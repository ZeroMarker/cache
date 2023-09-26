// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var lnkEvent=document.getElementById('EditEvent');
var objEvent=document.getElementById('Event');
if ((lnkEvent)&&(objEvent)) {
	lnkEvent.innerHTML += objEvent.value;
}


