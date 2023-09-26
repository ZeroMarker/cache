editFun = function(dataStore,grid,pagingTool) {
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid"); 
	}
	
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '代码',
		allowBlank: false,
		emptyText: '核算月代码...',
		name: 'code',
		anchor: '90%'
	});
	
	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '名称',
		allowBlank: false,
		emptyText: '核算月名称...',
		name: 'name',
		anchor: '90%'
	});
	
	var dataFinishField = new Ext.form.Checkbox({
		id: 'dataFinishField',
		//hideLabel: true,
		labelSeparator: '收入采集标志',
		allowBlank: false,
		checked: (rowObj[0].data['dataFinish'])=='Y'?true:false
	});

	var treatFinishField = new Ext.form.Checkbox({
		id: 'treatFinishField',
		labelSeparator: '成本采集标志',
		//hideLabel: true,
		//disabled:true,
		allowBlank: false,
		checked: (rowObj[0].data['treatFinish'])=='Y'?true:false
	});
	
	var tieOffField = new Ext.form.Checkbox({
		id: 'tieOffField',
		labelSeparator: '参数采集标志',  //'扎帐标志',
		//disabled:true,
		//hideLabel: true,
		allowBlank: false,
		checked: (rowObj[0].data['tieOff'])=='Y'?true:false
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		allowBlank: false,
		emptyText: '类别名称...',
		name: 'remark',
		anchor: '90%'
	});
	
	var startDate = new Ext.form.DateField({
		id: 'startDate',
		fieldLabel: '开始时间',
		allowBlank: false,
		dateFormat: 'Y-m-d',
		emptyText:'选择开始时间...',
		anchor: '90%'
	});
	var endDate = new Ext.form.DateField({
		id: 'endDate',
		fieldLabel: '结束时间',
		allowBlank: false,
		dateFormat: 'Y-m-d',
		emptyText:'选择结束时间...',
		anchor: '90%'
	});
	
	/*
	dataFinishField.on('check', function(o, v){
		if(v==true)	{
			treatFinishField.setDisabled(false);
			tieOffField.setDisabled(true);
		}else{
			treatFinishField.setDisabled(true);
			tieOffField.setDisabled(true);
		}
	});
	
	treatFinishField.on('check', function(o, v){
		if(v==true)	{
			dataFinishField.setDisabled(true);
			tieOffField.setDisabled(false);
		}else{
			dataFinishField.setDisabled(false);
			tieOffField.setDisabled(true);
		}
	});
	tieOffField.on('check', function(o, v){
		if(v==true)	{
			dataFinishField.setDisabled(true);
			treatFinishField.setDisabled(true);
		}else{
			dataFinishField.setDisabled(true);
			treatFinishField.setDisabled(false);
		}
	});
	
	var flagPanel = new Ext.Panel({
			layout: 'column',
			border: false,
			//labelWidth: 80,
			baseCls: 'x-plain',
			autoHeight:true,
			defaults: {
				border: false,
				layout: 'form',
				baseCls: 'x-plain',
				//labelSeparator: ':',
				columnWidth: .3
			},
			items: [
				{
					items: dataFinishField
				},
				{
					items: treatFinishField
				},
				{
					items: tieOffField
				}
			]
	});
	*/
	// create form panel
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			codeField,
            nameField,
			startDate,
			endDate,
            //flagPanel,
            remarkField,
            dataFinishField,
            treatFinishField,
            tieOffField
			
		]        
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			startDate.setValue(rowObj[0].data['start']);
			endDate.setValue(rowObj[0].data['end']);
		});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '修改核算月',
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
			var remark=remarkField.getValue();
      		var dataFinish = (dataFinishField.getValue()==true)?'Y':'N';
      		var treatFinish = (treatFinishField.getValue()==true)?'Y':'N';
      		var tieOff = (tieOffField.getValue()==true)?'Y':'N';
      		
      		
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
      		
			var sDate=startDate.getValue().format('Y-m-d');
			var eDate=endDate.getValue().format('Y-m-d');
			var temDate=""
			if(startDate>endDate){
				temDate=startDate;
				startDate=endDate;
				endDate=temDate;
			}
			
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: AccountMonthsUrl+'?action=edit&id='+myRowid+'&code='+code+'&name='+name+'&dataFinish='+dataFinish+'&treatFinish='+treatFinish+'&tieOff='+tieOff+'&remark='+remark+'&startDate='+sDate+'&endDate='+eDate,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyCode') message='输入的代码为空!';
									if(jsonData.info=='EmptyName') message='输入的名称为空!';
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