function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args){
		obj.cboHospital.on("expand", obj.cboHospital_OnExpand, obj);
		//obj.cboLoc.on("expand", obj.cboLoc_OnExpand, obj);
		//obj.cboAdmType.on("expand", obj.cboAdmType_OnExpand, obj);
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj);
		obj.btnExport.on("click", obj.btnExport_OnClick, obj);
		/*
		obj.cboHospitalStore.load({
			callback : function() {
				if (session['LOGON.HOSPID']){
					obj.cboHospital.setValue(session['LOGON.HOSPID']);
				}
				if (tDHCMedMenuOper['admin'] == '1'){
					obj.cboHospital.setDisabled(false);
				}else{
					obj.cboHospital.setDisabled(true);
				}
				obj.cboLocStore.load({
					callback : function() {
						if ((tDHCMedMenuOper['admin'] == '1') || (tDHCMedMenuOper['HospitalAdmin'] == '1')){
							obj.cboLoc.setDisabled(false);
						}else{
							obj.cboLoc.setValue(session['LOGON.CTLOCID']);
							obj.cboLoc.setDisabled(true);
						}
					}
					,scope: obj.cboLocStore
					,add: false
				});
			}
			,scope: obj.cboHospitalStore
			,add: false
		});
		*/
		obj.cboHospital.getStore().load({
			callback : function(r){
				if (r.length > 0) {
					var objRec = r[0];
					obj.cboHospital.setValue(objRec.get("CTHospID"));
					obj.cboHospital.setRawValue(objRec.get("CTHospDesc"));
				}
				if (r.length < 2) {
					obj.cboHospital.setDisabled(true);
				}
			}
		});
		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.DtlDataGridPanel.getColumnModel();
    			var cfg = null;
    			for(var i=0;i<cm.config.length;++i)
   	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="Secret1")||(cfg.id=="Secret2")) {
					cm.setHidden(i,true);
	   	 		}
			}
		}
	};
	obj.cboHospital_OnExpand = function(){
		obj.cboHospitalStore.load({});
		obj.cboLoc.clearValue();
	}
	/*obj.cboLoc_OnExpand = function(){
		obj.cboLocStore.load({});
	}
	
	obj.cboAdmType_OnExpand = function(){
		obj.cboAdmTypeStore.load({});
	}*/
	obj.btnQuery_OnClick = function(){
		obj.StatDataGridPanelStore.removeAll();
		obj.StatDataGridPanelStore.load({params : {start : 0,limit : 20}});
		obj.DtlDataGridPanelStore.removeAll();
		obj.DtlDataGridPanelStore.load({params : {start : 0,limit : 20}});
	}
	obj.btnExport_OnClick = function(){
		
		if (obj.StatDataGridPanel.getStore().getCount() < 1) {
			ExtTool.alert("确认", "无数据记录，不允许导出!");
			return;
		}

		var strFileName = "传染病疾病统计";
		var objExcelTool = Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.StatDataGridPanel, strFileName, false);	
	}
}