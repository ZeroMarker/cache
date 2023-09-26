function InitViewScreen(){
	var obj = new Object();
	
	obj.bpcNGCode = new Ext.form.TextField({
		id : 'bpcNGCode'
		,fieldLabel : '����'
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
			obj.bpcNGCode
			,obj.RowId
		]
	});
	
	obj.bpcNGDesc = new Ext.form.TextField({
		id : 'bpcNGDesc'
		,fieldLabel : '����'
		,anchor : '95%'
	}); 
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.bpcNGDesc
		]
	});
	
	obj.bpcNGWardDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltextward(v, record) { 
         return record.wardRowid+" || "+record.wardDesc; 
    } 
    
	obj.bpcNGWardDrstore = new Ext.data.Store({
		proxy: obj.bpcNGWardDrstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'wardRowid'
		}, 
		[
			{name: 'wardRowid', mapping: 'wardRowid'}
			,{ name: 'selecttext', convert: seltextward}
			//,{name: 'wardDesc', mapping: 'wardDesc'}
		])
	});
	obj.bpcNGWardDr = new Ext.form.ComboBox({
		id : 'bpcNGWardDr'
		,store:obj.bpcNGWardDrstore
		,minChars:1
		//,displayField:'wardDesc'
		,displayField:'selecttext'
		,fieldLabel : '����'
		,valueField : 'wardRowid'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.bpcNGWardDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUBedEquip';
		param.QueryName = 'Findward';
		param.Arg1 = obj.bpcNGWardDr.getRawValue();
		param.ArgCnt = 1;
	});
	obj.bpcNGWardDrstore.load({});	
	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.bpcNGWardDr
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
		]
	});

	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,text : '���'
	});

	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,text : '����'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,text : 'ɾ��'
	});
//	obj.findbutton = new Ext.Button({
//		id : 'findbutton'
//		,text : '����'
//	});

	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,buttonAlign : 'center'
		//,columnWidth : .72
		,layout : 'column'
        ,buttons:[
            obj.addbutton
            ,obj.updatebutton
            ,obj.deletebutton
   //         ,obj.findbutton
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
		,height : 120
		,title : '��ʿ��ά��'
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
			idProperty: 'rowId'
		}, 
	    [
			{name: 'rowId', mapping: 'rowId'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'WardId', mapping: 'WardId'}
			,{name: 'WardDesc', mapping: 'WardDesc'}
		])
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		//,{header: 'tID', width: 50, dataIndex: 'tID', sortable: true}
		,{header: '����', width: 350, dataIndex: 'Code', sortable: true}
		,{header: '����', width: 350, dataIndex: 'Desc', sortable: true}
		,{header: '����', width: 350, dataIndex: 'WardDesc', sortable: true}
		]
//		,viewConfig:
//		{
//			forceFit: false
//		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
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

	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCNurseGroup';
		param.QueryName = 'NurseGroup';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
	
	InitViewScreenEvent(obj);
	
	//�¼��������
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
    //obj.findbutton.on("click", obj.findbutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}

