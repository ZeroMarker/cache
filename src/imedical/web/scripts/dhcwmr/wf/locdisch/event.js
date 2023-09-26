function InitviewScreenEvents(obj){
	obj.LoadEvents = function(){
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital.on('select',obj.cboHospital_select,obj);
		
		obj.btnQuery.on('click',obj.btnQuery_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		obj.btnExportDtl.on('click',obj.btnExportDtl_click,obj);
		obj.LocDischGrid.on('rowclick',obj.LocDischGrid_rowclick,obj);
		obj.LocDischGrid.on('rowdblclick',obj.LocDischGrid_click,obj);
		
		obj.cboHospital_select();
	}
	
	obj.cboHospital_select = function(){
		obj.cboMrType.getStore().removeAll();
		obj.cboMrType.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboMrType.setValue(r[0].get("MrTypeID"));
						obj.cboMrType.setRawValue(r[0].get("MrTypeDesc"));
					}
				}
			}
		});
	}
	
	obj.LocDischGrid_rowclick = function() {
		var selectObj = obj.LocDischGrid.getSelectionModel().getSelected();
		if (selectObj.get('LocID')==obj.LocID)
		{
			obj.LocID="";
			obj.LocDischGridDtlStore.removeAll();	
		}else{
			obj.LocID=selectObj.get('LocID');
			obj.LocNotBackFlag=1;
			Common_LoadCurrPage('LocDischGridDtl',1);
		}
	}
	
	obj.LocDischGrid_click = function() {
		var selectObj = obj.LocDischGrid.getSelectionModel().getSelected();
		if (selectObj.get('LocID')==obj.LocID)
		{
			obj.LocID="";
			obj.LocDischGridDtlStore.removeAll();	
		}else{
			obj.LocID=selectObj.get('LocID');
			obj.LocNotBackFlag="";
			Common_LoadCurrPage('LocDischGridDtl',1);
		}
	}
	
	obj.btnQuery_click = function (){
		var MrTypeID = Common_GetValue("cboMrType");
		if (MrTypeID==''){
			window.alert("请选择病案类型!");
			return;
		}
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		Common_LoadCurrPage('LocDischGrid',1);
	}
	
	obj.btnExport_click = function (){
		if (obj.LocDischGridStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		if ("undefined"==typeof EnableLocalWeb || 0==EnableLocalWeb ){
			ExprotGrid(obj.LocDischGrid,'科室出院回收情况统计.xls');
		}else{
			ExprotGridStrNew(obj.LocDischGrid,'科室出院回收情况统计.xls');
		}
	}
	obj.btnExportDtl_click = function (){
		if (obj.LocDischGridDtlStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		if ("undefined"==typeof EnableLocalWeb || 0==EnableLocalWeb ){
			ExprotGrid(obj.LocDischGridDtl,'科室出院回收情况明细.xls');
		}else{
			ExprotGridStrNew(obj.LocDischGridDtl,'科室出院回收情况明细.xls');
		}
	}
}
