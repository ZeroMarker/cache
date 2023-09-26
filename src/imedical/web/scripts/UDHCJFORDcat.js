var regnoobj,nameobj,admobj
var Adm
function BodyLoadHandler() {
	regnoobj=document.getElementById('RegNo');
	nameobj=document.getElementById('name');
	admobj=document.getElementById('EpisodeID');
	ordcatobj=document.getElementById('ordcat');
	billobj=document.getElementById('Bill');
	clearobj=document.getElementById('Clear');
	notpaidobj=document.getElementById('notpaid');
	selectdateobj=document.getElementById('seldate');
	getnotpaidobj=document.getElementById('getnotpaid');
	getseldateobj=document.getElementById('getseldate');
	dateobj=document.getElementById('stdate');
	enddateobj=document.getElementById('enddate');
	guserobj=document.getElementById('Guser');
	findobj=document.getElementById('Find');
	printdetailobj=document.getElementById('printdetail');
    selstatusobj=document.getElementById('selstatus');
    getstatusobj=document.getElementById('getstatus');
    Guser=guserobj.value
	regnoobj.onkeydown = getpat;
	clearobj.onclick=clearall;
	notpaidobj.onclick=getnotpaidfun;
	selectdateobj.onclick=getseldatefun;
	billobj.onclick=bill;
	//findobj.onclick=Find;
	printdetailobj.onclick=Print;
	ordcatobj.onkeyup=clearordcatid;
	selstatusobj.onclick=selstatusfun;
	if (getnotpaidobj.value=="0") {notpaidobj.checked=true;}
	if (getnotpaidobj.value=="1") {notpaidobj.checked=false;}
	if (getseldateobj.value=="0") {selectdateobj.checked=false;}
	if (getseldateobj.value=="1") {selectdateobj.checked=true;}
	if (getstatusobj.value=="0") {selstatusobj.checked=true;}
	if (getstatusobj.value=="1") {selstatusobj.checked=false;}
	getstatusobj.value="1"
	ordcatobj.onkeydown=ordercatlook;
    //var tblobj=document.getElementById('tUDHCJFORDcat')
    //if (tblobj) tblobj.onclick=linksubwindows	    
    var confirmobj=document.getElementById('BtnConfirm')
    if (confirmobj) {confirmobj.onclick=confirm_click }
	var readcard=document.getElementById('readcard');
    if (readcard) readcard.onclick=readcard_click; 
    
    var obj=document.getElementById('OPCardType');
    if (obj){
	   obj.size=1
	   obj.multiple=false;
	   loadCardType()
	   obj.onchange=OPCardType_OnChange;
	}
 
  websys_setfocus('RegNo');
	
}

function getpat()
{   var key=websys_getKey(e);
	if (key==13) {
		 if (regnoobj.value!=""){
			p1=regnoobj.value
			alert(p1)
			var getregno=document.getElementById('getregno');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setpat_val','',p1)=='1'){
				};
	}
	}
}

function setpat_val(value)
	{
		var val=value.split("^");
		regnoobj.value=val[0];
		nameobj.value=val[1];
		admobj.value=val[2];
		Adm=admobj.value
	}
	
function getnotpaidfun()
{
	if (notpaidobj.checked==true) 
	{getnotpaidobj.value="0"}
	else
	{getnotpaidobj.value="1"}
	}
function getseldatefun()
{
	if (selectdateobj.checked==true) 
	{getseldateobj.value="1"}
	else
	{getseldateobj.value="0"}
	
	}
 function selstatusfun()
{
	if (selstatusobj.checked==true) 
	{getstatusobj.value="0"}
	else
	{getstatusobj.value="1"}
	}
function getordcatid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('getordcatid');
	obj.value=val[1];

}
function clearordcatid()
{
	var obj=document.getElementById('getordcatid');
	obj.value="";
	}
/*
function linksubwindows(){
   
   var eSrc=window.event.srcElement;
   var rowobj=getRow(eSrc)
   Objtbl=document.getElementById('tUDHCJFORDcat');
   var rowObj=getRow(eSrc);
   var selectrow=rowObj.rowIndex;
   alert(selectrow)
   if (eval(selectrow)<2) return;   
   alert("2err")
   
   var arcitm=document.getElementById('itmidz'+selectrow).value;
   alert("3err")
   var getnotpaid=document.getElementById('getnotpaid').value;
   alert("4err")
   var getstatus=document.getElementById('getstatus').value;
   alert("5err")
   var seldate=document.getElementById('getseldate').value;
   alert("6err")
   var oeord=document.getElementById('oeordz'+selectrow).innerText;
   alert("oeord="+oeord)
   alert("arcitm="+arcitm)
   alert("seldate="+seldate)
   if (seldate==1) {
      var stdate=document.getElementById('stdate').value
      var enddate=document.getElementById('enddate').value
   }else{
      var stdate=""
      var enddate=""   
   }
   var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOrdCatDetail&oeord='+oeord+'&arcitm='+arcitm+'&payflag='+getnotpaid+'&getstatus='+getstatus+'&stdate='+stdate+'&enddate='+enddate  //+'&sramount='+sramount
   window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=650,left=20,top=120')
      
}
*/
function clearall()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOrdCat";
	notpaidobj.checked=true;
}
function bill() {		
		Adm=admobj.value
		if (Adm&&Adm!=""){
			var WshNetwork = new ActiveXObject("WScript.NetWork");
			var computername=WshNetwork.ComputerName;
			p1=Adm;	
			var getmother=document.getElementById('getmotheradm');
			if (getmother) {var encmeth=getmother.value} else {var encmeth=''};
		   
		    if (cspRunServerMethod(encmeth,p1)=='true'){
					alert(t['03']);
					return;
				}
			p2=Guser;
			p3="";
			p4=computername;
			var getbill=document.getElementById('getbill');
			if (getbill) {var encmeth=getbill.value} else {var encmeth=''};
				
			if (cspRunServerMethod(encmeth,'','',p1,p2,p3,p4)=='0'){
					alert(t['01']);
				}
				else
				{alert(t['02']);}
			}
			if (regnoobj.value!=""){
			p1=regnoobj.value
			//p2=getnotpaidobj.value
			var getregno=document.getElementById('getregno');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setpat_val','',p1)=='1'){
				};
			
			}
	}
function Print()
{ Adm=admobj.value
  var getnum=document.getElementById('getbillnum'); 
  if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
  var str=cspRunServerMethod(encmeth,Adm)
  str=str.split("^")
  num=str[0]
  var BillNo=str[1]
  if (num==1)
  { 
    if (BillNo=="") {alert("BillNo is Null");return;}
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetail&BillNo='+BillNo
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
  }
  if (num>1)
  {	
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFPatBill&Adm='+Adm
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
  }
}
function ordercatlook()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  ordcat_lookuphandler();
		}
	}
function confirm_click()
{  
	if (admobj.value=="")
	{
		alert(t['07'])
		return
	}
	var confirmflag=document.getElementById('GetConfirm');
	if (confirmflag) {var encmeth=confirmflag.value} else {var encmeth=''};
    var retval=cspRunServerMethod(encmeth,admobj.value,Guser)
    if (retval=="")
    {   alert(t['05'])
        return 
    }
    if (retval=="Y")
    {   alert(['04'])
        return 
    }
    if (retval=="0")
    {
	    alert(t['06']) 
	    return
    }
 }
document.body.onload = BodyLoadHandler;