addFun = function(dataStore,grid,pagingTool) {

	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '代码',
		allowBlank: false,
		emptyText: '核算月代码...',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '名称',
		allowBlank: false,
		emptyText: '核算月名称...',
		anchor: '90%'
	});
	
	var startDate = new Ext.form.DateField({
		id: 'startDate',
		fieldLabel: '开始日期',
		allowBlank: false,
		dateFormat: 'Y-m-d',
		emptyText:'选择开始日期...',
		anchor: '90%'
	});
	var endDate = new Ext.form.DateField({
		id: 'endDate',
		fieldLabel: '结束日期',
		allowBlank: false,
		dateFormat: 'Y-m-d',
		emptyText:'选择结束日期...',
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		allowBlank: true,
		emptyText:'备注...',
		anchor: '90%'
	});
	
	remarkField.on('check', function(o, v){
		if(v==true)	inFlagField.setValue(false);
	});
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			codeField,
            nameField,
            startDate,
			endDate,
			remarkField
		]        
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '添加核算月',
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
      		var code = codeField.getValue();
      		var name = nameField.getValue();
			var remark = remarkField.getValue();
			
			var sDate=startDate.getValue().format('Y-m-d');
			var eDate=endDate.getValue().format('Y-m-d');
			var temDate=""
			if(startDate>endDate){
				temDate=startDate;
				startDate=endDate;
				endDate=temDate;
			}
			
      		code = code.trim();
      		name = name.trim();
      		
			remark = remark.trim();
      		
      		if(code=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(name=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
      		
      		
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: AccountMonthsUrl+'?action=add&code='+code+'&name='+name+'&remark='+remark+'&startDate='+sDate+'&endDate='+eDate,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyCode') message='输入的代码为空!';
									if(jsonData.info=='EmptyName') message='输入的名称为空!';
									if(jsonData.info=='EmptyStart') message='输入的开始日期为空!';
									if(jsonData.info=='EmptyEnd') message='输入的结束日期为空!';
									if(jsonData.info=='RepCode') message='输入的代码已经存在!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
									if(jsonData.info=='NameformatError') message='请将输入的名称改为 YYYY-MM 格式!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
	    	}
    	},
    	{
				text: '取消',
        handler: function(){window.close();}
      }]
    });

    window.show();
};