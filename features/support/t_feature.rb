require_relative 'progress.rb'
class FeatureManager
	attr_accessor :tfeatures,:finished_features
	def initialize task_id
		@tfeatures = []
		@finished_features = []
		path =  Pathname.new(__FILE__).realpath.parent.parent
		Find.find(path.to_s) do |f|
			if File.file?(f) and f.include?(".feature")
				@tfeatures<< TFeature.new(File.basename(f,".*"),task_id)		
			end 
		end
	end

	def total
		tfeatures.size + finished_features.size
	end

	def current_feature_index
		finished_features.size + 1
	end

	def current_feature
		tfeatures.first
	end

	def unfinished_empty?
		@tfeatures.empty?
	end

	def shift_feature 
		finished_features<<(@tfeatures.shift)	
	end

	def find_feature feature_name
		@tfeatures.find{|feature| feature.name.eql?feature_name}
	end

end


class TElement
	attr_accessor :name,:pass
	def initialize name
		@name = name
		@pass = false
	end

	def pass?
		@pass
	end
end

class TFeature < TElement
	attr_accessor :steps,:pass,:finished_steps,:task_id,:ready
	include Progress
	# CACHE = MemCache.new 'localhost:11211'
	def initialize feature_name,task_id
		super(feature_name)
		@steps = []
		@finished_steps = []
		@task_id = task_id
		@ready = false
	end

	def push_step(step_name)
		@steps << TStep.new(step_name)
	end

	def total
		steps.size + finished_steps.size
	end

	def current_step_index
		finished_steps.size + 1
	end

	def shift_step
		@finished_steps<<@steps.shift
	end

	def pass?
		return false unless steps.empty?
		finished_steps.each do|step|
			# log("#{step.name}:#{step.pass?}")
			return false unless step.pass?
		end
		return true
	end


	def empty?
		@steps.empty?
	end
end

class TStep < TElement
	def initialize step_name
		super(step_name)
	end
end