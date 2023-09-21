
var directory_divPopup = {
	
	id : "directory_divPopup",
	
	open : function(html) {
		// 1. popup div
		var div = $("#"+this.id);
		if (div.length < 1) {
			div = $("<div id='"+this.id+"'></div>");
			
			div.css("position", "fixed");
			div.css("background", "#FFFFFF");
			div.css("border", "3px solid #666666");
			div.css("zIndex", 999);
			$("body").append(div);
		}
		div.html(html);
		div.css("left", (($(window).width() - div.width()) / 2) + "px");
		div.css("top", (($(window).height() - div.height()) / 2) + "px");
		
		// 2. modal mask
		var mask = $("#"+this.id + "_mask");
		if (mask.length < 1) {
			mask = $("<div id='"+this.id + "_mask'></div>");
			
			mask.css("position", "fixed");
			mask.css("background", "#666666");
			mask.css("border", "0px");
			mask.css("zIndex", 998);
			mask.css("opacity",  0.5);// standard
			mask.css("filter", "alpha(opacity=50)"); // ie 7, 8
			
			$("body").append(mask);
		}
		
		mask.css("left", "0px");
		mask.css("top", "0px");
		mask.css("width", "100%");
		mask.css("height", "100%");
	},
	close : function(){
		var div = $("#"+this.id);
		if (div.length > 0) {
			div.remove();
		}
		
		var mask = $("#"+this.id + "_mask");
		if (mask) {
			mask.remove();
		}
	}
};
