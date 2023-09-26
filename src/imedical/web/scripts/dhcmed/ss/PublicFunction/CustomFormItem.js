var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);
var DicTypeGZ=""
function Common_GetValue()
{
	//checkbox,combo,datefield,timefield,numberfield,textarea,textfield
	var itmValue = '';
	var objItm = Ext.getCmp(arguments[0]);
	if (objItm) {
		var itmType = objItm.getXType();
		if (itmType == 'combo') {
			if (objItm.getRawValue() != ''){
				itmValue = objItm.getValue();
				//var valueField = objItm.valueField;
				//var index = objItm.getStore().find(valueField,itmValue);
				//if (index<0) itmValue = '';
			}
		} else if (itmType == 'datefield') {
			itmValue = objItm.getRawValue();
		} else if (itmType == 'timefield') {
			itmValue = objItm.getRawValue();
		} else if (itmType == 'checkboxgroup') {
			var chkGrpItems = objItm.getValue();
			for (var idx = 0; idx < chkGrpItems.length; idx++)
			{
				var cb = chkGrpItems[idx];
				itmValue = itmValue + "," + cb.inputValue;
			}
			if (itmValue) itmValue=itmValue.substring(1,itmValue.length);
		} else if (itmType == 'label') {
			itmValue = objItm.text;
		} else {
			itmValue = objItm.getValue();
		}
	}
	return itmValue;
}

function Common_GetText()
{
	//checkbox,combo,datefield,timefield,numberfield,textarea,textfield
	var itmValue = '';
	var objItm = Ext.getCmp(arguments[0]);
	if (objItm) {
		var itmType = objItm.getXType();
		if (itmType == 'combo') {
			if (objItm.getRawValue() != ''){
				itmValue = objItm.getRawValue();
			}
		} else if (itmType == 'datefield') {
			itmValue = objItm.getRawValue();
		} else if (itmType == 'timefield') {
			itmValue = objItm.getRawValue();
		} else if (itmType == 'checkboxgroup') {
			var chkGrpItems = objItm.getValue();
			for (var idx = 0; idx < chkGrpItems.length; idx++)
			{
				var cb = chkGrpItems[idx];
				itmValue = itmValue + "," + cb.boxLabel;
			}
			if (itmValue) itmValue=itmValue.substring(1,itmValue.length);
		} else {
			itmValue = objItm.getValue();
		}
	}
	return itmValue;
}
	
function Common_SetValue()
{
	//checkbox,combo,datefield,timefield,numberfield,textarea,textfield
	var itmValue = arguments[1];
	var itmRawValue = arguments[2];
	if (typeof itmValue == 'undefined') itmValue = "";
	if (typeof itmRawValue == 'undefined') itmRawValue = "";
	var objItm = Ext.getCmp(arguments[0]);
	if (objItm) {
		var itmType = objItm.getXType();
		if (itmType == 'checkbox') {
			if (itmValue!=0&&itmValue!=false) {
				objItm.setValue(true);
			} else {
				objItm.setValue(false);
			}
		} else if (itmType == 'combo') {
			//update by zf 2015-05-18 下拉框Store未加载，赋值有问题
			//if (objItm.getStore().getCount()<=0){ //fix bug 184556、187260  by pylian 20160322 死亡证明疾病/地址、慢病地址不显示
			if (objItm.getStore().getCount()<0){
				objItm.getStore().load({
					callback : function(r,option,success){
						if (success) {
							if (r.length > 0) {
								objItm.setValue(itmValue);
								objItm.setRawValue(itmRawValue);
							}
						}
					}
				});
			} else {
				objItm.setValue(itmValue);
				objItm.setRawValue(itmRawValue);
			}
		} else if (itmType == 'datefield') {
			objItm.setRawValue(itmValue);
		} else if (itmType == 'timefield') {
			objItm.setRawValue(itmValue);
		} else if (itmType == 'numberfield') {
			objItm.setValue(itmValue);
		} else if (itmType == 'textarea') {
			objItm.setValue(itmValue);
		} else if (itmType == 'textfield') {
			objItm.setValue(itmValue);
		} else if (itmType == 'checkboxgroup') {
			if ((itmValue == '')&&(itmRawValue == '')) {
				if (Object.prototype.toString.call(objItm.items) === '[object Array]') {
					for (var idx = 0; idx < objItm.items.length; idx++) {
						var cb = objItm.items[idx];
						cb.checked = false;
					}
				} else {
					for (var idx = 0; idx < objItm.items.length; idx++) {
						var cb = objItm.items.itemAt(idx);
						cb.setValue(false);
					}
				}
			} else {
				var cbValues = itmValue.split(',');
				var cbTexts = itmRawValue.split(',');
				if (Object.prototype.toString.call(objItm.items) === '[object Array]') {
					for (var idx = 0; idx < objItm.items.length; idx++) {
						var cb = objItm.items[idx];
						var itemActive = false;
						for (var indValue = 0; indValue < cbValues.length; indValue++) {
							if (!cbValues[indValue]) continue;
							if (cb.inputValue == cbValues[indValue]) {
								itemActive = true;
							}
						}
						for (var indText = 0; indText < cbTexts.length; indText++) {
							if (!cbTexts[indText]) continue;
							if (cb.boxLabel == cbTexts[indText]) {
								itemActive = true;
							}
						}
						cb.checked = itemActive;
					}
				} else {
					for (var idx = 0; idx < objItm.items.length; idx++) {
						var cb = objItm.items.itemAt(idx);
						var itemActive = false;
						for (var indValue = 0; indValue < cbValues.length; indValue++) {
							if (!cbValues[indValue]) continue;
							if (cb.inputValue == cbValues[indValue]) {
								itemActive = true;
							}
						}
						for (var indText = 0; indText < cbTexts.length; indText++) {
							if (!cbTexts[indText]) continue;
							if (cb.boxLabel == cbTexts[indText]) {
								itemActive = true;
							}
						}
						cb.setValue(itemActive);
					}
				}
			}
		} else if (itmType == 'label') {
			objItm.setText(itmValue);
		} else {
			objItm.setValue(itmValue);
		}
	}
	return itmValue;
}

/// add by maxp 2016-04-18
//为使用基础字典库的Combobox赋值 只知道字典项名称
function Common_SetComboSSDicValue()
{
	var DicType = arguments[1];
	var itmValue = arguments[2];
	var itmRawValue = arguments[3];
	if (typeof itmValue == 'undefined') itmValue = "";
	if (typeof itmRawValue == 'undefined') itmRawValue = "";
	if ((itmValue=="")&&(itmRawValue!="")) {
		var objDic = ExtTool.RunServerMethod("DHCMed.SSService.DictionarySrv","GetObjByTypeDesc",DicType,itmRawValue);
		if (objDic) itmValue=objDic.RowID;
	}
	var objItm = Ext.getCmp(arguments[0]);
	if (objItm) {
		var itmType = objItm.getXType();
		if (itmType=='combo') {
			objItm.setValue(itmValue);
			objItm.setRawValue(itmRawValue);
		}
	}
}

function Common_SetDisabled()
{
	var objItm = Ext.getCmp(arguments[0]);
	if (objItm) {
		objItm.setDisabled(arguments[1]);
	}
	return true;
}

function Common_SetVisible()
{
	var objItm = Ext.getCmp(arguments[0]);
	if (objItm) {
		objItm.setVisible(arguments[1]);
	}
	return true;
}

function Common_CheckboxGroupToDic()
{
	var arrItem = new Array();
	//var objDictionarySrv = ExtTool.StaticServerObject("DHCMed.SSService.DictionarySrv");
	//var strDicList = objDictionarySrv.GetDicsByType(arguments[2]);
	var strDicList = ExtTool.RunServerMethod("DHCMed.SSService.DictionarySrv","GetDicsByType",arguments[2]);
	var dicList = strDicList.split(String.fromCharCode(1));
	for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
		var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
		var chkItem = {
			id : arguments[0] + '-' + dicSubList[0],
			boxLabel : dicSubList[1],
			name : arguments[0] + '-' + dicSubList[0],
			inputValue : dicSubList[0],
			checked : false
		}
		arrItem.push(chkItem);
	}
	
	var cbgDictionary = new Ext.form.CheckboxGroup({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,xtype : 'checkboxgroup'
		,columns : (arguments[3] ? arguments[3] : 4)
		,items : arrItem
		,width : 10
		,anchor : '100%'
	});
	
	return cbgDictionary;
}
//CheckboxGroup(Common_CheckboxGroupToDic)引用例子
//obj.Operation_cbgEmerOperType = Common_CheckboxGroupToDic("Operation_cbgEmerOperType","手术类型","OperationType",4);

function Common_RadioGroupToDic()
{
	var arrItem = new Array();
	//var objDictionarySrv = ExtTool.StaticServerObject("DHCMed.SSService.DictionarySrv");
	//var strDicList = objDictionarySrv.GetDicsByType(arguments[2]);
	var strDicList = ExtTool.RunServerMethod("DHCMed.SSService.DictionarySrv","GetDicsByType",arguments[2]);
	var dicList = strDicList.split(String.fromCharCode(1));
	for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
		var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
		var chkItem = {
			id : arguments[0] + '-' + dicSubList[0],
			boxLabel : dicSubList[1],
			name : arguments[0] + '-' + dicSubList[0],
			inputValue : dicSubList[0],
			checked : false,
			listeners : {
				check : function(checkbox, checked) {
					if (checked) {
						var chkBoxId = checkbox.id;
						var chkBoxValue = checkbox.inputValue;
						var chkGrpId = chkBoxId.substring(0, chkBoxId.length - chkBoxValue.length-1);
						var chkGrp = Ext.getCmp(chkGrpId);
						if (chkGrp) {
							for (idx = 0; idx < chkGrp.items.length; idx++) {
								var cbId=chkGrp.items.items[idx].id;
								if (cbId!=chkBoxId) {
									chkGrp.setValue(cbId,false);
								}
							}
						}
					}
					/*
					else {
						var chkBoxId = checkbox.id;
						var chkBoxValue = checkbox.inputValue;
						var chkGrpId = chkBoxId.substring(0, chkBoxId.length - chkBoxValue.length-1);
						var isHaveValue = false;
						var chkGrp = Ext.getCmp(chkGrpId);
						if (chkGrp) {
							for (idx = 0; idx < chkGrp.items.length; idx++) {
								var cb=chkGrp.items.items[idx];
								if (cb.checked) isHaveValue = true;
							}
						}
						if (!isHaveValue) {
							chkGrp.setValue(chkBoxId,true);
						}
					}*/
				}
			}
		}
		arrItem.push(chkItem);
	}
	
	var cbgDictionary = new Ext.form.CheckboxGroup({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,xtype : 'checkboxgroup'
		,columns : (arguments[3] ? arguments[3] : 4)
		,items : arrItem
		,width : 10
		,anchor : '100%'
	});
	return cbgDictionary;
}
//CheckboxGroup(Common_RadioGroupToDic)引用例子
//obj.Operation_cbgEmerOperType = Common_RadioGroupToDic("Operation_cbgEmerOperType","手术类型","OperationType",4);

function Common_DateFieldToDateTime()
{
	var anchor = (arguments[2] ? arguments[2] : '100%');
	
	var tmpDateField = new Ext.form.DateField({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		//,format : 'Y-m-d H:i'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)+" H:i"
		,altFormats : 'Y-m-d H:i|d/m/Y H:i'
		,width : 10
		,anchor : anchor
	});
	
	return tmpDateField;
}
//DateField(Common_DateFieldToDateTime)引用例子
//obj.Operation_txtEndDateTime = Common_DateFieldToDateTime("Operation_txtEndDateTime","开始时间");
	
function Common_DateFieldToDate()
{
	var anchor = (arguments[2] ? arguments[2] : '100%');
	
	var tmpDateField = new Ext.form.DateField({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 10
		,anchor : anchor
		,value : new Date()
	});
	
	return tmpDateField;
}
//DateField(Common_DateFieldToDate)引用例子
//obj.txtDate = Common_DateFieldToDate("txtDate","日期");

	
function Common_DateFieldToDate1()
{
	var anchor = (arguments[2] ? arguments[2] : '100%');
	
	var tmpDateField = new Ext.form.DateField({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 10
		,anchor : anchor
	});
	
	return tmpDateField;
}
//DateField(Common_DateFieldToDate)引用例子
//obj.txtDate = Common_DateFieldToDate("txtDate","日期");


function Common_TimeField()
{
	var anchor = (arguments[2] ? arguments[2] : '100%');
	
	var tmpTimeField = new Ext.form.TimeField({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,format:'H:i'
		,altFormats : 'H:i'
		,width : 10
		,anchor : anchor
	});
	
	return tmpTimeField;
}
//TimeField(Common_TimeField)引用例子
//obj.txtTime = Common_TimeField("txtTime","时间");

function Common_TextFieldToFormat()
{
	var formatStr = (arguments[2] ? arguments[2] : '');
	var tmpTimeField = new Ext.form.TextField({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,width : 10
		,anchor : '100%'
		,initEvents : function() {
			var keyPress = function(e,field){
				var blockchars = '0123456789';
				var c = e.getCharCode();
				if(blockchars.indexOf(String.fromCharCode(c)) == -1){
					e.stopEvent();
				}
			};
			this.el.on("keypress", keyPress, this);
			
			var focus = function(e,field){
				var value = this.getValue();
				if (formatStr == '小时:分钟') {
					var indHour = value.indexOf('小时');
					var indMin = value.indexOf('分钟');
					var valHour = (indHour > -1 ? Ext.util.Format.substr(value, 0, indHour) : '0')
					var valMin =(indMin > -1 ? (indHour > -1 ? Ext.util.Format.substr(value, indHour + 2, indMin - indHour - 2) : Ext.util.Format.substr(value, 0, indMin)) : '0')
					valHour = parseInt(valHour);
					valMin = parseInt(valMin);
					valHour = valHour + ((valMin - valMin % 60) / 60);
					valMin = valMin % 60;
					this.setValue(valHour + '小时' + valMin + '分钟');
				} else if (formatStr) {
					val = parseInt('0' + value);
					this.setValue(val + formatStr);
				}
			};
			this.el.on("focus", focus, this);
			
			var blur = function(e,field){
				var value = this.getValue();
				if (formatStr == '小时:分钟') {
					var indHour = value.indexOf('小时');
					var indMin = value.indexOf('分钟');
					var valHour = (indHour > -1 ? Ext.util.Format.substr(value, 0, indHour) : '0')
					var valMin =(indMin > -1 ? (indHour > -1 ? Ext.util.Format.substr(value, indHour + 2, indMin - indHour - 2) : Ext.util.Format.substr(value, 0, indMin)) : '0')
					valHour = parseInt(valHour);
					valMin = parseInt(valMin);
					valHour = valHour + ((valMin - valMin % 60) / 60);
					valMin = valMin % 60;
					if ((valHour > 0)||(valMin >0)) {
						this.setValue(valHour + '小时' + valMin + '分钟');
					} else {
						this.setValue('');
					}
				} else if (formatStr) {
					//val = parseInt('0' + value);		抗生素术后用药天数大于9天bug
					val = parseInt(value);
					if (val > 0) {
						this.setValue(val + formatStr);
					} else {
						this.setValue('');
					}
				}
			};
			this.el.on("blur", blur, this);
		}
	});
	return tmpTimeField;
}
//TimeField(Common_TextFieldToFormat)引用例子
//obj.Anti_txtTime = Common_TextFieldToFormat("Anti_txtTime","术前用药时间");
	
function Common_ComboToDic()
{
	var DicType = arguments[2];
	if (arguments[3]) {
		var AddItem = arguments[3];
	} else {
		var AddItem = '^-';
	}
	var anchor = (arguments[4] ? arguments[4] : '100%');
	if (arguments[5]) {
		var HospID = arguments[5];
	} else {
		var HospID = "";
	}
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.SSService.DictionarySrv';
						param.QueryName = 'QryDicToCbo';
						param.Arg1      = DicType;
						param.Arg2      = AddItem
						param.Arg3      = HospID
						param.ArgCnt    = 3;
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
		,minChars : 0
		,displayField : 'DicDesc'
		,valueField : 'DicRowId'
		,tpl : new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td ><SPAN style="FONT-SIZE: 12px;">{DicDesc}</SPAN></td>',
				'</tr></tpl>',
			'</table>'
		)
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToDic)引用例子
//obj.cboAnaesthesia = Common_ComboToDic("cboAnaesthesia","麻醉方式","InfectionNarcosisType");

	
function Common_ComboToDicGZ()
{
	var DicType = arguments[2];
	if (arguments[3]) {
		var AddItem = arguments[3];
	} else {
		var AddItem = '^-';
	}
	var anchor = (arguments[4] ? arguments[4] : '100%');
	if (arguments[5]) {
		var HospID = arguments[5];
	} else {
		var HospID = "";
	}
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.SSService.DictionarySrv';
						param.QueryName = 'QryDicToCbo';
						param.Arg1      = DicTypeGZ;
						param.Arg2      = AddItem
						param.Arg3      = HospID
						param.ArgCnt    = 3;
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
		,minChars : 0
		,displayField : 'DicDesc'
		,valueField : 'DicRowId'
		,tpl : new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td ><SPAN style="FONT-SIZE: 12px;">{DicDesc}</SPAN></td>',
				'</tr></tpl>',
			'</table>'
		)
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}

function Common_TextField()
{
	var tmpTextField = new Ext.form.TextField({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,width : 10
		,anchor : '100%'
		,emptyText : arguments[2]
	});
	
	return tmpTextField;
}
//TextField(Common_TextField)引用例子
//obj.txtDesc = Common_TextField("txtDesc","名称");


function Common_TextArea()
{
	var height = (arguments[2] ? arguments[2] : 10);
	var maxLength = (arguments[3] ? arguments[3] : 500);
	var anchor = (arguments[4] ? arguments[4] : '100%');
	
	var tmpTextField = new Ext.form.TextArea({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,width : 10
		,height : height
		,maxLength : maxLength
		,anchor : anchor
	});
	
	return tmpTextField;
}
//TextField(Common_TextArea)引用例子
//obj.Operation_txtResume = Common_TextArea("Operation_txtResume","备注",50);

function Common_Label()
{
	var tmpLabel = new Ext.form.Label({
		id : arguments[0]
		,text : arguments[1]
		,width : 10
		,height : 27
		,anchor : '100%'
	});
	
	return tmpLabel;
}
//TextField(Common_tmpLabel)引用例子
//obj.Operation_txtResume = Common_Label("Operation_txtResume","备注");

function Common_NumberField()
{
	var tmpNumberField = new Ext.form.NumberField({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,allowBlank: true
		,allowNegative : (arguments[2] ? true : false)
		,allowDecimals : (arguments[3] ? true : false)
		,decimalPrecision : (arguments[4] ? arguments[4] : 2)
        ,nanText :'请输入有效的数值'
		,width : 10
		,anchor : '100%'
	});
	
	return tmpNumberField;
}
//NumberField(Common_NumberField)引用例子  正整数
//obj.Operation_txtOprCutCount = Common_NumberField("Operation_txtOprCutCount","切口个数",0,0);
	
function Common_Checkbox()
{
	var tmpCheckbox = new Ext.form.Checkbox({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,anchor : '100%'
	});
	
	return tmpCheckbox;
}
//Checkbox(Common_Checkbox)引用例子
//obj.IsActive = Common_Checkbox("IsActive","是否有效");

function Common_DateFieldToMonth()
{
	var tmpDateField = new Ext.form.DateField({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,plugins: 'monthPickerPlugin'
		,format :'Y-m'
		,editable : false
		,width : 10
		,anchor : '100%'
		,value : new Date().dateFormat('Y-m')
	});
	return tmpDateField;
}
//DateField(Common_DateFieldToMonth)引用例子
//obj.txtYearMonth = Common_DateFieldToMonth("txtYearMonth","年月");

function Common_ComboToLoc()
{
	var LocType = arguments[2];
	var lnkLocCmp = arguments[3];
	var AdmType = arguments[4];
	var lnkHospCmp = arguments[5];
	if (arguments.length>6) {
		var AddItem = arguments[6];
	} else {
		var AddItem = '^-';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.SSService.HospitalSrv';
						param.QueryName = 'QueryLoction';
						param.Arg1      = tmpCombo.getRawValue();
						param.Arg2      = '';
						param.Arg3      = Common_GetValue(lnkLocCmp);
						param.Arg4      = ((LocType) ? LocType : '');
						param.Arg5      = ((AdmType) ? AdmType : '');
						param.Arg6      = ((AddItem) ? AddItem : '');
						param.Arg7      = Common_GetValue(lnkHospCmp);
						param.ArgCnt    = 7;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'LocRowId'
				}, 
				[
					{name: 'LocRowId', mapping: 'LocRowId'}
					,{name: 'LocDesc', mapping: 'LocDesc'}
					,{name: 'LocDesc1', mapping: 'LocDesc1'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>名称</th>',
					'<th>代码</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{LocDesc}</td>',
					'<td>{LocRowId}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'LocRowId'
		,displayField : 'LocDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(){
								field.setValue('');
							}
						});
					}
				}
			}
		}
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToLoc)引用例子
//obj.cboLoc = Common_ComboToLoc("cboLoc","填报科室");

//刷新当前页面
function Common_LoadCurrPage(gridId)
{
	var objGrid = Ext.getCmp(gridId);
	if (objGrid) {
		if (objGrid.getBottomToolbar()) {
			var start=objGrid.getBottomToolbar().cursor;
			var limit=objGrid.getBottomToolbar().pageSize;
			objGrid.getStore().load({params:{start:start,limit:limit}});
		}
		else{      //add by wuqk 2013-03-08
			objGrid.getStore().load();
		}
	}
}

function GetParam(obj, key)
{
	var url = obj.location.href;
	var strParams = "";
	var pos = url.indexOf("?");
	var tmpArry = null;
	var strValue = "";
	var tmp = "";
	if( pos < 0) {
		return "";
	} else {
		strParams = url.substring(pos + 1, url.length);
		tmpArry = strParams.split("&");
		for(var i = 0; i < tmpArry.length; i++)
		{
			tmp = tmpArry[i];
			if(tmp.indexOf("=") < 0) continue;
			if(tmp.substring(0, tmp.indexOf("=")) == key)
			{
				strValue = tmp.substring(tmp.indexOf("=") + 1, tmp.length);
			}
		}
		return strValue;
	}
}

                                                                
///add by wuqk 
///自定义ComboBox控件
///2013-03-01
function Common_ComboCustom(config,fn)
{
	var tmpCombo = new Ext.form.ComboBox({
		id : (config.id?config.id:"")
		,labelSeparator :''
		,fieldLabel : (config.label?config.label:"")
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {'beforeload' :  fn}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: (config.idProperty?config.idProperty:""),
				fields:[
					{name: config.valueField}   //, mapping: config.valueField
					,{name: config.displayField}  //, mapping: config.displayField
					,{name: config.idProperty}  //, mapping: config.idProperty
				]
				}
			)
		})
		,minChars : 0
		,displayField : config.displayField
		,valueField : config.valueField
		,triggerAction : 'all'
		,editable : (config.editable==undefined?false:config.editable)
		,width : 10
		,anchor : '100%'
	});
	return tmpCombo;
}

// 日期大小比较  格式：2013-03-22
function Common_CompareDate(startDate,endDate) {
	var startMonth = startDate.substring(5,startDate.lastIndexOf ("-"));
	var startDay = startDate.substring(startDate.length,startDate.lastIndexOf ("-")+1);
	var startYear = startDate.substring(0,startDate.indexOf ("-"));
	
	var endMonth = endDate.substring(5,endDate.lastIndexOf ("-"));
	var endDay = endDate.substring(endDate.length,endDate.lastIndexOf ("-")+1);
	var endYear = endDate.substring(0,endDate.indexOf ("-"));
	
	if (Date.parse(startMonth+"/"+startDay+"/"+startYear) >= Date.parse(endMonth+"/"+endDay+"/"+endYear)) { 
		return false;
	}
	return true;
}

// add byy mxp 
//日期字符串转换为数字 
function Common_DateParse() {
	var DateFormat = ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat);
	var argDateTime = arguments[0];
	var tmpDateTime=Date.parse(argDateTime);
	
	if (argDateTime.indexOf(":")>-1) {
		var argDate=argDateTime.split(" ")[0];
		var argTime=argDateTime.split(" ")[1];
		var tmpDate = Date.parseDate(argDate,DateFormat);
		if (tmpDate){
			argDate = tmpDate.format('Y/m/d');
			tmpDateTime = Date.parse(argDate+" "+argTime);
		}
	}else{
		var tmpDate = Date.parseDate(argDateTime,DateFormat);
		if (tmpDate){
			tmpDateTime = Date.parse(tmpDate);
		}
	}
	
	return tmpDateTime
}

//后台返回对象 取对象中的日期 赋值格式固定为'y-m-d' 
//需要按照配置转换
function Common_SetDateValue() {
	var DateFormat = ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat);
	var itmValue = arguments[1];
	if (typeof itmValue == 'undefined') itmValue = "";
	var objItm = Ext.getCmp(arguments[0]);
	if (objItm) {
		var itmType = objItm.getXType();
		if (itmType == 'datefield') {
			var tmpDate = Date.parseDate(itmValue,'Y-m-d');
			if (tmpDate) {
				tmpDate = tmpDate.format(DateFormat);
				objItm.setRawValue(tmpDate);
			}
		}
	}
}

// 日期天数差 传入日期控件ID 第2个传入空,默认与当前日期比较
function Common_ComputeDays() {
	var ret = "";
	var endDateID = arguments[1];
	if (typeof endDateID == 'undefined') endDateID = "";
	if (endDateID!="") {
		var objEndItm = Ext.getCmp(endDateID);
		if (objEndItm) {
			var endDate = objEndItm.getValue().format("Y-m-d");
			endDate = Date.parseDate(endDate, "Y-m-d");
		}
	}else{
		var endDate = new Date().format("Y-m-d");
		endDate = Date.parseDate(endDate, "Y-m-d");
	}
	var objItm = Ext.getCmp(arguments[0]);
	if (objItm) {
		var startDate = objItm.getValue().format("Y-m-d");
		startDate = Date.parseDate(startDate, "Y-m-d");
	}
	startDate = Date.parse(startDate);
	endDate = Date.parse(endDate);
	if ((startDate) && (endDate)) {
		var tmpStartDate = startDate / 1000 / 3600 / 24;
		var tmpEndDate = endDate / 1000 / 3600 / 24;
		ret = tmpEndDate - tmpStartDate;
		if (ret==0)	ret='0';
	}
	
	return ret;
}

function Common_ComboToCTHosp()
{
	if (arguments[2]) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '^-';
	}
	var anchor = (arguments[3] ? arguments[3] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.SSService.HospitalSrv';
						param.QueryName = 'QryCTHospital';
						param.ArgCnt    = 0;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'HospID'
			}, 
			[
				{name: 'HospID', mapping: 'HospID'}
				,{name: 'HospCode', mapping: 'HospCode'}
				,{name: 'HospDesc', mapping: 'HospDesc'}
			])
		})
		,minChars : 0
		,displayField : 'HospDesc'
		,valueField : 'HospID'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToCTHosp)引用例子
//obj.cboHospital = Common_ComboToCTHosp("cboHospital","医院");

function Common_ComboToProduct()
{
	if (arguments[2]) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '^-';
	}
	var anchor = (arguments[3] ? arguments[3] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.SSService.ProductsSrv';
						param.QueryName = 'QueryProInfo';
						param.Arg1      = '';
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'rowid'
			}, 
			[
				{name: 'rowid', mapping: 'rowid'}
				,{name: 'ProName', mapping: 'ProName'}
			])
		})
		,minChars : 0
		,displayField : 'ProName'
		,valueField : 'rowid'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToProduct)引用例子
//obj.cboProduct = Common_ComboToProduct("cboProduct","产品");

function Common_ComboToArea()
{
	var lnkLocCmp = arguments[2];
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.SS.AreaDic';
						param.QueryName = 'QryArea';
						param.Arg1 = '';
						param.Arg2 = (lnkLocCmp != "1" ? Common_GetValue(lnkLocCmp) : 1);
						param.Arg3 = '';
						param.Arg4 = '';
						param.Arg5 = '';
						param.ArgCnt = 5;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'ID'
				}, 
				[
					{name: 'ID', mapping: 'ID'}
					,{name: 'Code', mapping: 'Code'}
					,{name: 'ShortDesc', mapping: 'ShortDesc'}
					,{name: 'LongDesc', mapping: 'LongDesc'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>名称</th>',
					'<th>代码</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ShortDesc}</td>',
					'<td>{Code}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:200
		,valueField : 'ID'
		,displayField : 'ShortDesc'
		,loadingText: '查询中,请稍等...'
		,emptyText : '请选择...'
		,editable : false
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(){
								field.setValue('');
							}
						});
					}
				}
			}
		}
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToArea)引用例子
//obj.cboCity = Common_ComboToArea("cboCity","市","");

function Common_ComboToICD()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.SSService.CommonCls';
						param.QueryName = 'QryICDDxByAlias';
						param.Arg1 =  tmpCombo.getRawValue();
						param.ArgCnt = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader(
				{
					root: 'record',
					totalProperty: 'total',
					idProperty: 'ICDRowID'
				},
				[
					{name: 'ICDRowID', mapping: 'ICDRowID'}
					,{name: 'ICDCode', mapping: 'ICDCode'}
					,{name: 'ICDDesc', mapping: 'ICDDesc'}
					,{name: 'ICD10', mapping: 'ICD10'}
				]
			)
		})
		,minChars : 2
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>诊断描述</th>',
					'<th>ICD10</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ICDDesc}</td>',
					'<td>{ICD10}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:180
		,valueField : 'ICDRowID'
		,displayField : 'ICDDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((!field.getValue())||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(){
								field.setValue('');
							}
						});
					}
				}
			}
		}
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToICD)引用例子
//obj.cboDiagnose = Common_ComboToICD("cboDiagnose","诊断");


function Common_ComboToICD1()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.SSService.DiseaseSrv';
						param.QueryName = 'QryDisease';
						param.Arg1 =  "CD";
						param.Arg2 =  1;
						param.Arg3 =  "";
						param.Arg4 =  arguments[2];
						param.Arg5 =  tmpCombo.getRawValue();
						param.ArgCnt = 5;
					}
				}
			}),
			reader: new Ext.data.JsonReader(
				{
					root: 'record',
					totalProperty: 'total',
					idProperty: 'ID'
				},
				[
					{name: 'ID', mapping: 'ID'}
					,{name: 'IDCode', mapping: 'IDCode'}
					,{name: 'IDDesc', mapping: 'IDDesc'}
					,{name: 'ICD10', mapping: 'ICD10'}
				]
			)
		})
		,minChars : 2
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>诊断描述</th>',
					'<th>ICD10</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{IDDesc}</td>',
					'<td>{ICD10}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'ID'
		,displayField : 'IDDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((!field.getValue())||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(){
								field.setValue('');
							}
						});
					}
				}
			}
		}
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToICD)引用例子
//obj.cboDiagnose = Common_ComboToICD("cboDiagnose","诊断");


function Common_ComboToEPDICD()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.EPDService.InfectionSrv';
						param.QueryName = 'QryInfection';
						param.Arg1 = tmpCombo.getRawValue();
						param.Arg2 = "";
						param.ArgCnt = 2;
					}
				}
			}),
			reader : new Ext.data.JsonReader(
			{
				root : 'record',
				totalProperty : 'total',
				idProperty : 'myid'
			}, [
				{name : 'checked',mapping : 'checked'}
				,{name : 'RowID',mapping : 'RowID'}
				,{name : 'MIFDisease',mapping : 'MIFDisease'}
			])
		})
		,minChars : 2
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				//'<thead align="center"><tr>',
				//	'<th>诊断描述</th>',
				//'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{MIFDisease}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:30
		,editable : true
		//,editable : false
		,valueField : 'RowID'
		,displayField : 'MIFDisease'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((!field.getValue())||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(){
								field.setValue('');
							}
						});
					}
				}
			}
		}
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToICD)引用例子
//obj.cboDiagnose = Common_ComboToEPDICD("cboDiagnose","确诊诊断");

function SetComboxByValue(cmp,value,flg){
	if (!flg) flg = CHR_1;
	var arrItem = value.split(flg);
	if (arrItem.length > 1) {
		Common_SetValue(cmp,arrItem[0],arrItem[1]);
	}
}

function SetComboxByText(cmp,text){
	if (text != "") {
		var objCmp = Ext.getCmp(cmp);
		objCmp.getStore().load({
			callback : function(r){
				for (var indRec = 0; indRec < r.length; indRec++){
					var objRec = r[indRec];
					if (text.indexOf(objRec.get("DicDesc")) > -1) {
						Common_SetValue(cmp,objRec.get("DicRowId"),objRec.get("DicDesc"));
					}
				}
			}
		});
	}
}

function Common_ComboToSSHosp()
{
	var SSHospCode = arguments[2];
	var ProductCode = arguments[3];
	var anchor = (arguments[4] ? arguments[4] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,labelSeparator :''
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.SSService.HospitalSrv';
						param.QueryName = 'QrySSHospByCode';
						param.Arg1      = SSHospCode;
						param.Arg2      = ProductCode;
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'CTHospID'
			}, 
			[
				{name: 'CTHospID', mapping: 'CTHospID'}
				,{name: 'CTHospDesc', mapping: 'CTHospDesc'}
			])
		})
		,minChars : 0
		,displayField : 'CTHospDesc'
		,valueField : 'CTHospID'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	tmpCombo.getStore().load({
		callback : function(r){
			if (r.length > 0) {
				var objRec = r[0];
				tmpCombo.setValue(objRec.get("CTHospID"));
				tmpCombo.setRawValue(objRec.get("CTHospDesc"));
			}
			if (r.length < 2) {
				tmpCombo.setDisabled(true);
			}
		}
	});
	return tmpCombo;
}
//ComboBox(Common_ComboToSSHosp)引用例子
//obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院","");

function Common_ComboToSSHospAA()
{
	var SSHospCode = arguments[2];
	var ProductCode = arguments[3];
	var anchor = (arguments[4] ? arguments[4] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.SSService.HospitalSrv';
						param.QueryName = 'QrySSHospByCodeAA';
						param.Arg1      = SSHospCode;
						param.Arg2      = ProductCode;
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'CTHospID'
			}, 
			[
				{name: 'CTHospID', mapping: 'CTHospID'}
				,{name: 'CTHospDesc', mapping: 'CTHospDesc'}
			])
		})
		,minChars : 0
		,displayField : 'CTHospDesc'
		,valueField : 'CTHospID'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	tmpCombo.getStore().load({
		callback : function(r){
			if (r.length > 0) {
				var objRec = r[0];
				tmpCombo.setValue(objRec.get("CTHospID"));
				tmpCombo.setRawValue(objRec.get("CTHospDesc"));
			}
			if (r.length < 2) {
				tmpCombo.setDisabled(true);
			}
		}
	});
	return tmpCombo;
}
//ComboBox(Common_ComboToSSHospAA)引用例子
//obj.cboLoc = Common_ComboToSSHospAA("cboLoc","检验科室");


function Common_CheckboxGroupToStr()
{
	var arrItem = new Array();
	var strDicList = arguments[2];
	var dicList = strDicList.split(String.fromCharCode(1));
	for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
		var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
		var chkItem = {
			id : arguments[0] + '-' + dicSubList[0],
			boxLabel : dicSubList[1],
			name : arguments[0] + '-' + dicSubList[0],
			inputValue : dicSubList[0],
			checked : false
		}
		arrItem.push(chkItem);
	}
	
	var cbgDictionary = new Ext.form.CheckboxGroup({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,xtype : 'checkboxgroup'
		,columns : (arguments[3] ? arguments[3] : 4)
		,items : arrItem
		,width : 10
		,anchor : '100%'
	});
	
	return cbgDictionary;
}
//CheckboxGroup(Common_CheckboxGroupToStr)引用例子
//obj.cbgSymptom = Common_CheckboxGroupToStr("cbgSymptom","症状",strList,4);

function Common_RadioGroupToStr()
{
	var arrItem = new Array();
	var strDicList = arguments[2];
	var dicList = strDicList.split(String.fromCharCode(1));
	for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
		var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
		var chkItem = {
			id : arguments[0] + '-' + dicSubList[0],
			boxLabel : dicSubList[1],
			name : arguments[0] + '-' + dicSubList[0],
			inputValue : dicSubList[0],
			checked : false,
			listeners : {
				check : function(checkbox, checked) {
					if (checked) {
						var chkBoxId = checkbox.id;
						var chkBoxValue = checkbox.inputValue;
						var chkGrpId = chkBoxId.substring(0, chkBoxId.length - chkBoxValue.length-1);
						var chkGrp = Ext.getCmp(chkGrpId);
						if (chkGrp) {
							for (idx = 0; idx < chkGrp.items.length; idx++) {
								var cbId=chkGrp.items.items[idx].id;
								if (cbId!=chkBoxId) {
									chkGrp.setValue(cbId,false);
								}
							}
						}
					}
				}
			}
		}
		arrItem.push(chkItem);
	}
	
	var cbgDictionary = new Ext.form.CheckboxGroup({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,xtype : 'checkboxgroup'
		,columns : (arguments[3] ? arguments[3] : 4)
		,items : arrItem
		,width : 10
		,anchor : '100%'
	});
	return cbgDictionary;
}
//CheckboxGroup(Common_RadioGroupToStr)引用例子
//obj.cbgSymptom = Common_RadioGroupToStr("cbgSymptom","症状",strList,4);
