
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args)
	{
		obj.cboCategoryStore.load({});
		obj.cboCategory.on("select", obj.cboCategory_onSelect, obj);
		obj.gridResult.on("rowclick",obj.gridResult_rowclick,obj);
		obj.btnDelete.on("click", obj.btnDelete_onClick, obj);
		obj.btnUpdate.on("click", obj.btnUpdate_onClick, obj);
		
		obj.btnUpdate.setDisabled(true);
		obj.btnDelete.setDisabled(true);
		obj.txtWord.setDisabled(true);
		obj.txtText1.setDisabled(true);
		obj.txtText2.setDisabled(true);
		obj.cbgActType.setDisabled(true);
		obj.chkIsActive.setDisabled(true);
		obj.txtResume.setDisabled(true);
		
		Common_SetValue("cbgActType",'','包含');
		Common_SetValue("chkIsActive",true);
	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtWord","");
		Common_SetValue("txtText1","");
		Common_SetValue("txtText2","");
		//Common_SetValue("cbgActType","");
		//Common_SetValue("chkIsActive","");
		Common_SetValue("txtResume","");
		
		obj.btnDelete.setDisabled(true);
	}
	
	obj.SetFormItem = function(objRec)
	{
		obj.RecRowID = objRec.get("ID");
		Common_SetValue("txtWord",objRec.get("Words"));
		Common_SetValue("txtText1",objRec.get("Text1"));
		Common_SetValue("txtText2",objRec.get("Text2"));
		Common_SetValue("cbgActType",objRec.get("ActType"),objRec.get("ActTypeDesc"));
		if (objRec.get("IsActive") == '1') {
			var IsActive = true;
		} else {
			var IsActive = false;
		}
		Common_SetValue("chkIsActive",IsActive);
		Common_SetValue("txtResume",objRec.get("ResumeText"));
		
		obj.btnDelete.setDisabled(false);
	}
	
	obj.cboCategory_onSelect = function()
	{
		var SelectIndex = obj.cboCategoryStore.find("Code", obj.cboCategory.getValue());
		if (SelectIndex < 0) {
			obj.btnUpdate.setDisabled(true);
			obj.btnDelete.setDisabled(true);
			obj.txtWord.setDisabled(true);
			obj.txtText1.setDisabled(true);
			obj.txtText2.setDisabled(true);
			obj.cbgActType.setDisabled(true);
			obj.chkIsActive.setDisabled(true);
			obj.txtResume.setDisabled(true);
			obj.gridResultStore.removeAll();
			return;
		} else {
			obj.btnUpdate.setDisabled(false);
			obj.btnDelete.setDisabled(true);
			obj.txtWord.setDisabled(false);
			obj.txtText1.setDisabled(false);
			obj.txtText2.setDisabled(false);
			obj.cbgActType.setDisabled(false);
			obj.chkIsActive.setDisabled(false);
			obj.txtResume.setDisabled(false);
			
			obj.gridResultStore.removeAll();
			obj.ClearFormItem();
			Common_LoadCurrPage('gridResult');
		}
	}
	
	obj.gridResult_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridResult.getStore().getAt(index);
		if (objRec.get("ID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.SetFormItem(objRec);
		}
	};
	
	obj.btnDelete_onClick = function()
	{
		if (obj.RecRowID)
		{
			Ext.MessageBox.confirm('提示', '是否删除当前记录？', function(btn,text){
				if (btn == 'yes') {
					var flg = ExtTool.RunServerMethod("DHCMed.DP.Base.ActWards", "DeleteById", obj.RecRowID);
					if (parseInt(flg) <= 0) {
						ExtTool.alert("提示","删除记录错误!Error=" + flg);
						return;
					} else {
						obj.ClearFormItem();
						Common_LoadCurrPage('gridResult');
					}
				}
			});
		} else {
			ExtTool.alert("提示","请选择要删除的记录!");
			return;
		}
	}
	
	obj.btnUpdate_onClick = function()
	{
		var errinfo = "";
		var CategValue = obj.cboCategory.getValue();
		if (!CategValue) return;
		
		var Words = Common_GetValue("txtWord");
		var Text1 = Common_GetValue("txtText1");
		var Text2 = Common_GetValue("txtText2");
		var ActType = Common_GetValue("cbgActType");
		var IsActive = Common_GetValue("chkIsActive");
		if (IsActive==true) {
			IsActive = 1;
		} else {
			IsActive = 0;
		}
		
		var Resume = Common_GetValue("txtResume");
		
		if (!CategValue) {
			errinfo = errinfo + "常用短语类别为空!<br>";
		}
		if (!Words) {
			errinfo = errinfo + "常用短语为空!<br>";
		}
		if (!ActType) {
			errinfo = errinfo + "常用短语属性为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var strArg = obj.RecRowID;
		strArg += "^" + CategValue;
		strArg += "^" + Words;
		strArg += "^" + ActType;
		strArg += "^" + Text1;
		strArg += "^" + Text2;
		strArg += "^" + '';
		strArg += "^" + '';
		strArg += "^" + IsActive;
		strArg += "^" + Resume;
		
		var ret = ExtTool.RunServerMethod("DHCMed.DPService.Base.ActWards", "Update", strArg, "^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("提示","更新记录错误!Error=" + ret);
			return;
		} else {
			obj.gridResultStore.removeAll();
			obj.ClearFormItem();
			Common_LoadCurrPage('gridResult');
		}
	}
}

