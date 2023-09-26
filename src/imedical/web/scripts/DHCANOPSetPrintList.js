 var selrow;
 var Tbl=document.getElementById("tDHCANOPSetPrintList");
function BodyLoadHandler()
{
	var obj=document.getElementById('add');
	if (obj) {obj.onclick=add_click;}
	var DelBt=document.getElementById("Del");
	if (DelBt) {DelBt.onclick=Delclick;}
	var UpdateBt=document.getElementById("Update");
	if (UpdateBt) {UpdateBt.onclick=UpdateBtclick;}
}
function UpdateBtclick()
{
  var queryTypeCode=document.getElementById("queryTypeCode").value;
  if (queryTypeCode==""){alert("not type!");return false;}
  var seqno=document.getElementById("txtseqno").value;
  var columName=document.getElementById("txtcolumName").value;
  var ColLinkID=document.getElementById("txtColLinkID").value;
  if ((seqno=="")||(columName==""))
  {
   alert ("请选中一行")
  return false;
  }
 var ColLink=document.getElementById("txtColLink").value;
 if (ColLink==""){ColLinkID="";}
 if (selrow=="") return;
 if (selrow!=""){
	 var rw=document.getElementById("Rwz"+selrow).innerText;
	 var UpdateTitle=document.getElementById("UpdateTitle").value;
	 var TypStr=columName+"|"+ColLink+"|"+ColLinkID+"|"+seqno;
	 var ret;
	 //alert(rw+" "+TypStr+" "+queryTypeCode)
	 ret=cspRunServerMethod(UpdateTitle,rw,TypStr,queryTypeCode);
	 if (ret==0)
     {
	    alert(t['alert:success']);
	 }
	 else
	 {
		alert(t['alert:error']);
	 }
  }
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPSetPrintList&queryTypeCode="+queryTypeCode;
    window.location.href=lnk;
 
	
}
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}

function SelectRowHandler()
{
    selrow=DHCWeb_GetRowIdx(window);
    var seqno=document.getElementById("txtseqno");
    var columName=document.getElementById("txtcolumName");
    var ColLinkID=document.getElementById("txtColLinkID");
    var ColLink=document.getElementById("txtColLink");
    seqno.value=document.getElementById("seqnoz"+selrow).innerText
    columName.value=document.getElementById("columNamez"+selrow).innerText
    ColLinkID.value=document.getElementById("ColLinkIDz"+selrow).innerText
    ColLink.value=document.getElementById("ColLinkz"+selrow).innerText;   
}   
function Delclick(){
	var queryTypeCode=document.getElementById("queryTypeCode").value;
	if (queryTypeCode==""){alert("not type!");return false;}
	  var seqno=document.getElementById("txtseqno").value;
  var columName=document.getElementById("txtcolumName").value;
  var ColLinkID=document.getElementById("txtColLinkID").value;
  if ((seqno=="")||(columName==""))
  {
   alert ("请选中一行")
  return false;
  }

	if (selrow=="") return;
	if (selrow!=""){
	 var rw=document.getElementById("Rwz"+selrow).innerText;
	 var DelFun=document.getElementById("DelTitle").value;
	 var ret;
	 ret=cspRunServerMethod(DelFun,queryTypeCode,rw);
	 if (ret==0)
     {
	    alert(t['alert:success']);
	 }
	 else
	 {
		alert(t['alert:error']);
	 }
	}
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPSetPrintList&queryTypeCode="+queryTypeCode;
    window.location.href=lnk;    
}
function add_click() 
{
  var queryTypeCode=document.getElementById("queryTypeCode").value;
  if (queryTypeCode==""){alert("not type!");return false;}
  var AddTile=document.getElementById("AddTile").value;
  var seqno=document.getElementById("txtseqno").value;
  var columName=document.getElementById("txtcolumName").value;
  var ColLink=document.getElementById("txtColLink").value;
  var ColLinkID=document.getElementById("txtColLinkID").value;
  if ((seqno=="")||(columName==""))
  {
   alert (t['alert:null'])
  return false;
  }
   //alert(queryTypeCode+"!"+columName+"|"+ColLink+"|"+ColLinkID+"|"+seqno)
  var res=cspRunServerMethod(AddTile,queryTypeCode,columName+"|"+ColLink+"|"+ColLinkID+"|"+seqno)
     if (res==0)
    {//add ok
	    alert(t['alert:success']);
	}
	else
	{
		alert(t['alert:error']);
	}
 var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPSetPrintList&queryTypeCode="+queryTypeCode;
 window.location.href=lnk; 

}


function getColLinkID(str)
{
		var arryLinkID=str.split("^");
		var obj=document.getElementById("txtColLinkID")
		obj.value=arryLinkID[1];
}
document.body.onload = BodyLoadHandler;
