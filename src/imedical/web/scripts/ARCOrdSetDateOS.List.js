// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// Created 18/5/2005 JPD

function SetSelectHandler(){
	var HiddenAdd=document.getElementById("HiddenAdd");
	var OrderSet=document.getElementById("OrderSet");
	var PARREF=document.getElementById("PARREF");
	var url="arcordsetdateos.add.csp?OrderSet="+OrderSet.value+"&PARREF="+PARREF.value;
	window.location=url;
	return; 
}