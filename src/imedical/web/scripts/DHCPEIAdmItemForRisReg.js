/// DHCPEIAdmItemForRisReg.js
var TFORM="DHCPEIAdmItemForRisReg";
var SelectedRow=0
function Ini(){

}

function SelectRowHandler()	
{		
	var eSrc = window.event.srcElement;	//�����¼���
	var objtbl=document.getElementById('tDHCPEIAdmItemForRisReg');	//ȡ���Ԫ��?����
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;

	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

    ///�˴�֮ǰ��Ϊ�̶�?�����޸�document.getElementById('tINSUPatTypeC
    
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
	var tbl=document.getElementById('t'+TFORM);	//ȡ���Ԫ��?����
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
