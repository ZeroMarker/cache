var CurEDDesc="";
function AddDefaultEDID(e)
{
	var obj,DefaultEDID="",DisplayDesc="",Result="",encmeth="";
	obj=document.getElementById("DefaultEDID");
	if (obj) DefaultEDID=obj.value;
	if (DefaultEDID==""){
		//alert(t["DefaultEDID"]);
		alert("��վ��û��ά��Ĭ�Ͻ���")
		return false;
	}
	if (DisplayDesc==""){
		DisplayDesc="Ĭ��"
	}
	if (Result==""){
		Result="Ĭ��"
	}
	obj=document.getElementById("UpdateDefaultEDInfo");
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	var ret=cspRunServerMethod(encmeth,DefaultEDID,DisplayDesc,Result);
	if (ret=="0"){
		//window.location.reload();
		AddDiagnosis(DefaultEDID);
	}else{
		alert(t["AddErr"]+ret)
	}
		return false;
}

function DBUpdate_click(){
		
	Update(1);
	return false;
}
function Update(AlertFlag)
{
	var ObjArr=document.getElementsByName("Advice");
	var ArrLength=ObjArr.length;
	var Strings=""
	for (var i=0;i<ArrLength;i++)
	{
		var ObjID=ObjArr[i].id;
		var ID=ObjID.split("^")[0];
		var Remark="";
		var Advice=ObjArr[i].value;
		var obj=document.getElementById(ID+"^Desc");
		var DisplayDesc=obj.value;
		var EDCDesc=""
		if (Strings=="")
		{
			Strings=ID+"&&"+Remark+"&&"+Advice+"&&"+""+"&&"+DisplayDesc+"&&"+EDCDesc
		}
		else
		{
			Strings=Strings+"^"+ID+"&&"+Remark+"&&"+Advice+"&&"+""+"&&"+DisplayDesc+"&&"+EDCDesc
		}
	}
	if (Strings=="") 
	{
		return false;
	}
	var obj=document.getElementById("DUpdateBox");
	if (obj) var encmeth=obj.value;
	
	var flag=cspRunServerMethod(encmeth,Strings)
	if (AlertFlag=="1") {//alert(t[flag]);
	window.location.reload();
	}
	return false;
}
function ShowEDInfo_change()
{
	var obj,ShowInfo=0,encmeth="";
	obj=document.getElementById("ShowEDInfo");
	if (obj&&obj.checked) ShowInfo=1;
	obj=document.getElementById("ShowEDInfoClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ShowInfo)
	window.location.reload();
}
function DeleteEDInfo(e,alertFlag)
{
	if (alertFlag==1)
	{
		if (!confirm(t['Del'])) {
			window.location.reload();
			 return false;
		}

	}
	var obj=document.getElementById("StationID");       //add by zl
	if (obj) var ChartID=obj.value;               //add by zl
	var obj=document.getElementById("EpisodeID");    //add by zl
	if (obj) var EpisodeID=obj.value;              //add by zl
	var obj=document.getElementById("DSSID");
	if (obj) var SSID=obj.value;
	var ID=e.id;
	var obj=document.getElementById("DSumResultBox");
	if (obj) var encmeth=obj.value;
	if (ID=="") return false;
	var flag=cspRunServerMethod(encmeth,SSID,ID,"1",ChartID,EpisodeID);
    if (flag==0){
		DeleteTableRow(e);
	}
	else{
		alert(t[flag])
	}
	return false;
}
function StationSCancelSub()
{
	StatusChange("Cancel",0);
}
function Audit_click(e,CompleteFlag) {
	StatusChange("Submit",CompleteFlag);
	
}
function StatusChange(Type,CompleteFlag)
{
	var UpdateCode="1";
	obj=document.getElementById("EpisodeID");
	if (obj) var PAADM=obj.value;
	
	 var flag=tkMakeServerCall("web.DHCPE.ResultNew","IsOtherPatientToHP",PAADM)
	 if(flag=="1"){
		 alert("סԺ������������б�����Ϊ�������");
		 return false;
	 }

	var UpdateCodeFlag=1;
	var UserID="";
	obj=document.getElementById("StationID");
	if (obj) ChartID=obj.value;
	var CurUserID=session['LOGON.USERID'];
	var CurLocID=session['LOGON.CTLOCID'];
	var UserID=session['LOGON.USERID'];
	if (Type=="Submit"){
		var obj=document.getElementById("AuditUser");
		if (obj) UserID=obj.value;
		// �Զ���������
		var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,ChartID,UserID,CurUserID,CurLocID)
		var ConArr=ConRet.split("^");
		if (ConArr[0]=="-1"){
			alert(ConArr[1]);
			window.location.reload();
			return false;
		}else if (ConArr[0]=="-2"){
			if (!confirm(ConArr[1]+",�Ƿ����?")){
			window.location.reload(); 
			return false;
			}

		}
		SaveResult();
	}
	
	//����ǩ��
	try{
		if (!PESaveCASign("1",PAADM+"%"+ChartID,"")) return false;
	}catch(e){}

	
	obj=document.getElementById("AuditBox");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,PAADM,ChartID,Type,UserID);

	if (flag=="0")
	{
		if (Type=="Submit")
		{
			if (CompleteFlag=="1")  //����ʱ����ȷ��
			{
				BComplete();
			}
			var StationID=GetValue("StationID",1);
			var RoomID=GetValue("RoomID",1);
			if ((RoomID=="")&&(session['LOGON.CTLOCID']=="572")&&(StationID!="10")){
				document.write("<font color=red>��ɼ��</font>");
				
			}else{
				window.location.reload();
			}
			parent.ShowNextPage();
		}else{
			window.location.reload();
		}
		return false;
	}else{
		if (Type=="Submit")
		{
			var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,ChartID,CurUserID,CurUserID,CurLocID)
		
		}
		alert(t[flag]);
		window.location.reload();
		return false;
	}
}
function SaveResult()
{
	
	var UObj=document.getElementsByTagName('A');
	var ButtonLength=UObj.length;
	for (var i=0;i<ButtonLength;i++)
	{
		var ButtonID=UObj[i].id;
		if ((ButtonID.split("Update").length>1)&&((UObj[i].innerText=="������")||(UObj[i].innerText=="���潨��"))) UObj[i].click();
		if (ButtonID=="BSave") UObj[i].click();
	}
	var UObj=document.getElementsByTagName('button');
	var ButtonLength=UObj.length;
	for (var i=0;i<ButtonLength;i++)
	{
		var ButtonID=UObj[i].name;
		if (ButtonID.split("Update").length>1)
		{//DBUpdate
			if ((UObj[i].innerText=="������")||(UObj[i].innerText=="���潨��")){UObj[i].click();}
		}
		if (ButtonID=="BSave") UObj[i].click();
	}
	
	
}
function AddDiagnosis(value){
	var ID=value.split("^")[0];
	var obj=document.getElementById("StationID");
	if (obj) var ChartID=obj.value;
	obj=document.getElementById("EpisodeID");
	if (obj) var EpisodeID=obj.value;
	obj=document.getElementById("DSSID");
	if (obj) var SSID=obj.value;
	var obj=document.getElementById("DSumResultBox");
	if (obj) var encmeth=obj.value;
	//if (SSID=="") {alert(t["NoSS"]);return false;}
	var flag=cspRunServerMethod(encmeth,SSID,ID,"0",ChartID,EpisodeID);
	var Arr=flag.split("^");
	if (Arr[0]==0)
	{ 
		var obj=document.getElementById("GetEDInfoBox");
		if (obj) var encmeth=obj.value;
		var Info=cspRunServerMethod(encmeth,ID,ChartID,EpisodeID);
		var InfoArr=Info.split("^");
		InsertNewRow(InfoArr[0],Arr[1],InfoArr[6]);
	}
	return false;
}
function EDClick()
{
	var eSrc=window.event.srcElement;
	var eSrcID=eSrc.id;
	var EpisodeID="";
	var obj=document.getElementById("EpisodeID");
	if (obj) var EpisodeID=obj.value;
	var InfoArr=eSrcID.split("^");
	var StationID=InfoArr[0];
	var Desc=InfoArr[1];
	var obj=document.getElementById("GetEDInfoByDesc");
	if (obj) encmeth=obj.value;
	EDDesc=Desc;
	var Info=cspRunServerMethod(encmeth,StationID,Desc,EpisodeID);
	if (Info=="") return false;
	CreateEDDetailDiv(eSrc,Info);
	//CreateDiv(eSrc,Info)
}
/*
function CreateDiv(obj,Info){  
	RemoveAllDiv(1); 
    div = document.createElement("div");   
    div.id="ALLEDDesc";  
    div.style.position='absolute';  
    var op=getoffset(obj);  
    div.style.top=op[0]+20;  
    div.style.left=op[1]+30;  
    div.style.zIndex =100;  
    div.style.backgroundColor='white';  
    div.style.border="1px solid #666";  
    //div.className="td1";  
    var innerText="<TABLE border=0.5 width=200><TR align='left' bgcolor='lightblue'><TD colspan=2><button onclick='RemoveAllDiv(0)'>�ر�</button></TD></TR>"
    var Char_2=String.fromCharCode(2);
    var Char_1=String.fromCharCode(1);
    var EDArr=Info.split(Char_2);
    var EDArrLength=EDArr.length
    for (var i=0;i<EDArrLength;i++)
    {
    	var OneEDArr=EDArr[i];
    	var OneArr=OneEDArr.split(Char_1);
    	innerText=innerText+"<TR bgcolor='lightblue'><TD style='cursor:hand' value='"+OneArr[0]+"' ondblclick=AllEDDblClick(this)>"+OneArr[1]+"</TD></TR>"
    }
    innerText=innerText+"</TABLE>"
    div.innerHTML=innerText;
    document.body.appendChild(div);  
}
function AllEDDblClick(eSrc)
{
	var EDID=eSrc.value;
	EDDescDBLClick(CurEDDesc);
	AddDiagnosis(EDID);
}
*/
/*
function InsertNewRow(SDID,Desc,Advice)
{
	var TableObj=document.getElementById("EDTABLE");
	var newTR = TableObj.insertRow(TableObj.rows.length);
	var newTD=newTR.insertCell(0);
	newTD.innerHTML = "<textarea style='width:100%;white-space:normal; word-break:break-all;' rows=3 id='"+SDID+"^Desc' name='Desc'>"+Desc+"</textarea>";
	var newTD=newTR.insertCell(1);
	newTD.innerHTML = "<textarea style='width:100%;white-space:normal; word-break:break-all;' rows=3 id='"+SDID+"^Advice' name='Advice'>"+Advice+"</textarea>";
	var newTD=newTR.insertCell(2);
	newTD.innerHTML = "<button id='"+SDID+"' onclick='DeleteEDInfo(this)'><font color=red>��</font></button>";
}
*/
function InsertNewRow(SDID,Desc,Advice)
{
	var TableObj=document.getElementById("EDTABLE");
	var newTR = TableObj.insertRow(TableObj.rows.length);
	var newTD=newTR.insertCell(0);
	newTD.innerHTML = "<textarea style='width:100%;white-space:normal; word-break:break-all;' rows=3 id='"+SDID+"^Desc' name='Desc'>"+Desc+"</textarea>";
	var newTD=newTR.insertCell(1);
	newTD.setAttribute('colspan',2);
	newTD.innerHTML = "<textarea style='width:85%;white-space:normal; word-break:break-all;' rows=3 id='"+SDID+"^Advice' name='Advice'>"+Advice+"</textarea>";
	//var newTD=newTR.insertCell(2);
	newTD.innerHTML =newTD.innerHTML+ "<button id='"+SDID+"' onclick='DeleteEDInfo(this)'><font color=red>��</font></button>";
}
function DeleteTableRow(e)
{
	var Rows=e.parentNode.parentNode.rowIndex;
	var TableObj=document.getElementById("EDTABLE");
	TableObj.deleteRow(Rows);
}