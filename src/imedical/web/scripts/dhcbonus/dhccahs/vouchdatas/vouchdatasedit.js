var editFun = function(dataStore,grid,pagingTool,monthDr) {
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
	
	
	var debitField = new Ext.form.NumberField({
		id: 'debitField',
		fieldLabel: '借方',
		//allowDecimals:false,
		name:'debit',
		allowBlank: false,
		anchor: '90%'
	});
	
	var loansField = new Ext.form.NumberField({
		id: 'loansField',
		fieldLabel: '贷方',
		//allowDecimals:false,
		name:'loans',
		allowBlank: true,
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		name:'remark',
		allowBlank: true,
		emptyText: '凭证数据备注...',
		anchor: '90%'
	});
	
	var deptCodeField = new Ext.form.TextField({
		id: 'deptCodeField',
		fieldLabel: '科室代码',
		name:'deptCode',
		allowBlank: true,
		emptyText: '修改科室代码...',
		anchor: '90%'
	});
var deptNameField = new Ext.form.TextField({
		id: 'deptNameField',
		fieldLabel: '科室名称',
		name:'deptName',
		allowBlank: true,
		emptyText: '修改科室名称...',
		anchor: '90%'
	});
	
	var subjCodeField = new Ext.form.TextField({
		id: 'subjCodeField',
		fieldLabel: '科目代码',
		name:'subjCode',
		allowBlank: true,
		emptyText: '修改科目代码...',
		anchor: '90%'
	});
	
	var subjNameField = new Ext.form.TextField({
		id: 'subjNameField',
		fieldLabel: '科目名称',
		name:'subjName',
		allowBlank: true,
		emptyText: '修改科名称...',
		anchor: '90%'
	});
	
	
  
	
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 70,
    items: [
			deptCodeField,
			deptNameField,
			subjCodeField,
			subjNameField,
			remarkField,
			debitField,
			loansField
		]        
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
		
		
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '修改凭证数据表',
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
		
			var deptCode=deptCodeField.getValue();
			var deptName=deptNameField.getValue();
			var subjCode=subjCodeField.getValue();
			var subjName=subjNameField.getValue();
      		var remark = remarkField.getValue();
			var debit=debitField.getValue();
			var loans=loansField.getValue();	
      		
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
						  
						   	//url: vouchDatasUrl+'?action=edit&id='+myRowid+'&deptCode='+deptCode+'&subjCode='+subjCode+'&remark='+remark+'&debit='+debit+'&loans='+loans+'&monthDr='+monthDr+'&userDr='+userDr+'&deptName='+deptName+'&subjName='+subjName,
							url: vouchDatasUrl+'?action=edit&id='+myRowid+'&deptCode='+deptCode+'&deptName='+deptName+'&subjCode='+subjCode+'&subjName='+subjName+'&remark='+remark+'&debit='+debit+'&loans='+loans+'&userDr='+userDr,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'注意',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize,monthDr:monthDr}});
									window.close();
								}
								else
								{
									var message = "";
									message =  jsonData.info;
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