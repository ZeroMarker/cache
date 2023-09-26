//DHCMedPVMCommonB.js

///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCMedPVMCommonB');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	var docid="NewPVMRowidz"+selectrow;
    var obj=document.getElementById(docid);
    var tmpRowid=obj.value;
    //parent.parent.frames[1].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCMedPVMCommonC&PVMRepRowid='+tmpRowid;
    parent.parent.frames[1].location.href='dhcmedpvmcommonr.csp?PVMRepRowid='+tmpRowid;
    //var TEquipDR=GetElementValue("TEquipDRz"+SelectedRow)dhcmedpvmcommonr.csp
    //parent.frames["DHCEQDepreSet"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSet&RowID='+rowid;
    return;
    //var lnk='DHCEQDepreSet.csp?EquipDR='+TEquipDR+'&TRowID='+rowid;
    //window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}