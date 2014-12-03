'use strict'

fs = require 'fs'
_  = require 'underscore'
json2csv = require 'json2csv'

file = JSON.parse fs.readFileSync __dirname+"/result_final.json", "utf8"
# console.log file
# console.log file[0].like

# console.log (_.flatten (_.pluck file,'like' ))
fff = _.flatten (_.pluck file,'like' )
ggg = _.each fff, (num) -> num.val=1

# console.log ggg

summ_name = _(ggg).reduce (mem,d)->
	mem[d.name] = (mem[d.name] || 0) + d.val
	return mem
, {}
name_count = _(summ_name).map (v,k)->
	name:k
	total:v

summ_catego = _(ggg).reduce (mem,d)->
	mem[d.catego] = (mem[d.catego] || 0) + d.val
	return mem
, {}
catego_count = _(summ_catego).map (v,k)->
	name:k
	total:v

# console.log catego_count

# name_count = _.countBy(_.flatten(_.pluck(file, "like")), "name")
# catego_count = _.countBy(_.flatten(_.pluck(file, "like")), "catego")

name_count_sort = _.sortBy name_count, (k)->
	return -k.total
catego_count_sort = _.sortBy catego_count, (k)->
	return -k.total

# console.log ttt

name = JSON.stringify name_count_sort,null,'\t'
catego = JSON.stringify catego_count_sort,null,'\t'

fs.writeFile 'name_count.json', name
fs.writeFile 'catego_count.json', catego

json2csv {data: name_count_sort, fields: ['name','total']}, (err, csv) ->
	if (err) 
		console.log err
	fs.writeFile 'name_count.csv', csv, (err) ->
		if (err) 
			throw err

json2csv {data: catego_count_sort, fields: ['name','total']}, (err, csv) ->
	if (err) 
		console.log err
	fs.writeFile 'catego_count.csv', csv, (err) ->
		if (err) 
			throw err
