function InitEvent(obj)
{
	obj.LoadEvents = function()
	{
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.btnPrint.on('click',obj.btnPrint_click,obj);
		obj.btnQry.on('click',obj.btnQry_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
	}
	
	obj.cboHospital_select = function(combo,record,index){
		//加载病案类型
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
	
	obj.btnQry_click = function()
	{
		Common_LoadCurrPage('gridLocLend',1);
	}
	
	obj.btnExport_click = function()
	{
		if (obj.gridLocLendStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		ExportGridByCls(obj.gridLocLend,'科室借阅统计');
	}
		
	obj.btnPrint_click = function()
	{
		if (obj.gridLocLendStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		var fields = 'MrNo'
			+ CHR_1 + 'PatName'
			+ CHR_1 + 'Sex'
			+ CHR_1 + 'Age'
			+ CHR_1 + 'LendLoc'
			+ CHR_1 + 'LendUser'
			+ CHR_1 + 'LendDate'
			+ CHR_1 + 'UpdateUser'
			+ CHR_1 + 'BackUser'
		var xlsName = 'DHCWMR_OMR_LocLendQry.xlt';
		var recTitle = "" 
		PrintGridByCls(obj.gridLocLend,fields,xlsName,recTitle);
	}
}