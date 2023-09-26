
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
		,columnWidth : .20
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
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.dfDateTo
		]
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,width : 80
		,clearCls : 'icon-find'
		,text : '查询'
		,disabled : false
	});
	obj.pConditionChild3 = new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign : 'center'
		,columnWidth : .10
		,layout : 'form'
		,items:[
			obj.btnQuery
		]
	});
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
	    	,text: '导出EXCEL'
	});
	obj.pConditionChild4 = new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign : 'center'
		,columnWidth : .10
		,layout : 'form'
		,items:[
			obj.btnExport
		]
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
		]
	});
	obj.ConditionPanel = new Ext.Panel({
		id : 'ConditionPanel'
		,height : 70
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'fit'
		,title : '变异记录查询'
		,items:[
			obj.ConditionSubPanel
		]
	});
	obj.ResultGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL,
			timeout:180000      //Add By Niucaicai 2011-08-10  加载超时限制3分钟
		}));
	obj.ResultGridPanelStore = new Ext.data.Store({
		proxy: obj.ResultGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Num'
		}, 
		[
			{name:'PathWayID',mapping:'PathWayID'}
			,{name:'Paadm',mapping:'Paadm'}
			,{name:'CPWDicDesc',mapping:'CPWDicDesc'}
			,{name:'StatusDesc',mapping:'StatusDesc'}
			,{name:'PatientID',mapping:'PatientID'}
			,{name:'PapmiNo',mapping:'PapmiNo'}
			,{name:'PatName',mapping:'PatName'}
			,{name:'Sex',mapping:'Sex'}
			,{name:'Birthday',mapping:'Birthday'}
			,{name:'Age',mapping:'Age'}
			,{name:'PersonalID',mapping:'PersonalID'}
			,{name:'AdmitDate',mapping:'AdmitDate'}
			,{name:'AdmitTime',mapping:'AdmitTime'}
			,{name:'DisDate',mapping:'DisDate'}
			,{name:'DisTime',mapping:'DisTime'}
			,{name:'AdmLoc',mapping:'AdmLoc'}
			,{name:'AdmWard',mapping:'AdmWard'}
			,{name:'AdmDoc',mapping:'AdmDoc'}
			,{name:'VarReason',mapping:'VarReason'}
			,{name:'ExtraType',mapping:'ExtraType'}
			,{name:'ExtraDesc',mapping:'ExtraDesc'}
			,{name:'Num',mapping:'Num'}
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
			,{header: '登记号', width: 70, dataIndex: 'PapmiNo', sortable: false}
			,{header: '姓名', width: 70, dataIndex: 'PatName', sortable: false}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: false}
			,{header: '年龄', width: 50, dataIndex: 'Age', sortable: false}
			,{header: '路径名称', width: 100, dataIndex: 'CPWDicDesc', sortable: false}
			,{header: '路径状态', width: 50, dataIndex: 'StatusDesc', sortable: false}
			,{header: '变异原因', width: 100, dataIndex: 'VarReason', sortable: false}
			,{header: '附加类型', width: 100, dataIndex: 'ExtraType', sortable: false}
			,{header: '附加项目', width: 200, dataIndex: 'ExtraDesc', sortable: false}
			,{header: '入院日期', width: 70, dataIndex: 'AdmitDate', sortable: false}
			,{header: '出院日期', width: 70, dataIndex: 'DisDate', sortable: false}
			,{header: '科室', width: 80, dataIndex: 'AdmLoc', sortable: false}
			,{header: '病区', width: 80, dataIndex: 'AdmWard', sortable: false}
			,{header: '医生', width: 70, dataIndex: 'AdmDoc', sortable: false}
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
	obj.MonitorViewport = new Ext.Viewport({
		id : 'MonitorViewport'
		,region : document.body
		,layout : 'border'
		,items:[
			obj.ConditionPanel
			,obj.ResultGridPanel
		]
	});
	obj.ResultGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.ClinPathWayItmAnalysis';
			param.QueryName = 'QryItemExecRatio';
			param.Arg1 = obj.dfDateFrom.getRawValue();
			param.Arg2 = obj.dfDateTo.getRawValue();
			param.Arg3 = "";
			param.Arg4 = "";
			param.ArgCnt = 4;
	});
	InitMonitorViewportEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}

