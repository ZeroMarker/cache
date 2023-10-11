FieldCoefficientAddFun = function() {

///////////////////��/////////////////////////////  
var aYearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


aYearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:FieldCoefficientUrl+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('aYearField').getRawValue()),method:'POST'});
});

var aYearField = new Ext.form.ComboBox({
	id: 'aYearField',
	fieldLabel: '���',
	width:180,
	listWidth : 250,
	allowBlank : false, 
	store:aYearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	anchor: '100%',
	//emptyText:'��ѡ��ʼʱ��...',
	name: 'aYearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	labelSeparator:'',
	editable:true
});

	//ϵͳģ���
var aSysModListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
aSysModListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : FieldCoefficientUrl+'?action=sysmodelist&str='+encodeURIComponent(Ext.getCmp('aSysModListField').getRawValue()),
						method : 'POST'
					});
		});
var aSysModListField = new Ext.form.ComboBox({
            id:'aSysModListField',
			name:'aSysModListField',
			fieldLabel : 'ϵͳģ��',
			width : 180,
			listWidth : 250,
			selectOnFocus : true,
			allowBlank : false,
			store : aSysModListDs,
			anchor : '100%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			// emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
			forceSelection : true
		});
		
		//�ֶ��б�
var aFieldListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
aFieldListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : FieldCoefficientUrl+'?action=fieldlist&sysmod='+aSysModListField.getValue()+'&str='+encodeURIComponent(Ext.getCmp('aFieldListField').getRawValue()),
						method : 'POST'
					});
		});
var aFieldListField = new Ext.form.ComboBox({
            id:'aFieldListField',
			name:'aFieldListField',
			fieldLabel : '�ֶ��б�',
			width : 180,
			listWidth : 250,
			selectOnFocus : true,
			allowBlank : false,
			store : aFieldListDs,
			anchor : '100%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
			forceSelection : true,
			listeners:{"select":function(combo,record,index){ 
				   	    Ext.Ajax.request({				   	    			        
                     url: FieldCoefficientUrl+'?action=fieldinfoslist&str='+encodeURIComponent(aFieldListField.getValue()),
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
						         if (jsonData.success=='true'){
							         var data = jsonData.info;	
							         var dataarr = data.split("|",-1);
							         var fieldcode = dataarr[1];
							         var fieldname = dataarr[2]; 			
							         var calcmethod = dataarr[3];	          
                                    aCodeField.setValue(fieldcode);  
                                    aNameField.setValue(fieldname);
									aCalcMethodField.setValue(calcmethod);
					         	}
				         	},
					       scope: this
				   	    });           
			        }}  
		});
//////////////////////����////////////////////		
	var aCodeField = new Ext.form.TextField({
				id : 'aCodeField',
				name : 'aCodeField',
				fieldLabel : '����',
				allowBlank : false,
				width : 180,
				//emptyText : '����',
				editable:false,
				labelSeparator:'',
				anchor : '100%'
			});
//////////////////////����////////////////////		
	var aNameField = new Ext.form.TextField({
				id : 'aNameField',
				name : 'aNameField',
				fieldLabel : '����',
				width : 180,
				allowBlank : false,
				//emptyText : '����',
				editable:false,
				labelSeparator:'',
				anchor : '100%'
			});
//////////////////////���㷽ʽ///////////////////		
/**
	var aCalcMethodField = new Ext.form.TextField({
				id : 'aCalcMethodField',
				name : 'aCalcMethodField',
				fieldLabel : '���㷽ʽ',
				allowBlank : false,
				//emptyText : '����',
				editable:false,
				anchor : '100%'
			});
**/			
			
			
 var aCalcMethodDs = new Ext.data.ArrayStore({
				fields : ['rowid', 'name'],
				data : [['1', '����ϵ����'], ['2', '��ʽ��'], ['3', '�ȱȲ�����'], ['4', '�ǵȱȲ�����'], ['5', '�оٷ�']]
			});

	var aCalcMethodField = new Ext.form.ComboBox({
				fieldLabel : '���㷽ʽ',
				id:'aCalcMethodField',
				name : 'aCalcMethodField',
				store : aCalcMethodDs,
				width : 180,
				displayField : 'name',
				allowBlank : false,
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				forceSelection : true,
				triggerAction : 'all',
				// emptyText : '��ѡ',
				selectOnFocus : true,
				labelSeparator:'',
				anchor : '100%'
			});

	aCalcMethodField.on('select', function(combo, record, index) {
				// alert(combo.getValue());
				tmpV = combo.getValue();
				if (tmpV == 1) {
				    aFieldValueField.setDisabled(true);
					aFieldMinValueField.setDisabled(true);
					aFieldMaxValueField.setDisabled(true);
					aStepSizeField.setDisabled(true);
					aIntervalCoefficientField.setDisabled(true);
					aMinValueField.setDisabled(true);
					aMaxValueField.setDisabled(true);
					
					aCalculateDescField.hide();
					formu = '';
					aCalculateDescField.setValue('');
				} else if (tmpV == 2) {
					//bonusTargetCombo.setDisabled(true);
					aFieldValueField.setDisabled(true);
					aFieldMinValueField.setDisabled(true);
					aFieldMaxValueField.setDisabled(true);
					aStepSizeField.setDisabled(true);
					aIntervalCoefficientField.setDisabled(true);
					aMinValueField.setDisabled(true);
					aMaxValueField.setDisabled(true);
					
					aCalculateDescField.show();
				} else if (tmpV == 3)  {
					aFieldValueField.setDisabled(true);
					aFieldMinValueField.setDisabled(false);
					aFieldMaxValueField.setDisabled(false);
					aStepSizeField.setDisabled(false);
					aIntervalCoefficientField.setDisabled(false);
					aMinValueField.setDisabled(true);
					aMaxValueField.setDisabled(true);
					
					aCalculateDescField.hide();
					formu = '';
					aCalculateDescField.setValue('');
				} else if (tmpV == 4) {
				    aFieldValueField.setDisabled(true);
					aFieldMinValueField.setDisabled(true);
					aFieldMaxValueField.setDisabled(true);
					aStepSizeField.setDisabled(true);
					aIntervalCoefficientField.setDisabled(true);
					aMinValueField.setDisabled(false);
					aMaxValueField.setDisabled(false);
					
					aCalculateDescField.hide();
					formu = '';
					aCalculateDescField.setValue('');
				}else if (tmpV == 5) {
				    aFieldValueField.setDisabled(false);
					aFieldMinValueField.setDisabled(true);
					aFieldMaxValueField.setDisabled(true);
					aStepSizeField.setDisabled(true);
					aIntervalCoefficientField.setDisabled(true);	
					aMinValueField.setDisabled(true);
					aMaxValueField.setDisabled(true);
					
					aCalculateDescField.hide();
					formu = '';
					aCalculateDescField.setValue('');
				}

			});			
///////////////////////////ϵ������ SRMFC_CoefficientType
var aCoefficientTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����ϵ��'],['2', '����']]
	});		
		
var aCoefficientTypeField = new Ext.form.ComboBox({
	                   id : 'aCoefficientTypeField',
					   name:'aCoefficientTypeField',
		           fieldLabel : 'ϵ������',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : aCoefficientTypeDs,
		           anchor : '100%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
				   labelSeparator:'',
		           forceSelection : true
						  });	
////////////////////SRMFC_DefaultValue   Ĭ��ֵ						  
var aDefaultValueField = new Ext.form.TextField({
				id : 'aDefaultValueField',
				name : 'aDefaultValueField',
				width : 180,
				fieldLabel : 'Ĭ��ֵ',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});						  
				  
////////////////////SRMFC_FourmulaDesc   ��ʽ����	
var aCalculateDescField = new Ext.form.TriggerField({
				fieldLabel : '��ʽ����',
				// disabled:true,
				editable : false,
				hidden : true,
				width : 180,
				// emptyText : '��ʽ����',
				labelSeparator:'',
				anchor : '100%'
			});

	aCalculateDescField.onTriggerClick = function() {
		formula(1, this);
	};
	
////////////////////SRMFC_FieldValue   �ֶζ�Ӧֵ---�����				  
var aFieldValueField = new Ext.form.TextField({
				id : 'aFieldValueField',
				name : 'aFieldValueField',
				fieldLabel : '�ֶζ�Ӧֵ',
				width : 180,
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});		
/**			
////////////////////SRMFC_FieldValue   �ֶζ�Ӧֵ---������					  	
var aFieldValueDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
aFieldValueDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : FieldCoefficientUrl+'?action=fieldvaluelist&str='+encodeURIComponent(Ext.getCmp('aFieldValueCombo').getRawValue())+'&fieldid='+encodeURIComponent(Ext.getCmp('aFieldListField').getValue()),
						method : 'POST'
					});
		});
var aFieldValueCombo = new Ext.form.ComboBox({
            id:'aFieldValueCombo',
			name:'aFieldValueCombo',
			fieldLabel : '�ֶζ�Ӧֵ',
			width : 195,
			listWidth : 250,
			selectOnFocus : true,
			allowBlank : false,
			store : aFieldValueDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
**/
	
////////////////////SRMFC_FieldMinValue	 �ȱ���Сֵ			  
var aFieldMinValueField = new Ext.form.TextField({
				id : 'aFieldMinValueField',
				name : 'aFieldMinValueField',
				fieldLabel : '�ȱ���Сֵ',
				width : 180,
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});								  
////////////////////SRMFC_FieldMaxValue	 �ȱ����ֵ			  
var aFieldMaxValueField = new Ext.form.TextField({
				id : 'aFieldMaxValueField',
				name : 'aFieldMaxValueField',
				fieldLabel : '�ȱ����ֵ',
				width : 180,
				labelSeparator:'',
				emptyText : '',
				anchor : '100%'
			});										  
////////////////////SRMFC_StepSize	 ����			  
var aStepSizeField = new Ext.form.TextField({
				id : 'aStepSizeField',
				name : 'aStepSizeField',
				width : 180,
				fieldLabel : '����',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});								  
////////////////////SRMFC_IntervalCoefficient	 �ȱȼ��		  
var aIntervalCoefficientField = new Ext.form.TextField({
				id : 'aIntervalCoefficientField',
				name : 'aIntervalCoefficientField',
				width : 180,
				fieldLabel : '�ȱȱ���ϵ��',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});										  
////////////////////SRMFC_MinValue	 �ǵȱ���Сֵ			  
var aMinValueField = new Ext.form.TextField({
				id : 'aMinValueField',
				name : 'aMinValueField',
				width : 180,
				fieldLabel : '�ǵȱ���Сֵ',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});							  
////////////////////SRMFC_MaxValue	 �ǵȱ����ֵ			  
var aMaxValueField = new Ext.form.TextField({
				id : 'aMaxValueField',
				name : 'aMaxValueField',
				width : 180,
				fieldLabel : '�ǵȱ����ֵ',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});								  
////////////////////SRMFC_Coefficient 	 ϵ��	
/**		  
var aCoefficientField = new Ext.form.TextField({
				id : 'aCoefficientField',
				name : 'aCoefficientField',
				fieldLabel : 'ϵ��',
				width : 150,
				emptyText : '',
				anchor : '100%'
			});			
**/
var aCoefficientField = new Ext.form.TriggerField({
                id : 'aCoefficientField',
				name : 'aCoefficientField',
				fieldLabel : 'ϵ��',
				// disabled:true,
				editable : false,
				//hidden : true,
				width : 180,
				//emptyText : '��ʽ����',
				labelSeparator:'',
				anchor : '100%'
			});
aCoefficientField.onTriggerClick = function() {
		formula(1, this);
	};			
var hiddenField = new Ext.form.TextField({
		id: 'hiddenField',
		fieldLabel: 'ϵ������',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		hidden:true,
		name: 'hiddenField',
		minChars: 1,
		pageSize: 10,
		labelSeparator:'',
		editable:true
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
								   aYearField,
                                   aSysModListField,
								   aFieldListField, 
								   aCalcMethodField,
								   aCoefficientTypeField,
								   aDefaultValueField, 
								   aCalculateDescField, 
								   aFieldValueField   					   
								]	 
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								   aFieldMinValueField, 
								   aFieldMaxValueField, 
								   aStepSizeField,
								   aIntervalCoefficientField,
								   aMinValueField, 
								   aMaxValueField, 
								   aCoefficientField   		
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

	var addWin = new Ext.Window({
		title : '�����ֶ�ϵ��',
		iconCls: 'edit_add',
		width : 640,
		height : 350,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{
			text : '����',
			iconCls: 'save', 
			handler : function() {
				if (formPanel.form.isValid()) {
					if ((aCalcMethodField.getValue() == 2)
							&& (aCalculateDescField.getValue() == '')) {
						Ext.Msg.show({
									title : 'ע��',
									msg : '��ʽ����Ϊ��!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.WARNING
								});
						return;
					}
					/**
					var tmpCreatePerson = session['LOGON.USERCODE'];
					var dt = new Date();
					dt = dt.format('Y-m-d');
                    **/
					var tmpData = encodeURIComponent(aSysModListField.getValue().trim()) + "|"
							+ encodeURIComponent(aCalcMethodField.getValue().trim()) + "|"
							+ encodeURIComponent(aFieldListField.getValue()) + "|"
							+ encodeURIComponent(aCoefficientTypeField.getValue()) + "|"
							+ encodeURIComponent(aDefaultValueField.getValue().trim())+"|"
							+ encodeURIComponent(aCalculateDescField.getValue())+ "|"
							+ encodeURIComponent(aFieldValueField.getValue())+ "|"
							+ encodeURIComponent(aFieldMinValueField.getValue())+ "|"
							+ encodeURIComponent(aFieldMaxValueField.getValue())+ "|"
							+ encodeURIComponent(aStepSizeField.getValue())+ "|"
							+ encodeURIComponent(aIntervalCoefficientField.getValue())+ "|"
							+ encodeURIComponent(aMinValueField.getValue())+ "|"
							+ encodeURIComponent(aMaxValueField.getValue())+ "|"
							+ encodeURIComponent(aCoefficientField.getValue())+"|"
							+ encodeURIComponent(hiddenField.getValue())+"|"
							+ encodeURIComponent(aYearField.getValue())+"|"
							/**
							+ decodeURI(encodeURIComponent(formulaTrgg.getValue())) 
							+ bonusTargetCombo.getValue() + "|1|0||" + dt + "|"
							+ calFlagField.getValue() + "|"
							+ InitValueField.getValue()+ "|"
							+ MaxValueField.getValue();
							**/
					// alert(tmpData);
					Ext.Ajax.request({
						url : FieldCoefficientUrl + '?action=add&data=' + tmpData,
						waitMsg : '������...',
						failure : function(result, request) {
							Ext.Msg.show({
										title : '����',
										msg : '������������!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : 'ע��',
											msg : '�����ɹ�!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
                        itemGrid.load({params:{start:0,limit:25}});		
						addWin.close();
								/**		
								base10Ds.load({
											params : {
												start : 0,
												limit : base10PagingToolbar.pageSize
											}
										});
								**/
							} else {
								Ext.Msg.show({
											title : '����',
											msg : tmpmsg,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
						},
						scope : this
					});
				} else {
				}
			}
		}, {
			text: '�ر�',
			iconCls: 'cancel',
			handler : function() {
				addWin.close();
			}
		}]

	});

	addWin.show();

};
