// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

/*
  Procedure for allowing multiple lists on the same page is to dynamically change the id of a
  form, its encapsulating DIV, its TABLE menu and TABLE list to be unique.  The unique id is obtained from 
  adding the document.forms.length property on to the end of their existing names.*/

	var df=document.forms;
	var ltbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
	if (ltbl) {ltbl.id=ltbl.id+df.length,ltbl.Name=ltbl.id;}
	var mtbl=document.getElementById("m"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
	if (mtbl) {mtbl.id=mtbl.id+df.length,mtbl.Name=mtbl.id;}
	var div=document.getElementById("d"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
	if (div) {div.id=div.id+df.length,div.Name=div.id;}
	df[df.length-1].id=df[df.length-1].id+df.length;
	df[df.length-1].name=df[df.length-1].name+df.length;
//End

function WardBodyOnloadHandler() {
	// ab 6.05.03 - colouring moved to PACWard.ListColours.js
	SetWardColours();
}

document.body.onload=WardBodyOnloadHandler;