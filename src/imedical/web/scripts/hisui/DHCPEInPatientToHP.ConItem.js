
//名称	DHCPEInPatientToHP.ConItem.js
//功能  设置住院体检职称对应的会诊医嘱
//组件	DHCPEInPatientToHP.ConItem
//创建	2018.08.15
//创建人  xy


function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BSaveDefaultItem");
	if (obj){ obj.onclick=BSaveDefaultItem_click; }
	
	obj=document.getElementById("BSaveItem");
	if (obj){ obj.onclick=BSaveItem_click; }

	obj=document.getElementById("DefaultItemDesc");
	if (obj){ obj.onchange=DefaultItemDesc_change; }
	
	obj=document.getElementById("ItemDesc");
	if (obj){obj.onchange=ItemDesc_click;}
}
function BSaveDefaultItem_click()
{
	var obj,LocID="",DefaultItemID="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	obj=document.getElementById("DefaultItemID");
	if (obj) DefaultItemID=obj.value;
	obj=document.getElementById("DefaultItemClass");
	if (obj) encmeth=obj.value;
	var Ret=cspRunServerMethod(encmeth,LocID,DefaultItemID);
	
}
function BSaveItem_click()
{
	var obj,CarPrvTpID="",LocID="",ItemID="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	obj=document.getElementById("CarPrvTpID");
	if (obj) CarPrvTpID=obj.value;
	if (CarPrvTpID==""){
		$.messager.alert("提示","请选择职称，然后保存数据");
		//alert("请选择职称，然后保存数据");
		return false;
	}
	obj=document.getElementById("ItemID");
	if (obj) ItemID=obj.value;
	obj=document.getElementById("ItemClass");
	if (obj) encmeth=obj.value;
	var Ret=cspRunServerMethod(encmeth,CarPrvTpID,LocID,ItemID);
	window.location.reload();
}
function DefaultItemDesc_change()
{
	var obj=document.getElementById("DefaultItemID");
	if (obj) obj.value="";
}
function ItemDesc_click()
{
	var obj=document.getElementById("ItemID");
	if (obj) obj.value="";
}
function AfterDefaultItemDesc(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("DefaultItemDesc");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("DefaultItemID");
	if (obj) obj.value=Arr[2];
}
function AfterItemDesc(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("ItemDesc");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("ItemID");
	if (obj) obj.value=Arr[2];
}


var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if(index==selectrow)
	{
		var iCarPrvTpID=rowdata.TCarPrvTpID;
		var iCarPrvTpDesc=rowdata.TCarPrvTpDesc;
		var iItemID=rowdata.TItemID;
		var iItemDesc=rowdata.TItemDesc;
		
	    setValueById("CarPrvTpID",iCarPrvTpID)
	    setValueById("CarPrvTpDesc",iCarPrvTpDesc)
	    setValueById("ItemID",iItemID)
	    setValueById("ItemDesc",iItemDesc)
		
	}else
	{
		selectrow=-1;
		
	
	}


}



document.body.onload = BodyLoadHandler;

