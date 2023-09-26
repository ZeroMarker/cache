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
        document.getElementById("StationLabRowID").value=tmp[0]
	    document.getElementById("StationIdLab").value=tmp[1]
	    document.getElementById("StationId_Ris").value=tmp[2]
	    document.getElementById("SSGroup_SummarizeAudit").value=tmp[3]
}
        
function SearchlabRowID(value)
{
	var temp=value.split("^")
	if(""==value){return false}
	else{
		var obj
		 obj=document.getElementById('StationLabRowID')
		 obj.value=temp[1]}	
}
		 			 
function trim(s)
{
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}	

function Update_click()
{
    var  iStationIdLab=""
   
    var obj=document.getElementById("StationLabRowID")
    if (obj) {iStationIdLab=obj.value}
    
	var Instring=trim(iStationIdLab)
	
	var Ins=document.getElementById("ClassBox")	
    if (Ins) {var encmeth=Ins.value} else {var encmeth=""}
	var flag=cspRunServerMethod(encmeth,'','',Instring) 
	if (flag==0)  
    {
	    window.location.reload() 
	    alert(t["Success"])  
	}
}

document.body.onload=BodyLoadHandler