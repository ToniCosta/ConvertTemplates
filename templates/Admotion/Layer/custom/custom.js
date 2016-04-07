// Copyright (c) 2013 Admotion

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
	
	$(".closer").click(function () {
		doClose(true);
	});
}

/**
* This method is called after the ad's collapse.
**/
$(document).on('adm_close', function(){
	$('#Creativity').hide();
});

/**
* This method is called when the windows' size was changed.
**/
$(document).on('adm_resize', function(){
	
});
