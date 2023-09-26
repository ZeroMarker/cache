var Guser,flag,job,lastenddate,gusercode
var jsstdate,jsenddate,acctrowid,jsflag,err
var stdate,enddate,curdate,curdate1
function BodyLoadHandler() {
	var getstdate=document.getElementById('getstdate');
    if (getstdate) {var encmeth=getstdate.value} else {var encmeth=''};
    //document.getElementById('stdate').value=cspRunServerMethod(encmeth,"FLFEEACOUNT")
    stdate=cspRunServerMethod(encmeth,"FLFEEACOUNT")
	lastenddate=document.getElementById('stdate').value
	var jsflag=document.getElementById("jsflag")
    if (jsflag.checked==false)
    {   document.getElementById('stdate').value=stdate
	}
    jsflag.onclick=gethandin;
	Guser=session['LOGON.USERID']
	gusercode=session['LOGON.USERCODE']
	var obj=document.getElementById("Balance");
	if (obj) obj.onclick=Insert_click;	
	var obj=document.getElementById("Print");
	if (obj) obj.onclick=PrintCatFeeAcount_click;
	var cancel=document.getElementById("btncancel");
    if (cancel){
     cancel.onclick=Cancel_click;	  
    }  
    gettoday()
    gethandin() 
}
function setdate()
{	var getstdate=document.getElementById('getstdate');
    if (getstdate) {var encmeth=getstdate.value} else {var encmeth=''};
    stdate=cspRunServerMethod(encmeth,"FLFEEACOUNT")
    lastenddate=stdate
    document.getElementById('stdate').value=stdate
    Find_click()
}
function Insert_click()
{   getdate()
   
	if (err==-1)
        {   alert(t['jst06'])
            return }
        if (err==-2)
        {   alert("不能结算到当天.")
            return }
	if (jsflag=="Y")
	{   alert(t['jst05'])
	    return }
	if (stdate>enddate)
	{  //alert(t['06'])
	   //return 
	   }
	if (lastenddate!=stdate)
	{
		alert(t['05'])
		document.getElementById('stdate').value=lastenddate
		return
		
	}
	var Add=document.getElementById('Add');
	if (Add) {var encmeth=Add.value} else {var encmeth=''};
	flag="FLFEEACOUNT"
	var SelRowObj=document.getElementById('Tjobz'+1);
    job=SelRowObj.innerText;
	if (cspRunServerMethod(encmeth,Guser,flag,job)=='0')
	{   alert(t['01'])}
	else 
	{   alert(t['02'])
	}
}
function getpath() {
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};	
		path=cspRunServerMethod(encmeth,'','')
	}
function Cancel_click()
 {	getdate()
    var tmp=t['jst01']+lastdate+t['jst02']
    var truthBeTold = window.confirm(tmp);
    if (!truthBeTold) { return ;}
    var cancel=document.getElementById('cancel');
    if (cancel) {var encmeth=cancel.value} else {var encmeth=''};
    var err=(cspRunServerMethod(encmeth,acctrowid))
    if (err==0)
    {   alert(t['jst03'])
        return }
    else
    {   alert(t['jst04']) }
 }
function getdate()
{
	stdate=document.getElementById('stdate').value
	enddate=document.getElementById('enddate').value
    var laststr=document.getElementById('getlastdate');
    if (laststr) {var encmeth=laststr.value} else {var encmeth=''};
    var laststr1=(cspRunServerMethod(encmeth,"FLFEEACOUNT",stdate,enddate))
    lastjsdate1=laststr1.split("^")
    jsstdate=lastjsdate1[0]
    jsenddate=lastjsdate1[1]
    acctrowid=lastjsdate1[2]
    jsflag=lastjsdate1[3]
    err=lastjsdate1[4]
}
function gethandin()
{ var handinobj=document.getElementById("jsflag");
  var handin=handinobj.checked;
  var stdateobj=document.getElementById('stdate');
  var enddateobj=document.getElementById('enddate');
  //var stdateobj1=document.getElementById('ld50311istdate');
  //var enddateobj1=document.getElementById('ld50311ienddate');
  var Myobj=document.getElementById('Myid');
  if (Myobj){
   var imgname="ld"+Myobj.value+"i"+"stdate"
   var stdateobj1=document.getElementById(imgname);
   var imgname="ld"+Myobj.value+"i"+"enddate"
   var enddateobj1=document.getElementById(imgname);} 
  
  if (handin==true){
	  stdateobj.value=curdate1
	  enddateobj.value=curdate1
      stdateobj1.style.display="";
	  stdateobj.readOnly=false;
	  enddateobj1.style.display="";
	  enddateobj.readOnly=false;
	  }
   if (handin==false){
	 
	  getnotjkdate() 
	  if (document.getElementById('stdate').value=="")
	  {stdateobj.value=curdate1
	    enddateobj.value=curdate1
     
	  }
	   stdateobj1.style.display="none";
	   stdateobj.readOnly=true;
	  }
	}
function getnotjkdate()
{ var getstdate=document.getElementById('getstdate');
  if (getstdate) {var encmeth=getstdate.value} else {var encmeth=''};
  document.getElementById('stdate').value=cspRunServerMethod(encmeth,"FLFEEACOUNT")  
  
}
function gettoday() {
	var gettoday=document.getElementById('gettoday');
	if (gettoday) {var encmeth=gettoday.value} else {var encmeth=''};
	
	if (cspRunServerMethod(encmeth,'setdate_val','','')=='1'){
				};
	}
function setdate_val(value)
	{
		curdate=value;
		var str=curdate.split("/")
		curdate=str[2]+"-"+str[1]+"-"+str[0]
		curdate1=str[0]+"/"+str[1]+"/"+str[2]
	}

document.body.onload = BodyLoadHandler;