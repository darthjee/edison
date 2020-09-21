# frozen_string_literal: true

module Edison
  class Exception < StandardError
    class LoginFailed  < Edison::Exception; end
    class Unauthorized < Edison::Exception; end
    class NotLogged    < Edison::Exception; end
  end
end
