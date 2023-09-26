// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	var obj1=document.getElementById("AdmCodingHiddenz1");
	var obj2=document.getElementById("AdmCoding1");
	if ((obj1)&&(obj2)) {
		//alert(obj1.name);
		//alert(obj1.value);
		obj2.value=obj1.value;
		//alert(obj2.value);
	}
	
	window.focus();

}

document.body.onload = BodyLoadHandler;
