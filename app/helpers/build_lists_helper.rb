module BuildListsHelper
  def build_list_status_color(status)
    if [BuildList::BUILD_PUBLISHED, BuildServer::SUCCESS].include? status
      return 'green'
    end
    if [BuildServer::BUILD_ERROR, BuildServer::PLATFORM_NOT_FOUND,
        BuildServer::PROJECT_NOT_FOUND,BuildServer::PROJECT_VERSION_NOT_FOUND, BuildList::FAILED_PUBLISH].include? status
      return 'red'
    end

    'nocolor'
  end

  def build_list_item_status_color(status)
    if BuildServer::SUCCESS == status
      return 'success'
    end
    if [BuildServer::DEPENDENCIES_ERROR, BuildServer::BUILD_ERROR, BuildList::Item::GIT_ERROR].include? status
      return 'error'
    end

    ''
  end

  def build_list_status(build_list)
    if [BuildList::BUILD_PUBLISHED, BuildServer::SUCCESS].include? build_list.status
      "success"
    elsif [BuildServer::BUILD_ERROR, BuildServer::PLATFORM_NOT_FOUND, BuildServer::PROJECT_NOT_FOUND, 
      BuildServer::PROJECT_VERSION_NOT_FOUND, BuildList::FAILED_PUBLISH].include? build_list.status
      "error"
    end
  end

end
