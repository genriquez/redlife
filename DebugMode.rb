require("./Game.rb")

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
	def index=(value)
		@index = value
	end
	
	def state
		return "#{@index} - Food: #{@food}"
	end
end

class Game
	def run
		self.start(5)
		@cell_matrix.keys.each do |key|
			@cell_matrix[key].index = key.join(":")
		end
		
		
		Cluster.new(@cell_matrix[[1,1]], 3)

		loop_count = 100		
		while loop_count > 0 do
			loop_count -= 1
			index = 0

			self.cycle
			
			puts "-"*100
			@clusters.each do |cluster|
				index += 1

				puts "Cluster #{index}:\t#{cluster.state} -\tCell: #{cluster.current_cell.state}"
			end
			
		end
	end
end

Game.instance.run
