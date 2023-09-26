
//function InitDtlWindow(aDateFrom,aDateTo,aCPWDID,aAnalysisType,aLoc){
//	Modified by zhaoyu 2012-11-23 临床路径月报明细标题
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
			//中医相关的临床路径统计指标
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
			//*******Modified by zhaoyu 2012-11-12 临床路径月报明细增加:是否费用超标,是否住院日超标,参考费用,参考天数
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
			,{header: '登记号', width: 70, dataIndex: 'PapmiNo', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '病案号', width: 70, dataIndex: 'InMedicare', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '姓名', width: 70, dataIndex: 'PatName', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '性<br>别', width: 50, dataIndex: 'Sex', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '年<br>龄', width: 50, dataIndex: 'Age', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '科室', width: 80, dataIndex: 'AdmLoc', sortable: true, menuDisabled : true, align: 'left'}
			,{header: '病区', width: 80, dataIndex: 'AdmWard', sortable: true, menuDisabled : true, align: 'left'}
			,{header: '医生', width: 60, dataIndex: 'AdmDoc', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '诊断', width: 100, dataIndex: 'Diagnos', sortable: true, menuDisabled : true, align: 'left'}
			,{header: '病种名称', width: 80, dataIndex: 'CPWDicDesc', sortable: false, menuDisabled : true, align: 'left'}
			,{header: '状态', width: 70, dataIndex: 'CPWStatus', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '是否<br>变异', width: 50, dataIndex: 'IsVarPat', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '就诊日期', width: 70, dataIndex: 'AdmitDate', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '出院日期', width: 70, dataIndex: 'DischDate', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '住院<br>天数', width: 50, dataIndex: 'AdmDays', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '首次<br>手术日', width: 70, dataIndex: 'OperDate', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '术前<br>住院日', width: 50, dataIndex: 'OperAdmDays', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '出院情况', width: 70, dataIndex: 'OutStatus', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '是否<br>院感', width: 50, dataIndex: 'IsInHospInf', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '是否<br>手术<br>感染', width: 50, dataIndex: 'IsOperInf', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '住院费', width: 70, dataIndex: 'HospCost', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '药费', width: 70, dataIndex: 'DrugCost', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '检验费', width: 70, dataIndex: 'LabCost', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '检查费', width: 70, dataIndex: 'CheckCost', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '耗材费', width: 70, dataIndex: 'MaterialCost', sortable: true, menuDisabled : true, align: 'center'}
			
			//*****************************************************************
			//中医相关的临床路径统计指标
			//,{header: '中成药费', width: 70, dataIndex: 'ProprMedCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '中草药费', width: 70, dataIndex: 'HerbalMedCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '西药费', width: 70, dataIndex: 'WesternMedCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '治疗费', width: 70, dataIndex: 'TherapyCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '中医<br>治疗费', width: 70, dataIndex: 'ChTherapyCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '中医特色<br>疗法费', width: 70, dataIndex: 'CharaTherapyCost', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '是否使用<br>中药饮片', width: 70, dataIndex: 'IsPiecesMed', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '是否使用<br>中成药', width: 70, dataIndex: 'IsProprMed', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '是否使用<br>特色疗法', width: 70, dataIndex: 'IsCharaTherapy', sortable: false, menuDisabled : true, align: 'center'}
			//,{header: '是否使用<br>中医药治疗', width: 80, dataIndex: 'IsChTherapy', sortable: false, menuDisabled : true, align: 'center'}
			//*****************************************************************
			
			,{header: '是否<br>使用<br>抗菌药物', width: 50, dataIndex: 'Is3Pharmacy', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '抗菌药物<br>使用天数', width: 80, dataIndex: 'PharmacyDays', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '抗菌药物<br>使用费用', width: 80, dataIndex: 'PharmacyCost', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '是否非计划<br>重返手术', width: 100, dataIndex: 'TimesOperFlag', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '是否预防性<br>抗菌药物使用', width: 100, dataIndex: 'IsPreDrugFlag', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '是否<br>常见<br>并发症', width: 50, dataIndex: 'IsComplicationFlag', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '再住院<br>天数', width: 50, dataIndex: 'NextDays', sortable: true, menuDisabled : true, align: 'center'}
			//*******Modified by zhaoyu 2012-11-12 临床路径月报明细增加:是否费用超标,是否住院日超标,参考费用,参考天数
			//	CPWCost	CPWDays
			,{header: '参考费用', width: 80, dataIndex: 'CPWCost', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '参考天数', width: 70, dataIndex: 'CPWDays', sortable: true, menuDisabled : true, align: 'center'}
			//	WhetherOverCost,WhetherOverDay
			,{header: '费用是否超标', width: 90, dataIndex: 'WhetherOverCost', sortable: true, menuDisabled : true, align: 'center'}
			,{header: '天数是否超标', width: 90, dataIndex: 'WhetherOverDay', sortable: true, menuDisabled : true, align: 'center'}
			//*******
			,{header: '未入径原因', width: 100, dataIndex: 'NotInCPWReason', sortable: true, menuDisabled : true, align: 'center'}
			
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
		,text: '导出EXCEL'
	});
	var dtltitle = "临床路径月报明细（病种名称："+aCPWDicDesc+"；统计方式："+aAnalysisRawValue+"）"	//	Modified by zhaoyu 2012-11-23 临床路径月报明细标题
	obj.DtlWindow = new Ext.Window({
		id : 'DtlWindow'
		,buttonAlign : 'center'
		,maximized : false
		//,title : '临床路径月报明细'
		,title : dtltitle	//	Modified by zhaoyu 2012-11-23 临床路径月报明细标题
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
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}
