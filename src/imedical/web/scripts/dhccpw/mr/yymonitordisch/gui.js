
function InitMonitorViewport(){
	var obj = new Object();
	obj.dfDateFrom = new Ext.form.DateField({
		id : 'dfDateFrom'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '��ʼ����'
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
		,fieldLabel : '��������'
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
		,listEmptyText : '�뾶'
		,width : 50
		,store : obj.cboStatusStore
		,minChars : 1
		,displayField : 'CPWTypeDesc'
		,fieldLabel : '״̬'
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
		,fieldLabel : '����'
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
		,fieldLabel : '����'
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
		,fieldLabel : '�Ƿ�ɸѡ'
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
		,text : '��ѯ'
		,disabled : false
	});
	obj.btnFromShow = new Ext.Button({
		id : 'btnFromShow'
		,width : 80
		,clearCls : 'icon-menudic'
		,text : '��չ��'
		,disabled : false
	});
	obj.btnVarRecord = new Ext.Button({
		id : 'btnVarRecord'
		,width : 80
		,clearCls : 'icon-menudic'
		,text : '�����¼'
		,disabled : false
	});
	obj.btnOeordItem = new Ext.Button({
		id : 'btnOeordItem'
		,width : 80
		,clearCls : 'icon-menudic'
		,text : 'ҽ����'
		,disabled : false
		,hidden : true //modified by LiYang 2011-04-08
	});
	obj.btnMonitorRst = new Ext.Button({
		id : 'btnMonitorRst'
		,width : 80
		,clearCls : 'icon-menudic'
		,text : '��ؽ��'
		,disabled : false
		,hidden : true //modified by LiYang 2011-04-08
	});
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,text: '����EXCEL'
	});
	obj.btnPrintForm = new Ext.Button({
		id : 'btnPrintForm'
		,text: '��ӡ��'
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
		,title : '��Ժ��ѯ'
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
			,{header: '�ǼǺ�', width: 70, dataIndex: 'PapmiNo', sortable: true}
			,{header: '������', width: 70, dataIndex: 'InMedicare', sortable: true}
			,{header: '����', width: 60, dataIndex: 'PatName', sortable: true}
			,{header: '�Ա�', width: 40, dataIndex: 'Sex', sortable: true}
			,{header: '����', width: 40, dataIndex: 'Age', sortable: true}
			//,{header: '���֤��', width: 120, dataIndex: 'PersonalID', sortable: true}
			/*,{
				header: 'ҽ����',
				width: 80,
				dataIndex: 'Paadm',
				renderer : function(v, m, rd, r, c, s){
					var EpisodeID = rd.get("Paadm");
					//return " <a href='#' onclick='OeordItemLookUpHeader("+EpisodeID+")');'>&nbsp;" + v + "&nbsp; </a>";
					return " <a href='#' onclick='OeordItemLookUpHeader("+EpisodeID+")');'>&nbsp;�鿴ҽ��&nbsp; </a>";
				}
			},{
				header: '��ؽ��',
				width: 80,
				dataIndex: 'Rowid',
				renderer : function(v, m, rd, r, c, s){
					var PathWayID = rd.get("Rowid");
					var UserID = session['LOGON.USERID'];
					//return " <a href='#' onclick='MonitorRstLookUpHeader("+PathWayID+","+UserID+")');'>&nbsp;" + v + "&nbsp; </a>";
					return " <a href='#' onclick='MonitorRstLookUpHeader("+PathWayID+","+UserID+")');'>&nbsp;�鿴���&nbsp; </a>";
				}
			}
			,{
				header: '�����¼',
				width: 80,
				renderer : function(v, m, rd, r, c, s){
					var PathWayID = rd.get("Rowid");
					var UserID = session['LOGON.USERID'];
					//return " <a href='#' onclick='VarianceRecordHeader("+PathWayID+","+UserID+")');'>&nbsp;" + v + "&nbsp; </a>";
					return " <a href='#' onclick='VarianceRecordHeader("+PathWayID+","+UserID+")');'>&nbsp;�����¼&nbsp; </a>";
				}
			}*/
			,{header: '�ٴ�·��', width: 200, dataIndex: 'PathWayDesc', sortable: true}
			,{header: '�׶�', width: 100, dataIndex: 'PathWayEpDesc', sortable: true}
			//,{header: '����', width: 100, dataIndex: 'EPStepDesc', sortable: true}
			,{header: '״̬', width: 50, dataIndex: 'StatusDesc', sortable: true}
			,{header: '�뾶��', width: 60, dataIndex: 'InDoctorDesc', sortable: true}
			,{header: '�뾶����', width: 80, dataIndex: 'InDate', sortable: true}
			//,{header: '�뾶ʱ��', width: 60, dataIndex: 'InTime', sortable: true}
			,{header: '������', width: 60, dataIndex: 'OutDoctorDesc', sortable: true}
			,{header: '��������', width: 80, dataIndex: 'OutDate', sortable: true}
			//,{header: '����ʱ��', width: 60, dataIndex: 'OutTime', sortable: true}
			,{header: '��Ժ����', width: 80, dataIndex: 'AdmitDate', sortable: true}
			//,{header: '��Ժʱ��', width: 60, dataIndex: 'AdmitTime', sortable: true}
			,{header: '��Ժ����', width: 80, dataIndex: 'DisDate', sortable: true}
			//,{header: '��Ժʱ��', width: 60, dataIndex: 'DisTime', sortable: true}
			,{header: '����', width: 150, dataIndex: 'AdmLoc', sortable: true}
			,{header: '����', width: 150, dataIndex: 'AdmWard', sortable: true}
			//,{header: '����', width: 60, dataIndex: 'AdmRoom', sortable: true}
			//,{header: '����', width: 60, dataIndex: 'AdmBed', sortable: true}
			,{header: 'ҽ��', width: 60, dataIndex: 'AdmDoc', sortable: true}
			//,{header: '״̬', width: 100, dataIndex: 'AdmStatus', sortable: true}
			,{header: '�ο�����', width: 60, dataIndex: 'RefCost', sortable: false}
			,{header: 'ʵ�ʷ���', width: 60, dataIndex: 'CountCost', sortable: true}
			,{header: 'ҩ�ѱ���', width: 60, dataIndex: 'DrugRatio', sortable: true}
			,{header: '�ο�����', width: 60, dataIndex: 'RefDays', sortable: false}
			,{header: 'סԺ����', width: 60, dataIndex: 'AdmDays', sortable: true}
			,{header: '�������', width: 60, dataIndex: 'VarCount', sortable: false}
			,{
				header: '����ԭ��'
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
			,{header: '����ԭ��', width: 150, dataIndex: 'VarReason', sortable: false}
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
	//�¼��������
  obj.LoadEvent(arguments);
  return obj;
}

