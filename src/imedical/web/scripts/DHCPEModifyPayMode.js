document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	
	var obj=GetObj("InvNo");
	//if (obj) obj.onchange=InvNo_Change;
	if (obj) obj.onkeydown=InvNo_KeyDown;
	var obj=GetObj("RInvNo");
	//if (obj) obj.onchange=RInvNo_Change;
	if (obj) obj.onkeydown=RInvNo_KeyDown;
	var obj=GetObj("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=GetObj("PayMode");
	if (obj) obj.onchange=PayMode_Change
	var obj=GetObj("OldPayMode")
	obj.multiple=false;   //多选属性
	obj.size=1;  //多选属性为false时下拉列表框
}
function BUpdate_Click()
{
	var Info=GetValue("OldPayMode");
	if (Info==""){
		alert(t["NoOldRecord"]);
		return false;
	}
	var PayMode=GetValue("PayModeDR");
	if (PayMode==""){
		alert(t["NoPayMode"]);
		return false;
	}
	var encmeth=GetValue("UpdateClass");
	var Info=cspRunServerMethod(encmeth,Info,PayMode);
	if (Info==0){
		//alert("OK");
		alert("更新成功");
		window.location.reload();
	}else{
		//alert(Info)
		alert("更新失败");
		}
}
function InvNo_Change()
{
	var InvNo=GetValue("InvNo");
	InvNoChangeApp(InvNo,"");
}
function InvNo_KeyDown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		InvNo_Change(e);
	}
}
function RInvNo_Change()
{
	var InvNo=GetValue("RInvNo");
	InvNoChangeApp(InvNo,"R");
}
function RInvNo_KeyDown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		RInvNo_Change(e);
	}
}
function InvNoChangeApp(InvNo,Type)
{
	if (InvNo=="") return false;
	SetValue("Name","");
	SetValue("Amount","");
	var obj=GetObj("OldPayMode");
	if (Type=="R"){
		SetValue("InvNo","");
	}else{
		SetValue("RInvNo","");
	}
	RemoveList(obj);
	var User=session['LOGON.USERID'];
	var encmeth=GetValue("GetInfoClass");
	var Info=cspRunServerMethod(encmeth,InvNo,Type,User);
	if ((Info=="NoData")||(Info=="NoRefData")||(Info=="HadReport")||(Info=="UserNotOne")){
		
		alert(t[Info]);
		return false;
	}else{
		var Arr=Info.split("^");
		SetValue("Name",Arr[0]);
		SetValue("Amount",Arr[1]);
		var PayModeInfo=Arr[2];
		var obj=GetObj("OldPayMode");
		//RemoveList(obj);
		var Char_1=String.fromCharCode(1);
		var Char_2=String.fromCharCode(2);
		var PayModeArr=PayModeInfo.split(Char_1);
		var i=PayModeArr.length;
		for (var j=0;j<i;j++){
			var OneInfo=PayModeArr[j];
			var OneArr=OneInfo.split(Char_2);
			AddListItem(obj,OneArr[0],OneArr[1])
		}
	}
}
function GetObj(ElementName)
{
	return document.getElementById(ElementName)
}
function GetValue(ElementName)
{
	var obj=GetObj(ElementName)
	if (obj){
		return obj.value;
	}else{
		return "";
	}
}
function SetValue(ElementName,value)
{
	var obj=GetObj(ElementName)
	if (obj){
		obj.value=value;
	}
}
function RemoveList(obj)
{
	for (var i=(obj.length-1); i>=0; i--) {
			obj.options[i]=null;
	}
}
function AddListItem(obj,value,display)
{
	obj.options[obj.options.length] = new Option(display,value);
}
function SetPayMode(value)
{
	if (value=="") return false;
	SetValue("PayModeDR",value.split("^")[1]);
}
function PayMode_Change()
{
	SetValue("PayModeDR","");
}