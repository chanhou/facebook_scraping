casper = require('casper').create()
utils = require 'utils'
fs = require 'fs'

# read file to search the FB ID
# stream = fs.open 'feng-new.csv', 'r'
stream = fs.open 'FB_ids_want_to_scrape.csv', 'r'
line = stream.readLine()
people = []

until stream.atEnd()
	line = stream.readLine()
	people.push line


######################
# scroll function that dynamic load content
######################
scrollUntilDie = (casper) ->
	console.log ''
	# casper.capture 'gg1.png'
	pageHeight = casper.evaluate ->
		document.body.scrollHeight
	# console.log 'first page height'+pageHeight
	tryAndScroll = ->
		# console.log 3322
		pageHeight_1 = casper.evaluate ->
			document.body.scrollHeight
		casper.waitFor ->
			casper.scrollToBottom()
			@wait 500, ->
				@echo 'i dont know why for 0.5 second.'
			true
		, ->
			pageHeight_2 = casper.evaluate ->
				document.body.scrollHeight
			console.log 'pageHeight_1:'+pageHeight_1
			console.log 'pageHeight_2:'+pageHeight_2
			# @capture 'whywhywhy.png'
			unless pageHeight_1 is pageHeight_2
				@wait 500, -> 
					# @capture 'whywhywhy.png'
					@echo 'Scrolling........'
					@echo "I've waited for 0.5 second."
					@echo " "
				tryAndScroll()
	tryAndScroll()

######################
# login facebook first
######################
casper.start "https://facebook.com", ->
	# console.log 123
	console.log 'start login'
	query =
		email: 'your account'
		pass: 'your password'
	@fill "form#login_form", query, true
	console.log 'login finished'
	# @capture('gg.png')

result = []
log = []

####################
# the main function of scraping each FB link
####################
casper.each people, (self,link)->

	####################
	# if the link no exist 
	####################
	# self.thenBypassIf ->
	# 	link is undefined
	# , 1

	####################
	# start scraping
	####################
	self.then ->
		console.log '*****************************'
		console.log ''
		console.log 'start scraping'

		# separate FB id and Database' internal id
		separate = link.split /\,/gi
		link = 'https://www.facebook.com/profile.php?id='+separate[1]+'&fref=ts'
		internal_id = separate[0]
		
		####################
		# check the link type 
		# since data type perhaps is user name or id 
		# then check the link type
		####################
		# type = true
		# if /\?id/.test(link) # https://www.facebook.com/profile.php?id=100000000&fref=ts
		# 	if /\&/.test(link) # https://www.facebook.com/profile.php?id=100000000&fref=ts
		# 		gg = link.split /.*id=(.*)\&.*/gi 
		# 	else # https://www.facebook.com/profile.php?id=100000000
		# 		gg = link.split /.*id=(.*)/gi 
		# 	id = gg[1]
		# 	link_1 = "https://www.facebook.com/profile.php?id="+id+"&sk=likes"
		# 	type = false
		# else
		# 	if /\?/.test(link) # https://www.facebook.com/minte.chen?fref=ts
		# 		gg = link.split /(.*)\?.*/gi
		# 		# console.log gg
		# 		id = link.split /com\/(.*)\?.*/gi
		# 		id = id[1]
		# 		link_1 = gg[1]+'/likes'
		# 	else 
		# 		if /.*facebook.*\/.*\/.*/.test(link) # https://www.facebook.com/minte.chen/about
		# 			gg = link.split /(.*)\/.*/gi
		# 			# console.log gg
		# 			id = link.split /com\/(.*)\/.*/gi
		# 			id = id[1]
		# 			link_1 = gg[1]+'/likes'
		# 		else # https://www.facebook.com/minte.chen
		# 			link_1 = link+'/likes'
		# 			id = link.split /com\/(.*)/gi
		# 			id = id[1]


		####################
		# check the link for fb_uid.csv
		# your link is just FB id dont exist name 
		####################
		link_1 = "https://www.facebook.com/profile.php?id="+separate[1]+"&sk=likes"


		console.log '****************************'
		console.log '--people--'
		# console.log 'type----> '+type
		console.log 'link----> '+link_1
		console.log '****************************'

		####################
		# the collection edit
		####################
		collection =
			Internal_ID: internal_id
			FB_id: separate[1]
			link: link_1

		# for without classify by facebook tag
		collection.like = [] 

		# collection id[1]
		# console.log ''
		# console.log collection.id

		# require('utils').dump collection

		self.thenOpen link_1, ->
			console.log ''
			console.log 'Like page is open....'
			# console.log 'scroll until die'
			# scrollUntilDie casper

		self.then ->
			console.log ''
			console.log 'record the url of each like'
			# console.log 'Scroll Finished !!!!!!!!!'
			# console.log ''

			# require('utils').dump(@getElementsInfo 'a._3c_')
			# url = @getElementsAttribute 'div#pagelet_timeline_medley_likes a._3c_','href' 
			# console.log '(((((((((((((((((((((((((((((((((((((((())))))))))))))))'

			# id = @getElementsInfo 'ul.uiList._4-sn._5k35._620._509-._4ki div.fsl.fwb.fcb a'
			# id11 = @getElementInfo 'ul.uiList._4-sn._5k35._620._509-._4ki div.fsl.fwb.fcb a'
			
			# console.log 'id'
			# require('utils').dump(@getElementInfo 'ul.uiList._4-sn._5k35._620._509-._4ki div.fsl.fwb.fcb a')
			# require('utils').dump id
			# console.log typeof id
			# console.log 'id11'
			# for abc in id
			# 	console.log abc.text
			

			# collection.referrals_urls = url
			# collection.like = {}
			# collection.referrals_id = id

			# console.log 'collection'
			# console.log collection
			# require('utils').dump collection
			
			# collection[collection.length-1].push url
			# ba.split /.*com\/.*\/(.*)/gi

		# self.thenBypassIf ->
		# 	@exists 'div#pagelet_timeline_medley_likes'
		# , 2

		####################
		# check if the page dont have any like item
		####################
		self.thenBypassUnless ->
			@exists 'div#pagelet_timeline_medley_likes'
		, 2

		self.then ->

			####################
			# get the attribute of the like url
			####################
			url = @getElementsAttribute 'div#pagelet_timeline_medley_likes a._3c_','href' 
			collection.referrals_urls = url
			# collection.like = {}

			# count = 0
			console.log ''
			console.log 'start scraping each like yyyyeeeeAAAAHHHHH!!!!!!!!'

			####################
			# check the type is true or false for fb_uid.csv
			# valid for classify the name with facebook tag
			####################
			link = url[0]
			# type = true	
			# https://www.facebook.com/profile.php?id=100000000&fref=ts
			if /\?id/.test(link) then type = no else type = yes
			console.log '^^^^^^^^^^^^^^^^^^^^^^^'+type
			console.log url[0]

			####################
			# for each link to scraping
			####################
			casper.each collection.referrals_urls, (self_2, link_2) ->
				# regular expression to extract the theme/title
				# use a switch to compare theme: 3A45: other
				# collection.referrals_id[count]
				self_2.then ->
					# console.log 'type::'+type

					####################
					# check the item is belong to which group
					####################
					if type # link_2 is https://www.facebook.com/minte.chen/likes_section_tv_shows
						name = link_2.split /.*\/(.*)/gi
						name = name[1]
					else  # link_2 is https://www.facebook.com/profile.php?id=100000000&sk=likes&collection_token=100000000%3A2409997254%3A106
						name = link_2.split /.*3A(.*)/gi
						switch name[1]
							when '106' then name = 'likes_section_movies'
							when '107' then name = 'likes_section_tv_shows'
							when '109' then name = 'likes_section_music'
							when '108' then name = 'likes_section_books'
							when '110' then name = 'likes_section_sports_teams'
							when '118' then name = 'likes_section_apps_and_games'
							when '45' then name = 'likes_other'
							when '73' then name = 'likes_restaurants'
							when '119' then name = 'likes_section_sports_athletes'
							# when '61' then name = 'likes_other' fb -- people
							else name = 'dontknow'

					console.log ''
					# console.log '########################'
					console.log 'Page >>>>>>>   '+name

					# switch name
					# 	when 'likes_section_movies' then collection.like.likes_section_movies = []
					# 	when 'likes_section_tv_shows' then collection.like.likes_section_tv_shows = []
					# 	when 'likes_section_music' then collection.like.likes_section_music = []
					# 	when 'likes_section_books' then collection.like.likes_section_books = []
					# 	when 'likes_section_sports_teams' then collection.like.likes_section_sports_teams = []
					# 	when 'likes_section_apps_and_games' then collection.like.likes_section_apps_and_games = []
					# 	when 'likes_other' then collection.like.likes_other = []
					# 	when 'likes_restaurants' then collection.like.likes_restaurants = []
					# 	when 'likes_section_sports_athletes' then collection.like.likes_section_sports_athletes = []
					# 	else collection.like.dontknow = []


					# count += 1 
					self_2.thenOpen link_2, ->
						console.log ''
						console.log 'start scrolling this page!!!!'
						scrollUntilDie casper
						# casper.capture link_2+'.png'
					self_2.then ->
						console.log ''
						console.log 'scrolling finished!!!'
						title = @getElementsInfo 'ul.uiList._4-sn._5k35._620._509-._4ki div.fsl.fwb.fcb a'
						# title = @getElementsInfo 'ul.uiList._4-sn._5k35._620._509-._4ki a'
						catego = @getElementsInfo 'ul.uiList._4-sn._5k35._620._509-._4ki div._5k4f'
						# require('utils').dump(@getElementsInfo 'div._5h60._30f#pagelet_timeline_medley_likes')
						# require('utils').dump( @getHTML() )
						# require('utils').dump(@getHTML 'ul.uiList._4-sn._5k35._620._509-._4ki')
						
						# casper.capture 'ttttttt.png'
						# console.log title 
						
						# for ddd in catego
						# 	console.log ddd.text

						for abc, i in title
							# console.log abc.text
							arrr = 
								name: abc.text
								catego: catego[i].text
							# console.log arrr

							# collection.like[name].push arrr
							collection.like.push arrr # for without classify by facebook tag
						
						# console.log '########################'
						# console.log ''
						# console.log 'collection:::'
						# require('utils').dump collection
	
		self.then ->
			result.push collection
			rrr = JSON.stringify result,null,'\t'
			fs.write 'result.json', rrr,'w'
			# require('utils').dump result


casper.then ->
	# @capture('gg3.png')
	console.log ''
	console.log '~~~The End~~~'
	# utils.dump result
	rrr = JSON.stringify result,null,'\t'
	fs.write 'result.json', rrr,'w'

casper.run()