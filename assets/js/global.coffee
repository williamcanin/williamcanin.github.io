---
---

# Coffeescript
$('.scrolltop__button').click ->
	$('html, body').animate {scrollTop:0}, 'slow'
	false


	# title = document.querySelector('.body__output__command')
	# content = document.querySelector('.content_hello')

###
# Welcome to the new js2coffee 2.0, now
# rewritten to use the esprima parser.
# try it out!
###

# typeWriter = (element1, element2) ->
#   textArray = element1.innerHTML.split('')
#   element1.innerHTML = ''
#   element2.style.display = 'none'
#   textArray.forEach (letter, i) ->
#     setTimeout (->
#       element2.style.display = 'block'
#       element1.innerHTML += letter
#       return
#     ), 75 * i
#     return
#   return

# typeWriter title, content

# JS
#	$('.scrolltop__button').click(function(){
# 		$('html, body').animate({scrollTop:0}, 'slow');
# 		return false;
# });


# function typeWriter(element1, element2) {
#   const textArray = element.innerHTML.split('');
#   element.innerHTML = '';
#   element2.style.display = "none";
#   textArray.forEach(function(letter, i){
#     setTimeout(function(){
#       element.innerHTML += letter;
#     }, 75 * i)
#   });
#   element2.style.display = "block";
# }

# const title = document.querySelector('.content_hello p');
# const content = document.querySelector('.content_hello');
# typeWriter(title, content);


# title = document.querySelector('.body__output__command')
# content_hello = document.querySelector('.content_hello')


# typeWriter = (element) ->
#   textArray = element.innerHTML.split('')
#   element.innerHTML = ''
#   content_hello.style.display = "none"
#   textArray.forEach (letter, i) ->
#     setTimeout (->
#       element.innerHTML += letter
#       return
#     ), 75 * i
#     return
# 	content_hello.style.display = "block"
#   return

# typeWriter title