function InitOEWin(paadm){
	var obj = new Object();
	obj.LeftPanel = new Ext.Panel({
		id : 'LeftPanel'
		,buttonAlign : 'center'
		,columnWidth : .05
		,items:[
		]
	});
	obj.OEComBoxStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.OEComBoxStore = new Ext.data.Store({
		proxy: obj.OEComBoxStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.OEComBox = new Ext.form.ComboBox({
		id : 'OEComBox'
		,selectOnFocus : true
		,forceSelection : true
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '医嘱大类'
		,store : obj.OEComBoxStore
		,mode : 'loacl'
		,typeAhead : true
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'rowid'
});
	obj.OEItemComBoxStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.OEItemComBoxStore = new Ext.data.Store({
		proxy: obj.OEItemComBoxStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'desc', mapping: 'desc'}
			,{name: '', mapping: ''}
		])
	});
	obj.OEItemComBox = new Ext.form.ComboBox({
		id : 'OEItemComBox'
		,selectOnFocus : true
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '医嘱子类'
		,store : obj.OEItemComBoxStore
		,mode : 'loacl'
		,typeAhead : true
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'rowid'
});
	obj.OECprStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.OECprStore = new Ext.data.Store({
		proxy: obj.OECprStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'code'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.OECpr = new Ext.form.ComboBox({
		id : 'OECpr'
		,selectOnFocus : true
		,forceSelection : true
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '优先级'
		,store : obj.OECprStore
		,mode : 'loacl'
		,typeAhead : true
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'code'
});
	obj.OEDateFrom = new Ext.form.DateField({
		id : 'OEDateFrom'
		,fieldLabel : '开始日期'
		,anchor : '95%'
		,format: 'Y-m-d'
});
	obj.OEDateTo = new Ext.form.DateField({
		id : 'OEDateTo'
		,fieldLabel : '结束日期'
		,anchor : '95%'
		,format: 'Y-m-d'
});
	obj.BtnFind = new Ext.Button({
		id : 'BtnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.CenterPanel = new Ext.Panel({
		id : 'CenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .9
		,layout : 'form'
		,items:[
			obj.OECpr
			,obj.OEComBox
			,obj.OEItemComBox
			,obj.OEDateFrom
			,obj.OEDateTo
		]
	,	buttons:[
			obj.BtnFind
		]
	});
	obj.RightPanel = new Ext.Panel({
		id : 'RightPanel'
		,buttonAlign : 'center'
		,columnWidth : .05
		,items:[
		]
	});
	obj.QryFPanel = new Ext.form.FormPanel({
		id : 'QryFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,collapsible : true
		,region : 'west'
		,layout : 'column'
		,frame : true
		,width : 250
		,height : 368
		,collapsed : true
		,titleCollapse : false
		,items:[
			obj.LeftPanel
			,obj.CenterPanel
			,obj.RightPanel
		]
	});
	obj.OEListGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.OEListGridStore = new Ext.data.Store({
		proxy: obj.OEListGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OrdCreateDate'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'OrdCreateDate', mapping: 'OrdCreateDate'}
			,{name: 'OrdCreateTime', mapping: 'OrdCreateTime'}
			,{name: 'OrdStartDate', mapping: 'OrdStartDate'}
			,{name: 'OrdStartTime', mapping: 'OrdStartTime'}
			,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
			,{name: 'DoseQty', mapping: 'DoseQty'}
			,{name: 'DoseUnit', mapping: 'DoseUnit'}
			,{name: 'Priority', mapping: 'Priority'}
			,{name: 'PHFreq', mapping: 'PHFreq'}
			,{name: 'Instr', mapping: 'Instr'}
			,{name: 'Doctor', mapping: 'Doctor'}
			,{name: 'OrdStatus', mapping: 'OrdStatus'}
			,{name: 'Dura', mapping: 'Dura'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'SeqNo', mapping: 'SeqNo'}
			,{name: 'QtyPackUOM', mapping: 'QtyPackUOM'}
			,{name: 'PackUOMDesc', mapping: 'PackUOMDesc'}
			,{name: 'PrescNo', mapping: 'PrescNo'}
			,{name: 'dstatus', mapping: 'dstatus'}
			,{name: 'LabEpisodeNo', mapping: 'LabEpisodeNo'}
			,{name: 'OrdLabSpec', mapping: 'OrdLabSpec'}
			,{name: 'OrdXDate', mapping: 'OrdXDate'}
			,{name: 'OrdXTime', mapping: 'OrdXTime'}
			,{name: 'OrdSkinTest', mapping: 'OrdSkinTest'}
			,{name: 'OrdAction', mapping: 'OrdAction'}
			,{name: 'OrdDepProcNotes', mapping: 'OrdDepProcNotes'}
			,{name: 'OrdBilled', mapping: 'OrdBilled'}
			,{name: 'OrdSkinTestResult', mapping: 'OrdSkinTestResult'}
		])
	});
	obj.OEListGridCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.OEListGrid = new Ext.grid.GridPanel({
		id : 'OEListGrid'
		,store : obj.OEListGridStore
		,buttonAlign : 'center'
		,width : 390
		,height : 368
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '医嘱名称', width: 120, dataIndex: 'ArcimDesc', sortable: true}
			,{header: '下嘱日期', width: 80, dataIndex: 'OrdCreateDate', sortable: true}
			,{header: '下嘱时间', width: 60, dataIndex: 'OrdCreateTime', sortable: true}
			,{header: '开始日期', width: 80, dataIndex: 'OrdStartDate', sortable: true}
			,{header: '开始时间', width: 60, dataIndex: 'OrdStartTime', sortable: true}
			,{header: '状态', width: 50, dataIndex: 'OrdStatus', sortable: true}
			,{header: '优先级', width: 100, dataIndex: 'Priority', sortable: true}
			,{header: '剂量', width: 50, dataIndex: 'DoseQty', sortable: true}
			,{header: '单位', width: 50, dataIndex: 'DoseUnit', sortable: true}
			,{header: '频次', width: 50, dataIndex: 'PHFreq', sortable: true}
			,{header: '用法', width: 50, dataIndex: 'Instr', sortable: true}
			,{header: '医生', width: 100, dataIndex: 'Doctor', sortable: true}
			,{header: '疗程', width: 50, dataIndex: 'Dura', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.OEListGridStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		});
	obj.OEWin = new Ext.Window({
		id : 'OEWin'
		,height : 400
		,buttonAlign : 'center'
		,width : 800
		,title : '医嘱单'
		,layout : 'border'
		,items:[
			obj.QryFPanel
			,obj.OEListGrid
		]
	});
	obj.OEComBoxStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.QryPatOrdInfo';
			param.QueryName = 'QueryQECATInfo';
			param.ArgCnt = 0;
	});
	obj.OEComBoxStore.load({});
	obj.OEItemComBoxStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.QryPatOrdInfo';
			param.QueryName = 'QueryARCItemCatInfo';
			param.Arg1 = obj.OEComBox.getValue();
			param.ArgCnt = 1;
	});
	obj.OEItemComBoxStore.load({});
	obj.OECprStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.QryPatOrdInfo';
			param.QueryName = 'QueryAllOECPR';
			param.ArgCnt = 0;
	});
	obj.OECprStore.load({});
	obj.OEListGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.QryPatOrdInfo';
			param.QueryName = 'GetOrdList';
			param.Arg1 = paadm;
			param.Arg2 = obj.OEDateFrom.getValue();
			param.Arg3 = obj.OEDateTo.getValue();
			param.Arg4 = obj.OEComBox.getValue();
			param.Arg5 = obj.OEItemComBox.getValue();
			param.Arg6 = obj.OECpr.getValue();
			param.Arg7 = "";
			param.Arg8 = "";
			param.ArgCnt = 8;
	});
	obj.OEListGridStore.load();
	InitOEWinEvent(obj);
	//事件处理代码
	obj.OECpr.on("select",obj.BtnFind_click, obj);
	obj.OEComBox.on("select",obj.OEComBox_click, obj);
	obj.OEItemComBox.on("select",obj.BtnFind_click, obj);
	obj.BtnFind.on("click", obj.BtnFind_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

