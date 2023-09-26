
///UDHCJFrcptnum.js
var mydata=new Array()
var yjColumns,gusername
var skuserid,job
function BodyLoadHandler() {
	gusername=session['LOGON.USERNAME']    
    var obj=document.getElementById("Find") 
       if (obj){obj.onclick=Find_onclick;}
    var obj=document.getElementById("Print") 
       if (obj){obj.onclick=printalldetail}
    var obj=document.getElementById("lquser")
    if(obj) {obj.onkeyup=clearlquser;}

}
function clearlquser()
{
	var key=websys_getKey(e);
	if((key==8)||(key==46))
	{
      document.getElementById('skuserid').value="";
	  document.getElementById('lquser').value="";	
	}
	
}
function Find_onclick()
{
	Find_click();	
}

function getuserid(value)	{

	var str=value.split("^");
	skuserid=document.getElementById('skuserid');
	skuserid.value=str[1];
}	
function printalldetail()
{
	/*
	var Objtbl=document.getElementById('tUDHCJFrcptnum');
	Rows=Objtbl.rows.length;
    if (Rows<2) return;
    var SelRowObj=document.getElementById('Tjobz'+i);
	var job=SelRowObj.innerText;
    var useridStr=tkMakeServerCall("web.DHCIPBillInvDepCollect","GetUserID",job)
    var useridNum=useridStr.split("^").length
    */
    PrintInvDepNOALLDetails();
}

function printdetail(){
	var Objtbl=document.getElementById('tUDHCJFrcptnum');
	Rows=Objtbl.rows.length;
	alert(Rows);
    if (Rows<2) return;
	for (i=1;i<Rows;i++){
	var SelRowObj=document.getElementById('Tjkdatetimez'+i);
	var datetime=SelRowObj.innerText;
	SelRowObj=document.getElementById('TuserNamez'+i);
	var userName=SelRowObj.innerText;
	SelRowObj=document.getElementById('TDepNOInfoz'+i);
	var depNOInfo=SelRowObj.innerText;
	SelRowObj=document.getElementById('TDepNumz'+i);
	var depNum=SelRowObj.innerText;
	SelRowObj=document.getElementById('TStrikeDepNOz'+i);
	var StrikeDepNO=SelRowObj.innerText;
	SelRowObj=document.getElementById('TStrikeDepNumz'+i);
	var StrikeDepNum=SelRowObj.innerText;
	SelRowObj=document.getElementById('TAbortDepNOz'+i);
	var AbortDepNO=SelRowObj.innerText;
	SelRowObj=document.getElementById('TAbortDepNumz'+i);
	var AbortDepNum=SelRowObj.innerText;
	SelRowObj=document.getElementById('TInvNOInfoz'+i);
	var InvNOInfo=SelRowObj.innerText;
	SelRowObj=document.getElementById('TInvNumz'+i);
	var InvNum=SelRowObj.innerText;
	SelRowObj=document.getElementById('TStrikeInvNOz'+i);
	var StrikeInvNO=SelRowObj.innerText;
	SelRowObj=document.getElementById('TStrikeInvNumz'+i);
	var StrikeInvNum=SelRowObj.innerText;
	SelRowObj=document.getElementById('TAbortInvNOz'+i);
	var AbortInvNO=SelRowObj.innerText;
	SelRowObj=document.getElementById('TAbortInvNumz'+i);
	var AbortInvNum=SelRowObj.innerText;
	
	var str=datetime+"^"+userName+"^"+depNOInfo+"^"+depNum+"^"+StrikeDepNO+"^"+StrikeDepNum+"^"+AbortDepNO+"^"+AbortDepNum
	str=str+"^"+InvNOInfo+"^"+InvNum+"^"+StrikeInvNO+"^"+StrikeInvNum+"^"+AbortInvNO+"^"+AbortInvNum
    // mydata[i-1]=str.split("^"); 
    mydata[i-1]=str
	}
	PrintInvDepNODetails();  //调用UDHCJFDayPrint.js方法
	
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
	if (eval(date1[0])>eval(date[0])){end1obj.value="";endobj.value="";alert(t['01']);return}
	
	if ((eval(date1[0])==eval(date[0]))&(eval(date1[1])>eval(date[1]))){end1obj.value="";endobj.value="";alert(t['01']);return}
	if ((eval(date1[0])==eval(date[0]))&(eval(date1[1])==eval(date[1]))&(eval(date1[2])>eval(date[2]))){end1obj.value="";endobj.value="";alert(t['01']);return}
	}
}
	



document.body.onload = BodyLoadHandler;