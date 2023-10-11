preauditfun = function()
{	
	var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var usercode = session['LOGON.USERCODE'];
/////////////////Ԥ����///////////////////////////
var PreAuditDs = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['2','Ԥ��ͨ��'],['3','��ͨ��']]
});

var PreAuditCombo = new Ext.form.ComboBox({
	id: 'PreAuditCombo',
	fieldLabel: 'Ԥ����',
	width:270,
	listWidth : 270,
	allowBlank: true,
	store:PreAuditDs,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	//emptyText:'��ѡ��Ԥ����...',
	mode : 'local',
	name: 'PreAuditCombo',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	labelSeparator:''
});
	
	
	// ���ı���
	var textArea = new Ext.form.TextArea
	({		
		id : 'textArea',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : 'Ԥ�����',
		allowBlank :false,
		selectOnFocus:'true',
		//emptyText : '����дԤ���������'
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
		text:'����',
		iconCls: 'save'
	});
			
	///////////  ���Ӱ�ť��Ӧ����   ///////////
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
					waitMsg:'������...',
					failure: function(result, request)
					{
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request)
					{
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true')
						{							
							Ext.Msg.show({title:'ע��',msg:'Ԥ�����!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});												
							itemGrid.load({params:{start:0,limit:25}});	
							addwin.close();
						}
						else
						{
							//var tmpMsg = jsonData.info;
							Ext.Msg.show({title:'����',msg:'Ԥ��ʧ��',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							addwin.close();
						}
					},
					scope: this
			 	});
		  	}
	   }
	   else
	   {
		   Ext.Msg.show({title:'����',msg:'������ҳ���ϵĴ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	   }	
	}
	////// ��Ӽ����¼� //////	
	addButton.addListener('click',addHandler,false);

	cancelButton = new Ext.Toolbar.Button
	({
		text:'�ر�',
		iconCls : 'cancel'
	});
		
	cancelHandler = function()
	{
		addwin.close();
	}
		
	cancelButton.addListener('click',cancelHandler,false);

	addwin = new Ext.Window
	({
		title: '������Ԥ��',
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


