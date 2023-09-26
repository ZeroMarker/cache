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
        document.getElementById("HospitalName").value=tmp[0]
	    document.getElementById("HospitalCode").value=tmp[1]
	    document.getElementById("TrakVerison").value=tmp[2]
	    document.getElementById("MEDDATA").value=tmp[3]
	    document.getElementById("LABDATA").value=tmp[4]
} 
function trim(s)
 {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
 }	

function Update_click()
{
    var  ihospital="",iHospitalCode="",iTrakVerison="",imed="",ilab=""
    
    var obj=document.getElementById("TrakVerison");
    if (obj) {iTrakVerison=obj.value;}
   
    var obj=document.getElementById("HospitalCode");
    if (obj) {iHospitalCode=obj.value;}
    
    
    var obj=document.getElementById("LABDATA");
    if (obj) {ilab=obj.value;}
    
    var obj=document.getElementById("MEDDATA");
    if (obj) {imed=obj.value;}
    
     var obj=document.getElementById("HospitalName");
    if (obj) {ihospital=obj.value;}


	var Instring=trim(ihospital)
	                      +"^"+trim(iHospitalCode)
	                      +"^"+trim(iTrakVerison)
	                      +"^"+trim(imed)
	                      +"^"+trim(ilab)
	                     
	var Ins=document.getElementById("ClassBox")	
    if (Ins) {var encmeth=Ins.value} else {var encmeth=""}
	var flag=cspRunServerMethod(encmeth,'','',Instring) 
	if (flag==0)  
    {  window.location.reload();   
	   alert(t["Success"]);
	}
}


document.body.onload=BodyLoadHandler