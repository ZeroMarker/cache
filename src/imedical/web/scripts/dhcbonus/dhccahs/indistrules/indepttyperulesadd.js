specialUnitAddFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
  // pre-define fields in the form

	var selectedRow = grid.getSelections();
	if (selectedRow.length < 1){
		Ext.MessageBox.show({title: '提示',msg: '请选择一条数据！',buttons: Ext.MessageBox.OK,icon: Ext.MessageBox.INFO});
		return;
	}
	var selectedRowid=selectedRow[0].get("rowid");
	
	var fDeptField = new Ext.form.NumberField({
        id: 'fDeptField',
        fieldLabel: '开单科室',
		allowDecimals: true,
		allowNegative:false,
        allowBlank: false,
		value:0,
        emptyText: '开单科室...',
        anchor: '90%'
    });
	var tDeptField = new Ext.form.NumberField({
        id: 'tDeptField',
        fieldLabel: '接收科室',
		allowDecimals: true,
		allowNegative:false,
        allowBlank: false,
		value:0,
        emptyText: '接收科室...',
        anchor: '90%'
    });
	var patDeptField = new Ext.form.NumberField({
        id: 'patDeptField',
        fieldLabel: '病人科室',
        allowBlank: false,
		allowNegative:false,
		allowDecimals: true,
		value:0,
        emptyText: '病人科室...',
        anchor: '90%'
    });
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
		fDeptField,
		tDeptField,
		patDeptField
		]
	});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '修改科室类别分配规则',
    width: 400,
    height:200,
    minWidth: 300,
    minHeight: 200,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
		id:'saveButton',
    	text: '保存', 
      handler: function() {
      		// check form value
			var totalStr=fDeptField.getValue()+tDeptField.getValue()+patDeptField.getValue();
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'dhc.ca.indistrulesexe.csp?action=addtyperules&fdept='+fDeptField.getValue()+'&tdept='+tDeptField.getValue()+'&patdept='+patDeptField.getValue()+'&parRef='+selectedRowid,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
								if(totalStr!=100){
									Ext.Msg.show({title:'注意',msg:'比例总和不为100%,请从新调整!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}else{
									Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,parRef:selectedRowid}});
									window.close();
								}
								else
								{
									var message="";
									if(jsonData.info=='RepExist') message='输入的单元已经存在!';
									else message='未知错误!';
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