var path
var Guser,stdate,enddate,curdate
var yjrowid,fprowid,gusername,gusercode
var yjsum=0,sxjsum=0,sxjnum=0,szpsum=0,szpnum=0,shpsum=0,shpnum=0,sxyksum=0,sxyknum=0
var txjsum=0,txjnum=0,tzpsum=0,tzpnum=0,thpsum=0,thpnum=0,txyksum=0,txyknum=0,fpnum=0,tqtnum=0
var xjsum,zpsum,hpsum,xyksum,patfee,payorshare,discount,patshare,ybsum=0,gfsum=0,sldsum=0,tdeposit=0,ybnum=0,cjsum=0,scjsum=0,tcjsum=0
var rcptrow=0,invrow=0
var jsflag="N"
var hospitalname
var payorsharenum=0
var userjkno
var nbsbnum,nbnbnum,nbsbsum,nbnbsum
var curdate1
var balflag="0",prtflag=0
var job,flag
function BodyLoadHandler() 
{ 
  userjkno=""
  gusercode=session['LOGON.USERCODE'] 
  flag=document.getElementById('flag').value
  flag="1"
  if (flag=="1")
  { Guser=session['LOGON.USERID'] 
    gethandin()  
   }
  if (flag=="")
  { Guser="" 
    document.getElementById("Balance").style.visibility = "hidden"
	document.getElementById("btncancel").style.visibility = "hidden"
	document.getElementById("handin").style.visibility = "hidden"
	document.getElementById("chandin").style.visibility = "hidden"
  }
  gusername=session['LOGON.USERNAME']
  yjrowid=""
  fprowid=""
  gettoday() 
  var hospitalobj=document.getElementById('gethospital');
  if (hospitalobj) {var encmeth=hospitalobj.value} else {var encmeth=''};
  hospitalname=cspRunServerMethod(encmeth)
  var findobj=document.getElementById("Find");
  if (findobj)
  {
      findobj.onclick=Find_click;	  
  }
  var obj=document.getElementById("Balance");
  if (obj)
  {
      obj.onclick=Balance_click;	  
  }
  var prt=document.getElementById("Print");
  if (prt)
  {
     prt.onclick=Print_click;	  
  }  
   var cancel=document.getElementById("btncancel");
  if (cancel)
  {
     cancel.onclick=Cancel_click;	  
  }  
  var handinobj=document.getElementById("handin");
   handinobj.onclick=gethandin;
  
}
function gettoday() 
{
	var gettoday=document.getElementById('gettoday');
	if (gettoday) {var encmeth=gettoday.value} else {var encmeth=''};
	curdate=cspRunServerMethod(encmeth)
}
function setdate_val(value)
{
	curdate=value;
	var str=curdate.split("/")
	curdate=str[2]+"-"+str[1]+"-"+str[0]
	curdate1=str[0]+"/"+str[1]+"/"+str[2]
}
function Find_click()
{	
    stdate=document.getElementById("stdate").value;
    enddate=document.getElementById("enddate").value;
    var handin=document.getElementById("handin").checked;
    if (stdate=="")
    {  
       alert(t['01'])
       return;
    }
    if (enddate=="")
    {  
       alert(t['02'])
       return;
    }
    if (handin==true)
    {   
    handin="Y"
    }
    else
    {
	    handin="N"
	}
    if (handin=="N")
    { 
      parent.frames['UDHCJFdayInvRpt'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFdayInvRpt&stdate="+stdate+"&enddate="+enddate+"&handin="+handin+"&Guser="+Guser+"&jsflag="+"N"+"&jkdr="+""+"&flag="+flag;
      //parent.frames['UDHCJFInvRpt'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFInvRpt&stdate="+stdate+"&enddate="+enddate+"&handin="+handin+"&Guser="+Guser+"&jsflag="+"N"+"&jkdr="+""
      //parent.frames['UDHCJFInvRpt'].flag=flag 
    }
    if (handin=="Y")
    {  
       jsflag="Y"
       var his=document.getElementById('getnum');
	   if (his) {var encmeth=his.value} else {var encmeth=''};
	 
	   var count=cspRunServerMethod(encmeth,'','',stdate,enddate,Guser,flag)
	   
	   if (count>'1')
	   {  				
	      var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDayRptHis&stdate='+stdate+'&enddate='+enddate+'&guser='+Guser+'&findflag='+"FP"+"&flag="+flag
	      window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0')
	   }
	   if (count<='1')
	   {   
		   //parent.frames['UDHCJFDepositRpt'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDepositRpt&stdate="+stdate+"&enddate="+enddate+"&handin="+"Y"+"&Guser="+Guser+"&jsflag="+"N"+"&jkdr="+""; 
           parent.frames['UDHCJFdayInvRpt'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFdayInvRpt&stdate="+stdate+"&enddate="+enddate+"&handin="+"Y"+"&Guser="+Guser+"&jsflag="+"N"+"&jkdr="+""+"&flag="+flag;; 
           //parent.frames['UDHCJFInvRpt'].flag=flag
        }
	 }
      var SelRowObj=parent.frames['UDHCJFdayInvRpt'].document.getElementById('Tjobz'+1);
	  var job=SelRowObj.innerText;
	  document.getElementById('job').value=parent.frames['UDHCJFdayInvRpt'].document.getElementById('Tjobz'+1).innerText
	  alert(document.getElementById('job').value)

}
function Balance_click()
{ 
   //alert("VV")
   balflag="1"
   var SelRowObj=document.getElementById('handin');
   var select=SelRowObj.checked;
   userjkno=""
   if (select==true) 
   {  alert(t['03'])
        return;
   }
  // GetYjRowid()
   GetJsFpRowid()
   yjrowid=""
   if (invrow<2)
   {  
      fprowid=""
      alert(t['jst05'])
      return 
   }
   var str=stdate+"^"+enddate+"^"+Guser   
   if ((invrow>=2)&(jsflag=="N"))
   {
      var btnbal=document.getElementById('btnbal');
      if (btnbal) {var encmeth=btnbal.value} else {var encmeth=''};
      var balstr=(cspRunServerMethod(encmeth,'','',str,yjrowid,fprowid))
      var balstr1=balstr.split("^")
      retval=balstr1[0]
      userjkno=balstr1[1]      
      if (retval=='0') 
      {
	     alert(t['04'])
	     jsflag="Y"
	     window.location.reload();
	     return;
	  }
      else
      { 
        alert(t['05']);
        return;
      }
    }
    else
    {
       alert(t['06']);
    }    
}
function getpath() 
{
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};	
		path=cspRunServerMethod(encmeth,'','')
}
/*
function Print_click()
{   getpath()    
    printCyDaily()
    window.location.reload();
    var handinobj=document.getElementById("handin");
    var handin=handinobj.checked;
    if ((handin==false)&(balflag="1")) {
	   // getnotjkdate()
	    }    
}
*/
function gethandin()
{ 
  var handinobj=document.getElementById("handin");
  var handin=handinobj.checked;
  var stdateobj=document.getElementById('stdate');
  var enddateobj=document.getElementById('enddate');
  //var stdateobj1=document.getElementById('ld50311istdate');
  //var enddateobj1=document.getElementById('ld50311ienddate');
  var Myobj=document.getElementById('Myid');
  if (Myobj)
  {
     var imgname="ld"+Myobj.value+"i"+"stdate"
     var stdateobj1=document.getElementById(imgname);
     var imgname="ld"+Myobj.value+"i"+"enddate"
     var enddateobj1=document.getElementById(imgname);
   } 
  if (handin==true)
  {
	  //stdateobj.value=curdate1
	  //enddateobj.value=curdate1
      stdateobj1.style.display="";
	  stdateobj.readOnly=false;
	  enddateobj1.style.display="";
	  enddateobj.readOnly=false;
	  //parent.frames['UDHCJFDepositRpt'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDepositRpt&stdate="+""+"&enddate="+""+"&handin="+""+"&Guser="+Guser+"&jsflag="+""+"&jkdr="+""; 
      //parent.frames['UDHCJFInvRpt'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFInvRpt&stdate="+""+"&enddate="+""+"&handin="+""+"&Guser="+Guser+"&jsflag="+""+"&jkdr="+""; 
  }
  if (handin==false)
  {
	  getnotjkdate() 
	  stdateobj1.style.display="none";
	  stdateobj.readOnly=true;
	  //enddateobj1.style.display="none";
	  //enddateobj.readOnly=true;
	  Find_click()
  }
}

function getnotjkdate()
{ 
   var user=session['LOGON.USERID'] 
   var getstdate=document.getElementById('getstdate');
   if (getstdate) {var encmeth=getstdate.value} else {var encmeth=''};
   document.getElementById('stdate').value=cspRunServerMethod(encmeth,user)
   //var stdate=document.getElementById('stdate').value;
   //var getenddate=document.getElementById("getenddate");
   ///if (getenddate) {var encmeth=getenddate.value} else {var encmeth=''};
   //var stdateobj=document.getElementById('stdate');
   //var enddateobj=document.getElementById("enddate");
   //var daystr=cspRunServerMethod(encmeth,stdate,user)
   //var daystr1=daystr.split("^")
   //stdateobj.value=daystr1[0]
   //enddateobj.value=daystr1[1]
   Find_click()
 }
function Cancel_click()
 {	
    var lastdate,lasttime,jkdr
    var laststr=document.getElementById('getlastdate');
    if (laststr) {var encmeth=laststr.value} else {var encmeth=''};
    var laststr1=(cspRunServerMethod(encmeth,Guser))
    lastjsdate1=laststr1.split("^")
    lastdate=lastjsdate1[0]
    lasttime=lastjsdate1[1]
    jkdr=lastjsdate1[2]
    var tmp=t['jst01']+lastdate+t['jst02']
    var truthBeTold = window.confirm(tmp);
    if (!truthBeTold) { return ;}
    var cancel=document.getElementById('cancel');
    if (cancel) {var encmeth=cancel.value} else {var encmeth=''};
    var err=(cspRunServerMethod(encmeth,Guser,jkdr,lastdate,"FP"))
    if (err==0)
    {   
        alert(t['jst03'])
        balflag="0"
        window.location.reload();
        return 
    }
    else
    {   
        alert(t['jst04']) 
    }
 }
function GetJsFpRowid()
{  
	var Objtbl=parent.frames['UDHCJFdayInvRpt'].document.getElementById('tUDHCJFdayInvRpt');
	var Rows=Objtbl.rows.length;
	invrow=Rows-1
	for (i=1;i<=Rows-2;i++)
	{  
	   var select=true
	   SelRowObj=parent.frames['UDHCJFdayInvRpt'].document.getElementById('Trowidz'+i);
	   var prtrowid=SelRowObj.innerText;
	   if ((fprowid!="")&&(select==true))
	   {fprowid=fprowid+"^"+prtrowid}
	   if ((fprowid=="")&&(select==true))
	   {fprowid=prtrowid}
	}
}
function Print_click()
{   
    CommonPrint('UDHCJFIPcycrb'); 
}
function UnloadHandler()
{	
	var SelRowObj=parent.frames['UDHCJFdayInvRpt'].document.getElementById('Tjobz'+1);
	job=SelRowObj.innerText
	var KillTMPPrtGlbobj=document.getElementById("KillTmp");
	if (KillTMPPrtGlbobj) {var encmeth=KillTMPPrtGlbobj.value} else {var encmeth=''};
	var mytmp=cspRunServerMethod(encmeth,Guser,job)
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload=UnloadHandler;