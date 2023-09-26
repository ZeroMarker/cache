
function InitwinProblemEvent(obj) {
	obj.LoadEvent = function(args){
		obj.objParent = args[2];
		obj.btnSave.on("click", obj.btnSave_onClick, obj);
		obj.btnCancel.on("click", obj.btnCancel_onclick, obj);
		obj.btnSkip.on("click", obj.btnSkip_onclick, obj);
		
		obj.cboTargetDesc.on("select", obj.cboTargetDesc_onSelect, obj);
		obj.gridProblem.on("rowclick",obj.gridProblem_rowclick,obj);
		obj.btnUpdate.on("click", obj.btnUpdate_onClick, obj);
		
		obj.ClearFormItem();
		obj.gridProblemStore.load({
			callback : function(){
				if (obj.gridProblemStore.getCount() > 0) {
					obj.btnSave.setDisabled(true);
				} else {
					obj.btnSave.setDisabled(false);
				}
			}
		});
	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		obj.MappingTypeCode = '';
		obj.MapDicGroupCode = '';
		obj.MapDicTypeCode = '';
		obj.txtSrcValue.setValue('');
		obj.txtSrcDesc.setValue('');
		obj.cboTargetDesc.setValue('');
		obj.cboTargetDesc.setRawValue('');
		obj.txtTargetValue.setValue('');
		obj.txtResume.setValue('');
		
		obj.txtSrcValue.setDisabled(true);
		obj.txtSrcDesc.setDisabled(true);
		obj.cboTargetDesc.setDisabled(true);
		obj.txtTargetValue.setDisabled(true);
		obj.txtResume.setDisabled(true);
		obj.btnUpdate.setDisabled(true);
	}
	
	obj.SetFormItem = function(objRec)
	{
		obj.RecRowID = objRec.get("ID");
		obj.MappingTypeCode = objRec.get("MappingTypeCode");
		obj.MapDicGroupCode = objRec.get("MapDicGroupCode");
		obj.MapDicTypeCode = objRec.get("MapDicTypeCode");
		obj.txtSrcValue.setValue(objRec.get("SrcValue"));
		obj.txtSrcDesc.setValue(objRec.get("SrcDesc"));
		obj.txtTargetValue.setValue(objRec.get("TargetValue"));
		obj.cboTargetDesc.setValue(objRec.get("TargetValue"));
		obj.cboTargetDesc.setRawValue(objRec.get("TargetDesc"));
		if (obj.MapDicTypeCode != '') {
			obj.txtTargetValue.setDisabled(true);
			obj.cboTargetDescStore.load({});
		} else {
			obj.txtTargetValue.setDisabled(false);
			obj.cboTargetDescStore.removeAll();
		}
		obj.txtResume.setValue(objRec.get("ResumeText"));
		
		obj.cboTargetDesc.setDisabled(false);
		obj.txtResume.setDisabled(false);
		obj.btnUpdate.setDisabled(false);
	}
	
	obj.cboTargetDesc_onSelect = function()
	{
		if (obj.MapDicTypeCode != '') {
			var TargetValue = obj.cboTargetDesc.getValue();
			obj.txtTargetValue.setValue(TargetValue);
		}
	}
	
	obj.gridProblem_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridProblem.getStore().getAt(index);
		obj.SetFormItem(objRec);
	};
	
	obj.btnUpdate_onClick = function()
	{
		var errinfo = "";
		if (!obj.MappingTypeCode) return;
		
		var SrcValue = obj.txtSrcValue.getValue();
		var SrcDesc = obj.txtSrcDesc.getValue();
		if (obj.MapDicTypeCode != '') {
			var TargetValue = obj.cboTargetDesc.getValue();
		} else {
			var TargetValue = obj.txtTargetValue.getValue();
		}
		var TargetDesc = obj.cboTargetDesc.getRawValue();
		var ResumeText = obj.txtResume.getValue();
		
		if (!SrcValue) {
			errinfo = errinfo + "源值为空!<br>";
		}
		if (!TargetValue) {
			errinfo = errinfo + "目标值为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var strArg = obj.RecRowID;
		strArg += "^" + obj.MappingTypeCode;
		strArg += "^" + SrcValue;
		strArg += "^" + SrcDesc;
		strArg += "^" + TargetValue;
		strArg += "^" + TargetDesc;
		strArg += "^" + ResumeText;
		var ret = $.Tool.RunServerMethod("DHCHAI.MK.BTMapData", "Update", strArg, "^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("提示","更新记录错误!Error=" + flg);
			return;
		} else {
			obj.ClearFormItem();
			obj.gridProblemStore.load({
				callback : function(){
					if (obj.gridProblemStore.getCount() > 0) {
						obj.btnSave.setDisabled(true);
					} else {
						obj.btnSave.setDisabled(false);
					}
				}
			});
		}
	}
	
	obj.btnSave_onClick = function(){
		if (obj.gridProblemStore.getCount() > 0) {
			ExtTool.alert("提示","存在未对照的数据项!");
			return;
		} else {
			obj.winProblem.hide();
			obj.objParent.btnExportInterface_click(null, null, false);
		}
	}
	
	obj.btnCancel_onclick = function(){
		obj.winProblem.hide();
	}
	
	obj.btnSkip_onclick = function(){
		obj.winProblem.hide();
		if (typeof ExpAll == 'undefined') ExpAll = 0;
		if(ExpAll==0){
			obj.objParent.btnExportInterface_click(null, null, true);
		}else{
			obj.objParent.btnExportAllInterface_click(null, null, true);
		}
	}
}

