
 function BodyLoadHandler()
 {
	var obj
	obj=document.getElementById("Update")
	if (obj){ obj.onclick=Update_click}
	var obj
	obj=document.getElementById("Info")
	if (obj){var encmeth=obj.value} else{var encmeth=""}
    var returnval=cspRunServerMethod(encmeth,'','')
 
    var tmp=returnval.split("^")
   
	document.getElementById("ReportTitle").value=tmp[0]
 } 

 function trim(s) 
 {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
 }	
 
 function Update_click()
 { 
    var ireport="";
    var obj=document.getElementById("ReportTitle")
    if (obj) {ireport=obj.value;}

	var Instring=trim(ireport)
	                      
    var Ins=document.getElementById("ClassBox")
    if (Ins) {var encmeth=Ins.value} 
	else {var encmeth=""} 
    var flag=cspRunServerMethod(encmeth,'','',Instring) 
    if (flag==0)  
    {
	    window.location.reload()
	    alert(t["Success"])   
	}
  }
 document.body.onload=BodyLoadHandler