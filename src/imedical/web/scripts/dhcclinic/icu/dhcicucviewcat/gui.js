//update by GY 20170307
function InitViewScreen(){
	var obj = new Object();
	
	obj.icucvcCode = new Ext.form.TextField({
		id : 'icucvcCode'
		,fieldLabel : '��ʾ��������'
		,labelSeparator: ''
		,anchor : '95%'
	});	

	obj.icucvcEventstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.icucvcEventstore = new Ext.data.Store({
		proxy: obj.icucvcEventstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvcEvent'
			}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.icucvcEvent = new Ext.form.ComboBox({
		id : 'icucvcEvent'
		,store:obj.icucvcEventstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '��ʾ�¼�'
		,valueField : 'Desc'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
	});
	
	obj.icucvcDisplayByCatstoreProxy =new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.icucvcDisplayByCatstore = new Ext.data.Store({
		proxy: obj.icucvcDisplayByCatstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvcDisplayByCat'
			}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.icucvcDisplayByCat = new Ext.form.ComboBox({
		id : 'icucvcDisplayByCat'
		,store:obj.icucvcDisplayByCatstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '��������ʾ'
		,valueField : 'Desc'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
	});
	
	obj.RowId = new Ext.form.TextField({
		id : 'RowId'
		,hidden : true
    });
	 
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,width : 250
		,labelWidth : 85
		,layout : 'form'
		,items:[
			obj.icucvcCode
			,obj.icucvcEvent
			,obj.icucvcDisplayByCat
			,obj.RowId
		]
	});
	
	obj.icucvcDesc = new Ext.form.TextField({
		id : 'icucvcDesc'
		,fieldLabel : '��ʾ��������'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	obj.icucvcOrderstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.icucvcOrderstore = new Ext.data.Store({
		proxy:  obj.icucvcOrderstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvcOrder'
			}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.icucvcOrder = new Ext.form.ComboBox({
		id : 'icucvcOrder'
		,store:obj.icucvcOrderstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '��ʾ��ҩ'
		,valueField : 'Desc'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
	});
	
	obj.icucvscDescstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.icucvscDescstore = new Ext.data.Store({
		proxy: obj.icucvscDescstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvscId'
		}, 
		[
			{name: 'icucvscId', mapping: 'icucvscId'}
			,{name: 'icucvscDesc', mapping: 'icucvscDesc'}
		])
	});
	obj.icucvscDesc = new Ext.form.ComboBox({
		id : 'icucvscDesc'
		,store:obj.icucvscDescstore
		,minChars:1
		,displayField:'icucvscDesc'
		,fieldLabel : '��ʾ����'
		,valueField : 'icucvscId'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
	});
	
	obj.icucvscId = new Ext.form.TextField({
		id : 'icucvscId'
		,hidden : true
    });
    
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,width : 250
		,labelWidth : 85
		,layout : 'form'
		,items:[
			obj.icucvcDesc
			,obj.icucvcOrder
			,obj.icucvscDesc
			,obj.icucvscId
		]
	});
	
	obj.icucvcVPSitestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.icucvcVPSitestore = new Ext.data.Store({
		proxy:  obj.icucvcVPSitestoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvcVPSite'
			}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.icucvcVPSite = new Ext.form.ComboBox({
		id : 'icucvcVPSite'
		,store:obj.icucvcVPSitestore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '��������'
		,valueField : 'Desc'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
	});

	obj.icucvcTherapystoreProxy =new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    /*function seltextstatus(v, record) { 
         return record.Id+" || "+record.Desc; 
    } */
	obj.icucvcTherapystore = new Ext.data.Store({
		proxy: obj.icucvcTherapystoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvcTherapy'
			}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
			//,{ name: 'selecttexts', convert: seltextstatus}
		])
	});
	obj.icucvcTherapy = new Ext.form.ComboBox({
		id : 'icucvcTherapy'
		,store:obj.icucvcTherapystore
		,minChars:1
		,displayField:'Desc'
		//,displayField:'selecttexts'
		,fieldLabel : '��ʾ����'
		,valueField : 'Desc'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
	});
	
	obj.icucvcSummaryTypestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.icucvcSummaryTypestore = new Ext.data.Store({
		proxy: obj.icucvcSummaryTypestoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tCode'
		}, 
		[
			{name: 'tCode', mapping: 'tCode'}
			,{name: 'tDesc', mapping: 'tDesc'}
		])
	});
	obj.icucvcSummaryType = new Ext.form.ComboBox({
		id : 'icucvcSummaryType'
		,store:obj.icucvcSummaryTypestore
		,minChars:1
		,displayField:'tDesc'
		,fieldLabel : '��������'
		,valueField : 'tCode'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
	});
	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,width : 200
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.icucvcVPSite
			,obj.icucvcTherapy
			,obj.icucvcSummaryType
		]
	});

		obj.icucvcVSstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.icucvcVSstore = new Ext.data.Store({
		proxy:  obj.icucvcVSstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvcVS'
			}, 
		[
			{name: 'Desc', mapping: 'Desc'}
			,{name: 'Id', mapping: 'Id'}
			
		])
	});
	obj.icucvcVS = new Ext.form.ComboBox({
		id : 'icucvcVS'
		,store:obj.icucvcVSstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '��ʾ��������'
		,valueField : 'Desc'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
	});
	
	obj.icucvcLabstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
   /* function seltext(v, record) { 
         return record.tID+" || "+record.tBPCEMDesc; 
    } */
    
	obj.icucvcLabstore = new Ext.data.Store({
		proxy: obj.icucvcLabstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'icucvcLab'
			}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		    //,{ name: 'selecttext', convert: seltext}
		])
	});
	obj.icucvcLab = new Ext.form.ComboBox({
		id : 'icucvcLab'
		,store:obj.icucvcLabstore
		,minChars:1
		,displayField:'Desc'
		//,displayField:'selecttext'
		,fieldLabel : '��ʾ����'
		,valueField : 'Desc'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
	});
	obj.icucvcOptions = new Ext.form.TextField({
		id : 'icucvcOptions'
		,fieldLabel : 'ѡ��'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,width : 200
		,labelWidth : 90
		,layout : 'form'
		,items:[
			obj.icucvcVS
			,obj.icucvcLab
			,obj.icucvcOptions
		]
	});
	
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .8
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
		,text : '����'
		,iconCls : 'icon-add'
		,style: 'margin-left:10px'
		,width:86
	});

	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,text : '����'
		,iconCls : 'icon-updateSmall'
		,style: 'margin-Top:5px;margin-left:10px'
		,width:86
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,iconCls : 'icon-delete'
		,style: 'margin-left:10px'
		,width:86
		,text : 'ɾ��'
	});
	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,iconCls : 'icon-find'
		,style: 'margin-Top:5px;margin-left:10px'
		,width:86
		,text : '��ѯ'
	});

	obj.keypanel1 = new Ext.Panel({
		id : 'keypanel1'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'column'
        ,items:[
            obj.addbutton
            ,obj.updatebutton
       ]
	});
	obj.keypanel2 = new Ext.Panel({
		id : 'keypanel2'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'column'
        ,items:[
            obj.deletebutton
           ,obj.findbutton
       ]
	});
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,height : 80
		,columnWidth : .2
		,layout : 'column'
		,frame : false
		,items:[
			obj.keypanel1
			,obj.keypanel2
		]
	});
	
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 120
		,title : '��֢��ʾ����ά��'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,collapsible:true
		,animate:true
		,iconCls : 'icon-manage'
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
			,{name: 'tIcucvcCode', mapping: 'tIcucvcCode'}
			,{name: 'tIcucvcDesc', mapping: 'tIcucvcDesc'}
			,{name: 'tIcucvcVPSite', mapping: 'tIcucvcVPSite'}
			,{name: 'tIcucvcVS', mapping: 'tIcucvcVS'}
			,{name: 'tIcucvcEvent', mapping: 'tIcucvcEvent'}
			,{name: 'tIcucvcOrder', mapping: 'tIcucvcOrder'}
			,{name: 'tIcucvcTherapy', mapping: 'tIcucvcTherapy'}
			,{name: 'tIcucvcLab', mapping: 'tIcucvcLab'}
			,{name: 'tIcucvscDesc', mapping: 'tIcucvscDesc'}
			,{name: 'tIcucvscId', mapping: 'tIcucvscId'}
			,{name: 'tIcucvcDisplayByCat', mapping: 'tIcucvcDisplayByCat'}
			,{name: 'tIcucvcSummaryType', mapping: 'tIcucvcSummaryType'}
			,{name: 'tIcucvcSummaryTypeDesc', mapping: 'tIcucvcSummaryTypeDesc'}
			,{name: 'tIcucvcOptions', mapping: 'tIcucvcOptions'}
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
		,{header: '�к�', width: 50, dataIndex: 'tRowId', sortable: true}
		,{header: '��ʾ���ʹ���', width: 100, dataIndex: 'tIcucvcCode', sortable: true}
		,{header: '��ʾ��������', width: 100, dataIndex: 'tIcucvcDesc', sortable: true}
		,{header: '��ʾ��������', width: 100, dataIndex: 'tIcucvcVS', sortable: true}
		,{header: '��ʾ�¼�', width: 60, dataIndex: 'tIcucvcEvent', sortable: true}
		,{header: '��ʾ��ҩ', width: 60, dataIndex: 'tIcucvcOrder', sortable: true}
		,{header: '��������', width: 60, dataIndex: 'tIcucvcVPSite', sortable: true}
		,{header: '��ʾ����', width: 60, dataIndex: 'tIcucvcTherapy', sortable: true}
		,{header: '��ʾ����', width: 60, dataIndex: 'tIcucvcLab', sortable: true}
		,{header: '��������ʾ', width: 70, dataIndex: 'tIcucvcDisplayByCat', sortable: true}
		,{header: '��ʾ����', width: 60, dataIndex: 'tIcucvscDesc', sortable: true}
		,{header: 'tIcucvscId', width: 70, dataIndex: 'tIcucvscId', sortable: true}
		,{header: 'С������', width: 60, dataIndex: 'tIcucvcSummaryTypeDesc', sortable: true}
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
		,title : '��֢��ʾ�����ѯ���'
		,iconCls : 'icon-result'
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
	
	obj.icucvcEventstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUCVC';
		param.ArgCnt = 0;
	});
	obj.icucvcEventstore.load({});
	
	obj.icucvcDisplayByCatstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUCVC';
		param.ArgCnt = 0;
	});
	obj.icucvcDisplayByCatstore.load({});

obj.icucvcOrderstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUCVC';
		param.ArgCnt = 0;
	});
	obj.icucvcOrderstore.load({});

obj.icucvcVPSitestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUCVC';
		param.ArgCnt = 0;
	});
	obj.icucvcVPSitestore.load({});

obj.icucvcTherapystoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUCVC';
		param.ArgCnt = 0;
	});
	obj.icucvcTherapystore.load({});	

obj.icucvcVSstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUCVC';
		param.ArgCnt = 0;
	});
	obj.icucvcVSstore.load({});		
	
obj.icucvcLabstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUCVC';
		param.ArgCnt = 0;
	});
	obj.icucvcLabstore.load({});		
	

	obj.icucvscDescstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindVSC';
		param.ArgCnt = 0;
	});
	obj.icucvscDescstore.load({});
	
	obj.icucvcSummaryTypestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1 = 'SummaryType';
		param.ArgCnt = 1;
	});
	obj.icucvcSummaryTypestore.load({});
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCViewCat';
		param.QueryName = 'FindICUViewCat';
		param.Arg1 = obj.icucvcCode.getValue();
		param.Arg2 = obj.icucvcDesc.getValue();
		param.Arg3 = obj.icucvscDesc.getValue();
		param.Arg4 = obj.icucvcSummaryType.getValue();
		param.ArgCnt = 4;
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