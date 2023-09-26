function InitEvent(obj){
	obj.LoadEvents = function(){
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.btnQry.on('click',obj.btnQry_click,obj);
		obj.btnExportCollect.on('click',obj.btnExportCollect_click,obj);
		obj.btnExportDetail.on('click',obj.btnExportDetail_click,obj);
		obj.CollectResult.on('rowclick',obj.CollectResult_rowclick,obj);
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
		Common_LoadCurrPage('CollectResult',1);
		obj.DetailResultStore.removeAll();
	}
	
	obj.btnExportCollect_click = function()
	{
		if (obj.CollectResultStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		ExportGridByCls(obj.CollectResult,'未归还病案汇总');
	}
	
	obj.btnExportDetail_click = function()
	{
		if (obj.DetailResultStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		ExportGridByCls(obj.DetailResult,'未归还病案明细');		
	}
	
	obj.CollectResult_rowclick = function()
	{
		var selectObj = obj.CollectResult.getSelectionModel().getSelected();
		var HospID   = Common_GetValue("cboHospital");
		var MrTypeID = Common_GetValue("cboMrType");
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo   = Common_GetValue("dfDateTo");
		var LendLoc = selectObj.get("LendLoc");
		var LendUser = selectObj.get("LendUser");
		var strArg = HospID;
		strArg += '^' + MrTypeID;
		strArg += '^' + DateFrom;
		strArg += '^' + DateTo;
		strArg += '^' + LendLoc;
		strArg += '^' + LendUser;
		obj.QueryDetailInput = strArg;
		Common_LoadCurrPage('DetailResult',1);
	}
}