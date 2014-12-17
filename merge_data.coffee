fs = require 'fs'
_  = require 'underscore'
# json2csv = require 'json2csv'

data = [
	'result_final',
	'data_1_3_4_result',
	'data_1_result_1',
	'data_2_result',
	'data_3_result_1',
	'data_4_result_1',
	'data_5_6_result',
	'data_5_6_result_1',
	'data_5_result_1',
	'data_6_result_1',
	'data_7_result']

collection = []
# console.log data.length
for name,index in data
	# console.log i
	# console.log j
	file = JSON.parse fs.readFileSync __dirname+'/'+name+".json", "utf8"
	collection.push(file)
	# if index is 1 then break

collection = _.flatten collection,true
collection = JSON.stringify collection,null,'\t'

fs.writeFile 'collection_all.json', collection
