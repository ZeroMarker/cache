function loadIncomeDatas(dataStore,pagingTool)
{    
	if(monthDr==""){
		Ext.Msg.show({title:'错误',msg:'请选择核算区间再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}
	// if(!isdeal(dataStore)) return;
	//var ServletURL = 'http://192.168.2.68:8080';
	var fileNameField = new Ext.form.TextField({
	id: 'fileName',
    fieldLabel: '选择文件',
    name: 'upload',
    inputType: 'file',
    allowBlank: false,
    blankText: '请选择上传文件...',   
    anchor: '95%'
	});

	// create form panel
	var formPanel = new Ext.form.FormPanel({
				frame: true,
    		    id: 'fromPanel',
				baseCls : 'x-plain',
				labelWidth : 80,
				fileUpload : true,
				//enctype : 'multipart/form-data',
				items : [ fileNameField ],
				buttons : [{
					text: '开始上传',
					handler: function(){
					
					    
						if (formPanel.getForm().isValid()) {
							formPanel.getForm().submit({
							url: ServletURL+'/dhccanow/IncomeDataUp?interval='+monthDr+'&inType=load&user='+userDr,	
								method : 'POST',
								waitMsg:'正在上传, 请等待...',
								success:function(form, action, o) {
									Ext.Msg.show({title:'注意',msg:'上传成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                                    dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize,monthDr:monthDr}});
									
									win.close();
								},
								failure:function(form, action) {
									Ext.Msg.show({title:'注意',msg:'上传失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                                                              
								}
							});    
						}
						else{
							Ext.Msg.show({title:'注意',msg:'请修正错误后再上传!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					}
				}]
	});
									
	var win = new Ext.Window( {
			title: '导入收入数据',
		    width: 450,
    		height:200,  
    		minWidth: 450,
    		minHeight: 200,  
    		layout: 'fit',   
    		plain:true,
    		bodyStyle:'padding:5px;',  
    		buttonAlign:'center',  
    		items: formPanel,
    		modal : true,
			maximizable : false
	});
	win.show();
};