class TError
	def self.write(error_path,err_msg)
		File.open(error_path, "a") { |file|  
			file.puts(err_msg)
		}
	end

	def self.out err_msg
		File.open("#{Dir.pwd}/users/#{$caps[:caps][:user]}/log/#{$caps[:caps][:task_id]}.error", "a") { |file|  
			file.puts(err_msg)
		}
	end
end