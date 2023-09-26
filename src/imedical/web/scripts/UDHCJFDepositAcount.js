 
var Guser,flag,job,path,lastenddate,gusercode
var jsstdate,jsenddate,acctrowid,jsflag,err
var stdate,enddate
var cancelerr
function BodyLoadHandler() {
       
	var jsflag=document.getElementById("jsflag")    
    gettoday()    
    jsflag.onclick=setdate;
	Guser=session['LOGON.USERID']
	gusercode=session['LOGON.USERCODE']
        
	var obj=document.getElementById("Balance");
	if (obj) obj.onclick=Insert_click;	
	var obj=document.getElementById("PrintDetail");
	if (obj) obj.onclick=PrintDepositAcountDetail_click;
	var obj=document.getElementById("PrintWard");
	if (obj) obj.onclick=PrintDepositAcountWard_click;
	var obj=document.getElementById("PrintAll");
	if (obj) obj.onclick=PrintDepositAcountAll_click;	
	var cancel=document.getElementById("btncancel");
    if (cancel){
     cancel.onclick=Cancel_click;	  
    }
    var clearobj=document.getElementById("Clear");
    if (clearobj) clearobj.onclick=clear_click
    var PrintWardDayobj=document.getElementById("PrintWardDay");
    if (PrintWardDayobj) PrintWardDayobj.onclick=PrintWardDay_click;    
    getcurrjob()        
}
function setdate()
{	
   var stdateobj=document.getElementById('stdate')   
   var enddateobj=document.getElementById('enddate')   
   var jsflag=document.getElementById("jsflag")
   var gettodayobj=document.getElementById('gettoday');
   if (gettodayobj) {var encmeth=gettodayobj.value} else {var encmeth=''}; 
   var todaystr=cspRunServerMethod(encmeth)
   var todaystr1=todaystr.split("^");
   if (jsflag.checked==false)
   {  var getstdate=document.getElementById('getstdate');
      if (getstdate) {var encmeth=getstdate.value} else {var encmeth=''};
      stdate=cspRunServerMethod(encmeth,"YJACOUNTSAVE")
      lastenddate=stdate
      stdateobj.value=stdate
      enddateobj.value=todaystr1[0]              
   }
   if (jsflag.checked==true){
      enddateobj.value=todaystr1[1]
      stdateobj.value=todaystr1[1] 
   }      
}
function PrintDepositAcountDetail_click()
{  
	var warddescobj=document.getElementById('Warddesc');
	var warddesc=warddescobj.value
	var wardidobj=document.getElementById('Wardid');
	var wardid=wardidobj.value
	if ((warddesc=="")||(wardid=="")||(wardid=='0')){
	   alert(t['Prt01']);
	   return;
	}
	CommonPrint("UDHCJFIPYJJbqzz");	
}
function PrintDepositAcountWard_click()
{  
	var warddescobj=document.getElementById('Warddesc');
	var warddesc=warddescobj.value
	var wardidobj=document.getElementById('Wardid');
	var wardid=wardidobj.value
	
	if (warddesc!=""){		
	   alert(t['Prt02']);
	   return;
	}
	if ((wardid!="")&&(wardid!="0")){
	   alert(t['Prt02']);
	   return;
	}
	CommonPrint("UDHCJFIPYJJZDT");
}
function PrintDepositAcountAll_click()
{
  var warddescobj=document.getElementById('Warddesc');
  var warddesc=warddescobj.value
  var wardidobj=document.getElementById('Wardid');
  var wardid=wardidobj.value
  if (warddesc!=""){		
	   alert(t['Prt02']);
	   return;
  }
  if ((wardid!="")&&(wardid!="0")){
	   alert(t['Prt02']);
	   return;
  }
  CommonPrint("UDHCJFIPYJJzz");
}
function Insert_click()
{	
    getdate()
    if (err==-1)
    {   alert(t['jst06'])
        return }
	    
    if (jsflag=="Y")
	{   alert(t['jst05'])
	    return }
	if (stdate>enddate)
	{  //alert(t['08'])
	   //return 
	   }
	if ((lastenddate!=document.getElementById('stdate').value)&&(lastenddate!=0))
	{
		alert(t['05'])
		document.getElementById('stdate').value=lastenddate
		return
	}
	var warddescobj=document.getElementById('Warddesc');
    var warddesc=warddescobj.value
    var wardidobj=document.getElementById('Wardid');
    var wardid=wardidobj.value
    if (warddesc!=""){		
	   alert(t['InsertErr01']);
	   return;
	}
	if ((wardid!="")&&(wardid!="0")){
	   alert(t['InsertErr01']);
	   return;
	}    
	var Add=document.getElementById('Add');
	if (Add) {var encmeth=Add.value} else {var encmeth=''};
	flag="YJACOUNTSAVE"
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
 {  var warddescobj=document.getElementById('Warddesc');
    var wardidobj=document.getElementById('Wardid');
    if (warddescobj.value!=""){
      alert(t['InsertErr01']);
      return;
    }
    if (wardidobj.value!=""){
      alert(t['InsertErr01']);
      return;
    }
    getdate()
    if (cancelerr!='0'){
	   alert(t['InsertErr02'])
	   return;
	}   
    var tmp=t['jst01']+jsstdate+"--"+jsenddate+t['jst02']
    var truthBeTold = window.confirm(tmp);
    if (!truthBeTold) { return ;}
    flag="YJACOUNTSAVE"
    var cancel=document.getElementById('cancel');
    if (cancel) {var encmeth=cancel.value} else {var encmeth=''};
    
    var err=(cspRunServerMethod(encmeth,acctrowid,jsstdate,jsenddate,flag))
    if (eval(err)==0)
    {   alert(t['jst03'])
        return }
    else if (eval(err)==100){
	   alert(t['InsertErr02'])
	   return;   
	}
    else
    {   alert(t['jst04']) }  
    
 }
function getdate()
{
	stdate=document.getElementById('stdate').value
	enddate=document.getElementById('enddate').value
    var laststr=document.getElementById('getlastdate');
    if (laststr) {var encmeth=laststr.value} else {var encmeth=''};
    var laststr1=(cspRunServerMethod(encmeth,"YJACOUNTSAVE",stdate,enddate))
    lastjsdate1=laststr1.split("^")
    jsstdate=lastjsdate1[0]
    jsenddate=lastjsdate1[1]
    acctrowid=lastjsdate1[2]
    jsflag=lastjsdate1[3]
    err=lastjsdate1[4]
    cancelerr=lastjsdate1[5]
}
function getcurrjob()
{
   var jobobj=document.getElementById("job");
   if (jobobj.value==""){
      var getcurrectjobobj=document.getElementById("getcurrectjob");
      if (getcurrectjobobj) {var encmeth=getcurrectjobobj.value} else {var encmeth=''};
      job=cspRunServerMethod(encmeth,'','')   
      jobobj.value=job
   }
   job=jobobj.value          	
}
function UnloadHandler()
{	var jobobj=document.getElementById("job");
    job=jobobj.value
    var KillDepositAcountTMP=document.getElementById("KillDepositAcountTMP");
	if (KillDepositAcountTMP) {var encmeth=KillDepositAcountTMP.value} else {var encmeth=''};
	var mytmp=cspRunServerMethod(encmeth,job)
}
function gettoday()
{
   var warddescobj=document.getElementById('Warddesc');
   var wardidobj=document.getElementById('Wardid');	
   var enddateobj=document.getElementById('enddate');
   var stdateobj=document.getElementById('stdate'); 
   var jsflag=document.getElementById('jsflag');
   var ClearFlagobj=document.getElementById('ClearFlag');
   var gettodayobj=document.getElementById('gettoday');
   if (gettodayobj) {var encmeth=gettodayobj.value} else {var encmeth=''}; 
   var todaystr=cspRunServerMethod(encmeth)
   var todaystr1=todaystr.split("^");
   if (jsflag.checked==false)
   {  var getstdate=document.getElementById('getstdate');
      if (getstdate) {var encmeth=getstdate.value} else {var encmeth=''};
      stdate=cspRunServerMethod(encmeth,"YJACOUNTSAVE")
      lastenddate=stdate
      
      if ((ClearFlagobj.value=="")&&(wardidobj.value=="")&&(warddescobj.value=="")){          
         stdateobj.value=stdate              
      }          
   }        
   ClearFlagobj.value="1"  
}

function clear_click()
{
   var warddescobj=document.getElementById('Warddesc');
   var wardidobj=document.getElementById('Wardid');
   var ClearFlagobj=document.getElementById("ClearFlag");
   warddescobj.value=""
   wardidobj.value=""
   ClearFlagobj.value=""   
   setdate()
   var Findobj=document.getElementById('Find');
   Findobj.click()      	
}
function wardlookup(str)
{
   var obj=document.getElementById('Wardid');
   var tem=str.split("^");
   if (tem[1]=='0'){
      tem[1]=""
   }
   obj.value=tem[1]; 
   var Findobj=document.getElementById('Find');
   Findobj.click();	
}
function PrintWardDay_click()
{
   var warddescobj=document.getElementById('Warddesc');
	var warddesc=warddescobj.value
	var wardidobj=document.getElementById('Wardid');
	var wardid=wardidobj.value
	if ((warddesc=="")||(wardid=="")||(wardid=='0')){
	   alert(t['Prt01']);
	   return;
	}
	CommonPrint("UDHCJFIPYJJWDZZ");		
}
document.body.onload = BodyLoadHandler;
document.body.onbeforeunload=UnloadHandler;