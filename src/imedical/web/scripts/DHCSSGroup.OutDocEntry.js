var CheckMutually="OutDocEntryMTR^NewOutPatList"
function BodyLoadHandler() {
	
	var obj=document.getElementById("Save");
	if (obj) obj.onclick=SaveClickHandler;
	var obj=document.getElementById("OutDocEntryMTR");
	if (obj) obj.onclick=CheckBoxClickHandle;
	var obj=document.getElementById("NewOutPatList");
	if (obj) obj.onclick=CheckBoxClickHandle;
	InitShow();
}
///获取响应事件的对象
function GetEventElementObj(){
	var isIE=document.all ? true : false;  
	var obj = null;  
	if(isIE==true){  
		obj = document.elementFromPoint(event.clientX,event.clientY);  
	}else{  
		e = arguments.callee.caller.arguments[0] || window.event;   
		obj = document.elementFromPoint(e.clientX,e.clientY);  
	}
	return obj
}
function CheckBoxClickHandle(e){
	var Obj=GetEventElementObj()
	var CheckMutuallyArry=CheckMutually.split("^")
	for (var i=0;i<CheckMutuallyArry.length;i++)
	{
		if (Obj.name!=CheckMutuallyArry[i])
		{
			var ObjCheck=document.getElementById(CheckMutuallyArry[i]);
			if (ObjCheck){ObjCheck.checked=false}
		}
		
	}
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
		//var ObjCheck=document.getElementById(CheckMutuallyArry[i]);
		//if (ObjCheck){ObjCheck.checked=false}
	}
	//检验检查树权限设置
	/*var OutDocEntryMTR=tkMakeServerCall(trClass,trMethod,"OutDocEntryMTR",GroupID);
	if (OutDocEntryMTR==1){OutDocEntryMTR=true}else{OutDocEntryMTR=false}
	DHCC_SetElementData("OutDocEntryMTR",TreeMaintain);*/
	
}
function SaveClickHandler() {
	var SaveMethod=DHCC_GetElementData("SaveMethod");
	if (SaveMethod=="") { 
		alert("缺少后台调用元素");
		return;
	}
	//检验检查树权限设置
	//var NodeName="OutDocEntryMTR";
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
	
	//var OutDocEntryMTR=DHCC_GetElementData("OutDocEntryMTR");
	//cspRunServerMethod(SaveMethod,NodeName,GroupID,OutDocEntryMTR);
	
	alert("保存成功");
	
}

document.body.onload = BodyLoadHandler;;