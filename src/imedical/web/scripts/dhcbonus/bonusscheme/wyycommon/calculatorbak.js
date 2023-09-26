// �༭��ʽ
formula = function(scheme, type, formulaTrgg) {
	// type=1:��ʾ��Ӳ���
	// type=2:��ʾ�޸Ĳ���
	if (type == 1) {
		// ������ʾ
		globalStr = "";
		// ���ʽ����
		expreDesc = "";
		// �����˸�
		globalStr2 = "";
		// ���ڴ洢
		globalStr3 = "";
		checkStr = "";
	}
    var DecsArry=[];    //���ڴ洢ÿ�����ӵ��������ȣ��Է���ɾ����
	var CodeArry=[];    //���ڴ洢ÿ�����ӵı��볤�ȣ��Է���ɾ����
	var area = new Ext.form.TextArea({
				id : 'area',
				width : 500,
				height : 100,
				labelWidth : 20,
				fieldLabel : '���㹫ʽ',
				readOnly : true
			});

//������㵥Ԫ
var acctbookDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		acctbookDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.base10exe.csp?action=GetUnit&str='+UnitField.getValue(),
				method : 'POST'
			})
		});

		var UnitField = new Ext.form.ComboBox({
					id : 'UnitField',
					fieldLabel : '���㵥Ԫ',
					width : 190,
					listWidth : 230,
					allowBlank : true,
					store : acctbookDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'UnitField',
					minChars : 1,
					pageSize : 10,
					anchor: '90%',
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								alert(UnitField.getValue());
							}
						}
					}
				});			
			
	var bonusTargetDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'BonusTargetCode', 'BonusTargetName'])
			});

	var bonusTargetTypeDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'code', 'name'])
			});

	bonusTargetTypeDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'dhc.bonus.base10exe.csp?action=targetTypelist',
							method : 'POST'
						})
			});

	var bonusTargetComb = new Ext.form.ComboBox({
				fieldLabel : 'ָ���ʶ',
				width : 190,
				allowBlank : true,
				store : bonusTargetDs,
				valueField : 'BonusTargetCode',
				displayField : 'BonusTargetName',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,

				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
	var SchemeDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	SchemeDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.scheme01exe.csp?action=schemelist',
			method : 'POST'
		})
	});
	var bonusSchemeComb = new Ext.form.ComboBox({
				fieldLabel : '���𷽰�',
				width : 190,
				allowBlank : true,
				store : SchemeDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
	// �����ͺ��㵥Ԫ����
	bonusSchemeComb.on("select", function(cmb, rec, id) {
				bonusItemDs.load({
							params : {
								start : 0,
								limit : 10,
								type : bonusSchemeComb.getValue()
							}
						});
			});
	var bonusTargetTypeComb = new Ext.form.ComboBox({
				fieldLabel : 'ָ�����',
				width : 190,
				allowBlank : true,
				store : bonusTargetTypeDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
	// �����ͺ��㵥Ԫ����
	bonusTargetTypeComb.on("select", function(cmb, rec, id) {
				searchFun(cmb.getValue());

				bonusTargetDs.load({
							params : {
								start : 0,
								limit : 10
							}
						});
			});

	function searchFun(SetCfgDr) {

		bonusTargetDs.proxy = new Ext.data.HttpProxy({
					url : 'dhc.bonus.base10exe.csp?action=targertList&targetType='
							+ SetCfgDr.toString(),
					method : 'POST'
				});
		bonusTargetDs.load({
					params : {
						start : 0,
						limit : 10
					}
				});
	};

	bonusTargetDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
					url : 'dhc.bonus.base10exe.csp?action=targertList&targetType='
							+ bonusTargetTypeComb.getValue(),
					method : 'POST'
				})
	});
	bonusTargetComb.on("select", function(cmb, rec, id) {
				if (bsfunTypeField.getValue() != '') {
				    if(bsfunTypeField.getValue() != '#BonUnitTarget') {
				        showValue(bsfunTypeField.getRawValue() + '#'
									+ cmb.getRawValue(), '^'
									+ bsfunTypeField.getValue() + '#T'
									+ cmb.getValue());
					    checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
				   
				   }
				   else{
					 if(UnitField.getValue()!=""){
					     showValue(bsfunTypeField.getRawValue()+'('+UnitField.getRawValue()+')'+'#'
	                               + cmb.getRawValue(), '^'+ bsfunTypeField.getValue() + '@'+UnitField.getValue()+'#T'+ cmb.getValue());
                         checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
						 UnitField.setValue();
					 }
					 else{
						 Ext.Msg.show({
													title : '��ʾ',
													msg : '��ѡ����㵥Ԫ��',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO,
													width : 250
												});
					 
					 }
				   }	
				} 
				else {
					showValue(cmb.getRawValue(), '^T' + cmb.getValue());
					checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
				}

				bonusTargetComb.setValue("");

			});

	var bonusItemDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'SchemeItemCode', 'SchemeItemName'])
			});

	bonusItemDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'dhc.bonus.scheme01exe.csp?action=itemlist&type='
									+ bonusSchemeComb.getValue(),
							method : 'POST'
						})
			});

	var bonusItemComb = new Ext.form.ComboBox({
				fieldLabel : '������Ŀ',
				width : 190,
				allowBlank : true,
				store : bonusItemDs,
				valueField : 'SchemeItemCode',
				displayField : 'SchemeItemName',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});

	bonusItemComb.on("select", function(cmb, rec, id) {

				if (bsfunTypeField.getValue() != '') {
				      if(bsfunTypeField.getValue() != '#BonUnitTarget') {
					     showValue(bsfunTypeField.getRawValue() + '#'
									+ cmb.getRawValue(), '^'
									+ bsfunTypeField.getValue() + '#S'
									+ cmb.getValue());
					     checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
					  }
					  else{
					     if(UnitField.getValue()!=""){
					         showValue(bsfunTypeField.getRawValue()+'('+UnitField.getRawValue()+')'+'#'
	                               + cmb.getRawValue(), '^'+ bsfunTypeField.getValue() + '@'+UnitField.getValue()+'#S'+ cmb.getValue());
                             checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
							 UnitField.setValue();
					      }
					     else{
					        Ext.Msg.show({
													title : '��ʾ',
													msg : '��ѡ����㵥Ԫ��',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO,
													width : 250
												});
					      }
				   }	
					
				} 
				else {
					checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
					showValue(cmb.getRawValue(), '^S' + cmb.getValue());
				}
				bonusItemComb.setValue("");

			});

	var periodFunStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [['', '��'], ['#supTarget', '�ϼ���λָ��'],['#suppTarget', '���ϼ���λָ��'],
						['#Sum', 'ͬ����λ���'],['#SumChild', 'ȡ�¼���λ��'],['#SumSchemeTarget', '����ָ�����'], ['#Percent', 'ռͬ��ٷֱ�'], 
						['#TargetTypeSum', 'ָ��������'],['#SchemeItemAvg', '��ָ��ƽ��ֵ'],['#BSFDeptRate', '���ҿ�˰']
						,['#BSFPositive', 'ȡ����'],['#BSFInteger', 'ȡ����'],['#BSFAddUp', '�������ۼ�'],['#BonUnitTarget', '���㵥Ԫָ��']]
			});
	//�ȷ��ã�['#Avg3Month', 'ȡ���¾�ֵ'], ['#Avg6Month', 'ȡ���¾�ֵ'] //
	var bsfunTypeField = new Ext.form.ComboBox({
				id : 'bsfunTypeField',
				fieldLabel : '������',
				width : 190,
				listWidth : 180,
				selectOnFocus : true,
				allowBlank : false,
				store : periodFunStore,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '',
				mode : 'local', // ����ģʽ
				editable : false,
				pageSize : 20,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});
			
		bsfunTypeField.on("select", function(cmb, rec, id) {
		   if(bsfunTypeField.getValue()!='#BonUnitTarget'){
		      Ext.getCmp('UnitField').setValue("");��
		      Ext.getCmp('UnitField').setDisabled(true);�� 
		   }
		   else{
		      Ext.getCmp('UnitField').setDisabled(false);��
		   }
		});
		
	var formSet = new Ext.form.FormPanel({
				// title: '��ʽ�༭����',
				listWidth : 10,
				frame : true,
				fileUpload : true,
				bodyStyle : 'padding:5 5 5 5',
				region : 'north',
				height : 195,
				labelSeparator : ':',
				width : 510,
				items : [area,

				{
							xtype : 'panel',
							layout : "table",
							isFormField : true,
							layoutConfig : {
								columns : 4
							},
							items : [{
										xtype : 'label',
										text : 'ָ�����'
									}, bonusTargetTypeComb, {
										xtype : 'label',
										text : '����ָ�꣺'
									}, bonusTargetComb, {
										xtype : 'label',
										text : '���𷽰���'
									}, bonusSchemeComb, {
										xtype : 'label',
										text : '������Ŀ��'
									}, bonusItemComb, {
										xtype : 'label',
										text : '��������'
									}, bsfunTypeField, {
										xtype : 'label',
										text : '���㵥Ԫ��'
									},UnitField]
						}]
			});

	function showValue(name, code) {
		globalStr = globalStr + name;
		if (globalStr2 == "") {
			globalStr2 = code;
		} else {
			globalStr2 = globalStr2 + code;
		}
		DecsArry.push(name.length);
		CodeArry.push(code.length);
		//alert(globalStr2);
		area.setValue(globalStr);
	};

	var autohisoutmedvouchForm = new Ext.form.FormPanel({
		listWidth : 20,
		// title: '��ʽ�༭����',
		region : 'center',
		frame : true,
		height : 25,
		bodyStyle : 'padding:5 5 5 5',
		labelSeparator : ':',
		width : 550,
		items : [{
					xtype : 'panel',
					layout : "column",
					hideLabel : true,
					isFormField : true,
					items : [{
								columnWidth : .05,
								xtype : 'button',
								text : '9',
								tooltip : '9',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + ' '
											+ rec.get('rowid');
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '8',
								tooltip : '8',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '7',
								tooltip : '7',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '6',
								tooltip : '6',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '5',
								tooltip : '5',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '4',
								tooltip : '4',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '3',
								tooltip : '3',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '2',
								tooltip : '2',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '1',
								tooltip : '1',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '0',
								tooltip : '0',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '.',
								tooltip : '��',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '{',
								tooltip : '�������',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '}',
								tooltip : '�Ҵ�����',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '[',
								tooltip : '��������',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : ']',
								tooltip : '��������',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '(',
								tooltip : '��С����',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : ')',
								tooltip : '��С����',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '+',
								tooltip : '�Ӻ�',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + ' ' + 'a' + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '-',
								tooltip : '����',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '*',
								tooltip : '�˺�',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '/',
								tooltip : '����',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '^',
								tooltip : 'ָ��',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '<--',
								tooltip : 'ɾ��',
								handler : function(b) {
								    //alert(globalStr2);
								    var i = 0-DecsArry.pop();
								    var j = 0-CodeArry.pop();
								    if(i!=0)
								    globalStr=globalStr.slice(0,i);
								    if(j!=0)
								    globalStr2=globalStr2.slice(0,j);
									 //alert(globalStr2);
								    area.setValue(globalStr);
								  }
								},{
								columnWidth : .135,
								xtype : 'button',
								text : 'C',
								tooltip : '���',
								handler : function(b) {
									globalStr = "";
									globalStr2 = "";
									checkStr = "";
									area.setValue(globalStr);
								}
							}]
				}]
	});

	var OkButton = new Ext.Toolbar.Button({
				text : 'ȷ��',
				handler : function() {

					var upUrl = dhcbaUrl + "/dhchxbonus/formulaverify?exp="
							+ checkStr;

					var upUrl = dhcbaUrl + "/dhchxbonus/formulaverify?exp="
							+ (checkStr);

					formulaTrgg.setValue(globalStr);
					formu = globalStr2;
					win.close();
					return;
				}
			});

	var cancelButton = new Ext.Toolbar.Button({
				text : 'ȡ��'
			});

	// ����ȡ���޸İ�ť����Ӧ����
	cancelHandler = function() {
		win.close();
	}

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);

	win = new Ext.Window({
				title : '��ʽ�����',
				width : 715,
				height : 340,
				minWidth : 715,
				minHeight : 320,
				layout : 'border',
				plain : true,
				modal : true,
				bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : [formSet, autohisoutmedvouchForm],
				buttons : [OkButton, cancelButton]
			});
	// ������ʾ
	win.show();
}