# frozen_string_literal: true

module Magicka
  module Edison
    class Input < Magicka::Input
      with_locals :type
      with_attributes type: :text
    end
  end
end
