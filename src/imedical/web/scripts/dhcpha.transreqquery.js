var currentRow ;
var stktype ;
var mainrowid;
var gReqType;
var dispuser
function BodyLoadHandler()
{ 
// var obj=document.getElementById("Find")
// if (obj) obj.onclick=FindReq;
 var obj=document.getElementById("Clear");
 if (obj) obj.onclick=Clear;
 var obj=document.getElementById("New");
 if (obj) obj.onclick=NewReq;
 var obj=document.getElementById("Modify");
 if (obj) obj.onclick=ModifyReq;
 var obj=document.getElementById("PrintReq");
 if (obj) obj.onclick=PrintReq;

 var obj=document.getElementById("PrintReqOrd");
 if (obj) obj.onclick=PrintReqOrd;

 var obj=document.getElementById("RequestByBaseDrug");
 if (obj) obj.onclick=CreateRequestByBaseDrug;

 var obj=document.getElementById("RequestJSDM");
 if (obj) obj.onclick=CreateRequestJSDM;
 
 var obj=document.getElementById("RequestDSY");
 if (obj) obj.onclick=CreateRequestDSY;
 
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
  if ( getBodyLoaded()!='1') 
  {
	  var obj=document.getElementById("Find");
	  if (obj)
	  {setBodyLoaded();
	   obj.click(); 
	  }
  }
 //get stock type code
 var obj=document.getElementById("StkType")
 if (obj) stktype=obj.value;
 //get stock type code
 //alert(stktype)
 setBodyLoaded();
 var objtbl=document.getElementById("t"+"dhcpha_transreqquery");
 var cnt=getRowcount(objtbl);
 if (cnt>0)
 {   HighlightRow_OnLoad("TReqNo"+"z"+cnt);   
  } 
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
	{  	
		window.event.keyCode=117;
		window.event.isLookup=true;
	    ProvLoc_lookuphandler(window.event);
	}
	 }	 
function ProvLocCheck()
 {	var obj=document.getElementById("ProvLoc");
	var obj2=document.getElementById("FrLocDR");
	if (obj) 
	{if (obj.value=="") obj2.value=""	;	}

 }

function setDefaults()
{   //default date
	var dd=today();
	var obj=document.getElementById("StartDate");
	//;if (obj) obj.value=dd;
	if (obj) obj.value=getRelaDate(-10);
	var obj=document.getElementById("EndDate");
	if (obj) obj.value=dd;
	
	// default loc
	var userid=session['LOGON.USERID'] ;
	//var obj=document.getElementById("mGetDefaultLoc") ;
	//if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	//var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;

	}
function getBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded");
	if (obj) return obj.value;
}
function setBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded");
	if (obj) 
	{obj.value='1'  ;}	
	}
function setDefLoc(value)
{
	var defloc=value.split("^");
	if (defloc.length>0)
	var locdr=defloc[0] ;
	var locdesc=defloc[1] ;
	if (locdr=="") return ;
	var obj=document.getElementById("ReqLoc") ;
	if (obj) obj.value=locdesc;
	var obj=document.getElementById("ToLocDR") ;
	if (obj) obj.value=locdr;
}

function FindReq()
{}
function Clear()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transreqquery"+"&StkType="+stktype
	window.location.href=lnk;	
	   
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transreqqueryitm"
	parent.frames['dhcpha.transreqqueryitm'].window.document.location.href=lnk;
	
}
function ModifyReq()
{
	//alert(currentRow)
	if (currentRow>0){
		var complete;
		complete=ifComplete(currentRow);
		if (complete=='1')
		{			alert(t['COMPLETED']) ;  // The request is already completed and not allowed to be modifed
			return;			}

		var reqType="";
		var obj=document.getElementById("TReqType"+"z"+currentRow);
		if (obj) reqType=obj.innerText;
		if (reqType=="精神毒麻补货")
		{
			alert('精神毒麻补货请求单禁止修改!');
			return ;		}
		
		var obj=document.getElementById("TReqRowid"+"z"+currentRow);
		rowid=obj.value;
		
		var obj=document.getElementById("TReqRowid"+"z"+currentRow);
		rowid=obj.value;
		
		var obj=document.getElementById("TReqNo"+"z"+currentRow);
		var reqno=obj.innerText;
		
		var stkcatcode=reqno.substr(0,reqno.length-9);  
		//alert(stkcatcode);
		
 		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transferreq&Rowid="+rowid+"&StkType="+stktype+"&StkCatGrpCode="+stkcatcode
		
		if (reqType=="大输液补货"){
			var EditType="ADD" ;
			var gReqType="3";
			} 
		else if (reqType=="基数补货")
		    {var EditType="";
		     var gReqType="1";}

		lnk=lnk+"&EditType="+EditType
		lnk=lnk+"&ReqType="+reqType   //gReqType
	
		window.open(lnk,"_blank","width=1000,height=800,menubar=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
	  
		//window.open(lnk);

	  //window.open("dhcpha.transferReqInput.csp"+"?Rowid="+rowid+"&StkType="+stktype+"&StkCatGrpCode="+stkcatcode)
	  
	}
}
function ifComplete(row)
{		var obj=document.getElementById("TComp"+"z"+row);
		if ((obj)&&(obj.checked))  complete='1';
		else complete='0'
		
	return complete
	}
function NewReq()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transferreq&StkType="+stktype
	lnk=lnk+"&ReqType="+reqType  //gReqType;
	lnk=lnk+"&EditType=ADD";
	window.open(lnk,"transferInput","width=1050,height=600,menubar=no,status=yes,toolbar=no,center=true,scrollbars=yes,resizable=yes");
	//window.open(lnk,"transferInput","width=1000,height=800,menubar=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
	//window.showModelessDialog(lnk,"TARGET","dialogHeight:100;dialogWidth:800;menubar:no;status:yes;toolbar:no;resizable:yes");
 	//window.open(lnk);
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
	//alert(row+"row");
	var obj=document.getElementById("TReqRowid"+"z"+row)
	if (obj) 
	{mainrowid = obj.value;	}
	else
	{mainrowid="";}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transreqqueryitm&Rowid="+mainrowid ;
	parent.frames['dhcpha.transreqqueryitm'].window.document.location.href=lnk;
}
function CreateRequestByBaseDrug()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transferRequestByBasedrug"+"&ICCode=BASEDRUG";
	window.open(lnk,"BBD","left=0,top=0,width="+screen.availWidth+",height="+screen.availHeight+",scrollbars=yes,resizable=yes");
}
function CreateRequestJSDM()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transferRequestByBasedrug"+"&ICCode=JSDM";
	window.open(lnk,"JSDM","left=0,top=0,width="+screen.availWidth+",height="+screen.availHeight+",scrollbars=yes,resizable=yes");
}

function CreateRequestDSY()
{
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transferRequestByBasedrug"+"&ICCode=DSY";
	//window.open(lnk,"DSY","left=0,top=0,width='+screen.availWidth+',height='+screen.availHeight+',scrollbars=yes,resizable=yes");
	gReqType="3";  //大输液
	reqType="大输液补货"
	NewReq();
}


function PrintReq()
{
 var fyobj=document.getElementById("TDispUserName"+"z"+currentRow);
 var dispuser=""
 if(obj) {dispuser=fyobj.innerText}	
 if (mainrowid>0) 
 {
   var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.printBddReq"+"&PrtSumFlag=1"+"&ReqRowID="+mainrowid+"&DispUser="+dispuser;
   var lnk=lnk+"&AllowRePrintFlag=0"
   //alert(lnk);
   parent.frames['dhcpha.printBddReq'].window.document.location.href=lnk;
   
  } 
  SetValPrint()	
	
}

function PrintReqOrd()
{
 var fyobj=document.getElementById("TDispUserName"+"z"+currentRow);
 var dispuser=""
 if(obj) {dispuser=fyobj.innerText}	
 if (mainrowid>0) 
 {
   var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.printBddReq"+"&PrtSumFlag=0"+"&ReqRowID="+mainrowid+"&DispUser="+dispuser;
   var lnk=lnk+"&AllowRePrintFlag=0"
   parent.frames['dhcpha.printBddReq'].window.document.location.href=lnk;
  } 
  SetOrdValPrint()	
}
function ReqTypeValue(rqtype)
{
	
}

function SetOrdValPrint()
{
  var obj=document.getElementById("TReqType"+"z"+currentRow)
  var reqtypetext=""
  if(obj) {reqtypetext=obj.innerText}
  var obj2=document.getElementById("TPrintFlag"+"z"+currentRow)
  var obj3=document.getElementById("TPrtDate"+"z"+currentRow)
  var obj4=document.getElementById("TPrtTime"+"z"+currentRow)
  var printdatetime=getPrintDateTime()
  var datetime=printdatetime.split(" ")
  var printdate=getPrintDate()
  var printtime=datetime[1]
  if (reqtypetext=="精神毒麻补货")
   { 
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
  var reqtypetext=""
  if(obj) {reqtypetext=obj.innerText}
  var obj2=document.getElementById("TPrintFlag"+"z"+currentRow)
  var obj3=document.getElementById("TPrtDate"+"z"+currentRow)
  var obj4=document.getElementById("TPrtTime"+"z"+currentRow)
  var printdatetime=getPrintDateTime()
  var datetime=printdatetime.split(" ")
  var printdate=getPrintDate()
  var printtime=datetime[1]
  if ((reqtypetext=="基数补货")||(reqtypetext=="大输液补货"))
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
