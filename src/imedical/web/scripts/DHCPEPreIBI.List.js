//Create by MLH 20071212
//var TFORM="tDHCPEPreIBI_List";

var SelectedRow=0
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("New");
	if (obj){ obj.onclick=New_click; }
	var tbl=document.getElementById('tDHCPEPreIBI_List');
	if (tbl){tbl.ondblclick=SelRegNo_click;}
	iniForm();
}
function iniForm(){
	var obj;
}
function SelectRowHandler() {
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEPreIBI_List');	//取表格元素?名称
	var rowObj=getRow(eSrc);
	var SelectedRow=rowObj.rowIndex;
}

function SelRegNo_click() {
	var RegNo=GetRegNo();
	if (RegNo==""){ return false;}
    window.opener.TransRegNo(RegNo);
	window.close();
 	return false;
}
function New_click() {
 	window.close();
}

function GetRegNo()
{
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEPreIBI_List');	//取表格元素?名称
	var rowObj=getRow(eSrc);
	var SelectedRow=rowObj.rowIndex;

	if (SelectedRow==0) return ""
	var obj,RegNo="";
	obj=document.getElementById("PIBI_PAPMINoz"+SelectedRow);
	if (obj) RegNo=obj.innerText;
	return RegNo;
}	
document.body.onload = BodyLoadHandler;