require("singleton.rb")
require("./Cluster.rb")
require("./Cell.rb")

class Game
	include Singleton
	
	attr_accessor :cell_matrix
	attr_accessor :clusters
	
	def start(matrix_size = 5)
		@cell_matrix = Hash.new
		
		@clusters = []
		@cycle_new_clusters = []

		matrix_side = (1..matrix_size).to_a
		matrix_keys = matrix_side.product(matrix_side)
		
		matrix_keys.collect do |index|
			cell = Cell.new(10)
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
	
	def cycle
		@clusters.each do |cluster|
			cluster.cycle
		end

		@clusters = @clusters.concat(@cycle_new_clusters)
		@cycle_new_clusters = []
	end
end
