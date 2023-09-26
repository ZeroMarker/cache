(function(){
	Ext.ns("dhcwl.datasource.dsitemCfg");
})();
//*****************************************************该js为数据源明细新增页面*************************************************************
dhcwl.datasource.dsitemCfg=function(winObj){
	var serviceUrl="dhcwl/schema/metacfg.csp?";
	var parentObj=winObj;
	var winOfThis=this;
	var jspURL="dhcwl/measuredimrole/datasource.csp?";
	var parentIs=null;
	var dsData=null;
	var dsParam=""		
	
	
	var sourceFieldSm = new Ext.grid.CheckboxSelectionModel();	
	var itemSm = new Ext.grid.CheckboxSelectionModel();		
	
    var sourceFieldRec = Ext.data.Record.create([
	{
        name: 'sqlfieldName',
        type: 'string'
    }, {
        name: 'type',
        type: 'string'
	}]);

	var itemRec = Ext.data.Record.create([
		{
			name: 'itemName',
			type: 'string'
		}, {
			name: 'itemDesc',
			type: 'string'
		}, {
			name: 'itemType',
			type: 'string'
		}, {
			name: 'dataType',
			type: 'string'
		}, {
			name: 'linkedSHMURI',
			type: 'string'
		},{
			name: 'directVal',
			type: 'string'
		},{
			name: 'expVal',
			type: 'string'
		},{
			name: 'sourceField',
			type: 'string'
		}, {
			name: 'sourceDataType',
			type: 'string'
		}]);

    var sourceFieldStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:jspURL}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name: 'type'},
				{name:'sqlfieldName'}
       		]
    	})
    });
	
    var sourceFieldGrid = new Ext.grid.GridPanel({
		title:'源表字段',
        store: sourceFieldStore,
        sm: sourceFieldSm,
        columns: [
			sourceFieldSm,        
			{header:'字段名',dataIndex:'sqlfieldName',sortable:true, width: 260, sortable: true,menuDisabled : true,id:'sqlfieldName'},
			{header:'字段类型',dataIndex:'type',sortable:true, width: 160, sortable: true,menuDisabled : true}
		],
		autoExpandColumn: 'sqlfieldName'
	})
	
    var itemStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:jspURL+'action=mulSearch'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'itemName'},
				{name: 'itemDesc'},
				{name: 'itemType'},
				{name:'dataType'},
				{name: 'linkedSHMURI'},
				{name: 'directVal'},
				{name: 'expVal'},				
				{name: 'sourceField'},
				{name: 'sourceDataType'}		
       		]
    	})
    });
	
	var comboDatatype=	new Ext.form.ComboBox({       
			allowBlank:false,
			width:150,
			mode:           'local',
			triggerAction:  'all',
			forceSelection: true,
			editable:       false,
			displayField:   'name',
			valueField:     'value',
			store:          new Ext.data.JsonStore({
				fields : ['name', 'value'],
				data   : [
					{name : 'INT',   value: 'INT'},
					{name : 'LONG',  value: 'LONG'},
					{name : 'DATE',   value: 'DATE'},
					{name : 'DOUBLE',  value: 'DOUBLE'},
					{name : 'STRING',   value: 'STRING'}					
					]
			})			
		})	

	var itemGrid = new Ext.grid.EditorGridPanel({
		title:'数据项',
        store: itemStore,
        sm: itemSm,
        columns: [
			itemSm, 		
			{header:'统计项名称',dataIndex:'itemName', width: 260,menuDisabled : true},
			{header:'统计项描述',dataIndex:'itemDesc',width: 130, editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))},
			{header:'统计项类型',dataIndex:'itemType',sortable:true, width: 80, sortable: true,menuDisabled : true},
			{header:'数据类型',dataIndex:'dataType',sortable:true, width: 150, sortable: true,menuDisabled : true,id:'dataType'},
			{header: '表达式取值',dataIndex: 'expVal',width: 130},
			{header:'源字段名',dataIndex:'sourceField',sortable:true, width: 130, sortable: true,menuDisabled : true,hidden:true}
		]/*,
		autoExpandColumn: 'dataType'*/,
		tbar: [{
            text: '自定义数据项',
            handler: onAddCustomItem
        }]
	});	
	
     var actform = new Ext.FormPanel({
     	width:70,
     	height:500,
		layout: {
		    type:'vbox',
		    padding:'5',
		    pack:'center',
		    align:'center'
		},
		defaults:{margins:'0 0 5 0'},
		items:[{
		    xtype:'button',
		  	text: '>口径',
		  	width:50,
		  	handler:onBtnClick
		},{
		    xtype:'button',
		  	text: '>度量',
		  	width:50,
		  	handler:onBtnClick
		},{
		    xtype:'button',
		    text: '<',
		  	width:50,
		  	handler:onBtnClick
		}]

    });	
	
	itemGrid.on('contextmenu',function( e ){
			e.preventDefault();
	});
	
    var itemCfgWin =new Ext.Window({
        width:1070,
		height:530,
		resizable:false,
		closable : false,
		buttonAlign:'center',
		//closeAction:'close',			//不提供窗口右上角的“关闭”按钮
		//id:'itemCfgWin',
    	title:'数据项选择----选择源表字段作为数据项或者直接新增空数据项',
    	layout:"table",
        layoutConfig:{columns:3},
        items: 
		[{
			
			layout:'fit',
			width:450,
			height:460,			
			items: sourceFieldGrid
		},{
			id:'itemActform',
			layout:'fit',
			width:70,
			height:460,	
			items: actform
		},{
			id:'itemitemGrid',
			layout:'fit',
			width:540,
			height:460,				
			items: itemGrid
		}],
        buttons: [
			{
				text: '<span style="line-Height:1">关闭</span>',
				icon   : '../images/uiimages/cancel.png',
				handler: OnCancel
			},{
				text: '<span style="line-Height:1">保存</span>',				
				icon   : '../images/uiimages/filesave.png',
				handler: OnNextSetp
			}
		]

    });
	sourceFieldStore.on('load', function(store,recs,options){
		if (!!itemCfgWin) {	
			itemCfgWin.body.unmask();
		}
	});


	
	function onBtnClick(btn){
   		
		partCalExp=btn.getText();

		if(partCalExp==">口径"){
			
			var selRecs=sourceFieldGrid.getSelectionModel().getSelections();
			if (!selRecs) {
				Ext.Msg.alert("提示","请选择源表字段");
				return;
			} 
			
			
			for(var i=0;i<=selRecs.length-1;i++){
				var rec=selRecs[i];
				var strDataType=sourceType2ItemType(rec.get('type'));
				
				var addedRec = new itemRec({
					itemName: rec.get('sqlfieldName'),
					itemDesc:'',
					itemType: '口径',
					dataType: strDataType,
					sourceField: rec.get('sqlfieldName'),
					sourceDataType:	rec.get('type')
				})
				
				sourceFieldGrid.getStore().remove(rec);
				itemGrid.getStore().add(addedRec);			
			}
		}else if(partCalExp==">度量"){
			var selRecs=sourceFieldGrid.getSelectionModel().getSelections();
			if (!selRecs) {
				Ext.Msg.alert("提示","请选择源表字段");
				return;
			} 
			
			
			for(var i=0;i<=selRecs.length-1;i++){
				var rec=selRecs[i];
				var strDataType=sourceType2ItemType(rec.get('type'));
				var addedRec = new itemRec({
					itemName: rec.get('sqlfieldName'),
					itemDesc:'',
					itemType: '度量',
					dataType: strDataType,
					sourceField: rec.get('sqlfieldName'),
					sourceDataType:	rec.get('type')
				})
				
				sourceFieldGrid.getStore().remove(rec);
				itemGrid.getStore().add(addedRec);			
			}
		}else if(partCalExp=="<"){
			var selRecs=itemGrid.getSelectionModel().getSelections();
			if (!selRecs) {
				Ext.Msg.alert("提示","请选择数据项");
				return;
			} 
			
			for(var i=0;i<=selRecs.length-1;i++){
				var rec=selRecs[i];
				if (!rec.get('expVal')){
					var moveLeftRec = new sourceFieldRec({
						sqlfieldName:rec.get('sourceField'),
						type:rec.get('sourceDataType')
					})
					sourceFieldGrid.getStore().add(moveLeftRec);
				}
				itemGrid.getStore().remove(rec);			
			}			
		}
    }    

	function CloseWins() {
		itemCfgWin.destroy();
		itemCfgWin.close();
		
	}
	
	function OnCancel() {
		CloseWins();
	}
	
	function onAddCustomItem() {
		//var newRec=new itemRec();
		//itemGrid.getStore().add(newRec);
		modifyWin=new dhcwl.ds.modify(winOfThis);
		modifyWin.show();
	}
	
	function sourceType2ItemType(sourceType){
		var retType=sourceType
		return retType;
	}
	//新建模型时调用
	this.show=function(dsPar) {
		dsParam=dsPar;
		itemCfgWin.show();
		sourceFieldStore.proxy.setUrl(encodeURI(jspURL+"action=getTablePro&tableName="+dsParam));
	    sourceFieldStore.load();
	}
	
	//
	this.setDSCfg=function(dataSourceData) {
		dsData=dataSourceData;
	}
	
	
	//右键新建数据项时使用
	this.showCfgInfo=function(nodeID){
	}
	
	function OnNextSetp() {
		
		var recCnt=itemGrid.getStore().getCount();
		if (recCnt<=0) {
			Ext.Msg.alert("提示","先将源字段映射成数据项再点击完成");
			return;
		} 
		if (!dsParam) {
			Ext.Msg.alert("提示","获取数据源信息失败");
			return;
		}
		var aryItemName=[];
		var aryItemDesc=[];
		var aryItemType=[];
		var aryItemDataType=[];
		var aryItemexpValue=[];
		
		for(var i=0;i<=recCnt-1;i++){
			rec=itemGrid.getStore().getAt(i);
			if(rec.get("itemName")=="" || rec.get("itemType")=="" || rec.get("dataType")=="" || rec.get("itemDesc")=="") {
				Ext.Msg.alert("提示","描述、名称、统计项类型以及数据类型不能为空！");
				return;
			}
			aryItemName.push(rec.get("itemName"));
			aryItemDesc.push(rec.get("itemDesc"));
			aryItemType.push(rec.get("itemType"));
			aryItemDataType.push(rec.get("dataType"));
			aryItemexpValue.push(rec.get("expVal"));
		}
		
		var strItemName=aryItemName.toString();
		var strItemDesc=aryItemDesc.toString();
		var strItemType=aryItemType.toString();
		var strItemDataType=aryItemDataType.toString();
		var strValue=aryItemexpValue.toString();
		
		
		dhcwl.mkpi.Util.ajaxExc(jspURL,
		{
			action:"addDSourceItem",
			dsID       :dsParam,
			strItemName:strItemName,
			strItemDesc:strItemDesc,
			strItemType:strItemType,
			strItemDataType:strItemDataType,
			strValue:strValue
		},
		function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				Ext.Msg.alert("提示","操作成功！");
				parentIs.refresh();
				CloseWins();
				
			}else{
				Ext.Msg.alert("提示",jsonData.tip);
				CloseWins();
				}
			},this);

	}
	
	this.updateItem=function(rec){
		var newRec=new itemRec({
			itemName:rec.name,
			itemDesc:rec.descript,
			itemType:rec.type,
			dataType:rec.dataType,
			expVal:rec.expVal,
			sourceField: rec.name,
			sourceDataType:rec.dataType
		});
		/*newRec.set('itemName',rec.name);
		newRec.set('itemDesc',rec.descript);
		newRec.set('itemType',rec.type);
		newRec.set('dataType',rec.dataType);
		newRec.set('expVal',rec.expVal);*/
		itemGrid.getStore().add(newRec);
	}
	
	this.getWin=function(){
		return itemCfgWin;
	}
	this.setParentAct=function(parentAct){
		parentIs=parentAct;
	}	
}