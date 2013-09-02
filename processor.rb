#PROCEDURAL
#require_relative 'ruby-fann'
require 'ruby-fann'
require 'rubygems'
require 'mongo'
include Mongo

#vars with $ are global...instance is @...globals accessible in loaded/required files too

class Processor
	def setupMongo()
		# fetch from mongo
		@client = MongoClient.new('localhost', 27017)
		@db     = @client['ann']

		#user data
		$coll2   = @db['user_data']

		#raw data
		$coll   = @db['user_raw']

		#lookup user data
			#@coll2.find.each { |doc|
		#}
	end

	def createUser()
		allusers = [ ];
		#read user_raw contents
		$coll.find.each { |doc|
        		doc.each do | k, v|
                		if k == 'user'
					#add item to array
                        		allusers.push(v) 
                        		#puts v
                		end
                		if k == 'entry'
                        		#puts v
                		end
        		end
		}

		#remove all duplicates
		#puts allusers.inspect
		#$allusers = allusers.uniq { |x|  }
		$allusers = allusers.uniq
		#puts 'run uniq'
		#puts $allusers.inspect
		#puts 'finish allusers'
	end

	def fannStart()
		load '/home/ubuntu/ANN/RUBY/fann.rb'
	end
end

processor = Processor.new();
processor.setupMongo()
processor.createUser()
processor.fannStart()
