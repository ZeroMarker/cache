

//名称	DHCPEAdmRecordList.js
//组件  DHCPEAdmRecordList
//功能	个人修改日志
//创建	2018.09.014
//创建人  xy

function BodyLoadHandler() {
	var Info=GetValue("BaseInfo",1);
	var Arr=Info.split("^");
	SetValue("Name",Arr[0],1);
	SetValue("Sex",Arr[1],1);
	SetValue("Dob",Arr[2],1);
	SetValue("IDCard",Arr[3],1);
	var AdmId=getValueById("AdmId");
	var RemarkInfo=tkMakeServerCall("web.DHCPE.AdmRecordManager","GetAdmRecordReMarkInfo",AdmId);
	 setValueById("ReMark",RemarkInfo)
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