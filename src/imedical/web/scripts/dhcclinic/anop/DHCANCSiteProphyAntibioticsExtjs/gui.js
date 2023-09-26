function InitViewScreen(){
	var obj = new Object();
	
 function seletext(v,record) { 
         return record.BodySiteDesc+" || "+record.BodySiteRowId; 
    } 	
obj.OecBodySiteDescStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.OecBodySiteDescStore=new Ext.data.Store({
		proxy:obj.OecBodySiteDescStoreProxy,
		reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'BodySiteRowId'   
      		},
		[
			 {name:'BodySiteDesc',mapping:'BodySiteDesc'}
			,{name:'BodySiteRowId',mapping:'BodySiteRowId'}
			,{name:'DisPlayText',convert:seletext}
		])
		});	
	obj.OecBodySiteDesc = new Ext.form.ComboBox({
		id : 'OecBodySiteDesc'
		,fieldLabel : '身体部位'
		,store : obj.OecBodySiteDescStore
	    ,triggerAction : 'all'
	    ,displayField : 'DisPlayText'
	    ,valueField : 'BodySiteDesc'
	    ,editable : false
		,anchor : '95%'
	});	

	
	obj.ISDisplay = new Ext.form.TextField({
		id : 'ISDisplay'
		,fieldLabel : '是否激活'
		,anchor : '95%'
	});	
	
	 function seltext(v,record) { 
         return record.arcimId+"^"+record.arcimDesc; 
    } 
	obj.needArcimDescStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.needArcimDescStore=new Ext.data.Store({
		proxy:obj.needArcimDescStoreProxy,
		reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'arcimId'   
      		},
		[
			 {name:'arcimDesc',mapping:'arcimDesc'}
			,{name:'arcimId',mapping:'arcimId'}
			,{name:'selectText',convert:seltext}
		])
		});	
	obj.needArcimDesc = new Ext.form.ComboBox({
		id : 'needArcimDesc'
		,store : obj.needArcimDescStore
		,minChars:0
	    ,displayField : 'selectText'
	    ,fieldLabel : '医嘱名称'
	    ,triggerAction : 'all'
	    ,valueField : 'arcimId'
	    ,editable : true
		,anchor : '95%'
	});
	obj.RowId = new Ext.form.TextField({
		id : 'RowId'
		,hidden : true
    });
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .22
		,labelAlign : 'right'
		,labelWidth:80
		,layout : 'form'
		,items:[
			obj.OecBodySiteDesc
		   ,obj.RowId
		]
	});	

	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .22
		,labelAlign : 'right'
		,labelWidth:80
		,layout : 'form'
		,items:[
			obj.ISDisplay
		]
	});	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .35
		,labelAlign : 'right'
		,labelWidth:80
		,layout : 'form'
		,items:[
		   obj.needArcimDesc
		]
	});
   	obj.fPanel =  new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height :60
		,region : 'north'
		,layout : 'column'
		,items:[
		  	 obj.Panel1
			,obj.Panel2
			,obj.Panel3
		]
	});
	
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,text : '添加'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,text : '删除'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,text : '更新'
	});		
	obj.selectbutton = new Ext.Button({
		id : 'selectbutton'
		,text : '查询'
	});	
	obj.bpanel1 = new Ext.Panel({
		id : 'bpanel1'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
	    ,buttons:[
            obj.addbutton
       ]
	});
	obj.bpanel2 = new Ext.Panel({
		id : 'bpanel2'
		,buttonAlign : 'center'	
		,columnWidth : .20
		,layout : 'form'
	    ,buttons:[
           obj.deletebutton            
       ]
	});
	obj.bpanel3 = new Ext.Panel({
		id : 'bpanel3'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
	    ,buttons:[
	        obj.updatebutton           
       ]
	});
	obj.bpanel4 = new Ext.Panel({
		id : 'bpanel4'
		,buttonAlign : 'center'
		,columnWidth : .20		
		,layout : 'form'
	    ,buttons:[
	        obj.selectbutton           
       ]
	});	
	
	obj.bPanel = new Ext.form.FormPanel({
		id : 'bPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 20
		,height : 60
		,region : 'center'
		,layout : 'column'
		,items:[
		  	 obj.bpanel1
		  	,obj.bpanel2
		  	,obj.bpanel3
		  	,obj.bpanel4		
		  	]
	});
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 180
		,title : '身体部位对应医嘱'
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			 obj.fPanel
			,obj.bPanel

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
	         {name: 'tSPABodySite', mapping:'SPABodySite'}
			,{name: 'tSPAArcim', mapping:'SPAArcim'}
			,{name: 'tSPAActive', mapping :'SPAActive'}
			,{name: 'tRowID', mapping:'SPARowID'}
			,{name: 'tSPAArcimID', mapping:'SPAArcimID'}

		])
	});
     var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '身体部位',width: 150,dataIndex: 'tSPABodySite',sortable: true}
		   ,{header: '医嘱名称',width: 300,dataIndex: 'tSPAArcim',sortable: true}
           ,{header: '激活', width: 150, dataIndex: 'tSPAActive', sortable: true}
		   ,{header: 'RowId', width: 150, dataIndex: 'tRowID', sortable: true}
		    ,{header: '医嘱名称ID', width: 150, dataIndex: 'tSPAArcimID', sortable: true,hidden:true}
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
		,bbar: new Ext.PagingToolbar({
			pageSize : 400,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});


     obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.functionPanel
			,obj.retGridPanel
		]
	});	
	
	obj.OecBodySiteDescStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANCSiteProphyAntibiotics';
			param.QueryName = 'FindBodySite';
			param.ArgCnt = 0;
	});
	obj.needArcimDescStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANCSiteProphyAntibiotics';
			param.QueryName = 'GetMasterItem';
			param.Arg1='';
			param.Arg2=obj.needArcimDesc.getRawValue();
			param.ArgCnt = 2;
	});	
     obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANCSiteProphyAntibiotics';
			param.QueryName = 'FindANCSPA';
			param.ArgCnt = 0;
     });
        obj.retGridPanelStore.load({});
        obj.OecBodySiteDescStore.load({});
        obj.needArcimDescStore.load({});  
     	InitViewScreenEvent(obj);
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.needArcimDesc.on('select',obj.needArcimDesc_select,obj);
    obj.addbutton.on("click",obj.addbutton_click,obj);
	obj.updatebutton.on("click",obj.updatebutton_click,obj);
	obj.deletebutton.on("click",obj.deletebutton_click,obj);
	obj.selectbutton.on("click",obj.selectbutton_click,obj);
	obj.LoadEvent(arguments);
    return obj;
}