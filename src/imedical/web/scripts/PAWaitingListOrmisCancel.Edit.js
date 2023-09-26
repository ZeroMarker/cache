//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. w 6.50
function ReasonLookup(str) {
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("READesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("WLRGDesc")
	if (obj) obj.value = lu[2]
}
function InitatorLookUp(str) {

 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("WLRGDesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("READesc")
	if (obj) obj.value = ""

}