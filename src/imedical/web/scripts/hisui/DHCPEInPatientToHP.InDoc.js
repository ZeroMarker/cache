
//名称	DHCPEInPatientToHP.InDoc.js
//功能  设置住院体检的住院医生、不允许使用体检录入的提交
//组件	DHCPEInPatientToHP.InDoc
//创建	2018.08.15
//创建人  xy


function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BSave");
	if (obj){ obj.onclick=BSave_click; }
	obj=document.getElementById("BDelete");
	if (obj){ obj.onclick=BDelete_click; }
	obj=document.getElementById("UserName");
	if (obj){ obj.onchange=UserName_change; }
	
}
function BSave_click()
{
	
	var obj,LocID="",UserID="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	UserID=getValueById("UserID");
	if (UserID==""){
		$.messager.alert("提示","请选择待设置人员");
		return false;
	}
	obj=document.getElementById("SaveClass");
	if (obj) encmeth=obj.value;
	var Ret=cspRunServerMethod(encmeth,LocID,UserID);
	window.location.reload();
}
function BDelete_click()
{
	var obj,LocID="",UserID="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	obj=document.getElementById("UserID");
	if (obj) UserID=obj.value;
	if (UserID==""){
		$.messager.alert("提示","请选择待删除数据");
		return false;
	}
	obj=document.getElementById("SaveClass");
	if (obj) encmeth=obj.value;
	var Ret=cspRunServerMethod(encmeth,LocID,UserID,"Y");
	window.location.reload();
}
function UserName_change()
{
	var obj=document.getElementById("UserID");
	if (obj) obj.value="";
}

function AfterUserName(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("UserName");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("UserID");
	if (obj) obj.value=Arr[2];
}


var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if(index==selectrow)
	{
		var iUserID=rowdata.TUserID;
		var iUserName=rowdata.TUserName;
		
	    setValueById("UserID",iUserID)
	    setValueById("UserName",iUserName)
	    
		
	}else
	{
		selectrow=-1;
		
	
	}


}


document.body.onload = BodyLoadHandler;

