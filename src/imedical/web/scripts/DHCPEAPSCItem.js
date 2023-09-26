//IADD 函数?增加项目
var RowID=""
var ItemType=""
var gRowIndex=0
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("ItemDesc");
	if (obj) obj.onkeydown=ItemDesc_KeyDown;
	obj=document.getElementById("OrdSetsDesc");
	if (obj) obj.onkeydown=OrdSetsDesc_KeyDown;
	obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
	SetCellColor()
	websys_setfocus("ItemDesc");
}
function BClose_click()
{
	window.close();
}
function BDelete_click()
{
	var obj;
	var encmeth=GetCtlValueById("DeleteClass");
	if (RowID=="") 
	{
		alert("请选择待删除的记录");
		return;
	}
	var Ret=cspRunServerMethod(encmeth,ItemType,RowID,"D");
	if (Ret=="0")
	{
		window.location.reload();
		return true;
	}
	alert(Ret);
	
}
function OrdSetsDesc_KeyDown(e)
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		var ComponentObj=document.getElementById("ComponentID");
		if (ComponentObj){var ComponentID=ComponentObj.value
		var obj=document.getElementById("ld"+ComponentID+"iOrdSetsDesc");
		if (obj) obj.click();}
	}
}
function ItemDesc_KeyDown(e)
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		var ComponentObj=document.getElementById("ComponentID");
		if (ComponentObj){var ComponentID=ComponentObj.value
		var obj=document.getElementById("ld"+ComponentID+"iItemDesc");
		if (obj) obj.click();}
	}
}
function SelectedItem(value){
	var aiList=value.split("^");
	if (""==value){return false}
	var ItemId=aiList[2];
	var ItemDesc=aiList[1];
	var AddAmount=aiList[3];
	SetCtlValueByID("ItemDesc",ItemDesc,1);
	if (""==ItemId) { return ;}
	IAdd("ITEM",ItemId,AddAmount);
}

function SelectedItemSet(value){
	var aiList=value.split("^");
	if (""==value){return false;}
	var ItemSetId=aiList[0];
	var ItemSetDesc=aiList[1];
	var AddAmount=aiList[3];
	SetCtlValueByID("OrdSetsDesc",ItemSetDesc,1);
	
	if (""==ItemSetId) { return ;}
	IAdd("OrdSets",ItemSetId,AddAmount);

}
function IAdd(ItemType,ID,Amount)
{
	var APRowID=GetCtlValueById("APRowID");
	var Type=GetCtlValueById("Type");
	var SCRowID=GetCtlValueById("SCRowID");
	var encmeth=GetCtlValueById("InsertClass");
	var Ret=cspRunServerMethod(encmeth,ItemType,ID,Type,APRowID,SCRowID)
	if (Ret=="0")
	{
		window.location.reload();
		return true;
	}
	alert(Ret);
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var Table=GetCtlValueById("TableName");
	var objtbl=document.getElementById('t'+Table);	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	var obj;
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	if (Row==gRowIndex)
	{
		gRowIndex=0
		RowID=""
		ItemType=""
		return;
	}
	gRowIndex=Row
	if (gRowIndex==0) return;
	ItemType=GetCtlValueById("TItemTypez"+Row);
	RowID=GetCtlValueById("TRowIDz"+Row);

}
function SetCellColor()
{
	var Table=GetCtlValueById("TableName");
	var objtbl=document.getElementById('t'+Table);
	if (objtbl) { var Rows=objtbl.rows.length; }
	for (var j=1;j<Rows+1;j++) {
		var sLable=document.getElementById('TStatusz'+j);
		var Status=sLable.innerText;
		if (Status=="删除") objtbl.rows[j].style.background="#FF88AA";
		if (Status=="已用") objtbl.rows[j].style.background="#00CC66";
	}
}
document.body.onload = BodyLoadHandler;