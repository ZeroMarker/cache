// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function DocumentLoadHandler() {
	
	obj = document.getElementById("Update")
	if (obj) obj.onclick=UpdateClickHandler;
}

function UpdateClickHandler() {
	var msg = document.getElementById('msg')
	if (msg) msgVal=msg.value;
	var msg1 = document.getElementById('msg1')
	if (msg1) msgVal=msg.value;

	if (msg!="") {
		alert(msg)
	} else if (msg1!="") {
		var ret=confirm(msg1)
		if (ret) {
			window.opener.top.frames["TRAK_main"].frames["RBApptFind"].UpdateClickHandler("")
		}
	}

	if ((msg=="") && (msg1=="")) {
		window.opener.top.frames["TRAK_main"].frames["RBApptFind"].UpdateClickHandler("")
	}
}


		
document.body.onload = DocumentLoadHandler;

