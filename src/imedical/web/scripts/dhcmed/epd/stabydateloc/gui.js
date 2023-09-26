function InitviewScreen(){
	var obj = new Object();
	//******************************Start****************************
	obj.dtFromDate = new Ext.form.DateField({
		id : 'dtFromDate'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 100
		,fieldLabel : '开始日期'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		,value : new Date()
	});
	obj.pConditionChild1 = new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.dtFromDate
		]
	});
	obj.dtToDate = new Ext.form.DateField({
		id : 'dtToDate'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 100
		,fieldLabel : '结束日期'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		,value : new Date()
	});
	obj.pConditionChild2 = new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.dtToDate
		]
	});
	obj.cboHospitalStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboHospitalStore = new Ext.data.Store({
		proxy: obj.cboHospitalStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			/*{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'hosName', mapping: 'hosName'}*/
			{name: 'CTHospID', mapping: 'CTHospID'}
			,{name: 'CTHospDesc', mapping: 'CTHospDesc'}
		])
	});
	obj.cboHospital = new Ext.form.ComboBox({
		id : 'cboHospital'
		,width : 100
		,store : obj.cboHospitalStore
		,minChars : 1
		,displayField : 'CTHospDesc'
		,fieldLabel : '医院'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'CTHospID'
	});
	obj.cboHospitalStoreProxy.on('beforeload', function(objProxy, param){
			/*
			param.ClassName = 'DHCMed.Base.Hospital';
			param.QueryName = 'QueryHosInfo';
			param.ArgCnt = 0;
			*/
			param.ClassName = 'DHCMed.SSService.HospitalSrv';
			param.QueryName = 'QrySSHospByCode';
			param.Arg1      = SSHospCode;
			param.Arg2      = "EPD";
			param.ArgCnt    = 2;
	});
	obj.pConditionChild3 = new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.cboHospital
		]
	});
	obj.cboLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboLocStore = new Ext.data.Store({
		proxy: obj.cboLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			/*{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'} */
			{name: 'LocRowId', mapping: 'LocRowId'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'LocDesc1', mapping: 'LocDesc1'}
		])
	});
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,width : 100
		,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'LocDesc'
		,fieldLabel : '科室'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'LocRowId'
	});
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
			/*
			param.ClassName = 'DHCMed.Base.Ctloc';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboLoc.getRawValue();
			param.Arg2 = '';
			param.Arg3 = "" + "-" + obj.cboHospital.getValue();   //关联科室和医院放一个字段中
			param.ArgCnt = 3;
			*/
			param.ClassName = 'DHCMed.SSService.HospitalSrv';
			param.QueryName = 'QueryLoction';
			param.Arg1 = obj.cboLoc.getRawValue();
			param.Arg2 = '';
			param.Arg3 = '';
			param.Arg4 = 'E|EM';
			param.Arg5 = '';
			param.Arg6 = '';
			param.Arg7 = obj.cboHospital.getValue();
			param.ArgCnt = 7;
	});
	obj.pConditionChild4 = new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.cboLoc
		]
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,text : '查询'
	});
	
	obj.btnExport= new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,text : '导出'
	});
	
	obj.ConditionPanel = new Ext.form.FormPanel({
		id : 'ConditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'column'
		,region : 'north'
		,frame : true
		,height : 75
		,items:[
			obj.pConditionChild1
			,obj.pConditionChild2
			,obj.pConditionChild3
			,obj.pConditionChild4
		]
		,buttons:[
			obj.btnQuery
			,obj.btnExport
		]
	});
	//****************************** End ****************************
	obj.StatDataGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
			,timeout: 300000
			,method:'POST'
	}));
	obj.StatDataGridPanelStore = new Ext.data.Store({
		proxy: obj.StatDataGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DataIndex', mapping: 'DataIndex'}
			,{name: 'DataDesc', mapping: 'DataDesc'}
			,{name: 'EpdNum', mapping: 'EpdNum'}
			,{name: 'EpdRatio', mapping: 'EpdRatio'}
		])
	});
	obj.DataCheckColumn = new Ext.grid.CheckColumn({header : '',	dataIndex : 'checked',width : 40});
	obj.StatDataGridPanel = new Ext.grid.GridPanel({
		id : 'StatDataGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'Loading...'}
		,region : 'west'
		,width : 300
		,split: true
		,minWidth: 10
        ,maxWidth: 500
		,autoScroll : true
		,animCollapse: true
		//,collapsible : true
		//,collapsed : true
		,margins: '0 0 0 5'
		,store : obj.StatDataGridPanelStore
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '科室/疾病', width: 150, dataIndex: 'DataDesc', sortable: false}
			,{header: '病例<br>数量', width: 50, dataIndex: 'EpdNum', sortable: false}
			,{header: '比例', width: 50, dataIndex: 'EpdRatio', sortable: false}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.StatDataGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			forceFit : true
		}
	});
	obj.StatDataGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.EPDService.EpdStaSrv';
			param.QueryName = 'StaEpdByDate';
			param.Arg1 = obj.dtFromDate.getRawValue();
			param.Arg2 = obj.dtToDate.getRawValue();
			//param.Arg3 = obj.cboAdmType.getValue(); // update by  pylian 2015-09-17  fix bug 120754 统计条件去掉就诊类型
			param.Arg3 = obj.cboLoc.getValue();
			param.Arg4 = obj.cboHospital.getValue();
			param.ArgCnt = 4;
	});
	obj.DtlDataGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
			,timeout: 300000
			,method:'POST'
	}));
	obj.DtlDataGridPanelStore = new Ext.data.Store({
		proxy: obj.DtlDataGridPanelStoreProxy,
		reader : new Ext.data.JsonReader({
				root : 'record',
				totalProperty : 'total',
				idProperty : 'RowID'
			}, [
				{ name : 'checked', mapping : 'checked' }
				, { name : 'RowID', mapping : 'RowID' }
				, { name : 'PatientID', mapping : 'PatientID' }
				, { name : 'RegNo', mapping : 'RegNo' }
				, { name : 'PatientName', mapping : 'PatientName' }
				, { name : 'Sex', mapping : 'Sex' }
				, { name : 'Age', mapping : 'Age' }
				, { name : 'DiseaseICD', mapping : 'DiseaseICD' }
				, { name : 'DiseaseName', mapping : 'DiseaseName' }
				, { name : 'ReportDep', mapping : 'ReportDep' }
				, { name : 'RepPlace', mapping : 'RepPlace' }
				, { name : 'RepUserCode', mapping : 'RepUserCode' }
				, { name : 'RepUserName', mapping : 'RepUserName' }
				, { name : 'RepDate', mapping : 'RepDate' }
				, { name : 'RepTime', mapping : 'RepTime' }
				, { name : 'Paadm', mapping : 'Paadm' }
				, { name : 'IsUpload', mapping : 'IsUpload' }
				, { name : 'Status', mapping : 'Status' }
				, { name : 'StatusCode', mapping : 'StatusCode' }
				, { name : 'CheckUserCode', mapping : 'CheckUserCode' }
				, { name : 'CheckUserName', mapping : 'CheckUserName' }
				, { name : 'CheckDate', mapping : 'CheckDate' }
				, { name : 'CheckTime', mapping : 'CheckTime' }
				, { name : 'RepKind', mapping : 'RepKind' }
				, { name : 'RepRank', mapping : 'RepRank' }
				, { name : 'FamName', mapping : 'FamName' }
				, { name : 'Occupation', mapping : 'Occupation' }
				, { name : 'Company', mapping : 'Company' }
				, { name : 'Address', mapping : 'Address' }
				, { name : 'IDAddress', mapping : 'IDAddress' }
				, { name : 'TelPhone', mapping : 'TelPhone' }
				, { name : 'SickDate', mapping : 'SickDate' }
				, { name : 'DiagDate', mapping : 'DiagDate' }
				, { name : 'DeathDate', mapping : 'DeathDate' }
				, { name : 'RepNo', mapping : 'RepNo' }
				, { name : 'PersonalID', mapping : 'PersonalID' }
				, { name : 'DelReason', mapping : 'DelReason' }
				, { name : 'DemoInfo', mapping : 'DemoInfo' }
				,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
				,{name: 'PatLevel', mapping: 'PatLevel'}
			]
		)
	});
	obj.DtlDataGridPanel = new Ext.grid.GridPanel({
		id : 'DtlDataGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'Loading...'}
		,region : 'center'
		,width : '70%'
		,store : obj.DtlDataGridPanelStore
		,columns: [
			new Ext.grid.RowNumberer()
			, { header : '是否上报<br>CDC', width : 80, dataIndex : 'IsUpload', sortable : false, align : 'center' }
			, { header : '报告状态', width : 80, dataIndex : 'Status', align : 'center' 
				, renderer : function(value, metaData, record, rowIndex, colIndex, store) {
					var strRet = "";
					switch (record.get("StatusCode")) {
						case "1" :
							strRet = "<div style='color:red'>" + value + "</div>";
							break;
						case "2" :
							strRet = "<div style='color:green'>" + value + "</div>";
							break;
						case "3" :
							strRet = "<div style='color:orange'>" + value + "</div>";
							break;
						case "4" :
							strRet = "<div style='color:olive'>" + value + "</div>";
							break;
						case "5" :
							strRet = "<div style='color:black'>" + value + "</div>";
							break;
						case "6" :
							strRet = "<div style='color:blue'>" + value + "</div>";
							break;
						case "7" :
							strRet = "<div style='color:gray'>" + value + "</div>";
							break;
						default :
							strRet = "<div style='color:black'>" + value + "</div>";
							break;
					}
					return strRet;
				}
			}
			, { header : '登记号', width : 80, dataIndex : 'RegNo', sortable : false, align : 'center' }
			, { header : '患者姓名', width : 80, dataIndex : 'PatientName', sortable : false, align : 'center' }
			, { header : '性别', width : 40, dataIndex : 'Sex', sortable : false, align : 'center' }
			, { header : '年龄', width : 40, dataIndex : 'Age', sortable : false, align : 'center' }
			, {header : '病人<br>密级', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			, {header : '病人<br>级别', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
			, { header : '现住址', width : 250, dataIndex : 'Address', sortable : false }
			, { header : '疾病名称', width : 120, dataIndex : 'DiseaseName', sortable : false }
			, { header : '病例分类', width : 100, dataIndex : 'RepKind', sortable : false }
			, { header : '联系电话', width : 100, dataIndex : 'TelPhone', sortable : false }
			, { header : '报告人', width : 80, dataIndex : 'RepUserName', sortable : false, align : 'center' }
			, { header : '报告科室', width : 120, dataIndex : 'ReportDep', sortable : true, align : 'center' }
			, { header : '上报位置', width : 80, dataIndex : 'RepPlace', sortable : false, align : 'center' }
			, { header : '卡片编号', width : 120, dataIndex : 'RepNo', sortable : true, align : 'center' }
			, { header : '家长姓名', width : 80, dataIndex : 'FamName', sortable : false, align : 'center' }
			, { header : '身份证号', width : 100, dataIndex : 'PersonalID', sortable : false, align : 'center' }
			, { header : '职业', width : 80, dataIndex : 'Occupation', sortable : false, align : 'center' }
			, { header : '工作单位', width : 150, dataIndex : 'Company', sortable : false, align : 'center' }
			//, { header : '户籍地址', width : 200, dataIndex : 'IDAddress', sortable : false}
			, { header : '疾病等级', width : 100, dataIndex : 'RepRank', sortable : false, align : 'center' }
			, { header : '发病日期', width : 80, dataIndex : 'SickDate', sortable : false, align : 'center' }
			, { header : '诊断日期', width : 80, dataIndex : 'DiagDate', sortable : false, align : 'center' }
			, { header : '死亡日期', width : 80, dataIndex : 'DeathDate', sortable : false, align : 'center' }
			, { header : '报告人工号', width : 80, dataIndex : 'RepUserCode', sortable : false, align : 'center' }
			, { header : '报告日期', width : 80, dataIndex : 'RepDate', sortable : true, align : 'center' }
			, { header : '报告时间', width : 80, dataIndex : 'RepTime', sortable : false, align : 'center' }
			, { header : '审核人', width : 80, dataIndex : 'CheckUserName', sortable : false, align : 'center' }
			, { header : '审核人工号', width : 80, dataIndex : 'CheckUserCode', sortable : false, align : 'center' }
			, { header : '审核日期', width : 80, dataIndex : 'CheckDate', sortable : false, align : 'center' }
			, { header : '审核时间', width : 80, dataIndex : 'CheckTime', sortable : false, align : 'center' }
			, { header : '退回/删除原因', width : 80, dataIndex : 'DelReason', sortable : false }
			, { header : '备注', width : 80, dataIndex : 'DemoInfo', sortable : false }
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.DtlDataGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
	    ,iconCls: 'icon-grid'
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
	obj.DtlDataGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.EPDService.EpdStaSrv';
			param.QueryName = 'QueryEpdRepByDate';
			param.Arg1 = obj.dtFromDate.getRawValue();
			param.Arg2 = obj.dtToDate.getRawValue();
			//param.Arg3 = obj.cboAdmType.getValue(); // update by  pylian 2015-09-17  fix bug 120754 统计条件去掉就诊类型
			param.Arg3 = obj.cboLoc.getValue();
			param.Arg4 = obj.cboHospital.getValue();
			param.ArgCnt = 4;
	});
	obj.DataGridPanel = new Ext.Panel({
		id : 'DataGridPanel'
		,buttonAlign : 'center'
		,layout : 'border'
		,region : 'center'
		,items:[
			obj.StatDataGridPanel
			,obj.DtlDataGridPanel
		]
	});
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [
			obj.ConditionPanel
			,obj.DataGridPanel
		]
	});
	
	InitviewScreenEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}

