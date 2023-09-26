///DHCOutPhPrintCom  
///打印配药单,处方通用js,供界面调用
///调用新版scripts/pharmacy/outpha/dhcpha.outpha.printcom.js
function BodyLoadHandler(){	
	var phdrowid="",cyflag="",supp="";
	var cyobj=document.getElementById("cyflag")
	if (cyobj) {
		cyflag=cyobj.value;
	}
	var phobj=document.getElementById("phdrowid")
	if (phobj){
		phdrowid=phobj.value
	}
	if (phdrowid!="") {
	}else {
		var suppobj=document.getElementById("supp");
		if (suppobj){   
			supp=suppobj.value;
		} 
	}
	var printtype="";
	var printtypeobj=document.getElementById("PrintType");
	if (printtypeobj){
		printtype=printtypeobj.value;
	}
	PrintPrescCom(phdrowid,cyflag,supp,printtype);
	Clearitm();
}
function Clearitm()
{
	phobj=document.getElementById("phdrowid")
	if (phobj) {phobj.value=""}
	cyobj=document.getElementById("cyflag")
	if (cyobj) {cyobj.value=""}
}
document.body.onload=BodyLoadHandler;