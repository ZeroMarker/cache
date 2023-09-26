function InitEvent(obj){
	obj.LoadEvents = function(){
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.btnPrint.on('click',obj.btnPrint_click,obj);
		obj.btnQry.on('click',obj.btnQry_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		obj.txtMrNo.on('specialkey',obj.txtMrNo_specialkey,obj);
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
	
	obj.btnPrint_click = function()
	{
		if (obj.gridResultStore.getCount()<1) {
			window.alert("请先查询再打印！");
			return;
		}
		var fields = 'PapmiNo'
			+ CHR_1 + 'MrNo'
			+ CHR_1 + 'PatName'
			+ CHR_1 + 'Sex'
			+ CHR_1 + 'Age'
			+ CHR_1 + 'HospDesc'
			+ CHR_1 + 'StatusDesc'
			+ CHR_1 + 'LendDate'
			+ CHR_1 + 'LendLoc'
			+ CHR_1 + 'LendUser'
			+ CHR_1 + 'BackDate'
			+ CHR_1 + 'BackUser';
		var xlsName = 'DHCWMR_OMR_Lend.xlsx';
		var QryType = Common_GetText("cboQryType");
		var LendLoc = Common_GetText("cboLendLoc");
		var LendDoc = Common_GetText("cboLendDoc");
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		var recTitle = LendLoc+LendDoc+QryType+"病案("+DateFrom+"~"+DateTo+")";
		PrintGridByCls(obj.gridResult,fields,xlsName,recTitle);
	}
	
	obj.btnQry_click = function()
	{
		Common_LoadCurrPage('gridResult',1);
	}

	obj.btnExport_click = function()
	{
		if (obj.gridResultStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		ExportGridByCls(obj.gridResult,'借阅综合查询结果');
	}
	
	obj.txtMrNo_specialkey = function(field, e)
	{
		if (e.getKey() != Ext.EventObject.ENTER) return;
		var MrNo     = Common_GetValue("txtMrNo");
		if (MrNo==''){
			window.alert("请输入病案号！");
			return '';
		}
		Common_LoadCurrPage('gridResult',1);
		Common_SetValue("txtMrNo","");
	}
	
	obj.GetQueryInput = function(){
		var HospID 	 = Common_GetValue("cboHospital");
		var MrTypeID = Common_GetValue("cboMrType");
		var QryType  = Common_GetValue("cboQryType");
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo   = Common_GetValue("dfDateTo");
		var LendLoc  = Common_GetValue("cboLendLoc");
		var LendDoc  = Common_GetValue("cboLendDoc");
		var MrNo     = Common_GetValue("txtMrNo");
		
		if (HospID==''){
			window.alert("请选择医院！");
			return '';
		}
		if (MrTypeID==''){
			window.alert("请选择病案类型！");
			return '';
		}
		if ((DateFrom=='')||(DateTo=='')) {
			window.alert("请选择开始日期和结束日期！");
			return '';
		}
		
		var strArg = HospID;
		strArg += '^' + MrTypeID;
		strArg += '^' + QryType;
		strArg += '^' + DateFrom;
		strArg += '^' + DateTo;
		strArg += '^' + LendLoc;
		strArg += '^' + LendDoc;
		strArg += '^' + MrNo;
		return strArg;
	}
}