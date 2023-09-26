editFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();

	var rowObj = grid.getSelections();
	var len = rowObj.length;
	var id = 0;
	var deptDr = '';
	
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		id = rowObj[0].get("rowId");
		deptDr = rowObj[0].get("deptDr");
	}
	
	var orderField = new Ext.form.NumberField({
		id:'orderField',
    fieldLabel: '权限顺序',
    allowBlank: false,
    emptyText:'权限顺序...',
    name:'order',
    anchor: '95%'
	});
	
	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: '权限名称',
    allowBlank: false,
    emptyText:'权限名称...',
    name:'name',
    anchor: '95%'
	});
	
	var activeField = new Ext.form.Checkbox({
		id: 'activeField',
		labelSeparator: '有效:',
    allowBlank: false,
		checked: (rowObj[0].data['active'])=='Y'?true:false
	});

  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [
    	orderField,
 			nameField,
 			activeField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
	});

  var window = new Ext.Window({
  	title: '修改权限',
    width: 400,
    height:300,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存', 
      handler: function() {
				var order = orderField.getValue();
				var name = nameField.getValue();
      	var active = (activeField.getValue()==true)?'Y':'N';
      	
      	order = order.trim();	
      	name = name.trim();
      	
        if(formPanel.form.isValid()){
					Ext.Ajax.request({
						url: mainUrl+'?action=edit&id='+id+'&order='+order+'&name='+name+'&active='+active,
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
								var message="SQLErr: "+jsonData.info;
								if(jsonData.info=='RepOrder') message='输入的顺序已经存在!';
								if(jsonData.info=='RepName') message='输入的名称已经存在!';
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
      handler: function(){
      	window.close();
      }
    }]
  });
  window.show();
};