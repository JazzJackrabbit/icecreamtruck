module Archivable
  extend ActiveSupport::Concern
  include AppErrors::General
  
  included do
    scope :published, ->(){where(archived: false)}
    before_update :check_archived_status
  end

  def published? 
    !self.archived?
  end

  def archived?
    self.archived
  end

  def archive!
    self.archived = true
    self.save!
  end

  def check_archived_status
    raise AppErrors::General::ArchivedRecordError if archived? & !archived_changed?
  end
end