/// DHCPEItemNoCheck.ItmList.js
///
///
var TForm="tDHCPEItemNoCheck_ItmList";
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("CSelectAll");
	if (obj) { obj.onclick=SelectAll; }

}

function SelectAll() {
	var Src=window.event.srcElement;
	var obj;
	
	objtbl=document.getElementById(TForm);
	if (objtbl) {}
	else { return false; }
	
	for (iLoop=1;iLoop<=objtbl.rows.length;iLoop++) {
		obj=document.getElementById("TCheck"+"z"+iLoop);
		if (obj) { obj.checked=Src.checked; }
	}
	
}

// 获取项目 
function GetOEList() {
	
	var OEList='';
	var obj,objtbl;
	objtbl=document.getElementById(TForm);
	if (objtbl) {
		
		for (iLoop=1;iLoop<=objtbl.rows.length;iLoop++) {
			obj=document.getElementById("TCheck"+"z"+iLoop);
			if (obj && obj.checked) {
				obj=document.getElementById("TItemId"+"z"+iLoop);
				OEList =OEList+obj.value+'^';
			}
		}		
	}
	if (""!=OEList) { OEList="^"+OEList; }
	return OEList;
}

document.body.onload=BodyLoadHandler;