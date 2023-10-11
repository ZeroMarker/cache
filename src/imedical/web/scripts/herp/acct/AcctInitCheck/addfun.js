addfun = function() {
	
		var userdr = session['LOGON.USERID'];//��¼��ID
		var projUrl = 'herp.acct.acctinitcheckexe.csp';
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
	url:projUrl+'?action=GetAcctCheckType&str='+encodeURIComponent(Ext.getCmp('CheckTypeNameField').getRawValue()),method:'POST'});
});
var CheckTypeNameField = new Ext.form.ComboBox({
	id: 'CheckTypeNameField',
	fieldLabel: '������������',
	width:200,
	listWidth : 250,
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
	listeners:{
		"select":function(combo,record,index){
			SubjNameDs.removeAll();
			SubjNameField1.setValue('');
			SubjNameDs.proxy=new Ext.data.HttpProxy({url:projUrl+'?action=GetSubjName&str='+encodeURIComponent(Ext.getCmp('SubjNameField1').getRawValue())+'&CheckTypeID='+combo.value+'&acctbookid='+acctbookid,method:'POST'})
			SubjNameDs.load({params:{start:0,limit:10}});	
			
			
			CheckItemNameDs.removeAll();
			CheckItemNameField.setValue('');
			CheckItemNameDs.proxy=new Ext.data.HttpProxy({url:projUrl+'?action=GetTypeItemName&str='+encodeURIComponent(Ext.getCmp('CheckItemNameField').getRawValue())+'&CheckTypeID='+combo.value+'&acctbookid='+acctbookid,method:'POST'})
			CheckItemNameDs.load({params:{start:0,limit:10}});		
		
			Ext.Ajax.request({			        
				url: '../csp/herp.acct.acctinitcheckexe.csp?action=GetfIsFinishInit&&CheckTypeID='+combo.value+'&acctbookid='+acctbookid,	
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );  
					if (jsonData.success=='true'){
						var data = jsonData.info;
						var bcodes = jsonData.info;
						var arr = bcodes.split("^");
						var CheckTypeID=arr[0];
						var IsFinishInit=arr[1];
						if(IsFinishInit==1){
							Ext.Msg.show({title:'����',msg:'���ศ�����ѳ�ʼ����ɣ�������ӣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							SubjNameField1.disable();
							CheckItemNameField.disable();
							NumField.disable();
							NumDebitField.disable();
							NumCreditField.disable();
							PriceField.disable();
							CurrNameField.disable();
							AmtField.disable();
							AmtDebitField.disable();
							AmtCreditField.disable();
							ExchRateField.disable();
							OrderIDField.disable();
							OccurDateField.disable();
							OrderDateField.disable();
							SumField.disable();		
							SumDebitField.disable();		
							SumCreditField.disable();
						}else{
							SubjNameField1.enable();
							CheckItemNameField.enable();
							//NumField.enable();
							//PriceField.enable();
							//CurrNameField.enable();
							//AmtField.enable();
							//ExchRateField.enable();
							//OrderIDField.enable();
							//OccurDateField.enable();
							//OrderDateField.enable();
							SumField.enable();
							SumDebitField.enable();		
							SumCreditField.enable();
						};						
					};
				},
				scope: this
			});		
		}
	}	
});

//��ȡ��ƿ�Ŀ//
var SubjNameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['SubjCode','SubjNameAll','SubjCodeNameAll'])
});
SubjNameDs.on('beforeload', function(ds, o){	
	var CheckTypeID=CheckTypeNameField.getValue();
	if(!CheckTypeID){
		Ext.Msg.show({title:'ע��',msg:'����ѡ��������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
});
var SubjNameField1 = new Ext.form.ComboBox({
	id: 'SubjNameField1',
	fieldLabel: '��ƿ�Ŀ',
	width:200,
	listWidth : 250,
	//allowBlank : false,
	store: SubjNameDs,
	valueField: 'SubjCode',
	displayField: 'SubjCodeNameAll',
	triggerAction: 'all',
	emptyText:'��ѡ���ƿ�Ŀ',
	name: 'SubjNameField1',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners : {
		select:{
			fn:function(combo,record,index) { 
				Ext.Ajax.request({			        
					url: '../csp/herp.acct.acctinitcheckexe.csp?action=GetNumOrFc&SubjCode='+SubjNameField1.getValue()+'&acctbookid='+acctbookid,	
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
	var CheckTypeID=CheckTypeNameField.getValue();
	if(!CheckTypeID){
		Ext.Msg.show({title:'ע��',msg:'����ѡ��������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
});
var CheckItemNameField = new Ext.form.ComboBox({
	id: 'CheckItemNameField',
	fieldLabel: '����������',
	width:200,
	listWidth : 250,
	store: CheckItemNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ����������',
	name: 'CheckItemNameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	//allowBlank : false,
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
	width:200,
	selectOnFocus : true,
	editable:false
});	

//��ͬ���
var OrderIDField = new Ext.form.TextField({
	fieldLabel: '��ͬ���',
	width:200,
	selectOnFocus : true,
	allowBlank : false,
	editable:false
});	

//ҵ��������
var OccurDateField = new Ext.form.DateField({
	id : 'OccurDateField',
	fieldLabel: 'ҵ����ʱ��',
	//format : 'Y-m-d',
	width : 200,
	emptyText : '',
	value: new Date(),
	editable:true
});

//��ͬ��������
var OrderDateField = new Ext.form.DateField({
	id : 'OrderDateField',
	fieldLabel: '��ͬ��ֹ����',
	//format : 'Y-m-d',
	width : 200,
	emptyText : '',
	//value: new Date(),
	editable:true
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
	width:200,
	listWidth : 220,
	store: CurrNameFieldDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ���������',
	name: 'CurrNameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	allowBlank : true,
	forceSelection:'true',
	editable:true
});

//��ʼ����־
var IsFinishInitField = new Ext.form.TextField({
	fieldLabel: '��ʼ����־',
	width:200,
	name:'IsFinishInit',
	selectOnFocus : true,
	editable:false
});	

//������
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
			SubjNameField1, 
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
	
//addwin����Ӱ�ť
addButton = new Ext.Toolbar.Button({
	text:'����',
	iconCls:'save'
});
			
//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
addHandler = function(){      							
	var CheckTypeID		= 	CheckTypeNameField.getValue();
	var SubjCode 		=	SubjNameField1.getValue();
	var CheckItemID		= 	CheckItemNameField.getValue();  
	var Sum 			=	SumField.getValue(); 				
	var SumDebit        =   SumDebitField.getValue();
	var SumCredit		=	SumCreditField.getValue();
	var Num				=	NumField.getValue();
	var NumDebit        =   NumDebitField.getValue();
	var NumCredit       =   NumCreditField.getValue();
	var Price			=	PriceField.getValue();	
	var CurrCode		= 	CurrNameField.getValue(); 
	var AmtF 			= 	AmtField.getValue(); 
	var AmtDebit        =   AmtDebitField.getValue();
	var AmtCredit		=	AmtCreditField.getValue();
	var ExchRate 		= 	ExchRateField.getValue(); 
	var OrderID			=	OrderIDField.getValue(); 
	var OccurDateTime 	=	OccurDateField.getValue(); 
	if (OccurDateTime!=="")
	{
		var OccurDate=OccurDateTime.format ('Y-m-d');
	}else {
		var OccurDate="" 
	};
	var OrderDateTime 	=	OrderDateField.getValue();
	if (OrderDateTime!=="")
	{
		var OrderDate=OrderDateTime.format ('Y-m-d');
	}else{
		var OrderDate="" 
	};
	var userdr 			= 	session['LOGON.USERID']; 
	
	if ((CheckTypeID=="")||(SubjCode=="")||(CheckItemID=="")){
		Ext.Msg.show({title:'��ʾ',msg:' ������������/��ƿ�Ŀ/��������������ɿ� ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
				
	if ((Sum=="")){
		Ext.MessageBox.confirm('��ʾ', '���Ϊ��,�Ƿ����?', 
			function(btn) {
				if(btn == 'yes'){ Ext.Ajax.request({
					url: '../csp/herp.acct.acctinitcheckexe.csp?action=add&CheckTypeID='+CheckTypeID+'&CheckItemID='+CheckItemID+'&SubjCode='+encodeURIComponent(SubjCode)+'&Num='+Num+'&Price='+Price+'&CurrCode='+CurrCode+'&AmtF='+AmtF+'&ExchRate='+ExchRate+'&OrderID='+OrderID+'&OccurDate='+OccurDate+'&OrderDate='+OrderDate+'&Sum='+Sum+'&acctbookid='+acctbookid+'&SumDebit='+SumDebit+'&SumCredit='+SumCredit+'&NumDebit='+NumDebit+'&NumCredit='+NumCredit+'&AmtDebit='+AmtDebit+'&AmtCredit='+AmtCredit,
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
									 itemGrid.load({params:{start:0,limit:25,acctbookid:acctbookid,userdr:userdr}});		
						}else if (jsonData.success == 'false'){
							var information = jsonData.info;
							if (information == "RecordExist"){
								Ext.Msg.show({title: '��ʾ',msg: '�������Ѵ��ڣ�������޸�! ',
									buttons: Ext.Msg.OK,icon: Ext.MessageBox.INFO});
							}else{
								Ext.Msg.show({title:'����',msg:'��Ӵ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						}
					},
					scope: this
				});
				//addwin.close();
				}else{
					return;
				}
			});
	}else{
		Ext.Ajax.request({
			url: '../csp/herp.acct.acctinitcheckexe.csp?action=add&CheckTypeID='+CheckTypeID+'&CheckItemID='+CheckItemID+'&SubjCode='+encodeURIComponent(SubjCode)+'&Num='+Num+'&Price='+Price+'&CurrCode='+CurrCode+'&AmtF='+AmtF+'&ExchRate='+ExchRate+'&OrderID='+OrderID+'&OccurDate='+OccurDate+'&OrderDate='+OrderDate+'&Sum='+Sum+'&acctbookid='+acctbookid+'&SumDebit='+SumDebit+'&SumCredit='+SumCredit+'&NumDebit='+NumDebit+'&NumCredit='+NumCredit+'&AmtDebit='+AmtDebit+'&AmtCredit='+AmtCredit,
			waitMsg:'������...',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );		
				if (jsonData.success=='true'){							
					Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					 itemGrid.load({params:{start:0,limit:25}});		
				}else if (jsonData.success == 'false'){
					var information = jsonData.info;
					if (information == "RecordExist"){
						Ext.Msg.show({title: '��ʾ',msg: '�������Ѵ��ڣ�������޸�! ',
							buttons: Ext.Msg.OK,icon: Ext.MessageBox.INFO});
					}else{
						Ext.Msg.show({title:'����',msg:'��Ӵ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				}
			},
			scope: this
		});
		//addwin.close();
	}
}
  
////// ��Ӽ����¼� ////////////////	
addButton.addListener('click',addHandler,false);

//addwin��ȡ����ť
cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��',
			iconCls:'back'
		});
cancelHandler = function(){
			addwin.close();
		}
cancelButton.addListener('click',cancelHandler,false);

addwin = new Ext.Window({
			title: '���Ӽ�¼',
			width: 720,
			height: 300,
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
addwin.show();
//���ش���,��ֹ������Ŀ
NumField.disable();
PriceField.disable();
NumDebitField.disable();
NumCreditField.disable();
CurrNameField.disable();
AmtField.disable();
ExchRateField.disable();			
AmtDebitField.disable();
AmtCreditField.disable();
}


