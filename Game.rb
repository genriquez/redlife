require("singleton.rb")
require("./Cluster.rb")
require("./Cell.rb")

class Cluster
	def state
		if alive?
			return "Size: #{@size}; Starving: #{@starving}"
		else
			return "DEAD \t\t"
		end
	end

	def current_cell
		return @current_cell
	end
end

class Cell
	def initialize(food = 0, index = "")
		@adjacent_cells = []
		@food = food
		@index = index
	end
	
	def state
		return "#{@index} - Food: #{@food}"
	end
end

class Game
	include Singleton
	
	def initialize(matrix_size = 5)
		@cell_matrix = Hash.new
		
		@clusters = []
		@cycle_new_clusters = []

		matrix_side = (1..matrix_size).to_a
		matrix_keys = matrix_side.product(matrix_side)
		
		matrix_keys.collect do |index|
			cell = Cell.new(100, index.join(":"))
			@cell_matrix[index] = cell
		end
		
		matrix_keys.collect do |index|
			x, y = index
			cell = @cell_matrix[index]
			
			[-1,0,1].product([-1,0,1]).collect do |displacement|
				dx, dy = displacement
				if (dx == 0 or dy == 0) and dx != dy
					adjacent_index = [x+dx,y+dy]
					if @cell_matrix.key?(adjacent_index)
						cell.add_adjacent(@cell_matrix[adjacent_index])
					end
				end
			end
		end
	end

	def register_cluster(cluster)
		@cycle_new_clusters.push(cluster)
	end
	
	def run
		Cluster.new(@cell_matrix[[1,1]], 3)

		loop_count = 100		
		while loop_count > 0 do
			loop_count -= 1
			
			puts "-"*100
			
			index = 0
			@clusters.each do |cluster|
				index += 1

				puts "Cluster #{index}:\t#{cluster.state} -\tCell: #{cluster.current_cell.state}"
				cluster.cycle
			end
			
			@clusters = @clusters.concat(@cycle_new_clusters)
			@cycle_new_clusters = []
		end
	end
end

Game.instance.run
