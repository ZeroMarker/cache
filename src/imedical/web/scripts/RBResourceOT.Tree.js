// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var obj=document.getElementById("ExpandAll");
if(obj) obj.onclick=expandAll;
var obj=document.getElementById("CollapseAll");
if(obj) obj.onclick=collapseAll;

collapseAll();


//This function expands all the trees
function expandAll() {
	var arrLookUps=document.getElementsByTagName("IMG");
	if(arrLookUps){
		for (var i=0; i<arrLookUps.length; i++) {
			if(arrLookUps[i].src.indexOf("plus.gif") != -1){
				//alert(arrLookUps[i].src);
				arrLookUps[i].onclick();
			}
		}
	}
}

//This function collapses all the trees
function collapseAll() {
	var arrLookUps=document.getElementsByTagName("IMG");
	if(arrLookUps){
		for (var i=0; i<arrLookUps.length; i++) {
			if(arrLookUps[i].src.indexOf("minus.gif") != -1){
				//alert(arrLookUps[i].src);
				arrLookUps[i].onclick();
			}
		}
	}
}
