var SelectedRow = 0;
var Adm,Prtrowid,Arpbl,PrtStatus,CurNo,EndNo,Title,RcptRowid,JkFlag
var obj,Guser
var RcptFlag 
var Objtbl,Rows,Sum,payamt,i,status,select
var returnval,path
var gusername
var clickflag=0
var curyear,curmon,curday
function BodyLoadHandler() 
{
	RcptFlag="Y" 
    Guser=session['LOGON.USERID']
    //Adm=parent.frames['UDHCJFAddDeposit'].document.getElementById('Adm').value;
    Adm=document.getElementById("Adm").value
	obj=document.getElementById("RefundDeposit");
	if (obj) obj.onclick=Refund_click;
	obj=document.getElementById("AbortDeposit");
	if (obj) obj.onclick=Abort_click; 
	getpatinfo()
	GetSum()     
	gettoday()
	

}
function getpatinfo()
{	  
    var infro=document.getElementById('getpatinfo');
	if (infro) {var encmeth=infro.value}else {var encmeth=''};
	var returnvalue=cspRunServerMethod(encmeth,"","",Adm)
	var sub = returnvalue.split("^")
    document.getElementById('papno').value=sub[7]
    document.getElementById('name').value=sub[0]
    document.getElementById('admdate').value=sub[1]
    document.getElementById('disdate').value=sub[12]
    document.getElementById('patward').value=sub[3]
    document.getElementById('patzyno').value=sub[10]
    var EncryptLevelObj=document.getElementById('EncryptLevel')
    if(EncryptLevelObj) {EncryptLevelObj.value=sub[14]}
    var PatLevelObj=document.getElementById('PatLevel')
    if(PatLevelObj) {PatLevelObj.value=sub[15]}

}

function gettoday(){
 var d=new Date();
 curday=d.getDate()
 curmon=d.getMonth()+1
 curyear=d.getYear();
}
function Refund_click()
{
	var obj
	selectrow=SelectedRow;
	clickflag=1
    var truthBeTold = window.confirm(t['23']);
    if (!truthBeTold) { return ;}
	if (!Prtrowid)
	{alert(t['01'])
	 return }
    if ((Arpbl!="")&&(Arpbl!=" "))
    {alert(t['02'])
     return;}
    if (PrtStatus==t['18'])
    {alert(t['03'])
     return;}
    if (PrtStatus==t['20'])
	{alert(t['04'])
	 return false ;}
  	if (PrtStatus==t['19'])
   	{alert(t['05'])
	 return false ;}
	
	var getstatus=document.getElementById('getprtstatus');
	if (getstatus) {var encmeth=getstatus.value} else {var encmeth=''};
	
	if (cspRunServerMethod(encmeth,Prtrowid)=='4') 
	{   alert(t['27'])
	    return;
			}    	
	if (RcptFlag=="Y")
	{var rcptno=document.getElementById('getrcptno');
	if (rcptno) {var encmeth=rcptno.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'GetRcptNo','',Guser)=='0') {
			} 
	}
	if (RcptFlag=="N")
	{ rcptno="" 
	  CurNo=""
	  EndNo=""}
    if (RcptFlag=="Y")
	{  var nextno
	   nextno=document.getElementById('getnextno');
	   if (nextno) {var encmeth=nextno.value} else {var encmeth=''};
	   if (cspRunServerMethod(encmeth,'GetNextNo','',CurNo)=='0') {
			} 
	}
	
	var Refund=document.getElementById('Refund');
	if (Refund) {var encmeth=Refund.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetPid','',CurNo,EndNo,Prtrowid,Guser,RcptRowid,RcptFlag)=='0') {
			}	
}
function GetRcptNo(value)
{
    var sub = value.split("^")
	var rcptrowid=sub[0]
	if (rcptrowid=="")
	{
	   alert(t['06'])
	   return false
    }
	EndNo=sub[1]
	CurNo=sub[2]
	Title=sub[3]
}
function GetNextNo(value)
{   
   if (parseInt(value,10)>parseInt(EndNo,10))
  {
       alert(t['07'])
       return false ;
  }
}
function SetPid(value) 
{   
	if (value!="0")
	{alert(t['08']);
	return;}
	try{	
	    alert(t['09']);	   
	    if ((RcptFlag=="Y")&&(clickflag==1)) {
		    var getyjdetail=document.getElementById('getyjdetail');
	        if (getyjdetail) {var encmeth=getyjdetail.value} else {var encmeth=''};
	        var patinfo=cspRunServerMethod(encmeth,'','',Prtrowid);
	        var getpath=document.getElementById('getpath');
	        if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	        path=cspRunServerMethod(encmeth,'','');
	        gusername=session['LOGON.USERNAME']
	        gusercode=session['LOGON.USERCODE']
	        returnval=patinfo
	       
	        printYJ()
	      
		    }	
		
	    window.location.reload();
	   // parent.frames['UDHCJFFindDeposit'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFFindDeposit&Adm="+Adm; 
   
   		//parent.frames['UDHCJFAddDeposit'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFAddDeposit&Adm="+Adm; 
    
		} catch(e) {};
		
}
function Abort_click()
{ 
    clickflag=2
    var truthBeTold = window.confirm(t['28']);
    if (!truthBeTold) { return ;}
	if (!Prtrowid)
	   {alert(t['10'])
		 return false}
	if ((Arpbl!="")&&(Arpbl!=" "))
	   {alert(t['11'])
	    return false}
	if (JkFlag=="Y")
		{alert(t['12'])
		 return false}
	if (PrtStatus==t['20'])
	   {alert(t['13'])
		return false}
	if (PrtStatus==t['19'])
	   {alert(t['14'])
		return false}
	if (PrtStatus==t['18'])
	   	{alert(t['15']+rcptno+t['16'])
		 return false}
	
	var Abort=document.getElementById('Abort');
	if (Abort) {var encmeth=Abort.value} else {var encmeth=''};
	
	if (cspRunServerMethod(encmeth,'SetPid','',Prtrowid,RcptRowid,Guser)=='0') {
			} 
	
}
function SelectRowHandler()	
{   var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tUDHCJFFindDeposit');
	Rows=Objtbl.rows.length;
	GetSum()
	
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	obj=document.getElementById('prtrowid');
	SelRowObj=document.getElementById('Tprtrowidz'+selectrow);
    Prtrowid=SelRowObj.value;
	obj.value=Prtrowid
	SelRowObj=document.getElementById('Tarpblz'+selectrow);
	Arpbl=SelRowObj.value;
	
	//Arpbl=Arpbl.charCodeAt(0)
	SelRowObj=document.getElementById('Tprtstatusz'+selectrow);
	PrtStatus=SelRowObj.innerText;
	SelRowObj=document.getElementById('Trcptrowidz'+selectrow);
	RcptRowid=SelRowObj.value;
	SelRowObj=document.getElementById('Tjkflagz'+selectrow);
	JkFlag=SelRowObj.innerText;
	//var obj=document.getElementById('Adm');
	//var TrakMenuDoc=parent.frames['eprmenu'].document;
	//var TrakMenuADM=TrakMenuDoc.getElementById('EpisodeID');
	//var TrakMenuBill=TrakMenuDoc.getElementById('BillRowIds');
	//obj.value=TrakMenuADM.value
	SelectedRow = selectrow;

}
function GetSum()
{   
    Sum=0;
    Objtbl=document.getElementById('tUDHCJFFindDeposit');
	Rows=Objtbl.rows.length;
	Sum=0
	
	for (i=1;i<=Rows-2;i++)
	{  
	   SelRowObj=document.getElementById('Tprtstatusz'+i);
	   prtstatus=SelRowObj.innerText;
	   
	  	if (prtstatus!="正常") {   
	  		//Objtb.rows[i].style.background="red" //设置背景色
		   	Objtbl.rows[i].style.color='red' //设置前景色
	   	}
	 
	}
	
}
document.body.onload = BodyLoadHandler;
