
class Cache
	def self.object
		@mem = MemCache.new 'localhost:11211' if @mem.nil?
		return @mem
	end
end


module Progress
	def init_progress
		# task = Cache.object.get(task_id)
		# task[:progress] << {
		# 	feature: @fm.current_feature.name,
		# 	step:[],
		# 	# total:total,
		# 	current:0,
		# 	finished:0,
		# 	show:[],
		# 	percent:"0",
		# 	status:"doing"
		# }
		# Cache.object.replace(task_id,task)
	end

	def end_progress msg
		# task = Cache.object.get(task_id)
		# task[:status] = msg
		# Cache.object.replace(task_id,task)
	end

	def ready_progress msg
		# task = Cache.object.get(task_id)
		# task[:progress].last[:step]<< msg
		# task[:progress].last[:total] = total
		# task[:progress].last[:show]<< "0/#{total}"
		# @ready = true if msg.include?"#p"
		# Cache.object.replace(task_id,task)
	end

	def step_progress msg
		# if ready
		# 	task = Cache.object.get(task_id)
		# 	task[:progress].last[:step]<< "#{steps.first.name}#{msg}"
		# 	task[:progress].last[:current] = current_step_index
		# 	task[:progress].last[:finished] = finished_steps.size
		# 	task[:progress].last[:show] << "#{current_step_index}/#{total}"
		# 	task[:progress].last[:percent] = "#{((((current_step_index.to_f)/total.to_i)*100).round.to_f/100)*100}"
		# 	task[:progress].last[:status] = "doing"
		# 	Cache.object.replace(task_id,task)
		# end
	end

	def end_feature_progress msg
		# task = Cache.object.get(task_id)
		# task[:progress].last[:status] = msg
		# Cache.object.replace(task_id,task)
	end
	
end