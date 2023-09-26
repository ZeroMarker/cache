function InitViewScreen()
{
	var obj = new Object();
	
	
	//------------------------------------------------------
	//Ĭ��ҩƷ����ҽ��
	obj.defaultOrdStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.defaultOrdStore = new Ext.data.Store({
		proxy: obj.defaultOrdStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'defaultOrdId'
		}, 
		[
		     {name: 'defaultOrdId', mapping: 'defaultOrdId'}
			,{name: 'defaultOrd', mapping: 'defaultOrd'}
		])
	});	
	obj.defaultOrd = new Ext.form.ComboBox({
		id : 'defaultOrd'
		,store:obj.defaultOrdStore
		,minChars:1	
		,displayField:'defaultOrd'	
		,fieldLabel : 'Ĭ��ҩƷ����ҽ��'
		,valueField : 'defaultOrdId'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.defaultOrdStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCode';
		param.QueryName = 'GetDrugOrdDefault';
		param.Arg1 = obj.defaultOrd.getRawValue();
		param.ArgCnt = 1;
	});
	obj.defaultOrdStore.load({});
	
	obj.Panel11 = new Ext.Panel({
		id : 'Panel11'
		,buttonAlign : 'center'
		,columnWidth : .3
		,labelWidth:120
		,layout : 'form'
		,items:[
			obj.defaultOrd
		]
	});
	
	
	obj.saveDefaultOrdButton = new Ext.Button({
		id : 'saveDefaultOrdButton'
		//,anchor:'95%'
		,text : '����Ĭ��ҽ��'
	});
	
	obj.Panel12 = new Ext.Panel({
		id : 'Panel12'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.saveDefaultOrdButton
		]
	});
	
	obj.topPanel = new Ext.form.FormPanel({
		id:"topPanel"
		,buttonAlign:"center"
		,labelAlign:"right"
		//,labelWidth:60
		,height:50
		,frame : true
		,region:"north"
		,layout:"column"
		,items:[
			obj.Panel11
			,obj.Panel12
		]
	});
	
	
	//----------------------------------------------
	//����ҩƷҽ��
	obj.dancoDescStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.dancoDescStore = new Ext.data.Store({
		proxy: obj.dancoDescStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ancoRowid'
		}, 
		[
		     {name: 'ancoRowid', mapping: 'ancoRowid'}
			,{name: 'ancoDesc', mapping: 'ancoDesc'}
		])
	});	
	obj.dancoDesc = new Ext.form.ComboBox({
		id : 'dancoDesc'
		,store:obj.dancoDescStore
		,minChars:1	
		,displayField:'ancoDesc'	
		,fieldLabel : '����ҩƷҽ��'
		,valueField : 'ancoRowid'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.dancoDescStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCode';
		param.QueryName = 'GetDrugOrd';
		param.Arg1 = obj.dancoDesc.getRawValue();
		param.ArgCnt = 1;
	});
	obj.dancoDescStore.load({});
	
	obj.dphcinID = new Ext.form.TextField({
		id : "dphcinID"
		,hidden:true
	});
	
	
	obj.dancoDescPanel = new Ext.Panel({
		id : 'dancoDescPanel'
		,buttonAlign : 'center'
		//,columnWidth : .2
		,labelWidth:120
		,width:300
		,height:250
		,frame : true
		,layout : 'form'
		,items:[
			obj.dancoDesc
			,obj.dphcinID
		]
	});
	
	//��ҩ;����dphcin��
	obj.dphcinStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.dphcinStore = new Ext.data.Store({
		proxy: obj.dphcinStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'phcinrowid'
		}, 
		[
		     {name: 'phcinrowid', mapping: 'phcinrowid'}
			,{name: 'phcinDesc', mapping: 'phcinDesc'}
		])
	});	
	
	obj.dphcinStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCode';
		param.QueryName = 'GetPhcinDesc';
		param.ArgCnt = 0;
	});
	obj.dphcinStore.load({});
	
	obj.dphcin = new Ext.grid.GridPanel({
		id : 'dphcin'
 		,store: obj.dphcinStore
    	//,multiSelect: true
    	,height:220
    	,width:230
    	,viewConfig:{forceFit:true}
    	,stripeRows:true
    	,cm:new Ext.grid.ColumnModel([{
        	header: 'ID',
        	dataIndex: 'phcinrowid',
        	width:20
    	},{
        	header: 'Desc',
        	dataIndex: 'phcinDesc'
    	}])
	}); 	
	
	obj.dphcinPanel = new Ext.Panel({
		id : 'dphcinPanel'
		,title : '��ҩ;��'
		,frame : true
		,animate:true
		,height:250
    	,width:250
		,layout: 'form'
		,items:[
			obj.dphcin
		]
	});
	
	//"���>>"��"�Ƴ�<<"��ť
	obj.AddOrdInstrucButton = new Ext.Button({
		id : 'AddOrdInstrucButton'
		//,anchor:'95%'
		//,width:50
		,text : '���>>'
	});
	
	obj.AddOrdInstrucPanel = new Ext.Panel({
		id : 'AddOrdInstrucPanel'
		,buttonAlign : 'center'
		,height:100
		,layout: {type: 'vbox',pack: 'end',align: 'buttom'}
		,items:[
		    obj.AddOrdInstrucButton
		]
	});
	obj.DelOrdInstrucButton = new Ext.Button({
		id : 'DelOrdInstrucButton'
		//,anchor:'95%'
		,text : '�Ƴ�<<'
	});
	
	obj.DelOrdInstrucPanel = new Ext.Panel({
		id : 'DelOrdInstrucPanel'
		,buttonAlign : 'center'
		//,columnWidth : .2
		,height:100
		,layout: {type: 'vbox',pack: 'start',align: 'top'}
		,items:[
		    obj.DelOrdInstrucButton
		]
	});
	obj.PanelTemp1 = new Ext.Panel({
		id : 'PanelTemp1'
		,height:30
		,layout : 'form'
		,items:[
		]
	});
	
	obj.OrdInstrucButtonPanel = new Ext.Panel({
		id : 'OrdInstrucButtonPanel'
		,buttonAlign : 'center'
		//,columnWidth : .40
		,height:250
		,width:80
		,frame : true
		,layout : 'form'
		,items:[
		    obj.AddOrdInstrucPanel
		    ,obj.PanelTemp1
		    ,obj.DelOrdInstrucPanel
		]
	});
	
	//����������ҽ������ҩ;��(unUsePhcinDesc)
	obj.unUsePhcinDescStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.unUsePhcinDescStore = new Ext.data.Store({
		proxy: obj.unUsePhcinDescStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'unusephcinid'
		}, 
		[
		     {name: 'unusephcinid', mapping: 'unusephcinid'}
			,{name: 'unusephcindesc', mapping: 'unusephcindesc'}
		])
	});	
	
	obj.unUsePhcinDescStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCode';
		param.QueryName = 'FindUnusePhcin';
		param.ArgCnt = 0;
	});
	obj.unUsePhcinDescStore.load({});
	
	obj.unUsePhcinDesc = new Ext.grid.GridPanel({
		id : 'unUsePhcinDesc'
 		,store: obj.unUsePhcinDescStore
    	//,multiSelect: true
    	,height:250
    	,width:200
    	,viewConfig:{forceFit:true}
    	//,stripeRows:true
    	,cm:new Ext.grid.ColumnModel([{
        	header: 'ID',
        	dataIndex: 'unusephcinid',
        	width:20
    	},{
        	header: 'Desc',
        	dataIndex: 'unusephcindesc'
    	}])
	}); 	
	
	obj.unUsePhcinDescPanel = new Ext.Panel({
		id : 'unUsePhcinDescPanel'
		,title : '����������ҽ������ҩ;��'
		,frame : true
		,animate:true
		,height:250
    	,width:220
		,layout: 'form'
		,items:[
			obj.unUsePhcinDesc
		]
	});
	
	obj.fPanel = new Ext.Panel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'column'
		,height : 270
		,frame : true
		,items:[
			obj.dancoDescPanel
			,obj.dphcinPanel
			,obj.OrdInstrucButtonPanel
			,obj.unUsePhcinDescPanel
		]
	});
	
	//----------------------------------------------
	//"����", "ɾ��", "����"��ť
	obj.saveButton = new Ext.Button({
		id : 'saveButton'
		,width:60
		,text : '����'
	});
	obj.deleteButton = new Ext.Button({
		id : 'deleteButton'
		,width:60
		,text : 'ɾ��'
	});
	obj.findButton = new Ext.Button({
		id : 'findButton'
		,width:60
		,text : '����'
	});
	obj.savePanel = new Ext.Panel({
		id : 'savePanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.saveButton
		]

	});
	obj.deletePanel = new Ext.Panel({
		id : 'deletePanel'
		,buttonAlign : 'center'	
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.deleteButton
		]

	});
	obj.findPanel = new Ext.Panel({
		id : 'findPanel'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.findButton
		    ]

	});	
	obj.buttonPanel = new Ext.Panel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 50
		,frame:true
		,region : 'south'
		,layout : 'column'
		,items:[
			 obj.savePanel
            ,obj.deletePanel
            ,obj.findPanel
		]
	});
	obj.floorPanel = new Ext.Panel({
		id : 'floorPanel'
		,buttonAlign : 'center'
		,height : 350
		,region : 'center'
		,layout : 'border'
		,frame : true
		//,collapsible:true
		//,animate:true
		,items:[
			obj.fPanel
			,obj.buttonPanel
		]
    });
    
    
	//----------------------------------------------------
	//����ҽ��GridPanel
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'dancoRowid'
		}, 
	    [
			{name: 'dancoRowid', mapping: 'dancoRowid'}
			,{name: 'dancoDesc', mapping: 'dancoDesc'}
			,{name: 'dphcinRowid', mapping: 'dphcinRowid'}
			,{name: 'dphcinDesc', mapping: 'dphcinDesc'}

		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '����ҽ��ID��',width: 200,dataIndex: 'dancoRowid',sortable: true}
			,{header: 'ҽ������',width: 200,dataIndex: 'dancoDesc',sortable: true}
      ,{header: '��ҩ;��ID��',width: 200,dataIndex: 'dphcinRowid',sortable: true}
			,{header: '��ҩ;������',width: 200,dataIndex: 'dphcinDesc',sortable: true}
		]
	});
	
	 obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
		//����״̬��
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		  displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
		})
	});
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCode';
		param.QueryName = 'FindOrdPhcin';
		param.Arg1 = obj.dancoDesc.getValue();
		param.Arg2 = obj.dphcinID.getValue();
		param.ArgCnt = 2;
	});
	obj.retGridPanelStore.load({});
	
	//����Panel23
	obj.Panel23 = new Ext.Panel({
		id : 'Panel23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	//����Pannel25
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
		,region : 'south'
		,layout : 'border'
		,height:250
		,frame : true
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
		]
	});
	
	obj.downPanel = new Ext.form.FormPanel({
		id:"downPanel"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:60
		//,height:600
		//,frame : true
		,region:"center"
		,layout:"border"
		,items:[
			obj.floorPanel
			,obj.resultPanel
		]
	});
	
	obj.ComOrdInstructPanel = new Ext.Panel({
		id : 'ComOrdInstructPanel'
		,buttonAlign : 'center'
		//,height : 600
		//,width:600
		,title : '����ҽ��������ҩ;��'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.topPanel
			,obj.downPanel
		]
	});
	
	//----------------------------------------------
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.ComOrdInstructPanel
		]
	});
	
	InitViewScreenEvent(obj);
	
	//�¼��������
	obj.LoadEvent(arguments);
	obj.saveDefaultOrdButton.on("click", obj.saveDefaultOrdButton_click, obj);
	obj.AddOrdInstrucButton.on("click", obj.AddOrdInstrucButton_click, obj);
	obj.DelOrdInstrucButton.on("click", obj.DelOrdInstrucButton_click, obj);
	obj.saveButton.on("click", obj.saveButton_click, obj);
	obj.deleteButton.on("click", obj.deleteButton_click, obj);
	obj.findButton.on("click", obj.findButton_click, obj);
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	return obj;	
   
}