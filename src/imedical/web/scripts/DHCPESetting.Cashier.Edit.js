function BodyLoadHandler()
{
	var obj
	obj=document.getElementById("Update")
	if(obj) {obj.onclick=Update_click}
	var obj
	obj=document.getElementById("Info")
	if(obj) {var encmeth=obj.value} else {encmeth=""}
	var returnval=cspRunServerMethod(encmeth,'','')
    var tmp=returnval.split("^")
	 
	    document.getElementById("BilledMode").value=tmp[0]
	    document.getElementById("FeeRowID").value=tmp[1]
	    document.getElementById("GroupsOEArcItemId").value=tmp[2]
	    document.getElementById("InvCol").value=tmp[3]
	    document.getElementById("InvMaxListCount").value=tmp[4]
	    document.getElementById("InvListFlag").value=tmp[5]
	    document.getElementById("InvColSortType").value=tmp[6]
	    document.getElementById("InvDefaulltFeeID").value=tmp[7]
	    document.getElementById("InvDefaulltFee").value=tmp[8]
	    document.getElementById("InvDefaultPayMode").value=tmp[9]
	    document.getElementById("InvFlag").value=tmp[10]
	    document.getElementById("RoundingFeeID").value=tmp[11]
	    document.getElementById("RoundingFee").value=tmp[12]
	    document.getElementById("RoundingFeeMode").value=tmp[13]
	    document.getElementById("CashierMin").value=tmp[14]
	      InfoPayMode();
} 
function InfoPayMode()
{  

	var Ins=document.getElementById("GetPayModeData")	
    if (Ins) {var encmeth=Ins.value} 
	else {var encmeth=""} 
    var Str=cspRunServerMethod(encmeth)
    //alert(Str)
	obj=document.getElementById("AllowPayMode");
	if (obj){obj.value=Str;}
}

function SearchFeeRowID(value){
	
	var temp=value.split("^")
	if(""==value){return false}
	else{
		var obj
		 obj=document.getElementById('FeeRowID')
		 obj.value=temp[1]}	}	
		 
		 
function SearchInvFee(value)
{
	var temp=value.split("^")
	if(""==value){return false}
	else{
		 var obj
		 obj=document.getElementById('InvDefaulltFeeID')
		 obj.value=temp[1]
	}   } 
	
function SearchRoundingFee(value)
{
	var temp=value.split("^")
	if(""==value){return false}
	else{
		 var obj
		 obj=document.getElementById('RoundingFeeID')
		 obj.value=temp[1]
	}   }

function trim(s)
 {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
 }	

function Update_click()
{
	var iBilledMode="",iFeeID="",iInvCol="",iInvMaxListCount="",iInvListFlag=""
    var iInvColSortType="",iInvDefaulltFee="",iInvDefaultPayMode="",iInvFlag=""
    var iRoundingFee="",iRoundingFeeMode="",iCashierMin=""
    
    var obj=document.getElementById("BilledMode");
    if (obj) {iBilledMode=obj.value;}
    
    var obj=document.getElementById("FeeRowID")
    if (obj) {iFeeID=obj.value;}
    
    var obj=document.getElementById("InvCol");
    if (obj) {iInvCol=obj.value;}
    
    var obj=document.getElementById("InvMaxListCount")
    if (obj) {iInvMaxListCount=obj.value;}
   
    var obj=document.getElementById("InvListFlag")
    if (obj) {iInvListFlag=obj.value;}
    
    var obj=document.getElementById("InvColSortType");
    if (obj) {iInvColSortType=obj.value;}
    
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

	var Instring=trim(iBilledMode)
	                      +"^"+trim(iFeeID)
	                      +"^"+trim(iInvCol)
	                      +"^"+trim(iInvMaxListCount)
	                      +"^"+trim(iInvListFlag)
	                      +"^"+trim(iInvColSortType)
	                      +"^"+trim(iInvDefaulltFee)
	                      +"^"+trim(iInvDefaultPayMode)
	                      +"^"+trim(iInvFlag)
	                      +"^"+trim(iRoundingFee)
	                      +"^"+trim(iRoundingFeeMode)
	                      +"^"+trim(iCashierMin)
	
	var Ins=document.getElementById("ClassBox")	
    if (Ins) {var encmeth=Ins.value} else {var encmeth=""}
	var flag=cspRunServerMethod(encmeth,'','',Instring) 
	if (flag==0)  
    {  window.location.reload();   
	   alert(t["Success"]);
	}
}


document.body.onload=BodyLoadHandler