// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler() {

	var obj=document.getElementById('deleted');
	if (obj && obj.value!="") DisableAll();
	
	obj=document.getElementById('update');
	if (obj) obj.onclick=UpdateClickHandler;
}

function DisableAll(){
	
	var inputArr=document.getElementsByTagName("input");
	for(i=0; i<inputArr.length; i++){
		inputArr[i].disabled=true;
	}
	var imgArr=document.getElementsByTagName("img");
	for(i=0; i<imgArr.length; i++){
		imgArr[i].disabled=true;
	}
	
	var obj=document.getElementById('update');
	if(obj) {
		obj.disabled=true;
		obj.onclick=function () {return false;}
	}

	
}

function UpdateClickHandler() {
	var obj=document.getElementById('SCScore');
	if (obj && obj.value!="") {
		var decimal=(obj.value).split(".")[1];
		if(isNaN(obj.value) || (decimal!="" && decimal!=null && decimal.length>3)) {
			alert(t["INVALID_SCORE"]);
			return false;
		}
			
	}
	
	return update_click();
}

document.body.onload=BodyLoadHandler;