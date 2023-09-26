function InitViewScreen(){
	var obj = new Object();
	
	obj.BPCNBPCNurseGroupDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltextng(v, record) { 
         return record.rowId+" || "+record.Desc; 
    } 
	obj.BPCNBPCNurseGroupDrstore = new Ext.data.Store({
		proxy: obj.BPCNBPCNurseGroupDrstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowId'
		}, 
		[
			{name: 'rowId', mapping: 'rowId'}
			,{ name: 'selecttext', convert: seltextng}
			//,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.BPCNBPCNurseGroupDr = new Ext.form.ComboBox({
		id : 'BPCNBPCNurseGroupDr'
		,store:obj.BPCNBPCNurseGroupDrstore
		,minChars:1
		//,displayField:'Desc'
		,displayField:'selecttext'
		,fieldLabel : '护士组'
		,valueField : 'rowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.BPCNBPCNurseGroupDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCNurseGroup';
		param.QueryName = 'NurseGroup';
		param.ArgCnt = 0;
	});
	obj.BPCNBPCNurseGroupDrstore.load({});
		
	
	obj.BPCNNurseCTCPDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltextct(v, record) { 
         return record.ctcpId+" || "+record.ctcpDesc; 
    } 
	obj.BPCNNurseCTCPDrstore = new Ext.data.Store({
		proxy: obj.BPCNNurseCTCPDrstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctcpId'
		}, 
		[
			{name: 'ctcpId', mapping: 'ctcpId'}
			,{ name: 'selecttext', convert: seltextct}
			//,{name: 'ctcpDesc', mapping: 'ctcpDesc'}
			//,{name: 'ctcpAlias', mapping: 'ctcpAlias'}
		])
	});
	obj.BPCNNurseCTCPDr = new Ext.form.ComboBox({
		id : 'BPCNNurseCTCPDr'
		,store:obj.BPCNNurseCTCPDrstore
		,minChars:1
		//,displayField:'ctcpDesc'
		,displayField:'selecttext'
		,fieldLabel : '医护人员'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.BPCNNurseCTCPDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'FindCtcp';
		param.Arg1=obj.BPCNNurseCTCPDr.getRawValue();
		param.Arg2="NOPDEPT^OUTOPDEPT^EMOPDEPT";
		param.Arg3="";
		param.Arg4="";
		param.Arg5="";
		param.Arg6="";
		param.Arg7="";
		param.ArgCnt = 7;
	});
	obj.BPCNNurseCTCPDrstore.load({});

	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });
	  	
   	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.BPCNBPCNurseGroupDr
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.BPCNNurseCTCPDr
		]
	});
    obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 50
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
		,width:60
		,text : '增加'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:60
		,text : '更新'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:60
		,text : '删除'
	});
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'right'
		//,height : 80
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.addbutton
		]
	});
	obj.updatepanel = new Ext.Panel({
		id : 'updatepanel'
		,buttonAlign : 'center'
		//,height : 65		
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.updatebutton
		]
	});
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'center'
		//,height : 65
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.deletebutton
		    ]
	});	
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
		]
	});
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 110
		,title : '护士工作站'
		,region : 'north'
		,layout : 'border'
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
			idProperty: 'tBPCBPMRowId'
		}, 
	    [
			{name: 'tBPCNBPCNurseGroup', mapping : 'tBPCNBPCNurseGroup'}
			,{name: 'tBPCNBPCNurseGroupDr', mapping: 'tBPCNBPCNurseGroupDr'}
			,{name: 'tBPCNNurseCTCP', mapping: 'tBPCNNurseCTCP'}
			,{name: 'tBPCNNurseCTCPDr', mapping: 'tBPCNNurseCTCPDr'}
			,{name: 'tBPCNRowId', mapping: 'tBPCNRowId'}

		])
	});
    var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			//{header: '指向安全组Id',width: 200,dataIndex: 'tBPCNBPCNurseGroupDr',sortable: true}
           {header: '安全组', width: 450, dataIndex: 'tBPCNBPCNurseGroup', sortable: true}
           
           //,{header: '指向医护人员Id', width: 200, dataIndex: 'tBPCNNurseCTCPDr', sortable: true}
           ,{header: '医护人员', width: 450, dataIndex: 'tBPCNNurseCTCP', sortable: true}
           
		   ,{header: '系统号', width: 200, dataIndex: 'tBPCNRowId', sortable: true}
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
		param.ClassName = 'web.DHCBPCNurse';
		param.QueryName = 'FindDHCBPCNurse';
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
			obj.functionPanel
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