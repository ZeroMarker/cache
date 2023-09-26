// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var lnkRule=document.getElementById('EditRule');
var objRule=document.getElementById('Rule');
if ((lnkRule)&&(objRule)) {
	/***don't use this way to allow sites to change the styling
	lnkEvent.style.fontSize='14pt';
	lnkEvent.style.fontWeight='bold';
	lnkEvent.style.color='green';
	****/
	//you could use this way where the site can change the websys.css to their own styles
	lnkRule.className = 'DSSRule';
	lnkRule.innerHTML += objRule.value;
}


