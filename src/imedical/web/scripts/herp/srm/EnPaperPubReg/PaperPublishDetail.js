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

///////////////////期刊类型/////////////////////////////  
var RecordTypeField = new Ext.form.TextField({
				fieldLabel: '被收录数据库',
				width:180,
				value:RecordTypes,
				//disabled:true,
				allowBlank : true, 
				anchor: '95%',
        //emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////期刊级别/////////////////////////////  
var JourLevelField = new Ext.form.TextField({
				fieldLabel: '期刊级别',
				width:180,
				value:JourLevels,
				//disabled:true,
				allowBlank : true, 
				anchor: '95%',
        //emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''

			});
/////////////////////期刊名称///////////////////////////  
var JNameField = new Ext.form.TextField({
				fieldLabel: '期刊名称',
				width:180,
				value:JNames,
				//disabled:true,
				allowBlank : true, 
				anchor: '95%',
        //emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////论文类别/////////////////////////////  
var PaperTypeField = new Ext.form.TextField({
				fieldLabel: '论文类别',
				width:180,
				value:PaperTypes,
				//disabled:true,
				allowBlank : true, 
				anchor: '95%',
        //emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////论文题目/////////////////////////////  
var Title = new Ext.form.TextField({
				fieldLabel: '论文题目',
				width:180,
				value:Titles,
				//disabled:true,
				allowBlank : true, 
				anchor: '95%',
        //emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////第一作者科室/////////////////////////////  
var FristAuthorDept = new Ext.form.TextField({
				fieldLabel: '第一作者科室',
				width:180,
				allowBlank : true, 
				anchor: '95%',
				//disabled:true,
				value:FristAuthorDept,
        //emptyText: '发表刊物......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////第一作者单位/////////////////////////////  
var FristAuthorComp = new Ext.form.TextField({
				fieldLabel: '第一作者单位',
				width:180,
				allowBlank : true, 
				anchor: '95%',
				value:FristAuthorComp,
				//disabled:true,
        //emptyText: '发表刊物......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////第一通讯作者科室/////////////////////////////  
var CorrAuthorDept = new Ext.form.TextField({
				fieldLabel: '第一通讯作者科室',
				width:180,
				allowBlank : true, 
				anchor: '95%',
				value:CorrAuthorDept,
				//disabled:true,
        //emptyText: '发表刊物......',
				selectOnFocus:'true',
				labelSeparator:''

			});	
///////////////////第一通讯作者单位/////////////////////////////  
var CorrAuthorComp = new Ext.form.TextField({
				fieldLabel: '第一通讯作者单位',
				width:180,
				allowBlank : true, 
				anchor: '95%',
				value:CorrAuthorComp,
				//disabled:true,
        //emptyText: '发表刊物......',
				selectOnFocus:'true',
				labelSeparator:''

			});	
///////////////////第一作者/////////////////////////////  
	var FristAuthor = new Ext.form.TextField({
				fieldLabel: '第一作者',
				width:180,
				value:FristAuthors,
				anchor: '95%',
				//disabled:true,
        //emptyText: '发表刊物......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////第一通讯作者/////////////////////////////  
var CorrAuthor= new Ext.form.TextField({
				fieldLabel: '第一通讯作者',
				width:180,
				value:CorrAuthors,
				//disabled:true,
				anchor: '95%',
        //emptyText: '发表刊物......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////年卷期页/////////////////////////////  
var RegInfoField = new Ext.form.TextField({
				fieldLabel: '年卷期页',
				width:180,
				allowBlank : true, 
				value:RegInfo,
				//disabled:true,
				anchor: '95%',
        //emptyText: '发表刊物......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////影响因子/////////////////////////////  
var IF = new Ext.form.TextField({
				fieldLabel: '影响因子',
				width:180,
				allowBlank : true, 
				value:IF,
				//disabled:true,
				anchor: '95%',
        //emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''

			});				
///////////////////发票代码/////////////////////////////  
var InvoiceCodeField = new Ext.form.TextField({
				fieldLabel: '发票代码',
				width:180,
				//allowBlank : false, 
				value:InvoiceCode,
				//disabled:true,
				anchor: '95%',
        //emptyText: '发表刊物......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////发票号/////////////////////////////  
var InvoiceNoField = new Ext.form.TextField({
				fieldLabel: '发票号码',
				width:180,
				//allowBlank : false, 
				//disabled:true,
				value:InvoiceNo,
				anchor: '95%',
        //emptyText: '发表刊物......',
				selectOnFocus:'true',
				labelSeparator:''

			});
///////////////////是否ESI高被引/////////////////////////////  
var ESICitedField = new Ext.form.TextField({
				fieldLabel: '是否ESI高被引',
				width:180,
				allowBlank : false, 
				//disabled:true,
				value:ESICiteds,
				anchor: '95%',
               //emptyText: '是否ESI高被引......',
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
				text:'关闭',
				iconCls : 'cancel'
			});
			
			cancelHandler = function(){
				addwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			addwin = new Ext.Window({
				title: Titles+'--论文发表明细信息',
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


