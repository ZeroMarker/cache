///20170324+GY
function InitViewScreen(){
	var obj = new Object();
	obj.oprCode = new Ext.form.TextField({
		id : 'oprCode'
		,fieldLabel : '���������'
		,labelSeparator: ''
		,anchor : '80%'
	}); 
	obj.oprAvailablestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
   /* function seltextyn(v, record) { 
         return record.Id+" || "+record.Desc; 
    } */
	obj.oprAvailablestore = new Ext.data.Store({
		proxy: obj.oprAvailablestoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'AvailableCode'
		}, 
		[
			{name: 'AvailableCode', mapping: 'AvailableCode'}
			//,{ name: 'selecttext', convert: seltextyn}
			//,{name: 'Desc', mapping : 'Desc'}
		])
	});
	obj.oprAvailable = new Ext.form.ComboBox({
		id : 'oprAvailable'
		,store:obj.oprAvailablestore
		,minChars:1
		,displayField:'AvailableCode'
		//,displayField:'selecttext'
		,fieldLabel : '�Ƿ����'
		,editable:false
		,valueField : 'AvailableCode'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '80%'
	});

	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });	
    
	obj.oprLocId = new Ext.form.TextField({
		id : 'oprLocId'
		,hidden : true
    });	
    
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.oprCode
			,obj.oprAvailable
			//,obj.Rowid
			//,obj.oprLocId 
		]
	});
	
	obj.oprDesc = new Ext.form.TextField({
		id : 'oprDesc'
		,fieldLabel : '����������'
		,labelSeparator: ''
		,anchor : '85%'
	}); 
	obj.oprNotAvailReasonstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.oprNotAvailReasonstore = new Ext.data.Store({
		proxy: obj.oprNotAvailReasonstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RNAVRowID'
		}, 
		[
			{name: 'RNAVRowID', mapping: 'RNAVRowID'}
			//,{ name: 'selecttext', convert: seltextyn}
			,{name: 'RNAVDesc', mapping : 'RNAVDesc'}
		])
	});
	obj.oprNotAvailReason = new Ext.form.ComboBox({
		id : 'oprNotAvailReason'
		,store:obj.oprNotAvailReasonstore
		,minChars:1
		,displayField:'RNAVDesc'
		//,displayField:'selecttext'
		,fieldLabel : '������ԭ��'
		,valueField : 'RNAVRowID'
		,editable:false
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '85%'
	});
		
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.oprDesc
			,obj.oprNotAvailReason
		]
	});
	
	obj.OperLocstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.OperLocstore = new Ext.data.Store({
		proxy: obj.OperLocstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'oprLocId'
		}, 
		[
			{name: 'oprLocId', mapping: 'oprLocId'}
			,{name: 'oprCtLoc', mapping : 'oprCtLoc'}
			
		])
	});
	obj.OperLoc = new Ext.form.ComboBox({
		id : 'OperLoc'
		,store:obj.OperLocstore
		,minChars:1
		,displayField:'oprCtLoc'
		//,displayField:'selecttext'
		,fieldLabel : '������'
		,valueField : 'oprLocId'
		,editable:false
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '85%'
	});

	obj.oprCtDefUsestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.oprCtDefUsestore = new Ext.data.Store({
		proxy: obj.oprCtDefUsestoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'oprLocId'
		}, 
		[
			{name: 'oprLocId', mapping: 'oprLocId'}
			//,{ name: 'selecttext', convert: seltexttype}
			,{name: 'oprCtLoc', mapping : 'oprCtLoc'}
			
		])
	});
	obj.oprCtDefUse = new Ext.form.ComboBox({
		id : 'oprCtDefUse'
		,store:obj.oprCtDefUsestore
		,minChars:1
		,displayField:'oprCtLoc'
		//,displayField:'selecttext'
		,fieldLabel : 'Ĭ����ƿ���'
		,valueField : 'oprLocId'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '85%'
	});
	obj.oprCtFloorstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.oprCtFloorstore = new Ext.data.Store({
		proxy: obj.oprCtFloorstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'oprCtFloorId'
		}, 
		[
			{name: 'oprCtFloorId', mapping: 'oprCtFloorId'}
			//,{ name: 'selecttext', convert: seltexttype}
			,{name: 'oprCtFloor', mapping : 'oprCtFloor'}
			
		])
	});
	obj.oprCtFloor = new Ext.form.ComboBox({
		id : 'oprCtFloor'
		,store:obj.oprCtFloorstore
		,minChars:1
		,displayField:'oprCtFloor'
		//,displayField:'selecttext'
		,fieldLabel : '����¥��'
		,editable:false
		,valueField : 'oprCtFloorId'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '80%'
	});			
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.OperLoc
			,obj.oprCtDefUse
			//,obj.oprCtFloor
		]
	});		
	
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,iconCls : 'icon-add'
		,width:'86'
		,text : '����'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,style:'margin-left:20px'
		,iconCls : 'icon-delete'
		,width:'86'
		,style:'margin-left:135px;'
		,text : 'ɾ��'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,iconCls : 'icon-updateSmall'
		,width:'86'
		,style:'margin-Top:3px;'
		,text : '����'
	});
	
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .20
		,style:'margin-left:20px'
		,layout : 'form'
		,items:[
		     obj.addbutton
            ,obj.updatebutton	
		]
	});	
		/*
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
            obj.deletebutton				
		]
	});*/
	obj.Panelf1 = new Ext.Panel({
		id : 'Panelf1'
		,buttonAlign : 'center'
		,columnWidth : .20
		,labelWidth:80
		,layout : 'form'
		,items:[
            obj.oprCtFloor	
            ,obj.deletebutton				
		]
	});	
		
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 90
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panelf1
			,obj.Panel4
			//,obj.Panel5
		]
	});
		
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 92
		,title : '����ָ���ά��'
		,iconCls:'icon-manage'
		,region : 'north'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
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
			idProperty: 'tOprId'
		}, 
	    [
			{name: 'tOprId', mapping : 'tOprId'}
			,{name: 'tOprCtLocId', mapping : 'tOprCtLocId'}
			,{name: 'tOprCtLoc', mapping : 'tOprCtLoc'}
			,{name: 'tOprCode', mapping : 'tOprCode'}
			,{name: 'tOprDesc', mapping : 'tOprDesc'}
			,{name: 'tOprCtFloorId', mapping: 'tOprCtFloorId'}
			,{name: 'tOprCtTypeId', mapping: 'tOprCtTypeId'}
			,{name: 'tOprCtDefUseId', mapping: 'tOprCtDefUseId'}
			,{name: 'tOprCtFloor', mapping: 'tOprCtFloor'}
			,{name: 'tOprCtType', mapping: 'tOprCtType'}
			,{name: 'tOprCtDefUse', mapping: 'tOprCtDefUse'}
			,{name: 'tOprAvailable', mapping: 'tOprAvailable'}
			,{name: 'tOprNotAvailReason', mapping: 'tOprNotAvailReason'}
			,{name: 'tOprBedType', mapping: 'tOprBedType'}
			,{name: 'tOprNotAvailReasonId', mapping: 'tOprNotAvailReasonId'}
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
		,{header: 'ϵͳ��', width: 50, dataIndex: 'tOprId', sortable: true}
		,{header: '������', width: 150, dataIndex: 'tOprCtLoc', sortable: true}
		,{header: '���������', width: 70, dataIndex: 'tOprCode', sortable: true}
		,{header: '����������', width: 80, dataIndex: 'tOprDesc', sortable: true}
		,{header: '������ID', width: 60, dataIndex: 'tOprCtLocId', sortable: true}
		,{header: '����¥��ID', width: 70, dataIndex: 'tOprCtFloorId', sortable: true}
		,{header: '��������ID', width:70, dataIndex: 'tOprCtTypeId', sortable: true}
		,{header: 'Ĭ����ƿ���ID', width: 90, dataIndex: 'tOprCtDefUseId', sortable: true}
		,{header: '����¥��', width: 60, dataIndex: 'tOprCtFloor', sortable: true}
		,{header: '��������', width: 60, dataIndex: 'tOprCtType', sortable: true}
		,{header: 'Ĭ����ƿ���', width: 150, dataIndex: 'tOprCtDefUse', sortable: true}
		,{header: '�Ƿ����', width: 60, dataIndex: 'tOprAvailable', sortable: true}
		,{header: '������ԭ��', width: 70, dataIndex: 'tOprNotAvailReason', sortable: true}
		//,{header: '����������', width: 80, dataIndex: 'tOPRBedType', sortable: true}
		,{header: '������ԭ��ID', width: 80, dataIndex: 'tOprNotAvailReasonId', sortable: true}
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
		,iconCls:'icon-result'
		,title : '����ָ��Ҳ�ѯ���'
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
	

	obj.OperLocstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCRoom';
		param.QueryName = 'ctloclookup';
		param.Arg1=obj.OperLoc.getRawValue();
		param.ArgCnt = 1;
	});
	obj.OperLocstore.load({});
		
	obj.oprCtDefUsestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCRoom';
		param.QueryName = 'ctdefuselookup';
		param.Arg1=obj.oprCtDefUse.getRawValue();
		param.ArgCnt = 1;
	});
	obj.oprCtDefUsestore.load({});
	
	obj.oprAvailablestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCRoom';
		param.QueryName = 'Availablelookup';
		param.ArgCnt = 0;
	});
	obj.oprAvailablestore.load({});
	
	obj.oprNotAvailReasonstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCRoom';
		param.QueryName = 'NotAvailReasonlookup';
		param.ArgCnt = 0;
	});
	obj.oprNotAvailReasonstore.load({});
	
	obj.oprCtFloorstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCRoom';
		param.QueryName = 'ctfloorlookup';
		param.Arg1='';
		param.ArgCnt = 1;
	});
	obj.oprCtFloorstore.load({});
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCRoom';
		param.QueryName = 'FindexeLoc';
		param.Arg1="P"
		param.ArgCnt = 1;
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