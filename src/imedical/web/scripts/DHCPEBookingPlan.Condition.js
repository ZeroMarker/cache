// DHCPEBookingPlan.Condition.js

function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BQuery");
	if (obj) { obj.onclick=BQuery_Click; }
	
	obj=document.getElementById("GADM")
	if (obj) { 
		obj.onclick=BType_Click;
		obj.checked=true;
	}
	
	obj=document.getElementById("IADM")
	if (obj) { obj.onclick=BType_Click;}
}

function BQuery_Click() {

	var obj;
	var iQType="";
	
	var iBookingDate="G";

	obj=document.getElementById("GADM");
	if (obj && obj.checked) { iQType="G"; }
	
	obj=document.getElementById("IADM");
	if (obj && obj.checked) { iQType="I"; }
	
	if (""==iQType) { return; }
	
	obj=document.getElementById("BookingDate");
	if (obj && ""!=obj.value) { iBookingDate=obj.value; }
	else { return false; }

	parent.frames["BookingPlan.Query"].BookingPlanQuery(iQType+"^"+iBookingDate);	

}

function BType_Click() {

	var Src=window.event.srcElement;
	
	obj=document.getElementById("GADM")
	if (obj && obj.id!=Src.id) { obj.checked=false;}
	
	obj=document.getElementById("IADM")
	if (obj && obj.id!=Src.id) { obj.checked=false;}	
}


/*
function BQuery_Click() {

	var obj;
	var iBookingDate="";

	obj=document.getElementById("BookingDate");

	if (obj && ""!=obj.value) { iBookingDate=obj.value; }
	else { return false; }

	var lnk="DHCPEBookingPlan.Query.csp?a=a"
			+"&BookingDate="+iBookingDate
			;

	parent.frames["BookingPlan.Query"].location.href=lnk;	
	
}

*/
document.body.onload = BodyLoadHandler;
