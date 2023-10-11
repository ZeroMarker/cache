FieldCoefficientAddFun = function() {

///////////////////年/////////////////////////////  
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
	fieldLabel: '年度',
	width:180,
	listWidth : 250,
	allowBlank : false, 
	store:aYearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	anchor: '100%',
	//emptyText:'请选择开始时间...',
	name: 'aYearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	labelSeparator:'',
	editable:true
});

	//系统模块号
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
			fieldLabel : '系统模块',
			width : 180,
			listWidth : 250,
			selectOnFocus : true,
			allowBlank : false,
			store : aSysModListDs,
			anchor : '100%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			// emptyText : '',
			//mode : 'local', // 本地模式
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
			forceSelection : true
		});
		
		//字段列表
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
			fieldLabel : '字段列表',
			width : 180,
			listWidth : 250,
			selectOnFocus : true,
			allowBlank : false,
			store : aFieldListDs,
			anchor : '100%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // 本地模式
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
//////////////////////编码////////////////////		
	var aCodeField = new Ext.form.TextField({
				id : 'aCodeField',
				name : 'aCodeField',
				fieldLabel : '编码',
				allowBlank : false,
				width : 180,
				//emptyText : '必填',
				editable:false,
				labelSeparator:'',
				anchor : '100%'
			});
//////////////////////名称////////////////////		
	var aNameField = new Ext.form.TextField({
				id : 'aNameField',
				name : 'aNameField',
				fieldLabel : '名称',
				width : 180,
				allowBlank : false,
				//emptyText : '必填',
				editable:false,
				labelSeparator:'',
				anchor : '100%'
			});
//////////////////////计算方式///////////////////		
/**
	var aCalcMethodField = new Ext.form.TextField({
				id : 'aCalcMethodField',
				name : 'aCalcMethodField',
				fieldLabel : '计算方式',
				allowBlank : false,
				//emptyText : '必填',
				editable:false,
				anchor : '100%'
			});
**/			
			
			
 var aCalcMethodDs = new Ext.data.ArrayStore({
				fields : ['rowid', 'name'],
				data : [['1', '比例系数法'], ['2', '公式法'], ['3', '等比步长法'], ['4', '非等比步长法'], ['5', '列举法']]
			});

	var aCalcMethodField = new Ext.form.ComboBox({
				fieldLabel : '计算方式',
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
				// emptyText : '必选',
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
///////////////////////////系数类型 SRMFC_CoefficientType
var aCoefficientTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '比例系数'],['2', '基数']]
	});		
		
var aCoefficientTypeField = new Ext.form.ComboBox({
	                   id : 'aCoefficientTypeField',
					   name:'aCoefficientTypeField',
		           fieldLabel : '系数类型',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : aCoefficientTypeDs,
		           anchor : '100%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
				   labelSeparator:'',
		           forceSelection : true
						  });	
////////////////////SRMFC_DefaultValue   默认值						  
var aDefaultValueField = new Ext.form.TextField({
				id : 'aDefaultValueField',
				name : 'aDefaultValueField',
				width : 180,
				fieldLabel : '默认值',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});						  
				  
////////////////////SRMFC_FourmulaDesc   公式描述	
var aCalculateDescField = new Ext.form.TriggerField({
				fieldLabel : '公式设置',
				// disabled:true,
				editable : false,
				hidden : true,
				width : 180,
				// emptyText : '公式设置',
				labelSeparator:'',
				anchor : '100%'
			});

	aCalculateDescField.onTriggerClick = function() {
		formula(1, this);
	};
	
////////////////////SRMFC_FieldValue   字段对应值---输入框				  
var aFieldValueField = new Ext.form.TextField({
				id : 'aFieldValueField',
				name : 'aFieldValueField',
				fieldLabel : '字段对应值',
				width : 180,
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});		
/**			
////////////////////SRMFC_FieldValue   字段对应值---下拉框					  	
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
			fieldLabel : '字段对应值',
			width : 195,
			listWidth : 250,
			selectOnFocus : true,
			allowBlank : false,
			store : aFieldValueDs,
			//anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // 本地模式
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
**/
	
////////////////////SRMFC_FieldMinValue	 等比最小值			  
var aFieldMinValueField = new Ext.form.TextField({
				id : 'aFieldMinValueField',
				name : 'aFieldMinValueField',
				fieldLabel : '等比最小值',
				width : 180,
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});								  
////////////////////SRMFC_FieldMaxValue	 等比最大值			  
var aFieldMaxValueField = new Ext.form.TextField({
				id : 'aFieldMaxValueField',
				name : 'aFieldMaxValueField',
				fieldLabel : '等比最大值',
				width : 180,
				labelSeparator:'',
				emptyText : '',
				anchor : '100%'
			});										  
////////////////////SRMFC_StepSize	 步长			  
var aStepSizeField = new Ext.form.TextField({
				id : 'aStepSizeField',
				name : 'aStepSizeField',
				width : 180,
				fieldLabel : '步长',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});								  
////////////////////SRMFC_IntervalCoefficient	 等比间隔		  
var aIntervalCoefficientField = new Ext.form.TextField({
				id : 'aIntervalCoefficientField',
				name : 'aIntervalCoefficientField',
				width : 180,
				fieldLabel : '等比比例系数',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});										  
////////////////////SRMFC_MinValue	 非等比最小值			  
var aMinValueField = new Ext.form.TextField({
				id : 'aMinValueField',
				name : 'aMinValueField',
				width : 180,
				fieldLabel : '非等比最小值',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});							  
////////////////////SRMFC_MaxValue	 非等比最大值			  
var aMaxValueField = new Ext.form.TextField({
				id : 'aMaxValueField',
				name : 'aMaxValueField',
				width : 180,
				fieldLabel : '非等比最大值',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});								  
////////////////////SRMFC_Coefficient 	 系数	
/**		  
var aCoefficientField = new Ext.form.TextField({
				id : 'aCoefficientField',
				name : 'aCoefficientField',
				fieldLabel : '系数',
				width : 150,
				emptyText : '',
				anchor : '100%'
			});			
**/
var aCoefficientField = new Ext.form.TriggerField({
                id : 'aCoefficientField',
				name : 'aCoefficientField',
				fieldLabel : '系数',
				// disabled:true,
				editable : false,
				//hidden : true,
				width : 180,
				//emptyText : '公式设置',
				labelSeparator:'',
				anchor : '100%'
			});
aCoefficientField.onTriggerClick = function() {
		formula(1, this);
	};			
var hiddenField = new Ext.form.TextField({
		id: 'hiddenField',
		fieldLabel: '系数描述',
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
		title : '新增字段系数',
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
			text : '保存',
			iconCls: 'save', 
			handler : function() {
				if (formPanel.form.isValid()) {
					if ((aCalcMethodField.getValue() == 2)
							&& (aCalculateDescField.getValue() == '')) {
						Ext.Msg.show({
									title : '注意',
									msg : '公式不能为空!',
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
						waitMsg : '保存中...',
						failure : function(result, request) {
							Ext.Msg.show({
										title : '错误',
										msg : '请检查网络连接!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : '注意',
											msg : '操作成功!',
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
											title : '错误',
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
			text: '关闭',
			iconCls: 'cancel',
			handler : function() {
				addWin.close();
			}
		}]

	});

	addWin.show();

};
