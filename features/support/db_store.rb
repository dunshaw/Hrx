# require "active_record"
# require 'cucumber'

# def rails_root
# 	tmp = nil
# 	real_path = Pathname.new(__FILE__).realpath
# 	while !tmp.to_s.include?"TEST_PERFECT"
#   	real_path = real_path.parent
#   	tmp = real_path.split.last
# 	end
# 	return real_path
# end
# ActiveRecord::Base.establish_connection :adapter => "sqlite3",:database => "#{rails_root}/db/development.sqlite3"

# class Parameter < ActiveRecord::Base
# end

# class SuiteCaseRecords < ActiveRecord::Base

# 	def result_to_s
# 		return "成功" if self.result == 1
# 		return "失败" if self.result == -1
# 	end

# 	def result_to_en
# 		return "success" if self.result == 1
# 		return "error" if self.result == -1
# 		return ""
# 	end
# end

# class DbService
# 	include Cucumber
# 	def initialize driver,cucumber
# 		@driver = driver
# 		@cucumber = cucumber
# 	end

# 	def parmater_value parmater_name
# 		pro_id = @driver.caps[:projectId].to_i
		
# 		device_name = @driver.caps[:userDevice]
		
# 		return get_parmater pro_id,device_name,parmater_name
# 	end

# 	def save_suite scenario
# 		if !$driver.caps[:suiteExId].nil?
# 			if !$driver.caps[:suiteExId].empty?
		
# 	    		if scenario.status==:passed then result = SCUCESS
# 	    							else result = FAIL
# 	    		end
# 	    		insert_record scenario.feature.short_name,$driver.caps[:userDevice],$driver.caps[:suiteExId],result 
# 			end
# 		end
# 	end

# 	private
	
#  	def insert_record(name,device,suiteid,value)
#  		record = SuiteCaseRecords.find_by("name=? and device=? and suiteid=?",name,device,suiteid)
#  		record.update_attributes(result: value)
# 	end

# 	def get_parmater pro_id,device_name,key
# 		key = key.encode("utf-8")
# 		parameter = Parameter.find_by("pro_id=? and device_id=?",pro_id,device_name)
# 		return key if parameter.nil?

# 		parmaters = JSON.parse(parameter.content.encode("utf-8"))
	
# 		index = parmaters.find_index{|item| item["name"].eql?key}
# 		return key if index.nil?
# 		 @cucumber.puts "\"#{key}\"=#{parmaters[index]["val"]}"
# 		return parmaters[index]["val"]
# 	end
# end












