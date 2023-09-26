// Copyright (c) 2006 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 25.10.06 

function BodyLoadHandler(e) {
	
	var obj=document.getElementById("Code");
	if (obj) obj.maxLength=10;
	

}

document.body.onload = BodyLoadHandler;
