var currentRow ;
var stktype ;
function BodyLoadHandler()
{ 
// var obj=document.getElementById("Find")
// if (obj) obj.onclick=FindReq;
 var obj=document.getElementById("Clear")
 if (obj) obj.onclick=Clear;
 var obj=document.getElementById("New")
 if (obj) obj.onclick=NewReq;
 var obj=document.getElementById("Modify")
 if (obj) obj.onclick=ModifyReq;

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
 var obj=document.getElementById("StkType")
 if (obj) stktype=obj.value;
 //get stock type code
 //alert(stktype)
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
	var obj=document.getElementById("EndDate");
	if (obj) obj.value=dd;
	
	// default loc
	var userid=session['LOGON.USERID'] ;
	var obj=document.getElementById("mGetDefaultLoc") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;
	
	var obj=document.getElementById("BodyLoaded")
	if (obj) 
	{obj.value='1'  ;}	
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
	if (currentRow>0){
		var complete;
		complete=ifComplete(currentRow);
		if (complete=='1')
		{			alert(t['COMPLETED']) ;
			return;			}
		var obj=document.getElementById("TReqRowid"+"z"+currentRow);
		rowid=obj.value;
		
		var obj=document.getElementById("TReqNo"+"z"+currentRow);
		var reqno=obj.innerText;
		
		var stkcatcode=reqno.substr(0,reqno.length-9);  
		//alert(stkcatcode);
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transferreq&Rowid="+rowid+"&StkType="+stktype+"&StkCatGrpCode="+stkcatcode
		window.open(lnk,"TARGET","width=1000,height=600");
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
	
	window.open(lnk,"TARGET","width=1000,height=600");
//	window.open(lnk);
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
	var mainrowid;
	//alert(row);
	var obj=document.getElementById("TReqRowid"+"z"+row)
	if (obj) 
	{mainrowid = obj.value;		}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transreqqueryitm&Rowid="+mainrowid ;
	parent.frames['dhcpha.transreqqueryitm'].window.document.location.href=lnk;
}


document.body.onload=BodyLoadHandler
