//update by GY 20170307
 function InitViewScreen()
{
	var obj = new Object();
	obj.ANCSUCode = new Ext.form.TextField({
		id : 'ANCSUCode'
		,fieldLabel : '代码'
		,labelSeparator: ''
		,anchor : '90%'
	});
	
	obj.ANCSUDesc = new Ext.form.TextField({
		id : 'ANCSUDesc'
		,fieldLabel : '描述'
		,labelSeparator: ''
		,anchor : '90%'
	});
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .18
		,labelWidth : 70
		,layout : 'form'
		,items:[
			obj.ANCSUCode
			,obj.ANCSUDesc
		]
	});
	
	obj.ANCSUType = new Ext.form.TextField({
		id : 'ANCSUType'
		,fieldLabel : '类型'
		,labelSeparator: ''
		,anchor : '90%'
	});	
	
	
	obj.ANCSUUomDr = new Ext.form.TextField({
		id : 'ANCSUUomDr'
		,fieldLabel : '单位指向'
		,labelSeparator: ''
		,anchor : '90%'
	});	
	
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .20
		,labelWidth : 100
		,layout : 'form'
		,items:[
			obj.ANCSUType
			,obj.ANCSUUomDr
		]
	});
	obj.ANCSUFactor = new Ext.form.TextField({
		id : 'ANCSUFactor'
		,fieldLabel : '因素'
		,labelSeparator: ''
		,anchor : '90%'
	});	
	
	
	obj.ANCSUByPatWeight = new Ext.form.TextField({
		id : 'ANCSUByPatWeight'
		,fieldLabel : '病人体重'
		,labelSeparator: ''
		,anchor : '90%'
	});	
	
	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .20
		,labelWidth : 100
		,layout : 'form'
		,items:[
			obj.ANCSUFactor
			,obj.ANCSUByPatWeight
		]
	});
	
	/*obj.ANCSUBaseSpeedUnitDr = new Ext.form.TextField({
		id : 'ANCSUBaseSpeedUnitDr'
		,fieldLabel : 'ANCSUBaseSpeedUnitDr'
		,anchor : '95%'
	});	*/
	
	obj.ANCSUBaseSpeedUnitDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.ANCSUBaseSpeedUnitDrStore = new Ext.data.Store({
		proxy: obj.ANCSUBaseSpeedUnitDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tCode'
		}, 
		[
		     {name: 'tCode', mapping: 'tCode'}
			,{name: 'tDesc', mapping: 'tDesc'}
		])
	});	
	obj.ANCSUBaseSpeedUnitDr = new Ext.form.ComboBox({
		id : 'ANCSUBaseSpeedUnitDr'
		,store:obj.ANCSUBaseSpeedUnitDrStore
		,minChars:1	
		,displayField:'tCode'	
		,fieldLabel : '基础速度指向'
		,valueField : 'tCode'
		,triggerAction : 'all'
		,anchor : '90%'
		,editable : false
		,selectOnFocus : true
		,labelSeparator: ''
		,mode: 'local'
	}); 	
	
	obj.ANCSUBaseSpeedUnitDrStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCSpeedUnit';
		param.QueryName = 'LookUpSpeed';
		//param.Arg1=obj.ANCSUBaseSpeedUnitDr.getValue();
		//param.Arg1='ReturnType'
		param.ArgCnt = 0;
	});
	obj.ANCSUBaseSpeedUnitDrStore.load({});
	
	obj.ANCSUBaseUomFactor = new Ext.form.TextField({
		id : 'ANCSUBaseUomFactor'
		,fieldLabel : '基础单位因素'
		,labelSeparator: ''
		,anchor : '90%'
	});	
	
	
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,labelWidth : 120
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.ANCSUBaseSpeedUnitDr
			,obj.ANCSUBaseUomFactor
		]
	});
	
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		//,hidden:true
		,anchor : '95%'
		,labelSeparator: ''
	});	
	
	
	
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:86
		,iconCls : 'icon-add'
		,text : '增加'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,iconCls : 'icon-updateSmall'
		,style: 'margin-Top:3px;'
		,text : '更新'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,iconCls : 'icon-delete'
		,style: 'margin-Top:3px;'
		,text : '删除'
	});
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'center'
		,columnWidth : .2
		,style: 'margin-left:20px;'
		,layout : 'form'
		,items:[
		    obj.addbutton
		    ,obj.updatebutton
		    ,obj.deletebutton
		]

	});
	
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    //obj.updatebutton
		    ]

	});	
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,region : 'south'
		,layout : 'column'
		,items:[
			//obj.addpanel
			//,obj.updatepanel
			//,obj.deletepanel
		]
	});
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.addpanel
			//,obj.deletepanel
		]
	});
	obj.floorPanel = new Ext.Panel({
		id : 'floorPanel'
		,buttonAlign : 'center'
		,height : 80
		,width:800
		,region : 'north'
		,layout : 'form'
		,items:[
			obj.fPanel
			//,obj.buttonPanel
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
			{name: 'ANCSUCode', mapping : 'ANCSUCode'}
			,{name: 'ANCSUDesc', mapping: 'ANCSUDesc'}
			,{name: 'ANCSUType', mapping: 'ANCSUType'}
			,{name: 'ANCSUUomDr', mapping: 'ANCSUUomDr'}
			,{name: 'ANCSUFactor', mapping: 'ANCSUFactor'}
			,{name: 'ANCSUByPatWeight', mapping: 'ANCSUByPatWeight'}
			,{name: 'ANCSUBaseSpeedUnitDr', mapping: 'ANCSUBaseSpeedUnitDr'}
			,{name: 'ANCSUBaseUomFactor', mapping: 'ANCSUBaseUomFactor'}
			,{name: 'ANCSUBaseSpeedUnitDrdesc', mapping: 'ANCSUBaseSpeedUnitDrdesc'}
			,{name: 'Rowid', mapping: 'Rowid'}

		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '代码',width: 100,dataIndex: 'ANCSUCode',sortable: true}
			,{header: '描述',width: 100,dataIndex: 'ANCSUDesc',sortable: true}
        	,{header: '类型',width: 100,dataIndex: 'ANCSUType',sortable: true}
			,{header: '单位指向',width: 100,dataIndex: 'ANCSUUomDr',sortable: true}
			,{header: '因素',width: 100,dataIndex: 'ANCSUFactor',sortable: true}
			,{header: '病人体重',width: 100,dataIndex: 'ANCSUByPatWeight',sortable: true}
			,{header: '基础速度指向',width: 100,dataIndex: 'ANCSUBaseSpeedUnitDr',sortable: true}
			,{header: '基础单位因素',width: 100,dataIndex: 'ANCSUBaseUomFactor',sortable: true}
			,{header: '指向单位',width: 100,dataIndex: 'ANCSUBaseSpeedUnitDrdesc',sortable: true}
			,{header: 'Rowid',width: 100,dataIndex: 'Rowid',sortable: true,hidden:true}
		]
	});
	
	 obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) 
		,clicksToEdit:1    
		,loadMask : true
		,region : 'center'
		,title : '速度单位查询结果'
		,iconCls : 'icon-result'
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
		param.ClassName = 'web.DHCICUCSpeedUnit';
		param.QueryName = 'FindQuerySpeed';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
	
	
	obj.AnOpReport = new Ext.Panel({
		id : 'AnOpReport'
		,buttonAlign : 'center'
		,height : 200
		,width:400
		,title : '速度单位维护'
		,region : 'center'
		,layout : 'border'
		,iconCls : 'icon-manage'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.floorPanel
			,obj.retGridPanel
		]
	});
	
	
	
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.AnOpReport
		]
	}); 
	
	
	InitViewScreenEvent(obj);
	
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
    obj.addbutton.on("click", obj.addbutton_click, obj);
    obj.updatebutton.on("click", obj.updatebutton_click, obj);
    obj.deletebutton.on("click", obj.deletebutton_click, obj);
    
    obj.LoadEvent(arguments);    
    return obj;	
}