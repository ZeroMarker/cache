var typeobj,lquserobj;
var typestatus
var m_AmtMRowID=""
var selectrowid,ConfirmFlag,ReturnFlag
function BodyLoadHandler() {
	
	typestatus="0"
	var obj=document.getElementById('BtnConfirm');
	if (obj) obj.onclick = Confirm_Click;
	var obj=document.getElementById('BtnReturn');
	if (obj) obj.onclick = Return_Click;
	typeobj=document.getElementById('type');
	lquserobj=document.getElementById('lquser');
	//if (lquserobj) lquserobj.readOnly=true;
	
	var obj=document.getElementById("stdate1");
	   obj.onkeydown=getstdate;
    if (obj.value==""){getdate()}
    var obj=document.getElementById("enddate1") 
       obj.onkeydown=getenddate
	 if (obj.value==""){getdate()}
	if (typestatus=="1"){
	   getmyid()
	}
	selectrowid="";
}
	
function getmyid(){
	var Myobj=document.getElementById('Myid');
    if (Myobj){
        var imgname="ld"+Myobj.value+"i"+"type"
        var typeobj1=document.getElementById(imgname);
        typeobj1.style.display="none"
        typeobj.readOnly=true
    }
}

function getdate() {	
	var getdateobj=document.getElementById('today');
	if (getdateobj) {var encmeth=getdateobj.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'setdate_val','','')=='1'){
				};
	}

function setdate_val(value)	{ 
	  var enddate1=document.getElementById('enddate1')
	  var enddate=document.getElementById('enddate')
	  var stdate1=document.getElementById('stdate1')
	  var stdate=document.getElementById('stdate')
	  today=value;
	    curdate=value;
		var curdate1=value
	    var str=curdate.split("/")
		
		curdate=str[2]+"-"+str[1]+"-"+str[0]
		if (enddate1.value==""){
		enddate1.value=curdate					
		enddate.value=curdate1}
		if (stdate1.value==""){
		stdate1.value=curdate					
		stdate.value=curdate1}
		checkdate()
				
		}
function checkdate(){
	var end1obj=document.getElementById('enddate1')
	var endobj=document.getElementById('enddate')
	var enddate1=document.getElementById('enddate1').value
	var stdate1=document.getElementById('stdate1').value

	if ((enddate1!="")&(stdate1!="")){
     var date=enddate1.split("-")
	 var date1=stdate1.split("-")
	if (eval(date1[0])>eval(date[0])){end1obj.value="";end1obj.value="";alert(t['07']);return}
	if (eval(date1[1])>eval(date[1])){end1obj.value="";end1obj.value="";alert(t['07']);return}
	if (eval(date1[2])>eval(date[2])){end1obj.value="";end1obj.value="";alert(t['07']);return}
	}
	
}
function setstartno_val(value){
	//alert(value)
	var val=value.split("^")
	if (val[3]=="") {
		var maxno=document.getElementById('maxno');
		if (maxno) {maxno.value="";
			maxno.readOnly=true;
		}
		var startno=document.getElementById('startno');
		if (startno) startno.value="";
		alert(t['01']);
		return;
	}
	
	m_AmtMRowID=val[3];
	var startno=document.getElementById('startno');
	startno.value=val[2];
	var title=document.getElementById('Title');
	title.value=val[4];
	var maxno=document.getElementById('maxno');
	if (maxno) {
		maxno.value=val[1];
		maxno.readOnly=true;
	}
	if (val[2]=="") {
		websys_setfocus('startno');
	}
	else
	{
		websys_setfocus('endno');
	}
		
}
	
	

function getstdate(){
   var key=websys_getKey(e);
	if (key==13) {
   var mybirth=DHCWebD_GetObjValue("stdate1");
	if ((mybirth=="")||((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("stdate1");
		obj.className='clsInvalid';
		websys_setfocus("stdate1");
		return websys_cancel();
	}else{
		var obj=document.getElementById("stdate1");
		obj.className='clsvalid';
	}
	if ((mybirth.length==8)){
		var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		DHCWebD_SetObjValueA("stdate1",mybirth);
	}
	////alert(mybirth);
	var myrtn=DHCWeb_IsDate(mybirth,"-")
	if (!myrtn){
		var obj=document.getElementById("stdate1");
		obj.className='clsInvalid';
		websys_setfocus("stdate1");
		return websys_cancel();
	}else{
		var obj=document.getElementById("stdate1");
		obj.className='clsvalid';
	}
	checkdate()
	var obj=document.getElementById("stdate1")
	var str1=obj.value.split("-")
	var str2=str1[2]+"/"+str1[1]+"/"+str1[0]
	var stdateobj=document.getElementById("stdate")
	stdateobj.value=str2
	websys_setfocus('enddate1')
	}		
	}
function getenddate(){
	var key=websys_getKey(e);
	if (key==13) {
	var mybirth=DHCWebD_GetObjValue("enddate1");
	if ((mybirth=="")||((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("enddate1");
		obj.className='clsInvalid';
		websys_setfocus("enddate1");
		return websys_cancel();
	}else{
		var obj=document.getElementById("enddate1");
		obj.className='clsvalid';
	}
	if ((mybirth.length==8)){
		var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		DHCWebD_SetObjValueA("enddate1",mybirth);
	}
	////alert(mybirth);
	var myrtn=DHCWeb_IsDate(mybirth,"-")
	if (!myrtn){
		var obj=document.getElementById("enddate1");
		obj.className='clsInvalid';
		websys_setfocus("enddate1");
		return websys_cancel();
	}else{
		var obj=document.getElementById("enddate1");
		obj.className='clsvalid';
	}
	checkdate()
	var obj=document.getElementById("enddate1")
	var str1=obj.value.split("-")
	var str2=str1[2]+"/"+str1[1]+"/"+str1[0]
	var enddateobj=document.getElementById("enddate")
	enddateobj.value=str2
	websys_setfocus('find')
	}	
}


//function Find_Click(){}
function getuserid(value)	{
	var user=value.split("^");
	var obj=document.getElementById('lquserid');
	obj.value=user[1];
}
function gettype()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  type_lookuphandler();
		}
	}
function getuser()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  lquser_lookuphandler();
		}
	}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tUDHCJFInvprtGrantUserSearch');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
  
	if (!selectrow) return;
	var SelRowObj=document.getElementById('Trowidz'+selectrow);
    selectrowid=SelRowObj.innerText;
    ConfirmFlag=document.getElementById('TConfirmFlagz'+selectrow).innerText
    ReturnFlag=document.getElementById('TReturnFlagz'+selectrow).innerText
}
function Confirm_Click()
{  
    if (ConfirmFlag=="Y")
    {   alert(t['03'])
        return
    }
	var getconfirm=document.getElementById('GetConfirm');
	if (getconfirm) {var encmeth=getconfirm.value} else {var encmeth=''};
		if (cspRunServerMethod(encmeth,selectrowid)==0)
		{
			alert(t['01'])
		}
		else
		{
			alert(t['02'])
			return
		}
		//window.location.reload();
		Find_click();
}
function Return_Click()
{   if (ReturnFlag=="Y")
    {   alert(t['04'])
        return
    }
	if ((selectrowid=="")||(selectrowid==" ")){
		alert("请选择要退回的发票记录!!");
		return;
	}
	if (selectrowid=="undefined"){
		alert("请选择要退回的发票记录!!");
		return;
	}
	
	var getreturn=document.getElementById('GetReturn');
	var HospDr=session['LOGON.HOSPID']
	if (getreturn) {var encmeth=getreturn.value} else {var encmeth=''};
		if (cspRunServerMethod(encmeth,selectrowid,HospDr)==0)
		{   alert(t['01'])      }
		else
		{   alert(t['02'])      }
    //window.location.reload();
    Find_click()
}
document.body.onload = BodyLoadHandler;