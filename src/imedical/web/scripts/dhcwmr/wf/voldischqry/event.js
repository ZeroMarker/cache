function InitviewScreenEvents(obj){
	obj.LoadEvents = function(){
		obj.btnDischQry.on('click',obj.btnDischQry_click,obj);
		obj.btnNoBack.on('click',obj.btnNoBack_click,obj);
		obj.btnBack.on('click',obj.btnBack_click,obj);
		obj.btn2DaysLate.on('click',obj.btn2DaysLate_click,obj);
		obj.btn3DaysLate.on('click',obj.btn3DaysLate_click,obj);
		obj.btn7DaysLate.on('click',obj.btn7DaysLate_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		obj.btnPrint.on('click',obj.btnPrint_click,obj);
		obj.btnBatBack.on('click',obj.btnBatBack_click,obj);
		Common_SetDisabled('btnBatBack',true);
		
		obj.dfDateFrom.setValue('');
		obj.dfDateTo.setValue('');
		
		obj.cboLocGroup.on("select",obj.cboLocGroup_select,obj);
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
		
		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.DischAdmGrid.getColumnModel();
	    		var cfg = null;
			for(var i=0;i<cm.config.length;++i)
	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="Secret1")||(cfg.id=="Secret2")) {
					cm.setHidden(i,true);
	   	 		}
			}
		}
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
		//加载科室组
		obj.cboLocGroup.getStore().removeAll();
		obj.cboLocGroup.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0){
						obj.cboLocGroup.setValue(r[0].get("GroupID"));
						obj.cboLocGroup.setRawValue(r[0].get("GroupDesc"));
					}
				}
			}
		});
	}
	
	obj.cboLocGroup_select = function(combo,record,index){
		obj.cboLoc.setValue();
		obj.cboLoc.setRawValue();
		obj.cboLoc.getStore().removeAll();
		obj.cboLoc.getStore().load({});
	}
	obj.btnNoBack_click = function (){
		obj.BackDays = 0;
		Common_LoadCurrPage('DischAdmGrid',1);
		Common_SetValue('msgDischAdmGrid','未回收病历查询结果');
		Common_SetDisabled('btnBatBack',false);
	}
	obj.btnBack_click = function (){
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		obj.BackDays = 1;
		Common_LoadCurrPage('DischAdmGrid',1);
		Common_SetValue('msgDischAdmGrid','已回收病历查询结果');
		Common_SetDisabled('btnBatBack',true);
	}
	obj.btnDischQry_click = function(){
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		obj.BackDays = -1;
		Common_LoadCurrPage('DischAdmGrid',1);
		Common_SetValue('msgDischAdmGrid','出院查询结果');
		Common_SetDisabled('btnBatBack',true);
	}
	obj.btn2DaysLate_click = function (){
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		obj.BackDays = 2;
		Common_LoadCurrPage('DischAdmGrid',1);
		Common_SetValue('msgDischAdmGrid','2日迟归病历查询结果');
		Common_SetDisabled('btnBatBack',true);
	}
	obj.btn3DaysLate_click = function (){
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		obj.BackDays = 3;
		Common_LoadCurrPage('DischAdmGrid',1);
		Common_SetValue('msgDischAdmGrid','3日迟归病历查询结果');
		Common_SetDisabled('btnBatBack',true);
	}
	obj.btn7DaysLate_click = function (){
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		obj.BackDays = 7;
		Common_LoadCurrPage('DischAdmGrid',1);
		Common_SetValue('msgDischAdmGrid','7日迟归病历查询结果');
		Common_SetDisabled('btnBatBack',true);
	}
	obj.btnExport_click = function (){
		if (obj.DischAdmGridStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		var recTitle = Common_GetValue('msgDischAdmGrid');
		ExportGridByCls(obj.DischAdmGrid,recTitle);
	}
	obj.btnPrint_click = function(){
		if (obj.DischAdmGridStore.getCount()<1) {
			window.alert("请先查询再打印！");
			return;
		}
		var fields = 'RowNumberer'
			+ CHR_1 + 'AdmWardDesc'
			+ CHR_1 + 'DischDate'
			+ CHR_1 + 'PapmiNo'
			+ CHR_1 + 'PatName'
			+ CHR_1 + 'MrNo'
			+ CHR_1 + 'AdmLocDesc';
		var xlsName = 'DHCWMR_IMR_DischMrBack.xlsx';
		var recTitle = Common_GetValue('msgDischAdmGrid');
		PrintGridByCls(obj.DischAdmGrid,fields,xlsName,recTitle);
	}
	
	//病案批量回收
	obj.btnBatBack_click = function(){
		if (obj.BackDays != 0) return;
		if (obj.DischAdmGridStore.getCount()<1) {
			window.alert("请先执行未回收病历查询！");
			return;
		}
		var win = new VBB_InitVolumeSelect(obj.DischAdmGridStore.lastOptions.params,'DischAdmGrid');
		win.VBB_WinVolumeSelect.show();
	}
}
