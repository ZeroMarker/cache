function InitViewScreen(){
	var obj = new Object();
	var selectObj=window.dialogArguments;
	 obj.proAnTime =new Ext.form.TimeField({
	    id : 'proAnTime'
		,format : 'H:i:s'
		,increment : 1
		,fieldLabel : 'Ԥ������ʱ��'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.leaveTime =new Ext.form.TimeField({
	    id : 'leaveTime'
		,format : 'H:i:s'
		,increment : 1
		,fieldLabel : '�벡��ʱ��'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.opaId = new Ext.form.TextField({
		id : 'opaId'
		,hidden:true
		,anchor : '95%'
	}); 
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .45
		,layout : 'form'
		,items:[
			obj.proAnTime
			,obj.leaveTime
			,obj.opaId
		]
	});
	
	obj.toICUTime =new Ext.form.TimeField({
	    id : 'toICUTime'
		,format : 'H:i:s'
		,increment : 1
		,fieldLabel : '��ICUʱ��'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.toWarTime =new Ext.form.TimeField({
	    id : 'toWarTime'
		,format : 'H:i:s'
		,increment : 1
		,fieldLabel : '���ز���ʱ��'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .45
		,layout : 'form'
		,items:[
			obj.toICUTime
			,obj.toWarTime
		]
	});
	
	
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 100
		//,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
		]
	});

	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,iconCls : 'icon-save'
		,text : '����'
	});
	obj.closebutton = new Ext.Button({
		id : 'closebutton'
		,iconCls : 'icon-close'
		,text : '�ر�'
	});
	obj.btnSavePanel=new Ext.Panel({
	   id:'btnSavePanel'
	   ,columnWidth : .3
	   ,items:
	   [
	    obj.updatebutton
	   ]
	  })
	  obj.btnSpacePanel1=new Ext.Panel({
	   id:'btnSpacePanel1'
	   ,columnWidth : .1
	   ,width:80
	   ,items:
	   [
	   ]
	  })
	  obj.btnSpacePanel=new Ext.Panel({
	   id:'btnSpacePanel'
	   ,columnWidth : .3
	   ,width:60
	   ,items:
	   [
	   ]
	  })
	  obj.btnClosePanel=new Ext.Panel({
	   id:'btnClosePanel'
	   ,columnWidth : .3
	   ,items:
	   [
	    	obj.closebutton
	   ]
	  })

	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
		]
        ,buttons:[
        obj.btnSpacePanel1
            ,obj.btnSavePanel
            ,obj.btnSpacePanel
            ,obj.btnClosePanel
       ]
	});
	
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 50
		//,region : 'center'
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
		,title : '�������ʱ����Ϣ'
		,region : 'center'
		,layout : 'form'
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
			{name: 'proAnTime', mapping : 'proAnTime'}
			,{name: 'leaveTime', mapping : 'leaveTime'}
			,{name: 'toICUTime', mapping : 'toICUTime'}
			,{name: 'toWarTime', mapping : 'toWarTime'}
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
		,{header: 'opaId', width: 30, dataIndex: 'opaId', hidden: true}
		,{header: 'Ԥ������ʱ��', width: 80, dataIndex: 'proAnTime', sortable: true}
		,{header: '�벡����ʱ��', width: 80, dataIndex: 'leaveTime', sortable: true}
		,{header: '��ICUʱ��', width: 70, dataIndex: 'toICUTime', sortable: true}
		,{header: '���ز���ʱ��', width: 80, dataIndex: 'toWarTime', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
		})
	});
    obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRecord';
		param.QueryName = 'GetTimeByOpaId';
		//param.Arg1 = selectObj.get('opaId');
		param.ArgCnt = 1;
		});
		obj.retGridPanelStore.load({});
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
		,hidden : true
		,buttonAlign : 'center'
		,region : 'north'
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
	obj.toICUTime.on("blur",obj.toICUTime_blur,obj)
	obj.toWarTime.on("blur",obj.toWarTime_blur,obj)
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.closebutton.on('click',obj.closebutton_click,obj)
	obj.LoadEvent(arguments);
	return obj;
}
