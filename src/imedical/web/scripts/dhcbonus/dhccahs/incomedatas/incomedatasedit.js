var editFun = function(dataStore,grid,pagingTool) {
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
	//------------------------------------------------------------------------------
	var feeField = new Ext.form.NumberField({
		id: 'feeField',
		fieldLabel: '金额',
		//allowDecimals:false,
		name:'fee',
		allowBlank: false,
		anchor: '90%'
	});
	
	var costField = new Ext.form.NumberField({
		id: 'costField',
		fieldLabel: '成本',
		//allowDecimals:false,
		name:'cost',
		allowBlank: false,
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		name:'remark',
		allowBlank: true,
		emptyText: '收入数据备注...',
		anchor: '90%'
	});
	var itemCodeField = new Ext.form.TextField({
		id: 'itemCodeField',
		fieldLabel: '项目代码',
		name:'itemCode',
		allowBlank: true,
		emptyText: '项目代码...',
		anchor: '90%'
	});
	var itemNameField = new Ext.form.TextField({
		id: 'itemNameField',
		fieldLabel: '项目名称',
		name:'itemName',
		allowBlank: true,
		emptyText: '收入项目名称...',
		anchor: '90%'
	});
	var fDeptCodeField = new Ext.form.TextField({
		id: 'fDeptCodeField',
		fieldLabel: '开单部门代码',
		name:'fDeptCode',
		allowBlank: true,
		emptyText: '开单部门代码...',
		anchor: '90%'
	});
	var fDeptNameField = new Ext.form.TextField({
		id: 'fDeptNameField',
		fieldLabel: '开单部门名称',
		name:'fDeptName',
		allowBlank: true,
		emptyText: '开单部门名称...',
		anchor: '90%'
	});
	var tDeptCodeField = new Ext.form.TextField({
		id: 'tDeptCodeField',
		fieldLabel: '接收部门代码',
		name:'tDeptCode',
		allowBlank: true,
		emptyText: '接收部门代码...',
		anchor: '90%'
	});
	var tDeptNameField = new Ext.form.TextField({
		id: 'tDeptNameField',
		fieldLabel: '接收部门名称',
		name:'tDeptName',
		allowBlank: true,
		emptyText: '接收部门名称...',
		anchor: '90%'
	});
	var patDeptCodeField = new Ext.form.TextField({
		id: 'pattDeptCodeField',
		fieldLabel: '病人部门代码',
		name:'patDeptCode',
		allowBlank: true,
		emptyText: '病人部门代码...',
		anchor: '90%'
	});
	var patDeptNameField = new Ext.form.TextField({
		id: 'patDeptNameField',
		fieldLabel: '病人部门名称',
		name:'patDeptName',
		allowBlank: true,
		emptyText: '病人部门名称...',
		anchor: '90%'
	});
	//------------------------------------------------------------------------------
	
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 90,
    items: [
			itemCodeField,
			itemNameField,
			fDeptCodeField,
			fDeptNameField,
			tDeptCodeField,
			tDeptNameField,
			patDeptCodeField,
			patDeptNameField,
			feeField,
			//costField,
			remarkField
		]        
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '修改收入数据表',
    width: 400,
    height:400,
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
		
			var itemCode=itemCodeField.getValue();
			var itemName=itemNameField.getValue();
			var fDeptCode=fDeptCodeField.getValue();
			var fDeptName=fDeptNameField.getValue();
			var tDeptCode=tDeptCodeField.getValue();
			var tDeptName=tDeptNameField.getValue();
			var patDeptCode=patDeptCodeField.getValue();
			var patDeptName=patDeptNameField.getValue();
			
			itemCode=itemCode.trim();
			itemName=itemName.trim();
			fDeptCode=fDeptCode.trim();
			fDeptName=fDeptName.trim();
			tDeptCode=tDeptCode.trim();
			tDeptName=tDeptName.trim();
			patDeptCode=patDeptCode.trim();
			patDeptName=patDeptName.trim();
			
      		var remark = remarkField.getValue();
			var fee=feeField.getValue();
			var cost=costField.getValue();
      		  		
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: incomeDatasUrl+'?action=edit&id='+myRowid+'&itemCode='+itemCode+'&itemName='+itemName+'&remark='+remark+'&fee='+fee+'&cost='+cost+'&monthDr='+monthDr+'&userDr='+userDr+'&fDeptCode='+fDeptCode+'&fDeptName='+fDeptName+'&tDeptCode='+tDeptCode+'&tDeptName='+tDeptName+'&patDeptCode='+patDeptCode+'&patDeptName='+patDeptName,
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
									if(jsonData.info=='EmptyName') message='输入的名称为空!';
									if(jsonData.info=='EmptyOrder') message='输入的序号为空!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
									if(jsonData.info=='RepOrder') message='输入的序号已经存在!';
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