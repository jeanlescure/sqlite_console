class ConsoleController < ApplicationController
  def show
    #nothing to do here
  end
  
  def template
    render body: File.read("#{Rails.root}/app/views/console/#{params[:t]}.ejs")
  end
  
  def show_json
    get_all_data
    render json: JSON.generate(@all_data)
  end
  
  def get_all_data
    tables = ActiveRecord::Base.connection.tables
    
    @all_data = []
    
    tables.each do |table|
      data = {}
      data[:table] = table
      data[:columns] = ActiveRecord::Base.connection.columns(table).map { |c| c.name }
      data[:data] = ActiveRecord::Base.connection.select_all("SELECT * FROM #{table}").to_hash().map{ |v| v.values }
      
      @all_data << data
    end
  end
  
  def execute
    begin
      keys = []
      data = ActiveRecord::Base.connection.execute(params[:sentence].force_encoding("ASCII-8BIT")).map do |val| 
        retval = []
        val.each do |k,v|
          unless k.is_a? Numeric
            retval << v
            keys << k
            keys.uniq!
          end
        end
        
        retval
      end
      
      render json: Hash(:result => true, :keys => keys, :data => data).to_json
    rescue Exception => err
      render json: "{\"result\": false, \"message\": \"#{err.message.gsub(/"/,'\"').gsub(/[\r\n]/, "<br>")}\"}"
    end
  end
  
  def empty_db
    tables = ActiveRecord::Base.connection.tables
    
    tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
    
    render json: '{"result": true}'
  end
end
