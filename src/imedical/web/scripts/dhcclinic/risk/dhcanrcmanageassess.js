Ext.onReady(function(){
    Ext.QuickTips.init();
    var bd = Ext.getBody();
    var AnrcmcDr=""
    //----------------------�������ռ���--------------------------

	
	
	var cmbRiskClassStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	var cmbRiskClassStore=new Ext.data.Store({
		proxy:cmbRiskClassStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'anrcrcId'
		}, 
		[
			{name: 'anrcrcId', mapping: 'anrcrcId'},
			{name: 'RiskClassDesc', mapping: 'tDesc'}
		])
	});	
	var cmbRiskClass=new Ext.form.ComboBox({
		id: 'cmbRiskClass',
	    fieldLabel:'�������ռ���',
		valueField:'anrcrcId',
	    displayField:'RiskClassDesc',
	    store:cmbRiskClassStore,
	    minChars : 1,
	    triggerAction : 'all',
	    anchor:'95%'
	});


    //----------------------��������--------------------------
	//Booked,Restricted,Emergency
	var cmbTypeData=[
		['B','����']
		,['R','����']
		,['E','����']
		];
	var cmbOPTypeStoreProxy = new Ext.data.MemoryProxy(cmbTypeData);
	var columnName = new Ext.data.Record.create([
		{ name: "OPTypeCode", type: "string" },
		{ name: "OPTypeDesc", type: "string" }
		]);
	var reader = new Ext.data.ArrayReader({}, columnName);
	var cmbOPTypeStore = new Ext.data.Store({
		proxy: cmbOPTypeStoreProxy,
        reader: reader,
		autoLoad: true
		});
	cmbOPTypeStore.load();	
	var cmbOPType=new Ext.form.ComboBox({
		id:'cmbOPType'
		,store :cmbOPTypeStore		
		,minChars : 1
		,displayField:'OPTypeDesc'
		,fieldLabel:'��������'
		,valueField:'OPTypeCode'
		,triggerAction : 'all'
		,anchor : '95%'
	});

    //----------------------������--------------------------
    var	cmbAnrcmcStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
    var cmbAnrcmcStore=new Ext.data.Store({
		proxy:cmbAnrcmcStoreProxy,
		reader:new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
		[
			{name: 'AnrcmcId', mapping: 'RowId'},
			{name: 'AnrcmcCode', mapping: 'Code'},
			{name: 'AnrcmcDesc', mapping: 'Desc'}
			//,{name: 'CtlocId', mapping: 'CtlocDr'},
			//{name: 'CtlocDesc', mapping: 'Ctloc'}
		])
	});
	/*var	cmbAnrcmc=new Ext.form.MultiSelect({
		
		id:'cmbAnrcmc',
	    fieldLabel:'������',
		valueField:'AnrcmcId',
	    displayField:'AnrcmcDesc',
	    store:cmbAnrcmcStore,
	    minChars:1,
	    triggerAction:'all',
	    anchor:'95%',
		//width: 200,
		editable: false,
		mode: 'local',
		allowBlank: false,
		emptyText: '��ѡ��',
		maxHeight:200, //����������߶�
		listeners:{
		    "select":function(combo,record,index)
		    	{
					cmbAnrcmc.setValue(record.data.AnrcmcId);
					AnrcmcDr=record.data.AnrcmcId;							    	
	    		}
	    }
	});*/
	var cmbAnrcmc=new Ext.form.ComboBox({
		id:'cmbAnrcmc'
		,store :cmbAnrcmcStore		
		,minChars : 1
		,displayField:'AnrcmcDesc'
		,fieldLabel:'��������'
		,valueField:'AnrcmcId'
		,triggerAction : 'all'
		,anchor : '95%'
		,emptyText: '��ѡ��',
		maxHeight:200, //����������߶�
		listeners:{
		    "select":function(combo,record,index)
		    	{
					cmbAnrcmc.setValue(record.data.AnrcmcId);
					AnrcmcDr=record.data.AnrcmcId;							    	
	    		}
	    }
	});

    //----------------------����--------------------------
	var cmbCtlocStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	var cmbCtlocStore=new Ext.data.Store({
		proxy:cmbCtlocStoreProxy,
		reader: new Ext.data.JsonReader({
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
	var cmbCtloc=new Ext.form.ComboBox({
		id: 'cmbCtloc',
	    fieldLabel: '����',
		valueField : 'ctlocId',
	    displayField: 'ctlocDesc',
	    store:cmbCtlocStore,
	    minChars : 1,
	    triggerAction : 'all',
	    anchor:'95%'
	});
	
	 var txtMaxAge=new Ext.form.TextField({
		id:'txtMaxAge',
		fieldLabel:'�������',
		anchor:'95%'
	});
	
	
    var pnlCombo=new Ext.Panel({
		id:'pnlCombo',
		frame:true,
		buttonAlign:'center',
		layout:'form',
		items:[
			cmbRiskClass,
			cmbOPType,
			cmbAnrcmc,
			cmbCtloc,
			txtMaxAge
		]
	});
	var btnInsert=new Ext.Button({
		id:'btnInsert',
		text:'����',
		handler: function() {
        	btnInsert_click();
    	}
	});
    var btnDelete=new Ext.Button({
		id:'btnDelete',
		text:'ɾ��',
		handler: function() {
        	btnDelete_click();
    	}
	});
	var btnModify=new Ext.Button({
		id:'btnModify',
		text:'�޸�',
		handler: function() {
        	btnModify_click();
    	}
	});
    var pnlButton=new Ext.Panel({
		id:'pnlButton',
		//layout:'column',
		buttons:[
			btnInsert,
			btnDelete,
			btnModify
		]
	});
	var pnlLeft=new Ext.Panel({
		id:'pnlLeft',
		frame:true,
		//buttonAlign:'center',
		width:350,
		//margin:'0 0 0 10',
		layout:'form',
		items:[
			pnlCombo,
			pnlButton
		]
	});
	
		
	var myGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	var myGridStore=new Ext.data.Store({
		proxy: myGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'anrcmaRowId'
		}, 
		[
			{name: 'anrcmaRowId', mapping: 'anrcmaRowId'},
			{name: 'anrcrcId', mapping: 'anrcrcId'},
			{name: 'anrcrcDesc', mapping: 'anrcrcDesc'},
			{name: 'opType', mapping: 'opType'},
			{name: 'opTypeDesc', mapping: 'opTypeDesc'},
			{name: 'anrcmcId', mapping: 'anrcmcId'},
			{name: 'anrcmcDesc', mapping: 'anrcmcDesc'},
			{name: 'ctlocId', mapping: 'ctlocId'},
			{name: 'ctlocDesc', mapping: 'ctlocDesc'},
			{name: 'maxAge', mapping: 'maxAge'}
		])
	});
	var myGrid=new Ext.grid.GridPanel({
		id:'myGrid',
		store:myGridStore,
		autoHeight:true,
		applyTo:myGrid,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}), //����Ϊ����ѡ��ģʽ
		//clicksToEdit:1,    //�����༭
		//loadMask:true,
		//region:'center',
		//buttonAlign:'center',
		columns:[
			new Ext.grid.RowNumberer(), 
			{header:'RowId',width:80,dataIndex:'anrcmaRowId',sortable:true},
			{header:'���ռ���',width:100,dataIndex:'anrcrcDesc',sortable:true},
			{header:'��������',width:100,dataIndex:'opTypeDesc',sortable:true},
			{header:'���չ�����',width:100,dataIndex:'anrcmcDesc',sortable:true},
			{header:'����',width:200,dataIndex:'ctlocDesc',sortable:true},
			{header:'�������',width:100,dataIndex:'maxAge',sortable:true}
		]
	});
	var pnlRight=new Ext.Panel({
		id:'pnlRight',
		frame:true,
        height:500,        
		width:700,
		autoScroll:true,
		layout:'table',
		items:[
			myGrid
		]
	});

	//data
	cmbRiskClassStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRCRiskCLass';
		param.QueryName = 'FindRiskClass';
		param.Arg1=cmbRiskClass.getRawValue();
		param.Arg2='';
		param.Arg3='';
		param.ArgCnt=3;	});
	cmbRiskClassStore.load({});
	
	cmbAnrcmcStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRCManageClass';
		param.QueryName = 'FindANRCManageClass';
		param.ArgCnt=0;
	});
	cmbAnrcmcStore.load({});

	cmbCtlocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'FindLocList';
		param.Arg1=cmbCtloc.getRawValue();
		param.Arg2='INOPDEPT^OUTOPDEPT^EMOPDEPT';
		param.Arg3='';
		param.ArgCnt=3;
	});
	cmbCtlocStore.load({});


	var pnlRisk=new Ext.Panel({
		id:'pnlRisk',
		frame:true,
        title:'�������չ���ּ�',
        //bodyPadding:5,
        width:1100,
        layout:'column',
        items: [
	        pnlLeft,
	        pnlRight
        ],
        renderTo: bd		
	});
	
	myGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANRCManageAssess';
			param.QueryName = 'FindManageAssess';
			param.ArgCnt = 0;
		});
	myGridStore.load({
			params : {
				start:0,
				limit:200
			}
		});  
		
	var DHCANRCManageAssess=ExtTool.StaticServerObject('web.DHCANRCManageAssess');
	function SetEmpty()
	{
		cmbRiskClass.setValue('');
		cmbOPType.setValue('');
		cmbAnrcmc.setValue('');
		cmbCtloc.setValue('');
		txtMaxAge.setValue('');
	}

    function btnInsert_click()
	{
		//alert(cmbAnrcmc.getValue()+"---"+cmbCheckItem.getValue()+"---"+cmbCtloc.getValue()+"---"+cmbCtloc.getValue()+"---"+txtMaxAge.getValue())
		var ret=DHCANRCManageAssess.InsertManageAssess(cmbRiskClass.getValue(),cmbOPType.getValue(),AnrcmcDr,cmbCtloc.getValue(),txtMaxAge.getValue());
		if(ret!=0) alert(ret)
		else alert("����ɹ�");
		myGridStore.reload();
		SetEmpty();
	}
	function btnDelete_click()
	{
		var selectObj=myGrid.getSelectionModel().getSelected();
		var anrcmaRowId=selectObj.get('anrcmaRowId');
		var ret=DHCANRCManageAssess.DeleteManageAssess(anrcmaRowId);
		if(ret!=0) alert(ret)
		else alert("ɾ���ɹ�");
		myGridStore.reload();
		SetEmpty();
	}
	function btnModify_click()
	{
		var selectObj=myGrid.getSelectionModel().getSelected();
		var anrcmaRowId=selectObj.get('anrcmaRowId');
		var ret=DHCANRCManageAssess.UpdateManageAssess(anrcmaRowId,cmbRiskClass.getValue(),cmbOPType.getValue(),AnrcmcDr,cmbCtloc.getValue(),txtMaxAge.getValue());
		if(ret!=0) alert(ret);
		myGridStore.reload(); 
		SetEmpty();
	}
	myGrid_rowclick=function()
	{
	    var rc = myGrid.getSelectionModel().getSelected();
	    if (rc){		  
	        cmbRiskClass.setValue(rc.get("anrcrcId"));
	        cmbOPType.setValue(rc.get("opType"));
	        cmbAnrcmc.setValue(rc.get("anrcmcId"));
	        AnrcmcDr=rc.get("anrcmcId");
	        cmbCtloc.setValue(rc.get("ctlocId"));
	        txtMaxAge.setValue(rc.get("maxAge"));	           
	  }
	}
	myGrid.on("rowclick", myGrid_rowclick, "");
});
