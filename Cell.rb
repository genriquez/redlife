class Cell
	def initialize(food = 0)
		@adjacent_cells = []
		@food = food
		@cluster = nil
	end
	
	def food
		return @food
	end

	def adjacent_cells
		return @adjacent_cells
	end

	def add_adjacent(cell)
		@adjacent_cells = @adjacent_cells.push(cell)
	end
	
	def consume(quantity)
		@food -= quantity
	end
	
	def enter(cluster)
		if @cluster == nil
			@cluster = cluster
		else
			@cluster.merge(cluster)
		end
	end
	
	def leave(cluster)
		@cluster = nil unless @cluster != cluster
	end
	
	def cluster
		return @cluster
	end
	
	def random_adjacent_cell(prefer_food = false)
		selected_cells = []
		@adjacent_cells.collect do |cell|
			if cell.food > 0 or not prefer_food
				selected_cells.push(cell)
			end
		end
		
		selected_cells = @adjacent_cells unless (selected_cells.size > 0)
		return selected_cells[rand(selected_cells.size)]
	end
end
