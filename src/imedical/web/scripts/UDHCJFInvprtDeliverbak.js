var guser,GuserCode;
var SelectedRow = 0;
var maxrowid ;
var stno;
var endno;
var judgepass1 = 0;
var judgepass2 = 0;
var type1obj,deliveruserobj;
var typestatus,passstatus
function BodyLoadHandler() {
	var num = 0;
	typestatus="0"
	passstatus="0"
    guser=session['LOGON.USERID']
    GuserCode=session["LOGON.USERCODE"]
    
    var guseridobj=document.getElementById('guserid');
    guseridobj.value=guser
    
    //var obj=document.getElementById('giveuser')
    //obj.value=GuserCode
    //if (obj) { obj.onkeydown=getgiveuser }
    //if (obj.value==""){guseridobj.value=""}
    
	 obj=document.getElementById('deliver');
	if (obj) obj.onclick = deliver_Click;
	var obj=document.getElementById("stdate1");
	   obj.onkeydown=getstdate;
	if (obj.value==""){getdate()}
    var obj=document.getElementById("enddate1") 
       obj.onkeydown=getenddate
       if (obj.value==""){getdate()}
       
	var numobj=document.getElementById('delivernum');
	if (numobj) numobj.onkeyup = celendno;
	type1obj=document.getElementById("type");
	if (typestatus=="1"){
		getmyid()
	}
	//type1obj.onkeydown=gettype;
	deliveruserobj=document.getElementById("deliveruser");
	deliveruserobj.onkeydown=getuser;
	
	//StartNo()
	getinvmax()
	document.getElementById('Startno').readOnly=true
	//query_Click()	

}
function StartNo()
{  
    var gettype
    selectrow=SelectedRow;
    var obj=document.getElementById('type');
    gettype=obj.value

    var obj=document.getElementById('guserid')
    
    var guserid=obj.value
    if (guserid==""){return;}
   
    var getstno=document.getElementById('getstno');
    if (getstno) {var encmeth=getstno.value} else {var encmeth=''};	
	if (cspRunServerMethod(encmeth,'SetNo','',guserid,gettype)=='0') {
			};	
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
function getmyid(){
	var Myobj=document.getElementById('Myid');
    if (Myobj){
        var imgname="ld"+Myobj.value+"i"+"type"
        var typeobj1=document.getElementById(imgname);
        typeobj1.style.display="none"
        type1obj.readOnly=true
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
function SetNo(value)
{   
    var str=value    
    var str1=str.split("^")
	var obj=document.getElementById('Startno');
	obj.value=str1[0];
	var obj1=document.getElementById('endno');
	obj1.value=str1[1];
	
	//obj2=document.getElementById('type');
	//obj2.value=str[2];
	var obj3=document.getElementById('kyendno');
	obj3.value=str1[1];
	var obj4=document.getElementById('kyrowid');
	obj4.value=str1[3];	
	if ((str1[1]!="")&(str1[0]!="")){
	var num=eval(parseInt(str1[1],10))-eval(parseInt(str1[0],10))+1
	var obj5=document.getElementById('delivernum');
	obj5.value=num;}
}
function deliver_Click() {
	 var stnoobj=document.getElementById('Startno');
	 if (stnoobj) var startno=stnoobj.value;
	 var endnoobj=document.getElementById('endno');
	 if (endnoobj) var endno=endnoobj.value;
	 var buyuserobj=document.getElementById('guserid');
	 if (buyuserobj) var buyuser=buyuserobj.value;
	 var typeobj=document.getElementById('type');
	 if (typeobj) var type=typeobj.value;	
	 var kyendobj=document.getElementById('kyendno');
	 if (kyendobj) var kyendno=kyendobj.value;
	 var kyrowidobj=document.getElementById('kyrowid');
	 if (kyrowidobj) var kyrowid=kyrowidobj.value;

	 var userid1=buyuser;
	 var useflag=""
	 if (type==""){
	    alert(t['01']);
	    websys_setfocus('type');
		return false;
	 }
	 if (startno==""||endno=="") {
		alert(t['02']);
	    websys_setfocus('endno');
	    return false;
	 }	  
	 if (!checkno(startno)) {
	    alert(t['05']); 
	    websys_setfocus('Startno');
	    return false;
	 }
	 if (!checkno(endno)) {
	    alert(t['06']);
	    websys_setfocus('endno');
	    return false;
	 }
	 if (parseInt(kyendno,10)<parseInt(endno,10))
	 {  alert(t['16']);
	    websys_setfocus('endno');
		return false;
	 } 
	 if (parseInt(endno,10)<parseInt(startno,10))
	 {  alert(t['07']);
	    websys_setfocus('endno');
		return false;
	 } 
	 if (endno.length!=startno.length)
	 {  alert(t['08']);
	    websys_setfocus('endno');
		return false;
	 } 
	 var userobj=document.getElementById('zjuserid');
	 if (userobj) var userid=userobj.value
	 if (userid=="") {
		 alert(t['09']);
		 websys_setfocus('deliveruser');
		 return
	 }
	if (userid==buyuser) {
		 alert(t['15']);
		 userobj.value=""
		 var obj=document.getElementById('deliveruser')
		 obj.value=""
		 websys_setfocus('deliveruser');
		  return
		 }	 
	if (passstatus=="1"){
	   judgepass1=1
	   judgepass2=1	}
	if (passstatus=="0"){
	   var pass1obj=document.getElementById('passward1');
	   if (pass1obj) var pass1=pass1obj.value;
	   var pass2obj=document.getElementById('passward2');
	   if (pass2obj) var pass2=pass2obj.value;	
	   if (pass1=="") {
		 alert(t['03']);
		 websys_setfocus('passward1');
		 return
		 }
	   if (pass2=="") {
		 alert(t['04']);
		 websys_setfocus('passward2');
		 return
		 }
	    var strpwd=userid1+"^"+pass1
	    var judgepwd=document.getElementById('judgepwd');
	    if (judgepwd) {var encmeth=judgepwd.value} else {var encmeth=''};
		if (cspRunServerMethod(encmeth,'judgepwd','',strpwd)=='0'){
					};
	    var strpwd1=userid+"^"+pass2
	    var judgepwd1=document.getElementById('judgepwd1');
	    if (judgepwd1) {var encmeth=judgepwd1.value} else {var encmeth=''};
		if (cspRunServerMethod(encmeth,'judgepwd1','',strpwd1)=='0'){
		}
	 
	 }
	
	 if (judgepass1==1 & judgepass2==1) {
	  var str="^"+startno+"^"+endno+"^"+userid+"^"+kyendno+"^"+kyrowid+"^"+type+"^"+userid1
    
     var truthBeTold = window.confirm(t['10']+startno+t['11']+endno+t['12']);
     
     if (truthBeTold) {
	    var err="";
 		p1=str
 		var getadd=document.getElementById('getadd');
		if (getadd) {var encmeth=getadd.value} else {var encmeth=''};
		//var flag=cspRunServerMethod(encmeth,'addok','',p1)
		//alert("flag"+flag)
		if (cspRunServerMethod(encmeth,'addok','',p1)=='1'){alert(t['17'])
		};
       }
	 }	

	}
function addok(value)
{if (value==0) {
		var findobj=document.getElementById('query');
		if (findobj) findobj.click();
		
	//	window.location.reload();
		}
				
}
function judgepwd(value)
{  if (value=='100'){
	alert(t['13']);
	websys_setfocus('passward1');
	judgepass1=0
	} else
	{judgepass1=1
		}	
	}
function judgepwd1(value)
{  if (value=='100'){
	alert(t['14']);
	websys_setfocus('passward2');
	judgepass2=0
	} else
	{judgepass2=1
		}
	
	}
function query_Click()
{		
	}
function celendno() {

	var numobj=document.getElementById('delivernum');
	    if (numobj) var num=numobj.value
	   var snoobj=document.getElementById('Startno');
	    if (snoobj) var sno=snoobj.value
	    
	   var ssno=""
	   var ssno1,slen,sslen
	   if (num==""||(parseInt(num,10)==0)) return;
	   
       if (checkno(num)&&(sno!="")&&checkno(sno)) 
       {

	       ssno1=parseInt(sno,10)+parseInt(num,10)-1;
	       ssno=ssno1.toString()
	       slen=sno.length
	       sslen=ssno.length
	       for (i=slen;i>sslen;i--){
	        ssno="0"+ssno
	        }
	        var endnoobj=document.getElementById('endno');
	 if (endnoobj) endnoobj.value=ssno;
	       }
	    
	}
	
	function checkno(inputtext) {
        var checktext="1234567890"
        for (var i = 0; i < inputtext.length; i++) {
            var chr = inputtext.charAt(i);
            var indexnum=checktext.indexOf(chr);
            if (indexnum<0)  return false;
        }
        return true;
    }
    function getuserid(value)	{
	   var user=value.split("^");
	   var obj=document.getElementById('zjuserid');
	   obj.value=user[1];
    }
    
    function setgivuserid(value){
	    var user=value.split("^");
	   var obj=document.getElementById('guserid');
	   obj.value=user[1];
	    getinvmax()
	    
	    }
function getinvmax(){
	var typeobj=document.getElementById('type');
	if (typeobj) p1=typeobj.value
	var obj=document.getElementById('guserid');
	if (obj) var guserid=obj.value
	if (p1=="") return;
	//p1="I"
	
	var getstartno=document.getElementById('getstno');
	if (getstartno) {var encmeth=getstartno.value} else {var encmeth=''};	
	if (cspRunServerMethod(encmeth,'SetNo','',guserid,p1)=='1'){
		};
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
	  deliveruser_lookuphandler();
		}
	}

function getgiveuser(){
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  giveuser_lookuphandler();
		}
	
	}
	document.body.onload = BodyLoadHandler;