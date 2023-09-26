
function BodyLoadHandler()
{
  var obj=document.getElementById("Ok");
  obj.onclick=HandleOK;
 var obj=document.getElementById("Exit");
  obj.onclick=Cancel;
  var obj=document.getElementById("Rowid");
  if (obj) 
  {
   var rowid=obj.value ;
   if (rowid!="")  getPhaLocation(rowid)
  }
  SetWinCenter(self)
}

function SetLookUpLocRowid(str)
{	var loc=str.split("^");
	var obj=document.getElementById("DispLocRowid");
	if (obj)
	{if (loc.length>0)   obj.value=loc[1] ;
		else	obj.value="" ;  
	}
}
function HandleOK()
{
  AddOneRow()	;
}

function AddOneRow()
{
	var rowid ;
	var obj=document.getElementById("Rowid")
	if (obj) rowid=obj.value;	
	//
	var resretflag
	var NotByWardFlag
	var auditneedflag
	
	
//	alert(exe)
	var obj=document.getElementById("DispLocRowid")
	if (obj) var loc=obj.value;
	var obj=document.getElementById("NotByWardFlag")
	if (obj) {
	  if (obj.checked==true) NotByWardFlag="Y"
	  else NotByWardFlag="" 
	}
	  
	var obj=document.getElementById("DSD")
	if (obj) var DSD=obj.value;
	var obj=document.getElementById("DED")
	if (obj) var DED=obj.value;
	var obj=document.getElementById("DST")
	if (obj) var DST=obj.value;
	var obj=document.getElementById("DET")
	if (obj) var DET=obj.value;
	var obj=document.getElementById("SSD")
	if (obj) var SSD=obj.value;
	var obj=document.getElementById("SED")
	if (obj) var SED=obj.value;
	var obj=document.getElementById("SST")
	if (obj) var SST=obj.value;
	var obj=document.getElementById("SET")
	if (obj) var SET=obj.value;
	
	var obj=document.getElementById("RetStDate")
	if (obj) var RSD=obj.value;
	var obj=document.getElementById("RetEndDate")
	if (obj) var RED=obj.value;
	
	var obj=document.getElementById("DispListCountPrefix")
	if (obj) var prefix=obj.value;
	var obj=document.getElementById("AuditNeedFlag")
	if (obj) {
	  if (obj.checked==true) auditneedflag="Y"
	  else auditneedflag="" }
	
	var obj=document.getElementById("ReserveRetFlag")
	if (obj) {
	  if (obj.checked==true) resretflag="Y"
	  else resretflag="" 
	}
	
	var obj=document.getElementById("DispUserFlag")
	if (obj) {
	  if (obj.checked==true) dispuserflag="Y"
	  else dispuserflag="" }
	  
	var obj=document.getElementById("OperaterFlag")	   //¼ÇÂ¼°ÚÒ©ÈË add by caoting
	if (obj) {
	   if (obj.checked==true) operaterflag="Y"
	   else operaterflag="" }
	   
	var obj=document.getElementById("RetAllFlag")
	if (obj) {
	  if (obj.checked==true) retallflag="Y"
	  else retallflag="" }
    
    var obj=document.getElementById("AduitBill")
	if (obj) {
	  if (obj.checked==true) aduitbillflag="Y"
	  else aduitbillflag="" }
	  
	var obj=document.getElementById("DispTypeLocal")
	if (obj) {
	  if (obj.checked==true) disptypelocalflag="Y"
	  else disptypelocalflag="" }
	 
	var obj=document.getElementById("DisplayEmy")
	if (obj) {
	  if (obj.checked==true) displayemyflag="Y"
	  else displayemyflag="" } 
	
	var obj=document.getElementById("DisplayOut")
	if (obj) {
	  if (obj.checked==true) displayoutflag="Y"
	  else displayoutflag="" }
	  
    var obj=document.getElementById("LS")
	if (obj) {
	  if (obj.checked==true) lsflag="Y"
	  else lsflag="" }
	  
	var obj=document.getElementById("ReqWard")
	if (obj) {
	  if (obj.checked==true) reqwardflag="Y"
	  else reqwardflag="" }   
	 
	var obj=document.getElementById("DispDefault") 
	if (obj) {
	  var dispdefaultflag=obj.value }
	  
    dates=DSD+"^"+DED+"^"+DST+"^"+DET+"^"+SSD+"^"+SED+"^"+SST+"^"+SET+"^"+RSD+"^"+RED
    
    var peret="N"
    var objprteret=document.getElementById("PrtExecRet")
    if (objprteret) 
    {
	    if (objprteret.checked) peret="Y" ;
    }
    
    var sendmachine="N"
    var objSendMachine=document.getElementById("SendMachine")
    if (objSendMachine) 
    {
	    if (objSendMachine.checked) sendmachine="Y" ;
    }
    
    
    var OrdAuditFlag="N"
    var objOrdAuditFlag=document.getElementById("OrdAuditFlag")
    if (objOrdAuditFlag) 
    {
	    if (objOrdAuditFlag.checked) OrdAuditFlag="Y" ;
    }
    
	
	var exe1,exe2
	
   	var obj=document.getElementById("mAddPhaLoc")
	if (obj ) exe1=obj.value 
	else exe1= ""

   	var obj=document.getElementById("mUpdatePhaLoc")
	if (obj ) exe2=obj.value 
	else exe2= ""
	
	
	
	var parastr=dispuserflag+"^"+retallflag+"^"+operaterflag+"^"+aduitbillflag+"^"+disptypelocalflag+"^"+displayemyflag+"^"+displayoutflag+"^"+lsflag+"^"+reqwardflag+"^"+dispdefaultflag+"^"+peret+"^"+sendmachine+"^"+OrdAuditFlag
	
	if (rowid=="") 
	{
		var rowid=cspRunServerMethod(exe1,loc,NotByWardFlag,"",dates,prefix,auditneedflag,resretflag,parastr)
		if (rowid<0) 
		{	alert(t['ADD_FAILED'])
			return}
	}
	else
	{
		var xx=cspRunServerMethod(exe2,rowid,loc,NotByWardFlag,"",dates,prefix,auditneedflag,resretflag,parastr)
		if (xx<0)
		{ alert(t['UPDATE_FAILED'])
			return		}
	}
	window.close();
	opener.location.reload();
	
	}
function Cancel()
{ window.close() ;
}

function getPhaLocation(rowid)
{   
    var exe ;
	var obj=document.getElementById("mGetPhaLoc")
	if (obj) exe=obj.value;
	else exe="";
	
	var result=cspRunServerMethod(exe,rowid)
	if (result!="")
	{
			 var ss=result.split("^")
		
		     var specflag=ss[0]
		     var cydyflag=ss[1]
		     var dsd=ss[2];
		     var ded=ss[3];
		     var dst=ss[4];
		     var det=ss[5];
		     var ssd=ss[6];
		     var sed=ss[7];
		     var sst=ss[8];
		     var set=ss[9];
		     var needAuditFlag=ss[10]
		 	 var resflag=ss[11]
		 	 var locdr=ss[12]       	  	 	 	  	
			 var locdesc=ss[13]	
			 var finaldate=ss[14]
			 var countfix=ss[15]
			 var countno=ss[16]
			 var dispuser=ss[17]
			 var retstdate=ss[18]
			 var retenddate=ss[19]
			 var retallflag=ss[20]
			 var operater=ss[21]
			 var aduitBill=ss[22]
			 var disptypelocal=ss[23]
			 var displayemy=ss[24]
			 var displayout=ss[25]
			 var ls=ss[26]
			 var reqward=ss[27]
			 var dispdefault=ss[28]
			 //alert(aduitBill)
             var prtret=ss[30]
             var sendmachine=ss[31]
             var ordauditflag=ss[32]
             
			 var obj=document.getElementById("DSD")	
			 if (obj) obj.value=dsd
			 var obj=document.getElementById("DED")	
			 if (obj) obj.value=ded
			 var obj=document.getElementById("DST")	
			 if (obj) obj.value=dst
			 var obj=document.getElementById("DET")	
			 if (obj) obj.value=det
			 var obj=document.getElementById("SSD")	
			 if (obj) obj.value=ssd
			 var obj=document.getElementById("SED")	
			 if (obj) obj.value=sed
			 var obj=document.getElementById("SST")	
			 if (obj) obj.value=sst
			 var obj=document.getElementById("SET")	
			 if (obj) obj.value=set
			  var obj=document.getElementById("RetStDate")	
			 if (obj) obj.value=retstdate
			  var obj=document.getElementById("RetEndDate")	
			 if (obj) obj.value=retenddate
			 var obj=document.getElementById("DispListCountPrefix")	
			 if (obj) obj.value=countfix
			 var obj=document.getElementById("DispListCountNo")	
			 if (obj) obj.value=countno
			 var obj=document.getElementById("AuditNeedFlag")	
			 if (obj)
			 { if (needAuditFlag=="Y") obj.checked=true
			   else obj.checked=false
				//  obj.value=needAuditFlag
		      }
			 var obj=document.getElementById("FinalDate")	
			 if (obj) obj.value=finaldate
			 var obj=document.getElementById("NotByWardFlag")	
			 if (obj)
			 {if (specflag=="Y") obj.checked=true
			  else obj.checked=false
			 }
			 var obj=document.getElementById("DispLoc")	
			 if (obj) obj.value=locdesc
			 var obj=document.getElementById("DispLocRowid")	
			 if (obj) obj.value=locdr
			 var obj=document.getElementById("ReserveRetFlag")	
			 if (obj)
			 { if (resflag=="Y")  obj.checked=true
			   else  obj.checked=false }
			 var obj=document.getElementById("DispUserFlag")	
			 if (obj)
			 {
				   if (dispuser=="Y") { obj.checked=true;}
				   else  { obj.checked=false }  
			 }
			 var obj=document.getElementById("RetAllFlag")	
			 if (obj)
			 {
				   if (retallflag=="Y") { obj.checked=true;}
				   else  { obj.checked=false }  
			 }
			 var obj=document.getElementById("OperaterFlag")
			 if(obj)
			 {
				 if (operater=="Y") {obj.checked=true;}
				 else {obj.checked=false}
			 }
			 var obj=document.getElementById("AduitBill")
			 if(obj)
			 {
				 if (aduitBill=="Y") {obj.checked=true;}
				 else {obj.checked=false}
			 }
			 var obj=document.getElementById("DispTypeLocal")
			 if(obj)
			 {
				 if (disptypelocal=="Y") {obj.checked=true;}
				 else {obj.checked=false}
			 }
			 var obj=document.getElementById("DisplayEmy")
			 if(obj)
			 {
				 if (displayemy=="Y") {obj.checked=true;}
				 else {obj.checked=false}
			 }
			 var obj=document.getElementById("DisplayOut")
			 if(obj)
			 {
				 if (displayout=="Y") {obj.checked=true;}
				 else {obj.checked=false}
			 }
			 var obj=document.getElementById("LS")
			 if(obj)
			 {
				 if (ls=="Y") {obj.checked=true;}
				 else {obj.checked=false}
			 }
			 var obj=document.getElementById("ReqWard")
			 if(obj)
			 {
				 if (reqward=="Y") {obj.checked=true;}
				 else {obj.checked=false}
			 }
			 var obj=document.getElementById("DispDefault")
			 if(obj)
			 {
				 obj.value=dispdefault
			 }
			 
			 var obj=document.getElementById("PrtExecRet")
			 if(obj)
			 {
				 if (prtret=="Y") {obj.checked=true;}
				 else {obj.checked=false}
			 }
			 
			 var obj=document.getElementById("SendMachine")
			 if(obj)
			 {
				 if (sendmachine=="Y") {obj.checked=true;}
				 else {obj.checked=false}
			 }
			 
			 var obj=document.getElementById("OrdAuditFlag")
			 if(obj)
			 {
				 if (ordauditflag=="Y") {obj.checked=true;}
				 else {obj.checked=false}
			 }
			 
			 
			 
	 	 	
	 }
	 

	 	 	
	
	 
 }

document.body.onload=BodyLoadHandler;