detaileditFun = function(detailGrid,RowId) {
	var BudgSchemSplitYearMonthDetailUrl ='herp.budg.budgschemsplityearmonthdetailexe.csp';
	var rowObj=detailGrid.getSelectionModel().getSelections();
	
	var rowid="";
	// 定义并初始化行对象长度变量
	var len = rowObj.length;
	// 判断是否选择了要修改的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择修改的的数据!',buttons: 

    Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else{
		rowid = rowObj[0].get("rowid");
		var bmcode = rowObj[0].get("bmcode");
	}	

	var bssdrateField1 = new Ext.form.NumberField({
		id: 'bssdrateField1',
		fieldLabel: '调节比例',
		allowBlank: false,
		emptyText: '调节比例...',
		anchor: '90%'
	});

  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
            bssdrateField1
		]
	});

  var window = new Ext.Window({
  	title: '修改调节比例',
    width: 400,
    height:300,
    minWidth: 400,
    minHeight: 300,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    // atLoad : true, // 是否自动刷新
    items: formPanel,
    buttons: [{
    	text: '保存',
		handler: function() {
      		// check form value
      		var bssdrate = bssdrateField1.getValue();
      		if(bssdrate=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'调节比例为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};

      		for(var i = 0; i < len; i++){
      			Ext.Ajax.request({
					url: BudgSchemSplitYearMonthDetailUrl+'?action=edit&&rowid='+rowObj[i].get("rowid")+'&bmcode='+rowObj[i].get("bmcode")+'&bssdrate='+bssdrate+'&RowId='+RowId,
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
				  	if (jsonData.success=='true') {
				  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				  		detailGrid.load({params:{start:0, limit:25}});
						window.close();
							// return rowid;
						}
					},
			  	scope: this
				});
			}
		}
		},{
		text: '取消',
		handler: function(){window.close();}
	}]
});
	window.show();
};