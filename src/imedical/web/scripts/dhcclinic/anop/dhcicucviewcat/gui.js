function InitViewScreen(){
	var obj = new Object();
	
	obj.icucvcCode = new Ext.form.TextField({
		id : 'icucvcCode'
		,fieldLabel : '显示代码类型'
		,anchor : '95%'
	});	

	obj.icucvcEventstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.icucvcEventstore = new Ext.data.Store({
		proxy: obj.icucvcEventstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvcEvent'
			}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.icucvcEvent = new Ext.form.ComboBox({
		id : 'icucvcEvent'
		,store:obj.icucvcEventstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '显示事件'
		,valueField : 'Desc'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.icucvcDisplayByCatstoreProxy =new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.icucvcDisplayByCatstore = new Ext.data.Store({
		proxy: obj.icucvcDisplayByCatstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvcDisplayByCat'
			}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.icucvcDisplayByCat = new Ext.form.ComboBox({
		id : 'icucvcDisplayByCat'
		,store:obj.icucvcDisplayByCatstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '按分类显示'
		,valueField : 'Desc'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.RowId = new Ext.form.TextField({
		id : 'RowId'
		,hidden : true
    });
	 
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.icucvcCode
			,obj.icucvcEvent
			,obj.icucvcDisplayByCat
			,obj.RowId
		]
	});
	
	obj.icucvcDesc = new Ext.form.TextField({
		id : 'icucvcDesc'
		,fieldLabel : '显示代码名称'
		,anchor : '95%'
	});	
	
	obj.icucvcOrderstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.icucvcOrderstore = new Ext.data.Store({
		proxy:  obj.icucvcOrderstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvcOrder'
			}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.icucvcOrder = new Ext.form.ComboBox({
		id : 'icucvcOrder'
		,store:obj.icucvcOrderstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '显示用药'
		,valueField : 'Desc'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.icucvscDescstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.icucvscDescstore = new Ext.data.Store({
		proxy: obj.icucvscDescstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvscId'
		}, 
		[
			{name: 'icucvscId', mapping: 'icucvscId'}
			,{name: 'icucvscDesc', mapping: 'icucvscDesc'}
		])
	});
	obj.icucvscDesc = new Ext.form.ComboBox({
		id : 'icucvscDesc'
		,store:obj.icucvscDescstore
		,minChars:1
		,displayField:'icucvscDesc'
		,fieldLabel : '显示大类'
		,valueField : 'icucvscId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.icucvscId = new Ext.form.TextField({
		id : 'icucvscId'
		,hidden : true
    });
    
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.icucvcDesc
			,obj.icucvcOrder
			,obj.icucvscDesc
			,obj.icucvscId
		]
	});
	
	obj.icucvcVPSitestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.icucvcVPSitestore = new Ext.data.Store({
		proxy:  obj.icucvcVPSitestoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvcVPSite'
			}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.icucvcVPSite = new Ext.form.ComboBox({
		id : 'icucvcVPSite'
		,store:obj.icucvcVPSitestore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '静脉穿刺'
		,valueField : 'Desc'
		,triggerAction : 'all'
		,anchor : '95%'
	});

	obj.icucvcTherapystoreProxy =new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    /*function seltextstatus(v, record) { 
         return record.Id+" || "+record.Desc; 
    } */
	obj.icucvcTherapystore = new Ext.data.Store({
		proxy: obj.icucvcTherapystoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvcTherapy'
			}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
			//,{ name: 'selecttexts', convert: seltextstatus}
		])
	});
	obj.icucvcTherapy = new Ext.form.ComboBox({
		id : 'icucvcTherapy'
		,store:obj.icucvcTherapystore
		,minChars:1
		,displayField:'Desc'
		//,displayField:'selecttexts'
		,fieldLabel : '显示治疗'
		,valueField : 'Desc'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.icucvcSummaryTypestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.icucvcSummaryTypestore = new Ext.data.Store({
		proxy: obj.icucvcSummaryTypestoreProxy,
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
	obj.icucvcSummaryType = new Ext.form.ComboBox({
		id : 'icucvcSummaryType'
		,store:obj.icucvcSummaryTypestore
		,minChars:1
		,displayField:'tCode'
		,fieldLabel : '汇总类型'
		,valueField : 'tCode'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.icucvcVPSite
			,obj.icucvcTherapy
			,obj.icucvcSummaryType
		]
	});

		obj.icucvcVSstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.icucvcVSstore = new Ext.data.Store({
		proxy:  obj.icucvcVSstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvcVS'
			}, 
		[
			{name: 'Desc', mapping: 'Desc'}
			,{name: 'Id', mapping: 'Id'}
			
		])
	});
	obj.icucvcVS = new Ext.form.ComboBox({
		id : 'icucvcVS'
		,store:obj.icucvcVSstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '显示生命体征'
		,valueField : 'Desc'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.icucvcLabstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
   /* function seltext(v, record) { 
         return record.tID+" || "+record.tBPCEMDesc; 
    } */
    
	obj.icucvcLabstore = new Ext.data.Store({
		proxy: obj.icucvcLabstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvcLab'
			}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		    //,{ name: 'selecttext', convert: seltext}
		])
	});
	obj.icucvcLab = new Ext.form.ComboBox({
		id : 'icucvcLab'
		,store:obj.icucvcLabstore
		,minChars:1
		,displayField:'Desc'
		//,displayField:'selecttext'
		,fieldLabel : '显示检验'
		,valueField : 'Desc'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.icucvcOptions = new Ext.form.TextField({
		id : 'icucvcOptions'
		,fieldLabel : '选项'
		,anchor : '95%'
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.icucvcVS
			,obj.icucvcLab
			,obj.icucvcOptions
		]
	});
	
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
		]
	});

	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,text : '添加'
	});

	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,text : '更新'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,text : '删除'
	});
	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,text : '查找'
	});

	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,buttonAlign : 'center'
		//,columnWidth : .72
		,layout : 'column'
        ,buttons:[
            obj.addbutton
            ,obj.updatebutton
            ,obj.deletebutton
            ,obj.findbutton
       ]
	});

	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 50
		,region : 'south'
		,layout : 'column'
		,frame : false
		,items:[
			obj.keypanel
		]
	});
	
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 180
		,title : '重症显示分类维护'
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
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
			idProperty: 'tRowId'
		}, 
	    [
			{name: 'tRowId', mapping: 'tRowId'}
			,{name: 'tIcucvcCode', mapping: 'tIcucvcCode'}
			,{name: 'tIcucvcDesc', mapping: 'tIcucvcDesc'}
			,{name: 'tIcucvcVPSite', mapping: 'tIcucvcVPSite'}
			,{name: 'tIcucvcVS', mapping: 'tIcucvcVS'}
			,{name: 'tIcucvcEvent', mapping: 'tIcucvcEvent'}
			,{name: 'tIcucvcOrder', mapping: 'tIcucvcOrder'}
			,{name: 'tIcucvcTherapy', mapping: 'tIcucvcTherapy'}
			,{name: 'tIcucvcLab', mapping: 'tIcucvcLab'}
			,{name: 'tIcucvscDesc', mapping: 'tIcucvscDesc'}
			,{name: 'tIcucvscId', mapping: 'tIcucvscId'}
			,{name: 'tIcucvcDisplayByCat', mapping: 'tIcucvcDisplayByCat'}
			,{name: 'tIcucvcSummaryType', mapping: 'tIcucvcSummaryType'}
			,{name: 'tIcucvcSummaryTypeDesc', mapping: 'tIcucvcSummaryTypeDesc'}
			,{name: 'tIcucvcOptions', mapping: 'tIcucvcOptions'}
		])
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: '行号', width: 50, dataIndex: 'tRowId', sortable: true}
		,{header: '显示类型代码', width: 100, dataIndex: 'tIcucvcCode', sortable: true}
		,{header: '显示类型名称', width: 100, dataIndex: 'tIcucvcDesc', sortable: true}
		,{header: '显示生命体征', width: 100, dataIndex: 'tIcucvcVS', sortable: true}
		,{header: '显示事件', width: 60, dataIndex: 'tIcucvcEvent', sortable: true}
		,{header: '显示用药', width: 60, dataIndex: 'tIcucvcOrder', sortable: true}
		,{header: '静脉穿刺', width: 60, dataIndex: 'tIcucvcVPSite', sortable: true}
		,{header: '显示治疗', width: 60, dataIndex: 'tIcucvcTherapy', sortable: true}
		,{header: '显示检验', width: 60, dataIndex: 'tIcucvcLab', sortable: true}
		,{header: '按分类显示', width: 70, dataIndex: 'tIcucvcDisplayByCat', sortable: true}
		,{header: '显示大类', width: 60, dataIndex: 'tIcucvscDesc', sortable: true}
		,{header: 'tIcucvscId', width: 70, dataIndex: 'tIcucvscId', sortable: true}
		,{header: '小结类型', width: 60, dataIndex: 'tIcucvcSummaryType', sortable: true}
		]
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
	
	obj.icucvcEventstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUCVC';
		param.ArgCnt = 0;
	});
	obj.icucvcEventstore.load({});
	
	obj.icucvcDisplayByCatstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUCVC';
		param.ArgCnt = 0;
	});
	obj.icucvcDisplayByCatstore.load({});

obj.icucvcOrderstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUCVC';
		param.ArgCnt = 0;
	});
	obj.icucvcOrderstore.load({});

obj.icucvcVPSitestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUCVC';
		param.ArgCnt = 0;
	});
	obj.icucvcVPSitestore.load({});

obj.icucvcTherapystoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUCVC';
		param.ArgCnt = 0;
	});
	obj.icucvcTherapystore.load({});	

obj.icucvcVSstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUCVC';
		param.ArgCnt = 0;
	});
	obj.icucvcVSstore.load({});		
	
obj.icucvcLabstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUCVC';
		param.ArgCnt = 0;
	});
	obj.icucvcLabstore.load({});		
	

	obj.icucvscDescstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindVSC';
		param.ArgCnt = 0;
	});
	obj.icucvscDescstore.load({});
	
	obj.icucvcSummaryTypestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1 = 'SummaryType';
		param.ArgCnt = 1;
	});
	obj.icucvcSummaryTypestore.load({});
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUViewCat';
		param.Arg1 = obj.icucvcCode.getValue();
		param.Arg2 = obj.icucvcDesc.getValue();
		param.ArgCnt = 2;
	});
	obj.retGridPanelStore.load({});
	
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
    obj.findbutton.on("click", obj.findbutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}