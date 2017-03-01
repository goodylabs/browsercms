module Cms
  # Captures values for the search form.
  class SearchFilter
    include ::ActiveModel::Model
    include ::ActiveModel::Serialization

    attr_accessor :model_class, :term, :responsible_person_email, :name, :filled, :job_type_id, :first_name, :surname, :nominator_last_name, :email, :university_id, :created_at_date, :confirmed_at_date, :hire_id, :origin_id, :created_at_date_gt, :created_at_date_lt

    def self.build(params_hash, model_class)
      model = self.new(params_hash)
      model.model_class = model_class
      model
    end

    def path
      model_class
    end

    def attributes
      { 'name' => nil, 'responsible_person_email' => nil, 'filled' => nil, 'job_type_id' => nil, 'first_name' => nil, 'surname' => nil, 'nominator_last_name' => nil, 'email' => nil, 'university_id' => nil, 'created_at_date' => nil, 'confirmed_at_date' => nil, 'hire_id' => nil , 'origin_id' => nil, 'created_at_date_gt' => nil, 'created_at_date_lt' => nil}
    end

  end
end