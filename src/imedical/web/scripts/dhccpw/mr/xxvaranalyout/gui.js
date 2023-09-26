
function InitVarianceViewport(){
	var obj = new Object();
	obj.DateFrom="";
	obj.DateTo="";
	obj.LocID="";
	obj.WardID="";
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
		,columnWidth : .2
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
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.dfDateTo
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
	obj.pConditionChild3 = new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign : 'center'
		,columnWidth : .3
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
	obj.pConditionChild4 = new Ext.Panel({
		id : 'pConditionChild5'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.cboWard
		]
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,width : 80
		,clearCls : 'icon-find'
		,text : '查询'
		,disabled : false
	});
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
	    ,text: '导出EXCEL'
	});
	obj.ConditionSubPanel = new Ext.form.FormPanel({
		id : 'ConditionSubPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 70
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'column'
		,frame : true
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
	obj.ConditionPanel = new Ext.Panel({
		id : 'ConditionPanel'
		,height : 100
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'fit'
		,title : '变异分析(出径时间)'
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
			idProperty: 'CPWID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CPWID', mapping: 'CPWID'}
			,{name: 'CPWDesc', mapping: 'CPWDesc'}
			,{name: 'InCount', mapping: 'InCount'}
			,{name: 'OutCount', mapping: 'OutCount'}
			,{name: 'CloseCount', mapping: 'CloseCount'}
			,{name: 'VarCount', mapping: 'VarCount'}
			,{name: 'OutRatio', mapping: 'OutRatio'}
			,{name: 'CloseRatio', mapping: 'CloseRatio'}
			,{name: 'VarRatio', mapping: 'VarRatio'}
		])
	});
	obj.ResultGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.ResultGridPanel = new Ext.grid.GridPanel({
		id : 'ResultGridPanel'
		,store : obj.ResultGridPanelStore
		,region : 'center'
		,frame : true
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '路径名', width: 300, dataIndex: 'CPWDesc', sortable: false}
			,{header: '入径人次', width: 80, dataIndex: 'InCount', sortable: false}
			,{header: '出径人次', width: 80, dataIndex: 'OutCount', sortable: false}
			,{header: '出径率', width: 80, dataIndex: 'OutRatio', sortable: true}
			,{header: '完成人次', width: 80, dataIndex: 'CloseCount', sortable: false}
			,{header: '完成率', width: 80, dataIndex: 'CloseRatio', sortable: true}
			,{header: '变异人次', width: 80, dataIndex: 'VarCount', sortable: false}
			,{header: '变异率', width: 80, dataIndex: 'VarRatio', sortable: true}
			,{
				header: '出径原因分析',
				width: 100,
				dataIndex: 'CPWID',
				renderer : function(v, m, rd, r, c, s){
					var CPWID = rd.get("CPWID");
					var OutCount = rd.get("OutCount");
					if (OutCount!=0) {
						var CPWDesc = rd.get("CPWDesc");
						return " <a href='#' onclick='OutReasonSubLookUpHeader(2,\""+CPWID+"\",\""+obj.DateFrom+"\",\""+obj.DateTo+"\",\""+obj.LocID+"\",\""+obj.WardID+"\",\""+CPWDesc+"\")');'>&nbsp;查看&nbsp; </a>";
					}
				}
			}
			,{
				header: '变异原因分析',
				width: 100,
				dataIndex: 'CPWID',
				renderer : function(v, m, rd, r, c, s){
					var CPWID = rd.get("CPWID");
					var VarCount = rd.get("VarCount");
					if (VarCount!=0) {
						var CPWDesc = rd.get("CPWDesc");
						return " <a href='#' onclick='VarReasonSubLookUpHeader(2,\""+CPWID+"\",\""+obj.DateFrom+"\",\""+obj.DateTo+"\",\""+obj.LocID+"\",\""+obj.WardID+"\",\""+CPWDesc+"\")');'>&nbsp;查看&nbsp; </a>";
					}
				}
			}
		]
	});
	obj.VarianceViewport = new Ext.Viewport({
		id : 'VarianceViewport'
		,region : document.body
		,layout : 'border'
		,items:[
			obj.ConditionPanel
			,obj.ResultGridPanel
		]
	});
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.SysBaseSrv';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboLoc.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	//obj.cboLocStore.load({});
	obj.cboWardStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.SysBaseSrv';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboWard.getRawValue();
			param.Arg2 = 'W';
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	//obj.cboWardStore.load({});
	obj.ResultGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.VarianceAnalysis';
			param.QueryName = 'QryVarianceByOutDate';
			param.Arg1 = obj.dfDateFrom.getRawValue();
			param.Arg2 = obj.dfDateTo.getRawValue();
			param.Arg3 = obj.cboLoc.getValue();
			param.Arg4 = obj.cboWard.getValue();
			param.ArgCnt = 4;
			
			obj.DateFrom=obj.dfDateFrom.getRawValue();
			obj.DateTo=obj.dfDateTo.getRawValue();
			obj.LocID=obj.cboLoc.getValue();
			obj.WardID=obj.cboWard.getValue();
	});
	InitVarianceViewportEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}

