//add by loo on 2010-4-26
//屏蔽Backspace退格键

	// For IE 
	if (typeof window.event != 'undefined')
	{ 
		document.onkeydown = function(){ 
			var type = event.srcElement.type; 
			var code = event.keyCode; 
			return ((code != 8) ||
				(type == 'text') || 
				(type == 'textarea')||
				(type == 'password'))
		} 
	}
	else
	{ // FireFox/Others 
		document.onkeypress = function(e) { 
			var type = e.target.type; 
			var code = e.keyCode; 
			return ((code != 8) || 
				(type == 'text') || 
				(type == 'textarea') || 
				(type == 'password'))
		}
	}