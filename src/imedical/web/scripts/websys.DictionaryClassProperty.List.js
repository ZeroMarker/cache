// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objUpdate=document.getElementById("update1");
if (objUpdate) objUpdate.onclick=UpdateAll;

function UpdateAll() {
	// SA 19.8.02 - log 27640: Update call will leave user on current page, to
	// allow them to go to the next page without returning to the start of the 
	// workflow.
	document.fwebsys_DictionaryClassProperty_List.target="TRAK_hidden";
	return update1_click(); 
}








