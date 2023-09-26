/// DHCPEPreIBaseInfo.List.js


function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BFind");
	if (obj) {obj.onclick=BFind_Click;}

	obj=document.getElementById('RegNo');
	if (obj) {obj.onkeydown=RegNo_keydown; }
	
	obj=document.getElementById('PatName');
	if (obj) {obj.onkeydown=RegNo_keydown; }
}

function RegNo_keydown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_Click();
	}
}


function BFind_Click()
{   
   var iRegNo="",iPatName="",iPatType="",iPatSex="",iPatDOB="",iPatIDCard=""
   var obj
    
	 var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	obj=document.getElementById("RegNo");
	if (obj){ 
		iRegNo=obj.value;
		if (iRegNo.length<RegNoLength && iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}
	}

	obj=document.getElementById("PatName");
    if (obj) { iPatName=obj.value};
    
    
    obj=document.getElementById("PatType");
    if (obj) { iPatType=obj.value};
	
	obj=document.getElementById("PatSex");
    if (obj) { iPatSex=obj.value};
    
    obj=document.getElementById("PatDOB");
    if (obj) { iPatDOB=obj.value};

    
    obj=document.getElementById("PatIDCard");
    if (obj) { iPatIDCard=obj.value};
    
  
  

     
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreIBaseInfo.List"
			+"&RegNo="+iRegNo
			+"&PatName="+iPatName
			+"&PatType="+iPatType
			+"&PatSex="+iPatSex
			+"&PatDOB="+iPatDOB
			+"&PatIDCard="+iPatIDCard
               
    location.href=lnk; 

}




document.body.onload = BodyLoadHandler;



