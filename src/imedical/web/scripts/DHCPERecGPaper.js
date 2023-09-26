///	DHCPERecGPaper.js
///	前台团体取消收表
///	20121208  
///	-----------------------
///	created by lxl 20121208
///	Description:    
var CurrentSel=0
function BodyLoadHandler(){
	var obj;  
	obj=document.getElementById("BCancelRecPaper");
	if (obj){ obj.onclick=BCancelRecPaper_click; }
	if (parent.frames["DHCPERecPaper"]) parent.frames["DHCPERecPaper"].websys_setfocus("ConfirmRecPaper"); 
	//websys_setfocus("ConfirmRecPaper"); 
} 

function BCancelRecPaper_click() {
	if (CurrentSel==0) return;
	var iPIADM="";
	var obj=document.getElementById("PIADMz"+CurrentSel);
	if (obj){ iPIADM=obj.value; }

	if (iPIADM=="")	{
		alert(t['01']);
		return false
	} 
	else{ 
		if (confirm(t['02'])) {
			var Ins=document.getElementById('CancelRecPaper');
			if (Ins) {var encmeth=Ins.value; } 
			else {var encmeth=''; };

			var flag=cspRunServerMethod(encmeth,iPIADM)
			if (flag=='0') {}
			else{
				alert(t['03']+flag)
			}
		location.reload();
		}
	}
}

function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel)
	{	    
	    CurrentSel=0;
	    return;
	}

	CurrentSel=selectrow;


}
document.body.onload = BodyLoadHandler;