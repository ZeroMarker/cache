var UserId=session['LOGON.USERID'];
var CloseODSDivFlag="1";
var CurID="";
document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var obj=document.getElementById("RegNo");
	if (obj) obj.onkeydown=RegNo_keydown;
	if (obj){obj.onfocus=txtfocus;}
	var obj=document.getElementById("Name");
	if (obj) obj.onkeydown=Name_keydown;
	var obj=GetObj("Record");
	if (obj) obj.onchange=Record_change;
	var obj=document.getElementById("ZJNo");
	if (obj) obj.onkeydown=ZJNo_keydown;
	
	var RRR=""
	obj=document.getElementById("RRR");
	if (obj) RRR=obj.value;
	obj=document.getElementById("RegNo");
	if ((obj)&&(RRR!="")) obj.value=RRR;
	
	if (RRR!="")
	{
		autoini()
	}
}

function autoini()
{
	
		var RegNo="",PAADM="";
		var obj=document.getElementById("RegNo");
		if (obj) RegNo=obj.value;
		if (RegNo==""){
			alert("请输入登记号");
			return false;
		}
		/*
		var Status=tkMakeServerCall("web.DHCPE.PreIADM","GetStatusByRegNo",RegNo);
		if(Status=="REGISTERED"){
			var url="dhcpecustomconfirmbox.csp?Type=Arrived";   
			var  iWidth=300; //模态窗口宽度
			var  iHeight=130;//模态窗口高度
			var  iTop=(window.screen.height-iHeight)/2;
			var  iLeft=(window.screen.width-iWidth)/2;
			var dialog=window.showModalDialog(url, RegNo, "dialogwidth:300px;dialogheight:130px;center:1"); 
			if(dialog){
				if(dialog!=1){
					return false;
				}
			}else{
				return false;
			}
		}*/
		SetInfoByRegNo(RegNo);
		var obj=document.getElementById("PAADM");
		if (obj) PAADM=obj.value;
		//alert(PAADM)
		if (PAADM!=""){
			obj=SetValue("Record",PAADM);
			CreateMainTable();
		}
}

function ZJNo_keydown()
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		var ZJNo="";
		var obj=document.getElementById("ZJNo");
		if (obj) ZJNo=obj.value;
		if (ZJNo==""){
			alert("请输入证件号");
			return false;
		}
		var PAADM=tkMakeServerCall("web.DHCPE.CardManager","GetPAADMByZJNo",ZJNo);
		if (PAADM==""){
			alert("证件号码不存在,请确认输入是否正确");
			return false;
		}
		var Arr=PAADM.split("^")
		var RegNo=Arr[0];
		var PAADM=Arr[1];
		SetValue("RegNo",RegNo);
		SetInfoByRegNo(RegNo);
		SetObj("Record",PAADM)
		Record_change();
		return false;
	}
}
function txtfocus()
{
    var obj;
	obj=document.getElementById("RegNo");
	/*active 代表输入法为中文
	inactive 代表输入法为英文
	auto 代表打开输入法 (默认)
	disable 代表关闭输入法
	*/
	if (obj) obj.select();
	if(obj.style.imeMode ==  "disabled")
	{                       
	 }
	else
	{                      
		obj.style.imeMode   =   "disabled";    
	}      


}
function Record_change()
{
	CreateMainTable();
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
function Name_keydown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		var Name=GetValue("Name");
		if (Name=="") return false;
		var Info=tkMakeServerCall("web.DHCPE.DocPatientFind","GetPersonCountByName",Name);
		var InfoArr=Info.split("^");
		var Count=InfoArr[0];
		if (Count==0) return false;
		
		if (Count==1){
			SetValue("RegNo",InfoArr[1]);
			SetInfoByRegNo(InfoArr[1]);
			return false;
		}
		if (Count>1){
			var method="web.DHCPE.DocPatientFind:GetRegNoByName";
			var jsfunction="GetRegNoAfter"
			var url='websys.lookup.csp';
			url += "?ID=";
			url += "&CONTEXT=K"+method;
			url += "&TLUJSF="+jsfunction;	
			url += "&P1="+ websys_escape(Name);
			websys_lu(url,1,'');
			return websys_cancel();
		}
	}
}
function GetRegNoAfter(value)
{
	if (value=="") return false;
	var InfoArr=value.split("^");
	SetValue("RegNo",InfoArr[0]);
	SetInfoByRegNo(InfoArr[0]);
	return false;
}
function RegNo_keydown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		var RegNo="";
		var obj=document.getElementById("RegNo");
		if (obj) RegNo=obj.value;
		if (RegNo==""){
			alert("请输入登记号");
			return false;
		}
		var Status=tkMakeServerCall("web.DHCPE.PreIADM","GetStatusByRegNo",RegNo);
		if(Status=="REGISTERED"){
			var url="dhcpecustomconfirmbox.csp?Type=Arrived";   
			var  iWidth=300; //模态窗口宽度
			var  iHeight=130;//模态窗口高度
			var  iTop=(window.screen.height-iHeight)/2;
			var  iLeft=(window.screen.width-iWidth)/2;
			var dialog=window.showModalDialog(url, RegNo, "dialogwidth:300px;dialogheight:130px;center:1"); 
			if(dialog){
				if(dialog!=1){
					return false;
				}
			}else{
				return false;
			}
		}
		SetInfoByRegNo(RegNo);
	}
}
function SetInfoByRegNo(RegNo)
{
	var encmeth=GetValue("GetInfo");
	var Info=cspRunServerMethod(encmeth,RegNo,"","","");
	if (Info.split("^")[0]=="-1")
	{
		alert(Info.split("^")[1]);
		return false;
	}
	var RecordInfo=Info.split(String.fromCharCode(1))[1];
	var BaseInfo=Info.split(String.fromCharCode(1))[0];
	var BaseArr=BaseInfo.split("^");
	SetValue("RegNo",BaseArr[0]);
	SetValue("Name",BaseArr[1]);
	//SetValue("IDCard",BaseArr[2]);
	//SetValue("Dob",BaseArr[3]);
	//SetValue("Tel",BaseArr[4]);
	SetValue("Age",BaseArr[5]);
	SetValue("Sex",BaseArr[7]);
	//DropMainTable();
	obj=GetObj("Record");
	RemoveList(obj);
	if (RecordInfo=="") return false;
	SetList(obj,RecordInfo);
	CreateMainTable();
	/*
	//SetValue("position",BaseArr[6]); //add by lxl 20121123
	var RecordArr=RecordInfo.split(String.fromCharCode(2));
	var obj=GetObj("Record");
	
	var length=RecordArr.length;
	for (var j=0; j<length; j++)
	{
		AddListItem(obj,RecordArr[j].split("^")[0],RecordArr[j].split("^")[1]);
	}
	obj.options[0].selected=true;
	*/
	
}
function DropMainTable()
{
	var obj=document.getElementById('NewDiagnosis');
	if (obj) obj.parentNode.removeChild(obj);
}
function CreateMainTable()
{
	
	var PAADM=GetValue("Record");
	var encmeth=GetValue("OutMain");
	var MainDoctor=GetValue("MainDoctor");
	var OnlyRead=GetValue("OnlyRead");
	var NewMainFlag=GetValue("NewMainFlag");
	var FZFlag=GetValue("FZFlag");
	if (MainDoctor=="N"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewDiagnosis&MainDoctor="+MainDoctor+"&OnlyRead="+OnlyRead+"&EpisodeID="+PAADM;
	}else if(MainDoctor=="Y"){
		
		if (NewMainFlag=="Y"){
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewDiagnosis&MainDoctor="+MainDoctor+"&OnlyRead="+OnlyRead+"&EpisodeID="+PAADM;
		}else{
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewDiagnosisMainDoctor&MainDoctor="+MainDoctor+"&OnlyRead="+OnlyRead+"&EpisodeID="+PAADM;	
		}
	}else{
		if (FZFlag=="Y"){
			var lnk="dhcpecardmanager.csp?EpisodeID="+PAADM;
		}else{
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewDiagnosis&MainDoctor="+MainDoctor+"&OnlyRead="+OnlyRead+"&EpisodeID="+PAADM;
		}
	}
	//alert(lnk)
	if (parent.frames["diagnosis"]){
		parent.frames["diagnosis"].location.href=lnk;
	}
	//cspRunServerMethod(encmeth,PAADM,MainDoctor,OnlyRead);
	
}
function SetList(obj,RecordInfo)
{
	var RecordArr=RecordInfo.split(String.fromCharCode(2));
	
	var GName=tkMakeServerCall("web.DHCPE.DocPatientFind","GetGroupNameByPAADM",RecordArr[0].split("^")[0]);
	SetValue("Group",GName);

	var length=RecordArr.length;
	for (var j=0; j<length; j++)
	{
		AddListItem(obj,RecordArr[j].split("^")[0],RecordArr[j].split("^")[1]);
	}
	obj.options[0].selected=true;
}
function AddListItem(obj,objItemValue,objItemText)
{
	var varItem = new Option(objItemText, objItemValue);      
    obj.options.add(varItem); 
}
function RemoveList(obj)
{
	obj.options.length = 0;
}