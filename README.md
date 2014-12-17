facebook_scraping
=================

Facebook scraping tools for different users and id

Preinstall: either using brew(mac) or npm to install

	1. install phantomjs

	2. install casperjs

Usage:

	casperjs facebook_scraping.coffee

Feed In Data type:

	'FB_id,database_internal_id'

Map Reduce for the result
=========================

Map reduce for counting the category or name appear in the data.

Preinstall: 
	
	1. install nodejs
	
	2. install coffee

Usage:
	
	coffee map_reduce.coffee

Merge data from several file
============================

Since we allocate other account to scarp the data, then we have several files.

This file intend to merge data in a file.

Preinstall:

	1. install nodejs
	
	2. install coffee

Usage:

	coffee merge_data.coffee
