function InitviewMain(){
	var obj = new Object();
	
	obj.btnExport  = new Ext.Toolbar.Button({
		id : 'btnExport',
		text: '<b>导出EXCEL<b>',
		iconCls : 'icon-export'
	});
	
	obj.gridAdmStatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridAdmStatStore = new Ext.data.Store({
		proxy: obj.gridAdmStatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CtRowid'
		},
		[
			{name: 'CtRowid', mapping : 'CtRowid'}
			,{name: 'CtDesc', mapping : 'CtDesc'}
			,{name: 'InHospitalNum', mapping: 'InHospitalNum'}
			,{name: 'InPathWayNum', mapping: 'InPathWayNum'}
			,{name: 'PathWayNum', mapping: 'PathWayNum'}
			,{name: 'InPathWayPercent', mapping: 'InPathWayPercent'}
		])
	});
	obj.gridAdmStat = new Ext.grid.GridPanel({
		id : 'gridAdmStat'
		,store : obj.gridAdmStatStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,frame : true
		,bbar : ['在院统计列表导出：',obj.btnExport]
		,columns: [
			{header: '科室名称', width: 100, dataIndex: 'CtDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '在院人数', width: 50, dataIndex: 'InHospitalNum', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '入径人数', width: 50, dataIndex: 'InPathWayNum', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '路径数', width: 50, dataIndex: 'PathWayNum', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '入径人数/在院人数', width: 50, dataIndex: 'InPathWayPercent', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
			,getRowClass : function(record,rowIndex,rowParams,store){
				if (record.get('InPathWayNum')) {
					if (record.get('InPathWayNum') != 0) {
						return 'x-grid-record'
					}
				}
			}
		}
    });
	
	obj.viewMain = new Ext.Viewport({
		id : 'viewMain'
		,layout : 'border'
		,items:[
			obj.gridAdmStat
		]
	});
	
	obj.gridAdmStatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCPW.MR.ClinPathWaysStat';
		param.QueryName = 'QryAdmitStat';
		param.ArgCnt = 0;
	});
	
	InitviewMainEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}


function InitviewSubWindow(CTLocID,Title){
	var obj = new Object();
	
	obj.btnDtlExport  = new Ext.Toolbar.Button({
		id : 'btnDtlExport',
		text: '<b>导出EXCEL<b>',
		iconCls : 'icon-export'
	});
	
	obj.gridAdmStatDtlStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridAdmStatDtlStore = new Ext.data.GroupingStore({
		proxy: obj.gridAdmStatDtlStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'EpisodeID'
		},
		[
			{name: 'CtRowid', mapping : 'CtRowid'}
			,{name: 'MRAdm', mapping : 'MRAdm'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PathWayId', mapping: 'PathWayId'}
			,{name: 'PathNumStr', mapping: 'PathNumStr'}
			,{name: 'MrPathRowid', mapping: 'MrPathRowid'}
			,{name: 'PAPMIName', mapping: 'PAPMIName'}
			,{name: 'sex', mapping: 'sex'}
			,{name: 'PAPMIAge', mapping: 'PAPMIAge'}
			,{name: 'PAAdmDocCodeDR', mapping: 'PAAdmDocCodeDR'}
			,{name: 'admDate', mapping: 'admDate'}
			,{name: 'cpwInDate', mapping: 'cpwInDate'}
			,{name: 'currentStepDesc', mapping: 'currentStepDesc'}
			,{name: 'cpwDateNo', mapping: 'cpwDateNo'}
			,{name: 'cpwDataNoPercent', mapping: 'cpwDataNoPercent'}
			,{name: 'implItemsPercent', mapping: 'implItemsPercent'}
			,{name: 'CheckVar', mapping: 'CheckVar'}
			,{name: 'cont', mapping: 'cont'}
			,{name: 'DrugRatio', mapping: 'DrugRatio'}
			,{name: 'AdmDays', mapping: 'AdmDays'}
		])
		,sortInfo:{field: 'PathWayId', direction: "ASC"}
		,groupField:'PathNumStr'
	});
	
	obj.gridAdmStatDtl = new Ext.grid.GridPanel({
		id : 'gridAdmStatDtl'
		,store : obj.gridAdmStatDtlStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,frame : true
		,view: new Ext.grid.GroupingView({
			//forceFit:true,
			groupTextTpl: '{[values.rs[0].get("PathNumStr")]}',
			groupByText:'依本列分组'
		})
		,bbar : ['在院患者-出入径明细列表导出：',obj.btnDtlExport]
		,columns: [
			{header: '临床路径ID', width: 80,dataIndex: 'PathWayId', sortable: true,hidden:true, align: 'center'}
			,{header: '入径数', width: 80,dataIndex: 'PathNumStr', sortable: true,hidden:true, align: 'center'}
			,{header: '姓名', width: 80,dataIndex: 'PAPMIName', sortable: true, align: 'center'}
			,{header:'性别', width: 50,dataIndex:'sex',sortable:true, align: 'center'}
			,{header: '年龄', width: 50,dataIndex: 'PAPMIAge', sortable: true, align: 'center'}
			,{header: '医生', width: 80,dataIndex: 'PAAdmDocCodeDR', sortable: true, align: 'center'}
			,{header: '入院日期', width: 80,dataIndex: 'admDate', sortable: true, align: 'center'}
			,{header: '入径日期', width: 80,dataIndex: 'cpwInDate', sortable: true, align: 'center'}
			,{header: '所处步骤', width: 100,dataIndex: 'currentStepDesc', sortable: true, align: 'center'}
			,{header: '入径天数', width: 80,dataIndex: 'cpwDateNo', sortable: true, align: 'center'}
			,{header: '在院天数', width: 80,dataIndex: 'AdmDays', sortable: true, align: 'center'}
			,{header: '费用', width: 80,dataIndex: 'cont', sortable: true, align: 'center'}
			,{header: '药费比例', width: 80,dataIndex: 'DrugRatio', sortable: true, align: 'center'}
			//,{header: '入径天数/在院天数', width: 60,dataIndex: 'cpwDataNoPercent', sortable: true, align: 'center'}
			,{header: '已实施项目比例', width: 100,dataIndex: 'implItemsPercent', sortable: true, align: 'center'}
			,{header: '是否变异', width: 80,dataIndex: 'CheckVar', sortable: true, align: 'center'}
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
	
	obj.DtlSubWindow = new Ext.Window({
		id : 'DtlSubWindow'
		,collapsed : true
		,buttonAlign : 'center'
		,maximized : true
		,resizable : false
		,title : '在院患者-出入径明细列表' + '[' + Title + ']'
		,layout : 'fit'
		//,width : 800
		//,height : 600
		,modal: true
		,items:[
			obj.gridAdmStatDtl
		]
	});
	
	obj.gridAdmStatDtlStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCPW.MR.ClinPathWaysStat';
		param.QueryName = 'QryAdmitStatDetail';
		param.Arg1 = CTLocID;
		param.ArgCnt = 1;
	});
	
	InitviewSubWindowEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

