// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	var obj=document.getElementById("BDATEConfirmed");
	if (obj) obj.onclick=ConfClickHandler;
	var obj=document.getElementById("BDATEUnconfirmed");
	if (obj) obj.onclick=UnConfClickHandler;
	
}

function ConfClickHandler() {
	var obj=document.getElementById("BDATEUnconfirmed");
	if (obj) obj.checked=false;
}

function UnConfClickHandler() {
	var obj=document.getElementById("BDATEConfirmed");
	if (obj) obj.checked=false;
}

function ColorPicker(color) {
	//alert(color);	
	var obj=document.getElementById("BDateColor");
	if (obj) obj.value=color;
	
}

function OpenColorPalette() {
	var url = "websys.colorpalette.csp?";		
	//alert("url = "+url);
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"Palette","top=70,left=440,width=150,height=350,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
	return false;
}

var ColorObj=document.getElementById("colorpalette")
if (ColorObj) ColorObj.onclick=OpenColorPalette;

document.body.onload=BodyLoadHandler;