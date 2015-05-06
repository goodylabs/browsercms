module Cms
  # Captures values for the search form.
  class SearchFilter
    include ::ActiveModel::Model
    include ::ActiveModel::Serialization

    attr_accessor :model_class, :term, :responsible_person_email, :name, :filled, :job_type_id

    def self.build(params_hash, model_class)
      model = self.new(params_hash)
      model.model_class = model_class
      model
    end

    def path
      model_class
    end

    def attributes
      { 'name' => nil, 'responsible_person_email' => nil, 'filled' => nil, 'job_type_id' => nil }
    end

  end
end