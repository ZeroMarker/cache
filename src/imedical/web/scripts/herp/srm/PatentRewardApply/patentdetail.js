var userid = session['LOGON.USERID'];

PatentDetail = function(itemGrid ) {

	var records = itemGrid.getSelectionModel().getSelections();
	var Titles = records[0].get("Name");
	var PatentNums  = records[0].get("PatentNum");
	var CertificateNos  = records[0].get("CertificateNo");
	var AppDates  = records[0].get("AppDate");
	var AnnDates = records[0].get("AnnDate");
	var AnnUnitLists = records[0].get("AnnUnitList");
	var CompleteUnits  = records[0].get("CompleteUnit");
	var InvoiceCodes  = records[0].get("InvoiceCode");
	var InvoiceNos  = records[0].get("InvoiceNo");

///////////////////ר����/////////////////////////////  
var PatentNumField = new Ext.form.TextField({
				fieldLabel: 'ר����',
				width:180,
				value:PatentNums,
				disabled:true,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''
			});
///////////////////ר��֤���/////////////////////////////  
var CertificateNoField = new Ext.form.TextField({
				fieldLabel: 'ר��֤���',
				width:180,
				value:CertificateNos,
				disabled:true,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''
			});
/////////////////////������λ///////////////////////////  
var  AnnUnitListField= new Ext.form.TextField({
				fieldLabel: '������λ',
				width:180,
				value:AnnUnitLists,
				disabled:true,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''
			});
///////////////////��Ժ��λλ��/////////////////////////////  
var CompleteUnitField = new Ext.form.TextField({
				fieldLabel: '��Ժ��λλ��',
				width:180,
				value:CompleteUnits,
				disabled:true,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''
			});
///////////////////��������/////////////////////////////  
var AppDateField = new Ext.form.TextField({
				fieldLabel: '��������',
				width:180,
				value:AppDates,
				disabled:true,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''
			});
///////////////////��Ȩ��ʾ����/////////////////////////////  
var AnnDateField = new Ext.form.TextField({
				fieldLabel: '��Ȩ��ʾ����',
				width:180,
				allowBlank : true, 
				anchor: '95%',
				disabled:true,
				value:AnnDates,
        ////emptyText: '������......',
				selectOnFocus:'true',
				labelSeparator:''
			});
///////////////////��������/////////////////////////////  
var InvoiceCodeField = new Ext.form.TextField({
				fieldLabel: '��������',
				width:180,
				allowBlank : true, 
				anchor: '95%',
				value:InvoiceCodes,
				disabled:true,
        ////emptyText: '������......',
				selectOnFocus:'true',
				labelSeparator:''
			});
///////////////////������/////////////////////////////  
var InvoiceNoField = new Ext.form.TextField({
				fieldLabel: '������',
				width:180,
				allowBlank : true, 
				anchor: '95%',
				value:InvoiceNos,
				disabled:true,
        ////emptyText: '������......',
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
						       PatentNumField,
						       CertificateNoField,
						        AnnUnitListField,
						       CompleteUnitField
                
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
                  AppDateField,
                  AnnDateField,
                  InvoiceCodeField,
                  InvoiceNoField
				
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
				text:'�ر�',iconCls : 'cancel'
			});
			
			cancelHandler = function(){
				addwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			addwin = new Ext.Window({
				title: Titles+'--��ϸ��Ϣ',
				iconCls: 'popup_list',
				width: 500,
				height: 350,
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


