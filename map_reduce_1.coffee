'use strict'

fs = require 'fs'
_  = require 'underscore'
json2csv = require 'json2csv'


#####################################
##  reduce catego and name
#####################################

result_final = JSON.parse fs.readFileSync __dirname+"/collection_all.json", "utf8"
# console.log result_final
# console.log result_final[0].like

# console.log (_.flatten (_.pluck result_final,'like' ))
fff = _.flatten (_.pluck result_final,'like' )
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
# name_count = _.countBy(_.flatten(_.pluck(result_final, "like")), "name")
# catego_count = _.countBy(_.flatten(_.pluck(result_final, "like")), "catego")
name_count_sort = _.sortBy name_count, (k)->
	return -k.total
catego_count_sort = _.sortBy catego_count, (k)->
	return -k.total

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


