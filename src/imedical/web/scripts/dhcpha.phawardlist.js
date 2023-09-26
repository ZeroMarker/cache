var timer;

function BodyLoadHandler()
{
  	var obj=document.getElementById("StartTimer");
	if (obj) obj.onclick=TimerHandler; 

	var obj=document.getElementById("Exit");
	if (obj) obj.onclick=ExitClick; 
	
	var objtbl=document.getElementById("t"+"dhcpha_phawardlist");
	if (objtbl) 
	{objtbl.ondblclick=RetrieveDisp;	}
	
	if (getBodyLoaded()!="1")
	{	
		GetDefLoc()	;
		getDefDateScope();
		setBodyLoaded();
	}
	
  	if (getTimerFlag()==1) 
  	{
  		Start(); }  	
}

function RetrieveDisp()
{	var row;
	var obj=document.getElementById("CurrentRow") ;
	if (obj) row=obj.value;
	if (row>0) 
	{
		var displocrowid ;
		var wardrowid ;
		var  StartDate ;
		var  EndDate ;
		var Userid  ;
		var ByWardFlag  ;
		var LongOrdFlag  ;
		var  ShortOrdFlag ;
		var OutWithDrugFlag ;
		var DispCat  ;
		var Adm  ;
		var DoctorLocRowid ;
		var NotAudit;
		
		var obj=document.getElementById("StartDate")
		if (obj) sd=obj.value;
		var obj=document.getElementById("EndDate")
		if (obj) ed=obj.value;
		//var obj=document.getElementById("DispLoc")
		//if (obj) disploc=obj.value;
		var obj=document.getElementById("displocrowid")
		if (obj) displocrowid=obj.value;

	//	var obj=document.getElementById("TWard"+"z"+row)
	//	if (obj) ward=obj.innerText ;
		var obj=document.getElementById("TWardRowid"+"z"+row)
		if (obj) wardrowid=obj.value ;
	}
}

function BodyBeforeUnLoadHandler()
{Stop();	}
function ExitClick()
{
	window.close();	
	}
function TimerHandler()
{
	var obj=document.getElementById("StartTimer") ;
	if (obj)
	 {
		 if (obj.checked==true)
			 {Start(); }
		 else
			  {Stop(); }
	 }
}

function Start()
{
	setTimerFlag(1);
	timer=setInterval("OnTimer()",30000); 
}
function Stop()
{	
	clearInterval(timer);
	setTimerFlag(0);
}
	
function getDefDateScope()
{
	var obj=document.getElementById("StartDate");
	if (obj) obj.value=today()
	var obj=document.getElementById("EndDate");
	if (obj) obj.value=today()
	
	}
function OnTimer(){ 

   if (getTimerFlag()!=1) return ;
   
   var obj=document.getElementById("displocrowid");
   if (obj) var xdisplocrowid=obj.value;
   var obj=document.getElementById("DispLoc");
   if (obj) var xDispLoc=obj.value;
   var obj=document.getElementById("StartDate");
   if (obj) var xStartDate=obj.value;
   var obj=document.getElementById("EndDate");
   if (obj) var xEndDate=obj.value;
   var obj=document.getElementById("timerflag");
   if (obj) var xtimerflag=obj.value;
  var obj=document.getElementById("bodyloaded");
   if (obj) var xbodyloaded=obj.value;
   
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phawardlist&DispLoc="+xDispLoc+"&displocrowid="+xdisplocrowid+"&StartDate="+xStartDate+"&EndDate="+xEndDate+"&timerflag="+xtimerflag+"&bodyloaded="+xbodyloaded
	document.location.href=lnk ;
  
}

function FindClick()
{
	Find_click();
}

function setBodyLoaded()
{
	var obj=document.getElementById("bodyloaded") ;
	if (obj) obj.value="1"
	
}

function GetDefLoc()
{		
	//alert(BodyLoaded);
	var userid=session['LOGON.USERID'] ;
	var obj=document.getElementById("mGetDefaultLoc") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;
}
function setDefLoc(value)
{
	var defloc=value.split("^");
	if (defloc.length>0)
	var locdr=defloc[0] ;
	var locdesc=defloc[1] ;
	if (locdr=="") return ;
	var obj=document.getElementById("DispLoc") ;
	if (obj) obj.value=locdesc
	var obj=document.getElementById("displocrowid") ;
	if (obj) obj.value=locdr
	
}
function DispLocLookUpSelect(str)
{ 
	var loc=str.split("^");
	var obj=document.getElementById("displocrowid");
	if (obj)
	{if (loc.length>0)   obj.value=loc[1] ;
		else	obj.value="" ;  
	}
}
function setTimerFlag(b)
{
	var obj=document.getElementById("timerflag") ;
	if (obj) obj.value=b;
}
function getTimerFlag()
{
	var obj=document.getElementById("timerflag") ;
	if (obj) 
	{ 
	return obj.value}
}
function setBodyLoaded()
{
	var obj=document.getElementById("bodyloaded") ;	
	if (obj) 
	{obj.value="1" ;

	}
}
function getBodyLoaded()
{
	var obj=document.getElementById("bodyloaded") ;	
	if (obj) {
	return obj.value ; }
}

function SelectRowHandler() {
	var row=selectedRow(window);
	var obj=document.getElementById("CurrentRow") ;
	if (obj) obj.value=row
	
	RetrieveDispDetail()
}

function RetrieveDispDetail()
{  var lnk ;
	
	var row=document.getElementById("CurrentRow") ;
	if (row>=1) 
	{
	
		
	}
	
}
document.body.onload=BodyLoadHandler;
document.body.onbeforeunload=BodyBeforeUnLoadHandler;
