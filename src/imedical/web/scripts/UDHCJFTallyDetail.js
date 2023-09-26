var path="",num=0,listStr=""

function BodyLoadHandler() 
{	
	var obj=document.getElementById("print");
	if (obj) obj.onclick=print_click; 	
}
function print_click() 
{
	var Obj=document.getElementById('startDate');
	if(Obj){
		var stDate=Obj.value;
	}
	var Obj=document.getElementById('endDate');
	if(Obj){
		var endDate=Obj.value;
	}
	var Obj=document.getElementById('company');
	if(Obj){
		var company=Obj.value;
	}
	fileName = "DHCBILL-JFTallyDetail.raq&startDate=" + stDate + "&endDate=" + endDate + "&company=" + company;
	DHCCPM_RQPrint(fileName,800,800)      
}
document.body.onload = BodyLoadHandler;