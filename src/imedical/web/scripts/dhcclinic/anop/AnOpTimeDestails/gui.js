function InitViewScreen(){
	var obj = new Object();
	
	obj.dateFrm = new Ext.form.DateField({
		id : 'dateFrm'
		,value : new Date()
		,format : 'j/n/Y'
		,fieldLabel : '��ʼ����'
		,anchor : '95%'
	});
	obj.dateTo = new Ext.form.DateField({
		id : 'dateTo'
		,value : new Date()
		,format : 'j/n/Y'
		,fieldLabel : '��������'
		,anchor : '95%'
	});
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.dateFrm
			,obj.dateTo
		]
	});	
    obj.opaStartTime =new Ext.form.TimeField({
	    id : 'opaStartTime'
		,format : 'H:i:s'
		,increment : 1
		,fieldLabel : '������ʼ'
		,anchor : '95%'
	});
	obj.opaEndTime =new Ext.form.TimeField({
	    id : 'opaEndTime'
		,format : 'H:i:s'
		,increment : 1
		,fieldLabel : '��������'
		,anchor : '95%'
	});
	obj.opaId = new Ext.form.TextField({
		id : 'opaId'
		,hidden:true
		,anchor : '95%'
	}); 
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.opaStartTime
			,obj.opaEndTime
			,obj.opaId
		]
	});
	
	obj.anaStartTime =new Ext.form.TimeField({
	    id : 'anaStartTime'
		,format : 'H:i:s'
		,increment : 1
		,fieldLabel : '����ʼ'
		,anchor : '95%'
	});
	obj.anaEndTime =new Ext.form.TimeField({
	    id : 'anaEndTime'
		,format : 'H:i:s'
		,increment : 1
		,fieldLabel : '�������'
		,anchor : '95%'
	});	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.anaStartTime
			,obj.anaEndTime
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
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
		]
	});

	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,text : '����'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,text : '����'
	});
	
	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,buttonAlign : 'center'
		,layout : 'column'
        ,buttons:[
            obj.findbutton
            ,obj.updatebutton
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
		,height : 160
		,title : '�������ʱ���ѯ'
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
			idProperty: 'opaId'
		}, 
	    [
			{name: 'opaId', mapping : 'opaId'}
			,{name: 'patLocDesc', mapping : 'patLocDesc'}
			,{name: 'bedNo', mapping : 'bedNo'}
			,{name: 'patName', mapping : 'patName'}
			,{name: 'roomDesc', mapping : 'roomDesc'}
			,{name: 'ordno', mapping: 'ordno'}
			,{name: 'opdes', mapping: 'opdes'}
			,{name: 'inAreaTime', mapping: 'inAreaTime'}
			,{name: 'inRoomTime', mapping: 'inRoomTime'}
			,{name: 'anaStartTime', mapping: 'anaStartTime'}
			,{name: 'opaStartTime', mapping: 'opaStartTime'}
			,{name: 'opaEndTime', mapping: 'opaEndTime'}
			,{name: 'anaEndTime', mapping: 'anaEndTime'}
			,{name: 'leaveRoomTime', mapping: 'leaveRoomTime'}
			,{name: 'roomId', mapping: 'roomId'}
			,{name: 'patLocId', mapping: 'patLocId'}
			,{name: 'opdate', mapping: 'opdate'}
			,{name: 'anmethoddesc', mapping: 'anmethoddesc'}
			,{name: 'anDoc', mapping: 'anDoc'}
			,{name: 'PACUInDateTime', mapping: 'PACUInDateTime'}
			,{name: 'opTime', mapping: 'opTime'}
			,{name: 'anTime', mapping: 'anTime'}
			,{name: 'proAnTime', mapping: 'proAnTime'}
			,{name: 'leaveTime', mapping: 'leaveTime'}
			,{name: 'toICUTime', mapping: 'toICUTime'}
			,{name: 'toWarTime', mapping: 'toWarTime'}
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
		,{header: 'opaId', width: 30, dataIndex: 'opaId', sortable: true}
		,{header: '����', width: 80, dataIndex: 'patLocDesc', sortable: true}
		,{header: '��λ', width: 70, dataIndex: 'bedNo', sortable: true}
		,{header: '����', width: 80, dataIndex: 'patName', sortable: true}
		,{header: '������', width: 60, dataIndex: 'roomDesc', sortable: true}
		,{header: '̨��', width: 40, dataIndex: 'ordno', sortable: true}
		,{header: '��������', width:170, dataIndex: 'opdes', sortable: true}
		,{header: 'Ԥ������ʱ��', width:70, dataIndex: 'proAnTime', sortable: true}
		,{header: '��Ⱥ���', width: 90, dataIndex: 'inAreaTime', sortable: true}
		,{header: '���ز���ʱ��', width: 90, dataIndex: 'toWarTime', sortable: true}
		,{header: '����', width: 80, dataIndex: 'inRoomTime', sortable: true}
		,{header: '����ʼ', width: 80, dataIndex: 'anaStartTime', sortable: true}
		,{header: '������ʼ', width: 80, dataIndex: 'opaStartTime', sortable: true}
		,{header: '��������', width: 80, dataIndex: 'opaEndTime', sortable: true}
		,{header: '�������', width: 80, dataIndex: 'anaEndTime', sortable: true}
		,{header: '����', width: 80, dataIndex: 'leaveRoomTime', sortable: true}
		,{header: '�벡��ʱ��', width: 80, dataIndex: 'leaveTime', sortable: true}
		,{header: '��ICUʱ��', width: 80, dataIndex: 'toICUTime', sortable: true}
		,{header: 'roomid', width: 80, dataIndex: 'roomId', hidden: true}
		,{header: 'patLocId', width: 80, dataIndex: 'patLocId', hidden: true}
		,{header: '��������', width: 80, dataIndex: 'opdate', sortable: true}
		,{header: '������', width: 80, dataIndex: 'anmethoddesc', sortable: true}
		,{header: '����ҽ��', width: 80, dataIndex: 'anDoc', sortable: true}
		,{header: '��ָ���', width: 80, dataIndex: 'PACUInDateTime', sortable: true}
		,{header: '������ʱ', width: 80, dataIndex: 'opTime', sortable: true}
		,{header: '������ʱ', width: 80, dataIndex: 'anTime', sortable: true}
		]
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
	
	
	InitViewScreenEvent(obj);
	
	//�¼��������
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.findbutton.on("click", obj.findbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}