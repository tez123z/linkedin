module LinkedIn
  module Api

    # People APIs
    #
    #
    # @see https://developer.linkedin.com/docs/fields/basic-profile Profile Fields
    # @see http://developer.linkedin.com/documents/field-selectors Field Selectors
    # @see http://developer.linkedin.com/documents/accessing-out-network-profiles Accessing Out of Network Profiles
    module People

      # Retrieve a member's LinkedIn profile.
      #
      # Permissions: r_basicprofile, r_fullprofile
      #
      # @see https://developer.linkedin.com/docs/signin-with-linkedin#content-par_componenttabbedlist_resource_1_resourceparagraph_6
      # @macro person_path_options
      # @option options [string] :secure-urls if 'true' URLs in responses will be HTTPS
      # @return [LinkedIn::Mash]
      def profile(options={})
        path = "/me/?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))"
        simple_query(path, options)
      end

      def email
        simple_query("/emailAddress?q=members&projection=(elements*(handle~))")
      end

      # Retrieve a list of 1st degree connections for a user who has
      # granted access to his/her account
      #
      # Permissions: r_network
      #
      # @see http://developer.linkedin.com/documents/connections-api
      #
      # @macro person_path_options
      # @return [LinkedIn::Mash]
      def connections(options={})
        path = "#{person_path(options)}/connections"
        simple_query(path, options)
      end

      # Retrieve a list of the latest set of 1st degree connections for a
      # user
      #
      # Permissions: r_network
      #
      # @see http://developer.linkedin.com/documents/connections-api
      #
      # @param [String] modified_since timestamp indicating since when
      #   you want to retrieve new connections
      # @macro person_path_options
      # @return [LinkedIn::Mash]
      def new_connections(modified_since, options={})
        options.merge!('modified' => 'new', 'modified-since' => modified_since)
        path = "#{person_path(options)}/connections"
        simple_query(path, options)
      end

      # Retrieve the picture url
      # http://api.linkedin.com/v1/people/~/picture-urls::(original)
      #
      # Permissions: r_network
      #
      # @options [String] :id, the id of the person for whom you want the profile picture
      # @options [String] :picture_size, default: 'original'
      # @options [String] :secure, default: 'false', options: ['false','true']
      #
      # example for use in code: client.picture_urls(:id => 'id_of_connection')
      def picture_urls(options={})
        picture_size = options.delete(:picture_size) || 'original'
        path = "#{picture_urls_path(options)}::(#{picture_size})"
        simple_query(path, options)
      end
    end
  end
end
