//by+2017-03-03
function InitViewScreen()
{
	var obj = new Object();
	obj.appArcimStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.appArcimStore = new Ext.data.Store({
		proxy: obj.appArcimStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ArcimDR'
		}, 
		[
		     {name: 'ArcimDR', mapping: 'ArcimDR'}
			,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
		])
	});	
	obj.appArcim = new Ext.form.ComboBox({
		id : 'appArcim'
		,store:obj.appArcimStore
		,minChars:1	
		,displayField:'ArcimDesc'	
		,fieldLabel : '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp'+'���������Ӧҽ����'
		,labelSeparator: ''
		,valueField : 'ArcimDR'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
	}); 		
	obj.appArcimStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPAppSet';
		param.QueryName = 'FindMasterItem';
		param.Arg1 = obj.appArcim.getRawValue();
		param.ArgCnt = 1;
	});
	obj.appArcimStore.load({});
	
	obj.Panel11 = new Ext.Panel({
	    id : 'Panel11'
		,buttonAlign : 'center'
		,columnWidth : .3
		,labelAlign : 'center'
		,labelWidth:160
		,layout : 'form'
		,items : [
		    obj.appArcim
		]
	});
	
	obj.appTime = new Ext.form.TimeField({
	    id : 'appTime'
		,format : 'H:i'
		,increment : 30
		,fieldLabel : '��������ʱ������'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.Panel12 = new Ext.Panel({
	    id : 'Panel12'
		,buttonAlign : 'center'
		,columnWidth : .3
		,labelAlign : 'right'
		,labelWidth:160
		,layout : 'form'
		,items : [
		    obj.appTime
		]
	});
obj.PanelSP1 = new Ext.Panel({
	    id : 'PanelSP1'
		,buttonAlign : 'center'
		,columnWidth : .4
		,labelAlign : 'right'
		,labelWidth:160
		,layout : 'form'
		,items : [
		]
	});
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,layout : 'form'
		,columnWidth : .2
		,items:[
		   obj.Panel11
		   ,obj.Panel12
		   ,obj.PanelSP1
		]
	});
	
	obj.arcimNote = new Ext.form.TextField({
		id : 'arcimNote'
		,fieldLabel : '������Ӧҽ���ע'
		,labelSeparator: ''
		,anchor : '100%'
	});	
	
	obj.PanelN2 = new Ext.Panel({
		id : 'PanelN2'
		,buttonAlign : 'right'
		,columnWidth : 1
		,labelAlign : 'right'
		,layout : 'form'
		,items:[
		   obj.arcimNote
		]
	});
     /*
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'right'
		,labelAlign : 'right'
		,labelWidth:160
		,layout : 'form'
		,items:[
		   //obj.PanelN2
		  // ,obj.PanelSP2
		]
	});*/
	obj.noteVar = new Ext.form.TextField({
		id : 'noteVar'
		,fieldLabel : '��ע�����Ӧ����'
		,labelSeparator: ''
		,anchor : '100%'
	});	
	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'right'
		,columnWidth : 1
		,labelAlign : 'right'
		,layout : 'form'
		,items:[
			obj.PanelN2
		   ,obj.noteVar
		]
	});
		obj.PanelSP2 = new Ext.Panel({
	    id : 'PanelSP2'
		,buttonAlign : 'center'
		,columnWidth : .4
		,labelAlign : 'right'
		,labelWidth:160
		,layout : 'form'
		,items : [
		]
	});
		obj.Panelf3 = new Ext.form.FormPanel({
		id : 'Panelf3'
		//,frame:true
		,buttonAlign : 'center'
		,labelAlign : 'center'
		,labelWidth:160
		,layout : 'form'
		,items:[
		   obj.Panel3
		   ,obj.PanelSP2
		]
	});

	obj.chkInsertDefRoom = new Ext.form.Checkbox({
	    id : 'chkInsertDefRoom'
		,fieldLabel : '�Ƿ����Ĭ��������'
		,labelSeparator: ''
		,anchor : '98%'
	});
	
	
	
	obj.chkSendMessage = new Ext.form.Checkbox({
	    id : 'chkSendMessage'
		,fieldLabel : '�Ƿ�����Ϣ'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.Panel42 = new Ext.Panel({
		id : 'Panel42'
		,buttonAlign : 'right'
		,columnWidth : .25
		,labelAlign : 'right'
		,style:'margin-left :19px;'
		,labelWidth:160
		,layout : 'form'
		,items:[
		   obj.chkSendMessage
		]
	});
	
	obj.chkInsertLabInfo = new Ext.form.Checkbox({
	    id : 'chkInsertLabInfo'
		,fieldLabel : '�Ƿ��Զ����������'
		,labelSeparator: ''
		,anchor : '98%'
	});
	
	obj.Panel43 = new Ext.Panel({
		id : 'Panel43'
		,buttonAlign : 'right'
		,columnWidth : .25
		,labelAlign : 'right'
		,style:'margin-left :19px;'
		,labelWidth:160
		,layout : 'form'
		,items:[
		   obj.chkInsertLabInfo
		]
	});
	//������������շ��Ƿ�ϲ���20161220
	obj.chkChargeTogether = new Ext.form.Checkbox({
    id : 'chkChargeTogether'
    ,fieldLabel : '������������շ��Ƿ�ϲ�'
    ,labelSeparator: ''
    ,anchor : '98%'
    });
    
    obj.PanelOT = new Ext.Panel({
	    id : 'PanelOT'
	    ,buttonAlign : 'right'
	    ,columnWidth : .25
	    ,labelAlign : 'right'
	    ,labelWidth:180
	    ,layout : 'form'
	    ,items:[
	    obj.chkChargeTogether
	    ]
	});
	
	//���˵��Ȱ�ȫ��
	obj.PatScheduleStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.PatScheduleStore = new Ext.data.Store({
		proxy: obj.PatScheduleStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
		     {name: 'ID', mapping: 'ID'}
			,{name: 'Group', mapping: 'Group'}
		])
	});	
	obj.PatSchedule = new Ext.form.ComboBox({
		id : 'PatSchedule'
		,store:obj.PatScheduleStore
		,minChars:1	
		,displayField:'Group'	
		,fieldLabel : '���˵��Ȱ�ȫ��'
		,valueField : 'ID'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.PatScheduleStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLSET';
		param.QueryName = 'SSGROUP';
		param.Arg1 = obj.PatSchedule.getRawValue();
		param.ArgCnt = 1;
	});
	obj.PatScheduleStore.load({});
	
	//20190102 yq
	obj.chkOneOperName=new Ext.form.Checkbox({
	    id : 'chkOneOperName'
		,fieldLabel : '��ʩʵʩ�����Ƿ�һ��'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.Panel45 = new Ext.Panel({
		id : 'Panel45'
		,buttonAlign : 'right'
		,columnWidth : .25
		,labelAlign : 'right'
		//,style:'margin-left :19px;'
		,labelWidth:180
		,layout : 'form'
		,items:[
		   obj.chkOneOperName
		]
	});
	obj.chkDayOperNeedAN= new Ext.form.Checkbox({
	    id : 'chkDayOperNeedAN'
		,fieldLabel : '�ռ������Ƿ���Ҫ����'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.Panel44 = new Ext.Panel({
		id : 'Panel44'
		,buttonAlign : 'right'
		,columnWidth : .25
		,labelAlign : 'right'
		//,style:'margin-left :19px;'
		,labelWidth:180
		,layout : 'form'
		,items:[
		   obj.chkDayOperNeedAN
		]
	});
	
	//������ȫ��
	obj.NursingWorkerStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.NursingWorkerStore = new Ext.data.Store({
		proxy: obj.NursingWorkerStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
		     {name: 'ID', mapping: 'ID'}
			,{name: 'Group', mapping: 'Group'}
		])
	});	
	obj.NursingWorker = new Ext.form.ComboBox({
		id : 'NursingWorker'
		,store:obj.NursingWorkerStore
		,minChars:1	
		,displayField:'Group'	
		,fieldLabel : '������ȫ��'
		,valueField : 'ID'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.NursingWorkerStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLSET';
		param.QueryName = 'SSGROUP';
		param.Arg1 = obj.NursingWorker.getRawValue();
		param.ArgCnt = 1;
	});
	obj.NursingWorkerStore.load({});
	
	
	
	obj.Panelf4 = new Ext.form.FormPanel({
		id : 'Panelf4'
		,buttonAlign : 'center'
		//,frame:true
		,columnWidth : .25
		,layout : 'form'
		,items:[
		   obj.Panel42
		   ,obj.Panel43
		   ,obj.PanelOT
		   ,obj.Panel44
		]
	});
	
	obj.IPDefOpLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.IPDefOpLocStore = new Ext.data.Store({
		proxy: obj.IPDefOpLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rw'
		}, 
		[
		     {name: 'rw', mapping: 'rw'}
			,{name: 'desc', mapping: 'desc'}
		])
	});	
	obj.IPDefOpLoc = new Ext.form.ComboBox({
		id : 'IPDefOpLoc'
		,store:obj.IPDefOpLocStore
		,minChars:1	
		,displayField:'desc'	
		,labelSeparator: ''
		,fieldLabel : 'סԺ����Ĭ��������'
		,valueField : 'rw'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.IPDefOpLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPSET';
		param.QueryName = 'GetOpLoc';
		param.Arg1 =obj.IPDefOpLoc.getRawValue();
		param.ArgCnt = 1;
	});
	obj.IPDefOpLocStore.load({});
	
	obj.Panel51 = new Ext.Panel({
		id : 'Panel51'
		,buttonAlign : 'right'
		,columnWidth : .25
		,labelAlign : 'right'
		,labelWidth:160
		,layout : 'form'
		,items:[
		   obj.IPDefOpLoc
		]
	});
	
	obj.OPDefOpLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.OPDefOpLocStore = new Ext.data.Store({
		proxy: obj.OPDefOpLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rw'
		}, 
		[
		     {name: 'rw', mapping: 'rw'}
			,{name: 'desc', mapping: 'desc'}
		])
	});	
	obj.OPDefOpLoc = new Ext.form.ComboBox({
		id : 'OPDefOpLoc'
		,store:obj.OPDefOpLocStore
		,minChars:1	
		,displayField:'desc'	
		,fieldLabel : '��������Ĭ��������'
		,labelSeparator: ''
		,valueField : 'rw'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.OPDefOpLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPSET';
		param.QueryName = 'GetOpLoc';
		param.Arg1 =obj.OPDefOpLoc.getRawValue();
		param.ArgCnt = 1;
	});
	obj.OPDefOpLocStore.load({});
	
	obj.Panel52 = new Ext.Panel({
		id : 'Panel52'
		,buttonAlign : 'right'
		,columnWidth : .25
		,labelAlign : 'right'
		,labelWidth:160
		,layout : 'form'
		,items:[
		   obj.OPDefOpLoc
		   ,obj.PatSchedule
		   ,obj.NursingWorker
		]
	});
	
	obj.saveButton = new Ext.Button({
		id : 'saveButton'
		,width:86
		,text : '����'
		,iconCls : 'icon-save'
	});
	
	obj.saveButtonPanel = new Ext.Panel({
		id : 'saveButtonPanel'
		,buttonAlign : 'right'
		,columnWidth : .4
		,style:'margin-left:30px;'
		,layout : 'form'
		,items:[
		    obj.saveButton
		]
	});
	
	obj.Panelf5 = new Ext.form.FormPanel({
		id : 'Panelf5'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
		   obj.Panel1
		   ,obj.Panel51
		   ,obj.saveButtonPanel
		   
		]
	});
	obj.Panelfgroup= new Ext.form.FormPanel({
		id : 'Panelfgroup'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
		   obj.Panel52
		   
		]
	});
	obj.DirAuditStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.DirAuditStore = new Ext.data.Store({
		proxy: obj.DirAuditStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
		     {name: 'ID', mapping: 'ID'}
			,{name: 'Group', mapping: 'Group'}
		])
	});	
	obj.DirAudit = new Ext.form.ComboBox({
		id : 'DirAudit'
		,store:obj.DirAuditStore
		,minChars:1	
		,displayField:'Group'	
		,fieldLabel : '��������˰�ȫ��'
		,valueField : 'ID'
		,labelSeparator: ''
		,triggerAction : 'all'
		//,height:80
    	,width:160
		,editable : true
		,mode: 'local'
		,anchor : '95%'
	}); 	
	
	obj.DirAuditStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLSET';
		param.QueryName = 'SSGROUP';
		param.Arg1 = obj.DirAudit.getRawValue();
		param.ArgCnt = 1;
	});
	obj.DirAuditStore.load({});
	
	obj.Panel6SA = new Ext.Panel({
		id : 'Panel6SA'
		,buttonAlign : 'right'
		,labelAlign : 'right'
		,layout : 'form'
		,items:[
		   obj.DirAudit
		]
	});
	
		

	
	obj.data = [];
	obj.DirAuditListStoreProxy=obj.data;
	obj.DirAuditListStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(obj.data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'listId'}
			,{name: 'listDesc'}
		])
	});
	obj.DirAuditListStore.load();
	
	obj.DirAuditListGridPanel = new Ext.grid.GridPanel({
		id : 'DirAuditListGridPanel'
 		,store: obj.DirAuditListStore
    	,height:80
    	,width:160
    	,hideHeaders:true
    	,viewConfig:{forceFit:true}
    	,stripeRows:true
    	,cm:new Ext.grid.ColumnModel([{
        	header: 'ID',
        	dataIndex: 'listId',
        	hidden:true
    	},{
        	header: 'Desc',
        	dataIndex: 'listDesc'
    	}])
	}); 
	
	obj.PanelDAL = new Ext.Panel({
		id : 'PanelDAL'
		,buttonAlign : 'right'
		,style:'margin-left:160px;'
		,layout : 'form'
		,items:[
			obj.DirAuditListGridPanel 
		]
	});
	obj.Panelf6 = new Ext.form.FormPanel({
		id : 'Panelf6'
		,buttonAlign : 'center'
		,labelAlign : 'center'
		,columnWidth : .25
		,labelWidth:160
		,layout : 'form'
		,items:[
		   obj.Panel6SA
		   ,obj.PanelDAL 
		]
	});
	
	/*
	obj.Panel72 = new Ext.form.FormPanel({
		id : 'Panel72'
		//,frame:true
		,layout : 'form'
		,columnWidth : .14
		,items:[
			obj.saveButtonPanel
		]
	});
	*/
		
	
	obj.fPanell = new Ext.Panel({
		id : 'fPanell'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'column'
		,labelWidth:160
		,height : 200
		,frame : true
		,items:[
			obj.Panelf5
			,obj.Panelfgroup
			,obj.Panelf6
			,obj.Panelf4
		]
	});
	obj.fPanel = new Ext.Panel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'form'
		,frame : true
		//,collapsible:true
		,animate:true
		,items:[
			obj.Panelf3
			,obj.fPanell
		]
	});
	
	//---------------------------------------------------------------------
	
	//ҽ����Ա����
	obj.CarPrvTpStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.CarPrvTpStore = new Ext.data.Store({
		proxy: obj.CarPrvTpStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTCPTRowId'
		}, 
		[
		     {name: 'CTCPTRowId', mapping: 'CTCPTRowId'}
			,{name: 'CTCPTDesc', mapping: 'CTCPTDesc'}
		])
	});	
	
	obj.CarPrvTpStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPAppSet';
		param.QueryName = 'FindCarPrvTp';
		param.ArgCnt = 0;
	});
	obj.CarPrvTpStore.load({});
	
	obj.CarPrvTp = new Ext.grid.GridPanel({
		id : 'CarPrvTp'
		,height:180
 		,store: obj.CarPrvTpStore
    	,viewConfig:{forceFit:true}
    	,stripeRows:true
    	,cm:new Ext.grid.ColumnModel([{
        	header: 'ID',
        	dataIndex: 'CTCPTRowId',
        	width:20
    	},{
        	header: 'Desc',
        	dataIndex: 'CTCPTDesc'
    	}])
	}); 	
	
	obj.CarPrvTpPanel = new Ext.Panel({
		id : 'CarPrvTpPanel'
		,title : 'ҽ����Ա����'
		,frame : true
		,animate:true
		,iconCls : 'icon-normalinfo'
		,columnWidth : .2
    	,width:200
		,layout: 'form'
		,items:[
			obj.CarPrvTp
		]
	});
	
	//�������ҽ������
	obj.addOpDocButton = new Ext.Button({
		id : 'addOpDocButton'
		,anchor:'95%'
		,iconCls : 'icon-add'
		,text : '���>>'
	});
	
	obj.addOpDocPanel = new Ext.Panel({
		id : 'addOpDocPanel'
		,buttonAlign : 'center'
		//,columnWidth : .2
		,height:90
		,layout: {type: 'vbox',pack: 'end',align: 'top'}
		,items:[
		    obj.addOpDocButton
		]
	});
	//ɾ������ҽ������
	obj.delOpDocButton = new Ext.Button({
		id : 'delOpDocButton'
		,anchor:'95%'
		,text : 'ɾ��<<'
		,iconCls : 'icon-delete'
	});
	
	obj.delOpDocPanel = new Ext.Panel({
		id : 'delOpDocPanel'
		,buttonAlign : 'center'
		,height:100
		,layout: {type: 'vbox',pack: 'start',align: 'top'}
		,items:[
		    obj.delOpDocButton
		]
	});
	obj.PanelTemp1 = new Ext.Panel({
		id : 'PanelTemp1'
		,height:30
		,layout : 'form'
		,items:[
		]
	});
	
	obj.OpDocButtonPanel = new Ext.Panel({
		id : 'AnLocButtonPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,height:258
		,frame : true
		,layout : 'form'
		,items:[
		    obj.addOpDocPanel
		    ,obj.PanelTemp1
		    ,obj.delOpDocPanel
		]
	});
	
	//��������ҽ������
	obj.OpDocTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.OpDocTypeStore = new Ext.data.Store({
		proxy: obj.OpDocTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OpDocTypeId'
		}, 
		[
		     {name: 'OpDocTypeId', mapping: 'OpDocTypeId'}
			,{name: 'OpDocType', mapping: 'OpDocType'}
		])
	});	
	
	obj.OpDocTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPAppSet';
		param.QueryName = 'FindOpDocType';
		param.ArgCnt = 0;
	});
	obj.OpDocTypeStore.load({});
	
	obj.OpDocType = new Ext.grid.GridPanel({
		id : 'OpDocType'
		,height:180
 		,store: obj.OpDocTypeStore
    	,viewConfig:{forceFit:true}
    	,stripeRows:true
    	,cm:new Ext.grid.ColumnModel([{
        	header: 'ID',
        	dataIndex: 'OpDocTypeId',
        	width:20
    	},{
        	header: 'Desc',
        	dataIndex: 'OpDocType'
    	}])
	}); 	
	
	obj.OpDocTypePanel = new Ext.Panel({
		id : 'OpDocTypePanel'
		,title : '����ҽʦ����'
		,frame : true
		,animate:true
		,columnWidth : .2
		,iconCls : 'icon-normalinfo'
    	,width:150
		,layout: 'column'
		,items:[
			obj.OpDocType
		]
	});
	
	//��������
	obj.OpCategoryStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.OpCategoryStore = new Ext.data.Store({
		proxy: obj.OpCategoryStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CATEGRowId'
		}, 
		[
		     {name: 'CATEGRowId', mapping: 'CATEGRowId'}
			,{name: 'CATEGDesc', mapping: 'CATEGDesc'}
		])
	});	
	
	obj.OpCategoryStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPAppSet';
		param.QueryName = 'FindOpCategory';
		param.ArgCnt = 0;
	});
	obj.OpCategoryStore.load({});
	
	obj.OpCategory = new Ext.grid.GridPanel({
		id : 'OpCategory'
 		,store: obj.OpCategoryStore
    	//,multiSelect: true
    	,height:180
    	,viewConfig:{forceFit:true}
    	,stripeRows:true
    	,cm:new Ext.grid.ColumnModel([{
        	header: 'ID',
        	dataIndex: 'CATEGRowId',
        	width:20
    	},{
        	header: 'Desc',
        	dataIndex: 'CATEGDesc'
    	}])
	}); 	
	
	obj.OpCategoryPanel = new Ext.Panel({
		id : 'OpCategoryPanel'
		,title : '��������'
		,frame : true
		,animate:true
		,iconCls : 'icon-normalinfo'
		,columnWidth : .2
    	,width:250
		,layout: 'form'
		,items:[
			obj.OpCategory
		]
	});
	
	//�����������ఴť
	obj.SaveOpCatButton = new Ext.Button({
		id : 'SaveOpCatButton'
		,width:86
		,text : '������������'
		,iconCls : 'icon-save'
	});
	
	//��ʾ��Ϣ
	obj.labelinfo1=new Ext.form.Label(
	{
		id:'labelinfo1'
		,height:30
		,html:'<font color="blue"><strong><b>����ҽ����Ա�������ܿ�����������:</b></strong></font>'
	});
	obj.labelinfo2=new Ext.form.Label(
	{
		id:'labelinfo2'
		,height:30
		,html:'<font color="blue"><strong><b>˫��ĳһҽ����Ա���Ϳ�����ʾ����������;</b></strong></font>'
	});
	obj.labelinfo3=new Ext.form.Label(
	{
		id:'labelinfo3'
		,height:30
		,html:'<font color="blue"><strong><b>��Ctrl��ѡ������������;</b></strong></font>'
	});
	obj.labelinfo4=new Ext.form.Label(
	{
		id:'labelinfo4'
		,height:30
		,html:'<font color="blue"><strong><b>�ٵ�"������������"��ť;</b></strong></font>'
	});
	
	obj.InfoAndButtonPanel = new Ext.Panel({
		id : 'PanelText1'
		,buttonAlign : 'center'
		,title:'����ע������'
		,height:360
		,width:400
		,columnWidth : .3
		,labelWidth:160
		,frame : true
		,iconCls : 'icon-ordermanage'
		,region : 'center'
		,layout :{ type : 'vbox'}
		,items:[
			obj.labelinfo1
			,obj.labelinfo2
			,obj.labelinfo3
			,obj.labelinfo4
			,obj.SaveOpCatButton
		]
	});
	
	obj.buttomPanel = new Ext.Panel({
		id : 'buttomPanel'
		,buttonAlign : 'center'
		,region : 'south'
		,layout : 'column'
		,height : 300
		,frame : true
		,items:[
			obj.CarPrvTpPanel
			,obj.OpDocButtonPanel
			,obj.OpDocTypePanel
			,obj.OpCategoryPanel
			,obj.InfoAndButtonPanel
		]
	});
	
	//---------------------------------------------------------------------
	
	obj.AnOpAppSetPanel = new Ext.Panel({
		id : 'AnOpAppSetPanel'
		,buttonAlign : 'center'
		,title : '������������'
		,region : 'center'
		,iconCls : 'icon-manage'
		//,height:900
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
			,obj.buttomPanel
		]
	});
	
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.AnOpAppSetPanel
		]
	}); 
	
	
	//-----�����¼�----------
	InitViewScreenEvent(obj);
	
	obj.LoadEvent(arguments);
	
	obj.saveButton.on("click", obj.saveButton_click, obj); 
	obj.DirAudit.on("select",obj.DirAudit_select,obj);
	obj.DirAuditListGridPanel.on("rowdblclick",obj.DirAuditListGridPanel_rowdblclick,obj);
	obj.addOpDocButton.on("click",obj.addOpDocButton_click, obj);
	obj.delOpDocButton.on("click",obj.delOpDocButton_click, obj);
	obj.SaveOpCatButton.on("click", obj.SaveOpCatButton_click, obj);
	obj.CarPrvTp.on("rowdblclick",obj.CarPrvTp_rowdblclick,obj);
	obj.appArcim.on('select',obj.appArcim_select,obj);
	
    return obj;
	
}