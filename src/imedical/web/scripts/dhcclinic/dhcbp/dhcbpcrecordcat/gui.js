//20170307+dyl
function InitViewScreen(){
	var obj=new Object();
	obj.BPCRCDesc = new Ext.form.TextField({
		id : 'BPCRCDesc'
		,fieldLabel : '�໤��������'
		,labelSeparator: ''
		,anchor : '95%'

	});

	obj.BPCRCCode = new Ext.form.TextField({
		id : 'BPCRCCode'
		,fieldLabel : '�໤�������'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.BPCRCRowId = new Ext.form.TextField({
		id : 'BPCRCRowId'
		,hidden : true
	})
	
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,labelWidth:110
		,columnWidth : .2
		,layout : 'form'
		,items:[
		obj.BPCRCCode
		]
	});
	obj.Panel2= new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,labelWidth:110
		,columnWidth : .2
		,layout : 'form'
		,items:[
		obj.BPCRCDesc
		]
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .01
		,layout : 'form'
		,items:[
		obj.BPCRCRowId
		]
	});
	obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,iconCls:'icon-find'
		,width:86
		,text : '��ѯ'
	});
		obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,iconCls:'icon-add'
		,width:86
		,style:'margin-left:20px'
		,text : '����'
	});
		obj.btnUpd = new Ext.Button({
		id : 'btnUpd'
		,iconCls:'icon-edit'
		,style:'margin-left:20px'
		,width:86
		,text : '����'
	});
		obj.btnDel = new Ext.Button({
		id : 'btnDel'
		,width:86
		,style:'margin-left:20px'
		,iconCls:'icon-delete'
		,text : 'ɾ��'
	});
obj.buttonpanel = new Ext.Panel({
		id : 'buttonpanel'
		,buttonAlign : 'center'
		,columnWidth:.4
		,layout : 'column'
        ,items:[
            obj.btnAdd
            ,obj.btnUpd
            ,obj.btnDel
       ]
	});
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,height:60
		,region : 'north'
		,layout : 'column'
		,items:[
		  obj.Panel1
	     ,obj.Panel3
	     ,obj.Panel2
	     ,obj.buttonpanel
	    ]
	});
		
	

    obj.floorPanel = new Ext.Panel({
		id : 'floorPanel'
		,buttonAlign : 'center'
		,height : 65
		,title : '�໤����ά��'
		,iconCls:'icon-manage'
		,region : 'north'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
		     obj.fPanel
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
			,{name: 'tRowId', mapping: 'tRowId'}
			,{name: 'tBPCRCCode', mapping: 'tBPCRCCode'}
			,{name: 'tBPCRCDesc', mapping: 'tBPCRCDesc'}
		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,{header: '�໤�������', width: 150, dataIndex: 'tBPCRCCode', sortable: true}
			,{header: '�໤��������', width: 150, dataIndex: 'tBPCRCDesc', sortable: true}
			,{header: 'ϵͳ��', width: 100, dataIndex: 'tRowId', sortable: true}	
		]
	})
	obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
		,viewConfig:
		{
			forceFit: false
			//Return CSS class to apply to rows depending upon data values
			
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.retGridPanelStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,plugins : obj.retGridPanelCheckCol
	});
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,tbar:obj.tb
		,items:[
		obj.retGridPanel
		]
	});
		obj.retGridPanelStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCBPCRecordCat';
		param.QueryName = 'FindBPCReCat';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load();
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			 obj.floorPanel
			 ,obj.resultPanel
		]
	});
	InitViewScreenEvent(obj);
	//�¼��������
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.btnDel.on("click", obj.btnDel_click, obj);
	obj.btnAdd.on("click", obj.btnAdd_click, obj);
	obj.btnUpd.on("click", obj.btnUpd_click, obj);
  	obj.LoadEvent(arguments);
	return obj;
}


