// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function LocationLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('CTLOCDR')
	if (obj) obj.value = lu[3]
	alert(obj.value);
}
