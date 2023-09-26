var stktype;
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
	 var obj=document.getElementById("StkCatGrp")
	 if (obj) obj.onchange=SetSCGCode;
	var obj=document.getElementById("ReqLoc"); //
	if (obj) 
	{obj.onkeydown=popReqLoc;
	 obj.onblur=ReqLocCheck;
	} //
	 
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
	 
	 var obj=document.getElementById("Rowid");
	 if (obj.value=="") 
	 {	setDefaults();
		 DisableItmEdits(true);	 }
	 else
	 {	 GetReqInfo(obj.value);	
	  
	  }

	SetStkCatGrpList();
	SetWinCenter(window)
	setdefaultfocus()
	
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
	 {if (window.event.keyCode==13) 
		{  	window.event.keyCode=117;
		  Alias_lookuphandler();
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
	
	var obj=document.getElementById("ReqNo")
	if (obj) obj.value=no
	var obj=document.getElementById("ReqLoc")
	if (obj) obj.value=tolocdesc
	var obj=document.getElementById("ProvLoc")
	if (obj) obj.value=frlocdesc
	var obj=document.getElementById("ReqDate")
	if (obj) obj.value=dd
	var obj=document.getElementById("ReqLocRowid")
	if (obj) obj.value=toloc
	var obj=document.getElementById("ProvLocRowid")
	if (obj) obj.value=frloc
	var obj=document.getElementById("User")
	if (obj) obj.value=username
	var obj=document.getElementById("UserID")
	if (obj) obj.value=user
	var obj=document.getElementById("Completed")
	if (obj)
	{ 
	if (complete=='1') 
		{obj.checked=true;
		DisableItmEdits(true) ;}
	 else { obj.checked=false;     	}
		setComplete(obj)
	}
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
	}
function setDefLoc(value)
{
	var defloc=value.split("^");
	if (defloc.length>0)
	var locdr=defloc[0] ;
	var locdesc=defloc[1] ;
	if (locdr=="") return ;
	var obj=document.getElementById("ReqLoc") ;
	if (obj) obj.value=locdesc
	var obj=document.getElementById("ReqLocRowid") ;
	if (obj) obj.value=locdr
}

function findreq()
	{}
function closewin()
{window.close();}
function clearwin()
{//clear window

  var obj=document.getElementById("Rowid")
  if (obj) obj.value=""
	var scgc;
	var obj=document.getElementById("StkCatGrpCode");
	if (obj)  {scgc=obj.value; }
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transferreq&StkType="+stktype+"&StkCatGrpCode="+scgc;
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
 	if (cspRunServerMethod(delscript,rowid)=='0')
 	 {alert(t['DEL_FAILED']);}  

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
	stkcode=GetStkCatGrpCode()
	//alert(stkcode)
	if (stkcode=='')
	{alert(t['STKGRP_NEEDED']) ;
	 return;	
	}
	
	var obj=document.getElementById("mInsReq")
	if (obj) xx=obj.value;
	else xx='' ;
	var ret=cspRunServerMethod(xx,stkcode,toloc,frloc,user,"")
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
	{alert("ITM_NEEDED") ;
	return false;
	}
	inci=obj.value ;
	//
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
	
	//
	var obj=document.getElementById("mInsReqItm")
	if (obj) insitm=obj.value ;
	else  insitm='';
	
	var userid=session['LOGON.USERID'] ;

	if( cspRunServerMethod(insitm,m,inci,uom,qty,userid)!=0)
	{alert(t['INSITM_FAILED']) ;
		return false;	}
	
	refreshWin();
	
   // setdefaultfocus();	
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
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transferreq&Rowid="+rowid+"&StkType="+stktype+"&StkCatGrpCode="+scgc;
    window.location.href=lnk;

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
{var obj=document.getElementById("mGetItmUom");
   if (obj) getuomscript=obj.value ;
   else getuomscript="";
   var uoms=cspRunServerMethod(getuomscript,inci);
  // alert(uoms);
   var ss=uoms.split("^")
   var obj=document.getElementById("Uom");
   if (obj)
   {obj.length=0;
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
	if (obj)
	{if (inci.length>0)  { 
	// alert(inci[2]);
	obj.value=inci[2];} 
		else { obj.value="" ;  }
	 }
	
	getitmuom(inci[2]) ;
	 
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
  	
}
function SetStkCatGrpList()
{ // alert(stktype)
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
    {var i
     for (i=0;i<obj2.length;i++)
	     {	if (obj2.options[i].value==obj3.value)
	      {  obj2.selectedIndex=i  
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
document.body.onload=BodyLoadHandler
