edittypefun =function(){
	var rowObj=AcctCheckTypeBookGrid.getSelectionModel().getSelections();
	var len=rowObj.length;
	if(len==""){
		Ext.Msg.show({
			title:'ע��',
			msg:'��ѡ����Ҫ�޸ĵ����ݣ�',
			buttons:Ext.Msg.OK,
			icon:Ext.MessageBox.WARNING	
			
		});
		return;
	}else{
		var rowid =rowObj[0].get("rowid");
		var AcctBookID =rowObj[0].get("AcctBookID");
		var AcctBookName =rowObj[0].get("BookName");
		var AcctCheckTypeIDold =rowObj[0].get("AcctCheckTypeID");
		var AcctCheckTypeID =rowObj[0].get("AcctCheckTypeID");
		var AcctCheckTypeName =rowObj[0].get("CheckTypeName");
		var isValid =rowObj[0].get("isValid");
		var StartYear =rowObj[0].get("StartYear");
		var StartMonth =rowObj[0].get("StartMonth");
		var StartYearMonth=StartYear+"-"+StartMonth;
		// alert(StartYearMonth);
		var EndYear =rowObj[0].get("EndYear");
		var EndMonth =rowObj[0].get("EndMonth");
		var EndYearMonth=EndYear+"-"+EndMonth;
		// alert(rowid+"^"+AcctBookName+"^"+AcctCheckTypeName+"^"+isValid+"^"+StartYear+"^"+StartMonth);
	}
var AcctBookIDField = new Ext.form.TextField({
		id: 'StartYearField',
		fieldLabel: '��λ���ױ���',
		width:180,
		allowBlank: true,
		emptyText: '',
		anchor: '90%'
	});	
var AcctCheckTypeIDField = new Ext.form.TextField({
		id: 'StartYearField',
		fieldLabel: '�������ͱ���',
		width:180,
		allowBlank: true,
		emptyText: '',
		anchor: '90%'
	});	
	
/* //��λ�������ݼ�
var AcctBookNameeditProxy= new Ext.data.HttpProxy({
		url:CheckTypeUrl+'?action=AcctBookList'+'&AcctBookID='+acctbookid
});
var AcctBookNameeditDs = new Ext.data.Store({
		proxy:AcctBookNameeditProxy,
		reader:new Ext.data.JsonReader({
					root:'rows',
					totalProperty:'results'
		},['rowid','BookName']),
		remoteSort:true
});
	AcctBookNameeditDs.load({
		params:{
			start:0,
			limit:25
		}
	});
 */
var AcctBookNameeditField = new Ext.form.TextField({
		id: 'AcctBookNameeditField',
		name: 'AcctBookNameeditField',
		fieldLabel: '��λ��������',
		width:180,
		anchor: '90%',
		allowBlank : false,  
		disabled:true
});
	AcctBookNameeditField.on('select',function(combo, record, index){
		AcctBookID = combo.getValue();
	});

//��ƺ���������ݼ�
var CheckTypeeditProxy= new Ext.data.HttpProxy({
		url:CheckTypeUrl+'?action=CheckTypeList'	//+'&AcctBookID='+acctbookid
});
var CheckTypeeditDs = new Ext.data.Store({
		proxy:CheckTypeeditProxy,
		reader:new Ext.data.JsonReader({
					root:'rows',
					totalProperty:'results'
		},['rowid','CheckTypeName']),
		remoteSort:true
});
	CheckTypeeditDs.load({
		params:{
			start:0,
			limit:25
		}
	});

var CheckTypeeditField = new Ext.form.ComboBox({
		id: 'CheckTypeField',
		name: 'CheckTypeField',
		fieldLabel: '��ƺ������',
		store: CheckTypeeditDs,
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
		emptyText:'',
		selectOnFocus:true,
		forceSelection:true,
		valueNotFoundText:rowObj[0].get("CheckTypeName"),
		editable:true
});
	CheckTypeeditField.on('select',function(combo, record, index){
		AcctCheckTypeID = combo.getValue();
	});

//�Ƿ���Ч
var isValidStoreedit = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['0','��'],['1','��']]
});

var isValideditField=new Ext.form.ComboBox({
		id: 'isValideditField',
		name: 'isValideditField',
		fieldLabel: '�Ƿ���Ч',
		width:180,
		allowBlank: true,
		anchor: '90%',
		store: isValidStoreedit,
		valueField: 'key',
		displayField: 'keyValue',
		mode: 'local', // ����ģʽ
		emptyText:'��ѡ��...',
		// minChars: 15,
		// pageSize: 10,
		selectOnFocus: true,
		triggerAction: 'all',
		forceSelection:true,
		valueNotFoundText:rowObj[0].get("isValid"),
		editable:false
});

var StartYearMontheditField = new Ext.form.DateField({
		id: 'StartYearMontheditField',
		fieldLabel: '��������',
		value:"",
		format:'Y-m',
		plugins:'monthPickerPlugin',
		width:180,
		allowBlank: false,
		emptyMsg: '����...',
		triggerAction:'all',
		anchor: '90%'
	});

var EndYearMontheditField = new Ext.form.DateField({
		id: 'EndYearMontheditField',
		fieldLabel: 'ͣ������',
		value:StartYearMonth,
		format:'Y-m',
		plugins:'monthPickerPlugin',
		width:180,
		allowBlank: true,
		anchor: '90%'
	});
	
/* var StartYeareditField = new Ext.form.DateField({
		id: 'StartYearField',
		fieldLabel: '������',
		format:'Y',
		plugins:'monthPickerPlugin',
		width:180,
		allowBlank: false,
		emptyText: '�磺2016������...',
		valueNotFoundText:rowObj[0].get("StartYear"),
		anchor: '90%'
	}); 	
	
var StartMonthedit = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['01','01'],['02','02'],['03','03'],['04','04'],['05','05'],['06','06'],
			  ['07','07'],['08','08'],['09','09'],['10','10'],['11','11'],['12','12']
		]
});
var StartMontheditField = new Ext.form.ComboBox({
		id: 'StartMonthField',
		fieldLabel: '������',
		mode: 'local',
		store:StartMonthedit,
		displayField:'keyValue',
		valueField:'keyValue',
		width:180,
		allowBlank: false,
		emptyText: '�磺09������...',
		valueNotFoundText:rowObj[0].get("StartMonth"),
		triggerAction: 'all',
		forceSelection:true,
		selectOnFocus: true,
		anchor: '90%'
	});	
var EndYeareditField = new Ext.form.TextField({
		id: 'EndYearField',
		fieldLabel: 'ͣ����',
		width:180,
		allowBlank: true,
		emptyText: 'ͣ����...',
		valueNotFoundText:rowObj[0].get("EndYear"),
		anchor: '90%'
	});	
var EndMontheditField = new Ext.form.TextField({
		id: 'EndMonthField',
		fieldLabel: 'ͣ����',
		width:180,
		allowBlank: true,
		emptyText: 'ͣ����...',
		valueNotFoundText: rowObj[0].get("EndMonth"),
		anchor: '90%'
	});	
*/
var formPaneledit = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 100,
		labelAlign:'right',
		items: [
			AcctBookNameeditField,
			CheckTypeeditField,
			isValideditField,
			/* StartYeareditField,
			StartMontheditField,
			EndYeareditField,
			EndMontheditField */
			StartYearMontheditField,
			EndYearMontheditField
		]
});

//������
  formPaneledit.on('afterlayout', function(panel, layout) {                                                                                           //
		this.getForm().loadRecord(rowObj[0]); 
			
		AcctBookNameeditField.setValue(rowObj[0].get("BookName"));
		CheckTypeeditField.setValue(rowObj[0].get("AcctCheckTypeName"));	
		isValideditField.setValue(rowObj[0].get("isValid"));
		// StartYeareditField.setValue(rowObj[0].get("StartYear"));	
		// StartMontheditField.setValue(rowObj[0].get("StartMonth"));                                                                                              //
		// EndYeareditField.setValue(rowObj[0].get("EndYear"));	
		// EndMontheditField.setValue(rowObj[0].get("EndMonth"));
		StartYearMontheditField.setValue(StartYearMonth);
		EndYearMontheditField.setValue(EndYearMonth);
                                                                                                                    //
  });   
	
var editwindow= new Ext.Window({
		title: '���������޸�',
		width: 350,
		height:250,
		minWidth: 300,
		minHeight: 230,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:15px;',
		buttonAlign:'center',
		items: formPaneledit,
		buttons: [{
			text: '����',
			iconCls:'save',
			handler: function(){
				var rowid =rowObj[0].get("rowid");
				var booknameedit=parseInt(AcctBookID);//encodeURIComponent(AcctBookNameeditField.getValue());
				var checktypenameedit=AcctCheckTypeID;	//parseInt(AcctCheckTypeIDnew);	//encodeURIComponent(CheckTypeeditField.getValue());
				var isvalidedit=encodeURIComponent(isValideditField.getValue());
				// var startyearedit=StartYeareditField.getValue();
				// var startmonthedit=StartMontheditField.getValue();
				// var endyearedit=EndYeareditField.getValue();
				// var endmonthedit=EndMontheditField.getValue();
				// alert("�޸�"+booknameedit+"^"+checktypenameedit);
				var startyearmonth=StartYearMontheditField.getRawValue();
				var endyearmonth=EndYearMontheditField.getRawValue();
				
				if((checktypenameedit=="")||(startyearmonth=="")){
					Ext.Msg.show({
						title:'����',
						msg:'�����������ƻ��������²���Ϊ�գ�',
						buttons: Ext.Msg.OK,
						icon:Ext.MessageBox.ERROR
						});
						return;
					}
					var startyearedit=startyearmonth.substring(0,4);
					var startmonthedit=startyearmonth.substring(5,7);
					if(endyearmonth!=""){
						if(startyearmonth>endyearmonth&&startyearmonth!=endyearmonth){
							Ext.Msg.show({
								title:'����',
								msg:'ͣ�����²���С���������£�',
								buttons: Ext.Msg.OK,
								icon:Ext.MessageBox.ERROR
							});
							return;
						}
						var endyearedit=endyearmonth.substring(0,4);
						var endmonthedit=endyearmonth.substring(5,7);
					}else{
						var endyearedit="";
						var endmonthedit="";
					}	
					
			/* 	if(startyearmonth!=""){
					var startyearedit=startyearmonth.format('Y');
					var startmonthedit=startyearmonth.format('M');
					var startyearmonthedit=startyearedit+""+startmonthedit;
				}else{
					var startyearedit="";
					var startmonthedit="";
				}	
				if(endyearmonth!=""){
					var endyearedit=endyearmonth.format('Y');
					var endmonthedit=endyearmonth.format('M');
				}else{
					var endyearedit="";
					var endmonthedit="";
				}	 */
				
				var newdata='&rowid='+rowid+'&AcctBookID='+booknameedit+'&AcctCheckTypeID='+checktypenameedit+'&IsValid='+isvalidedit
					+'&StartYear='+startyearedit+'&StartMonth='+startmonthedit+'&EndYear='+endyearedit+'&EndMonth='+endmonthedit+'&AcctCheckTypeIDold='+AcctCheckTypeIDold;
				
				Ext.Ajax.request({
					url: CheckTypeUrl+'?action=TypeBookedit'+newdata,
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
									msg:'�޸ĳɹ�!',
									buttons: Ext.Msg.OK,
									icon:Ext.MessageBox.INFO
									});
									//ˢ�µ�ǰҳ
								var tbarnummain = AcctCheckTypeBookGrid.getBottomToolbar();  
									tbarnummain.doLoad(tbarnummain.cursor);
						  		/* CheckTypeBookDs.load({
									params:{
										start:0, 
										limit:25 
										}
									}); */
								CheckItemDs.load({
									params:{
										start:0, 
										limit:25,
										AcctCheckTypeID:checktypenameedit
										}
									});
									editwindow.close();
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
				// editwindow.close();
      		
				}
			},
		{
			text: 'ȡ��',
			iconCls:'back',
			handler: function(){
				editwindow.close();
				}
		}]
    
	});
    editwindow.show();	
			
};
