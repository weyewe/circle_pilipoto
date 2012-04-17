jQuery(document).ready(function($) {

 		$.preloadCssImages();
	
		$(".dropdown ul").parent("li").addClass("parent");
		$(".dropdown li:first-child, .pricing_box li:first-child").addClass("first");
		$(".dropdown li:last-child, .pricing_box li:last-child, .widget_twitter .tweet_item:last-child").addClass("last");
		$(".dropdown li:only-child").removeClass("last").addClass("only");	
		$(".dropdown .current-menu-item, .dropdown .current-menu-ancestor").prev().addClass("current-prev");		

		$("ul.tabs").tabs("> .tabcontent", {
			tabs: 'li', 
			effect: 'fade'
		});	
		
	$(".recent_posts li:odd").addClass("odd");
	$(".popular_posts li:odd").addClass("odd");
	$(".widget-container li:even").addClass("even");
	
// cols
	$(".row .col:first-child").addClass("alpha");
	$(".row .col:last-child").addClass("omega"); 	


// toggle content
	$(".toggle_content").hide(); 
	
	$(".toggle").toggle(function(){
		$(this).addClass("active");
		}, function () {
		$(this).removeClass("active");
	});
	
	$(".toggle").click(function(){
		$(this).next(".toggle_content").slideToggle(300,'easeInQuad');
	});

// pricing
	$(".pricing_box li.price_col").css('width',$(".pricing_box ul").width() / $(".pricing_box li.price_col").size());
	$(".table-price tbody tr:odd").addClass("odd");

// buttons	
	if ($.browser.msie && $.browser.version=="7.0") {
		return false;
	} else {
		$(".button_link, .social_content img, .button_styled").hover(function(){
			$(this).stop().animate({"opacity": 0.80});
		},function(){
			$(this).stop().animate({"opacity": 1});
		});
	}
});