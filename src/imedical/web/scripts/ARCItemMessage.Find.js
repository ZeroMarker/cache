// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function docLoadHandler() {
	var sAry=new Array();var n=0;var pAry=new Array();
	for (var i=0;i<document.all.length;i++) {
		if (document.all.item(i).tagName=="SCRIPT") {sAry[n]=document.all.item(i).src;n++}
	}
	for (var i=0;i<sAry.length;i++) {
		var pAry=sAry[i].split("/");
		//alert(pAry[pAry.length-2]);
	}
	alert(sAry.join("\n"));
}
document.body.onload=docLoadHandler;