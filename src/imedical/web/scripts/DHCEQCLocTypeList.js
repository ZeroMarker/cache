/// -------------------------------
/// 创建:ZY  2009-07-06  BugNo.ZY0004
/// 描述:科室类型设置
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
	var objtbl=document.getElementById('tDHCEQCLocTypeList');
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
		parent.DHCEQCLocType.location.href="websys.default.csp"
		}
	else{
		SelectedRow=selectrow;		
		varLocType=GetCElementValue("TLocTypez"+selectrow);
		varID=GetElementValue("TIDz"+selectrow);
		SetData();		
		}		
}
function SetData()
{	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCLocType&LocType="+(varLocType)+"&ID="+(varID);
	parent.DHCEQCLocType.location.href=lnk;
}
	
document.body.onload = BodyLoadHandler;