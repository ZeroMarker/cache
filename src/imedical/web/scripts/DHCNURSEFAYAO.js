var EpisodeID=document.getElementById("EpisodeID").value;
var objIfChangeRegNo=document.getElementById("ifChangeRegNo");
var preRegNo=""

function BodyLoadHandler() {
	//var regLookUp=document.getElementById("ld50696iregNo")
	//if(regLookUp)  regLookUp.style.display ="none";
	var userId=session['LOGON.USERID'];
    var loc=session['LOGON.CTLOCID'];
	var objStTime=document.getElementById("StartTime");
	objStTime.value="00:00";
	var objGetETime=document.getElementById("GetETime").value;
	var ETimeStr=cspRunServerMethod(objGetETime,loc);
	var objETime=document.getElementById("EndTime");
	objETime.value=ETimeStr;
    var GetUserWardId=document.getElementById("GetUserWardId").value;
    var wardstr=cspRunServerMethod(GetUserWardId,userId,loc);
    if(wardstr!="") getwardid(wardstr)
	var objSearch=document.getElementById("Find");
	if (objSearch) objSearch.onclick=SearchClick;
	var OBJ=document.getElementById("PrintFaYao");
	if (OBJ) OBJ.onclick=PrintFaYao;
	var obj=document.getElementById("tDHCNURSEFAYAO") ;
	if (obj)  obj.ondblclick=RowChanged;
	var typ=document.getElementById("typ");
	//typ.checked=true;
	var SendMsg=document.getElementById("SendMsg") ;
	if (SendMsg)  SendMsg.onclick=SendMsg_Click;
	var Audit=document.getElementById("AuditMed") ;
	if (Audit)  Audit.onclick=Audit_Click;
	var today=document.getElementById("getToday").value;
	/*var objStDate=document.getElementById("StDate");
	if (objStDate) {
		if (objStDate.value=="") {
	    	var adjSDate=AdjDateTime(today,-86400);
	    	objStDate.value=adjSDate.getDate()+"/"+(adjSDate.getMonth()+1)+"/"+adjSDate.getYear();
		}
		StDate=objStDate.value;
	}
	var objEDate=document.getElementById("EDate");
	if (objEDate) {
		if (objEDate.value=="") {objEDate.value=today;}
		EDate=objEDate.value;
	}*/
	var objUnPayFlage=document.getElementById("UnPayFlage");
	var objAllFlage=document.getElementById("AllFlage");
	if(objAllFlage){
		objAllFlage.onclick=All_Click;
		if(objAllFlage.checked==true){
			if(objUnPayFlage){objUnPayFlage.checked=false}
		}
	}
	if(objUnPayFlage){
		objUnPayFlage.onclick=UnPay_Click;
		if(objUnPayFlage.checked==true){
			if(objAllFlage){objAllFlage.checked=false}
		}
	}
	var objGetAuditList=document.getElementById("GetAuditTimeList")
    if(objGetAuditList)
    {
	    var retStr=document.getElementById("GetAuditTimeList").value;
		AuditBatch(retStr);
    }
	var objAudit=document.getElementById("auditBatchId");
	if(objAudit)
	{
		var auditBatchId=objAudit.value;
		var select=0
		if(auditBatchId!="")
		{
			var auditBatch=document.getElementById("auditBatch");
			for (var i=0;i<auditBatch.length;i++)
			{
				if(auditBatch.options[i].value==auditBatchId) select=i
			}
			auditBatch.selectedIndex=select;
		}
	}
	var obj=document.getElementById("SelectAll");
	if (obj){obj.onclick=SelectAll_Click;} 
	var objRegNo=document.getElementById("regNo");
	if (objRegNo) {
	    objRegNo.onkeydown=RegNoKeyDown;
	    objRegNo.onblur=RegNoBlur;
		if (objIfChangeRegNo.value!="Yes")
		{ 
			if (EpisodeID!="")
			{
				var getRegNobyEpisodeID=document.getElementById("getRegNobyEpisodeID").value;
				var retStr=cspRunServerMethod(getRegNobyEpisodeID,EpisodeID);
			
				if (retStr!="")	{objRegNo.value=retStr;}
			}
			else objRegNo.value="";
		}
		preRegNo=objRegNo.value;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCLINGYAODETAIL";	  
	parent.frames['RPbottom'].document.location.href=lnk	;
	var chec=document.getElementById("typ");
	  var checAudit=document.getElementById("Audittyp");    //xuqy070123
	  var AuditMed=document.getElementById("AuditMed");
	  if((chec.checked==true)||(checAudit.checked==true)){
		  AuditMed.style.visibility ="hidden";
	  }
	  else{
		  AuditMed.style.visibility ="visible";
	  }
    //var obj=document.getElementById("dateInfo")
    //if (obj){obj.value=StDate+"-"+EDate;obj.disabled=true}
    //SearchClick();
}
function getwardid(str)
{
	var obj=document.getElementById('ward');
	var tem=str.split("^");
	obj.value=tem[1];
	var obj=document.getElementById('warddes');
	obj.value=tem[0];
	return;
}
function SearchClick()
{
	  var StDate=document.getElementById("StDate").value ;
	  var EDate=document.getElementById("EDate").value;
	  var ward=document.getElementById("ward").value ;
	  var ArRow="";//document.getElementById("ArRowz"+row).innerText ;
	  var chec=document.getElementById("typ");
	  var checAudit=document.getElementById("Audittyp");    //xuqy070123
	  var dep=document.getElementById("dep").value ;
	  var Roll=document.getElementById("RollOrd"); 
	  var typ,RollFl,UnPayFlage
	  if (chec.checked==true)
	  {
		 typ="on";
	  }
	  else
	  {
		typ="";
	  }
	  if (Roll){
	  			if (Roll.checked==true)
	  			{
		 			RollFl="on";
	  			}
	  			else
	  			{
					RollFl="";
	  			}
	  }
	  else
	  	{
			RollFl="";
	  	}
	var auditBatch=document.getElementById("auditBatch");
	if(auditBatch)
	{
		var locId=session["LOGON.CTLOCID"];
		var Index=auditBatch.selectedIndex;
		if (Index!=-1)	var auditBatchId=auditBatch.options[Index].value;
		else var auditBatchId=""
	}else
	{
		var auditBatchId=""
	}
	if(auditBatchId!="")
	{
		var objAudit=document.getElementById("auditBatchId");
		if(objAudit) objAudit.value=auditBatchId
	}
	  var objOrdFlag=document.getElementById("tempOrdFlag");
	  if (objOrdFlag.checked==true) {tempOrdFlag="on";}else{tempOrdFlag="";}
	  var objUnPayFlage=document.getElementById("UnPayFlage");
	  if(objUnPayFlage)
	  {
		  if (objUnPayFlage.checked==true) {UnPayFlage="on";}else{UnPayFlage="";}
	  }
	  else
	  {
		  UnPayFlage="";
	  }
	  var objAllFlage=document.getElementById("AllFlage");
	  if(objAllFlage)
	  {
		  if (objAllFlage.checked==true) {AllFlage="on";}else{AllFlage="";}
	  }
	  else
	  {
		  AllFlage="";
	  }
	  var userId=session["LOGON.USERID"];
	  var locId=session["LOGON.CTLOCID"];
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCNURUNPACKED&userId="+userId+"&locId="+locId+"&std="+StDate+"&edd="+EDate+"&ArRow="+ArRow+"&typ="+typ+"&dep="+dep+"&tempOrdFlag="+tempOrdFlag+"&RollFl="+RollFl+"&UnPayFlage="+UnPayFlage+"&AllFlage="+AllFlage;	  
	//parent.frames['RPLbottom'].document.location.href=lnk	;
	Find_click();
}
function Audit_Click()
{
	var PrgAudit=document.getElementById("PrgAuditMed").value ;
	var ward=document.getElementById("ward").value ;
	var Process=document.getElementById("Processz"+1);
	var dep=document.getElementById("dep").value ;
	
	var ProcessValue;
    if (Process) 
    {
	    ProcessValue=Process.innerText;
	    }
    else
    {
	    return;
	    }


    var userid=session['LOGON.USERID'];
    // + wxl 090331	begin
    var objtbl=document.getElementById('tDHCNURSEFAYAO');
	var ArRowStr="";
	for (i=1;i<objtbl.rows.length;i++)
	{
	   var item=document.getElementById("seleitemz"+i);
	   if (item.checked==true)
       {
           	var ArRow=document.getElementById("ArRowz"+i).innerText;
           	if (ArRowStr.length==0){ArRowStr=ArRow}
       		else{ArRowStr=ArRowStr+"^"+ArRow}
	   }
	}
	if (ArRowStr.length<0) return;
    // + end
    //alert(locId+","+StDate+","+EDate+","+typ+","+userid+","+ProcessValue+","+dep+","+tempOrdFlag)
    // ward As %String, std As %String, edd As %String, typ As %String = "", UserId As %String
    //alert(ArRowStr+"@"+userid+"@"+ProcessValue)
    var ret=cspRunServerMethod(PrgAudit,userid,ProcessValue,ArRowStr);
    if (ret=="0"){alert("OK!");}
    else alert(ret);  //出错信息
	Find_click();

}
function SendMsg_Click()
{
	var ward=document.getElementById("ward").value ;
    var SavMsg=document.getElementById("SavMsg").value ;
    var warddes=document.getElementById("warddes").value;
    var Process=document.getElementById("Processz"+1).innerText;
    var userid=session['LOGON.USERID'];
	var ret=cspRunServerMethod(SavMsg,ward,warddes,userid,Process);
	if (ret==0)    //WardId,Ward,UserId,Process
	alert("OK");
}
function PrintFaYao()  //
{
  var fileName,path;
  var xlsExcel,xlsBook,xlsSheet;
  var row=0;
  var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
  var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
  var objtbl=document.getElementById('tDHCNURSEFAYAO');
  //fileName=path+ fileName;
  var type="领药";
  var warddes=document.getElementById("warddes").value;
  path=GetFilePath();
  fileName=path+"NURLINGYAO.xls";
  //fileName="D:\\HSMB\\NURLINGYAO.xls";
  xlsExcel = new ActiveXObject("Excel.Application");
	    //alert("also ok")
  xlsBook = xlsExcel.Workbooks.Add(fileName) ;//;Open(fileName)
  xlsSheet = xlsBook.ActiveSheet; //  Worksheets(1)
  	for (i=1;i<objtbl.rows.length;i++)
	{
	    var LocDes=document.getElementById("LocDescz"+i).innerText;
        var Arcim=document.getElementById("Arcimz"+i).innerText;
        var Qty=document.getElementById("Qtyz"+i).innerText;
        var Uom=document.getElementById("Uomz"+i).innerText;
        row=row+1;
	    if (row==1)
	    {
		 i=i-1
	    row=titleLable(xlsSheet,type,row,warddes);
	    xlsSheet.cells(row,1)="药房";
	    xlsSheet.cells(row,2)="药品";
	    xlsSheet.cells(row,3)="数量";
	    xlsSheet.cells(row,4)="单位";
	   	    
		}
		else
		{
	    xlsSheet.cells(row,1)=LocDes;
	    xlsSheet.cells(row,2)=Arcim;
	    xlsSheet.cells(row,3)=Qty;
	    xlsSheet.cells(row,4)=Uom;
	    }
	}
       var CenterHeader = "";
       var LeftHead="";
        titleRows=0;
        titleCols=0;
        RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = "第 &P 页,共 &N 页";
       // ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 

        gridlist(xlsSheet,3,row,1,4);
        xlsExcel.Visible = true
        xlsSheet.PrintPreview 
        //xlsSheet.PrintOut(); 

        //xlsSheet = null;
        xlsBook.Close(savechanges=false)
        xlsBook = null;
        xlsExcel.Quit();

}
 function GetFilePath()
  {   var GetPath=document.getElementById("GetPath").value;
      var path=cspRunServerMethod(GetPath);
      return path;
  }
function titleLable(xlsSheet,type,Row,warddes)
{
	    mergcell(xlsSheet,Row,1,4);
        fontcell(xlsSheet,Row,1,4,12);
        xlcenter(xlsSheet,Row,1,4);
        CenterHeader = "潍坊人民医院" + type + "清单";
        xlsSheet.cells(Row,1)=CenterHeader;
        Row=Row+1;
        mergcell(xlsSheet,Row,1,4);
        xlsSheet.cells(Row,1)="病区:"+warddes;
        FontStyle(xlsSheet,Row+1,1,4,10);
        return Row+1;

}
function RowChanged()
{ //current row
 /// var obj=document.getElementById("t"+"dhcpha_dispquerygenerally")
  var row=DHCWeb_GetRowIdx(window) ;
  if (row>0)
  {
	  var ArRow=document.getElementById("ArRowz"+row).innerText ;
	  var Process=document.getElementById("Processz"+row).innerText ;
	  var recLocId=document.getElementById("recLocIdz"+row).innerText ;
	  var userId=session["LOGON.USERID"];
	  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCLINGYAODETAIL&userId="+userId+"&process="+Process+"&ArRow="+ArRow+"&recLocId="+recLocId;	  
	  parent.frames['RPbottom'].document.location.href=lnk;
	  
}
	
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
function AdjDateTime(souceDateTime,adjSecond) 
{ 	
	var tmpList=souceDateTime.split("/");
	if (tmpList.length>2){
    	var curDate=new Date(tmpList[2],tmpList[1]-1,tmpList[0]);
	}
    else{var curDate=new Date();
    }
    var curDateVal=curDate.getTime();
    curDateVal=curDateVal+adjSecond*1000;
    curDate.setTime(curDateVal);
	return curDate
}
function RegNoKeyDown()
{
	if ((event.keyCode==13)) RegNoBlur();
}
function RegNoBlur()
{
	var i;
    var objRegNo=document.getElementById("regNo");
	var isEmpty=(objRegNo.value=="");
    var oldLen=objRegNo.value.length;
	if (!isEmpty) {  //add 0 before regno
	    for (i=0;i<10-oldLen;i++)
	    {
	    	objRegNo.value="0"+objRegNo.value  
	    }
	}
	if (objRegNo.value!=preRegNo) 
	{
		objIfChangeRegNo.value="Yes";
		preRegNo=objRegNo.value;
	}
}
function Ctloc(str)
{
	var obj=document.getElementById('RecLocId');
	var tem=str.split("^");
	if (obj.value!=tem[1]){obj.value=tem[1];}

}
function ArcimFun(str)
{
	var obj=document.getElementById('ArcimID');
	var tem=str.split("^");
	if (obj.value!=tem[1]){obj.value=tem[1];}

}
function All_Click()
{
	var objUnPayFlage=document.getElementById("UnPayFlage");
	var objAllFlage=document.getElementById("AllFlage");
	if(objAllFlage){
		if(objAllFlage.checked==true){
			if(objUnPayFlage){objUnPayFlage.checked=false}
		}
	}

}
function UnPay_Click()
{
	var objUnPayFlage=document.getElementById("UnPayFlage");
	var objAllFlage=document.getElementById("AllFlage");
	if(objUnPayFlage){
		if(objUnPayFlage.checked==true){
			if(objAllFlage){objAllFlage.checked=false}
			//var regLookUp=document.getElementById("ld50696iregNo")
			//if(regLookUp)  regLookUp.style.display ="block";
		}
		/*else
		{
			var regLookUp=document.getElementById("ld50696iregNo")
			if(regLookUp)  regLookUp.style.display ="none";
		}*/
	}
}
function AuditBatch(retStr)
{
	var batchStr=retStr.split("|");
	var auditBatch=document.getElementById("auditBatch");
	if(auditBatch)
	{
		auditBatch.size=1; 
		auditBatch.multiple=false;
		if (batchStr=="") return;
		for (var i=0;i<auditBatch.length;i++)
		{
			auditBatch.remove(i);
		}
		auditBatch.options[0]=new Option("","");
		for (var i=0;i<batchStr.length;i++)
		{
			if (batchStr[i]=="") {}
			else{
				var batch;
				batch=batchStr[i].split("^");
				var sel=new Option(batch[1],batch[0]);
				auditBatch.options[auditBatch.options.length]=sel;
	 		}
		}
		auditBatch.selectedIndex=0;
	}
}
function SelectAll_Click()
{
  var obj=document.getElementById("SelectAll");
  var Objtbl=document.getElementById('tDHCNURSEFAYAO');
  var Rows=Objtbl.rows.length;
  for (var i=1;i<Rows;i++){
	var selobj=document.getElementById('seleitemz'+i);  
	selobj.checked=obj.checked;  
	}
}
document.body.onload = BodyLoadHandler;
