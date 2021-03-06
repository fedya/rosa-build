class ProjectImport < ActiveRecord::Base
  belongs_to :project
  belongs_to :platform

  validates :name, uniqueness: { scope: :platform_id, case_sensitive: false }
  validates :name, :platform, :version, presence: true

  scope :by_name, ->(name) { where("#{table_name}.name ILIKE ?", name) }

  after_initialize ->(r) { r.file_mtime ||= Time.current - 10.years } # default
end
