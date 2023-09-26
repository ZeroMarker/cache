function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
//var formPanel="";
addSchemFun = function(dataStore,grid){
	//alert(importType);
	//var userCode = session['LOGON.USERCODE'];
	var sm = new Ext.grid.CheckboxSelectionModel();
	var jxUnitUrl = '../csp/dhc.qm.checkpointmakeexe.csp';
	var jxUnitProxy= new Ext.data.HttpProxy({url:jxUnitUrl + '?action=checkList&schemId='+itemID+'&importType='+importType});
	var jxUnitDs = new Ext.data.Store({
		proxy: jxUnitProxy,
		reader: new Ext.data.JsonReader({root: 'rows',totalProperty: 'results'}, ['groupRowid','groupName']),
		remoteSort: true
	});
	//设置默认排序字段和排序方向
	jxUnitDs.setDefaultSort('groupRowid', 'desc');
	//数据库数据模型
	var jxUnitCm = new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),
		{header:'检查点ID',dataIndex:'groupRowid',width:80,hidden:true},
		{header:'检查点名称',dataIndex:'groupName',width:230}		
	]);
	jxUnitDs.load({params:{start:0,limit:10000}});
	
	var formPanel = new Ext.grid.GridPanel({
		store:jxUnitDs,
		cm:jxUnitCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:sm,
		loadMask: true
	});
			
	var window = new Ext.Window({
  	title: '检查点选择',
    width: 350,
    height:380,
    minWidth: 200,
    minHeight: 100,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存',
		handler: function() {
      		// check form value
      		
			var cname = formPanel.getSelectionModel().getSelections(); 
			var len = cname.length;
			//alert(len);
			var idStr="";
			for(var i=0;i<len;i++){
				jxUnitDr=cname[i].get("groupRowid");
				if(idStr==""){
					idStr=jxUnitDr;
				}else{
					idStr=idStr+","+jxUnitDr
				}
			}
			jxUnitDrStr=idStr;
			window.close();
		
			//alert(jxUnitDrStr);   		
			Cname = jxUnitDrStr.trim();
			//Code = code.trim();
			//Uisstop = uisStop.trim();
      		
        	//var itemID = itemGridDs.data.items[rowIndex].selectedRow.data['rowid'];
			var data = Cname+'^'+itemID;
			//alert (data);
			//if (formPanel.grid.isValid()) {
						Ext.Ajax.request({
							url: projUrl+'?action=addchecker&data='+data,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									personDs.load({params:{start:0,limit:25}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
									if(jsonData.info=='RepKPI') message='重复!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	//}
        	//else{
						//Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					//}
	    	}
    	},
    	{
				text: '取消',
        handler: function(){window.close();}
      }]
    });
	
    window.show();
}