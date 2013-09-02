
class Fann
	def setProfile()
		#train PROFILE data
		inputs = [[0.0, 0.0, 0.0, 1.0],
 		[0.0, 0.0, 1.0, 0.0],
 		[0.0, 0.0, 1.0, 1.0],
 		[0.0, 1.0, 0.0, 0.0],
 		[0.0, 1.0, 0.0, 1.0],
 		[0.0, 1.0, 1.0, 0.0],
 		[0.0, 1.0, 1.0, 1.0],
 		[1.0, 0.0, 0.0, 0.0],
		[1.0, 0.0, 0.0, 1.0], 
		[1.0, 0.0, 1.0, 0.0],
		[1.0, 0.0, 1.0, 1.0],
		[1.0, 1.0, 0.0, 0.0],
		[1.0, 1.0, 0.0, 1.0],
		[1.0, 1.0, 1.0, 0.0]]

		outputs = [[0.0, 0.0, 1.0, 0.0],
 		[0.0, 0.0, 1.0, 1.0],
 		[0.0, 1.0, 0.0, 0.0],
 		[0.0, 1.0, 0.0, 1.0],
 		[0.0, 1.0, 1.0, 0.0],
 		[0.0, 1.0, 1.0, 1.0],
 		[1.0, 0.0, 0.0, 0.0],
 		[1.0, 0.0, 0.0, 1.0],
		[1.0, 0.0, 1.0, 0.0],
		[1.0, 0.0, 1.0, 1.0],
		[1.0, 1.0, 0.0, 0.0],
		[1.0, 1.0, 0.0, 1.0],
		[1.0, 1.0, 1.0, 0.0],
		[1.0, 1.0, 1.0, 1.0]]
		$profiletrain = RubyFann::TrainData.new(:inputs=>inputs, :desired_outputs=>outputs)
	end

	def setUser()
		#as long as it has data...so 2 or more items under user_raw (to train)
		if $userinput.any?
			$usertrain = RubyFann::TrainData.new(:inputs=>$userinput, :desired_outputs=>$useroutput)
		end
	end

	
	def createFann()
		$fann = RubyFann::Standard.new(:num_inputs=>4, :hidden_neurons=>[2, 8, 4, 3, 4], :num_outputs=>4)
		#inputs 4..outputs 4
	end

	def trainProfile()
		$fann.train_on_data($profiletrain, 1000, 10, 0.1) # 1000 max_epochs, 10 errors between reports and 0.1 desired MSE (mean-squared-error)
	end

	def trainUser()
		if $userinput.any?
			puts $userinput
		end
	end

	
	def runProcess()
		puts "Current: #{$current}"
		outputs = $fann.run([$current.to_f])
		return outputs
	end
	
	def updateStatus(k)
		#check user_data status		
		#puts "user (user_data): #{k}"
		#puts "count: #{$coll2.find(user:k).count()}"
		if $coll2.find(user:k).count() == 0
			#user not in user_data...insert new
			$coll2.insert({:user => k, :result=>'', :status=>'1', :datetime=>  Time.now.utc })	
			 puts 'user inserted'
		else
			#where user is X
			$coll2.update( { :user => k }, '$set' => { :status => '1' } )
			puts 'user updated'
		end
	end


	def updateUserData(k,result)
		$coll2.update( { :user => k }, '$set' => { :result => result } )
	end


	def updateStatusEnd(k)
       		$coll2.update( { :user => k }, '$set' => { :status => '0' } )
        end	

	def setupAllEntries(k)
		#where user is
		$allentries = [ ];
		$coll.find(:user=>k).each do |doc|
			doc.each do |k2, v2|
				if k2 == 'entry'
					$allentries.push(v2);
					#puts v2
				end
			end		
		end

		#puts allentries.inspect
		#count = $allentries.count
		#puts count
	end
	
	def setupUserInOutArray()
	
		$userinput = []
	        $useroutput = []	
		#create train array...will be passed into traindata
		$allentries.each_with_index do |item, index|
		
			if $allentries[index+1]
				#if current index can see existence of item in front..proceed
				
				#puts "#{$allentries[index]} = #{$allentries[index+1]}"
				#current index is input
				inval = $allentries[index]
				inval.split(",")
				inval = "#{inval[0]}.0, #{inval[1]}.0, #{inval[2]}.0, #{inval[3]}.0"
				$userinput.push(inval)
				
				#future index is output
				outval = $allentries[index+1]	
				outval.split(",")
            			outval = "#{outval[0]}.0, #{outval[1]}.0, #{outval[2]}.0, #{outval[3]}.0"
				$useroutput.push(outval)
				
				$current = outval
				#puts $current
			end
		end
		
		#user data input
		#puts $userinput.inspect
		#user data expected
		#puts $useroutput.inspect
	
	end

	def calcResult(output)
		result = [ ]
		output.each do |thing|
			item = thing.round(1) 
			if item > 1.0
				result.push(item)
			else
				if item >= 0.6
					item = 1.0
				else
					item = 0.0
				end
				result.push(item)
			end
		end
		#puts "Result: #{result}"		
		return result
	end

end





#setup FANN object
fann = Fann.new();

#fann.setupMongo()

#foreach user
$allusers.each do | k, v|
#puts k
#=begin
	fann.updateStatus(k)
	fann.setupAllEntries(k)
	fann.setupUserInOutArray()
	
	fann.setProfile()
	fann.setUser()
	fann.createFann()
	fann.trainProfile()
	fann.trainUser()

	output = fann.runProcess()

	result = fann.calcResult(output)
	puts "Result: #{result}"
	fann.updateUserData(k, result)
	fann.updateStatusEnd(k)
#=end
end
