var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI改造
var rowid=0;
//add by QW 2018-10-11 hisui改造：隐藏翻页条内容
function BodyLoadHandler() 
{
	$("#tDHCEQEquipOperatorFind").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});
	// MZY0156	3377013		2023-03-24
	var Equip=document.getElementById('Equip');
	if (Equip) Equip.onkeydown = Equip_keydown;
	var Location=document.getElementById('Location');
	if (Location) Location.onkeydown = Equip_keydown;
}
///选择表格行触发此方法
///Modify By QW 2018-10-11 HISUI改造：点击选择行后，界面无法正常填充数据
///解决方法传入index,rowdata两个参数，并修改判断逻辑
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		parent.DHCEQEquipServiceFind.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipServiceFind"
		parent.DHCEQUseRecord.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQUseRecord"
		SelectedRow=-1;	
		SetElement("EquipDR","")
		$('#tDHCEQEquipOperatorFind').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	parent.DHCEQEquipServiceFind.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipServiceFind&EquipDR="+rowdata.TEquipDR
	parent.DHCEQUseRecord.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQUseRecord&SourceIDDR="+rowdata.TEquipDR
	SetElement("EquipDR",rowdata.TEquipDR)
}
// MZY0156	3377013		2023-03-24
function Equip_keydown(e)
{
    var key=websys_getKey(e);
    if (key==13)
    {
        var val="&EquipDR="+GetElementValue("EquipDR");
		val=val+"&UserDR="+GetElementValue("UserDR");
		val=val+"&Equip="+GetElementValue("Equip");
		val=val+"&QXType="+GetElementValue("QXType");
		val=val+"&Location="+GetElementValue("Location");
		//alert(val)
		window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipOperatorFind'+val;
    }
}
document.body.onload = BodyLoadHandler;
