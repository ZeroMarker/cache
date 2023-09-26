// dhcmed.fbd.signdic.csp
function InitViewport1Event(obj) {
	
	obj.currGridRowId = "";
	obj.clsSignDic = ExtTool.StaticServerObject("DHCMed.FBD.SignDic");
	
	obj.LoadEvent = function() {
		obj.cboExtraTypeStore.load({});
		obj.gridSignDicStore.load({});
		obj.gridSignDic.on('rowclick', obj.gridSignDic_rowclick, obj);
		obj.btnSave.on('click', obj.btnSave_click, obj);
	}
	
	obj.gridSignDic_rowclick = function() {
		var objRec = obj.gridSignDic.getSelectionModel().getSelected();
		if (obj.currGridRowId && obj.currGridRowId==objRec.get("ID")) {
			obj.clearFormData();
		} else {
			obj.showFormData(objRec);
		}
	}
	
	obj.clearFormData = function() {
		obj.currGridRowId = "";
		obj.txtCode.setValue("");
		obj.txtDesc.setValue("");
		obj.txtExtraUnit.setValue("");
		obj.txtResume.setValue("");
		obj.chkIsActive.setValue(true);
		obj.cboExtraType.clearValue();
		obj.cboExtraTypeStore.load({});
	}
	
	obj.showFormData = function(objRow) {
		obj.currGridRowId = objRow.get("ID");
		obj.txtCode.setValue(objRow.get("Code"));
		obj.txtDesc.setValue(objRow.get("Desc"));
		obj.txtExtraUnit.setValue(objRow.get("ExtraUnit"));
		obj.txtResume.setValue(objRow.get("Resume"));
		obj.chkIsActive.setValue(objRow.get("IsActive"));
		obj.cboExtraTypeStore.load({
			callback : function() {
				obj.cboExtraType.setValue(objRow.get("ExtraTypeID"));
			}
		});
	}
	
	obj.btnSave_click = function() {
		var inputStr = "", errorStr = "", separete = "^";
		var ID = "", SDCode = "", SDDesc = "", SDExtraType = "", SDExtraUnit = "", SDIsActive = "", SDResume = "";
		if (obj.currGridRowId) { ID = obj.currGridRowId; }
		SDCode = obj.txtCode.getValue();
		SDDesc = obj.txtDesc.getValue();
		SDExtraType = obj.cboExtraType.getValue();
		SDExtraUnit = obj.txtExtraUnit.getValue();
		SDIsActive = +obj.chkIsActive.getValue();
		SDResume = obj.txtResume.getValue();
		if (SDCode=="") { errorStr = errorStr + "代码不能为空!" }
		if (SDDesc=="") { errorStr = errorStr + "描述不能为空!" }
		var flgCode = obj.clsSignDic.CheckCode(SDCode);
		if (flgCode>0 && ID=="") { errorStr = errorStr + "代码重复!"; }
		if (errorStr!="") { ExtTool.alert("提示", errorStr); return; }
		inputStr = ID + separete;
		inputStr = inputStr + SDCode + separete;
		inputStr = inputStr + SDDesc + separete;
		inputStr = inputStr + SDExtraType + separete;
		inputStr = inputStr + SDExtraUnit + separete;
		inputStr = inputStr + SDIsActive + separete;
		inputStr = inputStr + SDResume;
		try {
			var ret = obj.clsSignDic.Update(inputStr, separete);
			if (ret<=0) {
				ExtTool.alert("提示", "保存失败!");
				return;
			} else {
				obj.gridSignDicStore.load({});
				obj.clearFormData();
			}
		} catch(err) {
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
		return;
	}
	
}