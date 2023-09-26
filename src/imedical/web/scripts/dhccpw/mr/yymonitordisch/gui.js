
function InitMonitorViewport(){
	var obj = new Object();
	obj.dfDateFrom = new Ext.form.DateField({
		id : 'dfDateFrom'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '开始日期'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		,value : new Date()
	});
	obj.pConditionChild1 = new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign : 'center'
		,columnWidth : .17
		,layout : 'form'
		,items:[
			obj.dfDateFrom
		]
	});
	obj.dfDateTo = new Ext.form.DateField({
		id : 'dfDateTo'
		,width : 100
		,fieldLabel : '结束日期'
		,altFormats : 'Y-m-d|d/m/Y'
		,format : 'Y-m-d'
		,anchor : '99%'
		,value : new Date()
	});
	obj.pConditionChild2 = new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign : 'center'
		,columnWidth : .17
		,layout : 'form'
		,items:[
			obj.dfDateTo
		]
	});
	obj.cboStatusStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboStatusStore = new Ext.data.Store({
		proxy: obj.cboStatusStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CPWTypeCode'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CPWTypeID', mapping: 'CPWTypeID'}
			,{name: 'CPWTypeCode', mapping: 'CPWTypeCode'}
			,{name: 'CPWTypeDesc', mapping: 'CPWTypeDesc'}
		])
	});
	obj.cboStatus = new Ext.form.ComboBox({
		id : 'cboStatus'
		,listEmptyText : '入径'
		,width : 50
		,store : obj.cboStatusStore
		,minChars : 1
		,displayField : 'CPWTypeDesc'
		,fieldLabel : '状态'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'CPWTypeCode'
});
	obj.pConditionChild3 = new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign : 'center'
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.cboStatus
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
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,width : 100
		,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : '科室'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'CTLocID'
});
	obj.pConditionChild4 = new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.cboLoc
		]
	});
	obj.cboWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboWardStore = new Ext.data.Store({
		proxy: obj.cboWardStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.cboWard = new Ext.form.ComboBox({
		id : 'cboWard'
		,width : 100
		,store : obj.cboWardStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : '病区'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'CTLocID'
});
	obj.pConditionChild5 = new Ext.Panel({
		id : 'pConditionChild5'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.cboWard
		]
	});
	obj.chkSelect = new Ext.form.Checkbox({
		id : 'chkSelect'
		,fieldLabel : '是否筛选'
		,anchor : '99%'
		,checked : false
	});
	obj.pConditionChild6 = new Ext.Panel({
		id : 'pConditionChild6'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
			obj.chkSelect
		]
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,width : 80
		,clearCls : 'icon-find'
		,text : '查询'
		,disabled : false
	});
	obj.btnFromShow = new Ext.Button({
		id : 'btnFromShow'
		,width : 80
		,clearCls : 'icon-menudic'
		,text : '表单展现'
		,disabled : false
	});
	obj.btnVarRecord = new Ext.Button({
		id : 'btnVarRecord'
		,width : 80
		,clearCls : 'icon-menudic'
		,text : '变异记录'
		,disabled : false
	});
	obj.btnOeordItem = new Ext.Button({
		id : 'btnOeordItem'
		,width : 80
		,clearCls : 'icon-menudic'
		,text : '医嘱单'
		,disabled : false
		,hidden : true //modified by LiYang 2011-04-08
	});
	obj.btnMonitorRst = new Ext.Button({
		id : 'btnMonitorRst'
		,width : 80
		,clearCls : 'icon-menudic'
		,text : '监控结果'
		,disabled : false
		,hidden : true //modified by LiYang 2011-04-08
	});
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,text: '导出EXCEL'
	});
	obj.btnPrintForm = new Ext.Button({
		id : 'btnPrintForm'
		,text: '打印表单'
	});
	obj.ConditionSubPanel = new Ext.form.FormPanel({
		id : 'ConditionSubPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'column'
		,frame : true
		,items:[
			obj.pConditionChild1
			,obj.pConditionChild2
			,obj.pConditionChild3
			,obj.pConditionChild4
			,obj.pConditionChild5
			,obj.pConditionChild6
		]
		,buttons:[
			obj.btnQuery
			,obj.btnFromShow
			,obj.btnVarRecord
			,obj.btnMonitorRst
			,obj.btnOeordItem
			,obj.btnExport
			,obj.btnPrintForm
		]
	});
	obj.ConditionPanel = new Ext.Panel({
		id : 'ConditionPanel'
		,height : 100
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'fit'
		,title : '出院查询'
		,items:[
			obj.ConditionSubPanel
		]
	});
	
	obj.ResultGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ResultGridPanelStore = new Ext.data.Store({
		proxy: obj.ResultGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Paadm', mapping: 'Paadm'}
			,{name: 'PathwayDR', mapping: 'PathwayDR'}
			,{name: 'PathWayDesc', mapping: 'PathWayDesc'}
			,{name: 'PathWayEpDR', mapping: 'PathWayEpDR'}
			,{name: 'PathWayEpDesc', mapping: 'PathWayEpDesc'}
			,{name: 'EpStepDR', mapping: 'EpStepDR'}
			,{name: 'EPStepDesc', mapping: 'EPStepDesc'}
			,{name: 'Status', mapping: 'Status'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'InDoctorDR', mapping: 'InDoctorDR'}
			,{name: 'InDoctorDesc', mapping: 'InDoctorDesc'}
			,{name: 'InDate', mapping: 'InDate'}
			,{name: 'InTime', mapping: 'InTime'}
			,{name: 'OutDoctorDR', mapping: 'OutDoctorDR'}
			,{name: 'OutDoctorDesc', mapping: 'OutDoctorDesc'}
			,{name: 'OutDate', mapping: 'OutDate'}
			,{name: 'OutTime', mapping: 'OutTime'}
			,{name: 'OutReasonDR', mapping: 'OutReasonDR'}
			,{name: 'OutReasonDesc', mapping: 'OutReasonDesc'}
			,{name: 'UpdateUserDR', mapping: 'UpdateUserDR'}
			,{name: 'UpdateUserDesc', mapping: 'UpdateUserDesc'}
			,{name: 'UpdateDate', mapping: 'UpdateDate'}
			,{name: 'UpdateTime', mapping: 'UpdateTime'}
			,{name: 'Comments', mapping: 'Comments'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'InMedicare', mapping: 'InMedicare'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Birthday', mapping: 'Birthday'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'PersonalID', mapping: 'PersonalID'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'AdmitTime', mapping: 'AdmitTime'}
			,{name: 'DisDate', mapping: 'DisDate'}
			,{name: 'DisTime', mapping: 'DisTime'}
			,{name: 'AdmLoc', mapping: 'AdmLoc'}
			,{name: 'AdmWard', mapping: 'AdmWard'}
			,{name: 'AdmRoom', mapping: 'AdmRoom'}
			,{name: 'AdmBed', mapping: 'AdmBed'}
			,{name: 'AdmDoc', mapping: 'AdmDoc'}
			,{name: 'AdmStatus', mapping: 'AdmStatus'}
			,{name: 'AdmDays', mapping: 'AdmDays'}
			,{name: 'RefCost', mapping: 'RefCost'}
			,{name: 'RefDays', mapping: 'RefDays'}
			,{name: 'CountCost', mapping: 'CountCost'}
			,{name: 'DrugRatio', mapping: 'DrugRatio'}
			,{name: 'ErrFlag', mapping: 'ErrFlag'}
			,{name: 'VarCount', mapping: 'VarCount'}
			,{name: 'VarReason', mapping: 'VarReason'}
		])
	});
	obj.ResultGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.ResultGridPanel = new Ext.grid.GridPanel({
		id : 'ResultGridPanel'
		,loadMask : true
		,store : obj.ResultGridPanelStore
		,region : 'center'
		,frame : true
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '登记号', width: 70, dataIndex: 'PapmiNo', sortable: true}
			,{header: '病案号', width: 70, dataIndex: 'InMedicare', sortable: true}
			,{header: '姓名', width: 60, dataIndex: 'PatName', sortable: true}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: true}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: true}
			//,{header: '身份证号', width: 120, dataIndex: 'PersonalID', sortable: true}
			/*,{
				header: '医嘱单',
				width: 80,
				dataIndex: 'Paadm',
				renderer : function(v, m, rd, r, c, s){
					var EpisodeID = rd.get("Paadm");
					//return " <a href='#' onclick='OeordItemLookUpHeader("+EpisodeID+")');'>&nbsp;" + v + "&nbsp; </a>";
					return " <a href='#' onclick='OeordItemLookUpHeader("+EpisodeID+")');'>&nbsp;查看医嘱&nbsp; </a>";
				}
			},{
				header: '监控结果',
				width: 80,
				dataIndex: 'Rowid',
				renderer : function(v, m, rd, r, c, s){
					var PathWayID = rd.get("Rowid");
					var UserID = session['LOGON.USERID'];
					//return " <a href='#' onclick='MonitorRstLookUpHeader("+PathWayID+","+UserID+")');'>&nbsp;" + v + "&nbsp; </a>";
					return " <a href='#' onclick='MonitorRstLookUpHeader("+PathWayID+","+UserID+")');'>&nbsp;查看结果&nbsp; </a>";
				}
			}
			,{
				header: '变异记录',
				width: 80,
				renderer : function(v, m, rd, r, c, s){
					var PathWayID = rd.get("Rowid");
					var UserID = session['LOGON.USERID'];
					//return " <a href='#' onclick='VarianceRecordHeader("+PathWayID+","+UserID+")');'>&nbsp;" + v + "&nbsp; </a>";
					return " <a href='#' onclick='VarianceRecordHeader("+PathWayID+","+UserID+")');'>&nbsp;变异记录&nbsp; </a>";
				}
			}*/
			,{header: '临床路径', width: 200, dataIndex: 'PathWayDesc', sortable: true}
			,{header: '阶段', width: 100, dataIndex: 'PathWayEpDesc', sortable: true}
			//,{header: '步骤', width: 100, dataIndex: 'EPStepDesc', sortable: true}
			,{header: '状态', width: 50, dataIndex: 'StatusDesc', sortable: true}
			,{header: '入径人', width: 60, dataIndex: 'InDoctorDesc', sortable: true}
			,{header: '入径日期', width: 80, dataIndex: 'InDate', sortable: true}
			//,{header: '入径时间', width: 60, dataIndex: 'InTime', sortable: true}
			,{header: '出径人', width: 60, dataIndex: 'OutDoctorDesc', sortable: true}
			,{header: '出径日期', width: 80, dataIndex: 'OutDate', sortable: true}
			//,{header: '出径时间', width: 60, dataIndex: 'OutTime', sortable: true}
			,{header: '入院日期', width: 80, dataIndex: 'AdmitDate', sortable: true}
			//,{header: '入院时间', width: 60, dataIndex: 'AdmitTime', sortable: true}
			,{header: '出院日期', width: 80, dataIndex: 'DisDate', sortable: true}
			//,{header: '出院时间', width: 60, dataIndex: 'DisTime', sortable: true}
			,{header: '科室', width: 150, dataIndex: 'AdmLoc', sortable: true}
			,{header: '病区', width: 150, dataIndex: 'AdmWard', sortable: true}
			//,{header: '房间', width: 60, dataIndex: 'AdmRoom', sortable: true}
			//,{header: '床号', width: 60, dataIndex: 'AdmBed', sortable: true}
			,{header: '医生', width: 60, dataIndex: 'AdmDoc', sortable: true}
			//,{header: '状态', width: 100, dataIndex: 'AdmStatus', sortable: true}
			,{header: '参考费用', width: 60, dataIndex: 'RefCost', sortable: false}
			,{header: '实际费用', width: 60, dataIndex: 'CountCost', sortable: true}
			,{header: '药费比例', width: 60, dataIndex: 'DrugRatio', sortable: true}
			,{header: '参考天数', width: 60, dataIndex: 'RefDays', sortable: false}
			,{header: '住院天数', width: 60, dataIndex: 'AdmDays', sortable: true}
			,{header: '变异次数', width: 60, dataIndex: 'VarCount', sortable: false}
			,{
				header: '出径原因'
				,width: 150
				,renderer : function(v, m, rd, r, c, s){
					var Comments = rd.get("Comments");
					var OutReasonDesc = rd.get("OutReasonDesc");
					if (Comments!==''){
						OutReasonDesc=OutReasonDesc+","+Comments
					}
					return OutReasonDesc;
				}
			}
			,{header: '变异原因', width: 150, dataIndex: 'VarReason', sortable: false}
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
			,getRowClass : function(record,rowIndex,rowParams,store){
				if (record.data.ErrFlag=="1") {
					return 'x-grid-record-green';
				} else if (record.data.ErrFlag=="2") {
					return 'x-grid-record-red';
				} else {
					return '';
				}
			}
		}
	});
	obj.MonitorViewport = new Ext.Viewport({
		id : 'MonitorViewport'
		,region : document.body
		,layout : 'border'
		,items:[
			obj.ConditionPanel
			,obj.ResultGridPanel
		]
	});
	obj.cboStatusStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.SysBaseSrv';
			param.QueryName = 'QryCPWType';
			param.ArgCnt = 0;
	});
	obj.cboStatusStore.load({});
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.SysBaseSrv';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboLoc.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = obj.cboWard.getValue();
			param.ArgCnt = 3;
	});
	//obj.cboLocStore.load({});
	obj.cboWardStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.SysBaseSrv';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboWard.getRawValue();
			param.Arg2 = 'W';
			param.Arg3 = obj.cboLoc.getValue();
			param.ArgCnt = 3;
	});
	//obj.cboWardStore.load({});
	obj.ResultGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.ClinPathWaysQuery';
			param.QueryName = 'QryCPWByDischDate';
			param.Arg1 = obj.dfDateFrom.getRawValue();
			param.Arg2 = obj.dfDateTo.getRawValue();
			param.Arg3 = obj.cboStatus.getValue();
			param.Arg4 = obj.cboLoc.getValue();
			param.Arg5 = obj.cboWard.getValue();
			param.Arg6 = (obj.chkSelect.getValue())?'Y':'N';
			param.ArgCnt = 6;
	});
	InitMonitorViewportEvent(obj);
	//事件处理代码
  obj.LoadEvent(arguments);
  return obj;
}

