// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function OUTCDescLookUpHandler(str){
	var lu=str.split("^")
	var objLast =document.getElementById("LastOutcomeDisch");
	if (lu[2]=="DC") {
		objLast.value="Y"
	} else {
		objLast.value=""
	}
}