function InitViewScreen(){
	var obj=new Object();
	//�ı�1
	obj.bpdRowId = new Ext.form.TextField({
		id : 'bpdRowId'
		,hidden : true
    });
    
    obj.bpdstartDate = new Ext.form.DateField({	
		id : 'bpdstartDate'
		//,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel:'��ʼʱ��'
		,anchor : '95%'
	});
	 
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.bpdstartDate
			,obj.bpdRowId
		]
	});
	obj.bpdendDate = new Ext.form.DateField({	
		id : 'bpdendDate'
		//,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel:'����ʱ��'
		,anchor : '95%'
	});
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.bpdendDate
		]
	});
	
	
	obj.equipName = new Ext.form.TextField({
		id : 'equipName'
		,fieldLabel : '�豸����'
		,anchor : '95%'
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.equipName
		]
	});
	
	obj.equipSeqNo = new Ext.form.TextField({
		id : 'equipSeqNo'
		,fieldLabel : '�豸���к�'
		,anchor : '95%'
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.equipSeqNo
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
		,text : '�¼�'
	});

	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,text : '�༭'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,text : 'ɾ��'
		,hidden : true // ����
	});
	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,text : '����'
		//,hidden : true // ����
	});
	obj.excel = new Ext.Button({
		id : 'excel'
		,text : '����execl'
	});
	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,buttonAlign : 'left'
		//,columnWidth : .72
		,layout : 'column'
        ,buttons:[
            obj.addbutton
            ,obj.updatebutton
            ,obj.deletebutton
            ,obj.findbutton
            ,obj.excel
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
		,height : 120
		,title : '��������'
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
			,{name: 'tBPCDetectionDesc', mapping: 'tBPCDetectionDesc'} //�����Ʒ��
			,{name: 'tBPDBPCEquip', mapping: 'tBPDBPCEquip'}
			,{name: 'tBPDSpecimenNo', mapping: 'tBPDSpecimenNo'}
			,{name: 'tBPDDate', mapping: 'tBPDDate'}
			,{name: 'IsQualified', mapping: 'IsQualified'}
			,{name: 'tBPDIsQualified', mapping: 'tBPDIsQualified'}
			,{name: 'tBPDBatchSeqNo', mapping: 'tBPDBatchSeqNo'}
			,{name: 'userNameList', mapping: 'userNameList'}
			,{name: 'tBPDNote', mapping: 'tBPDNote'}
			,{name: 'tDBPDEquipSeqNo', mapping: 'tDBPDEquipSeqNo'}
			,{name: 'tBPCDetectionDr', mapping: 'tBPCDetectionDr'}
			,{name: 'tBPDBPCEquipCode', mapping: 'tBPDBPCEquipCode'}
			,{name: 'userIdList', mapping: 'userIdList'}
			,{name: 'tBPDTime', mapping: 'tBPDTime'}
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
		,{header: 'ϵͳ���', width: 70, dataIndex: 'tRowId', sortable: true,align:'center'}
		,{header: '�����Ʒ����', width: 150, dataIndex: 'tBPCDetectionDesc', sortable: true,align:'center'}
		,{header: '�豸��', width: 100, dataIndex: 'tBPDBPCEquip', sortable: true,align:'center'}
		,{header: '��Ʒ����', width: 150, dataIndex: 'tBPDSpecimenNo', sortable: true,align:'center'}
		,{header: '����ʱ��', width: 100, dataIndex: 'tBPDDate', sortable: true,align:'center'}
		,{header: '�Ƿ�ϸ�', width: 80, dataIndex: 'IsQualified', sortable: true,align:'center'}
		,{header: '�μ���', width: 140, dataIndex: 'userNameList', sortable: true,align:'center'}
		,{header: '��ע(���ϸ�ԭ��)', width: 180, dataIndex: 'tBPDNote', sortable: true,align:'center'}
		,{header: '�豸���к�', width: 180, dataIndex: 'tDBPDEquipSeqNo', sortable: true,align:'center'}
		]

		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			//store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
		})
		//,buttons:[obj.excel]
		,plugins : obj.retGridPanelCheckCol
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
 
	InitViewScreenEvent(obj);
	
	//�¼��������
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.excel.on("click", obj.excel_click, obj);
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.findbutton.on("click", obj.selectbutton_click, obj);
  	obj.LoadEvent(arguments);
	return obj;
}

function InitwinScreen()
{
	var obj = new Object();
	obj.winSamplingDate = new Ext.form.DateField({
		id : 'winSamplingDate'
		//,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel:'����ʱ��'
		,anchor : '95%'
	});
	
	obj.winTxtRowId = new Ext.form.TextField({
		id : 'winTxtRowId'
		,allowBlank : false
		,fieldLabel : ''
		,anchor : '95%'
		,hidden : true
	});
	
	//�����Ʒ��
	obj.winSampleNameStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.winSampleNameStore = new Ext.data.Store({
	    proxy : obj.winSampleNameStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'tRowId'
		},
		[
		    {name:'BPCDDesc',mapping:'BPCDDesc'}
			,{name:'tRowId',mapping:'tRowId'}
		])
		,autoLoad:true
	
	});
	obj.winSampleName = new Ext.form.ComboBox({
		id : 'winSampleName'
		,store:obj.winSampleNameStore
		,minChars:1
		//,mode:'local'
		,displayField:'BPCDDesc'
		,fieldLabel : '�����Ʒ��'
		,valueField : 'tRowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.winSampleNameStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCDetection';
		param.QueryName = 'FindBPCDetection';
		param.ArgCnt = 0;
	});
	
	//�����Ʒ���
	obj.winSampleNoStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.winSampleNoStore = new Ext.data.Store({
		proxy: obj.winSampleNoStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tBPBEBPCEquipDr'
		}, 
		[
			{name: 'tBPBEBPCEquipDr', mapping: 'tBPBEBPCEquipDr'}
			,{name: 'tBPBEBPCEquip', mapping: 'tBPBEBPCEquip'}
		])
	});	

	obj.winSampleNo = new Ext.form.ComboBox({
		id : 'winSampleNo'
		,store:obj.winSampleNoStore
		,minChars:1
		//,mode:'local'
		,displayField:'tBPBEBPCEquip'
		,fieldLabel : '�豸'
		,valueField : 'tBPBEBPCEquipDr'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	// ��Ʒ����
	obj.winSpecimenNo = new Ext.form.TextField({
		id : 'winSpecimenNo'
		,anchor : '95%'
		,fieldLabel : '��Ʒ����'
		//,hidden : true
    });
	
	//�Ƿ�ϸ�
	var winIsData =[
		['1','�ϸ�'],
		['0','���ϸ�']
		];

	obj.winIsQualifiedStoreProxy=new Ext.data.MemoryProxy(winIsData);
	obj.winIsQualifiedStore = new Ext.data.Store({
		proxy: obj.winIsQualifiedStoreProxy,
		reader: new Ext.data.ArrayReader({}, 
		[
			 {name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.winIsQualifiedStore.load({});
	obj.winIsQualified = new Ext.form.ComboBox({
		id : 'winIsQualified'
		,store:obj.winIsQualifiedStore
		,minChars:1
		,mode:'local'
		,displayField:'desc'
		,fieldLabel : '�Ƿ�ϸ�'
		,valueField : 'code'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.winParticipantsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.winParticipantsStore = new Ext.data.Store({
	    proxy : obj.winParticipantsStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'Id'
		},
		[   
		     {name: 'checked', mapping : 'checked'}
			,{name:'Name',mapping:'Name'}
			,{name:'Id',mapping:'Id'}
		])
	
	});
	
	obj.winParticipants = new Ext.ux.form.LovCombo({
	    id : 'winParticipants'
		,store : obj.winParticipantsStore
		,minChars : 1
		,displayField : 'Name'
		,fieldLabel : '�μ���'
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '95%'
	}); 
	var userId=session['LOGON.USERID']
	var logonCtlocId=session['LOGON.CTLOCID']
	obj.winParticipantsStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindUserByLoc';
		param.Arg1 = logonCtlocId;
		param.Arg2 = userId;
		param.ArgCnt = 2;
	});

	obj.winNote = new Ext.form.TextField({
		id : 'winNote'
		,fieldLabel : '��ע'
		,anchor : '95%'
	});
	
	obj.winBtnSave = new Ext.Button({
		id : 'winBtnSave'
		,iconCls : 'icon-save'
		,text : '����'
	});
	obj.winBtnCancle = new Ext.Button({
		id : 'winBtnCancle'
		,iconCls : 'icon-exit'
		,text : 'ȡ��'
	});
	obj.winPanelBTN = new Ext.Panel({
		id : 'winPanel4'
		,buttonAlign : 'center'
		,columnWidth : .8
		,layout : 'form'
		,items:[
			obj.winSampleName
			,obj.winSampleNo 
			,obj.winSpecimenNo
			,obj.winSamplingDate
			,obj.winIsQualified
			,obj.winParticipants
			,obj.winNote
			,obj.winTxtRowId
		]
		,buttons:[
			obj.winBtnSave
			,obj.winBtnCancle
		]
	});
	
	obj.winfPanel = new Ext.form.FormPanel({
		id : 'winfPanel'
		,buttonAlign : 'center'
		,title : '�豸��Ϣ'
		,labelWidth : 80
		,labelAlign : 'right'
		,frame : true
		,items:[
			obj.winPanelBTN
		]
	});
	
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 400
		,buttonAlign : 'center'
		,width : 365
		,title : '�༭'
		,modal : true
		,layout : 'fit'
		,items:[
			obj.winfPanel
		]
	});
	
	obj.winSampleNoStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPBedEquip';
		param.QueryName = 'FindBedEquip';
		param.ArgCnt = 0;
	});

	InitwinScreenEvent(obj);
	//�¼��������
	obj.winBtnSave.on("click", obj.winBtnSave_click, obj);
	//obj.winSampleName.on("load", obj.winSampleName_load, obj);
	obj.winBtnCancle.on("click", obj.winBtnCancle_click, obj);
	obj.LoadEvent(arguments);
	return obj;
}

