
var MESSCategCode;
function BodyLoadHandler() {
	var obj=document.getElementById("SelectAll")
	if (obj) {
		obj.onclick=SelectAllHandler;
		//var objCF=document.getElementById("AllowSendToAll")
		//if (objCF) {if (objCF.value!="Y") obj.disabled=true;}
	}
	var obj=document.getElementById("deleteUser")
	if (obj) obj.onclick=deleteUserHandler;

	var obj=document.getElementById("send")
	if (obj) obj.onclick=sendHandler;
	MESSCategCode="";
	var obj=document.getElementById("SelectGroup")
	if (obj) obj.disabled=true;
	obj=document.getElementById("SelectLocation")
	if (obj) obj.disabled=true;
}
function LookUpCateg(val)
{
	var strValue=val.split("^");
	var obj=document.getElementById("MESSCateg");
	if(obj){
		obj.value=strValue[2]
		obj=document.getElementById("MESSCategId");
		if(obj) obj.value=strValue[0];
		MESSCategCode=strValue[1];
		if(MESSCategCode=="G")
		{
			var obj=document.getElementById("SelectLocation")
			if (obj) obj.disabled=true;
			obj=document.getElementById("SelectGroup")
			if (obj) obj.disabled=false;
		}
		else
		{
			if(MESSCategCode=="L")
			{
				var obj=document.getElementById("SelectLocation")
				if (obj) obj.disabled=false;
				obj=document.getElementById("SelectGroup")
				if (obj) obj.disabled=true;
			}
			else
			{
				var obj=document.getElementById("SelectLocation")
				if (obj) obj.disabled=false;
				obj=document.getElementById("SelectGroup")
				if (obj) obj.disabled=false;
			}
		}
	}
}
function LookUpUser(val) {
	if(MESSCategCode=="")
	{
		alert("Please select categ!")
		return;
	}
	var obj=document.getElementById("MessageRecipients")
	if(MESSCategCode=="P")
	{
		TransferToList(obj,val);
	}
	document.getElementById("SelectUser").value="";
}
function LookUpGroup(val) {
	var ary=val.split("^")
	if(MESSCategCode=="")
	{
		alert("Please select categ!")
		return;
	}
	if(MESSCategCode=="P")
	{
		var GetUserByGroupObj=document.getElementById("GetUserByGroup");
		if(GetUserByGroupObj)
		{
			var GetUserByGroup=GetUserByGroupObj.value;
			var retStr=cspRunServerMethod(GetUserByGroup,ary[1])
		}
		var obj=document.getElementById("SelectGroup");
		if (obj) obj.value="";
	}
	else
	{
		//var obj=document.getElementById("SelectGroup");
		//obj.value=ary[0];
		//obj=document.getElementById("GroupId");
		//if(obj) obj.value=ary[1];
		if(MESSCategCode=="G")
		{
			var obj=document.getElementById("SelectGroup");
			if (obj) obj.value="";
			AddUserToList(ary[0]+"^"+ary[1]);
		}
	}
}
function SelectAllHandler() {
	var obj=document.getElementById("SelectAll");
	if (obj&&(obj.checked==true)) {
		if(MESSCategCode!="P")
		{
			alert("Please select Personal Message!")
			obj.checked=false
			return;
		}
	}
}
function LookUpLocation(val) {
	var ary=val.split("^")
	if(MESSCategCode=="")
	{
		alert("Please select categ!")
		return;
	}
	if(MESSCategCode=="P")
	{
		var GetUserByLoctionObj=document.getElementById("GetUserByLoction");
		if(GetUserByLoctionObj)
		{
			var GetUserByLoction=GetUserByLoctionObj.value
			var retStr=cspRunServerMethod(GetUserByLoction,ary[1])
		}
		var obj=document.getElementById("SelectLocation");
		if (obj) obj.value="";
	}
	else
	{
		//var obj=document.getElementById("SelectLocation");
		//obj.value=ary[0];
		//obj=document.getElementById("LocationId");
		//if(obj) obj.value=ary[1];
		if(MESSCategCode=="L")
		{
			var obj=document.getElementById("SelectLocation");
			if (obj) obj.value="";
			AddUserToList(ary[0]+"^"+ary[1]);
		}
	}
}
function AddUserToList(val)
{
	var obj=document.getElementById("MessageRecipients")
	if (obj) TransferToList(obj,val);
}
function deleteUserHandler() {
	var obj=document.getElementById("MessageRecipients")
	if (obj) ClearSelectedList(obj)
	return false;
}
function sendHandler() {
	var obj=document.getElementById("MessageRecipients");
	if (obj) {
		var ary=returnValues(obj);
		var objIdStr=ary.join("@");
		var LogOnUserId=document.getElementById("LogOnUserId").value;
		var DateEffective=document.getElementById("DateEffective").value;
		var TimeEffective=document.getElementById("TimeEffective").value;
		var MESSCategId=document.getElementById("MESSCategId").value;
		var MESSMessage=document.getElementById("MESSMessage").value;
		MESSMessage=MESSMessage.replace(/\r\n/g,"<br/>");
		if((LogOnUserId!="")&&(DateEffective!="")&&(MESSCategId!="")&&(MESSMessage!=""))
		{

			var objSelectAll=document.getElementById("SelectAll");		
			if((objIdStr=="")&&(objSelectAll.checked==true)) objIdStr="A"
			if(objIdStr=="") return;
			var parm=LogOnUserId+"^"+MESSMessage+"^"+MESSCategId+"^"+DateEffective+"^"+TimeEffective+"^"+objIdStr;
			var objSend=document.getElementById("SendMessage");
			if(objSend)
			{
				var ret=cspRunServerMethod(objSend.value,parm);
				if(ret=="0")
				{
					return send_click("OK");
				}
				else
				{
					alert("Send fail!")
				}
			}
		}
		else
		{
			alert("Please Complete Content!")
		}
	}
}
window.document.body.onload=BodyLoadHandler;