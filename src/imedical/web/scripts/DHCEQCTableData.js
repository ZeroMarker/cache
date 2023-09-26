///Creator: zy 2011-07-19 ZY0074
///Description:导出列设置数据维护
var SelectedRow = 0;
var varTableDR=""; //类型id

function BodyLoadHandler() 
{
	document.body.scroll="no";	
	InitUserInfo();	
}
function SelectRowHandler()	
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCTableData');
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var lnk=""
	if (!selectrow) return;
	if (SelectedRow==selectrow)	
	{	
		SelectedRow=0;
		varTableDR=""
		lnk="websys.default.csp"
	}
	else
	{
		SelectedRow=selectrow;		
		varTableDR=GetElementValue("TRowIDz"+selectrow);
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCColumns&TableDR="+(varTableDR);
	}
	parent.DHCEQCColumns.location.href=lnk;
}
	
document.body.onload = BodyLoadHandler;