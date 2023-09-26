Ext.onReady(function(){
    Ext.QuickTips.init();

    var bd = Ext.getBody();
    var txtCode=new Ext.form.TextField({
		id:'txtCode',
		fieldLabel:'代码',
		anchor:'95%'
	});
    var txtDesc=new Ext.form.TextField({
		id:'txtDesc',
		fieldLabel:'描述',
		anchor:'95%'
	}); 
	var txtMaxinum=new Ext.form.TextField({
		id:'txtMaxinum',
		fieldLabel:'最大记录',
		anchor:'95%'
	});
	
	var Panel1=new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			txtCode
			,txtDesc
			,txtMaxinum
		]
	});
	
	//--------------科室
    var	ctlocStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
    var ctlocStore=new Ext.data.Store({
		proxy:ctlocStoreProxy,
		reader:new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctlocId'
		}, 
		[
			{name: 'ctlocId', mapping: 'ctlocId'},
			{name: 'ctlocDesc', mapping: 'ctlocDesc'},
			{name: 'ctlocCode', mapping: 'ctlocCode'}
		])
	});
	
	var	ctloc=new Ext.form.MultiSelect({
		id:'ctloc',
	    fieldLabel:'科室',
		valueField:'ctlocId',
	    displayField:'ctlocDesc',
	    store:ctlocStore,
	    minChars:1,
	    triggerAction:'all',
	    anchor:'95%',
		//width: 200,
		editable: false,
		mode: 'local',
		allowBlank: false,
		emptyText: '请选择',
		maxHeight:200 //下拉框的最大高度
	});
	
	
	//--------------安全组
	var	groupStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
    var groupStore=new Ext.data.Store({
		proxy:groupStoreProxy,
		reader:new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctlocId'
		}, 
		[
			{name: 'groupId', mapping: 'groupId'},
			{name: 'groupDesc', mapping: 'groupDesc'}
		])
	});
	
	var	group=new Ext.form.MultiSelect({
		id:'group',
	    fieldLabel:'安全组',
		valueField:'groupId',
	    displayField:'groupDesc',
	    store:groupStore,
	    minChars:1,
	    triggerAction:'all',
	    anchor:'95%',
		//width: 200,
		editable: false,
		mode: 'local',
		allowBlank: false,
		emptyText: '请选择',
		maxHeight:200 //下拉框的最大高度
	});
	
	//--------------用户
	var	userStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
    var userStore=new Ext.data.Store({
		proxy:userStoreProxy,
		reader:new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'userId'
		}, 
		[
			{name: 'ctcpId', mapping: 'ctcpId'},
			{name: 'ctcpDesc', mapping: 'ctcpDesc'},
			{name: 'ctcpAlias', mapping: 'ctcpAlias'}
		])
	});
	
	var	user=new Ext.form.MultiSelect({
		id:'user',
	    fieldLabel:'用户',
		valueField:'ctcpId',
	    displayField:'ctcpDesc',
	    store:userStore,
	    minChars:1,
	    triggerAction:'all',
	    anchor:'95%',
		//width: 200,
		editable: false,
		mode: 'local',
		allowBlank: false,
		emptyText: '请选择',
		maxHeight:200 //下拉框的最大高度
	});

	var Panel2=new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .45
		,layout : 'form'
		,items:[
			ctloc
			,group
			,user
		]
	});

	//---------------------是否使用
	var IfUseData=[
		['','']
		,['Y','是']
		,['N','否']
		];
	var IfUseStoreProxy = new Ext.data.MemoryProxy(IfUseData);
	var columnName = new Ext.data.Record.create([
		{ name: "IfUseCode", type: "string" },
		{ name: "IfUseDesc", type: "string" }
		]);
	var reader = new Ext.data.ArrayReader({}, columnName);
	var IfUseStore = new Ext.data.Store({
		proxy: IfUseStoreProxy,
        reader: reader,
		autoLoad: true
		});
	IfUseStore.load();	
	var IfUse=new Ext.form.ComboBox({
		id:'IfUse'
		,store :IfUseStore		
		,minChars : 1
		,displayField:'IfUseDesc'
		,fieldLabel:'是否使用'
		,valueField:'IfUseCode'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	//---------------------类型
	var MsgTypeData=[
		['','']
		,['C','科室']
		,['G','安全组']
		,['U','用户']
		];
	var MsgTypeStoreProxy = new Ext.data.MemoryProxy(MsgTypeData);
	var columnName = new Ext.data.Record.create([
		{ name: "MsgTypeCode", type: "string" },
		{ name: "MsgTypeDesc", type: "string" }
		]);
	var reader = new Ext.data.ArrayReader({}, columnName);
	var MsgTypeStore = new Ext.data.Store({
		proxy: MsgTypeStoreProxy,
        reader: reader,
		autoLoad: true
		});
	MsgTypeStore.load();	
	var MsgType=new Ext.form.ComboBox({
		id:'MsgType'
		,store :MsgTypeStore		
		,minChars : 1
		,displayField:'MsgTypeDesc'
		,fieldLabel:'类型'
		,valueField:'MsgTypeCode'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	var btnInsert=new Ext.Button({
		id:'btnInsert',
		text:'插入',
		handler: function() {
        	btnInsert_click();
    	}
	});
    var btnDelete=new Ext.Button({
		id:'btnDelete',
		text:'删除',
		handler: function() {
        	btnDelete_click();
    	}
	});
	var btnModify=new Ext.Button({
		id:'btnModify',
		text:'修改',
		handler: function() {
        	btnModify_click();
    	}
	});
	var btnFind=new Ext.Button({
		id:'btnFind',
		text:'查找',
		handler: function() {
        	btnFind_click();
    	}
	});
    var pnlButton=new Ext.Panel({
		id:'pnlButton',
		layout:'column',
		buttons:[
			btnInsert,
			btnDelete,
			btnModify,
			btnFind
		]
	});
	
	var Panel3=new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .35
		,layout : 'form'
		,items:[
			IfUse
			,MsgType
			,pnlButton
		]
	});


	var pnlLeft=new Ext.Panel({
		id:'pnlLeft'
		,frame:true
		//buttonAlign:'center',
		//width:350,
		//margin:'0 0 0 10',
        ,title:'维护项'
		,layout:'column'
		,items:[
			Panel1
			,Panel2
			,Panel3
		]
	});
	
	var  myGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	var myGridStore=new Ext.data.Store({
		proxy: myGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'anrcrcId'
		}, 
		[
			{name: 'MsgRowId', mapping: 'MsgRowId'},
			{name: 'MsgCode', mapping: 'MsgCode'},
			{name: 'MsgDesc', mapping: 'MsgDesc'},
			{name: 'MsgRecCtloc', mapping: 'MsgRecCtloc'},
			{name: 'MsgRecCtlocDesc', mapping: 'MsgRecCtlocDesc'},
			{name: 'MsgRecGroup', mapping: 'MsgRecGroup'},
			{name: 'MsgRecGroupDesc', mapping: 'MsgRecGroupDesc'},
			{name: 'MsgRecUser', mapping: 'MsgRecUser'},
			{name: 'MsgRecUserDesc', mapping: 'MsgRecUserDesc'},
			{name: 'MsgMaxinum', mapping: 'MsgMaxinum'},
			{name: 'MsgIfUse', mapping: 'MsgIfUse'},
			{name: 'MsgRecType', mapping: 'MsgRecType'}
		])
	});
	
	var myGrid=new Ext.grid.GridPanel({
		id:'myGrid',
		store:myGridStore,
		autoHeight:true,
		applyTo:myGrid,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}), //设置为单行选中模式
		//clicksToEdit:1,    //单击编辑
		//loadMask:true,
		//region:'center',
		//buttonAlign:'center',
		columns:[
			new Ext.grid.RowNumberer(), 
			{header:'RowId',width:80,dataIndex:'MsgRowId',sortable:true},
			{header:'代码',width:80,dataIndex:'MsgCode',sortable:true},
			{header:'描述',width:80,dataIndex:'MsgDesc',sortable:true},
			{header:'ctlocId',width:80,dataIndex:'MsgRecCtloc',sortable:true},
			{header:'科室',width:100,dataIndex:'MsgRecCtlocDesc',sortable:true},
			{header:'groupId',width:80,dataIndex:'MsgRecGroup',sortable:true},
			{header:'安全组',width:100,dataIndex:'MsgRecGroupDesc',sortable:true},
			{header:'userId',width:80,dataIndex:'MsgRecUser',sortable:true},
			{header:'用户',width:100,dataIndex:'MsgRecUserDesc',sortable:true},
			{header:'最大记录',width:80,dataIndex:'MsgMaxinum',sortable:true},
			{header:'是否使用',width:80,dataIndex:'MsgIfUse',sortable:true},
			{header:'接收类型',width:80,dataIndex:'MsgRecType',sortable:true}
		]
	});
	myGrid.addListener('rowclick',GridRowClick);

	var pnlButtom=new Ext.Panel({
		id:'pnlButtom',
		frame:true,
        title:'手麻消息',
        height:500,        
		//width:650,
		layout:'table',
		items:[
			myGrid
		]
	});

	//data
	ctlocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'FindLocList';
		param.Arg1=ctloc.getRawValue();
		param.Arg2='INOPDEPT^OUTOPDEPT^EMOPDEPT';
		param.Arg3='';
		param.ArgCnt=3;
	});
	ctlocStore.load({});


	groupStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPMessage';
		param.QueryName = 'FindGroup';
		param.ArgCnt=0;
	});
	groupStore.load({});

	userStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'FindCtcp';
		param.Arg1=user.getRawValue();
		param.Arg2='INOPDEPT^OUTOPDEPT^EMOPDEPT^AN^OP^OUTAN^OUTOP^EMAN^EMOP^ICU';
		param.Arg3='';
		param.Arg4='';
		param.Arg5='';
		param.Arg6='';
		param.Arg7='';
		param.ArgCnt=7;
	});
	userStore.load({});

	var pnlRisk=new Ext.Panel({
		id:'pnlRisk',
		frame:true,
        title:'手术消息类型维护',
        //bodyPadding:5,
        //width:1015,
        layout:'form',
        items: [
	        pnlLeft,
	        pnlButtom
        ],
        renderTo: bd		
	});
	
	
	myGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANOPMessage';
			param.QueryName = 'FindMessage';
			param.ArgCnt = 0;
		});
	myGridStore.load({
			params : {
				start:0,
				limit:200
			}
		});  
		
	

	
	//InitViewScreenEvent(obj);
	
	//cmbCtloc.on("select",cmbCtloc_select,obj);
	//cmbCtloc.on("keyup",cmbCtloc_keyup,obj);
	//btnAdd.on("click",btnAdd_click,obj);
    //btnDelete.on("click",btnDelete_click,obj);
    //btnModify.on("click",btnModify_click,obj);
    
    
    //obj.LoadEvent(arguments);
    var _DHCANOPMessage=ExtTool.StaticServerObject('web.DHCANOPMessage');
	var MsgRowId;
	function GridRowClick() 
	{
		var selectObj=myGrid.getSelectionModel().getSelected();
		MsgRowId=selectObj.get('MsgRowId');
		//alert(MsgRowId)
		//MsgRowId,MsgCode,MsgDesc,MsgRecCtloc,MsgRecGroup,MsgRecUser,MsgMaxinum,MsgIfUse,MsgRecType,
		//MsgRecCtlocDesc,MsgRecGroupDesc,MsgRecUserDesc
		var MsgCode=selectObj.get('MsgCode');
		var MsgDesc=selectObj.get('MsgDesc');
		var MsgMaxinum=selectObj.get('MsgMaxinum');
		//var MsgIfUse=selectObj.get('MsgIfUse');
		//var MsgRecType=selectObj.get('MsgIfUse');
		txtCode.setValue(MsgCode);
		txtDesc.setValue(MsgDesc);
		txtMaxinum.setValue(MsgMaxinum);

		
		
		//cmbCtloc.setValue(tCtlocDesc);
		//Ext.getCmp("cmbCtloc").setValue(tCtlocId);
		//alert(cmbCtloc.getValue())
		//alert(Ext.getCmp("cmbCtloc").getValue())
	}
    function btnInsert_click()
	{
		var para=txtCode.getValue()+"^";
		para=para+txtDesc.getValue()+"^";
		para=para+ctloc.getValue()+"^";
		para=para+group.getValue()+"^";
		para=para+user.getValue()+"^";
		para=para+txtMaxinum.getValue()+"^";
		para=para+IfUse.getValue()+"^";
		para=para+MsgType.getValue();

		var ret=_DHCANOPMessage.InsertMessage(para);
		if(ret<0) alert(ret);
		myGridStore.reload();
	}
	function btnDelete_click()
	{
		var selectObj=myGrid.getSelectionModel().getSelected();
		MsgRowId=selectObj.get('MsgRowId');
		var ret=_DHCANOPMessage.DeleteMessage(MsgRowId);
		if(ret!=0) alert(ret);
		myGridStore.reload();
	}
	function btnModify_click()
	{
		var selectObj=myGrid.getSelectionModel().getSelected();
		MsgRowId=selectObj.get('MsgRowId');
		
		var para=txtCode.getValue()+"^";
		para=para+txtDesc.getValue()+"^";
		para=para+ctloc.getValue()+"^";
		para=para+group.getValue()+"^";
		para=para+user.getValue()+"^";
		para=para+txtMaxinum.getValue()+"^";
		para=para+IfUse.getValue()+"^";
		para=para+MsgType.getValue();
		
		var ret=_DHCANOPMessage.UpdateMessage(MsgRowId,para);
		if(ret<0) alert(ret);
		myGridStore.reload(); 
	}
	function btnFind_click()
	{
		myGridStore.removeAll();
		myGridStore.load({
			params : {
				start:0
				,limit:200
			}
		});
	}
    
});
