///DHCIPBillNotHandin.js

function BodyLoadHandler() {
	
	/*
	var obj=document.getElementById("Find");
	if(obj){
		obj.onclick=Find_OnClick;
	}
	*/
}

function getuserid(value){
	var userIdObj=document.getElementById("Userid");
	if(userIdObj){
		userIdObj.value=value.split("^")[1];
	}
}
document.body.onload = BodyLoadHandler;