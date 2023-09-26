(function(){
	Ext.ns("dhcwl.schema.metaCfg");
})();

dhcwl.schema.metaCfg.selField=function(winObj){
	var serviceUrl="dhcwl/schema/metacfg.csp?";
	var parentObj=winObj;
	var winOfThis=this;
	var frameObj=null;
	var sourceTabName=null;
	var dsUrl=null;
	var jspURL="http://localhost:8080/schema-web/jsp/schemametacfg.jsp?";
	var treeNodeID=null;
	var parentIs=null;
	var dsAttrib=null;
	//var servJerseyUrl=RESTServCfg.getJerseyUrl();
	//var timeout=RESTServCfg.getTimeout();	
	var itemSm = new Ext.grid.CheckboxSelectionModel();		
    var sourceFieldRec = Ext.data.Record.create([
	{
        name: 'sqlfieldName',
        type: 'string'
    }, {
        name: 'type',
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
        columns: [       
			{header:'字段名',dataIndex:'sqlfieldName',sortable:true, width: 160, sortable: true,menuDisabled : true,id:'sqlfieldName'},
			{header:'字段类型',dataIndex:'type',sortable:true, width: 160, sortable: true,menuDisabled : true}
		],
		autoExpandColumn: 'sqlfieldName'
	})
	

	
    var selFieldWin =new Ext.Window({
        width:970,
		height:530,
		resizable:false,
		closeAction:'close',
		id:'selFieldWin',
        items:{
			
			layout:'fit',
			width:350,
			height:460,			
			items: sourceFieldGrid
		},
        buttons: [
			{
				text: '完成',
				handler: OnNextSetp
			},{

				text: '取消',
				handler: OnCancel
			}
		]

    });		

	selFieldWin.on('close', function(t){}
	); 	

	sourceFieldStore.on('load', function(store,recs,options){
		selFieldWin.body.unmask();
	});
		
	
	function OnCancel() {
		winOfThis.getWin().close();
	}

	function sourceType2ItemType(sourceType){
		var retType=""
		if (sourceType=="Int_32") retType="INT";
		else if (sourceType=="Int_64") retType="LONG";
		else if (sourceType=="Date") retType="DATE";
		else if (sourceType=="Double") retType="DOUBLE";
		else if (sourceType=="String") retType="STRING";
		return retType;
	}
	function OnNextSetp() {
		var selRecs=sourceFieldGrid.getSelectionModel().getSelections();
		if (selRecs.length!=1) {
			Ext.Msg.alert("提示","请选择一个源表字段");
			return;
		} 				
		
		//parentObj.setSourceF(selRecs[0].get("sqlfieldName"));
		var sourceFParam={
			sourceField:selRecs[0].get("sqlfieldName"),
			dataType:sourceType2ItemType(selRecs[0].get("type"))
		}
		parentObj.setSourceF(sourceFParam);
		winOfThis.getWin().close();
		return;
	}
			
	function onAddCustomItem() {
		var newRec=new itemRec();
		itemGrid.getStore().add(newRec);
	}

	this.setTreeNodeID=function(nodeID){
		treeNodeID=nodeID;
	}
	
	this.setSourceTabName=function(sqlName){
		sourceTabName=sqlName;
	}
	//修改数据项时，选择源表字段用
	this.show=function(){
		if (treeNodeID) {
			
			var params={
				treeNodeID:treeNodeID
			};			
			sourceFieldStore.proxy=new Ext.data.ScriptTagProxy({
				method: 'GET',
				url: servJerseyUrl+"/web/getUnSelSchemaItem",
				timeout:timeout
			});
			sourceFieldStore.load({params:{params:$.toJSON(params)}});			
			//sourceFieldStore.proxy.setUrl(encodeURI(jspURL+"action=searchSourceFieldConfiged"+"&treeNodeID="+treeNodeID));
		}
		if (!!dsAttrib) {
			/*
			var params={
				format:dsAttrib["format"],
				url:dsAttrib["datasourceURL"],
				user:dsAttrib["userID"],
				password:dsAttrib["passWord"],
				driver:dsAttrib["driver"],
				table:dsAttrib["table"]
			};		
			*/
			
			/*
			var params={
				format:dsAttrib["format"]
			};
			
			if (dsAttrib["format"]=="jdbc") {
				params.url=dsAttrib["datasourceURL"];
				params.user=dsAttrib["userID"];
				params.password=dsAttrib["passWord"];
				params.driver=dsAttrib["driver"];
				params.table=dsAttrib["table"];
			}else if (dsAttrib["format"]=="json") {
				params.path=dsAttrib["path"];
			}	
			*/

			
			
			
			sourceFieldStore.proxy=new Ext.data.ScriptTagProxy({
				method: 'GET',
				url: servJerseyUrl+"/web/getFieldsMeta",
				timeout:timeout
			});
			sourceFieldStore.load({params:{dsConfig:$.toJSON(dsAttrib)}});		
		}
		//sourceFieldStore.load();	
		
		selFieldWin.setWidth(360);
		selFieldWin.show();
		//selFieldWin.body.mask("正在读取数据，请稍候！");
	}
	
	this.getWin=function(){
		return selFieldWin;
	}
	this.setDsParam=function(dsParams) {
		dsAttrib=dsParams;
	}
}