
var directory_divPopup = {
	
	id : "directory_divPopup",
	
	open : function(html) {
		// 1. popup div
		var div = document.getElementById(this.id);
		if (!div) {
			div = document.createElement("div");
			div.id = this.id;
			
			div.style.position = "fixed";
			div.style.background = "#FFFFFF";
			div.style.border = "3px solid #666666";
			div.style.zIndex = 999;
			
			document.body.appendChild(div);
		}
		
		div.innerHTML = html; // set html
		
		div.style.left = ((document.documentElement.clientWidth - div.offsetWidth) / 2) + "px";
		div.style.top = ((document.documentElement.clientHeight - div.offsetHeight) / 2) + "px";
		
		// 2. modal mask
		var mask = document.getElementById(this.id + "_mask");
		if (!mask) {
			mask = document.createElement("div");
			mask.id = this.id + "_mask";
			
			mask.style.position = "fixed";
			mask.style.background = "#666666";
			mask.style.border = "0px";
			mask.style.zIndex = div.style.zIndex - 1;
			mask.style.opacity = 0.5; // standard
			mask.style.filter = "alpha(opacity=50)"; // ie 7, 8
			
			document.body.appendChild(mask);
		}
		
		mask.style.left = "0px";
		mask.style.top = "0px";
		mask.style.width = "100%";
		mask.style.height = "100%";
	},
	close : function(){
		var div = document.getElementById(this.id);
		if (div) {
			document.body.removeChild(div);
		}
		
		var mask = document.getElementById(this.id + "_mask");
		if (mask) {
			document.body.removeChild(mask);
		}
	}
};
