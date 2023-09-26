function BodyLoadHandler() {
	var OBJ=document.getElementById("auditbt");
	//typ.checked=true;
	if (OBJ)  OBJ.onclick=Audit_click;
    OBJ=document.getElementById("UnAudit");
	//typ.checked=true;
	if (OBJ)  OBJ.onclick=UnAudit_click;
	var objPartAuditBtn=document.getElementById("partAuditBtn");
	if (objPartAuditBtn)  objPartAuditBtn.onclick=PartAuditBtn_click;
	Ordcheck();
	var objGetAuditList=document.getElementById("GetAuditTimeList")
    if(objGetAuditList)
    {
	    var retStr=document.getElementById("GetAuditTimeList").value;
		AuditBatch(retStr);
    }
}
function OrdStr(typ)
{
	var objtbl=document.getElementById('tDHCLINGYAODETAIL');
	var rowid;
	rowid="";
	var dhcDspIdStr="";
	
	for (i=1;i<objtbl.rows.length;i++)
	{
	   var item=document.getElementById("Selectz"+i);
	   var Audit=document.getElementById("Auditz"+i).innerText;
	   if (item.checked==true)
       {
	      var dhcDspId=document.getElementById("dhcDspIdz"+i).innerText;
	      //alert(Audit.length)
          if ((typ=="Y")&&(Audit=="| "))
          {
          if (dhcDspIdStr.length==0){dhcDspIdStr=dhcDspId}
          else{dhcDspIdStr=dhcDspIdStr+"^"+dhcDspId}
          }
          if ((typ=="N")&&(Audit!="| "))
          {
          if (dhcDspIdStr.length==0){dhcDspIdStr=dhcDspId}
          else{dhcDspIdStr=dhcDspIdStr+"^"+dhcDspId}
          }   
	   }
	}
	return dhcDspIdStr;
}
function Audit_click() //药品审核
{

	var dhcDspIdStr="";
    dhcDspIdStr=OrdStr("Y"); 
   // alert(oeoriIdStr); 
    var PAudit=document.getElementById("PAudit").value;
    var ArRow=document.getElementById("ArRow").value;
	var userid=session['LOGON.USERID'];
	//var ward=parent.frames[0].document.getElementById("ward").value;
	var auditBatch=document.getElementById("auditBatch");
	if(auditBatch)
	{
		var locId=session["LOGON.CTLOCID"];
		var Index=auditBatch.selectedIndex;
	    if (Index==-1) return; 
	    var auditBatchId=auditBatch.options[Index].value;
	}else
	{
		var auditBatchId=""
	}
	//alert(oeoriIdStr+","+userid+","+ArRow+","+locId)
    var ret=cspRunServerMethod(PAudit,dhcDspIdStr,userid,ArRow,locId,auditBatchId);
	if (ret!=0)
	  {
		  alert("err");
	  }
	  else
	  {
	   alert("OK");
	   self.location.reload();
	  }
	
}
function UnAudit_click()   //撤销
{
	var dhcDspIdStr="";
    dhcDspIdStr=OrdStr("N");   
    var UnAu=document.getElementById("UnAu").value;
	if (dhcDspIdStr.length!=0)
	{
	  var userid=session['LOGON.USERID'];
      var ret=cspRunServerMethod(UnAu,dhcDspIdStr,userid);
      alert(ret);
      self.location.reload();
	}
}
function Ordcheck()  //选择
{
	var objtbl=document.getElementById('tDHCLINGYAODETAIL');
	
	for (i=1;i<objtbl.rows.length;i++)
	{
	   var item=document.getElementById("Selectz"+i);
	   var Audit=document.getElementById("Auditz"+i).innerText;
          if ((Audit=="| "))
          {
           item.checked=true;
          
           // alert(arc.innerText);
          }
 
	
	}
}
function AuditBatch(retStr)
{
	var batchStr=retStr.split("|");
	var auditBatch=document.getElementById("auditBatch");
	if(auditBatch)
	{
		auditBatch.size=1; 
		auditBatch.multiple=false;
		if (batchStr=="") return;
		for (var i=0;i<auditBatch.length;i++)
		{
			auditBatch.remove(i);
		}
		auditBatch.options[0]=new Option("","");
		for (var i=0;i<batchStr.length;i++)
		{
			if (batchStr[i]=="") {}
			else{
				var batch;
				batch=batchStr[i].split("^");
				var sel=new Option(batch[1],batch[0]);
				auditBatch.options[auditBatch.options.length]=sel;
	 		}
		}
		auditBatch.selectedIndex=0;
	}
}
function PartAuditBtn_click() //部分审核
{
  var objtbl=document.getElementById('tDHCLINGYAODETAIL');
	var rowid;
	rowid="";
	var dhcDspIdStr="";	
	for (i=1;i<objtbl.rows.length;i++)
	{
	   var item=document.getElementById("Selectz"+i);
	   var Audit=document.getElementById("Auditz"+i).innerText;
	   var dhcDspId=document.getElementById("dhcDspIdz"+i).innerText;
	   if (Audit=="| ")
	   {
	   		if (item.checked==true)
       		{
          		if (dhcDspIdStr.length==0){dhcDspIdStr="Y!"+dhcDspId}
          		else{dhcDspIdStr=dhcDspIdStr+"^"+"Y!"+dhcDspId}
            }
	   		else
       		{
          		if (dhcDspIdStr.length==0){dhcDspIdStr="N!"+dhcDspId}
          		else{dhcDspIdStr=dhcDspIdStr+"^"+"N!"+dhcDspId}
            }            
	   }
	}
	if (dhcDspIdStr=="") return ;
    var partAudit=document.getElementById("partAudit").value;
    var ArRow=document.getElementById("ArRow").value;
	var userid=session['LOGON.USERID'];
	var locId=session["LOGON.CTLOCID"];
	//alert(dhcDspIdStr+","+userid+","+ArRow+","+locId)
    var ret=cspRunServerMethod(partAudit,dhcDspIdStr,userid,ArRow,locId);
	if (ret!=0)
	{
		alert("err");
	}
	else
	{
	    alert("OK");
	    self.location.reload();
	}	
}
document.body.onload = BodyLoadHandler;
