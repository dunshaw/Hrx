# This file provides setup and common functionality across all features.  It's
# included first before every test run, and the methods provided here can be 
# used in any of the step definitions used in a test.  This is a great place to
# put shared data like the location of your app, the capabilities you want to
# test with, and the setup of selenium.


require 'rspec/expectations'
require 'appium_lib'
require 'cucumber/ast'
require 'sqlite3'
require 'memcache'
require 'pathname'
require 'find'
require_relative 't_error.rb'
require_relative 't_feature.rb'
require_relative 'appiumworld.rb'
# Create a custom World class so we don't pollute `Object` with Appium methods




begin
    $caps = Appium.load_appium_txt file: File.expand_path('./', __FILE__), verbose: true
	
	Appium::Driver.new($caps)

	Appium.promote_appium_methods AppiumWorld

	# world = AppiumWorld.new(caps[:caps][:task_id])
	world = AppiumWorld.new
  	world.load_tfeature($caps[:caps][:task_id])
  	world

	World do
		TestResult.install = "通过"
		# world.init_progress
		world
	end	
rescue Exception => e
	TestResult.install = "未通过"
	error_path = "#{Dir.pwd}/users/#{$caps[:caps][:user]}/log/#{$caps[:caps][:task_id]}.error"
	TError.write(error_path,e.to_s)
	raise e
end



Before do|scenario|
	begin
		scenario.steps.to_a.each do|step|
			current_feature.push_step step.name
		end
		@test_action.initialize_test_result current_feature
		# tfeatures.first.ready_progress "正在准备运行 #w"
		sleep 20
		$driver.start_driver
		# @test_action.start "通过"
		# current_feature.ready_progress "正在准备运行 #p"
		# tfeatures.first.step_progress " #w"
	rescue Exception => e
		@test_action.start "未通过"
		# current_feature.ready_progress "正在准备运行 #e"	
		# TError.out("#{current_feature.name} : #{e.to_s}")
		raise e
	end
	
	
end
After do|scenario|
	@test_action.running "通过"
	begin
		if current_feature.pass?
			current_feature.end_feature_progress "sucess"
			@test_action.function "通过"
		else
			@test_action.function "未通过"
			current_feature.step_progress " #e"
			# current_feature.end_feature_progress "fail"
		# log("#{tfeatures.first.name}失败")
			# TError.out("#{current_feature.name} : #{scenario.exception.to_s}")
	
		
			begin
				raise "截图失败,请清理手机缓存" unless save_png(current_feature,0)
				if $caps[:caps][:test_type].eql?"function"
					raise "截图失败,请清理手机缓存" unless function_png(scenario)
				 # 	$driver.screenshot("#{Dir.pwd}/public/assets/logImage/#{scenario.__id__}.png")
					# embed("/assets/logImage/#{scenario.__id__}.png", "image/png", "SCREENSHOT")
				end
			rescue Exception => e
				# TError.out("#{e.to_s}") 	
			end
		end

		shift_feature	
		
		if unfinished_empty?
			
			unpass = finished_features.find{|f| !f.pass?}
			if unpass.nil?
				end_progress "sucess"
			else
				end_progress "fail"
			end

		end
	out_put_result
	rescue Exception => e
		raise e 	
	ensure 
		$driver.driver_quit
	end 
end

AfterStep do|scenario|
	
	begin
		
		raise "截图失败,请清理手机缓存" unless save_png(current_feature,1)
		current_feature.step_progress " #p"
		current_feature.steps.first.pass = true
	

		current_feature.shift_step
	

	rescue Exception => e
		@test_action.running "未通过"
		TError.out("AfterStep:#{e.to_s}")
		raise e
	end
	

	# unless tfeatures.first.empty?
	# 	tfeatures.first.step_progress " #w"
	# end
end







