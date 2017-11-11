---
layout: null
---

jQuery(document).ready(function($) {


 if (navigator.vendor ==  "" || navigator.vendor == undefined) {
  function show_alert(){
    alert("This Browser is not printable with this page. If you print with Ctrl + P, errors will appear in the page structure. We recommend 'Google Chrome' or 'Safari'. \n\n(Este Navegador não é compátivel com impressão desta página. Caso imprima com Ctrl+P, aparecerá erros na estrutura da página. Recomendamos o 'Google Chrome' ou 'Safari'.)");
    return false;
  }
  function verifyButtonCtrl(oEvent){
    var oEvent = oEvent ? oEvent : window.event;
    var tecla = (oEvent.keyCode) ? oEvent.keyCode : oEvent.which;
    if(tecla == 17 || tecla == 44|| tecla == 106){
      show_alert();
    }
  }
  document.onkeypress = verifyButtonCtrl;
  document.onkeydown = verifyButtonCtrl;

  $("#btn-print").click(function() {
    show_alert();
   });
 } else {
  $("#btn-print").click(function() {
    window.print();
    return false;
   });
 }

/* Method 2: */
/* var isFirefox = /^((?!chrome|android).)*firefox/i.test(navigator.userAgent); */
/*if (isFirefox == true) {
  alert("incompatible");
} */

});