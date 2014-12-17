'use strict'

fs = require 'fs'
_  = require 'underscore'
json2csv = require 'json2csv'

#####################################
##  group by each catego and summary what the top of the catego
#####################################
result_final = JSON.parse fs.readFileSync __dirname+"/collection_all.json", "utf8"

fff = _.flatten (_.pluck result_final,'like' )
ggg = _.each fff, (num) -> num.val=1

from_catego_count = JSON.parse fs.readFileSync __dirname+"/catego_count.json", "utf8"
# i_want_to_know = []

index_stop = 21
for name,index in from_catego_count
	
	if index is index_stop then break
	# i_want_to_know.push name.name

	name = from_catego_count[index]

	another = _.groupBy(ggg, 'catego')
	# console.log another["Games/Toys"]
	another_catego = _(another[name.name]).reduce (mem,d)->
		mem[d.name] = (mem[d.name] || 0) + d.val
		return mem
	, {}

	another_final = _(another_catego).map (v,k)->
		name:k
		total:v

	## sorting 
	another_final_sort = _.sortBy another_final, (k)->
		return -k.total


	# console.log another_final_sort

	another_ = JSON.stringify another_final_sort,null,'\t'

	if /\//.test(name.name) 
		wow = name.name.split /\//gi 
		name = ''
		for i in wow
			name += i + '_'
	else 
		name = name.name

	# console.log name

	fs.writeFile name+'.json', another_ , (err)->
		if err
			console.log err

	json2csv {data: another_final_sort, fields: ['name','total']}, (err, csv) ->
		if (err) 
			console.log err
		fs.writeFile name+'.csv', csv, (err) ->
			if (err) 
				throw err