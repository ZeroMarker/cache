function InitViewScreen(){
	Ext.QuickTips.init();
	var obj = new Object();
	
	obj.anciId = 0;
	obj.ifInquiry = 'N';
	obj.dateType = 'OP';
	obj.historySeq = "";
	obj.pageSize = 50;
	obj.currentPageStart = 0;

	InitCommonQueryStore(obj);

	InitCommon(obj);
	
	obj.ANCInquiryItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ANCInquiryItemStore = new Ext.data.Store({
		proxy: obj.ANCInquiryItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'code'
		}, 
		[
			{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
			,{name: 'type', mapping: 'type'}
			,{name: 'query', mapping: 'query'}
			,{name: 'displayField', mapping: 'displayField'}
			,{name: 'valueField', mapping: 'valueField'}
			,{name: 'valueOption', mapping: 'valueOption'}
			,{name: 'multiDelimiter', mapping: 'multiDelimiter'}
		])
	});
	obj.ANCInquiryItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'GetAllANCInquiryItem';
		param.ArgCnt = 0;
	});
	obj.ANCInquiryItemStore.load({});
	
	obj.inquiryDataFieldStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.inquiryDataFieldStore = new Ext.data.Store({
		proxy: obj.inquiryDataFieldStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'code'   
		}, 
		[	
			{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.inquiryDataFieldStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'GetInquiryDataField';
		param.ArgCnt =0;
	});
	obj.inquiryDataFieldStore.load({});
	
		//查询策略
	obj.comInquiryStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comInquiryStore = new Ext.data.Store({
		proxy: obj.comInquiryStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RowId', mapping: 'RowId'}
			,{name: 'ANCICode', mapping: 'ANCICode'}
			,{name: 'ANCIDesc', mapping: 'ANCIDesc'}
			,{name: 'ANCIDisplayDesc', mapping: 'ANCIDisplayDesc'}
			,{name: 'IfStartStoreTimeLine', mapping: 'IfStartStoreTimeLine'}
			,{name: 'ANCICtlocDr', mapping: 'ANCICtlocDr'}
			,{name: 'ANCICtloc', mapping: 'ANCICtloc'}
			,{name: 'ANCIStatus', mapping: 'ANCIStatus'}
			,{name: 'ANCIStatusDesc', mapping: 'ANCIStatusDesc'}
			,{name: 'ANCIType', mapping: 'ANCIType'}
			,{name: 'ANCITypeDesc', mapping: 'ANCITypeDesc'}
			,{name: 'ANCISearchLevel', mapping: 'ANCISearchLevel'}
			,{name: 'ANCIOpaCount', mapping: 'ANCIOpaCount'}
			,{name: 'ANCIResultCount', mapping: 'ANCIResultCount'}
			,{name: 'ANCIIsByDate', mapping: 'ANCIIsByDate'}
			,{name: 'ANCIDataType', mapping: 'ANCIDataType'}
			,{name: 'ANCIDataTypeDesc', mapping: 'ANCIDataTypeDesc'}
			,{name: 'ANCIDateTimeType', mapping: 'ANCIDateTimeType'}
			,{name: 'ANCIDateTimeTypeDesc', mapping: 'ANCIDateTimeTypeDesc'}
			,{name: 'ANCIUpdateUserDr', mapping: 'ANCIUpdateUserDr'}
			,{name: 'ANCIUpdateUser', mapping: 'ANCIUpdateUser'}
			,{name: 'ANCIUpdateDate', mapping: 'ANCIUpdateDate'}
			,{name: 'ANCIUpdateTime', mapping: 'ANCIUpdateTime'}
			,{name: 'ANCIIsActive', mapping: 'ANCIIsActive'}
		])
	});
	obj.comInquiryStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCInquiry';
		param.QueryName = 'FindANCInquiry';
		param.Arg1 = session['LOGON.CTLOCID'];
		param.ArgCnt = 1;
	});
	obj.comInquiryStore.load({});
	obj.comInquiry = new Ext.form.ComboBox({
		id : 'comInquiry'
		,store : obj.comInquiryStore
		,minChars : 1
		,displayField : 'ANCIDisplayDesc'
		,fieldLabel : '已保存策略'
		,valueField : 'RowId'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.InquiryItemGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.InquiryItemGridStore = new Ext.data.Store({
		proxy: obj.InquiryItemGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'anciiId'
		}, 
		[
			{name: 'anciiId', mapping: 'anciiId'}
			,{name: 'anciiSub', mapping: 'anciiSub'}
			,{name: 'anciiRelateAnciiSub', mapping: 'anciiRelateAnciiSub'}
			,{name: 'anciiCode', mapping: 'anciiCode'}
			,{name: 'anciiDesc', mapping: 'anciiDesc'}
			,{name: 'anciiType', mapping: 'anciiType'}
			,{name: 'anciiIsSearch', mapping: 'anciiIsSearch'}
			,{name: 'anciiIsDisplay', mapping: 'anciiIsDisplay'}
			,{name: 'anciiIsSingle', mapping: 'anciiIsSingle'}
			,{name: 'anciiMinQty', mapping: 'anciiMinQty'}
			,{name: 'anciiMaxQty', mapping: 'anciiMaxQty'}
			,{name: 'anciiNote', mapping: 'anciiNote'}
			,{name: 'anciiMultiple', mapping: 'anciiMultiple'}
			,{name: 'anciiMultipleDesc', mapping: 'anciiMultipleDesc'}
			,{name: 'anciiStartDateTime', mapping: 'anciiStartDateTime'}
			,{name: 'anciiDurationHour', mapping: 'anciiDurationHour'}
			,{name: 'anciiRefValue', mapping: 'anciiRefValue'}
			,{name: 'anciiRefAncoId', mapping: 'anciiRefAncoId'}
			,{name: 'anciiRefAncoDesc', mapping: 'anciiRefAncoDesc'}
			,{name: 'anciiDataField', mapping: 'anciiDataField'}
			,{name: 'anciiOeoriNote', mapping: 'anciiOeoriNote'}
			,{name: 'anciiFromTime', mapping: 'anciiFromTime'}
			,{name: 'anciiToTime', mapping: 'anciiToTime'}
			,{name: 'anciiExactTime', mapping: 'anciiExactTime'}
			,{name: 'anciiSeqNo', mapping: 'anciiSeqNo'}
			,{name: 'anciiLevel', mapping: 'anciiLevel'}
			,{name: 'anciiFromAncoId', mapping: 'anciiFromAncoId'}
			,{name: 'anciiToAncoId', mapping: 'anciiToAncoId'}
			,{name: 'anciiSummaryType', mapping: 'anciiSummaryType'}
			,{name: 'anciiDurationInterval', mapping: 'anciiDurationInterval'}
			,{name: 'multiDelimiter', mapping: 'multiDelimiter'}
			,{name: 'anciiColumnWidth', mapping: 'anciiColumnWidth'}
			,{name: 'anciiIsResultSearch', mapping: 'anciiIsResultSearch'}
			,{name: 'anciiFromDate',mapping: 'anciiFromDate'}
			,{name: 'anciiToDate',mapping: 'anciiToDate'}
		])
	});
	obj.InquiryItemGridStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'GetANCISearchItems';
		param.Arg1=obj.anciId;
		param.ArgCnt =1;
	});
	obj.comRelateAnciiData = []; 
	obj.comRelateAnciiStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(obj.comRelateAnciiData),
		reader: new Ext.data.ArrayReader({},
		[
			{name: 'value'}
		])

	});
	obj.btnComplexSch = new Ext.Button({
		id : 'btnComplexSch'
		,iconCls : 'icon-search'
		,scale : 'medium'
		,text : '查询'
	});
	obj.btnComplexSch.setTooltip("可以通过设置开始结束日期改变筛选范围!");
	obj.inquiryItemRelatePanel = new Ext.form.FormPanel({
		id : 'inquiryItemRelatePanel'
		,labelWidth : 20
		//,columnWidth : .15
		,width : 80
		,labelAlign : 'right'
		,layout : 'form'
		,items : [
		]
	});
	obj.inquiryItemPanel = new Ext.form.FormPanel({
		id : 'inquiryItemPanel'
		,labelWidth : 1
		,hideLabel : true
		,labelAlign : 'right'
		//,columnWidth : .15
		,width : 80
		,layout : 'form'
		,items : [
		]
	});
	obj.inquiryItemValuePanel = new Ext.form.FormPanel({
		id : 'inquiryItemValuePanel'
		,labelWidth : 40
		//,columnWidth : .35
		,width : 240
		,labelAlign : 'right'
		,layout : 'form'
		,autoScroll : true
		,items : [
		]
	});
	obj.inquiryItemMinPanel = new Ext.form.FormPanel({
		id : 'inquiryItemMinPanel'
		,labelWidth : 10
		//,columnWidth : .1
		,width : 60
		,labelAlign : 'right'
		,layout : 'form'
		,autoScroll : true
		,items : [
		]
	});
	obj.inquiryItemMaxPanel = new Ext.form.FormPanel({
		id : 'inquiryItemMaxPanel'
		,labelWidth : 10
		//,columnWidth : .1
		,width : 60
		,labelAlign : 'right'
		,layout : 'form'
		,autoScroll : true
		,items : [
		]
	});
	obj.inquiryDataFieldPanel = new Ext.form.FormPanel({
		id : 'inquiryDataFieldPanel'
		,labelWidth : 5
		//,columnWidth : .1
		,width : 60
		,labelAlign : 'right'
		,layout : 'form'
		,autoScroll : true
		,items : [
		]
	});
	obj.inquiryItemContainerPanel = new Ext.Panel({
		id : 'inquiryItemContainerPanel'
		,buttonAlign : 'center'
		,width : 600
		,layout : 'column'
		,renderHidden : true
		,autoScroll : true
		,items : [
			obj.inquiryItemRelatePanel
			,obj.inquiryItemPanel
			,obj.inquiryItemValuePanel
			,obj.inquiryItemMinPanel
			,obj.inquiryItemMaxPanel
			,obj.inquiryDataFieldPanel
		]
		,buttons:[
		]
	});
	obj.HistoryDataGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.HistoryDataGridStore = new Ext.data.Store({
		proxy: obj.HistoryDataGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'historySeq'
		}, 
		[
			{name: 'anciId', mapping: 'anciId'}
			,{name: 'anciDesc', mapping: 'anciDesc'}
			,{name: 'historySeq', mapping: 'historySeq'}
			,{name: 'dateType', mapping: 'dateType'}
			,{name: 'dateTypeDesc', mapping: 'dateTypeDesc'}
			,{name: 'startDate', mapping: 'startDate'}
			,{name: 'endDate', mapping: 'endDate'}
			,{name: 'appLoc', mapping: 'appLoc'}
			,{name: 'opaCount', mapping: 'opaCount'}
			,{name: 'rowCount', mapping: 'rowCount'}
		])
	});
	obj.HistoryDataGridStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'GetHistoryDataList';
		param.Arg1=obj.anciId;
		param.ArgCnt =1;
	});
	obj.historyDataPanelCheckCol = new Ext.grid.CheckboxSelectionModel({
		header:''
	});
	obj.btnSaveHistoryData = new Ext.Button({
		id : 'btnSaveHistoryData'
		,iconCls:'icon-table_save'
		,text : '保存统计结果'
	});
	obj.btnSaveHistoryData.setTooltip("保存后可较快显示出结果，不再需要查询!");
	obj.btnRemoveHistoryData = new Ext.Button({
		id : 'btnRemoveHistoryData'
		,iconCls:'icon-delete'
		,text : '删除历史数据'
	});
	obj.btnRemoveHistoryData.setTooltip("请选择一行需要删除的历史数据再操作!");
	obj.historyDataPanelTool=new Ext.Toolbar(
	{
		height: 35
		,items:[
			obj.btnSaveHistoryData
			,{
				xtype: 'tbspacer', 
				width: 20
			}
			,obj.btnRemoveHistoryData
		]
	});
	obj.inquiryHistoryDataPanel = new Ext.grid.EditorGridPanel({
		id : 'historyDataGridPanel'
		,store : obj.HistoryDataGridStore
		,sm:obj.historyDataPanelCheckCol
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,height : 200
		,region : 'center'
		,buttonAlign : 'center'
		,tbar:obj.historyDataPanelTool
		,cm:new Ext.grid.ColumnModel({
			defaults:
			{
				sortable: true // columns are not sortable by default           
			}
			,columns: [
				new Ext.grid.RowNumberer()
				,obj.historyDataPanelCheckCol
				,{ header: '日期类型',width: 80,dataIndex: 'dateTypeDesc'}
				,{ header: '开始日期',width: 100,dataIndex: 'startDate'}
				,{ header: '结束日期',width: 100,dataIndex: 'endDate'}
				,{ header: '申请科室',width: 80,dataIndex: 'appLoc'}
				,{ header: '历史数据序号',width: 80,dataIndex: 'historySeq'}
				,{ header: '策略名',width: 80,dataIndex: 'anciDesc'}
				,{ header: '总手术数量',width: 80,dataIndex: 'opaCount'}
				,{ header: '结果行数量',width: 80,dataIndex: 'rowCount'}
			]
		})
		,columnLines : true
	});
	obj.selectInquiryPanel = new Ext.Panel({
		id : 'selectInquiryPanel'
		,buttonAlign : 'center'
		,height : 80
		,region : 'north'
		,layout : 'fit'
		,frame :true
		,items:[
			obj.comInquiry
		]
		,buttons:[
			obj.btnComplexSch
		]
	});
	obj.selectInquiryItemPanel = new Ext.Panel({
		id : 'selectInquiryItemPanel'
		,region : 'center'
		,style : 'padding-top:20px;'
		,layout: 'form'
		,autoScroll : true
		,items:[
			obj.inquiryItemContainerPanel
			,obj.inquiryHistoryDataPanel
		]
	});
	obj.complexSeachPanel = new Ext.Panel({
		id : 'complexSeachPanel'
		,buttonAlign : 'center'
		,title : '选择查询策略'
		,region : 'center'
		,layout : 'border'
		,frame :true
		,autoScroll : true
		,items:[
			obj.selectInquiryPanel
			,obj.selectInquiryItemPanel
		]
	});
	//查询策略子项
	
	//查询结果

	InitResultGridPanel(obj);

	obj.schPanel = new Ext.Panel({
		id : 'schPanel'
		,width : 300
		,title : '手术综合查询'
		,region : 'east'
		,layout : 'border'
		,collapsible:true
		,animate:true
		,items:[
			obj.SeachDatePanel
			,obj.complexSeachPanel
		]
	});
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,title : '手术查询结果'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
			obj.retGridPanel
		]
	});
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,defaults: {
            split: true
			,collapsible: true
        }
		,items:[
			obj.schPanel
			,obj.resultPanel
		]
	});

	InitViewScreenEvent(obj);
	
	InitOpaInfoWindow(obj);
	
	obj.comInquiry.on('select',obj.comInquiry_select,obj);
	obj.inquiryHistoryDataPanel.on("rowclick", obj.inquiryHistoryDataPanel_rowclick, obj);
	obj.btnComplexSch.on('click',obj.btnComplexSch_click,obj);
	obj.btnSaveHistoryData.on('click',obj.btnSaveHistoryData_click,obj);
	obj.btnRemoveHistoryData.on('click',obj.btnRemoveHistoryData_click,obj);
	obj.InquiryItemGridStore.on('load',obj.InquiryItemGridStore_load,obj);
	obj.LoadEvent(arguments);
	return obj;
}
