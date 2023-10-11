preauditfun = function()
{	
	var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var usercode = session['LOGON.USERCODE'];
/////////////////预审结果///////////////////////////
var PreAuditDs = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['2','预审通过'],['3','不通过']]
});

var PreAuditCombo = new Ext.form.ComboBox({
	id: 'PreAuditCombo',
	fieldLabel: '预审结果',
	width:270,
	listWidth : 270,
	allowBlank: true,
	store:PreAuditDs,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	//emptyText:'请选择预审结果...',
	mode : 'local',
	name: 'PreAuditCombo',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	labelSeparator:''
});
	
	
	// 多文本域
	var textArea = new Ext.form.TextArea
	({		
		id : 'textArea',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '预审意见',
		allowBlank :false,
		selectOnFocus:'true',
		//emptyText : '请填写预审意见……'
		labelSeparator:''
	});

	var colItems =
	[
		{
			layout: 'column',
			border: false,
			defaults:
			{
				columnWidth: '1.0',
				bodyStyle:'padding:5px 5px 0',
				border: false
			},            
			items:
			[
				{
					xtype: 'fieldset',
					autoHeight: true,
					items:
					[			
						PreAuditCombo,
						textArea
					]
				}
			]
		}
	 ]			
	
	var formPanel = new Ext.form.FormPanel
	({
		labelWidth: 80,
		frame: true,
		items: colItems
	});
	
	addButton = new Ext.Toolbar.Button
	({
		text:'保存',
		iconCls: 'save'
	});
			
	///////////  增加按钮响应函数   ///////////
	addHandler = function()
	{
		var PreChkDesc= encodeURIComponent(Ext.getCmp('textArea').getRawValue());
		var PreAuditState= PreAuditCombo.getValue();
		
		if(formPanel.form.isValid())
		{			
		    for(var i = 0; i < len; i++)
		    {
			    Ext.Ajax.request
			    ({
					url:projUrl+'?action=preaudit'+'&rowid='+rowObj[i].get("rowid")+'&PreAuditState='+PreAuditState+'&PreAuditDesc='+PreChkDesc+'&usercode='+usercode,
					waitMsg:'保存中...',
					failure: function(result, request)
					{
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request)
					{
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true')
						{							
							Ext.Msg.show({title:'注意',msg:'预审完成!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});												
							itemGrid.load({params:{start:0,limit:25}});	
							addwin.close();
						}
						else
						{
							//var tmpMsg = jsonData.info;
							Ext.Msg.show({title:'错误',msg:'预审失败',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							addwin.close();
						}
					},
					scope: this
			 	});
		  	}
	   }
	   else
	   {
		   Ext.Msg.show({title:'错误',msg:'请修正页面上的错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	   }	
	}
	////// 添加监听事件 //////	
	addButton.addListener('click',addHandler,false);

	cancelButton = new Ext.Toolbar.Button
	({
		text:'关闭',
		iconCls : 'cancel'
	});
		
	cancelHandler = function()
	{
		addwin.close();
	}
		
	cancelButton.addListener('click',cancelHandler,false);

	addwin = new Ext.Window
	({
		title: '科主任预审',
		iconCls : 'updateinfo',
		width: 400,
		height: 300,
		//autoHeight: true,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons:[addButton,cancelButton]
	});		
	addwin.show();			
}


