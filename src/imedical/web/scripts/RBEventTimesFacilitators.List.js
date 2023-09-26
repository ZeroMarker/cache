// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function FACLookUpSelect(str) {
	var lu = str.split("^");
	//alert(str);
	var obj=document.getElementById('CPFId');
	if (obj) obj.value=lu[1];
	//alert(obj.value);
}