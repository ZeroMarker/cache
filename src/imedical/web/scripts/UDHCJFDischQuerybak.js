var path,wardid,warddesc,today;
var num,job
var medobj,finalobj,payflagobj,confirmflagobj
var medvalobj,finalvalobj,payflagvalueobj,confirmvalueobj
var wardobj,locobj
var myobj
var Adm,papno,name
var guser,BillNo,flag,admreason
function BodyLoadHandler() {
	medobj=document.getElementById('Medical');
	medvalobj=document.getElementById('Medval');
	finalobj=document.getElementById('Final');
	finalvalobj=document.getElementById('Finalval');
	payflagobj=document.getElementById('Payflag');
	payflagvalueobj=document.getElementById('payflagvalue');
	confirmflagobj=document.getElementById('confirmflag');
    confirmvalueobj=document.getElementById('confirmvalue');
    var Printdetailobj=document.getElementById('Printdetail');
    var printreceiptobj=document.getElementById('printreceipt');
    myobj=document.getElementById('Print');
	guser=session['LOGON.USERID']
	if(myobj)
	{
		myobj.onclick=Print_OnClick;
	}
	
	locobj=document.getElementById('Loc');
	wardobj=document.getElementById('Ward');
	var obj=document.getElementById('Clear');
	if (obj) obj.onclick = Clear_Click;
	var obj=document.getElementById('LinkOrdChk');
	if (obj) obj.onclick = LinkOrdChk;
	locobj.onkeyup=clearlocid;
	wardobj.onkeyup=clearwardid;
	locobj.onkeydown=getloc;
	wardobj.onkeydown=getward
	medobj.onclick=getmedobjfun;
	finalobj.onclick=getfinalobjfun;
	payflagobj.onclick=getpayflagobjfun;
	confirmflagobj.onclick=getconfirmfun;
	Printdetailobj.onclick=PrtBillinfo;
	printreceiptobj.onclick=PrtBillqingdan;
	var CancelConfirmobj=document.getElementById('CancelConfirm');
	if (CancelConfirmobj) CancelConfirmobj.onclick=Confirm_Click;
    
}
function PrtBillinfo()
{
	flag="detail"
	PrtBillDetail()
}
function PrtBillqingdan()
{
	flag="qingdan"
	PrtBillDetail()
}
function gettoday() 
{
	var gettoday=document.getElementById('gettoday');
	if (gettoday) 
	{   var encmeth=gettoday.value} else {var encmeth=''};
	    if (cspRunServerMethod(encmeth,'setdate_val','','')=='1'){
	};
}
function setdate_val(value)
{
		var Stdate=document.getElementById('Stdate');
		var EndDate=document.getElementById('EndDate');
		Stdate.value=value;
		EndDate.value=value;
}

function getmedobjfun()
{
	if (medobj.checked==true) 
	{   
	    finalobj.checked=false;
	    payflagobj.checked=false
	    confirmflagobj.checked=false
	    medvalobj.value="1";
	    finalvalobj.value="0"
	    confirmvalueobj.value="0"
	    payflagvalueobj.value="0";
	}
}
function getfinalobjfun()
{
	if (finalobj.checked==true) 
	{
	medobj.checked=false;
	payflagobj.checked=false
	confirmflagobj.checked=false
	finalvalobj.value="1";
	medvalobj.value="0"
	confirmvalueobj.value="0"
	payflagvalueobj.value="0";
	}	
}	
function getpayflagobjfun()
{
	if (payflagobj.checked==true) 
	{
	 medobj.checked=false;
	 confirmflagobj.checked=false
	 finalobj.checked=false
	 payflagvalueobj.value="1";
	 medvalobj.value="0"
	 confirmvalueobj.value="0"
	 finalvalobj.value="0"
	}	
}	

function getconfirmfun()
{
	if (confirmflagobj.checked==true) 
	{   medobj.checked=false;
	    payflagobj.checked=false
	    finalobj.checked=false
	    confirmvalueobj.value="1"
	    medvalobj.value="0";
	    finalvalobj.value="0"
	    payflagvalueobj.value="0";
	}
}	
function clearlocid()
{
	var locidobj=document.getElementById('locid');
	locidobj.value="";
}
function clearwardid()
{
	var wardidobj=document.getElementById('wardid');
	wardidobj.value="";
}
function Clear_Click()
{
	 location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDischQuery";
}
function getlocid(value)	
{
	var val=value.split("^");
	var obj=document.getElementById('locid');
	obj.value=val[1];
}
function getwardid(value)	
{
	var val=value.split("^");
	var obj=document.getElementById('wardid');
	obj.value=val[1];
}
function getward()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Ward_lookuphandler();
	}
}
function getloc()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Loc_lookuphandler();
	}
}
function CommonPrint(ReportName)
{
   var myxmlstr=(DHCDOM_WriteXMLInParameter());
   var myobj=document.getElementById('CPMReport');
   if (myobj){
      myobj.PrintCommonReport(ReportName, myxmlstr);
   }
}
function Print_OnClick()
{
	CommonPrint('DHCJFIPcyhzcx');
}
function SelectRowHandler()	
{  
   var eSrc=window.event.srcElement;
   Objtbl=document.getElementById('tUDHCJFDischQuery');
   var rowObj=getRow(eSrc);
   var selectrow=rowObj.rowIndex;
   if (!selectrow) return;
   var SelRowObj=document.getElementById('EpisodeIDz'+selectrow);
   Adm=SelRowObj.innerText;
   var SelRowObj=document.getElementById('Tregnoz'+selectrow);
   papno=SelRowObj.innerText;
   var SelRowObj=document.getElementById('Tnamez'+selectrow);
   name=SelRowObj.innerText;
   getpatinfo()
   	
}

function LinkOrdChk()
{
	if (Adm=="")
	{
		alert(t['07'])
		return
	}
	var confirmflag=document.getElementById('GetConfirm');
	if (confirmflag) {var encmeth=confirmflag.value} else {var encmeth=''};
    var retval=cspRunServerMethod(encmeth,Adm,guser)
    if (retval=="")
    {   alert(t['05'])
        return 
    }
    if (retval=="Y")
    {   alert(t['04'])
        return 
    }
    if (retval=="0")
    {
	    alert(t['06']) 
	    return
    }
   /*
   if (Adm=="") {alert(t['Err01']);return;}
   //var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFORDCHK&EpisodeID='+Adm
   var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFORDcat&EpisodeID='+Adm+'&RegNo='+papno+'&name='+name
   window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1200,height=520,left=5,top=100') 	
   */
}
function Confirm_Click()
{
   	if (Adm=="") {alert(t['Err01']);return;}
   	var cconfirm=document.getElementById('cconfirm');
	if (cconfirm) {var encmeth=cconfirm.value} else {var encmeth=''};
	var retconfirm=cspRunServerMethod(encmeth,Adm,guser);
	if (retconfirm==""){alert(t['Err01']);return;}
	if (retconfirm=="N"){alert(t['Err02']);return;}
	if (retconfirm=="0"){alert(t['Err03']);return;}
	if (retconfirm=="1"){alert(t['Err04']);return;}
	if (retconfirm=="100"){alert(t['Err05']);return;}
}
function PrtBillDetail()
{
  var getnum=document.getElementById('getbillnum'); 
  if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
  var str=cspRunServerMethod(encmeth,Adm)
  str=str.split("^")
  num=str[0]
  BillNo=str[1]
  if (num==1)
  { 
    var curbillflag=str[2]
    if (curbillflag!="P")
    {
	    Bill()
    }
    else
    {
	    alert(t['js']);
	    return;
    }
  }
  if (num>1)
  {	
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillNum&Adm='+Adm
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
  }
}
function Bill()
{
   if (Adm=="")
   { alert(t['billno']); return; }
   if (Adm!="")
   {   var WshNetwork = new ActiveXObject("WScript.NetWork");
       var computername=WshNetwork.ComputerName;
       var getbill=document.getElementById('getbill');
	   if (getbill) {var encmeth=getbill.value} else {var encmeth=''};
	   var num=cspRunServerMethod(encmeth,'','',Adm,guser,BillNo,computername)   
	   if (num=='0')
	   {  if (flag=="detail") 
	      { 
              if (BillNo=="") {alert("billno");return;}
	             var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetail&BillNo='+BillNo
              window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
	       }
	       if (flag=="qingdan")
	       {  
	           document.getElementById('BillNo').value=BillNo  
	           if (admreason==t['ybdesc']){CommonPrint('UDHCJFIPcybrjsqdyh')}
	           else {CommonPrint('UDHCJFIPcybrjsqd')}    //UDHCJFIPJSQDDIS
	       }
       }
       if (num=='2')
       { alert(t['fail'])
         return;} 	
       if (num=='-1')
       {alert(t['fail']);}
   }
}
function getpatinfo()
{	  
   var infro=document.getElementById('getpatinfo');
   if (infro) {var encmeth=infro.value}else {var encmeth=''};
   var returnvalue=cspRunServerMethod(encmeth,"","",Adm)
   var sub = returnvalue.split("^")
   admreason=sub[11]
}

document.body.onload = BodyLoadHandler;