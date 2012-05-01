class SourceFile < ActiveRecord::Base
  belongs_to :dataset

  has_attached_file :source
  validates_attachment_presence :source
  validates_presence_of :dataset_id
  validates_uniqueness_of :source_file_name, :scope => :dataset_id, :message => "should be unique"

  attr_accessible :source

  state_machine :status, :initial => :new do
    state :new
    state :importing
    state :imported
    state :replaced
    state :error
  end

  scope :recent, order('created_at DESC')

end
