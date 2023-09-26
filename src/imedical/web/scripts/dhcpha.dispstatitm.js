

function BodyLoadHandler()
{
	var obj=document.getElementById("t"+"dhcpha_dispstatitm")
	if (obj) obj.ondblclick=retrieveItm;
	
	var obj=document.getElementById("Close")
	if (obj) obj.onclick=closewin;
	
	var obj=document.getElementById("openSumwin")
	if (obj) obj.onclick=openSumwin;
	
	
}
function retrieveItm()
{
	return; //去掉此功能
	var obj=document.getElementById("currentRow")
	if (obj) var currRow=obj.value;
//	alert(currRow) ;
	var obj=document.getElementById("PID"+"z"+currRow)
	if (obj) var pid=obj.value;
//	alert(pid)
	var obj=document.getElementById("Tinci"+"z"+currRow)
	if (obj) var inciID=obj.value;
	//alert(inciID)
	var obj=document.getElementById("AdmLocID"+"z"+currRow)
	if (obj) var admloc=obj.value;
//	alert(currRow)
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispstatitmdet&PID="+pid+"&INCI="+inciID+"&AdmLocId="+admloc
	window.open(lnk,"_target","height=500,width=800,menubar=no,status=no,toolbar=no,resizable=yes,scrollbars=yes") ;
	
	}
function closewin()
{
	window.close() ;}
	
function openSumwin()
{
    var objtbl=document.getElementById("t"+"dhcpha_dispstatitm")
    var cnt=objtbl.rows.length-1
    if (cnt==0){return;}
	var obj=document.getElementById("PID"+"z"+1)
	if (obj) var pid=obj.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispstatitmsum&PID="+pid
	window.open(lnk,"_target","height=500,width=800,menubar=no,status=no,toolbar=no,resizable=yes,scrollbars=yes") ;
}

function SelectRowHandler() {
	var row=selectedRow(window);
	var obj=document.getElementById("currentRow") ;
	if (obj) obj.value=row
}

document.body.onload=BodyLoadHandler;
