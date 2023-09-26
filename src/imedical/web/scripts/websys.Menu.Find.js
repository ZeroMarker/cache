// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//Select from lookup
function SubMenuOfSelect(txt) {
	//clear other fields when select 
	var obj=document.getElementById('caption');
	if (obj) obj.value='';
	var obj=document.getElementById('name');
	if (obj) obj.value='';
}