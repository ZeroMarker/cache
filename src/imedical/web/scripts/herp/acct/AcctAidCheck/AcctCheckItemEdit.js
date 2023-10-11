edititemfun =function(){
	var rowObj=AcctCheckItemGrid.getSelectionModel().getSelections();
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
		var AcctCheckTypeID =rowObj[0].get("AcctCheckTypeID");
		var AcctCheckTypeName =rowObj[0].get("CheckTypeName");
		var CheckItemCode =rowObj[0].get("CheckItemCode");
		var CheckItemName =rowObj[0].get("CheckItemName");
		var IsValid =rowObj[0].get("IsValid");
		var StartDate =rowObj[0].get("StartDate");
		var EndDate =rowObj[0].get("EndDate");
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
	
var AcctBookNameeditField = new Ext.form.TextField({
		id: 'AcctBookNameeditField',
		name: 'AcctBookNameeditField',
		fieldLabel: '��λ��������',
		width:180,
		anchor: '90%',
		disabled:true
});
	AcctBookNameeditField.on('select',function(combo, record, index){
		AcctBookID = combo.getValue();
	});

//��ƺ���������ݼ�
var CheckTypeeditProxy= new Ext.data.HttpProxy({
		url:CheckTypeUrl+'?action=CheckTypeList'	
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
var CheckItemCodeField=new Ext.form.TextField({
		id: 'CheckItemCodeField',
		fieldLabel: '������Ŀ����',
		width:180,
		allowBlank: false,
		emptyText: '����...',
		valueNotFoundText:rowObj[0].get("CheckItemCode"),
		anchor: '90%',
		listeners : {
			specialKey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if (CheckItemCodeField.getValue() != "") {
						CheckItemNameField.focus();
					} else {
						Handler = function() {
							CheckItemCodeField.focus();
						}
						Ext.Msg.show({
							title : '��ʾ',
							msg : '������Ŀ���벻��Ϊ��! ',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING,
							fn : Handler
						});
					}
				}
			}
		}
});
var CheckItemNameField=new Ext.form.TextField({
		id: 'CheckItemNameField',
		fieldLabel: '������Ŀ����',
		width:220,
		allowBlank: false,
		emptyText: '����...',
		valueNotFoundText:rowObj[0].get("CheckItemName"),
		anchor: '90%',
		listeners : {
			specialKey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if (CheckItemNameField.getValue() != "") {
						IsValidField.focus();
					} else {
						Handler = function() {
							CheckItemNameField.focus();
						}
						Ext.Msg.show({
							title : '��ʾ',
							msg : '������Ŀ���Ʋ���Ϊ��! ',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING,
							fn : Handler
						});
					}
				}
			}
		}
});

var IsValidStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['0','��'],['1','��']]
});

var IsValidField=new Ext.form.ComboBox({
		id: 'IsValidField',
		name: 'IsValidField',
		fieldLabel: '�Ƿ���Ч',
		width:180,
		listWidth : 220,
		selectOnFocus: true,
		allowBlank: true,
		store: IsValidStore,
		anchor: '60%',
		valueField: 'key',
		displayField: 'keyValue',
		triggerAction: 'all',
		mode: 'local', // ����ģʽ
		emptyText:'��ѡ��...',
		minChars: 15,
		pageSize: 10,
		forceSelection:true,
		valueNotFoundText:rowObj[0].get("IsValid"),
		editable:false
});	
var StartDateField = new Ext.form.DateField({
		id: 'StartDateField',
		fieldLabel: '��ʼʱ��',
		width:180,
		// format:'Y-m-d',
		allowBlank: true,
		emptyText: '��ʼʱ��...',
		valueNotFoundText:rowObj[0].get("StartDate"),
		anchor: '60%'
	});	
var EndDateField = new Ext.form.DateField({
		id: 'EndDateField',
		fieldLabel: '��ֹʱ��',
		width:180,
		// format:'Y-m-d',
		allowBlank: true,
		emptyText: '��ֹʱ��...',
		valueNotFoundText:rowObj[0].get("EndDate"),
		anchor: '60%'
	});	
/* var OrgItemIDField = new Ext.form.TextField({
		id: 'OrgItemIDField',
		fieldLabel: 'ԭ��ID',
		width:180,
		allowBlank: true,
		emptyText: 'ԭ��ID...',
		valueNotFoundText:rowObj[0].get("OrgItemID"),
		anchor: '90%'
	});	
var SpellCodeField = new Ext.form.TextField({
		id: 'SpellCodeField',
		fieldLabel: 'ƴ����',
		width:180,
		allowBlank: true,
		emptyText: 'ƴ����...',
		valueNotFoundText:rowObj[0].get("SpellCode"),
		anchor: '90%'
	});	
 */
var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 100,
		labelAlign:'right',
		items: [
			AcctBookNameeditField,
			CheckTypeeditField,
			CheckItemCodeField,
			CheckItemNameField,
			IsValidField,
			StartDateField,
			EndDateField
			// OrgItemIDField,
			// SpellCodeField
		]
});

//������
  formPanel.on('afterlayout', function(panel, layout) {                                                                                           //
		this.getForm().loadRecord(rowObj[0]); 
			
		AcctBookNameeditField.setValue(rowObj[0].get("BookName"));
		CheckTypeeditField.setValue(rowObj[0].get("AcctCheckTypeName"));	
		CheckItemCodeField.setValue(rowObj[0].get("CheckItemCode"));
		CheckItemNameField.setValue(rowObj[0].get("CheckItemName"));	
		IsValidField.setValue(rowObj[0].get("IsValid"));
		StartDateField.setValue(rowObj[0].get("StartDate"));	
		EndDateField.setValue(rowObj[0].get("EndDate"));                                                                                              //
		// OrgItemIDField.setValue(rowObj[0].get("OrgItemID"));	
		// SpellCodeField.setValue(rowObj[0].get("SpellCode"));                                                                                              //
                                                                                                                    //
  });   
	
var editwindow= new Ext.Window({
		title: '��ƺ������ֵ��޸�',
		width: 400,
		height:300,
		minWidth: 300,
		minHeight: 300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:15px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '����',
			iconCls:'save',
			handler: function(){
				var rowid =rowObj[0].get("rowid");
				var booknameedit=parseInt(AcctBookID);//encodeURIComponent(AcctBookNameeditField.getValue());
				var checktypenameedit=parseInt(AcctCheckTypeID);	//encodeURIComponent(CheckTypeeditField.getValue());
				var checkitemcode=CheckItemCodeField.getValue();
				var checkitemname=encodeURIComponent(CheckItemNameField.getValue());
				var isvalid=encodeURIComponent(IsValidField.getValue());
				var startdate=StartDateField.getRawValue();
				var enddate=EndDateField.getRawValue();
				// alert(startdate+"^"+enddate);
				if(startdate.indexOf('/')!=-1){
					// ˵��ʱ���ʽ�ǣ�d/m/Y
					startdate= Date.parseDate(startdate,'j/n/Y').format('Y-m-d')
				}
				if(enddate.indexOf('/')!=-1){
					// ˵��ʱ���ʽ�ǣ�d/m/Y
					enddate= Date.parseDate(enddate,'j/n/Y').format('Y-m-d')
				}

				if((booknameedit=="")||(checktypenameedit=="")||(checkitemcode=="")||(checkitemname=="")){
					Ext.Msg.show({
						title:'����',
						msg:'�����������ơ�������Ŀ����ͺ�����Ŀ���Ʋ���Ϊ�գ�',
						buttons: Ext.Msg.OK,
						icon:Ext.MessageBox.ERROR
						});
						return;
					}
				if(startdate!=""&&enddate!=""){
					if(startdate>enddate&&startdate!=enddate){
						Ext.Msg.show({
							title:'����',
							msg:'��ʼʱ�䲻�ܴ�����ֹʱ�䣡',
							buttons: Ext.Msg.OK,
							icon:Ext.MessageBox.ERROR
						});
						return;
					}
				}else{
					if(startdate=="") startdate=="";
					if(enddate=="") enddate=="";
				}
				
				var newdata='&rowid='+rowid+'&AcctBookID='+booknameedit+'&AcctCheckTypeID='+checktypenameedit+'&CheckItemCode='+checkitemcode+'&CheckItemName='+checkitemname
							+'&IsValid='+isvalid+'&StartDate='+startdate+'&EndDate='+enddate; //+'&OrgItemID='+orgitemid+'&SpellCode='+spellcode;
				
				Ext.Ajax.request({
					url: CheckTypeUrl+'?action=CheckItemedit'+newdata,
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
								var tbarnum = AcctCheckItemGrid.getBottomToolbar();  
									tbarnum.doLoad(tbarnum.cursor);
						  		/* CheckItemDs.load({
									params:{
										start:this.bar.cursor, 
										limit:25 
										}
									}); */
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
