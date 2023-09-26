function InitViewport1Event(obj)
{
	//加载类方法
	obj.ClsMFFeeItem = ExtTool.StaticServerObject("DHCWMR.MF.FeeItem");
	
	obj.LoadEvent = function (args)
	{
		obj.btnUpdate.on('click',obj.btnUpdate_click,obj);
		obj.gridFeeItem.on("rowclick",obj.gridFeeItem_rowclick,obj);
		Common_LoadCurrPage("gridFeeItem");
	}
	obj.btnUpdate_click = function()
	{
		var errinfo = ""
		var ID   = obj.FeeItemID;
		var Code = Common_GetValue("txtCode");
		var Desc = Common_GetValue("txtDesc");
		if (Code=="") errinfo = errinfo+"收费项代码为空！<br>";
		if (Desc=="") errinfo = errinfo+"收费项名称为空！<br>";
		if (errinfo!="")
		{
			ExtTool.alert("提示",errinfo);
			return;
		}
		var selectObj = obj.gridFeeItem.getSelectionModel().getSelected();	
		var strCodeLast = (selectObj != null ? selectObj.get("FICode") : "");
		var strCode = Code;
		if ((strCode != strCodeLast) && (obj.gridFeeItemStore.findExact("FICode", strCode) >-1))
		{
			ExtTool.alert("提示","代码与列表中的现有项目重复，请仔细检查!");
			return;
		}

		var InputStr = ID;
		InputStr = InputStr +　CHR_1 + Code;
		InputStr = InputStr +　CHR_1 + Desc;
		
		var flg = obj.ClsMFFeeItem.Update(InputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			return;
		}
		obj.ClearFormItem();
		Common_LoadCurrPage("gridFeeItem");
	}
	
	obj.gridFeeItem_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridFeeItem.getStore().getAt(index);
		if (objRec.get("ID") == obj.FeeItemID) {
			obj.ClearFormItem();
		} else {
			obj.FeeItemID = objRec.get("ID");
			Common_SetValue("txtCode",objRec.get("FICode"));
			Common_SetValue("txtDesc",objRec.get("FIDesc"));
		}
	}
	
	obj.ClearFormItem = function()
	{
		obj.FeeItemID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
	}
}
function DisplayLnkHISFeeItemWindow(rowIndex){
	var objRec = Ext.getCmp("gridFeeItem").store.getAt(rowIndex);
	var FeeItemID = objRec.get('ID');
	var NTWindow= new InitviewSubWindow(FeeItemID);
	NTWindow.FeeItemSubWindow.show();
}