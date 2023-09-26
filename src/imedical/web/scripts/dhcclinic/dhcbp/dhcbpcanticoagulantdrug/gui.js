//by+2017-03-07
function InitViewScreen(){
	var obj = new Object();
	obj.drugCode = new Ext.form.TextField({
		id : 'drugCode'
		,fieldLabel : 'ҩƷ����'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.totalAmount = new Ext.form.TextField({
		id : 'totalAmount'
		,fieldLabel : '����'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	 //͸����ʽ	
    obj.AnticoagulantModeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.AnticoagulantModeStore = new Ext.data.Store({
	    proxy : obj.AnticoagulantModeStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'tBPCAMRowId'
		},
		[   
		     {name: 'checked', mapping : 'checked'}
		    ,{name:'tBPCAMDesc',mapping:'tBPCAMDesc'}
			,{name:'tBPCAMRowId',mapping:'tBPCAMRowId'}
		])
	
	});
	
	obj.AnticoagulantMode = new Ext.ux.form.LovCombo({
	    id : 'AnticoagulantMode'
		,store : obj.AnticoagulantModeStore
		,minChars : 1
		,displayField : 'tBPCAMDesc'
		,fieldLabel : '������ʽ'
		,labelSeparator: ''
		,valueField : 'tBPCAMRowId'
		,triggerAction : 'all'
		,anchor : '95%'
	}); 
	
	obj.AnticoagulantModeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCAnticoagulantMode';
		param.QueryName = 'FindAntMode';
		//param.Arg1 = "";
		param.ArgCnt = 0;
	}); 
	obj.AnticoagulantModeStore.load({});
	
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });	
    
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,layout : 'form'
		,columnWidth:.2
		,items:[
			obj.drugCode
			,obj.totalAmount
			,obj.AnticoagulantMode
			,obj.Rowid
		]
	});
	
	obj.drugName = new Ext.form.TextField({
		id : 'drugName'
		,fieldLabel : 'ҩƷ����'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.FirstAmount = new Ext.form.TextField({
		id : 'FirstAmount'
		,fieldLabel : '������'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.note = new Ext.form.TextField({
		id : 'note'
		,fieldLabel : '��ע'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
		
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,layout : 'form'
		,columnWidth:.2
		,items:[
			obj.drugName
			,obj.FirstAmount
			,obj.note
		]
	});
		
	obj.drugUnit = new Ext.form.TextField({
		id : 'drugUnit'
		,fieldLabel : '��λ'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.drugDosage = new Ext.form.TextField({
		id : 'drugDosage'
		,fieldLabel : '����'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	
	
	obj.drugConcentration = new Ext.form.TextField({
		id : 'drugConcentration'
		,fieldLabel : 'Ũ��'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.drugFrequency = new Ext.form.TextField({
		id : 'drugFrequency'
		,fieldLabel : 'Ƶ��'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.ctlocdescstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.ctlocdescstore = new Ext.data.Store({
		proxy: obj.ctlocdescstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctlocId'
		}, 
		[
		     {name: 'ctlocId', mapping: 'ctlocId'}
			,{name: 'ctlocDesc', mapping: 'ctlocDesc'}
			,{name: 'ctlocCode', mapping: 'ctlocCode'}
		])
	});	
	obj.ctlocdesc = new Ext.form.ComboBox({
		id : 'ctlocdesc'
		,store:obj.ctlocdescstore
		,minChars:1	
		,displayField:'ctlocDesc'	
		,fieldLabel : '����'
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	}); 	
	
	obj.ctlocdescstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'FindLocList';
		param.Arg1=obj.ctlocdesc.getValue();
		param.Arg2="";
		param.Arg3="";
		param.ArgCnt = 3;
	});
	obj.ctlocdescstore.load({});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,labelWidth : 80
		,layout : 'form'
		,columnWidth:.2
		,items:[
			obj.drugUnit
			,obj.drugDosage
			,obj.drugFrequency
		]
	});	
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,labelWidth : 80
		,columnWidth:.2
		,layout : 'form'
		,items:[
			obj.drugConcentration
			,obj.ctlocdesc
			
		]
	});	
		obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,text : '���'
		,width: 86
		,iconCls : 'icon-add'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width: 86
		,style:'margin-top :3px;'
		,text : 'ɾ��'
		,iconCls : 'icon-delete'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width: 86
		,style:'margin-top :3px;'
		,iconCls : 'icon-updateSmall'
		,text : '����'
	});
	
	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,buttonAlign : 'center'
		,style:'margin-left :20px;'
		,layout : 'form'
		,columnWidth:.2
		,labelWidth : 80
        ,items:[
            obj.addbutton
            ,obj.updatebutton
            ,obj.deletebutton
       ]
	});

	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'center'
		//,region : 'left'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.keypanel
		]
	});

	
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 130
		,title : '����ҩƷ������ؿ�����ʽά��'
		,iconCls : 'icon-manage'
		,region : 'north'
		,layout : 'column'
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
			idProperty: 'tID'
		}, 
	    [
			,{name: 'tID', mapping : 'tID'}
			,{name: 'tBPCADCode', mapping: 'tBPCADCode'}
			,{name: 'tBPCADDesc', mapping: 'tBPCADDesc'}
			,{name: 'tBPCADUomDr', mapping: 'tBPCADUomDr'}
			,{name: 'tBPCADConcentration', mapping: 'tBPCADConcentration'}
			,{name: 'tBPCADAmount', mapping: 'tBPCADAmount'}
			,{name: 'tBPCADFirstAmount', mapping: 'tBPCADFirstAmount'}
			,{name: 'tBPCADDose', mapping: 'tBPCADDose'}
			,{name: 'tBPCADFrequency', mapping: 'tBPCADFrequency'}
			,{name: 'tBPCCArcim', mapping: 'tBPCCArcim'}
			,{name: 'tBPCADNote', mapping: 'tBPCADNote'}
			,{name: 'tBPCAMIdList', mapping: 'tBPCAMIdList'}
			,{name: 'tBPCAMDescList', mapping: 'tBPCAMDescList'}
			,{name: 'tBPCDeptId', mapping: 'tBPCDeptId'}
			,{name: 'tBPCDept', mapping: 'tBPCDept'}
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
		,{header: 'ҩƷ����', width: 150, dataIndex: 'tBPCADCode', sortable: true}
		,{header: 'ҩƷ����', width: 200, dataIndex: 'tBPCADDesc', sortable: true}
		,{header: '��λ', width: 80, dataIndex: 'tBPCADUomDr', sortable: true}
		,{header: 'Ũ��', width: 80, dataIndex: 'tBPCADConcentration', sortable: true}
		,{header: '����', width: 80, dataIndex: 'tBPCADAmount', sortable: true}
		,{header: '������', width: 80, dataIndex: 'tBPCADFirstAmount', sortable: true}
		,{header: '����', width: 80, dataIndex: 'tBPCADDose', sortable: true}
		,{header: 'Ƶ��', width: 80, dataIndex: 'tBPCADFrequency', sortable: true}
		,{header: '������ʽ', width: 200, dataIndex: 'tBPCAMDescList', sortable: true}
		,{header: '��ע', width: 120, dataIndex: 'tBPCADNote', sortable: true}
		,{header: '����', width: 120, dataIndex: 'tBPCDept', sortable: true}
		,{header: 'ϵͳ��', width: 80, dataIndex: 'tID', sortable: true}
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
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCAnticoagulantDrug';
		param.QueryName = 'FindAnticoagulantDrug';
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