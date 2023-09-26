/////DHCWeb.OPMagMultiCardSup.js

////Support Multi Card 
////

//modify by tang 2006.08.02
function GetPmino() {
 var pmiobj=document.getElementById("PatientID");
 var key=websys_getKey(e);
 if (key==13) {	
    var plen=pmiobj.value.length
    var i
    var lszero=""
    if (plen==0){
	     DHCWeb_setfocus('PatientID'); return 0;}
 	if (plen<=8){
	 for (i=1;i<=8-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
	 var lspmino=lszero+pmiobj.value;
	 pmiobj.value=lspmino;
	 ReadPatInfo();
	 }
	else
	{
	 var patno=pmiobj.value
	 var getmethod=document.getElementById('chpatienno');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     var retval=cspRunServerMethod(encmeth,patno)
     if (retval==0){alert(t['35']);return;}
     else if (retval==1){
	     var patno=pmiobj.value
	     var getmethod=document.getElementById('getpmifrcard');
         if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
         var retval=cspRunServerMethod(encmeth,patno);
         pmiobj.value=retval ;
        ReadPatInfo();
         }
     else
     {
     var  CardTypeobj=document.getElementById("CGetCardType");
       CardTypeobj.style.visibility = "visible";
    var obj=document.getElementById('ld50536iCGetCardType');
       obj.style.visibility = "visible";
      DHCWeb_setfocus('CGetCardType');
     }
	}
 }
}
function CGetCardType_lookuphandler(e) {
	
	if (evtName=='CGetCardType') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var url='websys.lookup.csp';
		url += "?ID=d50536iCGetCardType";
		url += "&CONTEXT=Kweb.DHCPhQueryTotal:QueryCardType";
		url += "&TLUJSF=GetDropPmino";
		var obj=document.getElementById('PatientID');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		websys_lu(url,1,'top=100,left=100,width=200,height=100');
		return websys_cancel();
	}
}

/////
var obj=document.getElementById('CGetCardType');
if (obj) {obj.onkeydown=CGetCardType_lookuphandler;}
var obj=document.getElementById('ld50536iCGetCardType');
if (obj) {obj.onclick=CGetCardType_lookuphandler;}

function GetDropPmino(value)
{
	var val=value.split("^") 
	var pmiobj=document.getElementById("PatientID");
	var winid=document.getElementById("CGetCardType");
	winid.value=val[0]
	var patno=pmiobj.value
	var getmethod=document.getElementById('getpmifrcardType');
	if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	var retval=cspRunServerMethod(encmeth,patno,val[1]);
	pmiobj.value=retval;
  
  
	var  CardTypeobj=document.getElementById("CGetCardType");
	if (CardTypeobj){
		CardTypeobj.style.visibility = "hidden";
	}
	var obj=document.getElementById('ld50536iCGetCardType');
	if (obj){
		obj.style.visibility = "hidden";
	}
	ReadPatInfo();     	  
}
//modify by tang 2006.08.02
