function BodyLoadHandler()
{
	var obj=document.getElementById("ExecReturn")
	if (obj) obj.onclick=executeReturn;
	var obj=document.getElementById("LockRetReq")
	if (obj) obj.onclick=LockRetReq;
//	var obj=document.getElementById("test")
//	if (obj) obj.onclick=refreshDisplayAfterSave;
	
	}
function getRetNewNo()
{
	//create and get return No 
    var getRetNo=document.getElementById('mCreateRetNo');
	if (getRetNo) {var encmeth=getRetNo.value} else {var encmeth=''};
	var newRetNo=cspRunServerMethod(encmeth,'SetPa','','RT')
	if (newRetNo=="") 
	{ alert(t['CANNOT_CREATE_NO']) ;
		return "" ;	}
	return newRetNo	
}
function LockRetReq() 
{
	var obj=parent.frames['dhcpha.seekpharetrequesttoret'].document.getElementById("retReqNo")
	if (obj) var ReqNo=obj.value;
	if (ReqNo!="")
	{
		var obj=document.getElementById("ReqNo")
		if (obj) obj.value=ReqNo;
		LockRetReq_click();
	}
	else
	{	
		alert(t['NO_SELECTEDREQ']) ;
		return ;
		}
}
function executeReturn()
{// the code for returning 
// 1.save the return data
// 2.handle the stock changing 
    
	//check the data
	var objtbl=parent.frames['dhcpha.phareturnbyreq'].document.getElementById("t"+"dhcpha_phareturnbyreq");
	if (objtbl)	var rowcnt=getRowcount(objtbl) ;
	if (rowcnt<1)
	{alert(t['NO_ROWS']) ;
	 return ;}

 	// check reason
 	var obj=document.getElementById("retreasonrowid")
 	if (obj)	var reasonid=obj.value;
 	if (reasonid==""){
	 	alert(t['NO_RETREASON']) ;
	 	return ;  }
	 	
	//create the No of return ;
	// 
	var RetNo=getRetNewNo();
	if (RetNo=="") return ;
	 
	for (var i=1;i<=rowcnt;i++)
	{  
		var obj=document.getElementById("TReturnQtyz"+i)
		if (obj)
		{
			var retqty=obj.innerText ;
			if (retqty>0)
			{
			 	//execute insert
			 	var obj=document.getElementById("TOEDISDR"+"z"+i);
			 	if (obj) var Oedisdr  = obj.value 
			 	var obj=document.getElementById("TINCLBDR"+"z"+i);
			 	if (obj) var Inclbdr = obj.value 
			 	var obj=document.getElementById("TADMDR"+"z"+i);
			 	if (obj) var Admdr = obj.value 
			 	var obj=document.getElementById("TRECLOCDR"+"z"+i);
			 	if (obj) var Reclocdr  = obj.value 
			 	var obj=document.getElementById("TADMLOCDR"+"z"+i);
			 	if (obj) var Admlocdr = obj.value
			 	var obj=document.getElementById("TDEPTDR"+"z"+i);
			 	if (obj) var DeptDr = obj.value 
			 	var obj=document.getElementById("TBEDDR"+"z"+i);
			 	if (obj) var BedDr = obj.value 
			 	var obj=document.getElementById("TRETRQDR"+"z"+i);
			 	if (obj) var  RetRqDR= obj.value 
			 	//var obj=document.getElementById("TReturnOper"+"z"+i);
			 	//if (obj) var UserDR = obj.value 
			 	var UserDR=session['LOGON.USERID']
			 	//var obj=document.getElementById(""+"z"+i);
			 	//if (obj) var DD = obj.value 
			 	//var obj=document.getElementById(""+"z"+i);
			 	//if (obj) var TT= obj.value 
			 	var DD=""
			 	var TT=""
			 	var obj=document.getElementById("TPrescNo"+"z"+i);
			 	if (obj) var Prescno= obj.innerText 
			 	var obj=document.getElementById("TReturnQty"+"z"+i);
			 	if (obj) var Qty= obj.innerText; 
			 	var obj=document.getElementById("TReturnPrice"+"z"+i);
			 	if (obj) var Price= obj.innerText 
			 	var obj=document.getElementById("TReturnAmt"+"z"+i);
			 	if (obj) var Amount= obj.innerText 
			 	var obj=document.getElementById("TCode"+"z"+i);
			 	if (obj) var itmcode= obj.value 
			 	var obj=document.getElementById("TUom"+"z"+i);
			 	if (obj) var Uom= obj.innerText 
			    
		 		var datastr="" ;
				datastr=Oedisdr+"^"+Inclbdr+"^"+Admdr+"^"+Reclocdr+"^"+Admlocdr;
				datastr=datastr+"^"+DeptDr+"^"+BedDr+"^"+RetRqDR+"^"+UserDR+"^"+DD+"^"+TT+"^"+Prescno;
				datastr=datastr+"^"+Qty+"^"+Price+"^"+Amount+"^"+RetNo+"^"+itmcode+"^"+Uom		;
			    var execRet=parent.frames['dhcpha.phareturnbyreq'].document.getElementById('mExecReturn');
				if (execRet) {var encmeth=execRet.value} else {var encmeth=''};
				var result=cspRunServerMethod(encmeth,'','',datastr,reasonid)
				if (result<0)
					{ alert(t['EXERET_FAILED']) ;
					  return ;	}
				}
		}		
	}
	alert(t['SAVE_SUCCEED']);
	if (confirm(t['ASKPRINT'])==true)  
	{
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.printphareturn&PhaRetNo="+RetNo
		window.open(lnk,"_TARGET","width=60,height=10")

	 }  
	refreshDisplayAfterSave()  ;
}
function refreshDisplayAfterSave()
{	//clear return list
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phareturnbyreq" ;	
	
	//reload the request data
	var obj=parent.frames['dhcpha.seekpharetrequesttoret'].document.getElementById("Seek");
	if (obj) {	obj.click();	}
}

function RetReasonLookUpSelect(str)
{	var reason=str.split("^") ;
	if (reason.length>0)
	{var reasonrowid=reason[1] ;
	 var obj=document.getElementById("retreasonrowid");
	 if (obj){
		 obj.value=reasonrowid;	 }
	 else
	 	obj.value="" ;
		}
}

document.body.onload=BodyLoadHandler;
