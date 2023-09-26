function InitviewScreenEvent(obj) {
	
	obj.LoadEvent = function(args) {
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
		obj.cboHospital.on("expand", obj.cboHospital_OnExpand, obj);
		//obj.cboLoc.on("expand", obj.cboLoc_OnExpand, obj);
		obj.btnExport.on("click", obj.btnExport_OnClick, obj);
		
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
	};
	
	obj.btnExport_OnClick = function() {
		if (obj.RstGridPanel.store.data.length < 1) {
			ExtTool.alert("ȷ��", "�޼�¼,�������ӡ!");
			return;
		}

		// var filePath="D:\\DTHealth\\app\\dthis\\med\\Results\\Template\\DHCEpidemicOPStat.xls"
		var filePath = "";
		var objCommonSrv = ExtTool.StaticServerObject("DHCMed.EPDService.CommonSrv");
		if (objCommonSrv) {
			filePath = objCommonSrv.GetTemplatePath()
		}
		if (!filePath) {
			return;
		}
		var strFileName = "���ﴫȾ��ͳ�Ʊ�";
		filePath = filePath + "DHCEpidemicOPStat.xls"
		var objExcelTool = Ext.dhcc.DataToExcelTool;
		objExcelTool.ExcelApp.InitApp(filePath);
		objExcelTool.ExcelApp.SetVisible(true);
		objExcelTool.BuildBody(obj.RstGridPanel, 4, 1);
		objExcelTool.ExcelApp.SaveBook(strFileName);
		objExcelTool.ExcelApp.Close();

		// objExcelTool.ExprotGrid(obj.RstGridPanel,strFileName);
	};
	
	obj.cboHospital_OnExpand = function() {
		obj.cboHospitalStore.load({});
		obj.cboLoc.clearValue();
	};
	
	/*obj.cboLoc_OnExpand = function() {
		obj.cboLocStore.load({});
	};*/
	
	obj.btnQuery_click = function() {
		var FromDate = obj.dtFromDate.getRawValue();
		var ToDate = obj.dtToDate.getRawValue();
		
		if ((!FromDate)||(!ToDate)) {
			ExtTool.alert("��ʾ", "��ʼ���ڡ��������ڲ�����Ϊ��!");
			return;
		}
		if (Common_CompareDate(FromDate,ToDate)) {
			ExtTool.alert("��ʾ", "��ʼ���ڲ��ܴ��ڽ�������!");
			return;
		}
	
		obj.GridStore.removeAll();
		obj.GridStore.reader = new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total'
				// ,idProperty: 'RstNo'
			}, obj.storeFields)
		obj.GridStore.load({});
		obj.GridColumnHeaderGroup = new Ext.ux.grid.ColumnHeaderGroup({
					rows : [obj.gridHeader]
				});
		obj.GridColumns = new Ext.grid.ColumnModel(obj.gridColumn);
		obj.GridColumns.rows = obj.GridColumnHeaderGroup.config.rows;
		obj.RstGridPanel.reconfigure(obj.GridStore, obj.GridColumns);
	};
	
	// ���ڴ�С�Ƚ�  
function Common_CompareDate(startDate,endDate) {
	if ((typeof(startDate)=='undefined')||(typeof(endDate)=='undefined')){
		return false;
	} 
	var startDate = tkMakeServerCall("DHCMed.SSService.CommonCls","DateHtmlToLogical",startDate);
	var endDate = tkMakeServerCall("DHCMed.SSService.CommonCls","DateHtmlToLogical",endDate);
	debugger
	if (startDate>endDate) { 
		return true;
	}
	return false;
}

}
