var Guser
var BillNo,Adm,prtrowid,Patfee,invfee
var currentinvnoobj,currinvnumber,Invdr
var path,getpatfee,patinvfee,syamount,patbillfee
var SubPrtrowid,subflag,subamout
function BodyLoadHandler()
{
   DHCP_GetXMLConfig("InvPrintEncrypt","DHCJFIPReceipt");
   Guser=session['LOGON.USERID'];
   var admobj=document.getElementById('Adm');
   Adm=admobj.value
   var billnoobj=document.getElementById('BillNo');
   BillNo=billnoobj.value
   var invobj=document.getElementById('prtrowid');
   prtrowid=invobj.value
   currentinvnoobj=document.getElementById('currentinvno');
   var Printobj=document.getElementById('Print');
   Printobj.onclick=Print_click;
   var Abortobj=document.getElementById('Abort');
   Abortobj.onclick=Abort_click;
   var Closeobj=document.getElementById('Close');
   Closeobj.onclick=Close_click;
   var invsumobj=document.getElementById('invsum');
   if (invsumobj) invsumobj.onkeydown=enterinvsum
   currentinvnoobj.readOnly=true;
   getpatinfo()
   getpatfee()
   if (!getcurrentinvno()){alert(t['01'])}
   getinvfee()
   websys_setfocus('invsum')
}
function getpatinfo()
{	  
   var infro=document.getElementById('getpatinfo');
   if (infro) {var encmeth=infro.value}else {var encmeth=''};
   returnvalue=cspRunServerMethod(encmeth,"","",Adm)
   var sub = returnvalue.split("^")
   document.getElementById('papno').value=sub[7]
   document.getElementById('name').value=sub[0]
   document.getElementById('admdate').value=sub[1]
   document.getElementById('disdate').value=sub[12]
   admreason=sub[11]
   document.getElementById('patward').value=sub[3]
   document.getElementById('patzyno').value=sub[10]
}
function Print_click()
{
	getsaveinvprtsub()
}
function Close_click()
{	
   window.close();
   window.opener.location.reload();
   //location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFPAY";
}
function BodyunLoadHandler()
{
   window.opener.Find.click();
}

function getcurrentinvno() 
{
   p1=Guser
   var getcurrinvobj=document.getElementById('getcurinvno');
   if (getcurrinvobj) {var encmeth=getcurrinvobj.value} else {var encmeth=''};
   if (cspRunServerMethod(encmeth,'setinvno_val','',p1)=='1'){return true;}
   else {return false;}
}
function setinvno_val(value)
{
   var val=value.split("^")
   currentinvnoobj.value=val[0];
   currinvnumber=val[0];
   Invdr=val[1];
}
function getpatfee()
{
	p1=BillNo
    var getpatfee=document.getElementById('getpatfee');
    if (getpatfee) {var encmeth=getpatfee.value} else {var encmeth=''};
    patfee=cspRunServerMethod(encmeth,p1)
    var val=patfee.split("#")
    patbillfee=val[3]
    document.getElementById('patfee').value=patbillfee;   
}
function getinvfee()
{
	p1=prtrowid
	var patinvfee=document.getElementById('getinvfee');
    if (patinvfee) {var encmeth=patinvfee.value} else {var encmeth=''};
    patinvfee=cspRunServerMethod(encmeth,'','',p1)
    //?????document.getElementById('invsum').value=patinvfee;
    syamount=eval(patbillfee)-eval(patinvfee)
    syamount=eval(syamount).toFixed(2).toString(10)
    document.getElementById('sysum').value=syamount;
}
function enterinvsum()
{
   var key=websys_getKey(e);
   if (key==13) 
   {
      var invsumobj=document.getElementById('invsum')
      var invsum=invsumobj.value
      invsum=eval(invsum).toFixed(2).toString(10);
      invsumobj.value=invsum
      websys_setfocus('Print')	   
   }  	
}
function getsaveinvprtsub()
{
	var invsum=document.getElementById('invsum').value
	var sysum=document.getElementById('sysum').value;
	var syinvamount=eval(sysum)-eval(invsum);
	if (syinvamount<0)
	{
		alert(t['err0']);
		document.getElementById('invsum').value="0.00";
	    document.getElementById('sysum').value=sysum;
	}
	else
	{
        var patfeeobj=document.getElementById('patfee');
        var patfeeall=patfeeobj.value
        var insinv=document.getElementById('getsaveinvprtsub');
        if (insinv) {var encmeth=insinv.value} else {var encmeth=''};
        var str=currinvnumber+"^"+Adm+"^"+BillNo+"^"+prtrowid+"^"+invsum+"^"+Guser+"^"+"Y"+"^"+Invdr+"^"+patfeeall
        var retval=cspRunServerMethod(encmeth,'','',str)
        if (retval=="0")
        {
	        alert(t['succeed'])
	        PrintFP(currinvnumber)
	        window.location.reload(); 
        }
        else if (retval=="1")
        {
	       alert(t['err0']);
	       window.location.reload();       
	    }
        else
        {
	        alert(t['fail'])
	        return;
        }
	}
}
function SelectRowHandler()	
{  	var SelRowObj
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tUDHCJFInvprtzySub');
	var Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('subprtrowid');
	SelRowObj=document.getElementById('Tsubrowidz'+selectrow);
    SubPrtrowid=SelRowObj.innerText;
	SelRowObj=document.getElementById('Tsubflagz'+selectrow);
	subflag=SelRowObj.innerText;
	SelRowObj=document.getElementById('Tpayamoutz'+selectrow);
	subamout=SelRowObj.innerText;
}
function Abort_click()
{
  	SelectRowHandler();
  	if (subflag=="A")
  	{
	  	alert(t['zffail']);
	  	return;
  	}
  	else
  	{
	  	 var abort=document.getElementById('getabort');
         if (abort) {var encmeth=abort.value} else {var encmeth=''};
         var str=SubPrtrowid;
         var retval=cspRunServerMethod(encmeth,'','',str);
         if (retval==0)
         {
	         alert(t['zfsucceed']);
	         //var sysum=document.getElementById('sysum').value;
	         //var newsysum=subamout+sysum
	         //document.getElementById('sysum').value=newsysum;
	         window.location.reload();
  	     }
  	     else
  	     {
	  	     alert(t['zfsb']);
	  	     return;
  	     }
  	}
  	
}
document.body.onload = BodyLoadHandler;
document.body.onunload = BodyunLoadHandler;