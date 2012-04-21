class Cluster
	def initialize(current_cell, size = 2, starving = 0)
		@current_cell = current_cell
		@starving = starving
		@size = size
		
		@current_cell.enter(self)
		Game.instance.register_cluster(self)
	end

	def cycle
		if alive?
			eat
			reproduce
			move
		end
	end
	
	def size
		return @size
	end
	
	def alive?
		return @size > 0
	end
	
	private
	
	def eat
		available_food = @current_cell.food
		if available_food > @size
			@current_cell.consume(@size)
			@starving = 0
		else
			now_starving = @size - available_food
			@current_cell.consume(available_food)
			
			deaths = [0, @starving + now_starving - @size].max
			@size -= deaths
			@starving = now_starving - deaths
		end
	end
	
	def reproduce
		if @current_cell.food > 0 and @size > 0
			food_size_ratio = [1, @current_cell.food / @size].max
			
			#For every entity there is a 2% chance of a single reproduction plus a bonus for food availability
			reproduction_rate =  (0.02 * @size + rand) + ((1 - 1.0/food_size_ratio) / 50)
			
			new_borns = [0, reproduction_rate].max.floor
			@size += new_borns
		end
		
		#For every entity there is a 1% chance of death
		natural_deaths = (rand + 0.01 * @size).floor
		@size -= natural_deaths
	end
	
	def move
		if alive?
			if rand < split_probability
				new_cell = @current_cell.random_adjacent_cell(true)
				Cluster.new(new_cell, (@size/2).floor, (@starving/2).floor)
				
				@size -= (@size/2).floor
				@starving -= (@starving/2).floor
			end
			
			if rand < move_probability
				@current_cell.leave(self)
				@current_cell = @current_cell.random_adjacent_cell(true)
				@current_cell.enter(self)
			end
		end
	end
	
	def split_probability
		adjacent_cells = @current_cell.adjacent_cells
		cell_count = adjacent_cells.size + 1
		
		average_nearby_food = @current_cell.food / cell_count
		adjacent_cells.each do |cell|
			average_nearby_food += cell.food / cell_count
		end
		
		food_size_ratio = average_nearby_food / @size
		
		# 100% chance when no food, 50% when just to survive one cycle, 17% when five times the cluster size
		return (1 - 1.0/@size) / (1 + food_size_ratio)
	end
	
	def move_probability
		food_size_ratio = @current_cell.food / @size
		
		# 100% chance when no food, 50% when just to survive one cycle, 17% when five times the cluster size
		return 1.0 / (1 + food_size_ratio)
	end
end
