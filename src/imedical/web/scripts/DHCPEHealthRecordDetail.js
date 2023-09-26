 function BodyLoadHandler()
 {
	var obj
	obj=document.getElementById("Save")
	if (obj){ obj.onclick=Save_click}
	var obj
	obj=document.getElementById("Delete")
	if (obj){ obj.onclick=Delete_click}
 } 

 function trim(s) 
 {
	if (""==s) {return ""}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/)
	return (m == null) ? "" : m[1]
 }	
 
 function Save_click()
 { 
    var iciname="",idesc="",itype="",icode="",irequired="",irowid=""
    var icascade="",iparent="",isequence="",ihrrowid="",ihrdrowid=""
    var obj=document.getElementById("Desc")
    if (obj) {idesc=obj.value}
    
    var obj=document.getElementById("Code")
    if (obj) {icode=obj.value}
    
    var obj=document.getElementById("DisplayType")
    if (obj) {itype=obj.value}
    
    var obj=document.getElementById("CIName")
    if (obj) {iciname=obj.value}
   
    var obj=document.getElementById("Required")
    if (obj.checked) {irequired='Y'}
    else{irequired='N'}
    
    var obj=document.getElementById("Cascade")
    if (obj) {icascade=obj.value}
    
    var obj=document.getElementById("Parent")
    if (obj) {iparent=obj.value}
    
    var obj=document.getElementById("Sequence")
    if (obj) {isequence=obj.value}
    
    var obj=document.getElementById("HR_RowId")
    if (obj) {ihrrowid=obj.value}
    
    var obj=document.getElementById("HRD_RowId")
    if (obj) {ihrdrowid=obj.value}
    
    var obj=document.getElementById("RowId")
    if (obj) {irowid=obj.value}
  
	var Instring=trim(idesc)
	                  +"^"+trim(icode)
	                  +"^"+trim(itype)
	                  +"^"+trim(iciname)
	                  +"^"+trim(irequired)
	                  +"^"+trim(icascade)
	                  +"^"+trim(iparent)
	                  +"^"+trim(isequence)
	                  +"^"+trim(ihrrowid)
	                  +"^"+trim(ihrdrowid)
	                  +"^"+trim(irowid)
	                      
    var Ins=document.getElementById("SaveBox")
    if (Ins) {var encmeth=Ins.value} 
	else {var encmeth=""} 
    var flag=cspRunServerMethod(encmeth,'','',Instring) 
    if (flag==0)  
    {window.location.reload()}
  }
 document.body.onload=BodyLoadHandler