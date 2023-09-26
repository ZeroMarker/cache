
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args){
		obj.gridResult.on("rowdblclick", obj.gridResult_rowdblclick, obj);
		obj.gridResult.on("cellclick",obj.gridResult_cellclick,obj);
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
		obj.btnExport.on("click", obj.btnExport_click, obj);
		obj.btnExportXml.on("click", obj.btnExportXml_click, obj);
		obj.btnBatchCheck.on("click",obj.btnBatchCheck_click, obj);
		obj.cboRepType.on('select',obj.cboRepType_onSelect,obj);
		obj.chkSelectAll.on("check",obj.chkSelectAll_check,obj);
		
		obj.cboSSHosp.on("select",obj.cboSSHosp_select,obj);
		//obj.cboSSHosp.setValue(CTHospID);
		//obj.cboSSHosp.setRawValue(CTHospDesc);
		obj.cboSSHosp_select();
		
		//开始日期为昨天
		/*var curDate = new Date();
		var preDate = new Date(curDate.getTime() - 24*60*60*1000);
		var timeYesterday = preDate.format("Y") +"-" +preDate.format("m") + "-"+(preDate.format("d"));
		Common_SetValue('dtDateFrom',timeYesterday);*/
		obj.dtDateFrom.setValue(new Date().add(Date.DAY, -1));
		Common_SetValue('cbgRepStatus','','提交');
		
		//初始化报告类型,并执行查询
		obj.cboRepType.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboRepType.setValue(r[0].get("DicRowId"));
						obj.cboRepType.setRawValue(r[0].get("DicDesc"));
						obj.cboRepType_onSelect();
						obj.btnQuery_click();
					}
				}
			}
		});
	}
	
	obj.cboSSHosp_select = function(combo,record,index){
		obj.cboRepLoc.setValue();
		obj.cboRepLoc.setRawValue();
		obj.cboRepLoc.getStore().removeAll();
		obj.cboRepLoc.getStore().load({});
	}
	
	obj.btnQuery_click = function(){
		var repStatus = Common_GetValue("cbgRepStatus");
		if (repStatus == ''){
			window.alert("请选择报告状态！");
			return;
		}
		
		obj.chkSelectAll.setValue(false);
		var RepTypeID = obj.cboRepType.getValue();
		var objRepType = ExtTool.RunServerMethod("DHCMed.SS.Dictionary","GetObjById",RepTypeID);
		obj.RepTypeCode = objRepType.Code;
		if (obj.RepTypeCode=="1") {	
			Common_LoadCurrPage('gridResult',1);
			Common_SetValue('msgSearch','查询结果-重性精神疾病发病报卡');
		}else if (obj.RepTypeCode=="3"){
			Common_LoadCurrPage('gridResult',1);
			Common_SetValue('msgSearch','查询结果-严重精神障碍发病报卡');
		}else if (obj.RepTypeCode=="4"){
			Common_LoadCurrPage('gridResult',1);
			Common_SetValue('msgSearch','查询结果-严重精神障碍出院信息卡');
		} else {
			Common_LoadCurrPage('gridResult',1);
			Common_SetValue('msgSearch','查询结果-全部类型精神疾病报卡');
		}
	}
	
	obj.btnBatchCheck_click = function(){
		if (obj.gridResultStore.getCount() < 1) {
			ExtTool.alert("确认", "请先查询，再批量审核!");
			return;
		}
		
		var Count=0;
		for (var row = 0; row < obj.gridResultStore.getCount(); row++) {
			var record = obj.gridResultStore.getAt(row);
			if (record.get("checked")) {
				var ReportID = record.get("ReportID");
				var StatusDesc = record.get("StatusDesc");
				if (StatusDesc == '提交') {
					var ret = ExtTool.RunServerMethod("DHCMed.SMD.Report","CheckReport",ReportID, "2", "", session['LOGON.USERID']);
				}
				Count++;
			}
		}
		if (Count < 1) {
			ExtTool.alert("提示信息", "请至少选中一行记录,再进行审核!");
			return;
		}
		
		obj.btnQuery_click();
	}
	
	obj.cboRepType_onSelect = function(){
		obj.gridResultStore.removeAll();
	}
	
	obj.btnExport_click = function(){
		if (obj.gridResultStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		ExportGridByCls(obj.gridResult,'精神疾病报告查询');
	}
	
	obj.btnExportXml_click = function(objBtn, objEvent, isMapping)
	{
		//是否跳过字典对照检查（true：跳过）
		if (typeof isMapping == 'undefined') isMapping = false;
		
		//导出XML必须选择一种报卡类型
		var RepTypeID=Common_GetValue('cboRepType');
		if (RepTypeID == '') {
			window.alert("请选择一种报告类型,重新查询再导出！");
			return;
		} else {
			var RepTpCode = '';
			var objStore = obj.cboRepType.getStore();
			if (objStore){
				var rowIndex = objStore.find('DicRowId',RepTypeID);
				if (rowIndex > -1){
					var record = objStore.getAt(rowIndex);
					if (record){
						RepTpCode=record.get('DicCode');
					}
				}
			}
			if (!RepTpCode){
				window.alert("请选择一种报告类型,重新查询再导出！");
				return;
			}
		}
		
		var ReportIDList = "";
		for(var row = 0; row < obj.gridResultStore.getCount(); row++) {
			var objRec = obj.gridResultStore.getAt(row);
			if(!objRec.get("checked")) continue;
			if(ReportIDList != "") ReportIDList += "^";
			ReportIDList += objRec.get("ReportID");
		}
		if (ReportIDList == '') {
			window.alert("请选择导出XML的报卡！");
			return;
		}
		
		var HospInsCode = ExtTool.RunServerMethod("DHCMed.SSService.ConfigSrv", "GetValueByKeyHosp", "SMD-HospInsCode" ,CTHospID);
		if (HospInsCode == '') {
			window.alert("请设置医院/机构编码！");
			return;
		}
		
		ExtTool.prompt("文件路径", "请输入精神卫生信息系统接口文件存放路径...",
			function(e, text){
				if (e != "ok") return;
				
				var patrn=/^[C-Z]:\\.+$/;
				if(!patrn.exec(text)){
					ExtTool.alert("提示",text+":格式不正确！");
					return ;
				}
				var filePath = text;
				
				var objXML1 = new ExportXMLType1(); //严重精神障碍患者出院信息单（出院）
				var objXML2 = new ExportXMLType2(); //严重精神障碍患者报告卡（入院）
				var objXML3 = new ExportXMLType3(); //重性精神疾病报告卡（门诊）
				var objXML = null;
				switch(RepTpCode){
					case "1":
						filePath += '_门诊'
						objXML = new ExportXMLType3();	//重性精神疾病报告卡（门诊）
						break;
					case "3":
						filePath += '_入院'
						objXML = new ExportXMLType2();	//严重精神障碍患者报告卡（入院）
						break;
					case "4":
						filePath += '_出院'
						objXML = new ExportXMLType1();	//严重精神障碍患者出院信息单（出院）
						break;
				}
				
				//如果目录不存在，创建新目录
				var objFSO = new ActiveXObject("Scripting.FileSystemObject");
				if (!objFSO.FolderExists(filePath)){
					var strFolderName = objFSO.CreateFolder(filePath);
				}
				
				objXML.ExportXMLFile(ReportIDList, isMapping, filePath, HospInsCode);
			},
			null,
			false,
			"D:\\精神卫生信息系统接口文件"
		)
	}
	
	obj.chkSelectAllClickFlag = 1;
	obj.chkSelectAll_check = function(){
		if (obj.chkSelectAllClickFlag != 1) return;
		var objStore = obj.gridResult.getStore();
		if (objStore.getCount() < 1){
			obj.chkSelectAll.setValue(false);
			obj.btnBatchCheck.disable();
			obj.btnExportXml.disable();
			return;
		}
		
		var isCheck = obj.chkSelectAll.getValue();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			record.set('checked', isCheck);
			obj.gridResult.getStore().commitChanges();
			obj.gridResult.getView().refresh();
		}
		//fix bug 110381
		/*
		if (isCheck){
			obj.btnBatchCheck.enable();
			obj.btnExportXml.enable();
		} else {
			obj.btnBatchCheck.disable();
			obj.btnExportXml.disable();
		}
		*/
	}
	
	obj.gridResult_cellclick = function(grid, rowIndex, columnIndex, e){
		if (columnIndex != 1) return;
		var record = grid.getStore().getAt(rowIndex);
		var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
	    var recValue = record.get(fieldName);
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
		record.set(fieldName, newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
		
		if (newValue == '0') {
			var isSelectAll = '0';
		} else {
			var isSelectAll = '1';
			var count = 0;
			var objStore = grid.getStore();
			for (var row = 0; row < objStore.getCount(); row++){
				var record = objStore.getAt(row);
				count++;
				if (record.get(fieldName) != '1') {
					isSelectAll = '0';
					break;
				}
			}
			if (count<1) isSelectAll = '0';
		}
		
		obj.chkSelectAllClickFlag = 0;
		if (isSelectAll == '0'){
			obj.chkSelectAll.setValue(false);
		} else {
			obj.chkSelectAll.setValue(true);
		}
		obj.chkSelectAllClickFlag = 1;
	}
	
	obj.gridResult_rowdblclick = function(objGrid, rowIndex, eventObj){
		var objRec = obj.gridResultStore.getAt(rowIndex);
		if (!objRec) return;
		var ReportID = objRec.get("ReportID");
		var url = "dhcmed.smd.report.csp?ReportID=" + ReportID;
		var sFeatures = "dialogWidth=" + window.screen.availWidth + "px;dialogHeight=" + window.screen.availHeight + "px;resizable=no;"
		window.showModalDialog(url,"",sFeatures);
		Common_LoadCurrPage('gridResult');
		//var oWin = window.open(url,'',"height=" + (window.screen.availHeight - 50) + ",width=" + (window.screen.availWidth - 200) + ",top=0,left=100,resizable=no");
	}
	
	obj.DisplayReportWindow = function(rowIndex){
		var objRec = Ext.getCmp("gridResult");
		obj.gridResult_rowdblclick(objRec,rowIndex);
	}
}

