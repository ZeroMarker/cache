//by+2017-03-03
function InitViewScreen(){
	var obj = new Object();
	obj.floorname = new Ext.form.TextField({
		id : 'floorname'
		,fieldLabel : '楼层名称'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	obj.floorno = new Ext.form.TextField({
		id : 'floorno'
		,fieldLabel : '楼层代码'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });
	  	
   	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.floorno
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.floorname
		]
	});
    obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 30
		,columnWidth : .4
		,region : 'north'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Rowid
		]
	});
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:86
		,text : '增加'
		,style:'margin-left :15px;'
		,iconCls : 'icon-add'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,text : '更新'
		,style:'margin-left :15px;'
		,iconCls : 'icon-updateSmall'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,text : '删除'
		,style:'margin-left :15px;'
		,iconCls : 'icon-delete'
	});
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'right'
		//,height : 80
		,columnWidth : .25
		,layout : 'column'
		,items:[
		    obj.addbutton
		]
//		,buttons:[
//			obj.addbutton
//		]
	});
	obj.updatepanel = new Ext.Panel({
		id : 'updatepanel'
		,buttonAlign : 'center'
		//,height : 65		
		,columnWidth : .25
		,layout : 'column'
		,items:[
		    obj.updatebutton
		]
//		,buttons:[
//			obj.updatebutton
//		]
	});
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'center'
		//,height : 65
		,columnWidth : .25
		,layout : 'column'
		,items:[
		    obj.deletebutton
		    ]
//		,buttons:[
//			obj.deletebutton
//		]
	});	
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 30
		,region : 'center'
		,columnWidth : .4
		,layout : 'column'
		,items:[
			obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
		]
	});
	obj.floorPanel = new Ext.Panel({
		id : 'floorPanel'
		,buttonAlign : 'center'
		,height : 65
		,title : '手术间楼层维护'
		,region : 'north'
		,iconCls : 'icon-manage'
		,style:'margin-top :5px;'
		,layout : 'column'
		,frame : true
		,collapsible:true
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
			idProperty: 'RowId'
		}, 
	    [
			{name: 'ANCF_Desc', mapping : 'ANCF_Desc'}
			,{name: 'ANCF_Code', mapping: 'ANCF_Code'}
			,{name: 'RowId', mapping: 'RowId'}

		])
	});
    var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{
				header: '楼层名称'
				,width: 280
				,dataIndex: 'ANCF_Desc'
				,sortable: true
				}
        	,{
		        header: '楼层代码'
				, width: 280
				, dataIndex: 'ANCF_Code'
				, sortable: true
					
			}
			,{
				header: '系统号'
				, width: 100
				, dataIndex: 'RowId'
				, sortable: true
			}
		
		]
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
//		,viewConfig:
//		{
//			forceFit: false
//		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});

	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCFloor';
		param.QueryName = 'FindexeFloor';
		//param.Arg1 = 'OpaStatus';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
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
		,title : '楼层查询结果'
		,region : 'center'
		,iconCls:'icon-result'
		,style:'margin-top :5px;'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
		]
	});

    obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.floorPanel
			,obj.resultPanel
		]
	});
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}