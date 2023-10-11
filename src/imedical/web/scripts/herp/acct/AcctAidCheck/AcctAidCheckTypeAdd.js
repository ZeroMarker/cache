addtypefun=function(){

//��λ�������ݼ�
/* var AcctBookNameProxy= new Ext.data.HttpProxy({
		url:CheckTypeUrl+'?action=AcctBookList'+'&AcctBookID='+acctbookid
});
var AcctBookNameDs = new Ext.data.Store({
		proxy:AcctBookNameProxy,
		reader:new Ext.data.JsonReader({
					root:'rows',
					totalProperty:'results'
		},['rowid','BookName']),
		remoteSort:true
});
	AcctBookNameDs.load({
		params:{
			start:0,
			limit:25
		}
	}); */



var AcctBookNameField = new Ext.form.TextField({
		id: 'AcctBookNameField',
		name: 'AcctBookNameField',
		fieldLabel: '��λ��������',
		width:180,
		anchor: '90%',
		allowBlank : false,  
		disabled:true
});

Ext.Ajax.request({
		url:CheckTypeUrl+'?action=AcctBookList'+'&AcctBookID='+acctbookid,
		method:'GET',
		success:function(response){
			var respText=Ext.decode(response.responseText);
			var str=respText.info;
			Ext.getCmp('AcctBookNameField').setValue(str);
		}
});

//��ƺ���������ݼ�
var CheckTypeProxy= new Ext.data.HttpProxy({
		url:CheckTypeUrl+'?action=CheckTypeList'	//+'&AcctBookID='+acctbookid
});
var CheckTypeDs = new Ext.data.Store({
		proxy:CheckTypeProxy,
		reader:new Ext.data.JsonReader({
					root:'rows',
					totalProperty:'results'
		},['rowid','CheckTypeName']),
		remoteSort:true
});
	CheckTypeDs.load({
		params:{
			start:0,
			limit:25
		}
	});

var CheckTypeField = new Ext.form.ComboBox({
		id: 'CheckTypeField',
		name: 'CheckTypeField',
		fieldLabel: '��ƺ������',
		store: CheckTypeDs,
		displayField: 'CheckTypeName',
		valueField: 'rowid',
		width:180,
		listWidth : 220,
		anchor: '90%',
		start:0,
		limit:100,
		pageSize : 10,
		minChars : 1,
		triggerAction : 'all',  
		allowBlank : false,  
		emptyText:'��ѡ...',
		selectOnFocus:true,
		forceSelection:true,	//����ѡ���б��е�ֵ
		editable:true
});

var isValidStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['0','��'],['1','��']]
});

var isValidField=new Ext.form.ComboBox({
		id: 'isValidField',
		name: 'isValidField',
		fieldLabel: '�Ƿ���Ч',
		width:180,
		listWidth : 220,
		selectOnFocus: true,
		allowBlank: true,
		store: isValidStore,
		anchor: '90%',
		valueField: 'key',
		displayField: 'keyValue',
		triggerAction: 'all',
		mode: 'local', // ����ģʽ
		emptyText:'��ѡ��...',
		minChars: 15,
		pageSize: 10,
		forceSelection:true,
		editable:true
});	
var StartYearMonthField = new Ext.form.DateField({
		id: 'StartYearMonthField',
		fieldLabel: '��������',
		width:180,
		format:'Y-m',
		value:new Date(),	
		plugins : 'monthPickerPlugin',
		allowBlank: false,
		// emptyText:new Date(),
		anchor: '90%'
	});	
/* var StartMonthField = new Ext.form.TextField({
		id: 'StartMonthField',
		fieldLabel: '������',
		width:180,
		allowBlank: false,
		emptyText: '�磺09������...',
		anchor: '90%'
	});	 */
var EndYearMonthField = new Ext.form.DateField({
		id: 'EndYearMonthField',
		fieldLabel: 'ͣ������',
		width:180,
		allowBlank: true,
		format:'Y-m',
		plugins : 'monthPickerPlugin',
		emptyText: 'ͣ������...',
		anchor: '90%'
	});	
/* var EndMonthField = new Ext.form.TextField({
		id: 'EndMonthField',
		fieldLabel: 'ͣ����',
		width:180,
		allowBlank: true,
		emptyText: 'ͣ����...',
		anchor: '90%'
	});	 */

var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 100,
		labelAlign:'right',
		lineHeight:25,
		items: [
			AcctBookNameField,
			CheckTypeField,
			// isValidField,
			StartYearMonthField
			// EndYearMonthField
		]
});
var addwindow= new Ext.Window({
		title: '�����������',
		width: 350,
		height:220,
		minWidth: 300,
		minHeight: 220,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:20px 10px 0 10px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '����',
			iconCls:'save',
			handler: function(){
				var bookid=acctbookid;	//ʵ��ȡ����BookName��Ӧ��ID
				var checktypeid=CheckTypeField.getValue();//ʵ��ȡ����CheckTypeName��Ӧ��ID
				// var isvalid=isValidField.getValue();
				var startyearmonth=StartYearMonthField.getRawValue();
				// var yearmonth=startyearmonth.split("-");
				var startyear=startyearmonth.substring(0,4);//yearmonth[0];
				var startmonth=startyearmonth.substring(5,7);
				// var endyearmonth=EndYearMonthField.getRawValue();
				// var endyear=endyearmonth.split("-",1);	
				// var endmonth=endyearmonth.split("-",2);
				// alert(startyear+"^"+startmonth);
				if((checktypeid=="")||(startyear=="")||(startmonth=="")){
					Ext.Msg.show({
						title:'����',
						msg:'��ƺ��������������²���Ϊ�գ�',
						buttons: Ext.Msg.OK,
						icon:Ext.MessageBox.ERROR
						});
						return;
					}
				var newdata='&AcctBookID='+bookid+'&AcctCheckTypeID='+checktypeid
					+'&StartYear='+startyear+'&StartMonth='+startmonth;		//+'&IsValid='+isvalid+'&EndYear='+endyear+'&EndMonth='+endmonth;
				
				Ext.Ajax.request({
					url: CheckTypeUrl+'?action=TypeBookadd'+newdata,
					failure: function(result, request) {
							Ext.Msg.show({
								title:'����',
								msg:'������������!',
								buttons: Ext.Msg.OK,
								icon:Ext.MessageBox.ERROR
								});
					},
					success: function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({
									title:'ע��',
									msg:'��ӳɹ�!',
									buttons: Ext.Msg.OK,
									icon:Ext.MessageBox.INFO
									});
						  		CheckTypeBookDs.load({
									params:{
										start:0, 
										limit:25 
										}
									});
								}else {
									var message = jsonData.info;
									Ext.Msg.show({
									title : '����',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
									});
								}
					},
					scope: this
				});
			//	addwindow.close();
      		
				}
			},
		{
			text: 'ȡ��',
			iconCls:'back',
			handler: function(){
				addwindow.close();
				}
		}]
    
	});
    addwindow.show();	
			
};
