// Copyright (c) 2014 Admotion

/**
* Initializes the ad.
**/
$(document).on('adm_initializeAd', function(){
	setButtonHandlers();
})

function setButtonHandlers(){
	$('.adButton').click(function () {
			HTMLCreative.clickThrough();
	});
}

$(document).on('adm_resize', function(){
	reDraw();
});

function reDraw(){
	
}