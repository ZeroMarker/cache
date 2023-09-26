//20170307+dyl
function InitViewScreen(){
	var obj = new Object();
	obj.bpcAMCode = new Ext.form.TextField({
		id : 'bpcAMCode'
		,fieldLabel : '����'
		,labelSeparator: ''
		,anchor : '90%'
	});  

	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,labelWidth : 35
		,columnWidth : .13
		,layout : 'form'
		,items:[
			obj.bpcAMCode
			,obj.Rowid
		]
	});
	obj.bpcAMDesc = new Ext.form.TextField({
		id : 'bpcAMDesc'
		,fieldLabel : '����'
		,labelSeparator: ''
		,anchor : '90%'
	}); 
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,labelWidth : 35
		,buttonAlign : 'center'
		,columnWidth : .16
		,layout : 'form'
		,items:[
			obj.bpcAMDesc
		]
	});

	//---------------------�Ƿ�ѡ��ҩƷ
	var data=[
		['Y','��'],
		['N','��']
	]
	obj.IfSelectDrugStoreProxy = new Ext.data.MemoryProxy(data),
	
	obj.IfSelectDrugStore = new Ext.data.Store({
		proxy: obj.IfSelectDrugStoreProxy,
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.IfSelectDrugStore.load({});
	obj.IfSelectDrug = new Ext.form.ComboBox({
		id : 'IfSelectDrug'
		,minChars : 1
		,fieldLabel : '�Ƿ�ѡ��ҩƷ'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.IfSelectDrugStore
		,displayField : 'desc'
		,valueField : 'code'
		,anchor :'90%'
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .13
		,labelWidth : 85
		,layout : 'form'
		,items:[
			obj.IfSelectDrug
		]
	});	
	//---------------------�Ƿ�ʹ��
	var data=[
		['Y','��'],
		['N','��']
	]
	obj.ActiveStoreProxy = new Ext.data.MemoryProxy(data),
	
	obj.ActiveStore = new Ext.data.Store({
		proxy: obj.ActiveStoreProxy,
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.ActiveStore.load({});
	obj.Active = new Ext.form.ComboBox({
		id : 'Active'
		,minChars : 1
		,fieldLabel : '�Ƿ�ʹ��'
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.ActiveStore
		,labelSeparator: ''
		,displayField : 'desc'
		,valueField : 'code'
		,anchor :'90%'
	});
 
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,labelWidth : 60
		,columnWidth : .12
		,layout : 'form'
		,items:[
			obj.Active
		]
	});
	//---------------------Ѫ͸����͸
	var data=[
		['H','Ѫ͸'],
		['P','��͸']
	]
	obj.SubTypeStoreProxy = new Ext.data.MemoryProxy(data),
	
	obj.SubTypeStore = new Ext.data.Store({
		proxy: obj.SubTypeStoreProxy,
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.SubTypeStore.load({});
	obj.SubType = new Ext.form.ComboBox({
		id : 'SubType'
		,minChars : 1
		,fieldLabel : '����Ӧ��'
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.SubTypeStore
		,labelSeparator: ''
		,displayField : 'desc'
		,valueField : 'code'
		,anchor :'90%'
	});
 
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,labelWidth : 60
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.SubType
		]
	});	
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,iconCls : 'icon-Insert'
		,width:70
		,style:'margin-left:10px'
		,text : '���'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,style:'margin-left:10px'
		,width:70
		,iconCls : 'icon-delete'
		,text : 'ɾ��'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,style:'margin-left:10px'
		,iconCls : 'icon-edit'
		,width:70
		,text : '����'
	});
	
	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,buttonAlign : 'center'
		,columnWidth:.1
		,layout : 'form'
        ,items:[
            obj.addbutton
       ]
	});
obj.keypanel2 = new Ext.Panel({
		id : 'keypanel2'
		,buttonAlign : 'center'
		,columnWidth:.1
		,layout : 'form'
        ,items:[
            obj.updatebutton
       ]
	});
	obj.keypanel3 = new Ext.Panel({
		id : 'keypanel3'
		,buttonAlign : 'center'
		,columnWidth:.1
		,layout : 'form'
        ,items:[
            obj.deletebutton
       ]
	});

	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,labelWidth : 30
		,height:65
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.Panel5
			,obj.keypanel
			,obj.keypanel2
			,obj.keypanel3
		]
	});

	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 70
		,title : '�������ά��'
		,iconCls : 'icon-manage'
		,region : 'north'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
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
			idProperty: 'tBPCAMRowId'
		}, 
	    [
			,{name: 'tBPCAMRowId', mapping : 'tBPCAMRowId'}
			,{name: 'tBPCAMCode', mapping: 'tBPCAMCode'}
			,{name: 'tBPCAMDesc', mapping: 'tBPCAMDesc'}
			,{name: 'ifSelectDrug', mapping: 'ifSelectDrug'}
			,{name: 'ifSelectDrugDesc', mapping: 'ifSelectDrugDesc'}
			,{name: 'ifActive', mapping: 'ifActive'}
			,{name: 'ifActiveDesc', mapping: 'ifActiveDesc'}
			,{name: 'tBPCAMSubType', mapping: 'tBPCAMSubType'}
			,{name: 'tBPCAMSubTypeDesc', mapping: 'tBPCAMSubTypeDesc'}
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
		,{header: 'ϵͳ��', width: 100, dataIndex: 'tBPCAMRowId', sortable: true}
		,{header: '����', width: 100, dataIndex: 'tBPCAMCode', sortable: true}
		,{header: '����', width: 300, dataIndex: 'tBPCAMDesc', sortable: true}
		,{header: '�Ƿ�ѡ��ҩƷ', width: 100, dataIndex: 'ifSelectDrugDesc', sortable: true}
		,{header: '�Ƿ�ʹ��', width: 100, dataIndex: 'ifActiveDesc', sortable: true}
		,{header: '����Ӧ��', width: 100, dataIndex: 'tBPCAMSubTypeDesc', sortable: true}
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
		param.ClassName = 'web.DHCBPCAnticoagulantMode';
		param.QueryName = 'FindAntMode';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
	
	InitViewScreenEvent(obj);
	
	//�¼��������
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}