
//function InitDtlWindow(aDateFrom,aDateTo,aCPWDID,aAnalysisType,aLoc){
//	Modified by zhaoyu 2012-11-23 �ٴ�·���±���ϸ����
function InitDtlWindow(aDateFrom,aDateTo,aCPWDID,aAnalysisType,aLoc,aAnalysisRawValue,aCPWDicDesc){
	var obj = new Object();
	obj.DtlResultGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.DtlResultGridPanelStore = new Ext.data.Store({
		proxy: obj.DtlResultGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'AnalysisID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'AnalysisID', mapping: 'AnalysisID'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'InMedicare', mapping: 'InMedicare'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'AdmLoc', mapping: 'AdmLoc'}
			,{name: 'AdmWard', mapping: 'AdmWard'}
			,{name: 'AdmDoc', mapping: 'AdmDoc'}
			,{name: 'Diagnos', mapping: 'Diagnos'}
			,{name: 'CPWDicDesc', mapping: 'CPWDicDesc'}
			,{name: 'CPWStatus', mapping: 'CPWStatus'}
			,{name: 'IsVarPat', mapping: 'IsVarPat'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'DischDate', mapping: 'DischDate'}
			,{name: 'AdmDays', mapping: 'AdmDays'}
			,{name: 'OperDate', mapping: 'OperDate'}
			,{name: 'OperAdmDays', mapping: 'OperAdmDays'}
			,{name: 'OutStatus', mapping: 'OutStatus'}
			,{name: 'IsInHospInf', mapping: 'IsInHospInf'}
			,{name: 'IsOperInf', mapping: 'IsOperInf'}
			,{name: 'HospCost', mapping: 'HospCost'}
			,{name: 'DrugCost', mapping: 'DrugCost'}
			,{name: 'LabCost', mapping: 'LabCost'}
			,{name: 'CheckCost', mapping: 'CheckCost'}
			,{name: 'MaterialCost', mapping: 'MaterialCost'}
			
			//**************************************************
			//��ҽ��ص��ٴ�·��ͳ��ָ��
			,{name: 'ProprMedCost', mapping: 'ProprMedCost'}
			,{name: 'HerbalMedCost', mapping: 'HerbalMedCost'}
			,{name: 'WesternMedCost', mapping: 'WesternMedCost'}
			,{name: 'TherapyCost', mapping: 'TherapyCost'}
			,{name: 'ChTherapyCost', mapping: 'ChTherapyCost'}
			,{name: 'CharaTherapyCost', mapping: 'CharaTherapyCost'}
			,{name: 'IsPiecesMed', mapping: 'IsPiecesMed'}
			,{name: 'IsProprMed', mapping: 'IsProprMed'}
			,{name: 'IsCharaTherapy', mapping: 'IsCharaTherapy'}
			,{name: 'IsChTherapy', mapping: 'IsChTherapy'}
			//**************************************************
			
			,{name: 'Is3Pharmacy', mapping: 'Is3Pharmacy'}
			,{name: 'PharmacyDays', mapping: 'PharmacyDays'}
			,{name: 'PharmacyCost', mapping: 'PharmacyCost'}
			,{name: 'TimesOperFlag', mapping: 'TimesOperFlag'}
			,{name: 'IsPreDrugFlag', mapping: 'IsPreDrugFlag'}
			,{name: 'IsComplicationFlag', mapping: 'IsComplicationFlag'}
			,{name: 'NextDays', mapping: 'NextDays'}
			,{name: 'NotInCPWReason', mapping: 'NotInCPWReason'}
			//*******Modified by zhaoyu 2012-11-12 �ٴ�·���±���ϸ����:�Ƿ���ó���,�Ƿ�סԺ�ճ���,�ο�����,�ο�����
			//	CPWCost	CPWDays
			,{name: 'CPWCost', mapping: 'CPWCost'}
			,{name: 'CPWDays', mapping: 'CPWDays'}
			//	WhetherOverCost	WhetherOverDay
			,{name: 'WhetherOverCost', mapping: 'WhetherOverCost'}
			,{name: 'WhetherOverDay', mapping: 'WhetherOverDay'}
			//*******
		])
	});
	obj.DtlResultGridPanel = new Ext.grid.GridPanel({
		id : 'DtlResultGridPanel'
		,loadMask : true
		,store : obj.DtlResultGridPanelStore
		,region : 'center'
		,columnLines : true
		,frame : true
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '�ǼǺ�', width: 70, dataIndex: 'PapmiNo', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '������', width: 70, dataIndex: 'InMedicare', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '����', width: 70, dataIndex: 'PatName', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '��<br>��', width: 50, dataIndex: 'Sex', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '��<br>��', width: 50, dataIndex: 'Age', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '����', width: 80, dataIndex: 'AdmLoc', sortable: true, menuDisabled : true, align: 'left'}
			,{header: '����', width: 80, dataIndex: 'AdmWard', sortable: true, menuDisabled : true, align: 'left'}
			,{header: 'ҽ��', width: 60, dataIndex: 'AdmDoc', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '���', width: 100, dataIndex: 'Diagnos', sortable: true, menuDisabled : true, align: 'left'}
			,{header: '��������', width: 80, dataIndex: 'CPWDicDesc', sortable: false, menuDisabled : true, align: 'left'}
			,{header: '״̬', width: 70, dataIndex: 'CPWStatus', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '�Ƿ�<br>����', width: 50, dataIndex: 'IsVarPat', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '��������', width: 70, dataIndex: 'AdmitDate', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '��Ժ����', width: 70, dataIndex: 'DischDate', sortable: true, menuDisabled : true, align: 'center'}
			,{header: 'סԺ<br>����', width: 50, dataIndex: 'AdmDays', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '�״�<br>������', width: 70, dataIndex: 'OperDate', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '��ǰ<br>סԺ��', width: 50, dataIndex: 'OperAdmDays', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '��Ժ���', width: 70, dataIndex: 'OutStatus', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '�Ƿ�<br>Ժ��', width: 50, dataIndex: 'IsInHospInf', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '�Ƿ�<br>����<br>��Ⱦ', width: 50, dataIndex: 'IsOperInf', sortable: true, menuDisabled : true, align: 'center'}
			,{header: 'סԺ��', width: 70, dataIndex: 'HospCost', sortable: true, menuDisabled : true, align: 'center'}
			,{header: 'ҩ��', width: 70, dataIndex: 'DrugCost', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '�����', width: 70, dataIndex: 'LabCost', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '����', width: 70, dataIndex: 'CheckCost', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '�Ĳķ�', width: 70, dataIndex: 'MaterialCost', sortable: true, menuDisabled : true, align: 'center'}
			
			//*****************************************************************
			//��ҽ��ص��ٴ�·��ͳ��ָ��
			//,{header: '�г�ҩ��', width: 70, dataIndex: 'ProprMedCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '�в�ҩ��', width: 70, dataIndex: 'HerbalMedCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '��ҩ��', width: 70, dataIndex: 'WesternMedCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '���Ʒ�', width: 70, dataIndex: 'TherapyCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '��ҽ<br>���Ʒ�', width: 70, dataIndex: 'ChTherapyCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '��ҽ��ɫ<br>�Ʒ���', width: 70, dataIndex: 'CharaTherapyCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '�Ƿ�ʹ��<br>��ҩ��Ƭ', width: 70, dataIndex: 'IsPiecesMed', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '�Ƿ�ʹ��<br>�г�ҩ', width: 70, dataIndex: 'IsProprMed', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '�Ƿ�ʹ��<br>��ɫ�Ʒ�', width: 70, dataIndex: 'IsCharaTherapy', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '�Ƿ�ʹ��<br>��ҽҩ����', width: 80, dataIndex: 'IsChTherapy', sortable: false, menuDisabled : true, align: 'center'}
			//*****************************************************************
			
			,{header: '�Ƿ�<br>ʹ��<br>����ҩ��', width: 50, dataIndex: 'Is3Pharmacy', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '����ҩ��<br>ʹ������', width: 80, dataIndex: 'PharmacyDays', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '����ҩ��<br>ʹ�÷���', width: 80, dataIndex: 'PharmacyCost', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '�Ƿ�Ǽƻ�<br>�ط�����', width: 100, dataIndex: 'TimesOperFlag', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '�Ƿ�Ԥ����<br>����ҩ��ʹ��', width: 100, dataIndex: 'IsPreDrugFlag', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '�Ƿ�<br>����<br>����֢', width: 50, dataIndex: 'IsComplicationFlag', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '��סԺ<br>����', width: 50, dataIndex: 'NextDays', sortable: true, menuDisabled : true, align: 'center'}
			//*******Modified by zhaoyu 2012-11-12 �ٴ�·���±���ϸ����:�Ƿ���ó���,�Ƿ�סԺ�ճ���,�ο�����,�ο�����
			//	CPWCost	CPWDays
			,{header: '�ο�����', width: 80, dataIndex: 'CPWCost', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '�ο�����', width: 70, dataIndex: 'CPWDays', sortable: true, menuDisabled : true, align: 'center'}
			//	WhetherOverCost,WhetherOverDay
			,{header: '�����Ƿ񳬱�', width: 90, dataIndex: 'WhetherOverCost', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '�����Ƿ񳬱�', width: 90, dataIndex: 'WhetherOverDay', sortable: true, menuDisabled : true, align: 'center'}
			//*******
			,{header: 'δ�뾶ԭ��', width: 100, dataIndex: 'NotInCPWReason', sortable: true, menuDisabled : true, align: 'center'}
			
		]
		,viewConfig : {
			//forceFit : true
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
	});
	obj.btnDtlExport = new Ext.Button({
		id : 'btnDtlExport'
		,text: '����EXCEL'
	});
	var dtltitle = "�ٴ�·���±���ϸ���������ƣ�"+aCPWDicDesc+"��ͳ�Ʒ�ʽ��"+aAnalysisRawValue+"��"	//	Modified by zhaoyu 2012-11-23 �ٴ�·���±���ϸ����
	obj.DtlWindow = new Ext.Window({
		id : 'DtlWindow'
		,buttonAlign : 'center'
		,maximized : false
		//,title : '�ٴ�·���±���ϸ'
		,title : dtltitle	//	Modified by zhaoyu 2012-11-23 �ٴ�·���±���ϸ����
		,resizable : false
		,layout : 'fit'
		,width : 900
		,height : 500
		,modal: true
		,items:[
			obj.DtlResultGridPanel
		]
		,buttons:[
			obj.btnDtlExport
		]
	});
	obj.DtlResultGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.ClinPathWayAnalysisSrv';
			param.QueryName = 'QryCPWDischDetail';
			param.Arg1 = aDateFrom
			param.Arg2 = aDateTo
			param.Arg3 = aCPWDID
			param.Arg4 = aAnalysisType
			param.Arg5 = aLoc
			param.ArgCnt = 5;
	});
	obj.DtlResultGridPanelStore.load({});
	InitDtlWindowEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}
