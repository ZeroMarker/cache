var userid = session['LOGON.USERID'];

PaperDetail = function(itemGrid ) {
	
//	"rowid^RecordType^DeptName^Title^JournalDR^JName^JourLevel^PaperType^PageCharge^InvoiceCode^InvoiceNo"
//  _"^FristAuthor^FristAuthorComp^FristAuthorDept^FristAuthorTitle^CorrAuthor^CorrAuthorComp^CorrAuthorDept^CorrAuthorTitle"
//  _"^RegInfo^PubYear^Roll^Period^StartPage^EndPage^IF^AuthorsInfo^CorrAuthorsInfo^RewardAmount"
//  _"^SubUser^SubDate^DataStatus^CheckState^Desc"
  
	var records = itemGrid.getSelectionModel().getSelections();
	var Titles  = records[0].get("Title");
	var JNames  = records[0].get("JName");
	var FristAuthors  = records[0].get("FristAuthor");
	var FristAuthorDept = records[0].get("FristAuthorDept");
	var FristAuthorComp = records[0].get("FristAuthorComp");
	var CorrAuthors  = records[0].get("CorrAuthor");
	var CorrAuthorDept  = records[0].get("CorrAuthorDept");
	var CorrAuthorComp  = records[0].get("CorrAuthorComp");
	var RegInfo = records[0].get("RegInfo");
	var IF = records[0].get("IF");
	var InvoiceCode = records[0].get("InvoiceCode");
	var InvoiceNo = records[0].get("InvoiceNo");
	
	var RecordTypes = records[0].get("RecordType");
	var JourLevels = records[0].get("JourLevel");
	var JNames = records[0].get("JName");
	var PaperTypes = records[0].get("PaperType");
	var ESICiteds = records[0].get("ESICited");
	
	var PaperTypes = records[0].get("PaperType");

///////////////////�ڿ�����/////////////////////////////  
var RecordTypeField = new Ext.form.TextField({
				fieldLabel: '����¼���ݿ�',
				width:180,
				value:RecordTypes,
				//disabled:true,
				allowBlank : true, 
				anchor: '95%',
        //emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////�ڿ�����/////////////////////////////  
var JourLevelField = new Ext.form.TextField({
				fieldLabel: '�ڿ�����',
				width:180,
				value:JourLevels,
				//disabled:true,
				allowBlank : true, 
				anchor: '95%',
        //emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});
/////////////////////�ڿ�����///////////////////////////  
var JNameField = new Ext.form.TextField({
				fieldLabel: '�ڿ�����',
				width:180,
				value:JNames,
				//disabled:true,
				allowBlank : true, 
				anchor: '95%',
        //emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////�������/////////////////////////////  
var PaperTypeField = new Ext.form.TextField({
				fieldLabel: '�������',
				width:180,
				value:PaperTypes,
				//disabled:true,
				allowBlank : true, 
				anchor: '95%',
        //emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////������Ŀ/////////////////////////////  
var Title = new Ext.form.TextField({
				fieldLabel: '������Ŀ',
				width:180,
				value:Titles,
				//disabled:true,
				allowBlank : true, 
				anchor: '95%',
        //emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////��һ���߿���/////////////////////////////  
var FristAuthorDept = new Ext.form.TextField({
				fieldLabel: '��һ���߿���',
				width:180,
				allowBlank : true, 
				anchor: '95%',
				//disabled:true,
				value:FristAuthorDept,
        //emptyText: '������......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////��һ���ߵ�λ/////////////////////////////  
var FristAuthorComp = new Ext.form.TextField({
				fieldLabel: '��һ���ߵ�λ',
				width:180,
				allowBlank : true, 
				anchor: '95%',
				value:FristAuthorComp,
				//disabled:true,
        //emptyText: '������......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////��һͨѶ���߿���/////////////////////////////  
var CorrAuthorDept = new Ext.form.TextField({
				fieldLabel: '��һͨѶ���߿���',
				width:180,
				allowBlank : true, 
				anchor: '95%',
				value:CorrAuthorDept,
				//disabled:true,
        //emptyText: '������......',
				selectOnFocus:'true',
				labelSeparator:''

			});	
///////////////////��һͨѶ���ߵ�λ/////////////////////////////  
var CorrAuthorComp = new Ext.form.TextField({
				fieldLabel: '��һͨѶ���ߵ�λ',
				width:180,
				allowBlank : true, 
				anchor: '95%',
				value:CorrAuthorComp,
				//disabled:true,
        //emptyText: '������......',
				selectOnFocus:'true',
				labelSeparator:''

			});	
///////////////////��һ����/////////////////////////////  
	var FristAuthor = new Ext.form.TextField({
				fieldLabel: '��һ����',
				width:180,
				value:FristAuthors,
				anchor: '95%',
				//disabled:true,
        //emptyText: '������......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////��һͨѶ����/////////////////////////////  
var CorrAuthor= new Ext.form.TextField({
				fieldLabel: '��һͨѶ����',
				width:180,
				value:CorrAuthors,
				//disabled:true,
				anchor: '95%',
        //emptyText: '������......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////�����ҳ/////////////////////////////  
var RegInfoField = new Ext.form.TextField({
				fieldLabel: '�����ҳ',
				width:180,
				allowBlank : true, 
				value:RegInfo,
				//disabled:true,
				anchor: '95%',
        //emptyText: '������......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////Ӱ������/////////////////////////////  
var IF = new Ext.form.TextField({
				fieldLabel: 'Ӱ������',
				width:180,
				allowBlank : true, 
				value:IF,
				//disabled:true,
				anchor: '95%',
        //emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});				
///////////////////��Ʊ����/////////////////////////////  
var InvoiceCodeField = new Ext.form.TextField({
				fieldLabel: '��Ʊ����',
				width:180,
				//allowBlank : false, 
				value:InvoiceCode,
				//disabled:true,
				anchor: '95%',
        //emptyText: '������......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////��Ʊ��/////////////////////////////  
var InvoiceNoField = new Ext.form.TextField({
				fieldLabel: '��Ʊ����',
				width:180,
				//allowBlank : false, 
				//disabled:true,
				value:InvoiceNo,
				anchor: '95%',
        //emptyText: '������......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////�Ƿ�ESI�߱���/////////////////////////////  
var ESICitedField = new Ext.form.TextField({
				fieldLabel: '�Ƿ�ESI�߱���',
				width:180,
				allowBlank : false, 
				//disabled:true,
				value:ESICiteds,
				anchor: '95%',
               //emptyText: '�Ƿ�ESI�߱���......',
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
						      JNameField,
						       JourLevelField,
						        RecordTypeField,
						       PaperTypeField,
                               Title,  
							   //ESICitedField,
                               RegInfoField,   
                               IF
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
								
									FristAuthor,
                  //FristAuthorComp,
                  FristAuthorDept,
                  CorrAuthor,
                  //CorrAuthorComp,
                  CorrAuthorDept,
                  	InvoiceCodeField,
					InvoiceNoField
								]
							 }]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 100,
				labelAlign:'right',
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
				title: Titles+'--���ķ�����ϸ��Ϣ',
				iconCls: 'popup_list',
				width: 500,
				height: 340,
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


