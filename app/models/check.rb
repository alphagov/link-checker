class Check < ApplicationRecord
  RECHECK_THRESHOLD = 60.minutes.ago

  has_many :batch_checks
  has_many :batches, through: :batch_checks

  belongs_to :link

  scope :created_within, ->(within) { where("created_at > ?", Time.now - within) }
  scope :requires_checking, -> { where(started_at: nil).or(Check.where(completed_at: nil).where("created_at < ?", RECHECK_THRESHOLD)) }

  def self.fetch_all(links, within: 4.hours)
    existing_checks = Check
      .created_within(within)
      .where(link: links)

    new_checks = (links - existing_checks.map(&:link)).map do |link|
      Check.new(link: link)
    end

    import_result = Check.import(new_checks)

    existing_checks + new_checks.select { |check| import_result.ids.include?(check.id) }
  end

  def requires_checking?
    started_at.nil? || (completed_at.nil? && created_at < RECHECK_THRESHOLD)
  end

  def is_pending?
    completed_at.nil?
  end

  def has_errors?
    link_errors.any?
  end

  def has_warnings?
    link_warnings.any?
  end

  def is_ok?
    !is_pending? && !has_errors? && !has_warnings?
  end

  def completed?
    !is_pending?
  end

  def status
    return :pending if is_pending?
    return :broken if has_errors?
    return :caution if has_warnings?
    :ok
  end

  def combined_errors
    if link.monitor_links.any?
      combine_link_history
    else
      link_errors
    end
  end

private

  def build_error_message(error)
    error_history = link.monitor_links.first.link_errors.select { |link_error| link_error['message'] == error }

    if error_history.any?
      "#{error_history[0]['message']} since #{error_history[0]['started_at']}"
    else
      error
    end
  end

  def combine_link_history
    link_errors.reduce([]) do |array, error|
      array << build_error_message(error)

      array
    end
  end
end
