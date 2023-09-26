var currentRow ;
var stktype ;
var mainrowid="";
var validatedUser;
var xxxxxx;

function BodyLoadHandler()
{ 
// var obj=document.getElementById("Find")
// if (obj) obj.onclick=FindReq;
 var obj=document.getElementById("Clear")
 if (obj) obj.onclick=Clear;
 var obj=document.getElementById("Collect")
 if (obj) obj.onclick=ReqCollect;
 var obj=document.getElementById("Disp")
 if (obj) obj.onclick=ReqDisp;
 

 var obj=document.getElementById("PrintReq")
 if (obj) obj.onclick=PrintReq;
 
 var obj=document.getElementById("PrintReqOrd")
 if (obj) obj.onclick=PrintReqOrd;
 
 var obj=document.getElementById("saveDM")
 if (obj) obj.onclick=ExportReqOrd;

 //alert(window.location.href);
 
var obj=document.getElementById("ReqLoc"); //
if (obj) 
{obj.onkeydown=popReqLoc;
 obj.onblur=ReqLocCheck;
} //
 
var obj=document.getElementById("ProvLoc"); //
if (obj) 
{obj.onkeydown=popProvLoc;
 obj.onblur=ProvLocCheck;
} //

 if ( getBodyLoaded()!='1') setDefaults();

 //get stock type code
 var obj=document.getElementById("StkType");
 if (obj) stktype=obj.value;
 //get stock type code
 //alert(stktype)
 setVisible();
 
 var objx=document.getElementById("Find");
 if (objx)
  {
	  var bodyloaded=getBodyLoaded();
	 // alert(bodyloaded)  ;
  	  if (bodyloaded!='1')  
  	   {
   		setBodyLoaded();
	  	objx.click();
  	   }
  }
  var objtbl=document.getElementById("t"+"dhcpha_transreqqueryColl");
 var cnt=getRowcount(objtbl);
 if (cnt>0)
 { 
  HighlightRow_OnLoad("TReqNo"+"z"+cnt);   
  }
 else {
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transreqqueryitm" ;
		parent.frames['dhcpha.transreqqueryitm'].window.document.location.href=lnk;}


}
 function popReqLoc()
 {	if (window.event.keyCode==13) 
	{  	window.event.keyCode=117;
	  ReqLoc_lookuphandler();
	}
 }
 function ReqLocCheck()
 {	// 
	var obj=document.getElementById("ReqLoc");
	var obj2=document.getElementById("ToLocDR");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
 }
 function popProvLoc()
 {	if (window.event.keyCode==13) 
	{  	window.event.keyCode=117;
	  ProvLoc_lookuphandler();
	}
	 }	 
function ProvLocCheck()
 {	var obj=document.getElementById("ProvLoc");
	var obj2=document.getElementById("FrLocDR");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}

 }

function setDefaults()
{   //default date
	var dd=today();
	var obj=document.getElementById("StartDate");
	if (obj) obj.value=dd;
	//if (obj) obj.value=getRelaDate(-15);
	var obj=document.getElementById("EndDate");
	if (obj) obj.value=dd;
	
	// default loc
	var userid=session['LOGON.USERID'] ;
	var obj=document.getElementById("mGetDefaultLoc") ;
	
	//if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	//var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;
	
	//var obj=document.getElementById("BodyLoaded")
	//if (obj) 
	//{obj.value='1'  ;}	
	}
function getBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded")
	if (obj) return obj.value;
}
function setDefLoc(value)
{
	var defloc=value.split("^");
	if (defloc.length>0)
	var locdr=defloc[0] ;
	var locdesc=defloc[1] ;
	if (locdr=="") return ;
	var obj=document.getElementById("ReqLoc") ;
	if (obj) obj.value=locdesc
	var obj=document.getElementById("ToLocDR") ;
	if (obj) obj.value=locdr
}
function setBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded") ;
	if (obj) obj.value=1;
}
function FindReq()
{}
function Clear()
{
	var collflag="";
	var obj=document.getElementById("CollFlag");
	if (obj) collflag=obj.value;
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transreqqueryColl"+"&StkType="+stktype+"&CollFlag="+collflag
	window.location.href=lnk;	
	   
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transreqqueryitm"
	parent.frames['dhcpha.transreqqueryitm'].window.document.location.href=lnk;
	
}

function ifComplete(row)
{		var obj=document.getElementById("TComp"+"z"+row);
		if ((obj)&&(obj.checked))  complete='1';
		else complete='0'
		
	return complete
	}

function ReqLocLookUpSelect(str)
{
  var ctloc=str.split("^");
  var obj=document.getElementById("ToLocDR")
  if (obj) obj.value=ctloc[1];
}
function ProvLocLookUpSelect(str)
{
  var ctloc=str.split("^");
  var obj=document.getElementById("FrLocDR")
  if (obj) obj.value=ctloc[1];
}

function SelectRowHandler() {
	
	var row=selectedRow(window);
	currentRow=row
	if (currentRow>0)
	 {
		var obj=document.getElementById("TReqRowid"+"z"+row)
		if (obj) 
		{mainrowid = obj.value;		}
		else
		{mainrowid="";}
	}
	else
	{mainrowid="";}
	 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transreqqueryitm&Rowid="+mainrowid ;
		parent.frames['dhcpha.transreqqueryitm'].window.document.location.href=lnk;
}
function setUser(user)
{
	validatedUser=user;
}
function ValidUserID()
{
 	var pwd="";
    var userRowid=""
    var CollFlag;
    var obj=document.getElementById("CollFlag")
    if (obj) CollFlag=obj.value;
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.SetReqColl&CollFlag="+CollFlag;
	validatedUser="";
    var ret=showModalDialog(lnk,window,"Width:100;Height:200;center:yes;scroll:no;");
    return validatedUser;
}
function ReqCollect()
{
	var pyobj=document.getElementById("TCollectUser"+"z"+currentRow);
	if (trim(pyobj.innerText)!=""){
		alert("该请求单已配药!");
		return;
	}
	var exe=""
	var obj=document.getElementById("mSetReqCollect");
	if (obj) exe=obj.value ;
	if (mainrowid!="")
	{
	  //var user=session['LOGON.USERID'];
	  var user=ValidUserID();
	  if (user=="") return ;
	  
	  //执行生成库存转移单并审核(outcheck,incheck)
	  
	  var ExeCreateAndAudit=""
	  var obj=document.getElementById("mCreateAndAuditTrans");
	  if (obj) ExeCreateAndAudit=obj.value;
	  if (ExeCreateAndAudit!="")
	  {
		 // alert(ExeCreateAndAudit);
		  var res=cspRunServerMethod(ExeCreateAndAudit,mainrowid,user)	;
		  if (res!="")
		  { alert(res);
		    return ;
		  }
	   }
	   var result=cspRunServerMethod(exe,mainrowid,user)	;
	    var objx=document.getElementById("Find");
	    objx.click();

	}
	
}
function ReqDisp()
{
	var fyobj=document.getElementById("TDispUser"+"z"+currentRow);
	if (trim(fyobj.innerText)!=""){
		alert("该请求单已发药!");
		return;
	}
	var exe=""
	var obj=document.getElementById("mSetReqDisp");
	if (obj) exe=obj.value ;
	
	if (mainrowid!="")
	{
	 // var user=session['LOGON.USERID'];
	 var user=ValidUserID();
	 if (user=="") return ;
	 var result=cspRunServerMethod(exe,mainrowid,user)	;
	 if (result=="-3"){alert("请求单错误！");return;}
	 else if (result=="-4"){alert("请求单未配药！");return;}
	 else if (result=="-5"){alert("请求单已发药！");return;}
	  var objx=document.getElementById("Find");
	   objx.click();
	}
}
function setVisible()
{
	var CollFlag;
	var obj=document.getElementById("CollFlag");
	if (obj) CollFlag=obj.value; 
	if (CollFlag=="C")
	{ 
	 var objtitle=document.getElementById("title");
	 if (objtitle) objtitle.innerText="请求单配药确认";
	 window.document.all('Collect').style.display=""  ;
	 window.document.all('Disp').style.display="none"  ;	
     window.document.all('IncludeOperated').style.display="" ;
     window.document.all('IncludeDispensed').style.display="none" ;
     window.document.all('cIncludeOperated').style.display=""; 
     window.document.all('cIncludeDispensed').style.display="none" ;
	 		}
	else
	{
	 var objtitle=document.getElementById("title");
	 if (objtitle) objtitle.innerText="请求单发药确认";
	 window.document.all('Collect').style.display="none"  ;
	 window.document.all('Disp').style.display=""  ;		
     window.document.all('IncludeOperated').style.display="none" ;
     window.document.all('IncludeDispensed').style.display="" ;
     window.document.all('cIncludeOperated').style.display="none"; 
     window.document.all('cIncludeDispensed').style.display="" ;
	}
}


function PrintReq()
{
 var fyobj=document.getElementById("TDispUser"+"z"+currentRow);
 var dispuser=""
 if(obj) {dispuser=fyobj.innerText}	
 if (mainrowid>0) 
 {
   var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.printBddReq"+"&PrtSumFlag=1"+"&ReqRowID="+mainrowid+"&DispUser="+dispuser;
   var lnk=lnk+"&AllowRePrintFlag=1"
   //alert(lnk);
   parent.frames['dhcpha.printBddReq'].window.document.location.href=lnk;
  } 		
  SetValPrint()
}
function PrintReqOrd()
{ 
 var fyobj=document.getElementById("TDispUser"+"z"+currentRow);
 var dispuser=""
 if(obj) {dispuser=fyobj.innerText}	
 if (mainrowid>0) 
 {
   var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.printBddReq"+"&PrtSumFlag=0"+"&ReqRowID="+mainrowid+"&DispUser="+dispuser;
   var lnk=lnk+"&AllowRePrintFlag=1"
   parent.frames['dhcpha.printBddReq'].window.document.location.href=lnk;
  } 
 SetOrdValPrint()

}	
function ExportReqOrd()
{
	if (mainrowid>0) 
 {
   var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.printBddReq"+"&PrtSumFlag=0"+"&ReqRowID="+mainrowid;
   var lnk=lnk+"&AllowRePrintFlag=1"+"&saveExcelFlag=1"
   parent.frames['dhcpha.printBddReq'].window.document.location.href=lnk;
  }
  SetValPrint()	
}

function SetOrdValPrint(){
  var obj=document.getElementById("TReqType"+"z"+currentRow)
  var obj2=document.getElementById("TPrintFlag"+"z"+currentRow)
  var obj3=document.getElementById("TPrtDate"+"z"+currentRow)
  var obj4=document.getElementById("TPrtTime"+"z"+currentRow)
  var printdatetime=getPrintDateTime()
  var datetime=printdatetime.split(" ")
  var printdate=datetime[0]
  var printtime=datetime[1]
  if (obj.innerText=="精神毒麻补货"){
	  obj2.innerText="是";
	  if (trim(obj3.innerText)==""){
		  obj3.innerText=printdate
	  }
      if (trim(obj4.innerText)==""){   
          obj4.innerText=printtime
      }
  }	
}

function SetValPrint()
{
  var obj=document.getElementById("TReqType"+"z"+currentRow)
  var obj2=document.getElementById("TPrintFlag"+"z"+currentRow)
  var obj3=document.getElementById("TPrtDate"+"z"+currentRow)
  var obj4=document.getElementById("TPrtTime"+"z"+currentRow)
  var printdatetime=getPrintDateTime()
  var datetime=printdatetime.split(" ")
  var printdate=datetime[0]
  var printtime=datetime[1]
  if ((obj.innerText=="基数补货")||(obj.innerText=="大输液补货"))
   {
     if (trim(obj3.innerText)==""){
        obj3.innerText=printdate
         }
     if (trim(obj4.innerText)==""){   
       obj4.innerText=printtime
     }
    }	
}
	
document.body.onload=BodyLoadHandler
