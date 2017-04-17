jQuery(document).ready(function($) {

  /* Cursor (pipe) flashing in the page Hello */
  setInterval(function() {
    $(".cursor").toggle()
  },600);

  /* Button clean input search */
  $(".btn-clean").click(function(){
    $('input[type="text"]').val("");
  });

  /* Button print page Resume */
  $("#btn-print").click(function() {
    window.print();
    return false;
  });

  /* Button click for read mode - Next Version
  */

});