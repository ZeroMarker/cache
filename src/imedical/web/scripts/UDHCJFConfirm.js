var guser,gusername
var paperidobj
function BodyLoadHandler() 
{
   guser=session['LOGON.USERID']
   gusername=session['LOGON.USERNAME']
   var usernameobj=document.getElementById('username');
   var regnoobj=document.getElementById('Regno');
   if (regnoobj) regnoobj.onkeydown=getpatinfo
   var medcareobj=document.getElementById('Medicare');
   if (medcareobj) medcareobj.onkeydown=getpatinfo
   paperidobj=document.getElementById("paperid");
   var useridobj=document.getElementById('userid');
   useridobj.onkeyup=clearuserid;
   var cleardobj=document.getElementById('Clear');
   cleardobj.onclick=clearall;
   //modify by lc 2008-05-26
   //if (usernameobj.value=="")
   //{
   //   usernameobj.value=gusername
   //   useridobj.value=guser	   
   //}
   var obj=document.getElementById("print");
   if (obj) obj.onclick=printshjl; 	
}
function getuseid(value)
{
   var val=value.split("^");
   var obj=document.getElementById('userid');
   obj.value=val[1];	
}
function clearuserid()
{
	var seridobj=document.getElementById('userid');
	seridobj.value="";
}
function clearpaperid()
{
	var seridobj=document.getElementById('paperid');
	seridobj.value="";
}
function printshjl()
{
	var SelRowObj=document.getElementById('Tjobz'+1);
	job=SelRowObj.innerText
	document.getElementById('job').value=job
	CommonPrint('UDHCJFIPshcx')
}
function getpatinfo()
{
   var key=websys_getKey(e);
   if (key==13) {    	
      var regnoobj=document.getElementById("Regno");
      var regno=regnoobj.value
      var medcareobj=document.getElementById("Medicare");
      var medcare=medcareobj.value
      var nameobj=document.getElementById("name");
      var name=nameobj.value
      var getpatinfoobj=document.getElementById('getpatinfo');
      if (getpatinfoobj) {var encmeth=getpatinfoobj.value} else {var encmeth=''};
      var patinfo=cspRunServerMethod(encmeth,regno,medcare)
      if (patinfo==""){
	     alert(t['patinfo01']);
	     return;
	  }else{
	     var patinfo1=patinfo.split("^");
	     regnoobj.value=patinfo1[0]
	     nameobj.value=patinfo1[1]
	     medcareobj.value=patinfo1[2]
	     paperidobj.value=patinfo1[3]
	  }	      
   }	
}
function clearall()
{	
   location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFConfirm";
}
document.body.onload = BodyLoadHandler;
