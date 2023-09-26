// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//TRAK NOTES
//Use filename as a prefix to identify globals and functions

var tn_selected=false;
var tn_x;
var tn_y;
	
function tn_onmousedown(e) {
	event.cancelBubble;
	e=window.event;
	if ( (!tn_selected) && (e.button==1) ) {
		tn_pickup(e);
	}
}
function tn_onmouseup(e) {
		tn_selected=null;
}
function tn_pickup(e) {
	var eSrc=window.event.srcElement;
	for (;;) {
		if (eSrc.className=='tn') break;
		if (eSrc.tagName=='INPUT') break;
		if (eSrc.parentElement) eSrc=eSrc.parentElement;
	}
	if (eSrc.className=='tn') {
		window.event.cancelBubble;
		tn_selected=eSrc;
		tn_selected.style.zIndex=websys_putontop();
		tn_x = window.event.x - parseInt(tn_selected.style.left);
		tn_y = window.event.y - parseInt(tn_selected.style.top);
	}
}
function tn_onmousemove(e) {
	e=window.event;
	if (tn_selected && (e.button==1) ) {
		//allow some tolerance before move
		if (Math.abs(window.event.x - tn_x - parseInt(tn_selected.style.left))>3||
		Math.abs(window.event.y - tn_y - parseInt(tn_selected.style.top))>3) {
			tn_selected.style.left =  window.event.x - tn_x;
			tn_selected.style.top = window.event.y - tn_y;
		}
	} else {
		tn_selected=null;
	}
}
	
