var statCode="";
var sendToScreen=false;
var regNo="";
RowId="";
var EpisodeID="";
var ICUBedRowid="";
var wardId="",bedId="";
var tmpDiagList=new Array();
function BodyLoadHandler()
{
    var fromDate=document.getElementById("fromDate");
    var toDate=document.getElementById("toDate");
    var today=document.getElementById("getToday").value; //ypz 061127
    if (fromDate.value=="") {fromDate.value=today;}
    if (toDate.value=="") {toDate.value=today;}
    var obj=document.getElementById("schbtn");
    if (obj) {obj.onclick=SchClick;}
    var objDeleteICUArrange=document.getElementById("DeleteICUArrange");
    if (objDeleteICUArrange) {objDeleteICUArrange.onclick=DeleteICUArrangeClick;}
    var objInsert=document.getElementById("insert");
    if (objInsert) {objInsert.onclick=InsertClick;}
    var objICUMonitor=document.getElementById("Monitor");
    if (objICUMonitor){objICUMonitor.onclick=ICUMonitor;}
     var objPerioperativeNursing=document.getElementById("PerioperativeNursing");
    if (objPerioperativeNursing){objPerioperativeNursing.onclick=PerioperativeNursing;}
    EpisodeID=document.getElementById("EpisodeID").value;
    wardId=session['LOGON.WARDID'];
    obj=document.getElementById("wardId");
    if (obj) obj.value=wardId;
	//UserId=session['LOGON.USERID'];
    //var ret=cspRunServerMethod(GetDocLoc,UserId)
    //if (ret!="") getloc(ret);
    
    var objtbl=document.getElementById('tDHCICUArrange');
	for (i=1;i<objtbl.rows.length;i++)
	{
	   var eSrc=objtbl.rows[i];
	   var RowObj=getRow(eSrc);
	   var item=document.getElementById("tStatusz"+i);
	   switch (item.innerText)
	   {
		   case "A":
		     RowObj.className="Exec";
		   break;
		   case "D":
		    RowObj.className="Discontinue";
		   break;
		   case "R":
		    RowObj.className="Immediate"
		   break;
		   case "M":
		    RowObj.className="LongNew";
		   break;
		   case "T":
		    RowObj.className="UnPaid";
		   break;
		   case "F":
		    RowObj.className="Temp"
		   break;
		   default:
		    RowObj.className="Exec";
		   break;
	   }
	}
}
function RSColor(Row,ObjTbl,selrow)
{
    var eSrc=ObjTbl.rows[Row];
	var RowObj=getRow(eSrc);
	var Status=document.getElementById("tStatusz"+Row).innerText;
	switch (Status)
	{
		   case "A":
		   RowObj.className="Exec";
		     
		   break;
		   case "D":
		    RowObj.className="Discontinue"//"Discontinue"; //blue /resu
		   break;
		   case "R":
		    RowObj.className="Immediate";//green //arrange
		   break;
		   case "M":
		    RowObj.className="Skintest";
		   break;
		   case "T":
		    RowObj.className="UnPaid";
		   break;
		   case "F":
		    RowObj.className="Temp"
		   break;
		   default:
		     RowObj.className="RowEven"; //
		   break 
	}
    if (selrow==Row)
    {
	   RowObj.className="clsRowSelected";
	}
}
function SchClick()
{
	bedId="";
	document.getElementById("bedDesc").value="";
	document.getElementById("bedDesc").readOnly = true;
	var fromDate=document.getElementById("fromDate").value;
	var toDate=document.getElementById("toDate").value;
	var sessloc=session['LOGON.CTLOCID'];
	var obj=document.getElementById("ICUAStatus");
	if (obj){ if (obj.value=""){statCode="";}	}
	var obj=document.getElementById("regNo");
	if (obj) { regNo=obj.value;	}
	var papmiMedicare="";
	obj=document.getElementById("medCareNo");
	if (obj) {papmiMedicare=obj.value;}
	//var papmiName=""
	obj=document.getElementById("patName");
	if (obj) {papmiName=obj.value;}
	var userLocId=session['LOGON.CTLOCID']	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCICUArrange&fromDate="+fromDate+"&toDate="+toDate+"&ctlocId="+userLocId+"&regNo="+regNo+"&icuaStatusCode="+statCode+"&papmiMedicare="+papmiMedicare+"&papmiName="+papmiName;
 	window.location.href=lnk; 
}

function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}

function GetRoomId(str)
{
	var room=str.split("^");
	var obj=document.getElementById("RoomId");
		obj.value=room[1];
}
function getloc(str)
{
	//var loc=str.split("^");
	//var obj=document.getElementById("loc")
	//obj.value=loc[1];
}
function SaveIcuaStatus(str)  //ypz 061225
{
	var icuaStatus=str.split("^");
	var obj=document.getElementById("icuaStatus")
	obj.value=icuaStatus[0];
	statCode=icuaStatus[1];
}
function InsertClick()
{
	if (EpisodeID=="") return;

	var userId=session['LOGON.USERID'];
	//check if duplicate
	var objHasSameEpisodeID=document.getElementById("HasSameEpisodeID").value;
    var retStr=cspRunServerMethod(objHasSameEpisodeID,EpisodeID);
    if(retStr==1)
    {
	    alert(t['HasSameEpisodeID']);
	    SchClick();
	    return;
    }
    if(retStr==2)
    {
	    alert(t['alert:nullEpisodeID']);
	    SchClick();
	    return;
    }
	var objInsertArrange=document.getElementById("insertArrange").value;
    var retStr=cspRunServerMethod(objInsertArrange,EpisodeID,userId);
    if (retStr!=0) alert(retStr)
    SchClick();
    EpisodeID="";
}
function DeleteICUArrangeClick()
{
	if(RowId==""){
		alert(t['alert:Please Select One']) 
		return;
	}
	var objDeleteICU=document.getElementById('DeleteICU')
	if(objDeleteICU) var encmeth=objDeleteICU.value;
	var resStr=cspRunServerMethod(encmeth,RowId)
	if (resStr!='0')
		{alert(t['alert:baulk']);
		return;}	
	else {alert(t['alert:success']);
	  location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCICUArrange";
	}
	SchClick();
}
function ICUMonitor()
{
    var selrow=document.getElementById("selrow");
   	if ((selrow.value=="")&&(EpisodeID==""))  return;
    var icuaId="";
   	if (selrow.value!="")
   	{
		var Status=document.getElementById("tStatusz"+selrow.value).innerText;
		if ((Status!="R")&&(Status!="M")&&(Status!="T")&&(Status!="F")) {
			alert("Setlect record please!");
			return;
		}
		icuaId=document.getElementById("icuaIdz"+selrow.value).innerText;
   	}
    if (icuaId==" ") icuaId=="";
    if ((icuaId=="")&&(EpisodeID=="")) return;
    //var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCICUDisplay&icuaId="+icuaId+"&EpisodeID="+EpisodeID+"&isSuperUser="+false+"&documentType="+"ICU";
	//var lnk="../Service/DHCClinic/App/ICU/DHCClinic.ICU.WPFMain.xbap";
	var curLocation=unescape(window.location);
	curLocation=curLocation.toLowerCase();
	var filePath=curLocation.substr(0,curLocation.indexOf('/csp/'))+"/service/DHCClinic/";

	var lnk="dhcicurecord.csp?icuaId="+icuaId+"&EpisodeID="+EpisodeID+"&filePath="+filePath+"&bedId="+bedId;
	//if (session['LOGON.USERID']='4359') //alert(lnk); //return;
		
	window.open(lnk,"DHC重症信息系统","height=900,width=1440,toolbar=no,menubar=no,resizable=yes");
	//showModalDialog(lnk,"DHCIcua","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no");
}
function PerioperativeNursing()
{
    var selrow=document.getElementById("selrow");
   	if ((selrow.value=="")&&(EpisodeID==""))  return;
    var icuaId="";
   	if (selrow.value!="")
   	{
		var Status=document.getElementById("tStatusz"+selrow.value).innerText;
		if ((Status!="R")&&(Status!="M")&&(Status!="T")&&(Status!="F")) {
			alert("Setlect record please!");
			return;
		}
		icuaId=document.getElementById("icuaIdz"+selrow.value).innerText;
   	}
    if (icuaId==" ") icuaId=="";
    if ((icuaId=="")&&(EpisodeID=="")) return;
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCICUDisplay&icuaId="+icuaId+"&EpisodeID="+EpisodeID+"&isSuperUser="+false+"&documentType="+"Perio";
	showModalDialog(lnk,"DHCIcua","dialogWidth:768px;dialogHeight:1024px;status:no;menubar:no");
	
}
 function SelectRowHandler()
 {
	bedId="";
	document.getElementById("bedDesc").value="";
	document.getElementById("bedDesc").readOnly = true;
    var i;
    var selrow=document.getElementById("selrow");
    if (selrow<1) return;
    var resList=new Array();
    var objtbl=document.getElementById('tDHCICUArrange');
    selrow.value=DHCWeb_GetRowIdx(window);
    EpisodeID=document.getElementById("tEpisodeIDz"+selrow.value).innerText;
    var objEpisodeID=document.getElementById("EpisodeID");
    objEpisodeID.value=EpisodeID;
   	
    RowId=document.getElementById("icuaIdz"+selrow.value).innerText;
    ICUBedRowid=document.getElementById("icuBedIdz"+selrow.value).innerText;
    //wardId=document.getElementById("curWardIdz"+selrow.value).innerText;
    //20120625curWardId
    for (i=1;i<objtbl.rows.length;i++)
	{
		enablePatHeight(i);
		enablePatWeight(i);
	}

	var frm =dhcsys_getmenuform();
   if (frm) {
   frm.EpisodeID.value=EpisodeID;
   if(frm.PatientID) frm.PatientID.value ="";
   }

   	var obj=document.getElementById('Save');
	 if(obj){
		(obj.disabled==false)
	 	{
		 	for (i=1;i<objtbl.rows.length;i++)
         	{
	        	RSColor(i,objtbl,selrow.value)
	     	}
	 	}
 
     }
    if(parent.frames['RPBottom'].location.href.indexOf("websys.default.csp?WEBSYS.TCOMPONENT=DHCICUBedEquip&BedRowid="+ICUBedRowid+"&wardId="+wardId)<0)
     {
     parent.frames['RPBottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCICUBedEquip&BedRowid="+ICUBedRowid+"&wardId="+wardId+"&icuaId="+RowId;
    }
 }
 ///身高
function enablePatHeight(rowIndex)
{
	var tpatHeightObj=document.getElementById("tpatHeightz"+rowIndex);
	if(document.getElementById("tpatHeightz"+rowIndex)) HeightStr=document.getElementById("tpatHeightz"+rowIndex).value;
	if(tpatHeightObj)
	{
		//scrubnurseObj.onblur=ScrNurOnKeyDown;
		tpatHeightObj.onkeydown=PatHeightObjOnKeyDown;
	}
}
function PatHeightObjOnKeyDown()
{	
	if ((event.keyCode==13)||(event.keyCode==0))  //1
	{   
		var eSrc=window.event.srcElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;	
		var patHeight=eSrc.value;
		var icuaId=document.getElementById("icuaIdz"+selectrow).innerText;
		if(patHeight.length==1)
		{
			alert("请检查输入!");
		}
		else 
		{
			var InsertHeight=document.getElementById("InsertHeight");
			if(InsertHeight)
			{
				ret=cspRunServerMethod(InsertHeight.value,patHeight,icuaId);
				if(ret!=0)
				{
					alert(ret);
				}
				else
				{
					alert("成功");
				}
			}
		}
	}
}
 ///体重
function enablePatWeight(rowIndex)
{
	var tpatWeightObj=document.getElementById("tpatWeightz"+rowIndex);
	if(tpatWeightObj)
	{
		tpatWeightObj.onkeydown=PatWeightObjOnKeyDown;
	}
}

function PatWeightObjOnKeyDown()
{	
	if ((event.keyCode==13)||(event.keyCode==0))  //1
	{   
		var eSrc=window.event.srcElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;	
		var patWeight=eSrc.value;
		var icuaId=document.getElementById("icuaIdz"+selectrow).innerText;
		if(patWeight.length==1)
		{
			alert("请检查输入!");
		}
		else 
		{
			var InsertWeight=document.getElementById("InsertWeight");
			if(InsertWeight)
			{
				ret=cspRunServerMethod(InsertWeight.value,patWeight,icuaId);
				if(ret!=0)
				{
					alert(ret);
				}
				else
				{
					alert("成功");
				}
			}
		}
	}
}
function GetBed(str)
{
	bedId="";
	obj=document.getElementById("bedDesc");
	if (obj.readOnly) 
	{
		obj.value="";	
	}
	else
	{
		var bedList=str.split("^");
		if (bedList.length>1)
		{
			bedId=bedList[1];
		}
	}
}
document.body.onload = BodyLoadHandler;
