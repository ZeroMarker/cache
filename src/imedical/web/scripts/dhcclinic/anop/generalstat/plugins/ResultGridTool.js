function InitResultGridTool(obj)
{
	obj.retSumTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retSumTypeStore = new Ext.data.Store({
		proxy: obj.retSumTypeStoreProxy,
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
	obj.retSumTypeStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'GetSummaryType';
		param.Arg1 = obj.anciId;
		param.ArgCnt = 1;
	});
	obj.comRetSumType = new Ext.form.ComboBox({
		id : 'comRetSumType'
		,store : obj.retSumTypeStore
		,minChars : 1
		,width : 120
		,minListWidth : 200
		,displayField : 'desc'
		,fieldLabel : '选择汇总类型'
		,emptyText : '请选择汇总类型'
		,valueField : 'code'
		,triggerAction : 'all'
		,anchor : '95%'
	});

	obj.comRetSumType_select=function()
	{
		if(!obj.CheckSelectInquiry()) return;
		obj.ifInquiry = 'N';
		obj.RefreshInquiryResult();
	}

	obj.comRetSumType.on('select',obj.comRetSumType_select,obj);

	obj.chkShowZero = new Ext.form.Checkbox({
		id : 'chkShowZero'
		,fieldLabel : ''
		,anchor : '95%'
		,checked : true
		,listeners : {
			'check': function()
			{
				if(obj.retGridPanel)obj.retGridPanel.reconfigure(obj.retGridPanelStore,obj.gridcm);
			}
		}
	});

	obj.menuItemPrintResult = new Ext.menu.Item({
		id : 'menuItemPrintResult'
		,iconCls : 'icon-page_excel'
		,text : '导出至Excel'
	});

	obj.menuItemPrintToHtml = new Ext.menu.Item({
		id : 'menuItemPrintToHtml'
		,iconCls : 'icon-grid'
		,text : '导出至新页面'
	});

	obj.printMenu=new Ext.menu.Menu({
		items:[
			obj.menuItemPrintResult
			,obj.menuItemPrintToHtml
		]
	});

	InitGridPrint(obj);

	obj.menuItemShowLastResult = new Ext.menu.Item({
		id : 'menuItemShowLastResult'
		,iconCls : 'icon-arrow_refresh'
		,text : '显示上次结果'
	});

	obj.menuItemSaveColumnWidth = new Ext.menu.Item({
		id : 'menuItemSaveColumnWidth'
		,iconCls : 'icon-table_save'
		,text : '保存列宽度'
	});

	obj.toolMenu=new Ext.menu.Menu({
		items:[
			obj.menuItemShowLastResult
			,obj.menuItemSaveColumnWidth
		]
	});

	obj.menuItemShowLastResult_click=function(args)
	{
		if(!obj.CheckSelectInquiry()) return;
		obj.ResetStartEndDate();
		obj.ifInquiry = 'N';
		obj.RefreshInquiryResult();
	}

	obj.menuItemShowLastResult.on('click',obj.menuItemShowLastResult_click,obj);

	obj.menuItemSaveColumnWidth_click=function(args)
	{
		if(!obj.CheckSelectInquiry()) return;
		var columnModel=obj.retGridPanel.getColumnModel();
		var cols=columnModel.getColumnCount();//显示列数
		var colWidthSaveStr = "";
		for(var j=1;j<cols;j++)
		{
			var colName=columnModel.getDataIndex(j);
			var colWidth=columnModel.getColumnWidth(j);
			if(colName!="" && colName != "undefinded")
			{
				if(colWidthSaveStr.length>0) colWidthSaveStr=colWidthSaveStr+"^";
				colWidthSaveStr=colWidthSaveStr+colName+":"+colWidth;
			}
		}
		var ret = obj._DHCANOPStat.SaveColumnWidth(obj.anciId,colWidthSaveStr);
		if(ret=="0") alert("保存列宽成功!");
	}

	obj.menuItemSaveColumnWidth.on('click',obj.menuItemSaveColumnWidth_click,obj);

	obj.statLegendMenu=new Ext.menu.Menu({
		items:[
		]
	});

	InitChartMenu(obj);

	obj.txtGridDataFilter = new Ext.form.TextField({
		anchor : '95%'
		,enableKeyEvents:true
		,minLength:0
		,maxLength:20
		,emptyText:'回车在结果中查询'
		,listeners:{
			'specialkey':function(event){
				if(window.event.keyCode==13)
				{
					obj.queryFilter=this.getValue();
					obj.menuItemShowLastResult_click();
				}
			}
		}
	});


	obj.gridHeaderTool=new Ext.Toolbar(
	{
		height: 35
		,items:[
			new Ext.form.Label({text:"显示0值:",forId:'chkShowZero'})
			,obj.chkShowZero
			,"-"
			,{   
				text:"导出",
				iconCls:'icon-printer',
				menu:obj.printMenu
			}
			,"-"
			,{   
				text:"工具", 
				iconCls:'icon-wrench',
				menu:obj.toolMenu
			}
			,"-"
			,obj.comRetSumType
			,"-"
			,{   
				text:"统计图例",
				iconCls:'icon-server_chart',
				menu:obj.statLegendMenu 
			}
			,"-"
			,obj.txtGridDataFilter
			//,'<marquee scrollamount="2" scrolldelay="75" width="187">正在查询第1天的数据</marquee>'
		]
	});

	obj.comboPageSize = new Ext.form.ComboBox({
		name : 'pagesize',
		triggerAction : 'all',
		mode : 'local',
		store : new Ext.data.ArrayStore({
			fields : ['value', 'text'],
			data : [
				[10, '10'], [20, '20'],
				[50, '50'], [100, '100'],
				[250, '250'], [500, '500'],
				[1000, '1000']
			]
		}),
		valueField : 'value',
		displayField : 'text',
		value : '50',
		editable : true,
		width : 65,
		listeners:{
			'select':function(){
				obj.pageSize = this.getValue();
				obj.gridPagingTool.pageSize = obj.pageSize;
				if(obj.anciId)
				{
					obj.retGridPanelStore.removeAll();
					obj.retGridPanelStore.load({
						params : {
							start:obj.currentPageStart
							,limit:obj.pageSize
						}
					});
				}
			}
		}
	});

	obj.gridPagingTool = new Ext.PagingToolbar({
		pageSize : obj.pageSize,
		store : obj.retGridPanelStore,
		displayMsg: '显示记录： {0} - {1} 合计： {2}',
		displayInfo: true,
		emptyMsg: '没有记录',
		items : ['-', '&emsp;每页显示', obj.comboPageSize,'行记录'],
		listeners :{
			'change':function(){
				obj.currentPageStart = this.cursor;
			}
		}
	});
}