
//名称	DHCPEInPatientToHP.RecLoc.js
//功能  设置住院体检会诊费对应的接受科室
//组件	DHCPEInPatientToHP.RecLoc	
//创建	2018.08.15
//创建人  xy

function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BSaveGenConUser");
	if (obj){ obj.onclick=BSaveGenConUser_click; }
	
	obj=document.getElementById("BSaveRecLoc");
	if (obj){ obj.onclick=BSaveRecLoc_click; }

	obj=document.getElementById("GenConUser");
	if (obj){ obj.onchange=GenConUser_change; }
	
	obj=document.getElementById("RecLocDesc");
	if (obj){obj.onchange=RecLocDesc_change;}
	
	obj=document.getElementById("DefaultDoc");
	if (obj){obj.onchange=DefaultDoc_change;}
	
}
function BSaveGenConUser_click()
{
	
	var obj,LocID="",UserID="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	obj=document.getElementById("GenConUserID");
	if (obj) UserID=obj.value;
	obj=document.getElementById("GenConUserClass");
	if (obj) encmeth=obj.value;
	var Ret=cspRunServerMethod(encmeth,LocID,UserID);
	
}
function BSaveRecLoc_click()
{
	var obj,StationID="",LocID="",RecLocID="",encmeth="",DefaultDocID = "";
	LocID=session['LOGON.CTLOCID'];
	obj=document.getElementById("StationID");
	if (obj) StationID=obj.value;
	
	if (StationID==""){
		$.messager.alert("提示","请选择站点，然后保存数据");
		return false;
	}
	obj=document.getElementById("RecLocID");
	if (obj) RecLocID=obj.value;
	obj=document.getElementById("RecLocClass");
	if (obj) encmeth=obj.value;
	obj=document.getElementById("DefaultDocID");
	if (obj) DefaultDocID=obj.value;
	//messageShow("","","",StationID+"^"+DefaultDocID+"^"+RecLocID)
	var Ret=cspRunServerMethod(encmeth,LocID,StationID,RecLocID+"^"+DefaultDocID);
	window.location.reload();
}
function GenConUser_change()
{
	var obj=document.getElementById("GenConUserID");
	if (obj) obj.value="";
}
function RecLocDesc_change()
{
	var obj=document.getElementById("RecLocID");
	if (obj) obj.value="";
}
function DefaultDoc_change()
{
	var obj=document.getElementById("DefaultDocID");
	if (obj) obj.value="";
	
}

function AfterGenConUser(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("GenConUser");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("GenConUserID");
	if (obj) obj.value=Arr[2];
}
function AfterRecLocDesc(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("RecLocDesc");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("RecLocID");
	if (obj) obj.value=Arr[2];
}

function DefaultDocSelect(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("DefaultDoc");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("DefaultDocID");
	if (obj) obj.value=Arr[2];
}


var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if(index==selectrow)
	{
		var iStationID=rowdata.StationID;
		var iSTDesc=rowdata.STDesc;
		var iRecLocID=rowdata.RecLocID;
		var iRecLocDesc=rowdata.RecLocDesc;
		var iDefaultDocID=rowdata.DefaultDocID;
		var iDefaultDoc=rowdata.DefaultDoc;
		
	    setValueById("StationID",iStationID)
	    setValueById("StationDesc",iSTDesc)
	    setValueById("RecLocID",iRecLocID)
	    setValueById("RecLocDesc",iRecLocDesc)
	    setValueById("DefaultDocID",iDefaultDocID)
	    setValueById("DefaultDoc",iDefaultDoc)
		
	}else
	{
		selectrow=-1;
		
	
	}


}


document.body.onload = BodyLoadHandler;

