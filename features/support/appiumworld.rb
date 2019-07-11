require_relative 'test_result.rb'
require_relative 'progress.rb'
require_relative 't_feature.rb'
class AppiumWorld
	attr_accessor :tfeatures,:finished_features,:task_id,:test_action
	include Progress
	# CACHE = MemCache.new 'localhost:11211'

	def load_tfeature task_id
		@test_action = ActionFactory.make
		@fm = FeatureManager.new task_id
		@task_id = task_id
		
	end

	def log s
		# File.open("cucumber_log", "a") { |file| file.puts s }
	end

	def total
		@fm.total
	end

	def current_feature_index
		@fm.current_feature_index
	end

	def current_feature
		@fm.current_feature
	end

	def finished_features
		@fm.finished_features
	end

	def unfinished_empty?
		@fm.unfinished_empty?
	end

	def save_png tfeature,sucess
		@test_action.save_png tfeature,sucess 		
	end

	def function_png scenario
		print_screen = false
		thread = Thread.new do
			$driver.screenshot("#{Dir.pwd}/public/assets/logImage/#{scenario.__id__}.png")
			embed("/assets/logImage/#{scenario.__id__}.png", "image/png", "SCREENSHOT")
			print_screen = true
		end 
		thread.join(15)
		Thread.kill(thread) if !thread.nil? and thread.alive?
		print_screen
	end

	def shift_feature 
		@fm.shift_feature	
	end

	def find_feature feature_name
		@fm.find_feature feature_name
	end

	def out_put_result
		# @test_action.test_result.out_put
	end
end

class ActionFactory
	def self.make
		return TestSuiteAction.new if $caps[:caps][:multiple].eql?"true"
		return TestCaseAction.new
	end
end

class TestCaseAction

	attr_accessor :test_result
	def initialize_test_result tfeature
		@test_result = TestResult.new($caps[:caps][:task_id],$caps[:caps][:test_id],0)
	end

	def save_png tfeature,sucess
		# if $caps[:caps][:test_type].eql?"adaptation"
		# 	png = "#{Dir.pwd}/public/assets/adapateImage/#{$caps[:caps][:task_id]}_#{$caps[:caps][:test_id]}_#{tfeature.current_step_index}_#{sucess}.png"
		# 	$driver.screenshot png
		# end
		print_screen = false
		thread = Thread.new do
			if $caps[:caps][:test_type].eql?"adaptation"
				png = "#{Dir.pwd}/public/assets/adapateImage/#{$caps[:caps][:task_id]}_#{$caps[:caps][:test_id]}_#{tfeature.current_step_index}_#{sucess}.png"
				$driver.screenshot png
			end
			print_screen = true
		end
		thread.join(15)
		Thread.kill(thread) if !thread.nil? and thread.alive?
		print_screen
	end

	def start pass
		@test_result.start = pass
	end

	def running pass
		@test_result.running = pass
	end

	def function pass
		@test_result.function = pass
	end
end

class TestSuiteAction
	attr_accessor :test_result
	def initialize_test_result tfeature
		test_case_pos = tfeature.name.split("-")[0]
		@test_result = TestResult.new($caps[:caps][:task_id],$caps[:caps][:test_id],test_case_pos)
	end

	def save_png tfeature,sucess
		print_screen = false
		thread = Thread.new do
			if $caps[:caps][:test_type].eql?"adaptation"
				test_case_pos = tfeature.name.split("-")[0]
				png = "#{Dir.pwd}/public/assets/adapateImage/#{$caps[:caps][:task_id]}_#{$caps[:caps][:test_id]}_#{test_case_pos}_#{tfeature.current_step_index}_#{sucess}.png"
				$driver.screenshot png
			end
			print_screen = true
		end
		thread.join(15)
		Thread.kill(thread) if !thread.nil? and thread.alive?
		print_screen
	end

	def start pass
		@test_result.start = pass
	end

	def running pass
		@test_result.running = pass
	end

	def function pass
		@test_result.function = pass
	end
end



