// dhcmed.main.disease.csp
function InitViewport1Event(obj) {
	
	obj.LoadEvent = function() {
		obj.gridDiseaseStore.load({});
		obj.cboProductStore.load({});
		obj.cboCategStore.load({});
		obj.gridDisease.on('rowclick', obj.gridDisease_rowclick, obj);
		obj.btnSaveDisease.on('click', obj.btnSaveDisease_click, obj);
		obj.btnSaveICD.on('click', obj.btnSaveICD_click, obj);
		obj.btnSaveAlias.on('click', obj.btnSaveAlias_click, obj);
		obj.initCboProduct();
	}
	
	obj.CurrGridRowId = "";
	obj.clsDisease = ExtTool.StaticServerObject("DHCMed.SS.Disease");
	
	obj.initCboProduct = function() {
		if (ProductCode=="") { return; }
		var ProductId = obj.clsProducts.GetIDByCode(ProductCode);
		obj.cboProductStore.load({
			callback : function() {
				obj.cboProduct.setValue(ProductId);
			}
		});
		obj.cboProduct.setDisabled("false");
	}
	
	obj.gridDisease_rowclick = function() {
		var objRec = obj.gridDisease.getSelectionModel().getSelected();
		if (obj.CurrGridRowId && obj.CurrGridRowId==objRec.get("ID")) {
			obj.clearFormData();
		} else {
			obj.showFormData(objRec);
		}
	}
	
	obj.clearFormData = function() {
		obj.CurrGridRowId = "";
		obj.txtDiseaseCode.setValue("");
		obj.txtDiseaseDesc.setValue("");
		obj.txtDiseaseICD.setValue("");
		obj.txtDiseaseResume.setValue("");
		obj.chkIsActive.setValue(true);
		if (ProductCode=="") { obj.cboProduct.clearValue(); }
		obj.cboCateg.clearValue();
		obj.cboProductStore.load({});
		obj.cboCategStore.load({});
	}
	
	obj.showFormData = function(objRow) {
		obj.CurrGridRowId = objRow.get("ID");
		obj.txtDiseaseCode.setValue(objRow.get("IDCode"));
		obj.txtDiseaseDesc.setValue(objRow.get("IDDesc"));
		obj.txtDiseaseICD.setValue(objRow.get("ICD10"));
		obj.txtDiseaseResume.setValue(objRow.get("Resume"));
		obj.chkIsActive.setValue(objRow.get("IsActive"));
		obj.cboProductStore.load({
			callback : function() {
				obj.cboProduct.setValue(objRow.get("ProID"));
				obj.cboCategStore.load({
					callback : function() {
						obj.cboCateg.setValue(objRow.get("CateID"));
					}
				});
			}
		});
	}
	
	obj.btnSaveDisease_click = function() {
		var inputStr = "", errorStr = "", separete = "^";
		var DiseaseId = "", DiseaseCode = "", DiseaseDesc = "", DiseaseICD = "", CateId = "", ProductId = "", IsActive = "", Resume = "";
		if (obj.CurrGridRowId) { DiseaseId = obj.CurrGridRowId; }
		DiseaseCode = obj.txtDiseaseCode.getValue();
		DiseaseDesc = obj.txtDiseaseDesc.getValue();
		DiseaseICD = obj.txtDiseaseICD.getValue();
		ProductId = obj.cboProduct.getValue();
		CateId = obj.cboCateg.getValue();
		IsActive = +obj.chkIsActive.getValue();
		Resume = obj.txtDiseaseResume.getValue();
		if (DiseaseCode=="") { errorStr = errorStr + "疾病代码不能为空!"; }
		if (DiseaseDesc=="") { errorStr = errorStr + "疾病描述不能为空!"; }
		if (ProductId=="") { errorStr = errorStr + "请选择产品!"; }
		if (CateId=="") { errorStr = errorStr + "请选择分类!"; }
		if (errorStr) { ExtTool.alert("提示", errorStr); return; }
		//var chkCode = obj.clsDisease.CheckDiseaseCode(DiseaseCode);
		//if (chkCode>0 && DiseaseId=="") { ExtTool.alert("提示", "代码重复!"); return; }
		inputStr = DiseaseId + separete;
		inputStr = inputStr + DiseaseCode + separete;
		inputStr = inputStr + DiseaseDesc + separete;
		inputStr = inputStr + DiseaseICD + separete;
		inputStr = inputStr + CateId + separete;
		inputStr = inputStr + ProductId + separete;
		inputStr = inputStr + IsActive + separete;
		inputStr = inputStr + Resume;
		try {
			var ret = obj.clsDisease.Update(inputStr, separete);
			if (ret<=0) {
				ExtTool.alert("提示", "保存失败!");
				return;
			} else {
				obj.gridDiseaseStore.load({});
				obj.clearFormData();
				ExtTool.alert("提示", "保存成功!");
				return;
			}
		} catch(err) {
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	}
	
	obj.btnSaveICD_click = function() {
		var selectObj = obj.gridDisease.getSelectionModel().getSelected();
		if (selectObj && (obj.CurrGridRowId!="")) {
			var objWinICD = new InitWinICD(selectObj);
			objWinICD.WinICD.show();
		} else {
			ExtTool.alert("提示", "请选中一行");
		}
	}
	
	obj.btnSaveAlias_click = function() {
		var selectObj = obj.gridDisease.getSelectionModel().getSelected();
		if (selectObj && (obj.CurrGridRowId!="")) {
			var objWinAlias = new InitWinAlias(selectObj);
			objWinAlias.WinAlias.show();
		} else {
			ExtTool.alert("提示", "请选中一行");
		}
	}
	
}

function InitWinICDEvent(obj) {
	
	obj.selDiseaseId = "";
	obj.clsDiseaseICD = ExtTool.StaticServerObject("DHCMed.SS.DiseaseICD");
	
	obj.LoadEvent = function() {
		obj.selDiseaseId = obj.selectObj.get("ID");
		obj.gridICDStore.load({});
		obj.btnUpdateICD.on('click', obj.btnUpdateICD_click, obj);
		obj.btnCancelICD.on('click', obj.btnCancelICD_click, obj);
		obj.btnAddICD.on('click', obj.btnAddICD_click, obj);
		obj.btnDeleteICD.on('click', obj.btnDeleteICD_click, obj);
	}
	
	obj.btnUpdateICD_click = function() {
		var objRec = "", inputStr = "", errorStr = "", separete = "^";
		for (var i = 0; i < obj.gridICDStore.getCount(); i++) {
			objRec = obj.gridICDStore.getAt(i);
			if (!objRec.dirty) { continue; }
			if (objRec.get("IDICD10")=="") {
				ExtTool.alert("提示", "第" + (i + 1) + "行数据未填写ICD10!");
				return;
			}
			if (objRec.get("IDICDDesc")=="") {
				ExtTool.alert("提示", "第" + (i + 1) + "行数据未填写疾病名称!");
				return;
			}
			var tmpArrID = objRec.get("ID").split("||");
			inputStr = tmpArrID[0] + separete;
			inputStr = inputStr + tmpArrID[1] + separete;
			inputStr = inputStr + objRec.get("IDICD10") + separete;
			inputStr = inputStr + objRec.get("IDICDDesc") + separete;
			inputStr = inputStr + objRec.get("IDExWords");
			var ret = obj.clsDiseaseICD.Update(inputStr, separete);
			if (+ret<=0) { errorStr = errorStr + (i+1) + ","; }
		}
		obj.gridICDStore.load({});
		if (errorStr) {
			errorStr = errorStr.substring(0, errorStr.length-1);
			ExtTool.alert("提示", "第" + errorStr + "行保存失败!");
		} else {
			ExtTool.alert("提示", "保存成功!");
		}
	}
	
	obj.btnCancelICD_click = function() {
		obj.WinICD.close();
	}
	
	obj.btnAddICD_click = function() {
		var objRec = new Ext.data.Record({
			ID : obj.selDiseaseId + "||"
			,IDICD10 : ""
			,IDICDDesc : ""
			,IDExWords : ""
		});
		obj.gridICDStore.add([objRec]);
	}
	
	obj.btnDeleteICD_click = function() {
		var objRec = ExtTool.GetGridSelectedData(obj.gridICD);
		if (objRec==null) { return; }
		ExtTool.confirm('选择框', '确定删除此记录', function(btn) {
			if (btn=="no") { return; }
			var tmpICDId = objRec.get("ID");
			if (tmpICDId.split("||")[1]!="") { obj.clsDiseaseICD.DeleteById(tmpICDId); }
			obj.gridICDStore.load({});
		});
	}
	
}

function InitWinAliasEvent(obj) {
	
	obj.selDiseaseId = "";
	obj.clsDiseaseAlias = ExtTool.StaticServerObject("DHCMed.SS.DiseaseAlias");
	
	obj.LoadEvent = function() {
		obj.selDiseaseId = obj.selectObj.get("ID");
		obj.gridAliasStore.load({});
		obj.btnUpdateAlias.on('click', obj.btnUpdateAlias_click, obj);
		obj.btnCancelAlias.on('click', obj.btnCancelAlias_click, obj);
		obj.btnAddAlias.on('click', obj.btnAddAlias_click, obj);
		obj.btnDeleteAlias.on('click', obj.btnDeleteAlias_click, obj);
	}
	
	obj.btnUpdateAlias_click = function() {
		var objRec = "", inputStr = "", errorStr = "", separete = "^";
		for (var i = 0; i < obj.gridAliasStore.getCount(); i++) {
			objRec = obj.gridAliasStore.getAt(i);
			if (!objRec.dirty) { continue; }
			if (objRec.get("IDAlias")=="") {
				ExtTool.alert("提示", "第" + (i + 1) + "行别名未填写!");
				return;
			}
			var tmpArrID = objRec.get("ID").split("||");
			inputStr = tmpArrID[0] + separete;
			inputStr = inputStr + tmpArrID[1] + separete;
			inputStr = inputStr + objRec.get("IDAlias");
			var ret = obj.clsDiseaseAlias.Update(inputStr, separete);
			if (+ret<=0) { errorStr = errorStr + (i+1) + ","; }
		}
		obj.gridAliasStore.load({});
		if (errorStr) {
			errorStr = errorStr.substring(0, errorStr.length-1);
			ExtTool.alert("提示", "第" + errorStr + "行保存失败!");
		} else {
			ExtTool.alert("提示", "保存成功!");
		}
	}
	
	obj.btnCancelAlias_click = function() {
		obj.WinAlias.close();
	}
	
	obj.btnAddAlias_click = function() {
		var objRec = new Ext.data.Record({
			ID : obj.selDiseaseId + "||"
			,IDAlias : ""
		});
		obj.gridAliasStore.add([objRec]);
	}
	
	obj.btnDeleteAlias_click = function() {
		var objRec = ExtTool.GetGridSelectedData(obj.gridAlias);
		if (objRec==null) { 
			ExtTool.alert('提示', '请选择一条数据')
			return; 
			}
		ExtTool.confirm('选择框', '确定删除此记录', function(btn) {
			if (btn=="no") { return; }
			var tmpAliasId = objRec.get("ID");
			if (tmpAliasId.split("||")[1]!="") { obj.clsDiseaseAlias.DeleteById(tmpAliasId); }
			obj.gridAliasStore.load({});
		});
	}
	
}