function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();
	initButtonWidth();
	initPanelHeaderStyle();		// MZY0151	2023-02-01
}
function InitEvent()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Clicked;
}

function BFind_Clicked()
{
	if (!$(this).linkbutton('options').disabled){
			$('#tDHCEQChangeAccountFind').datagrid('load',{ComponentID:getValueById("GetComponentID"),QXType:getValueById("QXType"),Equip:getValueById("Equip"),No:getValueById("No"),StartDate:$('#StartDate').datebox("getValue"),EndDate:$('#EndDate').datebox("getValue")});
		}
}
document.body.onload = BodyLoadHandler;
