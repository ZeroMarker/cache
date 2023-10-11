editFun = function() {
	
	
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要修改的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择修改的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else{
		var rowid = rowObj[0].get("rowid");
	}	

	var bfincreaserateField = new Ext.form.NumberField({
		id: 'bfincreaserateField',
		fieldLabel: '增长比例%',
		allowBlank: false,
		emptyText: '增长比例%...',
		anchor: '90%'
	});
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			bfincreaserateField
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '修改增长比例',
    width: 400,
    height:300,
    minWidth: 400,
    minHeight: 300,
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
      		var bfincreaserate = bfincreaserateField.getValue();		
   //   		bfincreaserate = bfincreaserate.trim();

      		if(bfincreaserate=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'增长比例为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
        	//var data = bfincreaserate;
            //if (formPanel.form.isValid()) {
      		for(var i = 0; i < len; i++){
						Ext.Ajax.request({
							url: BudgFactYearUrl+'?action=edit&&rowid='+rowObj[i].get("rowid")+'&bfincreaserate='+bfincreaserate+'&bsdcalflag='+rowObj[i].get("bsdcalflag"),
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						  		itemGrid.load({params:{start:0, limit:25}});
								window.close();
							}
//								else
//								{
//									var message = "";
//									message = "SQLErr: " + jsonData.info;
//									if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
//									if(jsonData.info=='RepCode') message='输入的代码已经存在!';
//									if(jsonData.info=='RepName') message='输入的名称已经存在!';
//								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//								}
						},
					  	scope: this
						});
      		}
        	//}
//        	else{
//						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//					}
	    	}
    	},
    	{
		text: '取消',
        handler: function(){window.close();}
      }]
    });

    window.show();
};