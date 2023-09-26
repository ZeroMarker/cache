///	FileName: DHCPEGAdm.List.JS
///	Created by SongDeBo 2006/5/29
///	Description:  团体信息查询主form.
///	
///	-----------------------
var gGrpAdmId="",  gGrpStatus=""
    
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEGAdm_List');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	gGrpAdmId="", gGrpId="", gGrpStatus="";
    
    if (!selectrow) return;
	DAlert('TRowIdz="'+selectrow+'"');
    
    var SelCellObj=document.getElementById('TRowIdz'+selectrow);
	gGrpAdmId=SelCellObj.innerText;
    var SelCellObj=document.getElementById('TGStatusz'+selectrow);
	gGrpStatus=SelCellObj.value;
	DAlert("gGrpAdmId=222   "+gGrpAdmId);
	return;    
}

/// 团体条码打印
function BarCodePrint() {
	if (gGrpAdmId==""){
		alert(t['NoSelected']);
		return false;
	}

}
///取消取达/取达
function AlterStatus(){
	var newStatus=""
	if (gGrpAdmId==""){
		alert(t['NoSelected']);
		return false;
	}
	if (gGrpStatus=="ARRIVED") {newStatus="REGISTERED"}
	if (gGrpStatus=="REGISTERED") {newStatus="ARRIVED"}
	if (newStatus==""){
		alert(t['ErrNotStatus']);
		return false;
	}
	var encmeth=GetCtlValueById('AlterStatusBox',1);        
    var flag=cspRunServerMethod(encmeth,gGrpAdmId,newStatus)///////////
    if (flag!='0') {
        alert(t['ErrFailed']+"  error="+flag);
        return false
    }

    alert(t['Completed']);
    location.reload();
}

///就餐
function Dieted(){
	UpdateDitedStatus("Y")
}

///取消就餐
function CancelDieted(){
	UpdateDitedStatus("N")
}

///parameter: IsDieted="Y"/"N"
function UpdateDitedStatus(DietedStatus){
	
	if (gGrpAdmId==""){
		alert(t['NoSelected']);
		return false;
	}
	var encmeth=GetCtlValueById('DietBox',1);        
    var ret=cspRunServerMethod(encmeth,gGrpAdmId,DietedStatus)///////////
    if (ret!=""){
        alert(t['ErrFailed']+"  error="+ret);
        return false;
    }
	alert(t['Completed']);
}

///团体项目查询菜单
function ListGroupItems(){
	var lnk;
	var iParRef="";
	
	if (gGrpAdmId==""){
		alert(t['NoSelected']);
		return false;
	}
	lnk="DHCPEGRegQuery.csp"
		+"?"+"ParRef="+gGrpAdmId;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0';
	window.open(lnk,"_blank",nwin)
}