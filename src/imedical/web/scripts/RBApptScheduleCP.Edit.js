// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


document.body.onload = Init;

function Init(){
	obj=document.getElementById('AllCp');
	if (obj) {
		obj.onclick=AllCpHndlr;
		//SB If no session then set AllCp to on and disable, otherwise lookup will show errors 
		var objSess=document.getElementById('SessId');
		if (objSess && objSess.value=="") {
			obj.checked=true;
			obj.disabled=true;
			AllCpHndlr()
		}
	}
}

function AllCpHndlr(){
	var allcpObj = document.getElementById("AllCp");
	var allcpHObj= document.getElementById("AllCpH");
	if(allcpObj && allcpHObj){
		if(allcpObj.checked) {
			allcpHObj.value="1";
		}
		else{
			allcpHObj.value="0";
		}
	}
}




