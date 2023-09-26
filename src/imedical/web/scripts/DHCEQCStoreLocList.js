/// -------------------------------
/// 创建:ZY  2010-07-26  BugNo.ZY0025
/// 描述:库房明细
/// --------------------------------
var SelectedRow = 0;
var varLocType=""; //类型名
var varID=""; //类型id

function BodyLoadHandler()
{
	document.body.scroll="no";	
	InitUserInfo();	
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCStoreLocList');
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	Selected(selectrow);
}
function Selected(selectrow)
{	
	if (SelectedRow==selectrow)	{	
		SelectedRow=0;
		varLocType="";
		varID=""
		parent.DHCEQCStoreManageLoc.location.href="websys.default.csp"
		}
	else{
		SelectedRow=selectrow;
		varID=GetElementValue("TStoreLocDRz"+selectrow);
		SetData();		
		}
}
function SetData()
{	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCStoreManageLoc&ID="+(varID);
	parent.DHCEQCStoreManageLoc.location.href=lnk;
}
	
document.body.onload = BodyLoadHandler;