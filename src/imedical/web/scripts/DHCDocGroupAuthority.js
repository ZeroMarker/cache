var CheckMutually="DelHospARCOSAuthority"
function BodyLoadHandler() {
	var obj=document.getElementById("Save");
	if (obj) obj.onclick=SaveClickHandler;
	InitShow();
}
function SaveClickHandler(){
	var SaveMethod=DHCC_GetElementData("SaveMethod");
	if (SaveMethod=="") { 
		alert("缺少后台调用元素");
		return;
	}
	var GroupID=DHCC_GetElementData("GroupRowId");
	var CheckMutuallyArry=CheckMutually.split("^")
	for (var i=0;i<CheckMutuallyArry.length;i++){
		var ObjCheck=document.getElementById(CheckMutuallyArry[i]);
		var NodeName=CheckMutuallyArry[i];
		var value=0;
		if (ObjCheck.checked){
			value=1;
		}
		cspRunServerMethod(SaveMethod,NodeName,GroupID,value);
	}
	alert("保存成功");
}
function InitShow() {
	var GroupID=DHCC_GetElementData("GroupRowId");
	var trClass="web.DHCDocConfig";
	var trMethod="GetConfigNode1"
	var CheckMutuallyArry=CheckMutually.split("^")
	for (var i=0;i<CheckMutuallyArry.length;i++)
	{
		var value=tkMakeServerCall(trClass,trMethod,CheckMutuallyArry[i],GroupID);
		if (value==1){value=true}else{value=false}
		DHCC_SetElementData(CheckMutuallyArry[i],value)
	}
}
document.body.onload = BodyLoadHandler;