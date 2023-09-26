//20170302+dyl
function InitViewScreen()
{
	var obj = new Object();
	
	//RowId
	obj.RowId = new Ext.form.TextField({
		id : 'RowId'
		,hidden : true
		,anchor : '95%'
	});
	
	//图例代码
	obj.ANICode = new Ext.form.TextField({
		id : 'ANICode'
		,fieldLabel : '图例代码'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	
	//图例宽
	obj.ANIWidth = new Ext.form.TextField({
		id : 'ANIWidth'
		,fieldLabel : '图例宽'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	//绘图数据
	obj.ANIData = new Ext.form.TextField({
		id : 'ANIData'
		,fieldLabel : '绘图数据'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,labelWidth:80
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.ANICode
			,obj.ANIWidth
			
		]
	});
	
	//图例名称
	obj.ANIDesc = new Ext.form.TextField({
		id : 'ANIDesc'
		,fieldLabel : '图例名称'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	//图例高
	obj.ANIHeight = new Ext.form.TextField({
		id : 'ANIHeight'
		,fieldLabel : '图例高'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	//线宽
	obj.ANILineWidth = new Ext.form.TextField({
		id : 'ANILineWidth'
		,fieldLabel : '线宽'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,labelWidth:80
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.ANIDesc
			,obj.ANIHeight
				
		]
	});
	
	
	//图形名
	obj.ANIShape = new Ext.form.TextField({
		id : 'ANIShape'
		,fieldLabel : '图形名'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	//定位点坐标(X)
	obj.ANIPositionX = new Ext.form.TextField({
		id : 'ANIPositionX'
		,fieldLabel : '定位点坐标(X)'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	//图例点数
	obj.ANICount = new Ext.form.TextField({
		id : 'ANICount'
		,fieldLabel : '图例点数'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	//定位点坐标(Y)
	obj.ANIPositionY = new Ext.form.TextField({
		id : 'ANIPositionY'
		,fieldLabel : '定位点坐标(Y)'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,labelWidth:80
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.ANICount
			,obj.ANIShape
			,obj.RowId
		]
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,labelWidth:100
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.ANIPositionX
			,obj.ANIPositionY
		]
	});
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,labelWidth:80
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		obj.ANIData
		,obj.ANILineWidth
		]
	});
	
	obj.fPanel = new Ext.form.FormPanel({
		id:"fPanel"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:90
		,height:100
		,region:"center"
		,layout:"column"
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.Panel5
		]
	});
	
	
	obj.addButton = new Ext.Button({
		id : 'addButton'
		,width:86
		,iconCls : 'icon-insert'
		,text : '新增'
	});
	
	obj.deleteButton = new Ext.Button({
		id : 'deleteButton'
		,width:86
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	obj.findButton = new Ext.Button({
		id : 'findButton'
		,width:86
		,iconCls : 'icon-find'
		,text : '查询'
	});	
	obj.updateButton = new Ext.Button({
		id : 'updateButton'
		,width:86
		,iconCls : 'icon-update'
		,text : '更新'
	});
	
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,style:'margin-left:10px'
		,layout : 'column'
		,items:[
		    obj.addButton
		]
	});
	
	obj.updatepanel = new Ext.Panel({
		id : 'updatepanel'
		,buttonAlign : 'center'	
		,columnWidth : .2
		,style:'margin-left:-80px'
		,layout : 'column'
		,items:[
		    obj.updateButton
		]

	});
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'center'
		,columnWidth : .2
		,style:'margin-left:-15px'
		,layout : 'column'
		,items:[
		    obj.deleteButton
		    ]

	});	
	obj.findpanel = new Ext.Panel({
		id : 'findpanel'
		,buttonAlign : 'center'
		,columnWidth : .2
		,style:'margin-left:100px'
		,layout : 'column'
		,items:[
		    obj.findButton
		    ]

	});	
	
	obj.buttonPanel = new Ext.Panel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 30
		,region : 'south'
		,layout : 'column'
		,items:[
			obj.findpanel
			,obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
		]
	});
	obj.floorPanel = new Ext.Panel({
		id : 'floorPanel'
		,buttonAlign : 'center'
		
		,height : 95
		,region : 'north'
		,layout : 'border'
		,frame : true
		//,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
			,obj.buttonPanel
		]
    });
    
    obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'code'
		}, 
	    [
			{name: 'ANICode', mapping : 'ANICode'}
			,{name: 'ANIDesc', mapping: 'ANIDesc'}
			,{name: 'ANICount', mapping: 'ANICount'}
			,{name: 'ANIWidth', mapping: 'ANIWidth'}
			,{name: 'ANIHeight', mapping: 'ANIHeight'}
			,{name: 'ANIPositionX', mapping: 'ANIPositionX'}
			,{name: 'ANIPositionY', mapping: 'ANIPositionY'}
			,{name: 'ANILineWidth', mapping: 'ANILineWidth'}
			,{name: 'ANIShape', mapping: 'ANIShape'}
			,{name: 'ANIData', mapping: 'ANIData'}
			,{name: 'rowid0', mapping: 'rowid0'}

		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '图例',width: 140,dataIndex: 'ANICode',sortable: true}
			,{header: '图例名称',width: 120,dataIndex: 'ANIDesc',sortable: true}
        	,{header: '图例点数',width: 80,dataIndex: 'ANICount',sortable: true}
			,{header: '图例宽',width: 60,dataIndex: 'ANIWidth',sortable: true}
			,{header: '图例高',width: 60,dataIndex: 'ANIHeight',sortable:true}
			,{header: '定位点坐标(X)',width: 100,dataIndex: 'ANIPositionX',sortable:true}
			,{header: '定位点坐标(Y)',width: 100,dataIndex: 'ANIPositionY',sortable:true}
			,{header: '线宽',width: 60,dataIndex: 'ANILineWidth',sortable:true}
			,{header: '图形名',width: 60,dataIndex: 'ANIShape',sortable:true}
			,{header: '绘图数据',width: 200,dataIndex: 'ANIData',sortable:true}
			,{header: 'aniRowId',width: 80,dataIndex: 'rowid0',sortable:true}
		]
	});
	
	 obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) 
		,clicksToEdit:1    
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCIcon';
		param.QueryName = 'GetDHCANCIcon';
		param.Arg1 = obj.ANICode.getRawValue();
		param.Arg2 = obj.ANIDesc.getRawValue();
		param.ArgCnt = 2;
	});
	obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});
	
	obj.Panel23 = new Ext.Panel({
		id : 'Panel23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	
	obj.Panel25 = new Ext.Panel({
		id : 'Panel25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});
	
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
		]
	});
	obj.DHCANCIcon = new Ext.Panel({
		id : 'DHCANCIcon'
		,buttonAlign : 'center'
		,title : '图标维护'
		,iconCls : 'icon-manage'
		,region : 'center'
		,layout : 'border'
		,frame : true
		//,collapsible:true
		,animate:true
		,items:[
			obj.floorPanel
			,obj.resultPanel
		]
	});
	
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.DHCANCIcon
		]
	}); 
	
	
	//事件
	InitViewScreenEvent(obj);
	
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
    obj.addButton.on("click", obj.addButton_click, obj);
    obj.updateButton.on("click", obj.updateButton_click, obj);
    obj.deleteButton.on("click", obj.deleteButton_click, obj);
    obj.findButton.on("click", obj.findButton_click, obj);
	
	return obj;	
	
}	