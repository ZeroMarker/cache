// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//intercept the click event
try {
	var obj=document.getElementById('find1');
	if (obj) obj.onclick=find1_clickX;
} catch(e) { alert(e.number + ' ' + e.description) };
//process the click event and then call the standard code
function find1_clickX() {
  try {
	if (document.getElementById('langidX').value=='') {
		msg="\'" + t['Language'] + "\' " + t['XMISSING'] + "\r";
		alert(msg);
	} else {
		find1_click();
	}
  } catch(e) {};
}
