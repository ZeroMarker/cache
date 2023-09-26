
//名称	DHCPEGAdmRecordList.js
//功能	团体修改日志
//组件	DHCPEGAdmRecordList	
//创建	2018.09.10
//创建人  xy
function BodyLoadHandler() {
	var Info=GetValue("BaseInfo",1);
	var Arr=Info.split("^");
	SetValue("GName",Arr[0],1);
	SetValue("GCode",Arr[1],1);
	SetValue("PreDate",Arr[2],1);
}

function GetObj(Name)
{
	var obj=document.getElementById(Name);
	return obj;	
}
function GetValue(Name,Type)
{
	var Value="";
	var obj=GetObj(Name);
	if (obj){
		if (Type=="2"){
			Value=obj.innerText;
		}else{
			Value=obj.value;
		}
	}
	return Value;
}
function SetValue(Name,Value,Type)
{
	var obj=GetObj(Name);
	if (obj){
		if (Type=="2"){
			obj.innerText=Value;
		}else{
			obj.value=Value;
		}
	}
}
document.body.onload = BodyLoadHandler;