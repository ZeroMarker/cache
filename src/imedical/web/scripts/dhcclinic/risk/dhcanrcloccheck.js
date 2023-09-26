Ext.onReady(function(){
    Ext.QuickTips.init();
    var bd = Ext.getBody();
    var anrcciDr=""
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
	var	cmbAnrcmc=new Ext.form.MultiSelect({
		id:'cmbAnrcmc',
	    fieldLabel:'管理级别',
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
		emptyText: '请选择',
		maxHeight:500 //下拉框的最大高度
	});
	var cmbCheckItemStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	var cmbCheckItemStore=new Ext.data.Store({
		proxy:cmbCheckItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
		[
			{name: 'CheckItemId', mapping: 'RowId'},
			{name: 'CheckItemCode', mapping: 'Code'},
			{name: 'CheckItemDesc', mapping: 'Desc'}
		])
	});
	var cmbCheckItem=new Ext.form.ComboBox({
		id: 'cmbCheckItem',		
	    fieldLabel:'风险核查项',
		valueField:'CheckItemId',
	    displayField:'CheckItemDesc',
	    store:cmbCheckItemStore,
	    minChars : 1,
	    triggerAction : 'all',	   
	    mode: 'remote',
	    anchor:'95%',
	    listeners:{
		    "select":function(combo,record,index)
		    	{
					cmbCheckItem.setValue(record.data.CheckItemId);
					anrcciDr=record.data.CheckItemId;							    	
	    		}
	    }			   
	});

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
	    fieldLabel: '科室',
		valueField : 'ctlocId',
	    displayField: 'ctlocDesc',
	    store:cmbCtlocStore,
	    minChars : 1,
	    triggerAction : 'all',
	    anchor:'95%'
	});
    var pnlCombo=new Ext.Panel({
		id:'pnlCombo',
		frame:true,
		buttonAlign:'center',
		layout:'form',
		items:[
			cmbAnrcmc,
			cmbCheckItem,
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
			idProperty: 'anrclcRowId'
		}, 
		[
			{name: 'anrclcRowId', mapping: 'anrclcRowId'},
			{name: 'anrcmcDr', mapping: 'anrcmcDr'},
			{name: 'anrcmcDesc', mapping: 'anrcmcDesc'},
			{name: 'anrcciDr', mapping: 'anrcciDr'},
			{name: 'anrcciItem', mapping: 'anrcciItem'},
			{name: 'ctlocDr', mapping: 'ctlocDr'},
			{name: 'ctlocDesc', mapping: 'ctlocDesc'}
		])
	});
	
	var myGrid=new Ext.grid.GridPanel({
		id:'myGrid',
		store:myGridStore,
		autoHeight:true,
		applyTo:myGrid,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}), //设置为单行选中模式
		clicksToEdit:1,    //单击编辑
		loadMask:true,
		region:'center',
		buttonAlign:'center',
		autoScroll:true,
		columns:[
			new Ext.grid.RowNumberer(), 
			{header:'RowId',width:80,dataIndex:'anrclcRowId',sortable:true},
			{header:'管理级别ID',dataIndex:'anrcmcDr',sortable:true},
			{header:'管理级别',width:80,dataIndex:'anrcmcDesc',sortable:true},
			{header:'风险核查项ID',dataIndex:'anrcciDr',sortable:true},
			{header:'风险核查项',width:80,dataIndex:'anrcciItem',sortable:true},
			{header:'科室ID',dataIndex:'ctlocDr',sortable:true},
			{header:'科室',width:350,dataIndex:'ctlocDesc',sortable:true}
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
	cmbAnrcmcStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRCManageClass';
		param.QueryName = 'FindANRCManageClass';
		param.ArgCnt=0;
	});
	cmbAnrcmcStore.load({});
	cmbCheckItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRCCheckItem';
		param.QueryName = 'FindANRCCheckItem';
		param.Arg1=cmbCheckItem.getRawValue();
		param.ArgCnt=1;
	});
	cmbCheckItemStore.load({});
	cmbCtlocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'FindLocList';
		//param.Arg1=cmbAnrcmc.getRawValue();
		param.Arg1=cmbCtloc.getRawValue();
		param.Arg2='INOPDEPT^OUTOPDEPT^EMOPDEPT';
		param.Arg3='';
		param.ArgCnt=3;
	});
	cmbCtlocStore.load({});


	var pnlRisk=new Ext.Panel({
		id:'pnlRisk',
		frame:true,
        title:'手术风险科室核查',
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
			param.ClassName = 'web.DHCANRCLocCheck';
			param.QueryName = 'FindLocCheck';
			param.ArgCnt = 0;
		});
	myGridStore.load({
			params : {
				start:0,
				limit:500
			}
		});  
		
	var DHCANRCLocCheck=ExtTool.StaticServerObject('web.DHCANRCLocCheck');
	function SetEmpty()
	{
		cmbAnrcmc.setValue('');
		cmbCheckItem.setValue('');
		cmbCtloc.setValue('');
	}

    function btnInsert_click()
	{
		//alert(cmbAnrcmc.getValue()+"---"+cmbCheckItem.getValue()+"---"+cmbCtloc.getValue())
		var ret=DHCANRCLocCheck.InsertLocCheck(cmbAnrcmc.getValue(),anrcciDr,cmbCtloc.getValue());
		if(ret!=0) alert(ret);
		myGridStore.reload();
		SetEmpty();
	}
	function btnDelete_click()
	{
		var selectObj=myGrid.getSelectionModel().getSelected();
		if(!selectObj){
			alert("请选择一条数据")
			return;
		}
		var anrclcRowId=selectObj.get('anrclcRowId');
		var ret=DHCANRCLocCheck.DeleteLocCheck(anrclcRowId);
		if(ret!=0) alert(ret);
		myGridStore.reload();
	}
	function btnModify_click()
	{		
		var selectObj=myGrid.getSelectionModel().getSelected();
		if(!selectObj){
			alert("请选择一条数据")
			return;
		}
		var anrclcRowId=selectObj.get('anrclcRowId');	
		//alert(anrclcRowId+"**"+cmbAnrcmc.getValue()+"**"+anrcciDr+"**"+cmbCtloc.getValue())
		var ret=DHCANRCLocCheck.UpdateLocCheck(anrclcRowId,cmbAnrcmc.getValue(),anrcciDr,cmbCtloc.getValue());
		if(ret!=0) {alert(ret);return;}
		else{alert("更新成功")};
		myGridStore.reload(); 
		SetEmpty();
	}    
    myGrid_rowclick=function()
	{
	    var rc = myGrid.getSelectionModel().getSelected();
	    if (rc){		  
	        cmbAnrcmc.setValue(rc.get("anrcmcDr"));
	        cmbCheckItem.setValue(rc.get("anrcciDr"));
	        anrcciDr=rc.get("anrcciDr");
	        cmbCtloc.setValue(rc.get("ctlocDr"));
	  }
	}
	myGrid.on("rowclick", myGrid_rowclick, "");	
	/*cmbCheckItem_select = function()
	{		
		cmbCheckItem.setValue(cmbCheckItem.getValue());		
	}
	/*cmbCheckItem_keyup = function()
	{
		if(cmbCheckItem.getRawValue()=="")
		cmbCheckItem.setValue("");
	}*/	
	//cmbCheckItem.on("select", cmbCheckItem_select,"");
	//cmbCheckItem.on("keyup", cmbCheckItem_keyup, "");
});
