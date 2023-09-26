base10EditFun = function() {
var rowObj = base10Main.getSelectionModel().getSelections();

	var len = rowObj.length;
	var tmpRowid = "";
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'����ѡ����Ҫ�޸ĵļ�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		tmpRowid = rowObj[0].get("rowid");
	}


var BonusTargetCodeField = new Ext.form.TextField({
	id: 'BonusTargetCodeField',
	name:'BonusTargetCode',
	fieldLabel: '����',
	allowBlank: false,
	emptyText: '����',
	anchor: '100%'
});

var BonusTargetNameField = new Ext.form.TextField({
	id: 'BonusTargetNameField',
	name:'BonusTargetName',
	fieldLabel: '����',
	allowBlank: false,
	emptyText: '����',
	anchor: '100%'
});

var TargetSpellField = new Ext.form.TextField({
	id: 'TargetSpellField',
	name:'TargetSpell',
	fieldLabel: 'ƴ����',
	emptyText: '',
	anchor: '100%'
});


var CalculateDescField = new Ext.form.TextField({
	id: 'CalculateDescField',
	name:'CalculateDesc',
	fieldLabel: '��ʽ����',
	emptyText: '',
	anchor: '100%'
});


var DataSourceSt = new Ext.data.ArrayStore({
	fields: ['rowid', 'name'],                
	data: 	[                                 
				['1',DataSourceValue[1]],            
				['2',DataSourceValue[2]],            
				['3',DataSourceValue[3]],            
				['4',DataSourceValue[4]],
				['9',DataSourceValue[9]],
				['10', DataSourceValue[10]],
				['11', DataSourceValue[11]],
				['12', DataSourceValue[12]],
				['13', DataSourceValue[13]],
				['14',DataSourceValue[14]]
				
			]                                 
});                                           

var DataSourceCombo = new Ext.form.ComboBox({
	fieldLabel:'������Դ',
	name:'DataSource',
	store: DataSourceSt,
	displayField:'name',
	allowBlank: false,
	valueField:'rowid',
	typeAhead: true,
	mode: 'local',
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'��ѡ',
	selectOnFocus:true,
	anchor: '100%'
});

var TargetPropertySt = new Ext.data.ArrayStore({
	fields: ['rowid', 'name'],                
	data: 	[                                 
				['1',TargetPropertyValue[1]],            
				['2',TargetPropertyValue[2]]
			]                                 
});                                           

var TargetPropertyCombo = new Ext.form.ComboBox({
	fieldLabel:'ָ������',
	name:'TargetProperty',
	store: TargetPropertySt,
	displayField:'name',
	allowBlank: false,
	valueField:'rowid',
	typeAhead: true,
	mode: 'local',
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'����',
	selectOnFocus:true,
	anchor: '100%'
});

var targetTypeCombo = new Ext.form.ComboBox({
	id: 'targetTypeCombo',
	name:'TargetTypeName',
	fieldLabel: 'ָ�����',
	anchor: '100%',
	//listWidth : 260,
	allowBlank: false,
	store: targetTypeComboDs,
	valueField: 'rowid',
	displayField: 'TargetTypeName',
	triggerAction: 'all',
	emptyText:'��ѡ',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var calUnitCombo = new Ext.form.ComboBox({
	id: 'calUnitCombo',
	name:'CalUnitName',
	fieldLabel: '������λ',
	anchor: '100%',
	//listWidth : 260,
	allowBlank: false,
	store: calUnitDs,
	valueField: 'rowid',
	displayField: 'CalUnitName',
	triggerAction: 'all',
	emptyText:'��ѡ',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var bonusTargetCombo = new Ext.form.ComboBox({
	id: 'bonusTargetCombo',
	name:'ParameterTargetName',
	fieldLabel: '����ָ��',
	anchor: '100%',
	//listWidth : 260,
	//allowBlank: false,
	store: bonusTargetDs,
	valueField: 'rowid',
	displayField: 'TargetNameType',
	triggerAction: 'all',
	emptyText:'',
	pageSize: 10,
	disabled:true,
	minChars: 1,
	selectOnFocus: true//,
	//forceSelection: true
});


var calStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [["0",'�޼���'],[1,'��Ա����'],[2,'���Ҽ���']]
		});
		var calField = new Ext.form.ComboBox({
			id: 'calField',
			fieldLabel: '���ݼ���',
			//listWidth : 231,
			selectOnFocus: true,
			allowBlank: true,
			store: calStore,
			anchor: '100%',
			//value:'new', //Ĭ��ֵ
			valueNotFoundText:rowObj[0].get("calFlagName"),
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'ѡ�����ݼ���...',
			mode: 'local', //����ģʽ
			editable:false,
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true
		});

var formulaTrgg = new Ext.form.TriggerField({
	fieldLabel:'��ʽ����',
	//disabled:true,
	name:'CalculateDesc',
	editable:false,
	hidden:true,
	emptyText:'��ʽ����',
	anchor: '100%'
});


formulaTrgg.onTriggerClick=function(){
	formula(1,this);
	
};


DataSourceCombo.on('select',function(combo, record, index){
	//alert(combo.getValue());
	tmpV=combo.getValue();
	if(tmpV==1){
		bonusTargetCombo.setDisabled(true);
		formulaTrgg.hide();
		formu='';
		formulaTrgg.setValue('');
	}else if(tmpV==2){
		bonusTargetCombo.setDisabled(true);
		formulaTrgg.show();
	}else if((tmpV == 3) ||(tmpV == 6)||(tmpV == 7)||(tmpV == 8)){
		bonusTargetCombo.setDisabled(false);
		formulaTrgg.hide();
		formu='';
		formulaTrgg.setValue('');
	}else if(tmpV==4){
		bonusTargetCombo.setDisabled(true);
		formulaTrgg.hide();
		formu='';
		formulaTrgg.setValue('');
	}
	
});
	
	var TargetDsecArea = new Ext.form.TextArea({
				id : 'TargetDsecArea',
				name : 'TargetDesc',
				fieldLabel : '����',
				emptyText : '',
				anchor : '100%'
			});
			
	var InitValueField = new Ext.form.NumberField({
				id : 'InitValueField',
				name : 'InitValue',
				decimalPrecision :6,
				fieldLabel : 'Ĭ��ֵ',
				emptyText : '',
				anchor : '100%'
			});
	
	var MaxValueField = new Ext.form.NumberField({
		id : 'MaxValueField',
		name : ' MaxValue',
		decimalPrecision :6,
		fieldLabel : '���ֵ',
		emptyText : '',
		anchor : '100%'
	});

	var rowObj = base10Main.getSelectionModel().getSelections();
	var len = rowObj.length;
	var tmpRowid = "";

	if(len < 1)
	{
		//Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		tmpRowid = rowObj[0].get("rowid");
	}

	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			BonusTargetCodeField,
			BonusTargetNameField,
			TargetSpellField,
			targetTypeCombo,//t1
			calUnitCombo,//t2
			DataSourceCombo,
			//��ʽ
			formulaTrgg,
			//TargetPropertyCombo = 2
			bonusTargetCombo,//t3
			calField,
			InitValueField,
			MaxValueField,
			TargetDsecArea
		]
	});
	
	var t1=rowObj[0].get("TargetTypeID");		//
	var t2=rowObj[0].get("CalUnitID");			//////////////////////////////////////////////////////////////////////////////////////////////////////
	var t3=rowObj[0].get("ParameterTarget");	//   
	if (t3.length>0) {
	bonusTargetCombo.setDisabled(false);
}
	                                                                                              //
	formPanel.on('afterlayout', function(panel, layout) {                                                                                           //
		this.getForm().loadRecord(rowObj[0]);                                                                                                       //
		 calField.setValue(rowObj[0].get('calFlagId'));
		MaxValueField.setValue(rowObj[0].get('MaxValue'));                                                                                                                                           //
	});                                                                                                                                             //
                                                                                                                                                    //
	var editWin = new Ext.Window({                                                                                                                  //
		title: '�޸�',                                                                                                                              //
		width: 300,                                                                                                                                 //
		height: 430,                                                                                                                                //
		layout: 'fit',                                                                                                                              //
		plain:true,                                                                                                                                 //
		modal:true,                                                                                                                                 //
		bodyStyle:'padding:5px;',                                                                                                                   //
		buttonAlign:'center',                                                                                                                       //
		items: formPanel,                                                                                                                           //
		buttons: [{                                                                                                                                 //
			id:'saveButton',                                                                                                                        //
			text: '����',                                                                                                                           //
			handler: function() {                                                                                                                   //
				if (formPanel.form.isValid()) {                 
					if((DataSourceCombo.getValue()==2)&&(formulaTrgg.getValue()=='')){
							Ext.Msg.show({title:'ע��',msg:'��ʽ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}				//
					var tmpCreatePerson=session['LOGON.USERCODE'];                                                                                  //
					var dt = new Date();                                                                                                            //
					dt=dt.format('Y-m-d');                                                                                                          //
					//BonusTargetCode|BonusTargetName^CalUnitID^TargetTypeID^TargetSpell^DataSource^TargetDesc^CalculateFormula^CalculateDesc       //
					//        *              *            *           *           *           *         ''           tmp''           *              //
					//CalculatePriority^TargetProperty^RateType^ParameterTarget^IsValid^AuditingState^AuditingDate^UpdateDate                       //
					//        tmp1           2            tmp1        *            1          0           ''           dt                           //
					if(targetTypeCombo.getValue()!=targetTypeCombo.getRawValue()){      //                                                          //
						t1=targetTypeCombo.getValue();                                  //                                                          //
					}                                                                   //                                                          //
					if(calUnitCombo.getValue()!=calUnitCombo.getRawValue()){            //                                                          //
						t2=calUnitCombo.getValue();                                     //////////////////////////////////////////////////////////////
					}                                                                   //
					if(bonusTargetCombo.getValue()!=bonusTargetCombo.getRawValue()){    //
						t3=bonusTargetCombo.getValue();                                 //
					}                                                                   //

					var tmpData=BonusTargetCodeField.getValue().trim()+"|"+BonusTargetNameField.getValue().trim()+"|"+t2+"|"+t1+"|"+TargetSpellField.getValue().trim();
					tmpData=tmpData
					+"|"+DataSourceCombo.getValue()
					+"|"+ TargetDsecArea.getValue()+"|"
					+encodeURIComponent(formu)+"|"
					+decodeURI(encodeURIComponent(formulaTrgg.getValue()))
					+"|1|1|1|"+t3+"|1|0||"+dt+"|"+calField.getValue()+ "|"
					+ InitValueField.getValue()+ "|"
					+ MaxValueField.getValue();
					//alert(tmpData);					
					
					
					Ext.Ajax.request({
						url: base10Url+'?action=base10edit&data='+tmpData+'&rowid='+tmpRowid,
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								base10Ds.load({params:{start:0, limit:base10PagingToolbar.pageSize}});
								editWin.close();
							}else{
								var tmpmsg='';
								if(jsonData.info=='1'){
									tmpmsg='�����ظ�!';
								}
								if(jsonData.info=='2'){
									tmpmsg='�����ظ�!';
								}
								Ext.Msg.show({title:'����',msg:tmpmsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
				else{
					Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		},
		{
			text: 'ȡ��',
			handler: function(){editWin.close();}
		}]
	});
	
	if(rowObj[0].get("DataSource")==2){
		formulaTrgg.show();
	}
	
	editWin.show();
};