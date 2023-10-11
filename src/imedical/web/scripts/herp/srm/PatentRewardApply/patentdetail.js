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

///////////////////专利号/////////////////////////////  
var PatentNumField = new Ext.form.TextField({
				fieldLabel: '专利号',
				width:180,
				value:PatentNums,
				disabled:true,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''
			});
///////////////////专利证书号/////////////////////////////  
var CertificateNoField = new Ext.form.TextField({
				fieldLabel: '专利证书号',
				width:180,
				value:CertificateNos,
				disabled:true,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''
			});
/////////////////////公布单位///////////////////////////  
var  AnnUnitListField= new Ext.form.TextField({
				fieldLabel: '公布单位',
				width:180,
				value:AnnUnitLists,
				disabled:true,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''
			});
///////////////////我院单位位次/////////////////////////////  
var CompleteUnitField = new Ext.form.TextField({
				fieldLabel: '我院单位位次',
				width:180,
				value:CompleteUnits,
				disabled:true,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''
			});
///////////////////申请日期/////////////////////////////  
var AppDateField = new Ext.form.TextField({
				fieldLabel: '申请日期',
				width:180,
				value:AppDates,
				disabled:true,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''
			});
///////////////////授权公示日期/////////////////////////////  
var AnnDateField = new Ext.form.TextField({
				fieldLabel: '授权公示日期',
				width:180,
				allowBlank : true, 
				anchor: '95%',
				disabled:true,
				value:AnnDates,
        ////emptyText: '发表刊物......',
				selectOnFocus:'true',
				labelSeparator:''
			});
///////////////////报销编码/////////////////////////////  
var InvoiceCodeField = new Ext.form.TextField({
				fieldLabel: '报销编码',
				width:180,
				allowBlank : true, 
				anchor: '95%',
				value:InvoiceCodes,
				disabled:true,
        ////emptyText: '发表刊物......',
				selectOnFocus:'true',
				labelSeparator:''
			});
///////////////////报销号/////////////////////////////  
var InvoiceNoField = new Ext.form.TextField({
				fieldLabel: '报销号',
				width:180,
				allowBlank : true, 
				anchor: '95%',
				value:InvoiceNos,
				disabled:true,
        ////emptyText: '发表刊物......',
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
				text:'关闭',iconCls : 'cancel'
			});
			
			cancelHandler = function(){
				addwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			addwin = new Ext.Window({
				title: Titles+'--明细信息',
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


