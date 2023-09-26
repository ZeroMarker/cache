var stktype;
var EditType=document.getElementById("EditType").value;
var objtbl=document.getElementById("t"+"dhcpha_transferreq");
var newReqItmRowid;
var newCode;
function BodyLoadHandler()
{
	var obj=document.getElementById("StkType")
	if (obj) stktype=obj.value;

	 var obj=document.getElementById("Close");
	 if (obj) obj.onclick=closewin;
	 var obj=document.getElementById("Clear");
	 if (obj) obj.onclick=clearwin;
	 var obj=document.getElementById("MakeComplete");
	 if (obj) obj.onclick=complete;
	 var obj=document.getElementById("AddNew");
	 if (obj) obj.onclick=InsReq;	
	 var obj=document.getElementById("AddItm");
	 if (obj) obj.onclick=InsReqItm;	
	 var obj=document.getElementById("UpdReq")
	 if (obj) obj.onclick=UpdReq;
	 var obj=document.getElementById("DelReq")
	 if (obj) obj.onclick=DelReq;	 
	 var obj=document.getElementById("StkCatGrp")
	 if (obj) obj.onchange=SetSCGCode;
	 var obj=document.getElementById("Qty")
	 if (obj) obj.onkeydown=startInsReq;
	 var obj=document.getElementById("t"+"dhcpha_transferreq")
	 if (obj) obj.onkeydown=handlerowchange;	 
	 var obj=document.getElementById("saveReqItm")
	 if (obj) obj.onclick=saveReqItm;	 
	 	 
	var obj=document.getElementById("ReqLoc"); //
	if (obj) 
	{
	obj.onkeydown=popReqLoc;
	 obj.onblur=ReqLocCheck;
	} //
	var obj=document.getElementById("clearItm"); // 
	if (obj) obj.onclick=clearItm;
	
	var obj=document.getElementById("ProvLoc"); //
	if (obj) 
	{obj.onkeydown=popProvLoc;
	 obj.onblur=ProvLocCheck;
	} //

	var obj=document.getElementById("Alias"); //
	if (obj) 
	{obj.onkeydown=popAlias;
	 obj.onblur=AliasCheck;
	} //

	var obj=document.getElementById("QtyPU"); 
	if (obj){ 
		obj.onblur=CalQty;
		obj.onkeydown=handleQtyPU;
	}
	 
	 var obj=document.getElementById("Rowid");
	 if (obj.value=="") 
	 {	setDefaults();
		 DisableItmEdits(true);	 }
	 else
	 {	 GetReqInfo(obj.value);	}

	SetStkCatGrpList();
	SetWinCenter(window);
	setdefaultfocus();
	
	setEditControlEnabled();
	
	}
function handlerowchange()
{
	
}
function startInsReq()
{if (window.event.keyCode==13) 
	{
	 InsReqItm();
	}
}

function clearItm()
{
	var objalias=document.getElementById("Alias");
	if (objalias) objalias.innerText=""
	var obj=document.getElementById("incirowid");
	if (obj) obj.innerText=""
	var obj=document.getElementById("Uom");
	if (obj) obj.length=0;
	var obj=document.getElementById("UomRowid");
	if (obj) obj.value="";
	
	var obj=document.getElementById("Qty");
	if (obj) obj.value="";
	var obj=document.getElementById("PackUOM");
	if (obj) obj.value="";

	var obj=document.getElementById("QtyPU");
	if (obj) obj.value="";
	var obj=document.getElementById("sp");
	if (obj) obj.value="";
	var obj=document.getElementById("stkqty");
	if (obj) obj.value="";
		
	objalias.focus();
	
}
function popReqLoc()
{	if (window.event.keyCode==13) 
{  	window.event.keyCode=117;
  ReqLoc_lookuphandler();
}
}
function ReqLocCheck()
{	// 
var obj=document.getElementById("ReqLoc");
var obj2=document.getElementById("ReqLocRowid");
if (obj) 
{if (obj.value=="") obj2.value=""		}
}
function popProvLoc()
{	if (window.event.keyCode==13) 
{  	window.event.keyCode=117;
  ProvLoc_lookuphandler();
}
 }	 
function ProvLocCheck()
{	var obj=document.getElementById("ProvLoc");
var obj2=document.getElementById("ProvLocRowid");
if (obj) 
{if (obj.value=="") obj2.value=""		}

}
function popAlias()
{
	if (window.event.keyCode==13) { 
		//	window.event.keyCode=117;
 	// Alias_lookuphandler();
 
 var obj=document.getElementById("ProvLocRowid");
 var provLoc="";
 if (obj) provLoc=obj.value;
 
 var alias="";
  var obj=document.getElementById("Alias");
  if (obj)
   { alias=obj.value;
     if(alias!=""){
	  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.IncItmByAlias&InciAlias="+alias+"&StkCode="+"&StkType="+stktype+"&pLoc="+provLoc;		  
	  //alert(lnk);
	  
	  showModalDialog(lnk,window);	
     }	   		  
   }
}
}	
function AliasCheck()
{var obj=document.getElementById("Alias");
var obj2=document.getElementById("incirowid");
if (obj) 
{if (obj.value=="") obj2.value=""		}
}	 
function SetSCGCode()
{
	var obj=document.getElementById("StkCatGrp")
	if ((obj)&&(obj.selectedIndex>=0))
	{var obj2=document.getElementById("StkCatGrpCode")
	 if (obj2) obj2.value=obj.value;	}
}
function GetReqInfo(rowid)
{
	var obj=document.getElementById("mGetReqInfo");
	var xx
	if (obj) 
	 { xx=obj.value;
	 }
	else  
	{xx='';}
	
	var ret=cspRunServerMethod(xx,rowid)
	//
	if (ret!="")
	{
	var ss=ret.split("^")
	var no=ss[0];
	var dd =ss[1];
	var tt=ss[2];
	var frloc =ss[3];
	var frlocdesc=ss[4];
	var toloc=ss[5];
	var tolocdesc=ss[6]
	var user=ss[7];
	var username=ss[8];
	var complete=ss[9];
	var reqType=ss[10];
	
	var obj=document.getElementById("ReqNo");
	if (obj) obj.value=no;
	var obj=document.getElementById("ReqLoc");
	if (obj) obj.value=tolocdesc;
	var obj=document.getElementById("ProvLoc");
	if (obj) obj.value=frlocdesc;
	var obj=document.getElementById("ReqDate");
	if (obj) obj.value=dd;
	var obj=document.getElementById("ReqLocRowid");
	if (obj) obj.value=toloc;
	var obj=document.getElementById("ProvLocRowid");
	if (obj) obj.value=frloc;
	var obj=document.getElementById("User");
	if (obj) obj.value=username;
	var obj=document.getElementById("UserID");
	if (obj) obj.value=user;
	var obj=document.getElementById("Completed");
	if (obj)
	{ 
	if (complete=='1') 
		{obj.checked=true;
		DisableItmEdits(true) ;}
	 else { obj.checked=false;     	}
		setComplete(obj)
	}
	
	/*
	var obj=document.getElementById("ReqType");
	if (obj)
	{obj.value=reqType;}	
	*/
 }
}
function DisableItmEdits(b)
{
	var obj=document.getElementById("Alias")
	if (obj) obj.readOnly=b
	var obj=document.getElementById("Uom")
	if (obj) obj.readOnly=b
	var obj=document.getElementById("Qty")
	if (obj) obj.readOnly=b
	
	if (b==false)
	{document.getElementById("Alias").focus();}
}
function setComplete(obj)
{
	 if (obj.checked==true) 
	{ 
	 obj.readOnly=true;}
  else obj.readOnly=false;
		}
function setDefaults()
{   //default date
	var dd=today();
	var obj=document.getElementById("ReqDate");
	if (obj) obj.value=dd;
	// default loc
	var userid=session['LOGON.USERID'] ;
	var obj=document.getElementById("mGetDefaultLoc") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;

	var obj=document.getElementById("User")
	if (obj) obj.value=session['LOGON.USERNAME'];
	var obj=document.getElementById("UserID")
	if (obj) obj.value=userid;	
	
	SetPharmacy();
	
	}
function setDefLoc(value)
{
	var defloc=value.split("^");
	if (defloc.length>0)
	var locdr=defloc[0] ;
	var locdesc=defloc[1] ;
	if (locdr=="") return ;
	//var obj=document.getElementById("ReqLoc") ;
	//if (obj) obj.value=locdesc
	//var obj=document.getElementById("ReqLocRowid") ;
	//if (obj) obj.value=locdr
}

function findreq()
	{}
function closewin()
{window.close();

  //window.history.back();
  

}
function clearwin()
{//clear window

  var obj=document.getElementById("Rowid")
  if (obj) obj.value=""
  var obj=document.getElementById("ReqNo")
  if (obj) obj.value=""
  	var ReqType="";
	var obj=document.getElementById("ReqType");
	if (obj) ReqType=obj.value;
	var scgc;
	var obj=document.getElementById("StkCatGrpCode");
	if (obj)  {scgc=obj.value; }
	var EditType=document.getElementById("EditType").value;
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transferreq&StkType="+stktype+"&StkCatGrpCode="+scgc;
  lnk=lnk+"&EditType="+EditType;
  lnk=lnk+"&ReqType="+ReqType;
  window.location.href=lnk;
}
function complete()
{}

function DelReq(rowid)
{
   var obj=document.getElementById("Rowid")
   if (obj) var rowid=obj.value ;
   if (rowid=="") return -1
   var obj=document.getElementById("mDelReq")
   var delscript ;
   if (obj) delscript=obj.value ;
   else delscript="";
   
   var ret=cspRunServerMethod(delscript,rowid);
 	if (ret!='0')
 	 {alert(t['DEL_FAILED']);}  
  else
  	{refreshMWin();
  		window.close();}
 }
function InsReq()
{
	var frloc
	var toloc
	var user	
   var obj=document.getElementById("Rowid")
   if (obj) 
   { if (obj.value!="")
   	{alert(t['PLEASE_CLEAR']);
   	 return ;  }	   }

   var obj=document.getElementById("ReqLocRowid")
   if (obj) toloc=obj.value;
   if (obj.value=="") 
   {alert(t["REQLOC_NEEDED"])
        return ;

	   }
   var obj=document.getElementById("ProvLocRowid")
   if (obj) frloc=obj.value;	 
   if (obj.value=="") 
   {alert(t['PROVLOC_NEEDED'])
     return ;
	   }
   user=session['LOGON.USERID'];
	
	//var obj=document.getElementById("StkCatGrp")
	//var stkcode=obj.value;
	//
	
	/*
	stkcode=GetStkCatGrpCode()
	//alert(stkcode)
	if (stkcode=='')
	{alert(t['STKGRP_NEEDED']) ;
	 return;	
	}
	*/
	var stkcode=""
	
	var obj=document.getElementById("mInsReq")
	if (obj) xx=obj.value;
	else xx='' ;
	
	var reqtype=document.getElementById("ReqType").value;
	if (reqtype=="大输液补货"){reqtype=3}
	else if (reqtype=="基数补货"){reqtype=1}
	var ret=cspRunServerMethod(xx,stkcode,toloc,frloc,user,"",reqtype)
	if (ret<0 ) 
	{
		alert(t['INSREQ_ERR'])
		return ;
		}

//	retrieving the request info ...
	if (ret>0 )
	{ var obj=document.getElementById("ReqNo")
	  if (obj) obj.value=ReqNo(ret) ;
	  var obj=document.getElementById("Rowid")
	  if (obj) obj.value=ret;
	}
	DisableItmEdits(false); 
//	alert("OK");
	//
 }
function ReqNo(rowid)
{
	var obj=document.getElementById("mGetReqNo")
	if (obj) xx=obj.value;
	else xx='' ;
	var ret=cspRunServerMethod(xx,rowid)
	return ret
}
function InsReqItm(m)
{ 	 
	var reqType="";
	var obj=document.getElementById("ReqType");
	if (obj) reqType=obj.value;
	//alert(reqType);
	if (reqType=="大输液补货"){reqType=3}
	else if (reqType=="基数补货"){reqType=1}
	if (reqType!=3) {	 
		alert(t['INSERTITM_NOT_ALLOWED']);
		return ;	 
	}
 
	var reqrowid ;
	var inci;
	var uom;
	var qty;
	var m;
	var obj=document.getElementById("Rowid");
	if (obj) m=obj.value;
    if (m=="")
	   {alert(t['MAINROWID_NEEDED'])
	     return ;	   }
	var obj=document.getElementById("incirowid");
	if ( (obj)&&(obj.value=="")) 
	{alert(t["ITM_NEEDED"]) ;
	return false;
	}
	inci=obj.value ;
	if (CheckTabelHaveInci(inci)==false)
	{
		alert("请求明细中已存在该药品!");
		return false;
	}
	var obj=document.getElementById("Uom");
	if ( (obj)&&(obj.selectedIndex<0)) 
	{alert(t['UOM_NEEDED']) ;
		return false ;
		}
	uom=obj.value;
	//
	var obj=document.getElementById("Qty");
	if ( (obj)&&(obj.value=="") )
	{ alert(t['QTY_NEEDED'])
	  return false		}
	qty=obj.value;
	
	
	if (parseFloat(qty)<=0) {
		alert("请领数量不符合要求,请重新输入.");
		return false
	}
	
	var obj=document.getElementById("ReqType");
	if (obj.value=='3') {
		if (CheckQtyPU(inci,qty)==false) {
			alert('请领数量不符合要求,请使用大包装数的整倍数.')
			return false; 
		} 	
  }
	//
	var obj=document.getElementById("mInsReqItm")
	if (obj) insitm=obj.value ;
	else  insitm='';
	
	var userid=session['LOGON.USERID'] ;

	newReqItmRowid=cspRunServerMethod(insitm,m,inci,uom,qty,userid)
	if( newReqItmRowid=="")
	{alert(t['INSITM_FAILED']) ;
		return false;	}
	
	refreshWin();
	//AddRow();
	clearItm();
	setdefaultfocus();
	
 }
function setdefaultfocus()
{	var obj=document.getElementById("Alias")
	if (obj) obj.focus();
}
function refreshWin()
{
	var rowid;
	var obj=document.getElementById("Rowid");
	if (obj)  {rowid=obj.value; }
	var scgc;
	var obj=document.getElementById("StkCatGrpCode");
	if (obj)  {scgc=obj.value; }
	
	var ReqType=document.getElementById("ReqType").value;
	var EditType=document.getElementById("EditType").value;
		
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transferreq&Rowid="+rowid+"&StkType="+stktype+"&StkCatGrpCode="+scgc;
  
   lnk=lnk+"&EditType="+EditType;
   lnk=lnk+"&ReqType="+ReqType;
   
  
    window.location.href=lnk;
    //window.location.reload();

}
function refreshMWin()
{
    window.opener.Find_click();

}
 function DelReqItm(reqitm)
 {
  /* var row=""
 
   var obj=document.getElementById("Rowid")
   if (obj) var rowid=obj.value ;
   if (rowid=="") return -1
   var obj=document.getElementById("mDelReqItm")
   var delscript ;
   if (obj) delscript=obj.value ;
   else delscript="";
      
 	if (cspRunServerMethod(delscript,rowid)=='0')
 	 {alert(t['DEL_FAILED'])}  
	 */
	 }
 function UpdateReqItm()
 {}
 function UpdateReq()
 {}
 function SelectReq()
 {
 }
	
function getitmuom(inci)
{
	var obj=document.getElementById("mGetItmUom");
	if (obj) getuomscript=obj.value ;
	else getuomscript="";
	var uoms=cspRunServerMethod(getuomscript,inci);
	// alert(uoms);
	var ss=uoms.split("^")
	var obj=document.getElementById("Uom");
	if (obj)	{
		obj.length=0;
		var elem=new Option(ss[1],ss[0]);
		var elem2=new Option(ss[3],ss[2]);
		obj.options[obj.options.length]=elem2;    
		
		if (ss[0]!=ss[2]) { obj.options[obj.options.length]=elem;}
		
		if (obj.length>0) {obj.selectedIndex=0;}
	}
}
function AliasLookupSelect(str)
{	var inci=str.split("^");
	var obj=document.getElementById("incirowid");
	var objDesc=document.getElementById("Alias");
	if (obj){
		if (inci.length>0) { 
			// alert(inci[2]);
			obj.value=inci[2];
			objDesc.innerText=inci[0]
			newCode=inci[1];
			
			getitmuom(inci[2]) ;
			getPackUom(inci[2]);
			
			var objUom=document.getElementById("Uom");
			var uom=objUom.options[objUom.selectedIndex].text;
			document.getElementById("sp").value=GetSp(newCode,uom);
			
			var loc=document.getElementById("ReqLoc").value;
			document.getElementById("stkqty").value=GetStkQty(newCode,loc,uom);
			
		} 
		else { 
			obj.value="" ;
			objDesc.innerText=""  
			return;
		}
	 }
	var obj=document.getElementById("PackUOM")
	if (obj){
	if(obj.value!="")	{
		var objPakUomQty=document.getElementById("QtyPU");
		if (objPakUomQty) objPakUomQty.focus();
	}
	else {
		var objQty=document.getElementById("Qty");
		if (objQty) objQty.focus();
	}
   }
}

function ReqLocLookUpSelect(str)
{
  var ctloc=str.split("^");
  var obj=document.getElementById("ReqLocRowid")
  if (obj) obj.value=ctloc[1];
}
function ProvLocLookUpSelect(str)
{
  var ctloc=str.split("^");
  var obj=document.getElementById("ProvLocRowid")
  if (obj) obj.value=ctloc[1];
}
function UpdReq()
{
  var rowid,tolocdr,frlocdr,comp ;
	
  var obj=document.getElementById("Rowid")
  if (obj) rowid=obj.value;	
  if (rowid=="")
  {alert(t['NO_REQ']) ;
    return ;}
  
  var obj=document.getElementById("ReqLocRowid")	
  if (obj) tolocdr=obj.value;
  if (tolocdr=="") {
	alert(t['REQLOC_NEEDED']) ;
	return  
	  }
  var obj=document.getElementById("ProvLocRowid")	
  if (obj) frlocdr=obj.value;
  if (frlocdr=="") 
  {alert(t['PROVLOC_NEEDED'])
   return ;
  }
  
  var obj=document.getElementById("Completed")	
  if (obj.checked)  comp="Y"
  else comp="N"
  
  var obj=document.getElementById("mUpdReq")
  if (obj) upd=obj.value
  else upd=''
  
  ret=cspRunServerMethod(upd,rowid,frlocdr,tolocdr,comp)
  if (ret!=0)
  {alert(t['UPDREQ_ERR'])
   return;
  }
  
  if (comp=="Y")
  {
  	  refreshMWin();
	  window.close();}
  else
  {refreshWin(); 	}
}
function SetStkCatGrpList()
{   
	var obj=document.getElementById("mGetStkCatGrp")
	if (obj) xx=obj.value;
	else xx=''
	//alert(xx);
	var str=cspRunServerMethod(xx,stktype)
	if (str!="")
	{var ss=str.split("^")
     //alert(ss[0]);
	 var obj2=document.getElementById("StkCatGrp")	
	 for (i=0;i<ss.length;i++)
	 {
		sss=ss[i].split('-');
		obj2.options[i]=new Option(sss[1],sss[0]) }
		}
	var obj3=document.getElementById("StkCatGrpCode")
    if (obj3.value!="") 
    {
	   var i
     for (i=0;i<obj2.length;i++)
     {	if (obj2.options[i].value==obj3.value) {
	       obj2.selectedIndex=i  
 	     }
     }
    }
}
function GetStkCatGrpCode()
{
 var code;
  var obj=document.getElementById("StkCatGrpCode")	
  if (obj) code=obj.value;
  return code	
	
}
function saveReqItm()
{   
	var exe;
	var reqItm;
	var qty;
	
	var exeCheck;
	
	var obj=document.getElementById("mCheckReqQty");
	if (obj) exeCheck=obj.value;
	else exeCheck='';
	
	
	var obj=document.getElementById("mUpdReqItm");
	if (obj)  exe=obj.value;
	else  exe="";
	
	var objtbl=document.getElementById("t"+"dhcpha_transferreq");
	if (objtbl)  var rowCnt=getRowcount(objtbl);


	var obj=document.getElementById("ReqType");
	if (obj.value=='3'){
		for (i=1;i<=rowCnt;i++)   {
		   var obj1=document.getElementById("TInciRowid"+"z"+i);
		   if (obj1)  inci=obj1.value;
		   var obj2=document.getElementById("TQty"+"z"+i);
		   if (obj2)  qty=obj2.value;
		   if (CheckQtyPU(inci,qty)==false){
			  alert('第'+i+'行:'+'请领数量不符合要求,请使用大包装数的整倍数.');
			  refreshWin(); 
			  return ;
		   }
		}
	}

	for (i=1;i<=rowCnt;i++)
    {
	   var obj1=document.getElementById("TReqItmRowid"+"z"+i);
	   if (obj1)  reqItm=obj1.value;
	   //alert(reqItm);
	   var obj2=document.getElementById("TQty"+"z"+i);
	   if (obj2)  qty=obj2.value;
	   var ret=cspRunServerMethod(exeCheck,reqItm,qty);
	   if (ret=='0')
	   {
		  alert('第'+i+'行:'+t['QTY_IS_BIGGER']);
		  return;
		   }
	   }
	   
	for (i=1;i<=rowCnt;i++)
    {
	   var obj1=document.getElementById("TReqItmRowid"+"z"+i);
	   if (obj1)  reqItm=obj1.value;
	   var obj2=document.getElementById("TQty"+"z"+i);
	   if (obj2)  qty=obj2.value;
	   var ret=cspRunServerMethod(exe,reqItm,qty);
	   if (ret==-2)
	   {
		  alert('第'+i+'行:'+t['QTY_IS_BIGGER']);
		   }
	   
	   }
	   
}
function setEditControlEnabled()
{
	/*
  if (EditType=="ADD")
  {
  	window.document.all('AddNew').style.display="";
	window.document.all('DelReq').style.display="";
	window.document.all('AddItm').style.display="";
  }
  else  {
	window.document.all('DelReq').style.display="none";
	window.document.all('AddItm').style.display="none";
  	window.document.all('AddNew').style.display="none";
  }	*/
	
}
function getPackUom(inci)
{
   var obj=document.getElementById("mGetPackUOM");
   var pu="";
   if (obj) var exe=obj.value;
   else var exe=""
   if (exe!=""){
	   var pu=cspRunServerMethod(exe,inci);
   }
   var obj=document.getElementById("PackUOM");
   if (obj) obj.value=pu;

}
function CalQty()
{ 
	var qtyPU;
	var obj=document.getElementById("QtyPU");
	if (obj) qtyPU=obj.value;
	
	if  ( parseFloat(qtyPU)<=0 )
	{obj.value=""; return;}
	
	var packuom=document.getElementById("PackUOM").value;
	if (packuom!="") 
	{
	var ss=packuom.split(" * ")
	var fac=ss[1] ;
	document.getElementById("Qty").value= qtyPU*fac
	}
}
function SetPharmacy()
{
	var exe="";
	var obj=document.getElementById("mGetConfigPhaLocDr");
	if (obj) exe=obj.value;
	else exe="";
	var obj=document.getElementById("ReqType");
	if (obj) var ReqType=obj.value;
	
	var iccode=GetICCode(ReqType)
	
	//alert(iccode);
	var obj=document.getElementById("ReqLocRowid");
	if (obj) {var reqloc=obj.value;}
	else { var reqloc="";}
	var str=cspRunServerMethod(exe,iccode,reqloc);
	if (str!="")
	{
		var ss=str.split("^");
		
		var phaLocRowid=ss[1];
		var phaLoc=ss[0];
		
		var obj=document.getElementById("ProvLocRowid");
		if (obj) obj.value=phaLocRowid;
		var obj=document.getElementById("ProvLoc");
		if (obj) obj.value=phaLoc;
	}
	
	}
function GetICCode(reqtype)
{
  if (reqtype=="3") return "DSY"	
  if (reqtype=="1") return "BASEDRUG"	
  if (reqtype=="2") return "JSDM"	
  return ""  
}
function handleQtyPU()
{
	if (window.event.keyCode==13) 
	{	
		CalQty();
		document.getElementById("Qty").focus();
	}
}
function AddRow()
{
	var qty=document.getElementById("Qty").value;
	var inci=document.getElementById("incirowid").value;
	var desc=document.getElementById("Alias").value;
	var objuom=document.getElementById("Uom");
	if (objuom)
	{var uom=objuom.options[objuom.selectedIndex].text;
		var uomid=objuom.options[objuom.selectedIndex].value;
	}
	var pu=document.getElementById("PackUOM").value;
	var sp=document.getElementById("sp").value;
	var stkqty=document.getElementById("stkqty").value;
	
	tAddRow(objtbl);
	//var cnt=getRowcount(objtbl);

	var rows=objtbl.rows.length;
	var cnt=rows - 1;
	
	document.getElementById("TCode"+"z"+cnt).innerText=newCode;

	document.getElementById("TDesc"+"z"+cnt).innerText=desc;
	document.getElementById("TInciRowid"+"z"+cnt).value=inci;
	document.getElementById("TReqItmRowid"+"z"+cnt).value=newReqItmRowid;
	document.getElementById("TQty"+"z"+cnt).innerText=qty;
    
    /*
	document.g1etElementById("TPackUOM"+"z"+cnt).value=pu;
	*/
	document.getElementById("TSp"+"z"+cnt).innerText=sp;
	document.getElementById("TStkQty"+"z"+cnt).innerText=stkqty;
	document.getElementById("TUomRowid"+"z"+cnt).value=uomid;
	document.getElementById("TUom"+"z"+cnt).innerText=uom;
	
}
function GetSp(code,uom)
{  
    var exe="";
	var obj=document.getElementById("mGetSp");
	if (obj) exe=obj.value;
	var sp=0;
	if (exe!="") 
	{ 
		sp=cspRunServerMethod(exe,code,uom); 
	}
	return sp;	
}
function GetStkQty(code,loc,uom)
{  var exe="";
	var obj=document.getElementById("mGetStkQty");
	if (obj) exe=obj.value;
	return cspRunServerMethod(exe,code,loc,uom)	;
}
function CheckQtyPU(inci,qty)
{
	var obj=document.getElementById("mGetPackUOM");
	var pu="";
	if (obj) var exe=obj.value;
	else var exe=""
	if (exe!=""){
	   var pu=cspRunServerMethod(exe,inci);
	}
	if (pu!="") 
	{
		var ss=pu.split(" * ");
		var fac=ss[1] ;
		var xx= qty%fac;
		if (xx==0) {return true ;}
		else {return false;}
	}
	else
	{return true ; }
}

///判断新增药品是否已存在明细中
function CheckTabelHaveInci(newinci)
{
	var inciz="";
	var objtbl=document.getElementById("t"+"dhcpha_transferreq");
	if (objtbl)  var rowCnt=getRowcount(objtbl);
	for (i=1;i<=rowCnt;i++)
    {
	   var inciobj=document.getElementById("TInciRowid"+"z"+i);
	   if (inciobj)  inciz=inciobj.value;
	   if (inciz==newinci)
	   {
		   return false;
	   }
	    
	}
	return true;	
}
document.body.onload=BodyLoadHandler
