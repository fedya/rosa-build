class ProjectToRepository < ActiveRecord::Base
  AUTOSTART_OPTIONS = %w(auto_publish user_id enabled)

  belongs_to :project
  belongs_to :repository

  delegate :path, to: :project

  scope :autostart_enabled, lambda { where("autostart_options -> 'enabled' = 'true'")  }

  after_destroy lambda { project.destroy_project_from_repository(repository) }, unless: lambda {Thread.current[:skip]}

  validate :one_project_in_platform_repositories, on: :create

  serialize :autostart_options, ActiveRecord::Coders::Hstore
  AUTOSTART_OPTIONS.each do |field|
    store_accessor :autostart_options, field
  end

  protected

  def one_project_in_platform_repositories
    errors.add(:base, I18n.t('activerecord.errors.project_to_repository.project')) if Project.joins(repositories: :platform).
                                                                 where('platforms.id = ?', repository.platform_id).by_name(project.name).exists?
  end
end
