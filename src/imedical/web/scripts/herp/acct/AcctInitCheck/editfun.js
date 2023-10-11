editfun = function() {
		var userdr = session['LOGON.USERID'];//��¼��ID
		var projUrl = 'herp.acct.acctinitcheckexe.csp';
		var rowObj = itemGrid.getSelectionModel().getSelections();  
		var rowid=rowObj[0].get("rowid");
		/*var AcctCheckTypeID=rowObj[0].get("AcctCheckTypeID"); */
		//var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		//var len = rowObj.length;

//��ȡ��Ƹ����������//
var CheckTypeNameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

CheckTypeNameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAcctCheckType&str='+encodeURIComponent(Ext.getCmp('CheckTypeNameField').getValue()),method:'POST'});
});

var CheckTypeNameField = new Ext.form.ComboBox({
	id: 'CheckTypeNameField',
	fieldLabel: '������������',
	width:220,
	listWidth : 220,
	store: CheckTypeNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ���������...',
	minChars: 1,
	pageSize: 10,
	columnWidth : .1,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	name: 'CheckTypeName',
	listeners:{
		 select:function(combo,record,index){
			
			AcctCheckTypeID=CheckTypeNameField.getValue();
			//alert(AcctCheckTypeID)
			SubjNameDs.removeAll();
			Ext.getCmp('SubjCodeName').setRawValue()=='';
            Ext.getCmp('SubjCodeName').setValue()=='';
			SubjNameDs.proxy=new Ext.data.HttpProxy({url:projUrl+'?action=GetSubjName&str='+encodeURIComponent(Ext.getCmp('SubjCodeName').getValue())+'&CheckTypeID='+AcctCheckTypeID+'&acctbookid='+acctbookid,method:'POST'})
			SubjNameDs.load({params:{start:0,limit:10}});	
		     
			 CheckItemNameDs.removeAll();
			 CheckItemNameField.setValue('');
			 CheckItemNameDs.proxy=new Ext.data.HttpProxy({url:projUrl+'?action=GetTypeItemName&str='+encodeURIComponent(Ext.getCmp('CheckItemNameField').getRawValue())+'&CheckTypeID='+AcctCheckTypeID+'&acctbookid='+acctbookid,method:'POST'})
			 CheckItemNameDs.load({params:{start:0,limit:10}});	
		 }
	 }	
});



//��ȡ��ƿ�Ŀ//
var SubjNameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['SubjCode','SubjNameAll','SubjCodeNameAll'])
});
SubjNameDs.on('beforeload', function(ds, o){

	SubjNameDs.proxy=new Ext.data.HttpProxy({url:projUrl+'?action=GetSubjName&str='+encodeURIComponent(Ext.getCmp('SubjCodeName').getValue())+'&CheckTypeID='+AcctCheckTypeID+'&acctbookid='+acctbookid,method:'POST'})
});
var SubjCodeName = new Ext.form.ComboBox({
	id: 'SubjCodeName',
	fieldLabel: '��ƿ�Ŀ',
	width:220,
	listWidth : 265,
	allowBlank: true,
	store: SubjNameDs,
	valueField: 'SubjCode',
	displayField: 'SubjCodeNameAll',
	triggerAction: 'all',
	emptyText:'��ѡ���ƿ�Ŀ',
	name: 'SubjCodeName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners : {
				select:{
					fn:function(combo,record,index) { 
					Ext.Ajax.request({			        
						url: '../csp/herp.acct.acctinitcheckexe.csp?action=GetNumOrFc&SubjCode='+SubjCodeName.getValue()+'&acctbookid='+acctbookid,	
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );  
							if (jsonData.success=='true'){
								var data = jsonData.info;
								var bcodes = jsonData.info;
								var arr = bcodes.split("^");
								var IsNum=arr[0];
								var IsFc=arr[1];
								if(IsNum!=1){  //��������
									NumField.disable();  //������ֹ����
									PriceField.disable(); //���۽�ֹ����
									NumDebitField.disable();
									NumCreditField.disable();
									//�����������������Ŀ
									NumField.setValue('');
									PriceField.setValue('');
									NumDebitField.setValue('');
									NumCreditField.setValue('');
								}else{
									NumField.enable();
									PriceField.enable();
									NumDebitField.enable();
									NumCreditField.enable();
								};
								if(IsFc!=1){
									ExchRateField.disable(); //���ʽ�ֹ��д
									CurrNameField.disable();	//�������ͽ�ֹ��д
									AmtField.disable();			//��ҽ��
									AmtDebitField.disable();
									AmtCreditField.disable();
									//����������Ŀ����
									ExchRateField.setValue('');
									CurrNameField.setValue('');
									AmtField.setValue('');
									AmtDebitField.setValue('');
									AmtCreditField.setValue('');
								}else{
									ExchRateField.enable();
									CurrNameField.enable();
									AmtField.enable();
									AmtDebitField.enable();
									AmtCreditField.enable();
								};
						
							};
						},
					   scope: this
					});              
					}
                }	
				}
});


//��ȡ��������

var CheckItemNameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});
//��������
CheckItemNameDs.on('beforeload', function(ds, o){
	
	CheckItemNameDs.proxy=new Ext.data.HttpProxy({url:projUrl+'?action=GetTypeItemName&str='+encodeURIComponent(Ext.getCmp('CheckItemNameField').getRawValue())+'&CheckTypeID='+AcctCheckTypeID+'&acctbookid='+acctbookid,method:'POST'})
	
});
var CheckItemNameField = new Ext.form.ComboBox({
	id: 'CheckItemNameField',
	fieldLabel: '����������',
	width:220,
	listWidth : 220,
	allowBlank: true,
	store: CheckItemNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ����������',
	name: 'CheckItemName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//������
var SumField = new Ext.form.TextField({
	fieldLabel: '������',
	width:200,
	selectOnFocus : true
});	

//�ۼƽ跽���
var SumDebitField = new Ext.form.TextField({
	fieldLabel: '�ۼƽ跽���',
	width:200,
	selectOnFocus : true
});

//�ۼƴ������
var SumCreditField = new Ext.form.TextField({
	fieldLabel: '�ۼƴ������',
	width:200,
	selectOnFocus : true
});
/////////////////////////////����/////////////////////////////////////
//�������
var NumField = new Ext.form.TextField({
	fieldLabel: '�������',
	width:200,
	selectOnFocus : true
});	

//����
var PriceField = new Ext.form.TextField({
	fieldLabel: '��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��',
	width:200,
	selectOnFocus : true
});	

//�ۼƽ跽����
var NumDebitField = new Ext.form.TextField({
	fieldLabel: '�ۼƽ跽����',
	width:200,
	selectOnFocus : true
});

//�ۼƴ�������
var NumCreditField = new Ext.form.TextField({
	fieldLabel: '�ۼƴ�������',
	width:200,
	selectOnFocus : true
});

////////////////////////////���///////////////////////////

//������
var AmtField = new Ext.form.TextField({
	fieldLabel: '�����ҽ��',
	width:200,
	selectOnFocus : true
});	

//����
var ExchRateField = new Ext.form.TextField({
	fieldLabel: '��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��',
	width:200,
	enableKeyEvents:true,
	selectOnFocus : true
});

//�ۼƽ跽���
var AmtDebitField = new Ext.form.TextField({
	fieldLabel: '�ۼƽ跽��ҽ��',
	width:200,
	selectOnFocus : true
});

//�ۼƴ������
var AmtCreditField = new Ext.form.TextField({
	fieldLabel: '�ۼƴ�����ҽ��',
	width:200,
	selectOnFocus : true
});

ExchRateField.on('keyup',function(field,e,op){
	var Sum=SumField.getValue();
	if(Sum==""){
		Ext.Msg.show({
			title:'��ʾ',
			msg:'���������! ',
			buttons: Ext.Msg.OK,
			icon:Ext.MessageBox.WARNING
			
		});
		ExchRateField.setValue("");
		return;
	 }
	//alert(Sum+"*"+ExchRateField.getValue());
	//AmtField.setValue(Ext.util.Format.number(Sum/ExchRateField.getValue(), '0,000.0000'));

});

//�ύ��
var InitPuterField = new Ext.form.TextField({
	fieldLabel:'�ύ��',
	width:220,
	selectOnFocus : true,
	name:'InitPuter',
	editable:false
});	

//��ͬ���
var OrderIDField = new Ext.form.TextField({
	fieldLabel: '��ͬ���',
	width:220,
	name:'OrderID',
	selectOnFocus : true,
	editable:false
});	

//ҵ��������

var OccurDateField = new Ext.form.DateField({
	id : 'OccurDateField',
	name:'OccurDateField',
	fieldLabel: 'ҵ����ʱ��',
	//format : 'Y-m-d',
	width : 220,
	emptyText : '',
	value:new Date(),
	editable:true
});

//��ͬ��������

var OrderDateField = new Ext.form.DateField({
	id : 'OrderDateField',
	name:'OrderDateField',
	fieldLabel: '��ͬ��ֹ����',
	//format : 'Y-m-d',
	width : 220,
	emptyText : '',
	editable:true
});

//���������־
var IsNumField = new Ext.form.TextField({
	fieldLabel: '���������־',
	width:220,
	name:'IsNum',
	selectOnFocus : true,
	editable:false
});	
//��Һ����־
var IsFcField = new Ext.form.TextField({
	fieldLabel: '��Һ����־',
	width:220,
	name:'IsFc',
	selectOnFocus : true,
	editable:false
});	

		
//��ȡ��������

var CurrNameFieldDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});

CurrNameFieldDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetCurrName&str='+encodeURIComponent(Ext.getCmp('CurrNameField').getRawValue()),method:'POST'});
});

var CurrNameField = new Ext.form.ComboBox({
	id: 'CurrNameField',
	fieldLabel: '��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��',
	width:220,
	listWidth : 220,
	allowBlank: true,
	store: CurrNameFieldDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ���������',
	name: 'CurrName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//�޸����
var colItems=[{
	layout: 'column',
	border: false,
	defaults: {
		columnWidth: '.5',
		bodyStyle:'padding:5px 5px 0',
		border: false
	},            
	items: [{
		xtype: 'fieldset',
		autoHeight: true,
		labelWidth: 100,
		labelSeparator: " ",
		items: [{
			xtype : 'displayfield',
			value : '',
			columnWidth : .1
		},
			CheckTypeNameField,
			SubjCodeName, 
			CheckItemNameField,  
			//DirectionField,
			SumField,	
			SumDebitField,
			SumCreditField
			//OccurDateField,
			//OrderIDField,
			//OrderDateField
		]	 
	}, {
		xtype: 'fieldset',
		autoHeight: true,
		labelWidth: 120,
		labelSeparator: " ",
		items: [{
			xtype : 'displayfield',
			value : '',
			columnWidth : .1
		},
			NumField,
			//PriceField,
			NumDebitField,
			NumCreditField,
			//CurrNameField,
			//ExchRateField, 
			AmtField,
			AmtDebitField,
			AmtCreditField
		]
	}]
}]			
var formPanel = new Ext.form.FormPanel({
	//labelWidth: 100,
	frame: true,
	labelAlign: 'right',
	items: colItems
});
//������

formPanel.on('afterlayout', function(panel, layout){
	this.getForm().loadRecord(rowObj[0]);
	CheckTypeNameField.setValue(rowObj[0].get("CheckTypeName"));
	AcctCheckTypeID=rowObj[0].get("CheckTypeID")

	SubjCodeName.setValue(rowObj[0].get("SubjCodeName"));
	CheckItemNameField.setValue(rowObj[0].get("CheckItemName")); 
	//DirectionField.getValue(rowObj[0].get("Direction"));  
	NumField.setValue(rowObj[0].get("BeginNum"));
	NumDebitField.setValue(rowObj[0].get("TotalDebitNum"));
	NumCreditField.setValue(rowObj[0].get("TotalCreditNum"));
	//PriceField.getValue(rowObj[0].get("Price"));	
	//CurrNameField.getValue(rowObj[0].get("CurrName")); 
	AmtField.setValue(rowObj[0].get("BeginSumF")); 
	AmtDebitField.setValue(rowObj[0].get("TotalDebitSumF"));
	AmtCreditField.setValue(rowObj[0].get("TotalCreditSumF"));
	//ExchRateField.getValue(rowObj[0].get("ExchRate")); 
	//OrderIDField.getValue(rowObj[0].get("OrderID")); 
// ���ڿؼ��Ļ�ȡ ʾ����	PSField.setValue(rowObj[0].get("plansdate"));
	//OccurDateField.setValue(rowObj[0].get("OccurDate")); 
	//OrderDateField.setValue(rowObj[0].get("OrderDate"));
			 
	SumField.setValue(rowObj[0].get("BeginSum")); 
	SumDebitField.setValue(rowObj[0].get("TotalDebitSum")); 
	SumCreditField.setValue(rowObj[0].get("TotalCreditSum")); 
	IsFcField.getValue(rowObj[0].get("IsFc"));
	IsNumField.getValue(rowObj[0].get("IsNum"));
			
	var SubjCode=SubjCodeName.getValue();
			
	if(SubjCode==rowObj[0].get("SubjCodeName")){
		SubjCode="";
		//alert(rowObj[0].get("IsNum"))
		if((rowObj[0].get("IsNum"))!=1){
			NumField.disable();
			PriceField.disable();
			NumDebitField.disable();
			NumCreditField.disable();
			//���������������Ŀ
			NumField.setValue('');
			PriceField.setValue('');
			NumDebitField.setValue('');
			NumCreditField.setValue('');
		}else{
			NumField.enable();
			PriceField.enable();
			NumDebitField.enable();
			NumCreditField.enable();
		};
		if((rowObj[0].get("IsFc"))!=1){
			ExchRateField.disable();
			CurrNameField.disable();
			AmtField.disable();
			AmtDebitField.disable();
			AmtCreditField.disable();
			//��շ������Ŀ
			ExchRateField.setValue('');
			CurrNameField.setValue('');
			AmtField.setValue('');
			AmtDebitField.setValue('');
			AmtCreditField.setValue('');	
		}else{
			ExchRateField.enable();
			CurrNameField.enable();
			AmtField.enable();
			AmtDebitField.enable();
			AmtCreditField.enable();				
		} ;
	}else {
		Ext.Ajax.request({			        
			url: '../csp/herp.acct.acctinitcheckexe.csp?action=GetNumOrFc&SubjCode='+SubjCodeName.getValue()+'&acctbookid='+acctbookid,	
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );  
				if (jsonData.success=='true'){
					var data = jsonData.info;
					var bcodes = jsonData.info;
					var arr = bcodes.split("^");
					var IsNum=arr[0];
					var IsFc=arr[1];
					if(IsNum!=1){
						NumField.disable();
						PriceField.disable();
						NumDebitField.disable();
						NumCreditField.disable();
						//���������������Ŀ
						NumField.setValue('');
						PriceField.setValue('');
						NumDebitField.setValue('');
						NumCreditField.setValue('');
					}else{
						NumField.enable();
						PriceField.enable();
						NumDebitField.enable();
						NumCreditField.enable();
					};
					if(IsFc!=1){
						ExchRateField.disable();
						CurrNameField.disable();
						AmtField.disable();
						AmtDebitField.disable();
						AmtCreditField.disable();
						//��շ������Ŀ
						ExchRateField.setValue('');
						CurrNameField.setValue('');
						AmtField.setValue('');
						AmtDebitField.setValue('');
						AmtCreditField.setValue('');	
					}else{
						ExchRateField.enable();
						CurrNameField.enable();
						AmtField.enable();
						AmtDebitField.enable();
						AmtCreditField.enable();
					};				
				};
			},
			scope: this
		});
	}
});
		
//addwin����Ӱ�ť
addButton = new Ext.Toolbar.Button({
		text:'����',
		iconCls:'save'
	});
	
addHandler = function(){      			
				
	var CheckTypeID		= 	CheckTypeNameField.getValue();
	var SubjCode 		=	SubjCodeName.getValue();
	var CheckItemID		= 	CheckItemNameField.getValue();  
				
	//�����������ȡֵ�����û�и����� ��Ϊ��,���� ��̨ ȡ
	if(CheckTypeID==rowObj[0].get("CheckTypeName")){CheckTypeID=""}
	//���û��
	if(SubjCode==rowObj[0].get("SubjCodeName")){SubjCode=""}
				
	if(CheckItemID==rowObj[0].get("CheckItemName")){CheckItemID=""}
	var Sum 			=	SumField.getValue(); 
	var SumDebit        =   SumDebitField.getValue();
	var SumCredit		=	SumCreditField.getValue();
	var Num				=	NumField.getValue();
	var NumDebit        =   NumDebitField.getValue();
	var NumCredit       =   NumCreditField.getValue();
	var Price			=	PriceField.getValue();	
	var CurrCode		= 	CurrNameField.getValue();
	var CurrCodeText	=	CurrNameField.getRawValue();
				
	var AmtF 			= 	AmtField.getValue(); 
	var AmtDebit        =   AmtDebitField.getValue();
	var AmtCredit		=	AmtCreditField.getValue();
	var ExchRate 		= 	ExchRateField.getValue(); 
	var OrderID			=	OrderIDField.getValue(); 
	var OccurDateTime 		=	OccurDateField.getValue(); 
	if (OccurDateTime!==""){
	  	var OccurDate=OccurDateTime.format ('Y-m-d');
	}
	else {
		var OccurDate="" 
	};
	var OrderDateTime 		=	OrderDateField.getValue();
	if (OrderDateTime!==""){
	   	var OrderDate=OrderDateTime.format ('Y-m-d');
	}
	else{
		var OrderDate="" 
	};
								
	if (CheckTypeNameField.getRawValue()==""){
		Ext.Msg.show({title:'��ʾ',msg:' ��ƺ��������Ϊ�� ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
				
	if(CurrNameField.getRawValue()==""){
		 CurrCode="";
	}else{
		CurrCode=CurrCodeText;
	}
				
	Ext.Ajax.request({
		url: '../csp/herp.acct.acctinitcheckexe.csp?action=update&rowid='+rowid+'&CheckTypeID='+CheckTypeID+'&CheckItemID='+CheckItemID+'&SubjCode='+encodeURIComponent(SubjCode)+'&Num='+Num+'&Price='+Price+'&CurrCode='+encodeURIComponent(CurrCode)+'&AmtF='+AmtF+'&ExchRate='+ExchRate+'&OrderID='+encodeURIComponent(OrderID)+'&OccurDate='+OccurDate+'&OrderDate='+OrderDate+'&Sum='+Sum+'&acctbookid='+acctbookid+'&SumDebit='+SumDebit+'&SumCredit='+SumCredit+'&NumDebit='+NumDebit+'&NumCredit='+NumCredit+'&AmtDebit='+AmtDebit+'&AmtCredit='+AmtCredit,
		waitMsg:'������...',
		failure: function(result, request){
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );					
			if (jsonData.success=='true'){
				Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
				itemGrid.load({params:{start:0,limit:25,userdr:userdr,acctbookid:acctbookid}});			
			}else if (jsonData.success == 'false'){
				var information = jsonData.info;
				if (information == "RecordExist"){
					Ext.Msg.show({title: '��ʾ',msg: '�������Ѵ��ڣ�������޸�! ',
						buttons: Ext.Msg.OK,icon: Ext.MessageBox.INFO});
				}else{
					Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		},
		scope: this
	});
	editwin.close();		
}

	////// ��Ӽ����¼� ////////////////	
addButton.addListener('click',addHandler,false);


///addwin��ȡ����ť
cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��',
			iconCls:'back'
		});
cancelHandler = function(){
			editwin.close();
		}
cancelButton.addListener('click',cancelHandler,false);

editwin = new Ext.Window({
			title: '�޸ļ�¼',
			width: 720,
			height: 325,
			//autoHeight: true,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});		
editwin.show();			
}

   				
			