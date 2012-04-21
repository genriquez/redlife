require("gosu")
require("./Game.rb")

class GameWindow < Gosu::Window
	def initialize(game)
		super 640, 480, false
		self.caption = "Gosu Tutorial Game"
		
		@game = game
		@cell_image = Gosu::Image.new(self, "media/cell.png", true)
		@counter = 0
	end
	
	def update
		@counter += 1
		
		if @counter % 2 == 0
			@game.cycle
		end
	end
	
	def draw
		cells = @game.cell_matrix
		
		cells.keys.each do |key|
			x, y = key
			cell = cells[key]
			@cell_image.draw(100 + x * 12, 100 + y * 12, 0, 1, 1, color_for_cell(cell))
		end
	end
	
	def color_for_cell(cell)
		color = Gosu::Color.new(0xff000000)
		clusters = cell.clusters
		
		if(clusters.size == 0)
			color.green = [cell.food * 20, 255].min
		else
			total_size = 0
			clusters.each do |cluster|
				total_size += cluster.size
			end
			color.red = 55 + [200, total_size*60].min
			color.green = 55
			color.blue = 55
		end

		return color
	end
end

Game.instance.start(20)
Cluster.new(Game.instance.cell_matrix[[1,1]], 3)


window = GameWindow.new(Game.instance)
window.show