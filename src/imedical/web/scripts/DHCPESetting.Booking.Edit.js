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
	 document.getElementById("PhyExamLocRowID").value=tmp[0]
	 document.getElementById("PhyExamLocId").value=tmp[1]
	 document.getElementById("PhyExamDrRowID").value=tmp[2]
	 document.getElementById("PhyExamDrId").value=tmp[3]
	 document.getElementById("PAPMINoGenModel").value=tmp[4]
	 document.getElementById("BookDateLimit").value=tmp[5]
	 document.getElementById("DefFeeType").value=tmp[6]
	 document.getElementById("DefSexType").value=tmp[7]
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
function trim(s)
 {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
 }	

function Update_click()
{
	var iPhyExamLocId="", iPhyExamDrId="", iPAPMINoGenModel="", iBookDateLimit="",iDefFeeType="", iDefSexType="";
	var obj=document.getElementById("PhyExamLocRowId")
    if (obj) {iPhyExamLocId=obj.value}
    
    var obj=document.getElementById("PhyExamDrRowId")
    if (obj) {iPhyExamDrId=obj.value}
    
    var obj=document.getElementById("PAPMINoGenModel")
    if (obj) {iPAPMINoGenModel=obj.value}
    
    var obj=document.getElementById("BookDateLimit")
    if (obj) {iBookDateLimit=obj.value}
    
    var obj=document.getElementById("DefFeeType")
    if (obj) {iDefFeeType=obj.value}
    
    var obj=document.getElementById("DefSexType")
    if (obj) {iDefSexType=obj.value}
    
    var Instring=trim(iPhyExamLocId)+"^"+trim(iPhyExamDrId)
	                                +"^"+trim(iPAPMINoGenModel)
	                                +"^"+trim(iBookDateLimit)
	                                +"^"+trim(iDefFeeType)
	                                +"^"+trim(iDefSexType)
	var Ins=document.getElementById("ClassBox")	
    if (Ins) {var encmeth=Ins.value} else {var encmeth=""}
	var flag=cspRunServerMethod(encmeth,'','',Instring) 
	if (flag==0)  
    {  window.location.reload();   
	   alert(t["Success"]);
	}
}


document.body.onload=BodyLoadHandler