$(document).ready(function(){
  
  /* init the cloud */
  // var framerate = 45,
  //     numberOfClouds = 6,
  //     numberOfTypeOfClouds = 3,
  //     cloudsWrapper = $('#clouds_wrapper'),
  //     wrapper = $('#clouds_wrapper .wrapper'),
  //     height = $('#content').height(),
  //     width = cloudsWrapper.width(),
  //     top, left,
  //     clouds = [],
  //     accelerations = [];
  // for(var i = 0; i < numberOfClouds; i++) {
  //   top = Math.random() * height;
  //   left = Math.random() * width - 100;
  //   var html = "<div id='cloud_" + i + "' class='cloud cloud" + Math.ceil(Math.random() * numberOfTypeOfClouds) + "' style='top:" + top + "px; left:" + left + "px'></div>";
  //   clouds.push(wrapper.append(html).children(':last')[0]);
  //   accelerations.push( Math.random() );
  // };
  // 
  // 
  // $('#clouds_wrapper .wrapper').fadeIn(3000, function() {
  //   setInterval(function(){
  //     for(var i = 0; i < numberOfClouds; i++ ) {
  //       var newLeft = (parseFloat($(clouds[i]).css('left')) + accelerations[i]);
  //       if(newLeft > width) newLeft = -50;
  //       $(clouds[i]).css({left:  newLeft + 'px' });
  //     };
  //   }, 1000/framerate);
  // } )
  // 
  
  /* Init Facebox */
  $('a[rel*=facebox]').facebox();
  
});