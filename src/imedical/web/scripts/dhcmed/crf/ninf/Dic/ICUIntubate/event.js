
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args)
	{
		obj.cboCategoryStore.load({});
		obj.cboCategory.on("select", obj.cboCategory_onSelect, obj);
		obj.gridResult.on("rowclick",obj.gridResult_rowclick,obj);
		obj.btnDelete.on("click", obj.btnDelete_onClick, obj);
		obj.btnUpdate.on("click", obj.btnUpdate_onClick, obj);
		obj.btnFind.on("click", obj.btnFind_onClick, obj);
		obj.txtArcimAlias.on("specialKey", obj.txtArcimAlias_onSpecialKey, obj);
		obj.gridArcimList.on("rowdblclick",obj.gridArcimList_rowdblclick,obj);
		
		obj.btnUpdate.setDisabled(true);
		obj.btnDelete.setDisabled(true);
		obj.txtObjectID.setDisabled(true);
		obj.txtObjectDesc.setDisabled(true);
		obj.txtTarget02.setDisabled(true);
		obj.txtTarget01.setDisabled(true);
		obj.txtResume.setDisabled(true);
	};
	
	obj.gridArcimList_rowdblclick = function()
	{
		var errinfo = "";
		var CategValue = obj.cboCategory.getValue();
		if (!CategValue) {
			errinfo = errinfo + " 医嘱类别为空!<br>";
			return;
		}
		
		var index=arguments[1];
		var objRec = obj.gridArcimList.getStore().getAt(index);
		var ObjectID = objRec.get("ArcimID");
		var ObjectDesc = objRec.get("ArcimDesc");
		var Target01 = Common_GetValue("txtTarget01"); //Modified By LiYang 2014-11-05
		var Target02 = Common_GetValue("txtTarget02"); //Modified By LiYang 2014-11-05
		var Resume = "";
		
		var recIndex = obj.gridResultStore.find("ObjectID",ObjectID);
		if (recIndex > -1){
			ExtTool.alert("提示","重复添加!");
			return;
		}
		
		var strArg = "";
		strArg += "^" + CategValue;
		strArg += "^" + ObjectID;
		strArg += "^" + ObjectDesc;
		strArg += "^" + Target01;
		strArg += "^" + Target02;
		strArg += "^" + Resume;
		var ret = ExtTool.RunServerMethod("DHCMed.NINF.Dic.ICUIntubate", "Update", strArg, "^");
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
				objRec.set("ObjectID",ObjectID);
				objRec.set("ObjectDesc",ObjectDesc);
				objRec.set("Target01",Target01);
				objRec.set("Target02",Target02);
				objRec.set("ResumeText",Resume);
				objRec.commit();
				obj.ClearFormItem();
			} else {
				obj.ClearFormItem();
				Common_LoadCurrPage('gridResult');
			}
		}
	}
	
	obj.txtArcimAlias_onSpecialKey = function(field, e)
	{
		if (e.getKey() == Ext.EventObject.ENTER) {
			obj.btnFind_onClick();
		}
	}
	
	obj.btnFind_onClick = function()
	{
		obj.gridArcimListStore.removeAll();
		if ("" == obj.txtArcimAlias.getValue()){
			ExtTool.alert("提示","请输入医嘱别名!");
			return;
		} else {
			obj.gridArcimListStore.load({});
		}
	}
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtObjectID","");
		Common_SetValue("txtObjectDesc","");
		Common_SetValue("txtTarget01","");
		Common_SetValue("txtTarget02","");
		Common_SetValue("txtResume","");
		
		obj.btnDelete.setDisabled(true);
	}
	
	obj.SetFormItem = function(objRec)
	{
		obj.RecRowID = objRec.get("ID");
		Common_SetValue("txtObjectID",objRec.get("ObjectID"));
		Common_SetValue("txtObjectDesc",objRec.get("ObjectDesc"));
		Common_SetValue("txtTarget01",objRec.get("Target01"));
		Common_SetValue("txtTarget02",objRec.get("Target02"));
		Common_SetValue("txtResume",objRec.get("ResumeText"));
		
		obj.btnDelete.setDisabled(false);
	}
	
	obj.cboCategory_onSelect = function()
	{
		var SelectIndex = obj.cboCategoryStore.find("Code", obj.cboCategory.getValue());
		if (SelectIndex < 0) {
			obj.btnUpdate.setDisabled(true);
			obj.btnDelete.setDisabled(true);
			obj.txtObjectID.setDisabled(true);
			obj.txtObjectDesc.setDisabled(true);
			obj.txtTarget01.setDisabled(true);
			obj.txtTarget02.setDisabled(true);
			obj.txtResume.setDisabled(true);
			obj.gridResultStore.removeAll();
			return;
		} else {
			obj.btnUpdate.setDisabled(false);
			obj.btnDelete.setDisabled(true);
			obj.txtObjectID.setDisabled(false);
			obj.txtObjectDesc.setDisabled(false);
			obj.txtTarget01.setDisabled(false);
			obj.txtTarget02.setDisabled(false);
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
					var flg = ExtTool.RunServerMethod("DHCMed.NINF.Dic.ICUIntubate", "DeleteById", obj.RecRowID);
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
		var ObjectID = Common_GetValue("txtObjectID");
		var ObjectDesc = Common_GetValue("txtObjectDesc");
		var Target01 = Common_GetValue("txtTarget01");
		var Target02 = Common_GetValue("txtTarget02");
		var Resume = Common_GetValue("txtResume");
		
		if (!CategValue) {
			errinfo = errinfo + " 医嘱类别为空!<br>";
		}
		if (!ObjectID) {
			errinfo = errinfo + "项目为空!<br>";
		}
		if (!ObjectDesc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var recIndex = obj.gridResultStore.find("ObjectID",ObjectID);
		if ((recIndex > -1) && ((obj.RecRowID == "" ) || (obj.RecRowID == null))){ //Modified By LiYang 2014-11-05 FixBug:3920 医院感染管理-全院综合性监测-基础数据维护-系统字典维护-系统字典-ICU三管医嘱-修改除项目外的其他信息,点击【更新】，提示"重复添加"
			ExtTool.alert("提示","重复添加!");
			return;
		}
		
		var strArg = obj.RecRowID;
		strArg += "^" + CategValue;
		strArg += "^" + ObjectID;
		strArg += "^" + ObjectDesc;
		strArg += "^" + Target01;
		strArg += "^" + Target02;
		strArg += "^" + Resume;
		var ret = ExtTool.RunServerMethod("DHCMed.NINF.Dic.ICUIntubate", "Update", strArg, "^");
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
				objRec.set("ObjectID",ObjectID);
				objRec.set("ObjectDesc",ObjectDesc);
				objRec.set("Target01",Target01);
				objRec.set("Target02",Target02);
				objRec.set("ResumeText",Resume);
				objRec.commit();
				obj.ClearFormItem();
			} else {
				obj.ClearFormItem();
				Common_LoadCurrPage('gridResult');
			}
		}
	}
}

