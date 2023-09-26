/// DHCPEIAdmItemForRisReg.js
var TFORM="DHCPEIAdmItemForRisReg";
var SelectedRow=0
function Ini(){

}

function SelectRowHandler()	
{		
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEIAdmItemForRisReg');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;

	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

    ///此处之前较为固定?除了修改document.getElementById('tINSUPatTypeC
    
    if (!selectrow) return;
	ChangeCheckStatus("TSelect");
	
}	

function ChangeCheckStatus(ItemName)
{
	var eSrc=window.event.srcElement;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var obj=document.getElementById(ItemName+"z"+selectrow);
	if (obj) obj.checked=!obj.checked;
}
function GetARCIMID()
{   var obj
	var tbl=document.getElementById('t'+TFORM);	//取表格元素?名称
	var row=tbl.rows.length;
	var vals="";
	var val=""

	for (var iLLoop=1;iLLoop<row;iLLoop++) {

		obj=document.getElementById('TSelect'+'z'+iLLoop);
		
		if (obj && obj.checked) {
		obj=document.getElementById('TARCIMDR'+'z'+iLLoop);
	
		if (obj){ val=obj.value; }
	   
	    var vals=vals+val+"^"
		
	}
	}
	return vals;
}

document.body.onload = Ini;
