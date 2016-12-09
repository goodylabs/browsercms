module Cms
  class TagsController < Cms::ContentBlockController
    def index
      load_blocks
    end

    def show
      redirect_to tags_path
    end

  end
end
