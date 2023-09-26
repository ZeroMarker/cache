//20170307+dyl
function InitViewScreen(){
	var obj = new Object();

	obj.sdate = new Ext.form.DateField({
		id : 'sdate'
		,value : new Date()
		//,format : 'Y-m-d'
		,fieldLabel:'特殊日期'
		,labelSeparator: ''
		,anchor : '95%'
	});

	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,iconCls : 'icon-insert'
		,width:86
		,text : '增加'
	});

	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,iconCls : 'icon-delete'
		,width:86
		,text : '删除'
	});
		
	obj.sdatePanel=new Ext.Panel({
		id:'sdatePanel'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
		    obj.sdate
		]
	}) 

	obj.addPanel=new Ext.Panel({
		id:'addPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,style:'margin-left:20px'
		,layout : 'form'
		,items:[
		    obj.addbutton
		]
	})
	
	obj.delPanel=new Ext.Panel({
		id:'delPanel'
		,buttonAlign : 'left'
		,columnWidth : .1
		,style:'margin-left:20px'
		,layout : 'form'
		,items:[
		    obj.deletebutton
		]
	})
		
    obj.toolPanel = new Ext.form.FormPanel({
		id : 'toolPanel'
		,buttonAlign : 'center'
		,height : 65
		,labelWidth : 100
		,labelAlign : 'right'
		,title : '特殊手术日维护'
		,iconCls:'icon-date'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,items:[
			obj.sdatePanel
		    ,obj.addPanel
		    ,obj.delPanel
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
			idProperty: 'appdate'
		}, 
	    [
			{name: 'appdate', mapping : 'appdate'}
			,{name: 'week', mapping: 'week'}
			,{name: 'status', mapping: 'status'}

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
				header: '特殊日期'
				,width: 200
				,dataIndex: 'appdate'
				,sortable: true
				}
        	,{
		        header: '星期'
				, width: 150
				, dataIndex: 'week'
				, sortable: true
					
			}
			,{
				header: '状态'
				, width: 150
				, dataIndex: 'status'
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
		param.ClassName = 'web.DHCANCOrc';
		param.QueryName = 'FindAncAppDate';
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
   obj.dataPanel = new Ext.Panel({
		id : 'dataPanel'
		,buttonAlign : 'center'
		,title : '特殊手术日查询结果'
		,iconCls:'icon-result'
		,region : 'center'
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
			obj.toolPanel
			,obj.dataPanel
		]
	});
	
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}