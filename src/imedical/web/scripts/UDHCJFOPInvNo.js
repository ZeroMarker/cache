///UDHCJFOPInvNo.js
var guser,username
var SelectRowId,RowId
var flag
var Tuserid
function BodyLoadHandler() {
	flag=document.getElementById('flag').value
	guser=session['LOGON.USERID']
	username=session['LOGON.USERNAME']
	document.getElementById('Guser').value=guser	
	var updobj=document.getElementById('Update');
	if (updobj) {updobj.onclick=Update_click  }
	usernameobj=document.getElementById("username");
	usernameobj.onkeydown=getuser;
	Tuserid=""
	SelectRowId=""
	var Myobj=document.getElementById('Myid');    
    if (Myobj){
	    var imgname="ld"+Myobj.value+"i"+"username"
	    var usernameobj1=document.getElementById(imgname);  }
	if (flag=="0"){
	   usernameobj1.readOnly=true;
	   usernameobj1.style.display="none"	   	   
	}
	if (flag=="1"){
	   usernameobj1.readOnly=false;
	   usernameobj1.style.display=""	
	}
	if (usernameobj.value=="")
	{usernameobj.value=username
	document.getElementById("userid").value=guser;}	
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tUDHCJFOPInvNo');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) 
	{  
		return;}
    if (SelectRowId!=selectrow)		
	{var SelRowObj=document.getElementById('TRowIdz'+selectrow);
	RowId=SelRowObj.innerText;
	SelRowObj=document.getElementById('TCurNoz'+selectrow);
	var CurNo=SelRowObj.innerText;
	SelRowObj=document.getElementById('TEndNoz'+selectrow);
	var EndNo=SelRowObj.innerText;
	SelRowObj=document.getElementById('TFlagz'+selectrow);
	var flag=SelRowObj.innerText;
	document.getElementById("UseFlag").value=flag
	document.getElementById('CurNo').value=CurNo
	document.getElementById('EndNo').value=EndNo
	SelectRowId=selectrow
	SelRowObj=document.getElementById('Tuseridz'+selectrow);
	Tuserid=SelRowObj.innerText}
	else
	{document.getElementById('CurNo').value=""
	 document.getElementById('EndNo').value="" 
	 document.getElementById('UseFlag').value="" 
	 SelectRowId=""
	 usernameobj.value=username
	 document.getElementById("userid").value=guser;
	  }
		
}
function Update_click()
{   
    var userid=document.getElementById('userid').value;
    if ((userid!=Tuserid)&&(Tuserid!="")){
	   alert(t['08']);
	   return;
	}
	var curno="",endno=""
	curno=document.getElementById('CurNo').value;
    endno=document.getElementById('EndNo').value;
    var flag=document.getElementById('UseFlag').value;
    if (curno=="") 
    {   alert(t['02'])
        return
    }
	if (endno=="")
	{   alert(t['03'])
	    return 
	} 
	
	if (parseInt(curno,10)>parseInt(endno,10))
	{
	    alert(t['04'])
	    return
    }
	/*
	if (eval(curno)>eval(endno))
	{
		alert(t['04'])
		return
	} 
    */
    if (parseInt(curno,10)==parseInt(endno,10))
	{
	    flag="“—”√ÕÍ"
    }
   
    var updobj=document.getElementById('UpdateInvNo');
	if (updobj) {var encmeth=updobj.value} else {var encmeth=''};
	if (encmeth){
	    var retval=cspRunServerMethod(encmeth,userid,RowId,curno,endno,flag)
	    if (retval=="GuserNull"){
		   alert(t['GuserNull']);
		   return;
		}else if (retval=="RowIdNull") {
		   alert(t['RowIdNull']);
		   return;
		}else if (retval=="CurNoNull") {
		   alert(t['CurNoNull']);
		   return;
		}else if (retval=="AlreadyUseUp") {
		   alert(t['AlreadyUseUp']);
		   return;
		}else if (retval=="StarLess") {
		   alert(t['StarLess']);
		   return;
		}else if (retval=="EndLess") {
		   alert(t['EndLess']);
		   return;
		}else if (retval=="CurLess") {
		   alert(t['CurLess']);
		   return;
		}else if (retval!=0) {
		    alert(t['UpdateErr'])
		    return;
	    }else {
	       alert(t['UpdateSucc']);
	       var findobj=document.getElementById('Find');
           if (findobj) findobj.click()
	    }   	  
	}
}
function getuserid(value)	{
	var user=value.split("^");
	var obj=document.getElementById('userid');
	obj.value=user[1];
	Find_click()
}
function getuser()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  username_lookuphandler();
		}
}
function GetUseFlag()
{
}
document.body.onload = BodyLoadHandler;
