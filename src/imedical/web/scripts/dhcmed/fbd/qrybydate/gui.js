// dhcmed.fbd.qrybydate.csp
function InitviewScreen() {
	
	var obj = new Object();
	
	obj.dtStaDate = new Ext.form.DateField({
		id : 'dtStaDate'
		,fieldLabel : '开始日期'
		,labelSeparator :''
		,width : 70
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,anchor : '99%'
		,value : new Date()
	});
	
	obj.dtEndDate = new Ext.form.DateField({
		id : 'dtEndDate'
		,fieldLabel : '结束日期'
		,labelSeparator :''
		,width : 70
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,anchor : '99%'
		,value : new Date()
	});
	
	obj.cboDateType = new Ext.form.ComboBox({
		id : 'cboDateType'
		,fieldLabel : '日期类型'
		,labelSeparator :''
		,width : 100
		,store : new Ext.data.ArrayStore({
			id : 'cboDateTypeStore'
			,fields : [ 'Code', 'Desc' ]
			,data : [ ['IndexReportDate', '报告日期'], ['IndexCheckDate', '审核日期'] ]
		})
		,valueField : 'Code'
		,displayField : 'Desc'
		,editable : true
		,minChars : 1
		,triggerAction : 'all'
		,anchor : '99%'
		,mode : 'local'
	});
	
	obj.cboHospitalStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboHospitalStore = new Ext.data.Store({
		proxy : obj.cboHospitalStoreProxy,
		reader : new Ext.data.JsonReader({
				root : 'record',
				totalProperty : 'total',
				idProperty : 'rowid'
		}, [
				{name: 'CTHospID', mapping: 'CTHospID'}
				,{name: 'CTHospDesc', mapping: 'CTHospDesc'}
			])
	});
	obj.cboHospital = new Ext.form.ComboBox({
		id : 'cboHospital',
		width : 100,
		store : obj.cboHospitalStore,
		minChars : 1,
		displayField : 'CTHospDesc',
		fieldLabel : '医院',
		labelSeparator :'',
		editable : true,
		triggerAction : 'all',
		anchor : '99%',
		valueField : 'CTHospID'
	});
	obj.cboHospitalStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.HospitalSrv';
		param.QueryName = 'QrySSHospByCode';
		param.Arg1      = SSHospCode;
		param.Arg2      = "FBD";
		param.ArgCnt    = 2;
	});
	
	obj.cboPatType = new Ext.form.ComboBox({
		id : 'cboPatType'
		,fieldLabel : '上报位置'
		,labelSeparator :''
		,width : 100
		,store : new Ext.data.ArrayStore({
			id : 'cboPatTypeStore'
			,fields : [ 'Code', 'Desc' ]
			,data : [ ['O', '门诊'], ['I', '病房'], ['E', '急诊'] ]
		})
		,valueField : 'Code'
		,displayField : 'Desc'
		,editable : true
		,minChars : 1
		,triggerAction : 'all'
		,anchor : '99%'
		,mode : 'local'
	});
	
	obj.cboDiseaseCateStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboDiseaseCateStore = new Ext.data.Store({
		proxy : obj.cboDiseaseCateStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'myid'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'myid', mapping : 'myid' }
			,{ name : 'Description', mapping : 'Description' }
		])
	});
	obj.cboDiseaseCate = new Ext.form.ComboBox({
		id : 'cboDiseaseCate'
		,fieldLabel : '疾病分类'
		,labelSeparator :''
		,width : 100
		,store : obj.cboDiseaseCateStore
		,valueField : 'myid'
		,displayField : 'Description'
		,editable : true
		,minChars : 1
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.cboDiseaseCateStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QryDictionary';
		param.Arg1 = 'FBDDiseaseType';
		param.Arg2 = '1';
		param.ArgCnt = 2;
	});
	
	obj.cboDiseaseDescStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboDiseaseDescStore = new Ext.data.Store({
		proxy : obj.cboDiseaseDescStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ID'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'ID', mapping : 'ID' }
			,{ name : 'IDDesc', mapping : 'IDDesc' }
		])
	});
	obj.cboDiseaseDesc = new Ext.form.ComboBox({
		id : 'cboDiseaseDesc'
		,fieldLabel : '疾病名称'
		,labelSeparator :''
		,width : 100
		,store : obj.cboDiseaseDescStore
		,valueField : 'ID'
		,displayField : 'IDDesc'
		,editable : true
		,minChars : 1
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.cboDiseaseDescStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.DiseaseSrv';
		param.QueryName = 'QryDisease';
		param.Arg1 = 'FBD';
		param.Arg2 = '1';
		param.Arg3 = obj.cboDiseaseCate.getValue()==""?-1:obj.cboDiseaseCate.getValue();
		param.ArgCnt = 3;
	});
	
	obj.cboReportLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboReportLocStore = new Ext.data.Store({
		proxy : obj.cboReportLocStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'CTLocID'
		},[
			{name: 'LocRowId', mapping: 'LocRowId'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'LocDesc1', mapping: 'LocDesc1'}
		])
	});
	obj.cboReportLoc = new Ext.form.ComboBox({
		id : 'cboReportLoc'
		,fieldLabel : '报告科室'
		,labelSeparator :''
		,width : 100
		,store : obj.cboReportLocStore
		,valueField : 'LocRowId'
		,displayField : 'LocDesc'
		,editable : true
		,minChars : 1
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.cboReportLocStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.HospitalSrv';
		param.QueryName = 'QueryLoction';
		param.Arg1 = obj.cboReportLoc.getRawValue();
		param.Arg2 = '';
		param.Arg3 = '';
		param.Arg4 = 'E|EM';
		param.Arg5 = '';
		param.Arg6 = '';
		param.Arg7 = obj.cboHospital.getValue();
		param.ArgCnt = 7;
	});
	
	var arrayStatus = new Array();
	var objReportSrv = ExtTool.StaticServerObject("DHCMed.FBDService.ReportSrv");
	var listStatus = objReportSrv.GetDicForCheckGroup("FBDReportStatus","1");
	listStatus = listStatus.split(",");
	for (var i=0; i<listStatus.length; i++) {
		var tmpStatus = listStatus[i].split("^");
		var tmpItem = { boxLabel : tmpStatus[1], name : tmpStatus[0], checked : tmpStatus[0]==1 }
		arrayStatus[arrayStatus.length] = tmpItem;
	}
	obj.chkReportStatus = new Ext.form.CheckboxGroup({
		id : 'chkReportStatus'
		,xtype : 'checkboxgroup'
		,fieldLabel : '报告状态'
		,labelSeparator :''
		,columns : 3
		,items : arrayStatus
		,anchor : '99%'
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,text : '查询'
	});
	
	obj.btnExportSel = new Ext.Button({
		id : 'btnExportSel'
		,iconCls : 'icon-export'
		,text : '选择导出'
	});
	
	obj.btnExportAll = new Ext.Button({
		id : 'btnExportAll'
		,iconCls : 'icon-export'
		,text : '全部导出'
	});
	
	obj.pnCol1 = new Ext.Panel({
		id : 'pnCol1'
		,layout : 'form'
		,labelAlign : 'right'
		,columnWidth : .30
		,items : [
			obj.cboHospital
			,obj.cboDiseaseCate
			,obj.cboReportLoc
		]
	});
	
	obj.pnCol2 = new Ext.Panel({
		id : 'pnCol2'
		,layout : 'form'
		,labelAlign : 'right'
		,columnWidth : .37
		,items : [
			{
				layout : 'column',
				items : [
				{
					layout : 'form',
					columnWidth : 0.55,
					labelWidth : 100,
					items : [obj.dtStaDate]
				}, {
					layout : 'form',
					columnWidth : 0.45,
					labelWidth : 70,
					items : [obj.dtEndDate]
				}]	
			}
			,obj.cboDiseaseDesc
			,obj.cboPatType
		]
	});
	
	obj.pnCol3 = new Ext.Panel({
		id : 'pnCol3'
		,layout : 'form'
		,labelAlign : 'right'
		,columnWidth : .33
		,items : [
			obj.cboDateType
			,obj.chkReportStatus
		]
	});
	
	obj.pnCondition = new Ext.Panel({
		id : 'pnCondition'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 70
		,bodyBorder : 'padding : 0 0 0 0'
		,region : 'north'
		,height : 140
		,frame : true
		,layout : 'column'
		,items : [
			obj.pnCol1
			,obj.pnCol2
			,obj.pnCol3
		]
		,buttons : [
			obj.btnQuery
			,obj.btnExportSel
			,obj.btnExportAll
		]
	});
	
	obj.gridReportStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
		,timeout : 300000
	}));
	obj.gridReportStore = new Ext.data.Store({
		proxy : obj.gridReportStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ID'
		},[
			{ name : 'ID', mapping : 'ID' }
			,{ name : 'EpisodeID', mapping : 'EpisodeID' }
			,{ name : 'PatientID', mapping : 'PatientID' }
			,{ name : 'PapmiNo', mapping : 'PapmiNo' }
			,{ name : 'PatName', mapping : 'PatName' }
			,{ name : 'Sex', mapping : 'Sex' }
			,{ name : 'PatAge', mapping : 'PatAge' }
			,{ name : 'AdmType', mapping : 'AdmType' }
			,{ name : 'AdmTypeDesc', mapping : 'AdmTypeDesc' }
			,{ name : 'PersonalID', mapping : 'PersonalID' }
			,{ name : 'CardNo', mapping : 'CardNo' }
			,{ name : 'Contactor', mapping : 'Contactor' }
			,{ name : 'Telephone', mapping : 'Telephone' }
			,{ name : 'Company', mapping : 'Company' }
			,{ name : 'CurrAddress', mapping : 'CurrAddress' }
			,{ name : 'Address', mapping : 'Address' }
			,{ name : 'CateID', mapping : 'CateID' }
			,{ name : 'CateDesc', mapping : 'CateDesc' }
			,{ name : 'DiseaseID', mapping : 'DiseaseID' }
			,{ name : 'DiseaseDesc', mapping : 'DiseaseDesc' }
			,{ name : 'DiseaseText', mapping : 'DiseaseText' }
			,{ name : 'StatusID', mapping : 'StatusID' }
			,{ name : 'StatusCode', mapping : 'StatusCode' }
			,{ name : 'StatusDesc', mapping : 'StatusDesc' }
			,{ name : 'AreaID', mapping : 'AreaID' }
			,{ name : 'AreaDesc', mapping : 'AreaDesc' }
			,{ name : 'OccupationID', mapping : 'OccupationID' }
			,{ name : 'OccupationDesc', mapping : 'OccupationDesc' }
			,{ name : 'IsInHosp', mapping : 'IsInHosp' }
			,{ name : 'IsInHospDesc', mapping : 'IsInHospDesc' }
			,{ name : 'IsUseAnti', mapping : 'IsUseAnti' }
			,{ name : 'IsUseAntiDesc', mapping : 'IsUseAntiDesc' }
			,{ name : 'UseAntiDesc', mapping : 'UseAntiDesc' }
			,{ name : 'SickDate', mapping : 'SickDate' }
			,{ name : 'SickTime', mapping : 'SickTime' }
			,{ name : 'AdmitDate', mapping : 'AdmitDate' }
			,{ name : 'AdmitTime', mapping : 'AdmitTime' }
			,{ name : 'DeathDate', mapping : 'DeathDate' }
			,{ name : 'DeathTime', mapping : 'DeathTime' }
			,{ name : 'RepUserName', mapping : 'RepUserName' }
			,{ name : 'ReportDate', mapping : 'ReportDate' }
			,{ name : 'ReportTime', mapping : 'ReportTime' }
			,{ name : 'ChkUserName', mapping : 'ChkUserName' }
			,{ name : 'CheckDate', mapping : 'CheckDate' }
			,{ name : 'CheckTime', mapping : 'CheckTime' }
			,{ name : 'ReportLoc', mapping : 'ReportLoc' }
			,{ name : 'ReportLocDesc', mapping : 'ReportLocDesc' }
			,{ name : 'PreDiagnos', mapping : 'PreDiagnos' }
			,{ name : 'Anamnesis', mapping : 'Anamnesis' }
			,{ name : 'Resume', mapping : 'Resume' }
			,{ name : 'EncryptLevel', mapping : 'EncryptLevel'}
			,{ name : 'PatLevel', mapping : 'PatLevel'}
		])
	});
	obj.DataRowNumberer = new Ext.grid.RowNumberer({
		header : '序号'
		,width : 40
	});
	obj.DataCheckColumn = new Ext.grid.CheckColumn({
		header : '选择'
		,width : 40
		,dataIndex : 'checked'
	});
	obj.gridReport = new Ext.grid.GridPanel({
		id : 'gridReport'
		,header : true
		,store : obj.gridReportStore
		,columnLines : true
		,loadMask : true
		,region : 'center'
		,frame : true
		,autoScroll : true
		,columns : [
			obj.DataRowNumberer, obj.DataCheckColumn
			,{ header : '报告编号', width : 120, dataIndex : 'CardNo', sortable : true }
			,{ header : '报告状态', width : 80, dataIndex : 'StatusDesc', sortable : true
				,renderer : function(value, metaData, record, rowIndex, colIndex, store) {
					var retStr = "", tmpStatusCode = record.get("StatusCode");
					if (tmpStatusCode==1) {
						retStr = "<div style='color:red'>" + value + "</div>";
					} else if (tmpStatusCode==2) {
						retStr = "<div style='color:green'>" + value + "</div>";
					} else if (tmpStatusCode==3) {
						retStr = "<div style='color:black'>" + value + "</div>";
					} else if (tmpStatusCode==4) {
						retStr = "<div style='color:blue'>" + value + "</div>";
					} else if (tmpStatusCode==5) {
						retStr = "<div style='color:gray'>" + value + "</div>";
					} else {
						retStr = "<div style='color:black'>" + value + "</div>";
					}
					return retStr;
				}
			}
			,{ header : '登记号', width : 80, dataIndex : 'PapmiNo', sortable : true }
			,{ header : '姓名', width : 80, dataIndex : 'PatName', sortable : true }
			,{ header : '性别', width : 80, dataIndex : 'Sex', sortable : true }
			,{ header : '年龄', width : 80, dataIndex : 'PatAge', sortable : true }
			,{header : '病人<br>密级', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header : '病人<br>级别', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
			,{ header : '上报位置', width : 80, dataIndex : 'AdmTypeDesc', sortable : true }
			,{ header : '身份证号', width : 120, dataIndex : 'PersonalID', sortable : true }
			,{ header : '联系人', width : 80, dataIndex : 'Contactor', sortable : true }
			,{ header : '联系电话', width : 80, dataIndex : 'Telephone', sortable : true }
			,{ header : '单位', width : 200, dataIndex : 'Company', sortable : true }
			,{ header : '现住址', width : 200, dataIndex : 'Address', sortable : true }
			,{ header : '疾病分类', width : 120, dataIndex : 'CateDesc', sortable : true }
			,{ header : '疾病名称', width : 120, dataIndex : 'DiseaseDesc', sortable : true }
			,{ header : '疾病备注', width : 120, dataIndex : 'DiseaseText', sortable : true }
			,{ header : '病人属于', width : 100, dataIndex : 'AreaDesc', sortable : true }
			,{ header : '病人职业', width : 100, dataIndex : 'OccupationDesc', sortable : true }
			,{ header : '是否住院', width : 80, dataIndex : 'IsInHospDesc', sortable : true }
			,{ header : '就诊前是否<br>使用抗生素', width : 80, dataIndex : 'IsUseAntiDesc', sortable : true }
			,{ header : '就诊前使用<br>抗生素名称', width : 120, dataIndex : 'UseAntiDesc', sortable : true }
			,{ header : '发病日期', width : 80, dataIndex : 'SickDate', sortable : true }
			,{ header : '就诊日期', width : 80, dataIndex : 'AdmitDate', sortable : true }
			,{ header : '死亡日期', width : 80, dataIndex : 'DeathDate', sortable : true }
			,{ header : '报告人', width : 80, dataIndex : 'RepUserName', sortable : true }
			,{ header : '报告日期', width : 80, dataIndex : 'ReportDate', sortable : true }
			,{ header : '报告时间', width : 80, dataIndex : 'ReportTime', sortable : true }
			,{ header : '审核人', width : 80, dataIndex : 'ChkUserName', sortable : true }
			,{ header : '审核日期', width : 80, dataIndex : 'CheckDate', sortable : true }
			,{ header : '审核时间', width : 80, dataIndex : 'CheckTime', sortable : true }
			,{ header : '上报科室', width : 80, dataIndex : 'ReportLocDesc', sortable : true }
			,{ header : '初步诊断', width : 120, dataIndex : 'PreDiagnos', sortable : true }
			,{ header : '既往病史', width : 120, dataIndex : 'Anamnesis', sortable : true }
			,{ header : '备注', width : 120, dataIndex : 'Resume', sortable : true }
		]
		,plugins : obj.DataCheckColumn
		,iconCls : 'icon-grid'
		,viewConfig : {
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) { return; }
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw<20 || csize.height<20)) { return; }
				if (g.autoHeight) {
					if (this.innerHd) { this.innerHd.style.width = vw + "px"; }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - hdHeight;
					this.scroller.setSize(vw, vh);
					if (this.innerHd) { this.innerHd.style.width = vw + "px"; }
				}
				if (this.forceFit) {
					if (this.lastViewWidth!=vw) {
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
	obj.gridReportStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.FBDService.ReportSrv';
		param.QueryName = 'QryReportByDate';
		param.Arg1 = obj.dtStaDate.getRawValue();
		param.Arg2 = obj.dtEndDate.getRawValue();
		param.Arg3 = obj.cboDateType.getValue();
		param.Arg4 = obj.GetSelStatus();
		param.Arg5 = obj.cboReportLoc.getValue();
		param.Arg6 = obj.cboPatType.getValue();
		param.Arg7 = obj.cboDiseaseCate.getValue();
		param.Arg8 = obj.cboDiseaseDesc.getValue();
		param.Arg9 = obj.cboHospital.getValue();
		param.ArgCnt = 9;
	});
	
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [ obj.pnCondition, obj.gridReport ]
	});
	
	obj.GetSelStatus = function() {
		var chkStatus = obj.chkReportStatus.getValue(), selStatus = "";
		for (var i=0; i<chkStatus.length; i++) {
			selStatus = selStatus + chkStatus[i].getName() + ",";
		}
		if (selStatus!="") { selStatus = selStatus.substring(0, selStatus.length-1); }
		return selStatus;
	}
	
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}