///UDHCJFDepositRpt.js
var prtflag,path,gusername,gusercode
var yjData = new Array()
var tzpData = new Array()
var thpData = new Array()
var yjColumns = new Array()
var sxjsum=0,szpsum=0,shpsum=0,syhksum=0,syklysum=0,syjsum=0
var txjsum=0,tzpsum=0,thpsum=0,tyhksum=0,tyklysum=0,tyjsum=0
var sxjnum=0,szpnum=0,shpnum=0,syhknum=0,syklynum=0,syjnum=0
var txjnum=0,tzpnum=0,thpnum=0,tyhknum=0,tyklynum=0,tyjnum=0
var zfxjnum=0,zfzpnum=0,zfhpnum=0,zfyhknum=0,zfyklynum=0,zfyjnum=0
var zfxjsum=0,zfzpsum=0,zfhpsum=0,zfyhksum=0,zfyklysum=0,zfyjsum=0
var curdate,syjsum=0,tyjsum=0,zfnum=0,chnum=0
var job,hidden="false"
function BodyLoadHandler() {
   job=document.getElementById('job').value
   prtflag="2"
   yjColumns = [
	 t['13'],t['03'],t['17'],t['04'],t['06'], t['07'], t['05'] ,t['14'],t['10'],t['08']
 	];
   gusername=session['LOGON.USERNAME']
   gusercode=session['LOGON.USERCODE']
   var prt=document.getElementById("Print");
   if (prt){
     prt.onclick=Print_click;	  
  }
  //document.getElementById('job').value=job.innerText
}
function SelectRowHandler()	
{
   var eSrc=window.event.srcElement;
   Objtbl=document.getElementById('tUDHCJFDepositRpt');
   var rowObj=getRow(eSrc);
   var selectrow=rowObj.rowIndex;
   if (!selectrow) return;
	//SelectedRow = selectrow;
}
function GetSum()
{   var Sum=0;
    var Objtbl=parent.frames['UDHCJFDepositRpt'].document.getElementById('tUDHCJFDepositRpt');
	var Rows=Objtbl.rows.length;
	for (i=1;i<=Rows-2;i++)
	{  
	   var SelRowObj=document.getElementById('Tstatusz'+i);
	   var prtstatus=SelRowObj.innerText;
	   SelRowObj=document.getElementById('Tselectz'+i);
	   var select=SelRowObj.checked;
	   SelRowObj=document.getElementById('Tpayamtz'+i);
	   var payamt=SelRowObj.innerText;
	   SelRowObj=document.getElementById('Tpatnamez'+i);
	   var patname=SelRowObj.innerText;
	   if ((prtstatus!=t['11'])&&(select==true)&&(patname!=t['12']))
	   {  Sum=eval(Sum)+eval(payamt) ;
	   }
	}
	var lastrow=Rows-1
	SelRowObj=document.getElementById('Tpayamtz'+lastrow);
	SelRowObj.innerText=Sum.toFixed(2);
}
function getpath() {
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};	
		path=cspRunServerMethod(encmeth,'','')
	}
function getcurdate() {
	var getcurdate=document.getElementById('getcurdate');
	if (getcurdate) {var encmeth=getcurdate.value} else {var encmeth=''};	
		curdate=cspRunServerMethod(encmeth)
	}
function Print_click()
{   var i
    yjData = new Array()
    tzpData = new Array()
    thpData = new Array()
    sxjsum=0,szpsum=0,shpsum=0,syhksum=0,syklysum=0,syjsum=0
    txjsum=0,tzpsum=0,thpsum=0,tyhksum=0,tyklysum=0,tyjsum=0
    sxjnum=0,szpnum=0,shpnum=0,syhknum=0,syklynum=0,syjnum=0
    txjnum=0,tzpnum=0,thpnum=0,tyhknum=0,tyklynum=0,tyjnum=0
    zfxjnum=0,zfzpnum=0,zfhpnum=0,zfyhknum=0,zfyklynum=0,zfyjnum=0
    zfxjsum=0,zfzpsum=0,zfhpsum=0,zfyhksum=0,zfyklysum=0,zfyjsum=0
    syjsum=0,tyjsum=0,zfnum=0

    var paymodestr
	paymodestr=t['jstpaymode'].split("_")	
    var Objtbl=document.getElementById('tUDHCJFDepositRpt');
	var Rows=Objtbl.rows.length;
	allnum=Rows-2
	for (i=1;i<=Rows-1;i++)
	{  var SelRowObj=document.getElementById('Tpatnamez'+i);
       var patname=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tregnoz'+i);
       var regno=SelRowObj.innerText;
       SelRowObj=document.getElementById('Trcptnoz'+i);
       var rcptno=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tpayamtz'+i);
       var payamt=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tpaymodez'+i);
       var paymode=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tstatusz'+i);
       var status=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tprtdatez'+i);
       var prtdate=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tprttimez'+i);
       var prttime=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tadmlocz'+i);
       var admloc=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tchequenoz'+i);
       var chequeno=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tzynoz'+i);
       var zyno=SelRowObj.innerText;
       var prtrowid=document.getElementById('Trowidz'+i).innerText;
       prtdate=(prtdate+" "+prttime)
       prtstatus=status
       if (status!=t['11']) {prtstatus=""}
       var str=admloc+"^"+patname+"^"+zyno+"^"+regno+"^"+payamt+"^"+paymode+"^"+rcptno+"^"+chequeno+"^"+prtdate+"^"+prtstatus
       yjData[i-1]=str.split("^"); 
       if (status!=t['11'])
       {  if (status!=t['16'])
          {  if (paymode==paymodestr[0]){sxjsum=eval(sxjsum)+eval(payamt),sxjnum=sxjnum+1}
	         if (paymode==paymodestr[1]) {szpsum=eval(szpsum)+eval(payamt),szpnum=szpnum+1}
	         if (paymode==paymodestr[3]) {shpsum=eval(shpsum)+eval(payamt),shpnum=shpnum+1}
	         if (paymode==paymodestr[5]) {syhksum=eval(syhksum)+eval(payamt),syhknum=syhknum+1}
             if ((paymode==paymodestr[2])||(paymode==paymodestr[4])||(paymode==paymodestr[6]))
              {   {syklysum=eval(syklysum)+eval(payamt),syklynum=syklynum+1}}
          }
          if (status==t['16'])
          { 
             payamt=0-payamt
             if (paymode==paymodestr[0]){txjsum=eval(txjsum)+eval(payamt),txjnum=txjnum+1}
	         if (paymode==paymodestr[1]) 
	         {  tzpsum=eval(tzpsum)+eval(payamt),tzpnum=tzpnum+1
	            var yjstr=document.getElementById('gettyj');
				if (yjstr) {var encmeth=yjstr.value} else {var encmeth=''};	
				var tyjstr=cspRunServerMethod(encmeth,prtrowid)
	            tzpData[tzpnum-1]=tyjstr;
	          }
	         if (paymode==paymodestr[3]) 
	         {  thpsum=eval(thpsum)+eval(payamt),thpnum=thpnum+1,thpData[thpnum-1]=str.split("^");
	            var yjstr=document.getElementById('gettyj');
				if (yjstr) {var encmeth=yjstr.value} else {var encmeth=''};	
				var tyjstr=cspRunServerMethod(encmeth,prtrowid)
	            thpData[thpnum-1]=tyjstr; 
	          }
	         if (paymode==paymodestr[5]) {tyhksum=eval(tyhksum)+eval(payamt),tyhknum=tyhknum+1}
             if ((paymode==paymodestr[2])||(paymode==paymodestr[4])||(paymode==paymodestr[6]))
             {  {tyklysum=eval(tyklysum)+eval(payamt),tyklynum=tyklynum+1}}
          }
       }
       else
       {   zfnum=zfnum+1
           if (paymode==paymodestr[0]){zfxjsum=eval(zfxjsum)+eval(payamt),zfxjnum=zfxjnum+1}
	       if (paymode==paymodestr[1]) {zfzpsum=eval(zfzpsum)+eval(payamt),zfzpnum=zfzpnum+1}
	       if (paymode==paymodestr[3]) {zfhpsum=eval(zfhpsum)+eval(payamt),zfhpnum=zfhpnum+1}
	       if (paymode==paymodestr[5]) {zfyhksum=eval(zfyhksum)+eval(payamt),zfyhknum=zfyhknum+1}
           if ((paymode==paymodestr[2])||(paymode==paymodestr[4])||(paymode==paymodestr[6]))
           {   {zfyklysum=eval(zfyklysum)+eval(payamt),zfyklynum=zfyklynum+1}}
       }
       if (status==t['16'])
       {  chnum=chnum+1 }
	}
	syjsum=eval(sxjsum)+eval(szpsum)+eval(shpsum)+eval(syhksum)+eval(syklysum)
	syjnum=eval(sxjnum)+eval(szpnum)+eval(shpnum)+eval(syhknum)+eval(syklynum)
	syjsum=eval(syjsum).toFixed(2).toString(2)
	tyjsum=eval(txjsum)+eval(tzpsum)+eval(thpsum)+eval(tyhksum)+eval(tyklysum)
	tyjnum=eval(txjnum)+eval(tzpnum)+eval(thpnum)+eval(tyhknum)+eval(tyklynum)
	tyjsum=eval(tyjsum).toFixed(2).toString(2)
	zfyjsum=eval(zfxjsum)+eval(zfzpsum)+eval(zfhpsum)+eval(zfyhksum)+eval(zfyklysum)
	zfyjsum=eval(zfyjsum).toFixed(2).toString(2)
	getpath();
	getcurdate()

	//nyfydeptprint()
	prtdepositdetail()
	// printDailyHz() ;
   
}


document.body.onload = BodyLoadHandler;