function InitViewPortEvents(obj)
{
	obj.LoadEvents = function()
	{
		obj.btnQuery.on('click',obj.btnQuery_click,obj);
		obj.btnSave.on('click',obj.btnSave_click,obj);
		obj.btnDelete.on('click',obj.btnDelete_click,obj);
		obj.gridMapping.on('rowclick',obj.gridMapping_rowclick,obj);
	}

	obj.btnQuery_click = function()
	{
		Common_LoadCurrPage('gridMapping',1);
	}
	
	obj.btnSave_click = function()
	{
		var Error='';
		if (!obj.MappingID)
		{
			ExtTool.alert('提示','请选中一条记录！');
			return;
		}
		var MRICD10=Common_GetValue('txtMRICD10');
		var MRICDDesc=Common_GetValue('txtMRICDDesc');
		var FPICD10=Common_GetValue('txtFPICD10');
		var FPICDDesc=Common_GetValue('txtFPICDDesc');
		var Resume=Common_GetValue('txtResume');
		var UserID=session['LOGON.USERID'];
		if (!FPICD10) Error = Error+'对照编码、';
		if (!FPICDDesc) Error = Error+'对照名称、';
		if (!MRICDDesc) Error = Error+'临床名称、';
		if (Error)
		{
			ExtTool.alert("提示",Error+'为空！');
			return;
		}

		var InputStr = obj.MappingID
			+ "^" + MRICD10
			+ "^" + MRICDDesc
			+ "^" + FPICD10
			+ "^" + FPICDDesc
			+ "^" + UserID
			+ "^" + '1'
			+ "^" + Resume
		var ret = ExtTool.RunServerMethod("DHCWMR.FPService.FPMappingSrv","CheckMapping",InputStr,"^");
		if(ret<0) {
			ExtTool.alert("提示","审核失败！");
			return;
		}else{
			ExtTool.alert("提示","审核成功！");
			Common_LoadCurrPage('gridMapping',1);
		}
	}

	obj.btnDelete_click = function()
	{
		if (!obj.MappingID)
		{
			ExtTool.alert('提示','请选中一条记录！');
			return;
		}
		var ret = ExtTool.RunServerMethod("DHCWMR.FP.FPMapping","DeleteById",obj.MappingID);
		if(ret<0) {
			ExtTool.alert("提示","删除失败！");
			return;
		}else{
			ExtTool.alert("提示","删除成功！");
			Common_LoadCurrPage('gridMapping',1);
		}
	}

	obj.gridMapping_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.gridMappingStore.getAt(rowIndex);
		if (obj.MappingID == objRec.get("ID")) {
			obj.MappingID = '';
			Common_SetValue('txtMRICD10','');
			Common_SetValue('txtMRICDDesc','');
			Common_SetValue('txtFPICD10','');
			Common_SetValue('txtFPICDDesc','');
			Common_SetValue('txtResume','');
		} else {
			obj.MappingID = objRec.get("ID");
			Common_SetValue('txtMRICD10',objRec.get("MRICD10"));
			Common_SetValue('txtMRICDDesc',objRec.get("MRICDDesc"));
			Common_SetValue('txtFPICD10',objRec.get("FPICD10"));
			Common_SetValue('txtFPICDDesc',objRec.get("FPICDDesc"));
			Common_SetValue('txtResume',objRec.get("Resume"));
		}
	}
}