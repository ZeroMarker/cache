 var selrow;
 var Tbl=document.getElementById("tDHCANOPReportList");
function BodyLoadHandler()
{
	var obj=document.getElementById('add');
	if (obj) {obj.onclick=add_click;}
	var DelBt=document.getElementById("del");
	if (DelBt) {DelBt.onclick=Delclick;}
	var UpdateBt=document.getElementById("Update");
	if (UpdateBt) {UpdateBt.onclick=UpdateBtclick;}
}

function UpdateBtclick(e) 
{
  var selrow=document.getElementById("selrow").value;
  if (selrow=="") return;
  var ColLinkID=document.getElementById("ColLinkIDz"+selrow).innerText;
  var schtypeId=document.getElementById("schtypeIdz"+selrow).innerText;
  var queryTypeCode=document.getElementById("queryTypeCode").value;
  if (queryTypeCode==""){alert("not type!");return false;}
  var UpdateTitle=document.getElementById("UpdateTitle").value;
  var seqno=document.getElementById("repseqno").value;
  var columName=document.getElementById("repcolumName").value;
  var ColLink=document.getElementById("repColLink").value;
  var repColLinkID=document.getElementById("repColLinkID").value;
  var ststatCode=document.getElementById("ststatCode").value;
  var repschtype=document.getElementById("repschtype").value;
  var repschtypeId=document.getElementById("repschtypeId").value;
  var repreturntype=document.getElementById("repreturntype").value;
  var repreturntypeId=document.getElementById("repreturntypeId").value;
  
  //alert(ststatCode);
  //alert(queryTypeCode);
  //alert(ColLinkID);
  //alert(AddTitle);
  if (seqno=="")
  {
   alert (t['alert:null'])
  return false;
  }
  //alert(repschtype+"*"+repschtypeId);
   //alert(queryTypeCode+"!"+columName+"|"+ColLink+"|"+ColLinkID+"|"+seqno)
  //alert(queryTypeCode+"!"+ststatCode+"!"+repColLinkID+"!"+repschtypeId+"!"+ColLinkID+"!"+schtypeId+"!"+columName+"^"+ColLink+"^"+seqno+"^"+repreturntypeId+"^"+repschtype+"^"+repreturntype);
  var res=cspRunServerMethod(UpdateTitle,queryTypeCode,ststatCode,repColLinkID,repschtypeId,ColLinkID,schtypeId,columName+"^"+ColLink+"^"+seqno+"^"+repreturntypeId+"^"+repschtype+"^"+repreturntype)
  //alert(res);
     if (res==0)
    {//add ok
	    alert(t['alert:success']);
	}
	else
	{
		alert(t['alert:error']);
	}
 var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPReportList&queryTypeCode="+queryTypeCode+"&ststatCode="+ststatCode;
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

function SelectRowHandler(e)
{
	var selrow=document.getElementById("selrow");
    selrow.value=DHCWeb_GetRowIdx(window);
    var seqno=document.getElementById("repseqno");
    var ColLinkID=document.getElementById("repColLinkID");
    var ColLink=document.getElementById("repColLink");
    var columName=document.getElementById("repcolumName");
    var schtype=document.getElementById("repschtype");
    var returntypeId=document.getElementById("repreturntypeId");
    var schtypeId=document.getElementById("repschtypeId");
    var returntype=document.getElementById("repreturntype");
    
    seqno.value=document.getElementById("seqnoz"+selrow.value).innerText;
    ColLinkID.value=document.getElementById("ColLinkIDz"+selrow.value).innerText;
    ColLink.value=document.getElementById("ColLinkz"+selrow.value).innerText;
    columName.value=document.getElementById("columNamez"+selrow.value).innerText;
    schtype.value=document.getElementById("schtypez"+selrow.value).innerText;
    returntypeId.value=document.getElementById("returntypeIdz"+selrow.value).innerText;
    schtypeId.value=document.getElementById("schtypeIdz"+selrow.value).innerText;
    returntype.value=document.getElementById("returntypez"+selrow.value).innerText;   
}   
function Delclick(e){
	var selrow=document.getElementById("selrow").value;
    if (selrow=="") return;
    var ColLinkID=document.getElementById("ColLinkIDz"+selrow).innerText;
    var schtypeId=document.getElementById("schtypeIdz"+selrow).innerText;
	var queryTypeCode=document.getElementById("queryTypeCode").value;
	var ststatCode=document.getElementById("ststatCode").value;
	if (queryTypeCode==""){alert("not type!");return false;}
	
	if (selrow!=""){
	 var DelFun=document.getElementById("DelTitle").value;
	 var ret;
	 ret=cspRunServerMethod(DelFun,ststatCode,queryTypeCode,schtypeId,ColLinkID);
	 if (ret==0)
     {
	    alert(t['alert:success']);
	 }
	 else
	 {
		alert(t['alert:error']);
	 }
	}
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPReportList&queryTypeCode="+queryTypeCode+"&ststatCode="+ststatCode;
    window.location.href=lnk;    
}
function add_click(e) 
{
  var queryTypeCode=document.getElementById("queryTypeCode").value;
  if (queryTypeCode==""){alert("not type!");return false;}
  var AddTitle=document.getElementById("AddTitle").value;
  var seqno=document.getElementById("repseqno").value;
  var columName=document.getElementById("repcolumName").value;
  var ColLink=document.getElementById("repColLink").value;
  var ColLinkID=document.getElementById("repColLinkID").value;
  var ststatCode=document.getElementById("ststatCode").value;
  var repschtype=document.getElementById("repschtype").value;
  var repschtypeId=document.getElementById("repschtypeId").value;
  var repreturntype=document.getElementById("repreturntype").value;
  var repreturntypeId=document.getElementById("repreturntypeId").value;
  if (repschtypeId==""){alert("查询类型不能为空！");return;}
  if (ColLinkID==""){alert("列关联不能为空！");return;}
  //alert(ststatCode);
  //alert(queryTypeCode);
  //alert(ColLinkID);
  //alert(AddTitle);
  if (seqno=="")
  {
   alert (t['alert:null'])
  return false;
  }
  //alert(ststatCode);
  //alert(queryTypeCode+"!"+ststatCode+"|"+ColLinkID+"|"+seqno+"|"+repschtypeId+"|"+repschtype)  
  var res=cspRunServerMethod(AddTitle,queryTypeCode,ststatCode,ColLinkID,repschtypeId,columName+"^"+ColLink+"^"+seqno+"^"+repreturntypeId+"^"+repschtype+"^"+repreturntype)
  //alert(res);
     if (res==0)
    {//add ok
	    alert(t['alert:success']);
	}
	else
	{
		alert(t['alert:error']);
	}
 var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPReportList&queryTypeCode="+queryTypeCode+"&ststatCode="+ststatCode;
 window.location.href=lnk; 

}


function getColLinkID(str)
{
		var arryLinkID=str.split("^");
		var obj=document.getElementById("repColLinkID")
		obj.value=arryLinkID[1];
}
function getrepschtype(str)
{
		var arryschtype=str.split("^");
		var obj=document.getElementById("repschtype")
		obj.value=arryschtype[1];
		var obj=document.getElementById("repschtypeId")
		obj.value=arryschtype[0];
}
function getrepreturntype(str)
{
		var arryreturntype=str.split("^");
		var obj=document.getElementById("repreturntype")
		obj.value=arryreturntype[1];
		var obj=document.getElementById("repreturntypeId")
		obj.value=arryreturntype[0];
}
document.body.onload = BodyLoadHandler;
