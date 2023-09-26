
var strMrMainRowId = GetParam(window, "MrMain")
var strMrType ="";
var strEpisodeID = GetParam(window, "EpisodeID")
var sWorkItem = GetParam(window, "sWorkItem")
var sReqType = GetParam(window, "sReqType")

function BodyLoadHandler()
{
	var obj=document.getElementById("cmdNewRequest");
	if (obj){ obj.onclick=cmdNewRequest_click;}
	var obj=document.getElementById("cmdCommit");
	if (obj){ obj.onclick=cmdCommit_click;}
	var obj=document.getElementById("cmdExit");
	if (obj){ obj.onclick=cmdExit_click;}
	var obj=document.getElementById("cmdMoveUp");
	if (obj){ obj.onclick=MoveUp_Click;}
	var obj=document.getElementById("cmdMoveDown");
	if (obj){ obj.onclick=MoveDown_Click;}
	var obj=document.getElementById("cmdDelete");
	if (obj){ obj.onclick=Delete_Click;}	
	IniForm();

}
function IniForm()
{
	var objWMRMain=GetDHCWMRMainByID("MGetMain",strMrMainRowId);
	var strPatId=objWMRMain.Papmi_Dr;
	strMrType=objWMRMain.MrType;
	var objPatient=GetPatientByID("MGetPatInfo", strPatId);
	var objMrType=GetDHCWMRDictionaryByID("MGetDic", strMrType);
	
	setElementValue("MrTypeDesc",objMrType.Description);
	setElementValue("MrNo",objWMRMain.MRNO);
	setElementValue("PatName",objPatient.PatientName);
	setElementValue("PatNo",objPatient.PatientNo);
	setElementValue("PatBirthday",objPatient.Birthday);
	setElementValue("PatSex",objPatient.Sex);
	
	var objAdmInfo=GetPatientAdmitInfo("GetAdmInfo", strEpisodeID);
	if (objAdmInfo!=null)
	{
	   var arry = objAdmInfo.LocDesc.split("/");
	   setElementValue("AimCtLoc",arry[0]); 
	   setElementValue("AimCtLocDesc",arry[1]);
	   var obj = document.getElementById("AimCtLocDesc");
	   if (obj){
		   obj.disabled=true;
	   }
	   var obj = document.getElementById("AimDate");
	   if (obj){
		   obj.disabled=true;
	   }
	   //add by wuqk 2008-06-23
	   //get RequestUser from paadm-doc
	   var arry=objAdmInfo.DocDesc.split("/");
	   setElementValue("AimUserName",arry[2]);
	   setElementValue("AimUser",arry[0]);
		}
	else
	{
		 //if no paadm,set RequestUser = login user
	   setElementValue("AimUserName",session['LOGON.USERNAME']);
	   setElementValue("AimUser",session['LOGON.USERID']);
		}
	
	var obj = document.getElementById("RequestType");
	if (obj){
		obj.multiple= false;
		obj.size = 1;
		//obj.disabled=true;
	  if (sReqType!=""){
	  	setElementValue("RequestType",sReqType);
	  	obj.disabled=true;
	  	}
	}
	
	var obj = document.getElementById("RequestItem");
	if (obj){
		obj.multiple= false;
		obj.size = 1;
		//obj.disabled=true;
	  if (sWorkItem!=""){
	  	setElementValue("RequestItem",sWorkItem);
	  	obj.disabled=true;
	  	}
	}
	
	var obj = document.getElementById("RequestList");
	if (obj){
		//obj.multiple= false;
		//obj.size = 6;
	}
	
	InvalidRequest();
	LoadRequestList();
}

//invalid cancel paadm request
function InvalidRequest()
{
	var obj=document.getElementById('MethodInvalidRequest');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=0;
    ret=cspRunServerMethod(encmeth,strMrMainRowId,"","","Y");
    if (ret<0){
	   alert(t["InvalidRequest"]);
	}
}

function GetAimCtLoc(record)
{
	var arry = record.split("^");
	setElementValue("AimCtLocDesc",arry[2]);
	setElementValue("AimCtLoc",arry[0]);
}
function GetAimUser(record)
{
	var arry = record.split("^");
	setElementValue("AimUserName",arry[2]);
	setElementValue("AimUser",arry[0]);
}

function MoveUp(SList)
{
	if (SList.selectedIndex==-1){return;}
	if (SList.selectedIndex==0){return;}
	var i=SList.selectedIndex,j=SList.selectedIndex-1;
	var objS = new Option(SList[i].text, SList[i].value);
	var objD = new Option(SList[j].text, SList[j].value);
	//var objS = CreatOption(SList[i].text, SList[i].value);
	//var objD = CreatOption(SList[j].text, SList[j].value);
	SList.options[j]=objS;
	SList.options[i]=objD;
	SList.options[j].selected=true;
}

function MoveDown(SList)
{
	if (SList.selectedIndex==-1){return;}
	if (SList.selectedIndex==SList.options.length-1){return;}
	var i=SList.selectedIndex,j=SList.selectedIndex+1;
	var objS = new Option(SList[i].text, SList[i].value);
	var objD = new Option(SList[j].text, SList[j].value);
	//var objS = CreatOption(SList[i].text, SList[i].value);
	//var objD = CreatOption(SList[j].text, SList[j].value);
	SList.options[j]=objS;
	SList.options[i]=objD;
	SList.options[j].selected=true;
}

function MoveOut(SList)
{
    if (SList.selectedIndex==-1){return;}
	var i;
	for (i=0;i<SList.options.length;i++)
		{
		if (SList.options[i].selected)
			{
	        SList.options[i]=null;
	        i=i-1;
       		}
		}
	return;
}

function cmdNewRequest_click()
{
	var objRequest=BuildNewRequest()
	if (!VerifyNewRequest(objRequest))
	{
		alert(t['VerifyNewObj']);
		return;
	}
	
	if (IsExistRequest(objRequest))   //add by zf 2008-4-15
	{
		alert(t['ExistRequest']);
		return;
	}
	
	var inString=SerializeDHCWMRRequest(objRequest)
	var ret=NewRequest("NewRequest",inString)
	
	if (parseInt(ret)>0)
	{
		LoadRequestList();
	}
	else
	{
		alert(t['NewReqFault']+ret);
	}
}

function IsExistRequest(obj)
{
	var ret="";
	var MainId=obj.MrMain_Dr;
	var Paadm=obj.Paadm_Dr;
	var ReqType=obj.RequestType;
	var ItemId=obj.WorkItem_Dr;
	var obj=document.getElementById("MethodGetReqByAdm");
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    ret=cspRunServerMethod(encmeth,MainId,ReqType,ItemId,Paadm);
    if (ret!==""){
		return true;
	}else{
		return false;
	}
}

function cmdCommit_click()
{
	var InString=GetListValue();
	var ret=CommitReqIndex("CommitReqIndex",InString)
	if (parseInt(ret)>0)
	{
		window.close();
	}else{
		alert(t['CommitReqFault']+ret);
	}
}

function cmdExit_click()
{
	window.close();
}
function Delete_Click()
{
	//MoveOut(document.getElementById("RequestList"));
}
function MoveUp_Click()
{
	MoveUp(document.getElementById("RequestList"));
}
function MoveDown_Click()
{
	MoveDown(document.getElementById("RequestList"));
}
function BuildNewRequest()
{
	  var obj = DHCWMRRequest();
    obj.RowID ="";
    obj.MrType_Dr =strMrType;
    obj.MrMain_Dr =strMrMainRowId;
    obj.RequestType =getElementValue("RequestType");
    obj.WorkItem_Dr =getElementValue("RequestItem");
    obj.AimDate =getElementValue("AimDate");
    obj.AimCtLoc_Dr =getElementValue("AimCtLoc");
    obj.AimUser_Dr=getElementValue("AimUser");
    obj.FirstFlag ="";
    obj.RequestDate ="";
    obj.RequestTime ="";
    obj.RequestUser_Dr=session['LOGON.USERID'];
    obj.IsActive="Y";
    obj.ResponseDate="";
    obj.ResponseTime="";
    obj.ResponseUser_D="";
    obj.MrMainStatus_D="";
    obj.ResumeText="";
    obj.Paadm_Dr=strEpisodeID;
    return obj;
}

function VerifyNewRequest(obj)
{
    if (obj == null)
        return false; 
    if (obj.MrType_Dr=="") return false;
    if (obj.MrMain_Dr=="") return false;
    if (obj.RequestType==""){
    	gSetFocus("RequestType");
    	return false;
    	}
    if (obj.WorkItem_Dr==""){
    	gSetFocus("RequestItem");
    	return false;
    	}
    if (obj.AimDate==""){
    	gSetFocus("AimDate");
    	return false;
    	}
    if (obj.AimCtLoc_Dr==""){
    	gSetFocus("AimCtLocDesc");
    	return false;
    	}
   return true;
   
}

function LoadRequestList()
{
	ClearListBox("RequestList");
	var arry=GetReqList("GetReqList", strMrMainRowId, "", "", "Y")
	cobList=document.getElementById("RequestList");
	for(var i = 0; i < arry.length; i ++)
  {
  	var objRequest=arry[i]
  	var txt=objRequest.AimCtLocObj.UserName + "(" +objRequest.RequestTypeObj.UserName + "  "+ objRequest.WorkItemObj.UserName+")";
  	var objOption = new Option(txt, objRequest.RowID);
  	//var objOption=CreatOption(txt, objRequest.Rowid);
	cobList.options[i]=objOption;
  }
	
}
function GetListValue()
{
		var	objList = document.getElementById("RequestList");
		var tmp = "";
		for(var i = 0; i < objList.options.length; i++)
		{
				tmp += (tmp.length == 0 ? "" : "^") + objList.options[i].value;
		}
		return tmp;
}

function CreatOption(txt,val)
{
	if ((!txt)&&(!val)){
		var obj=document.createElement("OPTION");
		obj.innerText =txt;
		obj.value = val;
		return obj;
	}else{return null;}
}

document.body.onload = BodyLoadHandler;