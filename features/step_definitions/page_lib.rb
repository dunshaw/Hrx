
module TAppium
	class Page
		attr_accessor :name,:container,:activity
		def initialize name,activity
			@name = name
			@container = Hash.new
			@activity = activity
		end

		def add_element name,element
			@container[name] = element
		end

		def get name
			@container[name]
		end
	end

	class Element
		attr_accessor :attributes
		def initialize attrs
			@attributes = Hash.new
			# @attributes[:class] = "android.widget.ImageButton"
			attrs.each_pair do|k,v|
				Element.define_componet(k)
				@attributes[k] = v
			end 
		end

		def self.define_componet name
			define_method(name){
                 return @attributes[name]
			}
		end
	end
end

class InputValue
	def self.get(exec)
		$execs[exec].nil? ? exec : $execs[exec]
	end
end	

class Logger
	def self.debug content
		# puts "user : #{$driver.caps[:user]}"
		File.open("#{Dir.pwd}/users/#{$driver.caps[:user]}/log/#{$driver.caps[:task_id]}.debug", "a") { |file|
			# file.puts "user : #{$driver.caps[:user]}"  
			file.puts content
		}
	end
end

# e = TAndroid::Element.new(id:1,text:"haha")
# puts e.xx


