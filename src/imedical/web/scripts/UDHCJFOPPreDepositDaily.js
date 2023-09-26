var job
function BodyLoadHandler() {  
  gusercode=session['LOGON.USERCODE']  
  //gusercode=492
  var prt=document.getElementById("Print");
  if (prt)
  {
     prt.onclick=Print_click;	  
  }  
  var handinobj=document.getElementById("Handin");
  handinobj.onclick=gethandin;
  var obj=document.getElementById("BHandin");
  if (obj) obj.onclick=BHandin_Click;
  //var findjsobj=document.getElementById("findjs");
  //if (findjsobj) DHCWeb_DisBtn(findjsobj);   
  gethandin()
}
function BHandin_Click()
{
	var handencobj=document.getElementById("HandinEncmeth");
	if (handencobj) {var encmeth=handencobj.value} else {var encmeth=''};
	var myinfo="";
	var myrtn=confirm(t['03']);
	if (myrtn==false)
	{
		return;
	}
    var stdate=document.getElementById('StDate').value
    var sttime=document.getElementById('StartTime').value
    var enddate=document.getElementById('EndDate').value
    var endtime=document.getElementById('EndTime').value
    var Guser=session['LOGON.USERID']
    //var Guser=640
	myinfo=stdate+"^"+sttime+"^"+enddate+"^"+endtime
	alert(myinfo)
	if (encmeth!="")
	{
		var rtn=(cspRunServerMethod(encmeth,Guser,myinfo)) 
	}
	var mytmpary=rtn.split("^");
	if (mytmpary[0]=="0") 
	{
		alert(t["01"]);
		var obj=document.getElementById("BHandin");
		DHCWeb_DisBtn(obj);		
	}else{
		alert(t["02"]);	  
	}
}
function findjs_click()
{	
	var stdate=document.getElementById('StDate').value
	var enddate=document.getElementById('EndDate').value
	var Guser=session['LOGON.USERID']
	 //var Guser=640                                    
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOPDayRptHis&stdate='+stdate+'&enddate='+enddate+'&Guser='+Guser+'&findflag='+"PreDept"
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0')  
}
function Print_click()
{  
   var SelRowObj=document.getElementById('TJobz'+1);
   job=SelRowObj.innerText;
   document.getElementById("job").value=job 
   CommonPrint("UDHCJFOPPrtDeptDaily");      
}
function gethandin()
{ var handinobj=document.getElementById("Handin");
  var handin=handinobj.checked;
  var stdateobj=document.getElementById('StDate');
  var enddateobj=document.getElementById('EndDate');
  var Myobj=document.getElementById('Myid');
   if (Myobj)
  {
     var imgname="ld"+Myobj.value+"i"+"StDate"
     var stdateobj1=document.getElementById(imgname);
     var imgname="ld"+Myobj.value+"i"+"EndDate"
     var enddateobj1=document.getElementById(imgname);
  } 
  if (handin==true){
      stdateobj1.style.display="";
	  stdateobj.readOnly=false;
	  enddateobj1.style.display="";
	  enddateobj.readOnly=false;
	  var findobj=document.getElementById("Find");
	  if (findobj){ 
   		findobj.disabled=true;
	  }
	  var findjsobj=document.getElementById("findjs");
	  	if (findjsobj){ 
   			findjsobj.disabled=false;
   			findjsobj.onclick=findjs_click;
   		}
	var obj=document.getElementById("BHandin");
         if (obj) {obj.disabled=true;
		}
   }
   if (handin==false){
	  getnotjkdate() 
	  stdateobj1.style.display="none";
	  stdateobj.readOnly=true;
	  var findobj=document.getElementById("Find");
	  if (findobj){ 
   		findobj.disabled=false;
	  }
	  var findjsobj=document.getElementById("findjs");
	  if (findjsobj){ 
   		findjsobj.disabled=true;
   		findjsobj.onclick=findjs_click;
	  }
	var obj=document.getElementById("BHandin");
         if (obj) {
		obj.disabled=false;
		obj.onclick=BHandin_Click;
		}
  }

}
function getnotjkdate()
{ 
  var user=session['LOGON.USERID']
  
   //var user="640"
   var getstdate=document.getElementById('getstdate');
   if (getstdate) {var encmeth=getstdate.value} else {var encmeth=''};
   var datestr=cspRunServerMethod(encmeth,user)
   datestr=datestr.split("^")
   document.getElementById('StDate').value=datestr[0]
   document.getElementById('StartTime').value=datestr[1]
   document.getElementById('EndDate').value=datestr[2]
   document.getElementById('EndTime').value=datestr[3]
}
function UnloadHandler()
{	
   var flag="EPPreDeptDailyHand"
   var job=document.getElementById('job').value
   var user=session['LOGON.USERID']
   //var user="640" 
   var killobj=document.getElementById('Killtmp');
   if (killobj) {var encmeth=killobj.value} else {var encmeth=''};
   if (cspRunServerMethod(encmeth,flag,user,job)==0)
   {
	   alert("kill error")
   }
}

document.body.onload = BodyLoadHandler;