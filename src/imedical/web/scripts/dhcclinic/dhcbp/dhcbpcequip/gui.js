function InitViewScreen(){
	var obj = new Object();
	
	obj.bpcECode = new Ext.form.TextField({
		id : 'bpcECode'
		,fieldLabel : '����'
		,anchor : '95%'
	});	
	
	obj.bpcEFromDate = new Ext.form.DateField({
		id : 'bpcEFromDate'
		//,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel:'��ʼ����'
		,anchor : '95%'
	});
	obj.bpcESoftwareVersion = new Ext.form.TextField({
		id : 'bpcESoftwareVersion'
		,fieldLabel : '�汾'
		,anchor : '95%'
	});	
	obj.RowId = new Ext.form.TextField({
		id : 'RowId'
		,hidden : true
    });
	 
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.bpcECode
			,obj.bpcEFromDate
			,obj.bpcESoftwareVersion
			,obj.RowId
		]
	});
	
	obj.bpcEDesc = new Ext.form.TextField({
		id : 'bpcEDesc'
		,fieldLabel : '����'
		,anchor : '95%'
	}); 
	obj.bpcEToDate = new Ext.form.DateField({
		id : 'bpcEToDate'
		//,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel:'��������'
		,anchor : '95%'
	});
	obj.bpcEPartstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.bpcEPartstore = new Ext.data.Store({
		proxy: obj.bpcEPartstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.bpcEPart = new Ext.form.ComboBox({
		id : 'bpcEPart'
		,store:obj.bpcEPartstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '���'
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.bpcEDesc
			,obj.bpcEToDate
			,obj.bpcEPart
		]
	});
	
	obj.bpcENo = new Ext.form.TextField({
		id : 'bpcENo'
		,fieldLabel : '���'
		,anchor : '95%'
	});
	

     
	obj.bpcEStatusstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltextstatus(v, record) { 
         return record.Id+" || "+record.Desc; 
    } 
	obj.bpcEStatusstore = new Ext.data.Store({
		proxy: obj.bpcEStatusstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'Id', mapping: 'Id'}
			//,{name: 'Desc', mapping: 'Desc'}
			,{ name: 'selecttexts', convert: seltextstatus}
		])
	});
	obj.bpcEStatus = new Ext.form.ComboBox({
		id : 'bpcEStatus'
		,store:obj.bpcEStatusstore
		,minChars:1
		//,displayField:'Desc'
		,displayField:'selecttexts'
		,fieldLabel : '״̬'
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.bpcEInstallDate = new Ext.form.DateField({
		id : 'bpcEInstallDate'
		//,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel:'��װ����'
		,anchor : '95%'
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.bpcENo
			,obj.bpcEStatus
			,obj.bpcEInstallDate
		]
	});

	obj.bpcENote = new Ext.form.TextField({
		id : 'bpcENote'
		,fieldLabel : '��ע'
		,anchor : '95%'
	});
	
	obj.bpcEModelDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
    function seltext(v, record) { 
         return record.tID+" || "+record.tBPCEMDesc; 
    } 
    
	obj.bpcEModelDrstore = new Ext.data.Store({
		proxy: obj.bpcEModelDrstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tID'
		}, 
		[
			{name: 'tID', mapping: 'tID'}
			//,{name: 'tBPCEMDesc', mapping: 'tBPCEMDesc'}
		    ,{ name: 'selecttext', convert: seltext}
		])
	});
	obj.bpcEModelDr = new Ext.form.ComboBox({
		id : 'bpcEModelDr'
		,store:obj.bpcEModelDrstore
		,minChars:1
		//,displayField:'tBPCEMDesc'
		,displayField:'selecttext'
		,fieldLabel : '�豸�ͺ�'
		,valueField : 'tID'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.bpcETotalWorkingHour = new Ext.form.TextField({
		id : 'bpcETotalWorkingHour'
		,fieldLabel : '����Сʱ'
		,anchor : '95%'
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .23
		,layout : 'form'
		,items:[
			obj.bpcENote
			,obj.bpcEModelDr
			,obj.bpcETotalWorkingHour
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
	
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 180
		,title : '�����豸ά��'
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
			idProperty: 'tBPCERowId'
		}, 
	    [
			{name: 'tBPCERowId', mapping: 'tBPCERowId'}
			,{name: 'tBPCECode', mapping: 'tBPCECode'}
			,{name: 'tBPCEDesc', mapping: 'tBPCEDesc'}
			,{name: 'tBPCENo', mapping: 'tBPCENo'}
			,{name: 'tBPCEFromDate', mapping: 'tBPCEFromDate'}
			,{name: 'tBPCEToDate', mapping: 'tBPCEToDate'}
			,{name: 'tBPCEStatus', mapping: 'tBPCEStatus'}
			,{name: 'tBPCEStatusD', mapping: 'tBPCEStatusD'}
			,{name: 'tBPCENote', mapping: 'tBPCENote'}
			,{name: 'tBPCEBPCEquipModelDr', mapping: 'tBPCEBPCEquipModelDr'}
			,{name: 'tBPCEBPCEquipModel', mapping: 'tBPCEBPCEquipModel'}
			,{name: 'tBPCESoftwareVersion', mapping: 'tBPCESoftwareVersion'}
			,{name: 'tBPCEPart', mapping: 'tBPCEPart'}
			,{name: 'tBPCEInstallDate', mapping: 'tBPCEInstallDate'}
			,{name: 'tBPCETotalWorkingHour', mapping: 'tBPCETotalWorkingHour'}
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
		//,{header: 'tID', width: 50, dataIndex: 'tID', sortable: true}
		,{header: '����', width: 140, dataIndex: 'tBPCECode', sortable: true}
		,{header: '����', width: 140, dataIndex: 'tBPCEDesc', sortable: true}
		,{header: '���', width: 140, dataIndex: 'tBPCENo', sortable: true}
		,{header: '��ʼ����', width: 140, dataIndex: 'tBPCEFromDate', sortable: true}
		,{header: '��������', width: 140, dataIndex: 'tBPCEToDate', sortable: true}
		,{header: '״̬', width: 140, dataIndex: 'tBPCEStatusD', sortable: true}
		,{header: '��ע', width: 140, dataIndex: 'tBPCENote', sortable: true}
		,{header: '�豸', width: 140, dataIndex: 'tBPCEBPCEquipModel', sortable: true}
		,{header: '�汾', width: 140, dataIndex: 'tBPCESoftwareVersion', sortable: true}
		,{header: '���', width: 140, dataIndex: 'tBPCEPart', sortable: true}
		,{header: '��װ����', width: 140, dataIndex: 'tBPCEInstallDate', sortable: true}
		,{header: '����Сʱ', width: 140, dataIndex: 'tBPCETotalWorkingHour', sortable: true}
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
	

	obj.bpcEPartstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquip';
		param.QueryName = 'FindBPCEPart';
		param.ArgCnt = 0;
	});
	obj.bpcEPartstore.load({});
	
	obj.bpcEStatusstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquip';
		param.QueryName = 'FindBPCEStatus';
		param.ArgCnt = 0;
	});
	obj.bpcEStatusstore.load({});
	
	obj.bpcEModelDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquipModel';
		param.QueryName = 'FindEModel';
		param.ArgCnt = 0;
	});
	obj.bpcEModelDrstore.load({});
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquip';
		param.QueryName = 'FindEquip';
		param.Arg1=obj.bpcEModelDr.getValue();
		param.ArgCnt = 1;
	});
	obj.retGridPanelStore.load({});
	
	InitViewScreenEvent(obj);
	
	//�¼��������
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
    obj.findbutton.on("click", obj.findbutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}