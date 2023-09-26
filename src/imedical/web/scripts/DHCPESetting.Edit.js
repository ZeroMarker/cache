//create by zhouli
//ÃÂºÏ…Ë÷√
function BodyLoadHandler()
 {
	var obj
	obj=document.getElementById("Update")
	if (obj){ obj.onclick=Update_click}
	
	var obj
	obj=document.getElementById("Info")
	if (obj){var encmeth=obj.value} else{var encmeth=""}
    var returnval=cspRunServerMethod(encmeth,'','')
    init(returnval)
 }
function Searchloc(value)
 {
	var temp=value.split("^")
	if(""==value){return false}
	else{
		var obj
		 obj=document.getElementById('PhyExamLocRowID')
		 obj.value=temp[1]
		}
 }
function SearchDr(value)
{
	
	var temp=value.split("^")
	if(""==value){return false}
	else{
		 var obj
		 obj=document.getElementById('PhyExamDrRowID')
		 obj.value=temp[2]
	}   
}
function SearchStationRowID(value)
{
	var temp=value.split("^")
	if(""==value){return false}
	else{
		var obj
		 obj=document.getElementById('StationRowID')
		 obj.value=temp[1]}
}
		 
function SearchlabRowID(value){
	alert(value)
	var temp=value.split("^")
	if(""==value){return false}
	else{
		var obj
		 obj=document.getElementById('StationLabRowID')
		 obj.value=temp[1]}	}
		 
		 
function SearchFeeRowID(value){
	alert(value)
	var temp=value.split("^")
	if(""==value){return false}
	else{
		var obj
		 obj=document.getElementById('FeeRowID')
		 obj.value=temp[1]}	}	
		 
		 
function SearchInvFee(value)
{
	alert(value)
	var temp=value.split("^")
	if(""==value){return false}
	else{
		 var obj
		 obj=document.getElementById('InvDefaulltFeeID')
		 obj.value=temp[1]
	}   } 
	
function SearchRoundingFee(value)
{
	alert(value)
	var temp=value.split("^")
	if(""==value){return false}
	else{
		 var obj
		 obj=document.getElementById('RoundingFeeID')
		 obj.value=temp[1]
	}   }
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}	

 
function Update_click()
{ var  iTrakVerison="", iPhyExamLocId="", iPhyExamDrId=""  ,iStationIds="",iStationIdLab="",iFeeID="" ,iPAPMINoGenModel=""
  var  iBookDateLimit="" ,iDefFeeType="" , iDefSexType="",  ilab="",imed="",ihospital="", ireport=""
  var  iInvCol="",iInvMaxListCount="" ,iInvColSortType="",iInvListFlag="",iInvDefaulltFee="",iInvDefaultPayMode="",iInvFlag="",iRoundingFee="",iRoundingFeeMode="",iCashierMin=""
  var  iBilledMode="",iHospitalCode=""
    var obj=document.getElementById("TrakVerison");
    if (obj) {iTrakVerison=obj.value;}
   
    var obj=document.getElementById("HospitalCode");
    if (obj) {iHospitalCode=obj.value;}
    
     var obj=document.getElementById("BilledMode");
    if (obj) {iBilledMode=obj.value;}
    
    var obj=document.getElementById("PhyExamLocRowID")
    if (obj) {iPhyExamLocId=obj.value;}
    
     var obj=document.getElementById("PhyExamDrRowID")
    if (obj) {iPhyExamDrId=obj.value;}
    
     var obj=document.getElementById("StationRowID")
    if (obj) {iStationIds=obj.value;}
    
    var obj=document.getElementById("StationLabRowID");
    if (obj) {iStationIdLab=obj.value;}
    
    var obj=document.getElementById("FeeRowID")
    if (obj) {iFeeID=obj.value;}
   
    var obj=document.getElementById("PAPMINoGenModel");
    if (obj) {iPAPMINoGenModel=obj.value;}
    
    var obj=document.getElementById("BookDateLimit")
    if (obj) {iBookDateLimit=obj.value;}
    
    var obj=document.getElementById("DefFeeType");
    if (obj) {iDefFeeType=obj.value;}
    
    var obj=document.getElementById("DefSexType");
    if (obj) {iDefSexType=obj.value;}
    
    var obj=document.getElementById("LABDATA");
    if (obj) {ilab=obj.value;}
    
    var obj=document.getElementById("MEDDATA");
    if (obj) {imed=obj.value;}
    
     var obj=document.getElementById("HospitalName");
    if (obj) {ihospital=obj.value;}
    
     var obj=document.getElementById("ReportTitle");
    if (obj) {ireport=obj.value;}
    
     var obj=document.getElementById("InvCol");
    if (obj) {iInvCol=obj.value;}
    
    var obj=document.getElementById("InvMaxListCount")
    if (obj) {iInvMaxListCount=obj.value;}
   
    var obj=document.getElementById("InvColSortType");
    if (obj) {iInvColSortType=obj.value;}
    
    var obj=document.getElementById("InvListFlag")
    if (obj) {iInvListFlag=obj.value;}
    
    var obj=document.getElementById("InvDefaulltFeeID");
    if (obj) {iInvDefaulltFee=obj.value;}
    
    var obj=document.getElementById("InvDefaultPayMode");
    if (obj) {iInvDefaultPayMode=obj.value;}
    
    var obj=document.getElementById("InvFlag");
    if (obj) {iInvFlag=obj.value;}
    
    var obj=document.getElementById("RoundingFeeID");
    if (obj) {iRoundingFee=obj.value;}
    
     var obj=document.getElementById("RoundingFeeMode");
    if (obj) {iRoundingFeeMode=obj.value;}
    
     var obj=document.getElementById("CashierMin");
    if (obj) {iCashierMin=obj.value;}

    if ((""==iTrakVerison)){
		alert(t['01']);
		return false;}


	var Instring=trim(iTrakVerison)
	                      +"^"+trim(iPhyExamLocId)
	                      +"^"+trim(iPhyExamDrId)
	                      +"^"+trim(iStationIds)
	                      +"^"+trim(iStationIdLab)
	                      +"^"+trim(iFeeID)
	                      +"^"+trim(iPAPMINoGenModel)
	                      +"^"+trim(iBookDateLimit)
	                      +"^"+trim(iDefFeeType)
	                      +"^"+trim(iDefSexType)
	                      +"^"+trim(ilab)
	                      +"^"+trim(imed)
	                      +"^"+trim(ihospital)
	                      +"^"+trim(ireport)
	                      +"^"+trim(iInvCol)
	                      +"^"+trim(iInvMaxListCount)
	                      +"^"+trim(iInvColSortType)
	                      +"^"+trim(iInvListFlag)
	                      +"^"+trim(iInvDefaulltFee)
	                      +"^"+trim(iInvDefaultPayMode)
	                      +"^"+trim(iInvFlag)
	                      +"^"+trim(iRoundingFee)
	                      +"^"+trim(iRoundingFeeMode)
	                      +"^"+trim(iCashierMin)
	                      +"^"+trim(iHospitalCode)
	                      +"^"+trim(iBilledMode)
    var Ins=document.getElementById("ClassBox")	
    if (Ins) {var encmeth=Ins.value} 
	else {var encmeth=""} 
    var flag=cspRunServerMethod(encmeth,'','',Instring) 
    if (flag==0)  
    {  window.location.reload();   
	   alert(t["info 01"]);
	}
  } 
    
    function init(returnval)
    {   var tmp=returnval.split("^")
        
        document.getElementById("HospitalName").value=tmp[0]
	    document.getElementById("ReportTitle").value=tmp[1]
	    document.getElementById("TrakVerison").value=tmp[2]
	    
	    document.getElementById("PhyExamLocRowID").value=tmp[3]
	    document.getElementById("PhyExamLocId").value=tmp[4]
	     
	    document.getElementById("PhyExamDrRowID").value=tmp[5]
	    document.getElementById("PhyExamDrId").value=tmp[6]
	    
	    document.getElementById("StationRowID").value=tmp[7]
	    document.getElementById("HealthFileStationIds").value=tmp[8]
	    
	    document.getElementById("StationLabRowID").value=tmp[9]
	    document.getElementById("StationIdLab").value=tmp[10]
	      
	    document.getElementById("FeeRowID").value=tmp[11]
	    document.getElementById("GroupsOEArcItemId").value=tmp[12]
	    document.getElementById("PAPMINoGenModel").value=tmp[13]
	    document.getElementById("BookDateLimit").value=tmp[14]
	  
	    document.getElementById("DefFeeType").value=tmp[15]
	    document.getElementById("DefSexType").value=tmp[16]
	    document.getElementById("LABDATA").value=tmp[17]
	    document.getElementById("MEDDATA").value=tmp[18]
	    
	    document.getElementById("InvCol").value=tmp[19]
	    document.getElementById("InvMaxListCount").value=tmp[20]
	    document.getElementById("InvColSortType").value=tmp[21]
	    document.getElementById("InvListFlag").value=tmp[22]
	    document.getElementById("InvDefaulltFee").value=tmp[23]
	    document.getElementById("InvDefaulltFeeID").value=tmp[24]
	    document.getElementById("InvDefaultPayMode").value=tmp[25]
	    document.getElementById("InvFlag").value=tmp[26]
	    document.getElementById("RoundingFee").value=tmp[27]
	    document.getElementById("RoundingFeeID").value=tmp[28]
	    document.getElementById("RoundingFeeMode").value=tmp[29]
	    document.getElementById("CashierMin").value=tmp[30]
	    document.getElementById("HospitalCode").value=tmp[31]
        document.getElementById("BilledMode").value=tmp[32]
	   
    } 
   
   
document.body.onload=BodyLoadHandler
	


