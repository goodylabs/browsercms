module Cms
  module Behaviors
    module Searching
      def self.included(model_class)
        model_class.extend(MacroMethods)
      end
      module MacroMethods
        def searchable?
          !!@is_searchable
        end
        def is_searchable(options={})
          @is_searchable = true
          @searchable_columns = options[:searchable_columns] ? options[:searchable_columns].map(&:to_sym) : [:name]
          extend ClassMethods
        
          #This is in a method to allow classes to override it
          scope :search, lambda{|search_params|
            conditions = []
            if search_params.is_a?(Hash)
              searchable_columns.each do |c|
                c = c.to_s
                bools = {'true' => 1, 'false' => 0}
                unless search_params[c].blank?
                  operand = c == "name" ? "like" : "="
                  if c.include?('_date')
                    if c.include?('_date_lt')
                      operand = '<='
                      query = "#{table_name}.#{c.gsub('_date_lt', '')}"
                    elsif c.include?('_date_gt')
                      operand = '>='
                      query = "#{table_name}.#{c.gsub('_date_gt', '')}"
                    else
                      query = "date(#{table_name}.#{c.gsub('_date', '')})"
                    end
                  else
                    query = "#{table_name}.#{c}"
                  end
                  if conditions.empty?
                    conditions = ["#{query} #{operand} ?"]
                  else
                    conditions.first << " AND #{query} #{operand} ?"
                  end
                  if c == 'name'
                    conditions << "%#{search_params[c]}%"
                  elsif c.include?('id')
                    conditions << search_params[c].to_i
                  elsif bools.keys.include?(search_params[c])
                    conditions << bools[search_params[c]]
                  elsif c.include?('_date')
                    conditions << Time.parse(search_params[c]).strftime('%Y-%m-%d')
                  else
                    conditions << "#{search_params[c]}"
                  end
                end
              end
            else
              term = search_params
              unless term.blank?
                searchable_columns.each do |c|
                  if conditions.empty?
                    conditions = ["#{table_name}.#{c} like ?"]
                  else
                    conditions.first << "or #{table_name}.#{c} like ?"
                  end
                  conditions << "%#{term}%"
                end
              end
            end
            where(conditions)
          }
        end
      end
      module ClassMethods
        def searchable_columns
          @searchable_columns
        end
      end
    end
  end
end
