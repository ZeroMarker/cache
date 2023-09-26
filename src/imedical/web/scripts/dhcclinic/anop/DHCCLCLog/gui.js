//dyl+20171031+��־���
 function InitViewScreen()
{
	var obj = new Object();
	obj.CLCCode = new Ext.form.TextField({
		id : 'CLCCode'
		,fieldLabel : '����'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.CLCDesc = new Ext.form.TextField({
		id : 'CLCDesc'
		,fieldLabel : '����'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .18
		,labelWidth : 70
		,layout : 'form'
		,items:[
			obj.CLCCode
			,obj.CLCDesc
		]
	});
	
	obj.CLCValue = new Ext.form.TextField({
		id : 'CLCValue'
		,fieldLabel : '����ֵ'
		,labelSeparator: ''
		,anchor : '90%'
	});	
	
	
	obj.CLCValueDesc = new Ext.form.TextField({
		id : 'CLCValueDesc'
		,fieldLabel : '��������'
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
			obj.CLCValue
			,obj.CLCValueDesc
		]
	});
	obj.DefaultValue = new Ext.form.TextField({
		id : 'DefaultValue'
		,fieldLabel : 'ȱʡֵ'
		,labelSeparator: ''
		,anchor : '90%'
	});	
	
	obj.AddIntroStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.AddIntroStore = new Ext.data.Store({
		proxy: obj.AddIntroStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
		     {name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});	
	obj.AddIntro = new Ext.form.ComboBox({
		id : 'AddIntro'
		,store:obj.AddIntroStore
		,minChars:1	
		,displayField:'Desc'	
		,fieldLabel : '�и���˵��'
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '90%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	});	
	
	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .20
		,labelWidth : 100
		,layout : 'form'
		,items:[
			obj.DefaultValue
			,obj.AddIntro
		]
	});
	
	obj.CLCTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.CLCTypeStore = new Ext.data.Store({
		proxy: obj.CLCTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Code'
		}, 
		[
		     {name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});	
	obj.CLCType= new Ext.form.ComboBox({
		id : 'CLCType'
		,store:obj.CLCTypeStore
		,minChars:1	
		,displayField:'Desc'	
		,fieldLabel : '����'
		,valueField : 'Code'
		,triggerAction : 'all'
		,anchor : '90%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	}); 	
	
	obj.CLCTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLLog';
		param.QueryName = 'FindCLCType';
		param.ArgCnt = 0;
	});
	obj.CLCTypeStore.load({});
	obj.AddIntroStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLLog';
		param.QueryName = 'FindAddInfo';
		param.ArgCnt = 0;
	});
	obj.AddIntroStore.load({});
	obj.CLCSeqNo = new Ext.form.TextField({
		id : 'CLCSeqNo'
		,fieldLabel : '�����'
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
			obj.CLCType
			,obj.CLCSeqNo
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
		,text : '����'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,iconCls : 'icon-updateSmall'
		,style: 'margin-Top:3px;'
		,text : '����'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,iconCls : 'icon-delete'
		,style: 'margin-Top:3px;'
		,text : 'ɾ��'
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
			idProperty: 'tClclogId'
		}, 
	    [
			{name: 'tClclogId', mapping : 'tClclogId'}
			,{name: 'tClclogCode', mapping: 'tClclogCode'}
			,{name: 'tClclogDesc', mapping: 'tClclogDesc'}
			,{name: 'tClclogType', mapping: 'tClclogType'}
			,{name: 'tClclogTypeDesc', mapping: 'tClclogTypeDesc'}
			,{name: 'tClclogValueList', mapping: 'tClclogValueList'}
			,{name: 'tClclogValueListDesc', mapping: 'tClclogValueListDesc'}
			,{name: 'tClclogIfAddInfo', mapping: 'tClclogIfAddInfo'}
			,{name: 'tClclogIfAddInfoDesc', mapping: 'tClclogIfAddInfoDesc'}
			,{name: 'tClclogDefault', mapping: 'tClclogDefault'}
			,{name: 'tClclogSortNo', mapping: 'tClclogSortNo'}

		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: 'tClclogId',width: 60,dataIndex: 'tClclogId',sortable: true}
			,{header: '����',width: 120,dataIndex: 'tClclogDesc',sortable: true}
        	,{header: '����',width: 120,dataIndex: 'tClclogCode',sortable: true}
			,{header: '����',width: 50,dataIndex: 'tClclogType',sortable: true}
			,{header: '��������',width: 50,dataIndex: 'tClclogTypeDesc',sortable: true}
			,{header: '����ֵ',width: 140,dataIndex: 'tClclogValueList',sortable: true}
			,{header: '����ֵ����',width: 140,dataIndex: 'tClclogValueListDesc',sortable: true}
			,{header: '����˵��',width: 80,dataIndex: 'tClclogIfAddInfo',sortable: true}
			,{header: '����˵������',width: 80,dataIndex: 'tClclogIfAddInfoDesc',sortable: true}
			,{header: 'ȱʡֵ',width: 100,dataIndex: 'tClclogDefault',sortable: true}
			,{header: '�����',width: 100,dataIndex: 'tClclogSortNo',sortable: true,hidden:true}
		]
	});
	
	 obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) 
		,clicksToEdit:1    
		,loadMask : true
		,region : 'center'
		,title : '���ά����ѯ���'
		,iconCls : 'icon-result'
		,buttonAlign : 'center'
		,cm:cm
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
		})
	});
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLLog';
		param.QueryName = 'FindCLCLog';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
	
	
	obj.AnOpReport = new Ext.Panel({
		id : 'AnOpReport'
		,buttonAlign : 'center'
		,height : 200
		,width:400
		,title : '��־���ά��'
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