function InitviewScreenEvents(obj){
	obj.LoadEvents = function(){
		obj.btnReViewStat.on('click',obj.btnReViewStat_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		
		obj.dfDateFrom.setValue('');
		obj.dfDateTo.setValue('');
		
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
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
	
	obj.btnReViewStat_click = function (){
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		Common_LoadCurrPage('gridReViewStat',1);
	}
	
	obj.btnExport_click = function (){
		if (obj.gridReViewStatStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		ExportGridByCls(obj.gridReViewStat,'复核不通过统计');
	}
}
