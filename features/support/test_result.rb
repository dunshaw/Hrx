class TestResult
	attr_accessor :start,:running,:function,:pos,:test_id,:task_id
	@@install = "未检测"
	def initialize task_id,test_id,pos
		@test_id = test_id
		@pos = pos
		@task_id = task_id
		#通过，未通过，未检测
		
		@start = "未检测"
		@running = "未检测"
		@function = "未检测"
	end

	def self.install=(pass)
		@@install = pass
	end

	def self.install
		@@install
	end


	def to_hash
		return {
			install:@@install,
			start:start,
			running:running,
			function:function
		}
	end

	def out_put
		begin
			res = self.to_hash
			temp_file = "#{Dir.pwd}/temp/#{task_id}_#{test_id}_#{pos}.tmp"
			i = 0
			while !File.exist?temp_file and i<3
				File.open(temp_file, "w") do |file|  
					Marshal.dump(res,file) 
				end
				i+=1	
			end
		rescue Exception => e
			puts e.to_s
			raise e
		end
	end
end