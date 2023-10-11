FieldCoefficientEditFun = function() {
var rowObj = itemGrid.getSelectionModel().getSelections();

	var len = rowObj.length;
	var tmpRowid = "";
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请先选择需要修改的记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		tmpRowid = rowObj[0].get("rowid");
	}
///////////////////年/////////////////////////////  
var eYearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eYearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:FieldCoefficientUrl+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('eYearField').getRawValue()),method:'POST'});
});

var eYearField = new Ext.form.ComboBox({
	id: 'eYearField',
	fieldLabel: '年度',
	width:180,
	listWidth : 250,
	allowBlank : false, 
	store:eYearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	anchor: '100%',
	//emptyText:'请选择开始时间...',
	name: 'eYearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	labelSeparator:'',
	editable:true
});
	//系统模块号
var eSysModListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
eSysModListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : FieldCoefficientUrl+'?action=sysmodelist&str='+encodeURIComponent(Ext.getCmp('eSysModListField').getRawValue()),
						method : 'POST'
					});
		});
var eSysModListField = new Ext.form.ComboBox({
            id:'eSysModListField',
			name:'eSysModListField',
			fieldLabel : '系统模块',
			width : 180,
			listWidth : 250,
			selectOnFocus : true,
			allowBlank : false,
			store : eSysModListDs,
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
			labelSeparator:'',
			selectOnFocus : true,
			forceSelection : true
		});
		
		//字段列表
var eFieldListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
eFieldListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : FieldCoefficientUrl+'?action=fieldlist&sysmod='+eSysModListField.getValue()+'&str='+encodeURIComponent(Ext.getCmp('eFieldListField').getRawValue()),
						method : 'POST'
					});
		});
var eFieldListField = new Ext.form.ComboBox({
            id:'eFieldListField',
			name:'eFieldListField',
			fieldLabel : '字段列表',
			width : 180,
			listWidth : 250,
			selectOnFocus : true,
			allowBlank : false,
			store : eFieldListDs,
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
			forceSelection : true,
			labelSeparator:'',
			listeners:{"select":function(combo,record,index){ 
				   	    Ext.Ajax.request({				   	    			        
                     url: FieldCoefficientUrl+'?action=fieldinfoslist&str='+encodeURIComponent(eFieldListField.getValue()),
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
						         if (jsonData.success=='true'){
							         var data = jsonData.info;	
							         var dataarr = data.split("|",-1);
							         var fieldcode = dataarr[1];
							         var fieldname = dataarr[2]; 			
							         var calcmethod = dataarr[3];	          
                                    eCodeField.setValue(fieldcode);  
                                    eNameField.setValue(fieldname);
									eCalcMethodField.setValue(calcmethod);
					         	}
				         	},
					       scope: this
				   	    });           
			        }}  
		});
//////////////////////编码////////////////////		
	var eCodeField = new Ext.form.TextField({
				id : 'eCodeField',
				name : 'eCodeField',
				fieldLabel : '编码',
				allowBlank : false,
				//emptyText : '必填',
				labelSeparator:'',
				editable:false,
				anchor : '100%'
			});
//////////////////////名称////////////////////		
	var eNameField = new Ext.form.TextField({
				id : 'eNameField',
				name : 'eNameField',
				fieldLabel : '名称',
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
			
			
 var eCalcMethodDs = new Ext.data.ArrayStore({
				fields : ['rowid', 'name'],
				data : [['1', '比例系数法'], ['2', '公式法'], ['3', '等比步长法'], ['4', '非等比步长法'], ['5', '列举法']]
			});

	var eCalcMethodField = new Ext.form.ComboBox({
				fieldLabel : '计算方式',
				name : 'eCalcMethodField',
				store : eCalcMethodDs,
				displayField : 'name',
				allowBlank : false,
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				forceSelection : true,
				triggerAction : 'all',
				// emptyText : '必选',
				labelSeparator:'',
				selectOnFocus : true,
				anchor : '100%'
			});

	eCalcMethodField.on('select', function(combo, record, index) {
				// alert(combo.getValue());
				tmpV = combo.getValue();
				if (tmpV == 1) {
				    eFieldValueField.setDisabled(true);
					eFieldMinValueField.setDisabled(true);
					eFieldMaxValueField.setDisabled(true);
					eStepSizeField.setDisabled(true);
					eIntervalCoefficientField.setDisabled(true);
					eMinValueField.setDisabled(true);
					eMaxValueField.setDisabled(true);
					
					eCalculateDescField.hide();
					formu = '';
					eCalculateDescField.setValue('');
				} else if (tmpV == 2) {
					//bonusTargetCombo.setDisabled(true);
					eFieldValueField.setDisabled(true);
					eFieldMinValueField.setDisabled(true);
					eFieldMaxValueField.setDisabled(true);
					eStepSizeField.setDisabled(true);
					eIntervalCoefficientField.setDisabled(true);
					eMinValueField.setDisabled(true);
					eMaxValueField.setDisabled(true);
					
					eCalculateDescField.show();
				} else if (tmpV == 3)  {
					eFieldValueField.setDisabled(true);
					eFieldMinValueField.setDisabled(false);
					eFieldMaxValueField.setDisabled(false);
					eStepSizeField.setDisabled(false);
					eIntervalCoefficientField.setDisabled(false);
					eMinValueField.setDisabled(true);
					eMaxValueField.setDisabled(true);
					
					eCalculateDescField.hide();
					formu = '';
					eCalculateDescField.setValue('');
				} else if (tmpV == 4) {
				    eFieldValueField.setDisabled(true);
					eFieldMinValueField.setDisabled(true);
					eFieldMaxValueField.setDisabled(true);
					eStepSizeField.setDisabled(true);
					eIntervalCoefficientField.setDisabled(true);
					eMinValueField.setDisabled(false);
					eMaxValueField.setDisabled(false);
					
					eCalculateDescField.hide();
					formu = '';
					eCalculateDescField.setValue('');
				}else if (tmpV == 5) {
				    eFieldValueField.setDisabled(false);
					eFieldMinValueField.setDisabled(true);
					eFieldMaxValueField.setDisabled(true);
					eStepSizeField.setDisabled(true);
					eIntervalCoefficientField.setDisabled(true);	
					eMinValueField.setDisabled(true);
					eMaxValueField.setDisabled(true);
					
					eCalculateDescField.hide();
					formu = '';
					eCalculateDescField.setValue('');
				}

			});			
///////////////////////////系数类型 SRMFC_CoefficientType
var eCoefficientTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '比例系数'],['2', '基数']]
	});		
		
var eCoefficientTypeField = new Ext.form.ComboBox({
	                   id : 'eCoefficientTypeField',
					   name:'eCoefficientTypeField',
		           fieldLabel : '系数类型',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : eCoefficientTypeDs,
		           anchor : '100%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
				   labelSeparator:'',
		           selectOnFocus : true,
		           forceSelection : true
						  });	
////////////////////SRMFC_DefaultValue   默认值						  
var eDefaultValueField = new Ext.form.TextField({
				id : 'eDefaultValueField',
				name : 'eDefaultValueField',
				fieldLabel : '默认值',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});						  
				  
////////////////////SRMFC_FourmulaDesc   公式描述	
/**
var aCalculateDescField = new Ext.form.TextField({
				id : 'aCalculateDescField',
				name : 'aCalculateDescField',
				fieldLabel : '公式描述',
				emptyText : '',
				anchor : '100%'
			});		
**/
var eCalculateDescField = new Ext.form.TriggerField({
				fieldLabel : '公式设置',
				// disabled:true,
				editable : false,
				hidden : true,
				// emptyText : '公式设置',
				labelSeparator:'',
				anchor : '100%'
			});

	eCalculateDescField.onTriggerClick = function() {
		formula(1, this);
	};
	
////////////////////SRMFC_FieldValue   字段对应值						  
var eFieldValueField = new Ext.form.TextField({
				id : 'eFieldValueField',
				name : 'eFieldValueField',
				fieldLabel : '字段对应值',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});										  
						  
////////////////////SRMFC_FieldMinValue	 等比最小值			  
var eFieldMinValueField = new Ext.form.TextField({
				id : 'eFieldMinValueField',
				name : 'eFieldMinValueField',
				fieldLabel : '等比最小值',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});								  
////////////////////SRMFC_FieldMaxValue	 等比最大值			  
var eFieldMaxValueField = new Ext.form.TextField({
				id : 'eFieldMaxValueField',
				name : 'eFieldMaxValueField',
				fieldLabel : '等比最大值',
				labelSeparator:'',
				emptyText : '',
				anchor : '100%'
			});										  
////////////////////SRMFC_StepSize	 步长			  
var eStepSizeField = new Ext.form.TextField({
				id : 'eStepSizeField',
				name : 'eStepSizeField',
				fieldLabel : '步长',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});								  
////////////////////SRMFC_IntervalCoefficient	 等比间隔		  
var eIntervalCoefficientField = new Ext.form.TextField({
				id : 'eIntervalCoefficientField',
				name : 'eIntervalCoefficientField',
				fieldLabel : '等比比例系数',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});										  
////////////////////SRMFC_MinValue	 非等比最小值			  
var eMinValueField = new Ext.form.TextField({
				id : 'eMinValueField',
				name : 'eMinValueField',
				fieldLabel : '非等比最小值',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});							  
////////////////////SRMFC_MaxValue	 非等比最大值			  
var eMaxValueField = new Ext.form.TextField({
				id : 'eMaxValueField',
				name : 'eMaxValueField',
				fieldLabel : '非等比最大值',
				emptyText : '',
				labelSeparator:'',
				anchor : '100%'
			});								  
////////////////////SRMFC_Coefficient 	 系数			
/**  
var eCoefficientField = new Ext.form.TextField({
				id : 'eCoefficientField',
				name : 'eCoefficientField',
				fieldLabel : '系数',
				emptyText : '',
				anchor : '100%'
			});			
**/
var eCoefficientField = new Ext.form.TriggerField({
                id : 'eCoefficientField',
				name : 'eCoefficientField',
				fieldLabel : '系数',
				// disabled:true,
				editable : false,
				//hidden : true,
				width : 180,
				labelSeparator:'',
				//emptyText : '公式设置',
				anchor : '100%'
			});
eCoefficientField.onTriggerClick = function() {
		formula(1, this);
	};	
var hiddenField = new Ext.form.TextField({
		id: 'hiddenField',
		fieldLabel: '系数描述',
		width:180,
		listWidth : 250,
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
								   eFieldListField,
                                   eSysModListField,
								   eFieldListField, 
								   eCalcMethodField,
								   eCoefficientTypeField,
								   eDefaultValueField, 
								   eCalculateDescField, 
								   eFieldValueField   					   
								]	 
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								   eFieldMinValueField, 
								   eFieldMaxValueField, 
								   eStepSizeField,
								   eIntervalCoefficientField,
								   eMinValueField, 
								   eMaxValueField, 
								   eCoefficientField   		
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
	formPanel.on('afterlayout', function(panel, layout) {
			var rowObj=itemGrid.getSelectionModel().getSelections(); 
			this.getForm().loadRecord(rowObj[0]);
			//"rowid^RecordType^DeptDr^Title^JName^PType^FristAuthor^CorrAuthor^CNPaperType^PageCharge^SubUser^
			//SubDate^DataStatus^CheckDesc^CheckState^RegInfo^PubYear^Roll^Period^StartPage^EndPage^TitleInfo"
			eSysModListField.setRawValue(rowObj[0].get("SysNO"));
			eFieldListField.setRawValue(rowObj[0].get("Name"));
			eCalcMethodField.setRawValue(rowObj[0].get("CalcMethod"));	
			eCoefficientTypeField.setRawValue(rowObj[0].get("CoefficientType"));
			eDefaultValueField.setValue(rowObj[0].get("DefaultValue"));   
			eCalculateDescField.setRawValue(rowObj[0].get("FourmulaDesc"));	
			eFieldValueField.setRawValue(rowObj[0].get("FieldValue"));	
			eFieldMinValueField.setValue(rowObj[0].get("FieldMinValue"));	
			eFieldMaxValueField.setValue(rowObj[0].get("eFieldMaxValueField"));			
			eStepSizeField.setValue(rowObj[0].get("StepSize"));
			eIntervalCoefficientField.setValue(rowObj[0].get("IntervalCoefficient"));
		    eMinValueField.setValue(rowObj[0].get("MinValue"));
			eMaxValueField.setValue(rowObj[0].get("MaxValue"));
			eCoefficientField.setValue(rowObj[0].get("Coefficient"));
		    hiddenField.setValue(rowObj[0].get("CoefficientDesc"));
			eYearField.setRawValue(rowObj[0].get("Year"));
		});
	
	var editWin = new Ext.Window({                                                                                                                 	        
	    title: '修改字段系数',        
		iconCls: 'pencil',		
		width: 640,                                                                                                                                 
		height: 330,                                                                                                                                
		layout: 'fit',                                                                                                                              
		plain:true,                                                                                                                                 
		modal:true,                                                                                                                                 
		bodyStyle:'padding:5px;',                                                                                                                   
		buttonAlign:'center',                                                                                                                       
		items: formPanel,                                                                                                                           
		buttons: [{                                                                                                                                 
			id:'saveButton',                                                                                                                        
			text: '保存',  
			iconCls: 'save', 			
			handler: function() {                                                                                                                   
				if (formPanel.form.isValid()) {                 
					if((eCalcMethodField.getValue()==2)&&(eCalculateDescField.getValue()=='')){
							Ext.Msg.show({title:'注意',msg:'公式不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}				
					var tmpData = encodeURIComponent(eSysModListField.getValue().trim()) + "|"
							+ encodeURIComponent(eCalcMethodField.getValue().trim()) + "|"
							+ encodeURIComponent(eFieldListField.getValue()) + "|"
							+ encodeURIComponent(eCoefficientTypeField.getValue()) + "|"
							+ encodeURIComponent(eDefaultValueField.getValue().trim())+"|"
							+ encodeURIComponent(eCalculateDescField.getValue())+ "|"
							+ encodeURIComponent(eFieldValueField.getValue())+ "|"
							+ encodeURIComponent(eFieldMinValueField.getValue())+ "|"
							+ encodeURIComponent(eFieldMaxValueField.getValue())+ "|"
							+ encodeURIComponent(eStepSizeField.getValue())+ "|"
							+ encodeURIComponent(eIntervalCoefficientField.getValue())+ "|"
							+ encodeURIComponent(eMinValueField.getValue())+ "|"
							+ encodeURIComponent(eMaxValueField.getValue())+ "|"
							+ encodeURIComponent(eCoefficientField.getValue())+"|"
							+ encodeURIComponent(hiddenField.getValue())+"|"
							+ encodeURIComponent(eYearField.getValue())+"|"
					//alert(tmpData);
					Ext.Ajax.request({
						url: FieldCoefficientUrl+'?action=edit&data='+tmpData+'&rowid='+tmpRowid,
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0,limit:25}});		
								editWin.close();
							}else{
								Ext.Msg.show({title:'错误',msg:'修改错误！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
				else{
					Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		},
		{
			text: '关闭',
			iconCls: 'cancel',
			handler: function(){editWin.close();}
		}]
	});
	
	if(rowObj[0].get("DataSource")==2){
		formulaTrgg.show();
	}
	
	editWin.show();
};