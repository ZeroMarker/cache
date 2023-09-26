
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
		
		//��ʼ����Ϊ����
		/*var curDate = new Date();
		var preDate = new Date(curDate.getTime() - 24*60*60*1000);
		var timeYesterday = preDate.format("Y") +"-" +preDate.format("m") + "-"+(preDate.format("d"));
		Common_SetValue('dtDateFrom',timeYesterday);*/
		obj.dtDateFrom.setValue(new Date().add(Date.DAY, -1));
		Common_SetValue('cbgRepStatus','','�ύ');
		
		//��ʼ����������,��ִ�в�ѯ
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
			window.alert("��ѡ�񱨸�״̬��");
			return;
		}
		
		obj.chkSelectAll.setValue(false);
		var RepTypeID = obj.cboRepType.getValue();
		var objRepType = ExtTool.RunServerMethod("DHCMed.SS.Dictionary","GetObjById",RepTypeID);
		obj.RepTypeCode = objRepType.Code;
		if (obj.RepTypeCode=="1") {	
			Common_LoadCurrPage('gridResult',1);
			Common_SetValue('msgSearch','��ѯ���-���Ծ��񼲲���������');
		}else if (obj.RepTypeCode=="3"){
			Common_LoadCurrPage('gridResult',1);
			Common_SetValue('msgSearch','��ѯ���-���ؾ����ϰ���������');
		}else if (obj.RepTypeCode=="4"){
			Common_LoadCurrPage('gridResult',1);
			Common_SetValue('msgSearch','��ѯ���-���ؾ����ϰ���Ժ��Ϣ��');
		} else {
			Common_LoadCurrPage('gridResult',1);
			Common_SetValue('msgSearch','��ѯ���-ȫ�����;��񼲲�����');
		}
	}
	
	obj.btnBatchCheck_click = function(){
		if (obj.gridResultStore.getCount() < 1) {
			ExtTool.alert("ȷ��", "���Ȳ�ѯ�����������!");
			return;
		}
		
		var Count=0;
		for (var row = 0; row < obj.gridResultStore.getCount(); row++) {
			var record = obj.gridResultStore.getAt(row);
			if (record.get("checked")) {
				var ReportID = record.get("ReportID");
				var StatusDesc = record.get("StatusDesc");
				if (StatusDesc == '�ύ') {
					var ret = ExtTool.RunServerMethod("DHCMed.SMD.Report","CheckReport",ReportID, "2", "", session['LOGON.USERID']);
				}
				Count++;
			}
		}
		if (Count < 1) {
			ExtTool.alert("��ʾ��Ϣ", "������ѡ��һ�м�¼,�ٽ������!");
			return;
		}
		
		obj.btnQuery_click();
	}
	
	obj.cboRepType_onSelect = function(){
		obj.gridResultStore.removeAll();
	}
	
	obj.btnExport_click = function(){
		if (obj.gridResultStore.getCount()<1) {
			window.alert("���Ȳ�ѯ�ٵ���Excel��");
			return;
		}
		ExportGridByCls(obj.gridResult,'���񼲲������ѯ');
	}
	
	obj.btnExportXml_click = function(objBtn, objEvent, isMapping)
	{
		//�Ƿ������ֵ���ռ�飨true��������
		if (typeof isMapping == 'undefined') isMapping = false;
		
		//����XML����ѡ��һ�ֱ�������
		var RepTypeID=Common_GetValue('cboRepType');
		if (RepTypeID == '') {
			window.alert("��ѡ��һ�ֱ�������,���²�ѯ�ٵ�����");
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
				window.alert("��ѡ��һ�ֱ�������,���²�ѯ�ٵ�����");
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
			window.alert("��ѡ�񵼳�XML�ı�����");
			return;
		}
		
		var HospInsCode = ExtTool.RunServerMethod("DHCMed.SSService.ConfigSrv", "GetValueByKeyHosp", "SMD-HospInsCode" ,CTHospID);
		if (HospInsCode == '') {
			window.alert("������ҽԺ/�������룡");
			return;
		}
		
		ExtTool.prompt("�ļ�·��", "�����뾫��������Ϣϵͳ�ӿ��ļ����·��...",
			function(e, text){
				if (e != "ok") return;
				
				var patrn=/^[C-Z]:\\.+$/;
				if(!patrn.exec(text)){
					ExtTool.alert("��ʾ",text+":��ʽ����ȷ��");
					return ;
				}
				var filePath = text;
				
				var objXML1 = new ExportXMLType1(); //���ؾ����ϰ����߳�Ժ��Ϣ������Ժ��
				var objXML2 = new ExportXMLType2(); //���ؾ����ϰ����߱��濨����Ժ��
				var objXML3 = new ExportXMLType3(); //���Ծ��񼲲����濨�����
				var objXML = null;
				switch(RepTpCode){
					case "1":
						filePath += '_����'
						objXML = new ExportXMLType3();	//���Ծ��񼲲����濨�����
						break;
					case "3":
						filePath += '_��Ժ'
						objXML = new ExportXMLType2();	//���ؾ����ϰ����߱��濨����Ժ��
						break;
					case "4":
						filePath += '_��Ժ'
						objXML = new ExportXMLType1();	//���ؾ����ϰ����߳�Ժ��Ϣ������Ժ��
						break;
				}
				
				//���Ŀ¼�����ڣ�������Ŀ¼
				var objFSO = new ActiveXObject("Scripting.FileSystemObject");
				if (!objFSO.FolderExists(filePath)){
					var strFolderName = objFSO.CreateFolder(filePath);
				}
				
				objXML.ExportXMLFile(ReportIDList, isMapping, filePath, HospInsCode);
			},
			null,
			false,
			"D:\\����������Ϣϵͳ�ӿ��ļ�"
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

