---
---

# Using JS
# Cursor (pipe) flashing in the page Hello
# setInterval(function() {
#   $(".layout_hello__cursor").toggle()
# },600);

# Coffeescript
setInterval () ->
  $(".layout_hello__cursor").toggle()
,600

# var typeWriter;

# typeWriter = function(element) {
#   var textArray;
#   textArray = element.innerHTML.split('');
#   element.innerHTML = '';
#   textArray.forEach(function(letter, i) {
#     setTimeout((function() {
#       element.innerHTML += letter;
#     }), 75 * i);
#   });
# };

# const title = document.querySelector('.content_hello');
# typeWriter(title);

# var title, typeWriter;

# title = document.querySelector('.content_hello');


# /*
#  * Welcome to the new js2coffee 2.0, now
#  * rewritten to use the esprima parser. () => element.innerHTML += letter, 75 * i
#  * try it out!
#  */

# typeWriter = function(element) {
#   var textArray;
#   textArray = element.innerHTML.split('');
#   element.innerHTML = '';
#   textArray.forEach(function(letter, i) {
#     setTimeout((function() {
#       element.innerHTML += letter;
#     }), 75 * i);
#   });
# };

# typeWriter(title);
