
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args)
	{
		obj.cboCategoryStore.load({});
		obj.cboCategory.on("select", obj.cboCategory_onSelect, obj);
		obj.gridResult.on("rowclick",obj.gridResult_rowclick,obj);
		obj.btnDelete.on("click", obj.btnDelete_onClick, obj);
		obj.btnUpdate.on("click", obj.btnUpdate_onClick, obj);
		obj.btnFind.on("click", obj.btnFind_onClick, obj);
		
		obj.btnFind.setDisabled(true);
		obj.btnUpdate.setDisabled(true);
		obj.btnDelete.setDisabled(true);
		obj.txtSrcObjID.setDisabled(true);
		obj.txtSrcObjDesc.setDisabled(true);
		obj.txtTargetDesc.setDisabled(true);
		obj.txtTargetID.setDisabled(true);
		obj.txtResume.setDisabled(true);
	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtSrcObjID","");
		Common_SetValue("txtSrcObjDesc","");
		Common_SetValue("txtTargetDesc","","");
		Common_SetValue("txtTargetID","");
		Common_SetValue("txtResume","");
		
		obj.btnDelete.setDisabled(true);
	}
	
	obj.SetFormItem = function(objRec)
	{
		obj.RecRowID = objRec.get("ID");
		Common_SetValue("txtSrcObjID",objRec.get("SrcValID"));
		Common_SetValue("txtSrcObjDesc",objRec.get("SrcValDesc"));
		if (obj.TypeCode != '') {
			obj.txtTargetID.setDisabled(true);
			Common_SetValue("txtTargetID",objRec.get("Target"));
			Common_SetValue("txtTargetDesc",objRec.get("Target"),objRec.get("TargetDesc"));
		} else {
			obj.txtTargetID.setDisabled(false);
			Common_SetValue("txtTargetID",objRec.get("Target"));
			Common_SetValue("txtTargetDesc",objRec.get("TargetDesc"));
		}
		Common_SetValue("txtResume",objRec.get("Resume"));
		
		obj.btnDelete.setDisabled(false);
	}
	
	obj.cboCategory_onSelect = function()
	{
		var SelectIndex = obj.cboCategoryStore.find("DicCode", obj.cboCategory.getValue());
		if (SelectIndex < 0) {
			obj.btnFind.setDisabled(true);
			obj.btnUpdate.setDisabled(true);
			obj.btnDelete.setDisabled(true);
			obj.txtSrcObjID.setDisabled(true);
			obj.txtSrcObjDesc.setDisabled(true);
			obj.cboTargetDesc.setDisabled(true);
			obj.txtTargetID.setDisabled(true);
			obj.txtResume.setDisabled(true);
			obj.gridResultStore.removeAll();
			return;
		} else {
			var objRec = obj.cboCategoryStore.getAt(SelectIndex);
			var objDic = ExtTool.RunServerMethod("DHCWMR.SS.Dictionary", "GetObjById", objRec.get("ID"));
			if (objDic) {
				obj.GroupCode =  objDic.StrA;
				obj.TypeCode =  objDic.StrB;
				var CategoryID=objRec.get("ID");
			} else {
				obj.GroupCode =  '';
				obj.TypeCode =  '';
				var CategoryID="";
			}
			
			obj.btnFind.setDisabled(false);
			obj.btnUpdate.setDisabled(false);
			obj.btnDelete.setDisabled(true);
			obj.txtSrcObjID.setDisabled(false);
			obj.txtSrcObjDesc.setDisabled(false);
			obj.txtTargetDesc.setDisabled(false);
			obj.txtResume.setDisabled(false);
			if (obj.TypeCode != '') {
				obj.txtTargetID.setDisabled(true);
			} else {
				obj.txtTargetID.setDisabled(false);
			}
			
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
					var flg = ExtTool.RunServerMethod("DHCWMR.SS.DicMapping", "DeleteById", obj.RecRowID);
					if (parseInt(flg) <= 0) {
						ExtTool.alert("提示","删除记录错误!Error=" + flg);
						return;
					} else {
						Common_LoadCurrPage('gridResult');
						obj.ClearFormItem();
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
		var SrcValID = Common_GetValue("txtSrcObjID");
		var SrcValDesc = Common_GetValue("txtSrcObjDesc");
		if (obj.TypeCode != '') {
			var TargetID = obj.cboTargetDesc.getValue();
		} else {
			var TargetID = Common_GetValue("txtTargetID");
		}
		var TargetDesc = obj.txtTargetDesc.getValue();
		var Resume = Common_GetValue("txtResume");
		
		if (!CategValue) {
			errinfo = errinfo + "字典类别为空!<br>";
		}
		if (!SrcValID) {
			errinfo = errinfo + "源值为空!<br>";
		}
		if (!TargetID) {
			//errinfo = errinfo + "目标值为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var strArg = obj.RecRowID;
		strArg += "^" + CategValue;
		strArg += "^" + SrcValID;
		strArg += "^" + SrcValDesc;
		strArg += "^" + TargetID;
		strArg += "^" + TargetDesc;
		strArg += "^" + Resume;
		
		var ret = ExtTool.RunServerMethod("DHCWMR.SS.DicMapping", "Update", strArg, "^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("提示","更新记录错误!Error=" + ret);
			return;
		} else {
			//更新当前记录
			var MapID = parseInt(ret);
			var SelectIndex = obj.gridResultStore.find("ID",MapID);
			if (SelectIndex > -1) {
				var objRec = obj.gridResultStore.getAt(SelectIndex);
				objRec.set("ID",ret);
				objRec.set("Category",CategValue);
				objRec.set("SrcValID",SrcValID);
				objRec.set("SrcValDesc",SrcValDesc);
				objRec.set("Target",TargetID);
				objRec.set("TargetDesc",TargetDesc);
				objRec.set("Resume",Resume);
				objRec.commit();
			} else {
				Common_LoadCurrPage('gridResult');
			}
			obj.ClearFormItem();
			Common_LoadCurrPage('gridResult');
		}
	}
	
	obj.btnFind_onClick = function()
	{
		obj.gridResultStore.removeAll();
		Common_LoadCurrPage('gridResult');
		obj.ClearFormItem();
	}
}

