
/// DHCPESpecialCSItemFind.js


var CurRow=0
var CurrentSel=0
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BExport");
	if (obj){obj.onclick=BExport_click;}
}
function BExport_click()
{
	//var objtbl=document.getElementById('tDHCPEQueryFind');	
	var tableid="tDHCPESpecialCSItemFind";
	var curTbl = document.getElementById(tableid);
    var oXL = new ActiveXObject("Excel.Application");
    var oWB = oXL.Workbooks.Add();
    var oSheet = oWB.ActiveSheet;
    var sel = document.body.createTextRange();
    sel.moveToElementText(curTbl);
    sel.select();
    sel.execCommand("Copy");
    oSheet.Paste();
    oXL.Visible = true;
}

document.body.onload = BodyLoadHandler;

