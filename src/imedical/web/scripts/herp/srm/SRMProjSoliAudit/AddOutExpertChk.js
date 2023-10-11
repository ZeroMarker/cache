AddOutExpertChk = function(viewrowid)
{
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var expertinfo = rowObj[0].get("OutExpertResult");
	var ethicexpertinfo=rowObj[0].get("OutEthicResult");
	var len = rowObj.length;
	if(len < 1)
	{
		Ext.Msg.show({title:'提示',msg:'请选择需要添加的项目!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
///////////////////////院外专家审核//////////////////////////////
var OutExpertInfoField = new Ext.form.TextArea({
		id : 'OutExpertInfoField',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '院外专家审核结果',
		allowBlank :true,
		selectOnFocus:'true',
		value:expertinfo,
		emptyText : '请填写院外专家审核结果……'
	});
	///////////////////////院外伦理专家审核//////////////////////////////
var OutEthicExpertInfoField = new Ext.form.TextArea({
		id : 'OutEthicExpertInfoField',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '院外伦理专家审核结果',
		allowBlank :true,
		selectOnFocus:'true',
		value:ethicexpertinfo,
		emptyText : '请填写院外专家审核结果……'
	});		
var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.9',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									},
				                     OutExpertInfoField,
				                     OutEthicExpertInfoField
								]	 
							}]
					}
				]			
	// create form panel
  	var viewFormPanel = new Ext.form.FormPanel
  	({  	
   		labelWidth: 80,
		frame: true,
    	items: colItems
	});
	
	viewFormPanel.on('afterlayout', function(panel, layout)
	{
		this.getForm().loadRecord(rowObj[0]);
	});

  	// define window and show it in desktop
 	var viewWindow = new Ext.Window
 	({
  		title: '院外专家审核结果',
    	width: 500,
    	//height:430,
    	//layout: 'fit',
    	plain:true,
    	modal:true,
    	bodyStyle:'padding:5px;',
    	buttonAlign:'center',
    	items: viewFormPanel,
		buttons: [{		 
				text : '保存',
				iconCls: 'save', 
				handler : function() {
				if (viewFormPanel.form.isValid()) {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var rowid = rowObj[0].get("rowid");

				var outexpert = OutExpertInfoField.getValue();
				var outethicexpert = OutEthicExpertInfoField.getValue();
					
				Ext.Ajax.request({
					url:'herp.srm.srmprosoliauditexe.csp?action=addoutexpertinfo&rowid='+encodeURIComponent(rowid)
					+'&outexpert='+encodeURIComponent(outexpert)+'&outethicexpert='+encodeURIComponent(outethicexpert),
					waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGrid.load({	params:{start:0, limit:25}});
						}
						else
						{	var message="重复添加";
						/*
						    if(jsonData.info=='RecordExist') message="记录重复";
							if(jsonData.info=='RepCode') message="编号重复！";
							if(jsonData.info=='RepID') message="身份证号码重复！";
							if(jsonData.info=='RepBirthDay') message="生日不能大于当前日期！";
						*/	
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  viewWindow.close();
				} 
				}					
			},
			{
				text: '关闭',
				iconCls : 'cancel',
				handler : function() {
					viewWindow.close();
				}
			}]
    });
    viewWindow.show();
};
