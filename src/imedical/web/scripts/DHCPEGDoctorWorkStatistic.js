/// DHCPEGDoctorWorkStatistic.js


function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BFind");
	if (obj) {obj.onclick=BFind_Click;}
	
	obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
	
	obj=document.getElementById("DocType_G");
	if (obj) { obj.onclick=DateType_click; }
	
	obj=document.getElementById("DocType_M");
	if (obj) { obj.onclick=DateType_click; }
}

function GetGroupID(value){
	if ("^^"==value) { return false; }
	var aiList=value.split("^");
	
    obj=document.getElementById("GroupDR");
	if (obj) { obj.value=aiList[0]; }
	
	obj=document.getElementById("Group");
	if (obj) { obj.value=aiList[1]; }
	
}

function DateType_click() {
	
	var src=window.event.srcElement;
	obj=document.getElementById('DocType_G');
	if (obj && obj.id!=src.id) { obj.checked=false; }
	obj=document.getElementById('DocType_M');
	if (obj && obj.id!=src.id) { obj.checked=false; }
	
	var srcId=src.id.split('_');
	obj=document.getElementById('DocType');
	if (obj) { obj.value=srcId[1]; }
}

function BClear_click()
{
	var obj;
	obj=document.getElementById("DateBegin");
    if (obj) { obj.value=""};
	
	obj=document.getElementById("DateEnd");
    if (obj) { obj.value=""};
    
     obj=document.getElementById("DocType");
    if (obj) { obj.value=""};
 
 	var obj=document.getElementById("GroupDR");
	if (obj) {obj.value="";}
	
	var obj=document.getElementById("Group");
	if (obj) {obj.value="";}
	
}
function BFind_Click()
{  
   var iDateBagin="",iDateEnd="",iDocType="",iGroupDR="";
   var obj
    obj=document.getElementById("DateBegin");
    if (obj) { iDateBagin=obj.value};
	
	obj=document.getElementById("DateEnd");
    if (obj) { iDateEnd=obj.value};
    
     obj=document.getElementById("DocType");
    if (obj) { iDocType=obj.value};
 
 	var obj=document.getElementById("GroupDR");
	if (obj) {iGroupDR=obj.value;}
	
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEGDoctorWorkStatistic"
			+"&DateBegin="+iDateBagin
			+"&DateEnd="+iDateEnd
	        +"&DocType="+iDocType
	        +"&GroupDR="+iGroupDR
	        ;
       // alert(lnk)       
    location.href=lnk; 

}




document.body.onload = BodyLoadHandler;

