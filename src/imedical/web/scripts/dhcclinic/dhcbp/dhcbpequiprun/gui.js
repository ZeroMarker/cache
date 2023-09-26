function InitViewScreen(){
	var obj=new Object();
	//�ı�1
	obj.startDate = new Ext.form.DateField({
		id : 'startDate'
		,format : 'Y-m-d'
		,fieldLabel:'��ʼ����'
		,anchor : '95%'
	});
	obj.startTime = new Ext.form.TextField({
		id : 'startTime'
		,fieldLabel : '��ʼʱ��'
		,anchor : '95%'
	});	
	obj.tRowId = new Ext.form.TextField({
		id : 'tRowId'
		,hidden : true
    });
    
	obj.endDate = new Ext.form.DateField({
		id : 'endDate'
		//,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel:'��������'
		,anchor : '95%'
	});
	obj.endTime = new Ext.form.TextField({
		id : 'endTime'
		,fieldLabel : '����ʱ��'
		,anchor : '95%'
	});	

	 
	obj.startdatePanel = new Ext.Panel({
		id : 'startdatePanel'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.startDate
			,obj.startTime
			,obj.tRowId
		]
	});
	obj.enddatePanel = new Ext.Panel({
		id : 'enddatePanel'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.endDate
			,obj.endTime
		]
	});
	
	// Ѫ͸�豸
	obj.bpEquipstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.bpEquipstore = new Ext.data.Store({
		proxy: obj.bpEquipstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tBPCERowId'
		}, 
		[
			{name: 'tBPCERowId', mapping: 'tBPCERowId'}
			,{name: 'tBPCECode', mapping: 'tBPCECode'}
			,{name: 'tBPCEDesc', mapping: 'tBPCEDesc'}
			
		])
	});
	obj.bpEquip = new Ext.form.ComboBox({
		id : 'bpEquip'
		,store:obj.bpEquipstore
		,minChars:1
		,displayField:'tBPCEDesc'
		,fieldLabel : '�豸'
		,valueField : 'tBPCERowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});

	obj.bperNote = new Ext.form.TextField({
		id : 'bperNote'
		,fieldLabel : '����'
		,anchor : '95%'
	});

	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.bpEquip
			,obj.bperNote
		]
	});
	
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 100
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.startdatePanel
			,obj.enddatePanel
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
	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,text : '����'
		//,hidden : true // ����
	});
	obj.equipMtain = new Ext.Button({
		id : 'equipMtain'
		,text : 'ά����¼'
		//,hidden : true // ����
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
	
	obj.detectionPanel = new Ext.Panel({
		id : 'detectionPanel'
		,buttonAlign : 'center'
		,height : 150
		,title : '�豸����'
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
	
	//gridview����
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
			,{name: 'tDBPCEquipDr', mapping: 'tDBPCEquipDr'}
			,{name: 'tDBPCEquipDesc', mapping: 'tDBPCEquipDesc'}
			,{name: 'StartDate', mapping: 'StartDate'}
			,{name: 'StartTime', mapping: 'StartTime'}
			,{name: 'EndDate', mapping: 'EndDate'}
			,{name: 'EndTime', mapping: 'EndTime'}
			,{name: 'Note', mapping: 'Note'}
			,{name: 'UserID', mapping: 'UserID'}
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
		,{header: 'ϵͳ���', width: 80, dataIndex: 'tRowId', sortable: true}
		,{header: 'Ѫ͸�豸', width: 180, dataIndex: 'tDBPCEquipDesc', sortable: true}
		,{header: '��ʼ����', width: 100, dataIndex: 'StartDate', sortable: true}
		,{header: '��ʼʱ��', width: 100, dataIndex: 'StartTime', sortable: true}
		,{header: '��������', width: 100, dataIndex: 'EndDate', sortable: true}
		,{header: '����ʱ��', width: 100, dataIndex: 'EndTime', sortable: true}
		,{header: '��ע', width: 100, dataIndex: 'Note', sortable: true}
		]

		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
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
			obj.detectionPanel
			,obj.resultPanel
		]
	});
	
	//***���ݰ󶨴���***
	//����豸
	obj.bpEquipstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquip';
		param.QueryName = 'FindEquip';
		param.Arg1 = "";
		param.ArgCnt = 1;
	});
	obj.bpEquipstore.load({});

	//gridview
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPEquipRun';
		param.QueryName = 'FindBPEquipRun';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
 
	InitViewScreenEvent(obj);
	
	//�¼��������
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.findbutton.on("click", obj.selectbutton_click, obj);
  	obj.LoadEvent(arguments);
	return obj;
}


