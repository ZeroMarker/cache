document.body.onload = BodyLoadHandler;

window.returnValue=null;
function BodyLoadHandler(){
	var obj=document.getElementById("Update");
	if (obj) obj.onclick=UpdateClickHandler;
	var obj=document.getElementById("PatID");
	if (obj){obj.onkeydown=PatIDKeyDown};

}
function PatIDKeyDown(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==13){return websys_cancel();}
}
function UpdateClickHandler(){
	var encmeth="",PAID="",PatientID="";
	var obj=document.getElementById("PatientID");
	if (obj) PatientID=obj.value;
	var obj=document.getElementById("PatID");
	if (obj) PAID=obj.value;
	if (PAID==""){
		alert("请输入身份证号.");
		return;
	}
	var PAID=DHCWeb_Get18IdFromCardNo(PAID);
	if (PAID==""){return;}
	var myary=DHCWeb_GetInfoFromId(PAID);
	if (myary[0]!="1")  return;
	var obj=document.getElementById("UpdateEncrype");
	if (obj) encmeth=obj.value;
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,PatientID,PAID);
		if (ret=="0") {
			alert("更新成功");
			window.returnValue="0";
			window.close();
		}else{
			alert("更新失败");
		  window.returnValue=null;
		}
	}
	
}