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
	var ctlocStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	var ctlocStore=new Ext.data.Store({
		proxy: ctlocStoreProxy,
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
	    fieldLabel: '科室',
		valueField : 'ctlocId',
	    displayField: 'ctlocDesc',
	    store: ctlocStore,
	    minChars : 1,
	    triggerAction : 'all',
	    anchor : '95%'
	});

    var pnlCDC=new Ext.Panel({
		id:'pnlCDC',
		frame:true,
		buttonAlign:'center',
		layout:'form',
		items:[
			txtCode,
			txtDesc,
			//txtCtloc
			cmbCtloc
		]
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
    var pnlADM=new Ext.Panel({
		id:'pADM',
		layout:'column',
		buttons:[
			btnInsert,
			btnDelete,
			btnModify,
			btnFind
		]
	});
	var pnlLeft=new Ext.Panel({
		id:'pnlLeft',
		frame:true,
		//buttonAlign:'center',
		width:350,
		//margin:'0 0 0 10',
        title:'维护项',
		layout:'form',
		items:[
			pnlCDC,
			pnlADM
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
			{name: 'anrcrcId', mapping: 'anrcrcId'},
			{name: 'tCode', mapping: 'tCode'},
			{name: 'tDesc', mapping: 'tDesc'},
			{name: 'tCtlocId', mapping: 'tCtlocId'},
			{name: 'tCtlocDesc', mapping: 'tCtlocDesc'}
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
			{header:'RowId',width:80,dataIndex:'anrcrcId',sortable:true},
			{header:'代码',width:80,dataIndex:'tCode',sortable:true},
			{header:'描述',width:80,dataIndex:'tDesc',sortable:true},
			{header:'科室ID',dataIndex:'tCtlocId',sortable:true},
			{header:'科室',width:350,dataIndex:'tCtlocDesc',sortable:true}
		]
	});
	myGrid.addListener('rowclick',GridRowClick);

	var pnlRight=new Ext.Panel({
		id:'pnlRight',
		frame:true,
        title:'手术风险等级',
        height:500,        
		width:650,
		layout:'table',
		items:[
			myGrid
		]
	});

	//data
	ctlocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'FindLocList';
		param.Arg1=cmbCtloc.getRawValue();
		param.Arg2='INOPDEPT^OUTOPDEPT^EMOPDEPT';
		param.Arg3='';
		param.ArgCnt=3;
	});
	ctlocStore.load({});


	var pnlRisk=new Ext.Panel({
		id:'pnlRisk',
		frame:true,
        title:'手术风险等级维护',
        //bodyPadding:5,
        width:1015,
        layout:'column',
        items: [
	        pnlLeft,
	        pnlRight
        ],
        renderTo: bd		
	});
	
	
	myGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANRCRiskCLass';
			param.QueryName = 'FindRiskClass';
			param.Arg1 = txtDesc.getValue();
			param.Arg2 = txtCode.getValue();
			param.Arg3 = cmbCtloc.getValue();
			param.ArgCnt = 3;
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
    var _DHCANRCRiskCLass=ExtTool.StaticServerObject('web.DHCANRCRiskCLass');
	var anrcrcId;
	function GridRowClick() 
	{
		var selectObj=myGrid.getSelectionModel().getSelected();
		anrcrcId=selectObj.get('anrcrcId');
		var tCode=selectObj.get('tCode');
		var tDesc=selectObj.get('tDesc');
		var tCtlocDesc=selectObj.get('tCtlocDesc');
		var tCtlocId=selectObj.get('tCtlocId');
		txtCode.setValue(tCode);
		txtDesc.setValue(tDesc);
		cmbCtloc.setValue(tCtlocDesc);
		Ext.getCmp("cmbCtloc").setValue(tCtlocId);
		//alert(cmbCtloc.getValue())
		//alert(Ext.getCmp("cmbCtloc").getValue())
	}
    function btnInsert_click()
	{
		var ret=_DHCANRCRiskCLass.InsertRiskClass(txtCode.getValue(),txtDesc.getValue(),cmbCtloc.getValue());
		if(ret!=0) alert(ret);
		myGridStore.reload();
	}
	function btnDelete_click()
	{
		var selectObj=myGrid.getSelectionModel().getSelected();
		anrcrcId=selectObj.get('anrcrcId');
		var ret=_DHCANRCRiskCLass.DeleteRiskClass(anrcrcId);
		if(ret!=0) alert(ret);
		myGridStore.reload();
	}
	function btnModify_click()
	{
		var selectObj=myGrid.getSelectionModel().getSelected();
		anrcrcId=selectObj.get('anrcrcId');
		var ret=_DHCANRCRiskCLass.UpdateRiskClass(anrcrcId,txtCode.getValue(),txtDesc.getValue(),cmbCtloc.getValue());
		if(ret!=0) alert(ret);
		myGridStore.reload(); 
	}
	function btnFind_click()
	{
		myGridStore.removeAll();
		myGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANRCRiskCLass';
			param.QueryName = 'FindRiskClass';
			param.Arg1 = txtDesc.getValue();
			param.Arg2 = txtCode.getValue();
			param.Arg3 = cmbCtloc.getValue();
			param.ArgCnt = 3;
		});
		myGridStore.load({
			params : {
				start:0
				,limit:200
			}
		});
	}
    
});


	/*
    var myData = [
        ['3m Co',                               "AAA", "A",  1],
        ['Alcoa Inc',                           "BBB", "B",  2],
        ['Altria Group Inc',                    "CCC", "C",  3],
        ['American Express Company',            "DDD", "D",  4],
        ['American International Group, Inc.',  "EEE", "E",  5],
        ['Boeing Co.',                          "FFF", "F",  6],
        ['Caterpillar Inc.',                    "GGG", "G",  7]
    ];

    var ds = Ext.create('Ext.data.ArrayStore', {
        fields: [
            {name: '描述'},
            {name: '代码'},
            {name: '科室'},
            {name: '科室ID',type: 'int'}
        ],
        data: myData
    });
    
    
    
    obj.ctloc = new Ext.form.ComboBox({
		id : 'ctloc'
		//,store : obj.ctlocStore
		,minChars : 1
		,displayField : 'ctloc'
		,fieldLabel : '科室'
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
    
    */
/*
	var comCtloc = new Ext.form.ComboBox({
		id: 'ctloc',
	    fieldLabel: '科室',
	    displayField: 'ctloc',
	    //store: ctlocStore,
	    queryMode: 'local',
	    typeAhead: true,
	    minChars : 1,
	    triggerAction : 'all',
	    anchor : '95%'
	});
	
	var ctlocStore= new Ext.data.Store({
		proxy: ctlocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctlocId'
		}, 
		[
			{name: 'ctlocId', mapping : 'ctlocId'}
			,{name: 'ctloc', mapping: 'ctloc'}
		])
	});
	var ctlocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	ctlocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'FindLocList';
		param.Arg1= comCtloc.getRawValue();
		param.Arg2 = 'INOPDEPT^OUTOPDEPT^EMOPDEPT';
		param.ArgCnt = 2;
	});
	ctlocStore.load({});
   	
    
    var gridForm = Ext.create('Ext.form.Panel', {
        id: 'risk-form',
        frame: true,
        title: '手术风险等级维护',
        bodyPadding: 5,
        width: 750,
        layout: 'column',
        fieldDefaults: {
            labelAlign: 'left',
            msgTarget: 'side'
        },
        items: [{
            columnWidth: 0.60,
            xtype: 'gridpanel',
            //store: ds,
            height: 500,
            title:'手术风险等级',
            columns: [
            ],

            listeners: {
                selectionchange: function(model, records) {
                    if (records[0]) {
                        this.up('form').getForm().loadRecord(records[0]);
                    }
                }
            }
        }, {
            columnWidth: 0.4,
            xtype: 'panel',
            margin: '0 0 0 10',
            title:'维护项',
            items: [
	            pnlCDC,
	            pnlADM
		     ]
        }],
        renderTo: bd
    });

		*/
    //gridForm.child('gridpanel').getSelectionModel().select(0);
    
