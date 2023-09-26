var fLogUserLocType;
var statCode="";
var sendToScreen=false;

function BodyLoadHandler()
{
    var obj=document.getElementById("schbtn");
    var opdate=document.getElementById("opdate");
    var enddate=document.getElementById("enddate");
    var objGetInitialDate=document.getElementById("GetInitialDate"); //ypz 101224
    if (objGetInitialDate)
    {
	    var initialDate=cspRunServerMethod(objGetInitialDate.value,session['LOGON.USERID'],"",session['LOGON.CTLOCID']);
	    if (opdate.value=="") {opdate.value=initialDate;}
	    if (enddate.value=="") {enddate.value=initialDate;}
    }
    var objGetRoomIdByIp=document.getElementById("GetRoomIdByIp");
    if (objGetRoomIdByIp)
    {   try
        {
		var ipset=new ActiveXObject("rcbdyctl.Setting"); //CK 100914 获取本机IP
		var localIPAddress="";
		localIPAddress=ipset.GetIPAddress;
		var retRoomStr=cspRunServerMethod(objGetRoomIdByIp.value,localIPAddress);
		if(retRoomStr!="")
		{
			document.getElementById("RoomId").value=retRoomStr.split("^")[0];
			document.getElementById("OpRoom").value=retRoomStr.split("^")[1];
		}
		}
        catch(e)
        {}
    }
	var objDept=document.getElementById("Dept");   //ck  091118
    if(objDept) objDept.onkeydown=GetDept;
    var objPatWard=document.getElementById("patWard");
    if(objPatWard) objPatWard.onkeydown=GetPatWard;
    var objOperStat=document.getElementById("operStat");
    if(objOperStat) objOperStat.onkeydown=GetOperStat;
    var objOprFloor=document.getElementById("oprFloor");
    if(objOprFloor) objOprFloor.onkeydown=GetOprFloor;
    var objOpRoom=document.getElementById("OpRoom");
    if(objOpRoom) objOpRoom.onkeydown=GetOpRoom;   //ck  091118
    //opdate.value=DateDemo();
    //enddate.value=DateDemo();
    if (obj) {obj.onclick=SchClick;}
    var GetDocLoc=document.getElementById("GetDocLoc").value
    //var useridobj=document.getElementById("userid");
    UserId=session['LOGON.USERID'];
    var ret=cspRunServerMethod(GetDocLoc,UserId)
    if (ret!="")
    {
	    var loc=ret.split("^");
	    var obj=document.getElementById("loc");
	    obj.value=loc[1];
    }
    var obj=document.getElementById("btnNewOpApp");
    if (obj) {obj.onclick=btnNewOpApp_Click;}
    var obj=document.getElementById("btnUpdateOpApp");
    if (obj) {obj.onclick=btnUpdateOpApp_Click;}
    var obj=document.getElementById("btnOpArr");
    if (obj) {obj.onclick=btnOpArr_Click;}
    var obj=document.getElementById("btnAnArr");
    if (obj) {obj.onclick=btnAnArr_Click;}
    var obj=document.getElementById("btnOpReg");
    if (obj) {obj.onclick=btnOpReg_Click;}
    var obj=document.getElementById("btnOpRefuse");
    if (obj) {obj.onclick=btnOpRefuse_Click;}
    var obj=document.getElementById("btnCancelOpRefuse");
    if (obj) {obj.onclick=btnCancelOpRefuse_Click;}
    SchClick()
}
function DateDemo(){
   var d, s="";
   d = new Date();  
   s += d.getDate() + "/";
   s += (d.getMonth() + 1) + "/";
   s += d.getYear();
   return(s);
}

function SchClick()
{
var appDate=document.getElementById("opdate").value;
var endDate=document.getElementById("enddate").value;
var RoomId=document.getElementById("RoomId").value;
var OpRoomObj=document.getElementById("OpRoom")
if(OpRoomObj) 
{
	var OpRoom=OpRoomObj.value;
	if(OpRoom=="")
	{
		var RoomId=""
	}
}
var loc=document.getElementById("loc").value;
var Dept=document.getElementById("Dept").value;
var ifloc=document.getElementById("ifloc").value
var sessloc=session['LOGON.CTLOCID'];
var UserId=session['LOGON.USERID']; //+ wxl 090305 begin
var UserType="";
var objGetUserType=document.getElementById("getUserType");
if (objGetUserType) var UserType=cspRunServerMethod(objGetUserType.value,UserId); //+ wxl 090305 end
var LogUserType=""; //lonon user type: ANDOCTOR,ANNURSE,OPNURSE
var ret=cspRunServerMethod(ifloc,sessloc);
if (Dept=="") loc="";
//opLoc:ret=1,anLoc:ret=2
if ((ret!=1)&&(ret!=2))
{
	//alert(ret)
	//ward nurse:link location's operatoin apply
	//ward doctor: logon location's operatoin apply
	if (UserType=="NURSE") //+ wxl 090305
	{
		if(Dept==""){
			var objGetLinkLocId=document.getElementById("getLinkLocId");
			if (objGetLinkLocId) var loc=cspRunServerMethod(objGetLinkLocId.value,sessloc);
		}
	}
	else {
		loc=sessloc;
	} // + wxl 090305
}
else
{
	if ((ret==1)&&(UserType=="NURSE"))  LogUserType="OPNURSE";
	if ((ret==2)&&(UserType=="NURSE"))	LogUserType="ANNURSE";
	if ((ret==2)&&(UserType=="DOCTOR"))	LogUserType="ANDOCTOR";
	if(ret==1)fLogUserLocType="OP"
	if(ret==2)fLogUserLocType="AN"
}
var obj=document.getElementById("operStat"); //ypz 061225
if (obj) {if (obj.value=="") statCode="";}  //ypz 061225
var userLocId=session['LOGON.CTLOCID']
var IsAppTObj=document.getElementById("IsAppT");
if(IsAppTObj.checked==true) {var IsAppT=1}
else  {var IsAppT=0}
var medCareNo=document.getElementById("MedCareNo").value
var floorObj=document.getElementById("oprFloorId")
if(floorObj) var oprFloorId=floorObj.value;
else var oprFloorId=""
var oprFloor=document.getElementById("oprFloor").value;
if(oprFloor=="") var oprFloorId=""
var obj=document.getElementById("patWardId")
if(obj) var patWardId=obj.value;
else var patWardId=""
var obj=document.getElementById("patWard")
if(obj)
{
	var patWard=obj.value;
	if(patWard=="") var patWardId="";
}
var PaidOp="N";
var PaidOpObj=document.getElementById("PaidOp");   //ck + 20100303 
if((PaidOpObj)&&(PaidOpObj.checked==true)) PaidOp="Y";
var UnPaidOp="N";
var UnPaidOpObj=document.getElementById("UnPaidOp"); // +wxl 090420
if((UnPaidOpObj)&&(UnPaidOpObj.checked==true)) UnPaidOp="Y";
var paidType="ALL";
if((PaidOp=="N")&&(UnPaidOp=="Y"))
{
	paidType="N";
}
else if((PaidOp=="Y")&&(UnPaidOp=="N"))
{
	paidType="Y";
}
var ifAllLoc=""
var obj=document.getElementById("ifAllLoc")
if((obj)&&(obj.checked==true))
{
  ifAllLoc="Y" 
}
var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCANPATMAIN&stdate="+appDate+"&enddate="+endDate+"&oproom="+RoomId+"&Dept="+loc+"&stat="+statCode+"&userLocId="+userLocId+"&IsAppT="+IsAppT+"&MedCareNo="+medCareNo+"&oprFloorId="+oprFloorId+"&patWardId="+patWardId+"&paidType="+paidType+"&LogUserType="+LogUserType+"&ifAllLoc="+ifAllLoc;
//window.open(lnk) ; //,"_TARGET"
parent.frames['anopbottom'].location.href=lnk; 
}
function GetRoomId(str)
{
	var room=str.split("^");
	var obj=document.getElementById("RoomId");
		obj.value=room[1];
}
function getloc(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("loc")
	if (obj) obj.value=loc[0];
	obj=document.getElementById("Dept");
	if (obj) obj.value=loc[1];
}
function SaveOperStat(str)  //ypz 061225
{
	var operStat=str.split("^");
	var obj=document.getElementById("operStat")
	obj.value=operStat[1];
	statCode=operStat[0];
}
function getOperFloor(str)
{
	var floor=str.split("^");
	var obj=document.getElementById("oprFloor")
	obj.value=floor[1];
	var floorObj=document.getElementById("oprFloorId")
	if(floorObj) floorObj.value=floor[0];
}
function getWardId(str)
{
	var tem=str.split("^");
	var obj=document.getElementById("patWard")
	obj.value=tem[0];
	var obj=document.getElementById("patWardId")
	if(obj) obj.value=tem[1];
}

//ck 091118
function GetDept()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		Dept_lookuphandler();
	}
}
function GetPatWard()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		patWard_lookuphandler();
	}
}
function GetOperStat()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		operStat_lookuphandler();
	}
}
function GetOprFloor()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		oprFloor_lookuphandler();
	}
}
function GetOpRoom()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		OpRoom_lookuphandler();
	}
}   //CK091118

function btnNewOpApp_Click()	//pat doctor new application
{
	var opaId
	opaId=""
	var appType="ward";
	var EpisodeID="";
	var objEpisodeID=document.getElementById('EpisodeID');
	if (objEpisodeID) EpisodeID=objEpisodeID.value;
	var win=top.frames['eprmenu'];
	if (win) {
		var frm = win.document.forms['fEPRMENU'];
        if (frm) {
	        EpisodeID=frm.EpisodeID.value;
        }
	}
	if (EpisodeID=="") 
	{
		var frm =dhcsys_getmenuform();
   		if (frm) { EpisodeID=frm.EpisodeID.value;}
	}
	if (EpisodeID=="") {
		alert(t['alert:selectpat']);
		return;
	}
	var lnk
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCANOPAPP"
	lnk+="&opaId="+opaId+"&appType="+appType+"&EpisodeID="+EpisodeID;
	window.open(lnk,'_blank',"scrollbars=yes,top=0,left=0,width=960,height=700")	
}

function btnUpdateOpApp_Click()
{
   	var Status=document.getElementById('status');
	if (Status){
		//if (Status.value!=t['val:apply']){
		//	alert(t['alert:canOper']+t['val:apply']);
		//	return;
		//}
		var stat=Status.value;
		if ((stat==t['val:refuse'])||(stat==t['val:arrange'])||(stat==t['val:finish'])) return;
	}
	else return;
 	var opaId=document.getElementById('opaId');
  	if (opaId){
		if (opaId.value==""){
   			alert(t['alert:selectOne']);
   			return;
		}
  	}
  	else return;
   	var appType="ward";
   	var lnk
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCANOPAPP"
    lnk+="&opaId="+opaId.value+"&appType="+appType;
    window.open(lnk,'_blank',"scrollbars=yes,top=0,left=0,width=960,height=700");
}

function btnOpReg_Click()
{
   	var Status=document.getElementById('status');
	if (Status){
		if ((Status.value!=t['val:arrange'])&&(Status.value!=t['val:leaveRoom'])&&(Status.value!=t['val:finish'])) {
			alert(t['alert:canOper']+t['val:arrange']+","+t['val:leaveRoom']+","+t['val:finish']);
			return;
		}
	}
	else return;
 	var opaId=document.getElementById('opaId');
  	if (opaId){
  		if (opaId.value=="")
  		{
   			alert(t['alert:selectOne']);
   			return;
  		}
  	}
  	else return;
  	var selrow=parent.frames['anopbottom'].document.getElementById("selrow")
  	if (selrow)
  	{
	  	var anNote=parent.frames['anopbottom'].document.getElementById("oprFloorz"+selrow.value).innerText;
	  	//alert(anNote.length)
	  	if (anNote.length>4)
	  	{
		  	alert(anNote);
		//  	return;
	  	}
  	}
  	
   	var appType="RegOp";
   	var lnk
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCANOPAPP"
    lnk+="&opaId="+opaId.value+"&appType="+appType;
    window.open(lnk,'_blank',"scrollbars=yes,top=0,left=0,width=960,height=700");
}

function btnOpArr_Click()  //operation arrange
{
   	var Status=document.getElementById('status');
	if (Status){
		if ((Status.value!=t['val:apply'])&&(Status.value!=t['val:arrange'])) {
			alert(t['alert:canOper']+t['val:apply']+","+t['val:arrange']);
			return;
		}
	}
	else return;
 	var opaId=document.getElementById('opaId');
  	if (opaId){
  		if (opaId.value=="")
  		{
   			alert(t['alert:selectOne']);
   			return;
  		}
  	}
  	else return;
  	var appType="op";
  	var lnk
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCANOPAPP"
  	lnk+="&opaId="+opaId.value+"&appType="+appType;
  	window.open(lnk,'_blank',"scrollbars=yes,top=0,left=0,width=960,height=700");
}

function btnAnArr_Click()	//anaesthesia arrange 
{
   	var Status=document.getElementById('status');
	if (Status){
		if ((Status.value!=t['val:apply'])&&(Status.value!=t['val:arrange'])) {
			alert(t['alert:canOper']+t['val:apply']+","+t['val:arrange']);
			return;
		}
	}
 	var opaId=document.getElementById('opaId');
  	if (opaId){
  		if (opaId.value=="")
  		{
   			alert(t['alert:selectOne']);
   			return;
  		}
  	}
  	else return;
  	var appType="anaes";
  	var lnk
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCANOPAPP"
   	lnk+="&opaId="+opaId.value+"&appType="+appType;
   	window.open(lnk,'_blank',"scrollbars=yes,top=0,left=0,width=1010,height=760");	
}
function btnOpRefuse_Click()  //refuse operation application
{
	var stat="";
    var StatusObj=document.getElementById('status');
	if (StatusObj)
	{
		var Status=StatusObj.value;
		if(Status==t['val:apply']) stat="A"
		if(Status==t['val:arrange']) stat="R"
		if(Status==t['val:unAppoint']) stat="N"
		if ((Status!=t['val:apply'])&&(Status!=t['val:arrange']))
		{
			alert(t['alert:canOper']+t['val:apply']+","+t['val:arrange']);
			return;
		}
	}
 	var opaId=document.getElementById('opaId');
  	if (opaId){
  		if (opaId.value=="")
  		{
   			alert(t['alert:selectOne']);
   			return;
  		}
  	}
  	else return;
	//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPSuspend&opaId="+opaId.value;
	//window.open(lnk,"DHCANOPSuspend","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=200,width=700,top=100,left=300");
	var ChangeAnopStat=parent.frames["anopbottom"].document.getElementById("ChangeAnopStat");
  	if (ChangeAnopStat){
		var ret=cspRunServerMethod(ChangeAnopStat.value,"D",opaId.value);
		if (ret!=""){
			alert(ret);
			return;
		}
		else {
			parent.frames["anopbottom"].location.reload();
		}
  	}
}
function btnCancelOpRefuse_Click()  //cancel opertion application
{
	var Status=document.getElementById('status');
	if (Status){
		if (Status.value!=t['val:refuse']) {
			alert(t['alert:canOper']+t['val:refuse']);
			return;
		}
	}
 	var opaId=document.getElementById('opaId');
  	if (opaId){
  		if (opaId.value=="")
  		{
   			alert(t['alert:selectOne']);
   			return;
  		}
  	}
  	else return;
  	var ChangeAnopStat=parent.frames["anopbottom"].document.getElementById("ChangeAnopStat");
  	if (ChangeAnopStat){
		var ret=cspRunServerMethod(ChangeAnopStat.value,"A",opaId.value);
		if (ret!=""){
			alert(ret);
			return;
		}
		else {
			parent.frames["anopbottom"].location.reload();
		}
  	}	
}
document.body.onload = BodyLoadHandler;
