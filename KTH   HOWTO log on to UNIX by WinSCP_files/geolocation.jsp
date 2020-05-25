       
$(document).ready(function() {
(function () {
// display based on location
$(".geolocation.country.SE").css('display', 'block');
$(".geolocation.region.Other").css('display', 'block'); 
var country = null;
var region = null;
if (country) {
if (country.length > 2) {
return;
}
$(".geolocation.country.").css('display', 'block');
}
if (region) {
$(".geolocation.region.").css('display', 'block');
}
})();
}); 
