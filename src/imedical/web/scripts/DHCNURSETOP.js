//document.write("<object ID='ClsAlert' CLASSID='CLSID:B080649D-D704-49F0-BBC1-B5B7A9A351E2' CODEBASE='../addins/client/OrdAlert.CAB#version=1,0,0,0'>");
//document.write("</object>");

var OrdAlert;//alert new order object
//var Ico;
//OrdAlert= new ActiveXObject("Ico.clsnot");//TestAx.CLSMAIN

var EpisodeID=document.getElementById("EpisodeID").value;
var objOnlyNewOrd=document.getElementById("onlyNewOrd");
var regNoLength=8;
var objGetPatConfig=document.getElementById("GetPatConfig");
if (objGetPatConfig)
{
	var patConfig=cspRunServerMethod(objGetPatConfig.value);
	var tmpList=patConfig.split("^");
	if (tmpList[0]>8) regNoLength=tmpList[0];
}
    
function BodyLoadHandler()
{
    // Ico= new ActiveXObject("Ico.clsnot");//TestAx.CLSMAIN
    // OrdAlert= new ActiveXObject("ordalert.ClsAlert");//TestAx.CLSMAIN
    //alert(EpisodeID+"in")
    var schobj=document.getElementById("SearCH");
    if (schobj) {schobj.onclick=sch_click;}
	
    var AutoRefeshWindow=document.getElementById("AutoRefeshWindow");
    if (AutoRefeshWindow) {AutoRefeshWindow.onclick=AutoRefeshWindow_click;}
    var schobj=document.getElementById("RegNo");
    //schobj.style.color ="red" ;
    if (schobj) {schobj.onblur=Reg_blur;}
    var objLongNewOrdAdd=document.getElementById("longNewOrdAdd");
    if (objLongNewOrdAdd) {objLongNewOrdAdd.onclick=sch_click;}
    if (objOnlyNewOrd) {objOnlyNewOrd.onclick=onlyNewOrd_click;}
    var objPdaExec=document.getElementById("pdaExec");
    if (objPdaExec) {objPdaExec.onclick=sch_click;}

    var rptypobj=document.getElementById("ReportList");
	
    rptypobj.value=""; //all order
    var obj=document.getElementById('vartyp');
    obj.value="Default";
    var stdate=document.getElementById("StartDate");
    //if (stdate) {stdate.onblur=sch_click;}
    var edate=document.getElementById("EndDate");
    //if (edate) {edate.onblur=sch_click;}
    var doctyp=document.getElementById("Doctyp");
    
    doctyp.checked=true;
    //ypz 061123 begin
   	//var today=document.getElementById("getToday").value; 
    //if (stdate.value=="") {stdate.value=today;}
    //if (edate.value=="") {edate.value=today;}
    stdate.value=DateDemo();
    edate.value=DateDemo(); 
    //ypz 061123
    var userId=session['LOGON.USERID'];
    var loc=session['LOGON.CTLOCID'];
    var GetUserWardId=document.getElementById("GetUserWardId").value;
    var wardstr=cspRunServerMethod(GetUserWardId,userId,loc,EpisodeID); //ypz 071114
    getwardid11(wardstr);
    var Reg=document.getElementById("RegNo");
	
    var GetUserGroupAccess=document.getElementById("GetUserGroupAccess").value;
    var userId=session['LOGON.USERID'];
    var usr=document.getElementById("userId");
    usr.value=userId;
    //var ret=cspRunServerMethod(GetUserGroupAccess,"",userId);
    
    var userGroupId=session['LOGON.GROUPID']  //ypz
    //var objUserGroup=document.getElementById("userGroupId");
    //if (objUserGroup) objUserGroup.value=userGroupId;
    var retStr=cspRunServerMethod(GetUserGroupAccess,userGroupId,userId);
    var tem=retStr.split("!");
    var temp=tem[1].split("|");

    if (tem[1]!="")
    {
        var objReportType=document.getElementById("ReportList");
        objReportType.value=temp[1];
        var obj=document.getElementById('vartyp');
        obj.value=temp[0];
        //if (obj.value=="JYDO") objBtnCheckOut.style.visibility ="visible";
    }

    if (EpisodeID!="")
    { 
        obj=document.getElementById("GetPNameRegNo").value;
        var retval=cspRunServerMethod(obj,EpisodeID);  
        var s=retval.split("^")
        if (Reg){ Reg.value=s[1];}
    }
    if (Reg.value!="")
    {
        sch_click();
    }
}
function onlyNewOrd_click()
{
}

function AutoRefeshWindow_click()
{
window.open ('websys.default.csp?WEBSYS.TCOMPONENT=DHCNYFYWardAutoRefreshNewOrder','新医嘱提示','height=0,width=0,top=1500,left=1500,status=yes,toolbar=yes') 
}
function DateDemo(){
   var d, s="";
   d = new Date();
   s += d.getDate() + "/";
   s += (d.getMonth() + 1) + "/";
   s += d.getYear();
   return(s);
}

function sch_click()
{
    var wardobj=document.getElementById("PacWard").value;
    var regobj=document.getElementById("RegNo").value;
    var rptypobj=document.getElementById("ReportList").value;
    var stdate=document.getElementById("StartDate").value;
    var edate=document.getElementById("EndDate").value;
    if (GetDate(stdate)>GetDate(edate)) {alert(t['alert:startEndDateErr']);return}
    var vartyp=document.getElementById("vartyp").value;
    var wardid=document.getElementById("wardid").value;
    var locid=document.getElementById("locid").value;
    var Dept=document.getElementById("Dept").value;
    var doctyp=document.getElementById("Doctyp").checked;
    var objPdaExec=document.getElementById("pdaExec");
    var pdaExec="";
    if (objPdaExec) pdaExec=objPdaExec.checked;
    var longNewOrdAdd=false;
    var objlongNewOrdAdd=parent.frames["NurseTop"].document.getElementById("longNewOrdAdd"); 
    if (objlongNewOrdAdd) longNewOrdAdd=objlongNewOrdAdd.checked;
    var ClearRecordSy=document.getElementById("ClearRecordSy").value;
    var sy=cspRunServerMethod(ClearRecordSy); //clear inject record
    var gap="";
    if (Dept=="")
    {
	    locid="";
	}
    //wardid=wardid+"|"+locid;
   
    if ((wardid=="")&&(regobj=="")) {alert(t['alert:selWardOrRegNo']);return false;};
    if (vartyp==""){alert(t['alert:selOrdType']);return false;}
    var userId=session['LOGON.USERID'];
    wardobj=escape(wardobj);
    //add by wkz S 071212  for query by arcim
    var ARCIMDesc=document.getElementById("ARCIMDesc")
    if(ARCIMDesc) {
	    ARCIMDesc=ARCIMDesc.value;
    }
    else {ARCIMDesc="" }
    var ArcimDR=document.getElementById("ArcimDR");
    if(ArcimDR){
	    ArcimDR=ArcimDR.value
    }
    else { ArcimDR="" }
    //if (regobj=="")    { ArcimDR=""; }
    if (ARCIMDesc=="") { ArcimDR=""; }
    var onlyNewOrd="";
    if (objOnlyNewOrd) onlyNewOrd=objOnlyNewOrd.checked;
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNURSEXCUTE"+"&wardid="+wardid+"&RegNo="+regobj+"&userId="+userId+"&StartDate="+stdate+"&EndDate="+edate+"&vartyp="+vartyp+"&gap="+gap+"&warddes="+wardobj+"&Loc="+locid+"&doctyp="+doctyp+"&longNewOrdAdd="+longNewOrdAdd+"&onlyNewOrd="+onlyNewOrd+"&ArcimDR="+ArcimDR+"&pdaExec="+pdaExec;
    //var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNURSEXCUTE"+"&wardid="+wardid+"&RegNo="+regobj+"&userId="+userId+"&StartDate="+stdate+"&EndDate="+edate+"&vartyp="+vartyp+"&gap="+gap+"&warddes="+wardobj+"&Loc="+locid+"&doctyp="+doctyp+"&longNewOrdAdd="+longNewOrdAdd+"&onlyNewOrd="+onlyNewOrd.checked;
     //add by wkz E 071212
    parent.frames['OrdList'].location.href=lnk; 
    var Server=parent.frames['OrdList'].document.getElementById("GetServerNameSpace").value;
    if (wardid!="")
    { 
    //OrdAlert.Gap="Gap";
    // OrdAlert.connectstring=Server;
    // OrdAlert.WardId=wardid;
    // OrdAlert.RegNo="";
    // OrdAlert.DocTyp=doctyp;
    // OrdAlert.UserId=userId;
    // OrdAlert.vartyp="Default";
    // OrdAlert.Loc=locid;
    // OrdAlert.SetInterVal(3);
     //OrdAlert.SetAudio(1000);
     //OrdAlert.Start();
    }
    
//	window.open(lnk,"医嘱执行","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=300,top=-100,left=300");

}
function OrdExcute_click()
{
	var objtbl=document.getElementById('tDHCNURSEXCUTE');
	var rowid;
	rowid="";
	for (i=1;i<objtbl.rows.length;i++)
	{
//	   var eSrc=objtbl.rows[i];
//	   var RowObj=getRow(eSrc);
	   var item=document.getElementById("seleitemz"+i);
	   if (item.checked==true)
       {
	       var basedose=document.getElementById("doseQtyUnitz"+i).innerText;
           var oeoriId=document.getElementById("oeoriIdz"+i).innerText;
           var arcicId=document.getElementById("arcicIdz"+i).innerText;
           rowid=rowid+"^"+basedose+"!"+oeoriId+"!"+arcicId+"!"+i;
           // alert(arc.innerText);
	   }
	
	}
    // alert(rowid);
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCORDEXCUTE"+"&AAA=1&BBB="+rowid;
	window.open(lnk,"OrdExec","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=300,top=-100,left=300");
	
}
function SearCH_click()
{
	var method=document.getElementById("schord");
	var wardno=document.getElementById("wardid").value;
	var regno=document.getElementById("RegNo").value;
	var userId=session['LOGON.USERID'];
    var mthallpatient=document.getElementById("getallpatient");
	if (method) {var encmeth=method.value} else {var encmeth=''};
    if (cspRunServerMethod(encmeth,'','',wardno,regno,userId)=='0') {
		}
	if (mthallpatient) {var encmeth=mthallpatient.value} else {var encmeth=''};
    if (cspRunServerMethod(encmeth,'getallord','',userId)=='0') {
		}
}
function getloc(str)
{
		var loc=str.split("^");
		var obj=document.getElementById("locid")
		obj.value=loc[1];
		sch_click();
		//alert(loc[1]);
	
}
function getwardid(str)
{
	var obj=document.getElementById('wardid');
	var tem=str.split("^");
	obj.value=tem[1];
	//alert( tem[1]);
	var obj=document.getElementById('PacWard');
	obj.value=tem[0];
	return;
}

function getwardid11(str)
{
   var locid=document.getElementById("locid");
   var Dept=document.getElementById("Dept");
  	if (str!="")
	{
     var ward=str.split("|");
	 var obj=document.getElementById('wardid');
	 var tem=ward[0].split("^");
	 obj.value=tem[1];
	//alert( tem[1]);
	 var obj=document.getElementById('PacWard');
	 obj.readOnly=true;
	 obj.value=tem[0];
	 var img=document.getElementById("ld50532iPacWard") //"ld50338iPacWard");
	 if (img) img.style.display ="none";
	 var loc=ward[1].split("^");
     //Dept.readOnly=true;
	 var imgdept=document.getElementById("ld50532iDept") //"ld50338iDept");
	 if (imgdept) imgdept.style.display ="none";
     locid.value=loc[1];
     Dept.value=loc[0];
	 return;
	}
	
	if ((session['LOGON.CTLOCID']==211)||(session['LOGON.CTLOCID']==212)||(session['LOGON.CTLOCID']==214))
	{
	   var GetLocDes=document.getElementById("GetLocDes").value
	   var ret=cspRunServerMethod(GetLocDes,session['LOGON.CTLOCID']);
	   locid.value=session['LOGON.CTLOCID'];
	   Dept.value=ret;
	  // Dept.readOnly=true;
	   var imgdept=document.getElementById("ld50112iDept");
	  imgdept.style.display ="none";
 
	}
	
}
function savetyp(str)
{
	var obj=document.getElementById('vartyp');
	var tem=str.split("^");
	if (obj.value!=tem[1]){obj.value=tem[1];sch_click();}
}
function Reg_blur()
{
	var i;
    var regno=document.getElementById("RegNo");
	var isEmpty=(regno.value=="");
    var oldLen=regno.value.length;
    if (!isEmpty) {  //add 0 before regno
        for (i=0;i<regNoLength-oldLen;i++)
        {
	        regno.value="0"+regno.value  
        }
    }
}

function GetDate(dateStr)
{
	var tmpList=dateStr.split("/")
	if (tmpList.length<3) return 0;
	return ((tmpList[2]*1000)+(tmpList[1]*50)+tmpList[0]*1)
}
function saveArcim(str)    ///add by wkz 071212  
{
	var obj=document.getElementById('ArcimDR');
	var tem=str.split("^");
	if (obj.value!=tem[1]){obj.value=tem[1];}
}

document.body.onload = BodyLoadHandler;
