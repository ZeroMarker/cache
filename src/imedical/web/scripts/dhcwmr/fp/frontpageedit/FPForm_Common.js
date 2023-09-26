//obj.cboAnaesthesia = FP_ComboDic("cboAnaesthesia","麻醉方式","InfectionNarcosisType");
function FP_ComboDic(){
	var DicType = arguments[2];
	if (arguments[3]) {
		var AddItem = arguments[3];
	} else {
		var AddItem = '-^-';
	}
	var anchor = (arguments[4] ? arguments[4] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.DictionarySrv';
						param.QueryName = 'QryDicToCbo';
						param.Arg1      = DicType;
						param.Arg2      = AddItem
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'DicRowId'
			}, 
			[
				{name: 'DicRowId', mapping: 'DicRowId'}
				,{name: 'DicCode', mapping: 'DicCode'}
				,{name: 'DicDesc', mapping: 'DicDesc'}
			])
		})
		,minChars : 100
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table style="width:100%;border-bottom:1px #BDBDBD solid;">',
				'<tbody>',
					'<tpl for=".">',
						'<tr class="x-combo-list-item">',
							'<td align="center">{DicCode}</td>',
							'<td align="left">{DicDesc}</td>',
						'</tr>',
					'</tpl>',
				'</tbody>',
			'</table>'
		)
		,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'DicRowId'
		,displayField : 'DicDesc'
		,loadingText: '查询中,请稍等...'
		,editable : false
		,width : 10
		,anchor : anchor
		,enableKeyEvents : true
		,listeners: {
			'keydown' : function(field, e){
				if ((e.getKey() == e.ENTER)||(e.getKey() == e.DOWN)){
					if (field.isExpanded() == false){
						//检查是否触发Tab键
						if (e.getKey() == e.ENTER){
							if (field.getValue() != ''){
								event.keyCode=9;  //触发Tab键
								return;
							} else {
								if (field.getRawValue() == ''){
									event.keyCode=9;  //触发Tab键
									return;
								}
							}
						}
						//加载Store数据
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success) {
								if (success){
									var isDefault = 0;
									var tmpValue = field.getRawValue();
									if ((tmpValue != '')&&(records.length>0)) {
										for (var row = 0; row < records.length; row++){
											if ((records[row].get('DicDesc') == tmpValue)
											||(records[row].get('DicCode') == tmpValue)){
												field.select(row);
												isDefault = 1;
											}
										}
									}
									if (isDefault == 0) field.setValue('');
								}
							}
						});
					} else {
						//if (e.getKey() == e.ENTER){
						//	event.keyCode=9;  //触发Tab键
						//}
					}
				}
			}
			,'render' : function(field){
				field.getEl().on('dblclick', function(){
					var field = tmpCombo;
					if (field.isExpanded() == false){
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success) {
								if (success){
									var tmpValue = field.getRawValue();
									field.setValue('');
									if (tmpValue != '') {
										for (var row = 0; row < records.length; row++){
											if ((records[row].get('DicDesc') == tmpValue)
											||(records[row].get('DicCode') == tmpValue)){
												field.select(row);
											}
										}
									}
								}
							}
						});
					}
				});
			}
			,'blur' : function(){
				if (this.getValue() == ''){
					this.setRawValue('');
				} else if (this.getRawValue() == ''){
					this.setValue('');
				}
			}
		}
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}

//obj.txtDesc = FP_TextField("txtDesc","名称");
function FP_TextField(){
	var anchor = (arguments[2] ? arguments[2] : '100%');
	var tmpTextField = new Ext.form.TextField({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,width : 10
		,anchor : anchor
		,listeners: {
			'specialkey' : function(field,e){
				if (e.getKey() == e.ENTER) {
					event.keyCode=9;  //触发Tab键
				}
			}
		}
	});
	return tmpTextField;
}

//obj.txtNo = FP_TextField("txtNo","序号");
function FP_NumberField(){
	var anchor = (arguments[2] ? arguments[2] : '100%');
	var tmpTextField = new Ext.form.TextField({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,width : 10
		,anchor : anchor
		,listeners: {
			'specialkey' : function(field,e){
				if (e.getKey() == e.ENTER) {
					var oldValue = field.getRawValue();
					var newValue = FormatNumberInput(oldValue);
					field.setValue(newValue);
					
					event.keyCode=9;  //触发Tab键
				}
			}
			,'blur' : function(field){
				var oldValue = field.getRawValue();
				var newValue = FormatNumberInput(oldValue);
				field.setValue(newValue);
			}
		}
	});
	return tmpTextField;
}
function FormatNumberInput(oldValue){
	var valChars1 = '1234567890'
	var valChars2 = '１２３４５６７８９０';
	var newValue = '';
	for (var pos = 0; pos < oldValue.length; pos++){
		var tmpChar = oldValue.substring(pos,pos+1);
		if (valChars1.indexOf(tmpChar) > -1){
			newValue = newValue + tmpChar;
		} else if (valChars2.indexOf(tmpChar) > -1){
			var pos = valChars2.indexOf(tmpChar);
			var tmpChar = valChars1.substring(pos,pos+1);
			newValue = newValue + tmpChar;
		} else {}
	}
	return newValue;
}

//obj.txtDate = FP_DateField("txtDate","日期");
function FP_DateField(){
	var anchor = (arguments[2] ? arguments[2] : '100%');
	var tmpDateField = new Ext.form.DateField({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,format : 'Y-m-d'
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 10
		,anchor : anchor
		,hideTrigger:true
		,listeners: {
			'specialkey' : function(field,e){
				if (e.getKey() == e.ENTER) {
					var oldValue = field.getRawValue();
					if (oldValue != ''){
						var newValue = FormatDateInput(oldValue,4);
						if (newValue != '') {
							var dt = new Date(newValue);
							field.setValue(dt);
						} else {
							field.setValue('');
							ExtTool.alert('提示', '输入日期 ' + oldValue + ' 格式错误,请重新输入!');
							return;
						}
					}
					
					event.keyCode=9;  //触发Tab键
				}
			}
			,'blur' : function(field){
				var oldValue = field.getRawValue();
				if (oldValue != ''){
					var newValue = FormatDateInput(oldValue,4);
					if (newValue != '') {
						var dt = new Date(newValue);
						field.setValue(dt);
					} else {
						field.setValue('');
						ExtTool.alert('提示', '输入日期 ' + oldValue + ' 格式错误,请重新输入!');
					}
				}
			}
		}
	});
	return tmpDateField;
}
function FormatDateInput(oldValue,dtFormat){
	var valChars1 = '1234567890-/'
	var valChars2 = '１２３４５６７８９０';
	var newValue = '';
	for (var pos = 0; pos < oldValue.length; pos++){
		var tmpChar = oldValue.substring(pos,pos+1);
		if (valChars1.indexOf(tmpChar) > -1){
			newValue = newValue + tmpChar;
		} else if (valChars2.indexOf(tmpChar) > -1){
			var pos = valChars2.indexOf(tmpChar);
			var tmpChar = valChars1.substring(pos,pos+1);
			newValue = newValue + tmpChar;
		} else {}
	}
	
	var dt = '';
	if (newValue.indexOf('-')>-1){
		var arrDt = newValue.split('-');
		if (arrDt.length == 3) {
			if (dtFormat == 4) {
				dt = arrDt[0] + '/' + arrDt[1] + '/' + arrDt[2];
			} else {
				dt = arrDt[0] + '-' + arrDt[1] + '-' + arrDt[2];
			}
		}
	} else if (newValue.indexOf('/')>-1){
		var arrDt = newValue.split('/');
		if (arrDt.length == 3) {
			if (dtFormat == 4) {
				dt = arrDt[0] + '/' + arrDt[1] + '/' + arrDt[2];
			} else {
				dt = arrDt[0] + '-' + arrDt[1] + '-' + arrDt[2];
			}
		}
	} else {
		if (newValue.length == 8){
			if (dtFormat == 4) {
				dt = newValue.substring(4,6) + '/' + newValue.substring(6,8) + '/' + newValue.substring(0,4);
			} else {
				dt = newValue.substring(4,6) + '-' + newValue.substring(6,8) + '-' + newValue.substring(0,4);
			}
		}
	}
	return dt;
}