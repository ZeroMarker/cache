var userid = session['LOGON.USERID'];

PatentDetail = function(itemGrid ) {

	var records = itemGrid.getSelectionModel().getSelections();
	var Patentees = records[0].get("Patentee");
	var Titles = records[0].get("Name");
	var SubUsers = records[0].get("SubUser");
	var SubDates = records[0].get("SubDate");
	var AppDates  = records[0].get("AppDate");
	var Phone  = records[0].get("Phone");
	var Email  = records[0].get("Email");
	
	

///////////////////��������/////////////////////////////  
var SubDatesField = new Ext.form.TextField({
				fieldLabel: '�Ǽ�����',
				width:180,
				value:SubDates,
				disabled:true,
				allowBlank : true, 
				anchor: '95%',
               ////emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});


///////////////////ר������/////////////////////////////  
var TitlesField = new Ext.form.TextField({
				fieldLabel: 'ר������',
				width:180,
				value:Titles,
				disabled:true,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});

///////////////////ר��Ȩ��/////////////////////////////  
var PatenteesField = new Ext.form.TextField({
				fieldLabel: 'ר��Ȩ��',
				width:180,
				value:Patentees,
				disabled:true,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});

///////////////////������/////////////////////////////  
var SubUsersField = new Ext.form.TextField({
				fieldLabel: '������',
				width:180,
				value:SubUsers,
				disabled:true,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});		
var PhoneField = new Ext.form.TextField({
		id: 'PhoneField',
		fieldLabel: '�绰����',
		width:180,
		value:Phone,
		disabled:true,
		allowBlank : true, 
		anchor: '95%',
		selectOnFocus:'true',
		labelSeparator:''

	});
var EMailField = new Ext.form.TextField({
		id: 'EMailField',
		fieldLabel: '�����ַ',
		width:180,
		value:Email,
		disabled:true,
		allowBlank : true, 
		anchor: '95%',
		selectOnFocus:'true',
		labelSeparator:''

	});			
			var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.5',
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
						       TitlesField,
							   SubDatesField,
						       PatenteesField
						      
                
								]	 
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									},
					
									SubUsersField,
									PhoneField,
									EMailField
								]
							 }]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 90,
				//layout: 'form',
				frame: true,
				items: colItems
			});
	
			cancelButton = new Ext.Toolbar.Button({
				text:'�ر�',
				iconCls : 'cancel'
			});
			
			cancelHandler = function(){
				addwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			addwin = new Ext.Window({
				title: Titles+'--��ϸ��Ϣ',
				iconCls: 'popup_list',
				width: 500,
				height: 280,
				//autoHeight: true,
				layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: formPanel,
				buttons: [
					cancelButton
				]
			});		
			addwin.show();			
	
	}


