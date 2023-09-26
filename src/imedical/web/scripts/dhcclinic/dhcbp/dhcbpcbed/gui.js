//20170307+dyl
function InitViewScreen(){
	var obj=new Object();
	obj.BPCBDesc = new Ext.form.TextField({
		id : 'BPCBDesc'
		,fieldLabel : '��λ����'
		,labelSeparator: ''
		,anchor : '95%'

	});

	obj.BPCBCode = new Ext.form.TextField({
		id : 'BPCBCode'
		,fieldLabel : '��λ����'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.BPCBGroupDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
    function seltextbed(v, record) { 
         return record.BedRowId+" || "+record.BedDesc; 
    } 
   	obj.BPCBGroupDrStore = new Ext.data.Store({
      	proxy: obj.BPCBGroupDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'BedRowId'   
      		}, 
      		[	
      			{name: 'BedRowId', mapping: 'BedRowId'}
      			,{ name: 'selecttext', convert: seltextbed}
      			//,{name: 'BedDesc', mapping: 'BedDesc'}
    
      		])
      	});		
   obj.BPCBGroupDr =new Ext.form.ComboBox({
      	id : 'obj.BPCBGroupDr'
      	,store : obj.BPCBGroupDrStore
      	,minChars : 0
      	//,displayField : 'BedDesc'
      	,displayField : 'selecttext'
      	,fieldLabel : '��λ��'
      	,labelSeparator: ''
      	,valueField : 'BedRowId'
      	,editable : false
      	,triggerAction : 'all'
      	,anchor : '95%'
              });	
    obj.BPCBGroupDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCBPCBed';
      	param.QueryName = 'FindBedGroup';
      	param.ArgCnt = 0;
      	});
      	obj.BPCBGroupDrStore.load();  //
	
	obj.BPCBStatusStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
      	
    function seltextstatus(v, record) { 
         return record.Id+" || "+record.Desc; 
    } 
    
   	obj.BPCBStatusStore = new Ext.data.Store({
      	proxy: obj.BPCBStatusStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'Id'   
      		}, 
      		[	
      			{name: 'Id', mapping: 'Id'}
      			,{ name: 'selecttext', convert: seltextstatus}
      			//,{name: 'Desc', mapping: 'Desc'}
    
      		])
      	});		
   obj.BPCBStatus =new Ext.form.ComboBox({
      	id : 'obj.BPCBStatus'
      	,store : obj.BPCBStatusStore
      	,minChars : 0
      	//,displayField : 'Desc'
      	,displayField : 'selecttext'
      	,fieldLabel : '״̬'
      	,labelSeparator: ''
      	,valueField : 'Id'
      	,editable : false
      	,triggerAction : 'all'
      	,anchor : '95%'
              });	
    obj.BPCBStatusStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCBPCBed';
      	param.QueryName = 'FindBPCBStatus';
      	param.ArgCnt = 0;
      	});
      	obj.BPCBStatusStore.load();
	
	obj.BPCBType = new Ext.form.TextField({
		id : 'BPCBType'
		,fieldLabel : '����'
		,labelSeparator: ''
		,anchor : '80%'

	});
	obj.BPCBRowId = new Ext.form.TextField({
		id : 'BPCBRowId'
		,hidden : true
	})
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth:60
		,layout : 'form'
		,items:[
		obj.BPCBCode
		]
	});
	obj.Panel2= new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .15
		,layout : 'form'
		,labelWidth:60
		,items:[
		obj.BPCBDesc
		]
	});

	obj.Panel3= new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .15
		,layout : 'form'
		,labelWidth:70
		,items:[
		obj.BPCBGroupDr
		]
	});
		obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth:40
		,layout : 'form'
		,items:[
		obj.BPCBStatus
		]
	});
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth:40
		,layout : 'form'
		,items:[
		obj.BPCBType
		]
	});
		obj.Panel6 = new Ext.Panel({
		id : 'Panel6'
		,buttonAlign : 'center'
		,columnWidth : .01
		,layout : 'form'
		,items:[
		obj.BPCBRowId
		]
	});
	//
	obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,iconCls:'icon-add'
		,width:86
		,style:'margin-left:2px'
		,text : '����'
	});
		obj.btnUpd = new Ext.Button({
		id : 'btnUpd'
		,width:86
		,style:'margin-left:15px'
		,iconCls:'icon-update'
		,text : '����'
	});
		obj.btnDel = new Ext.Button({
		id : 'btnDel'
		,width:86
		,style:'margin-left:15px'
		,iconCls:'icon-delete'
		,text : 'ɾ��'
	});
	obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,text : '��ѯ'
	});
	obj.schSubChildPl1 = new Ext.Panel({
		id : 'schSubChildPl1'
		,buttonAlign : 'left'
		,columnWidth : .34
		,layout : 'column'
		,items:[
		obj.btnAdd
		,obj.btnUpd
		,obj.btnDel
		]
		,buttons:[
		
		]
	});
	
	
	
	//
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,height:45
		//,labelWidth : 70
		,region : 'north'
		,layout : 'column'
		,items:[
		  obj.Panel1
	     ,obj.Panel2
	     ,obj.Panel3
	     ,obj.Panel4
	     ,obj.Panel5
	     ,obj.Panel6
	     ,obj.schSubChildPl1
		]
	});
		
		
    obj.floorPanel = new Ext.Panel({
		id : 'floorPanel'
		,buttonAlign : 'center'
		,height : 65
		,title : '��λ��Ϣά��'
		,iconCls:'icon-manage'
		,region : 'north'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
		     obj.fPanel
		     //,obj.chkFormPanel
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
			,{name: 'tBPCBCode', mapping: 'tBPCBCode'}
			,{name: 'tBPCBDesc', mapping: 'tBPCBDesc'}
			,{name: 'tBPCBBPCBedGroupDr', mapping: 'tBPCBBPCBedGroupDr'}
			,{name: 'tBPCBBPCBedGroup', mapping: 'tBPCBBPCBedGroup'}
			,{name: 'tBPCBStatus', mapping: 'tBPCBStatus'}
			,{name: 'tBPCBStatusD', mapping: 'tBPCBStatusD'}
			,{name: 'tBPCBType', mapping: 'tBPCBType'}
		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,{header: '��λ����', width: 220, dataIndex: 'tBPCBCode', sortable: true}
			,{header: '��λ����', width: 220, dataIndex: 'tBPCBDesc', sortable: true}
			,{header: '��λ��', width: 220, dataIndex: 'tBPCBBPCBedGroup', sortable: true}
			,{header: '״̬', width: 220, dataIndex: 'tBPCBStatusD', sortable: true}
			,{header: '����', width: 220, dataIndex: 'tBPCBType', sortable: true}
			,{header: 'ϵͳ��', width: 100, dataIndex: 'tRowId', sortable: true,hidden:true}	
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
		param.ClassName = 'web.DHCBPCBed';
		param.QueryName = 'FindBPCBed';
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


