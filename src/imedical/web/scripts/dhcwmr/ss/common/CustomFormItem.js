var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);

function Common_GetValue()
{
	//checkbox,combo,datefield,timefield,numberfield,textarea,textfield
	var itmValue = '';
	var field = Ext.getCmp(arguments[0]);
	if (field) {
		var itmType = field.getXType();
		if (itmType == 'combo') {
			//if (field.getRawValue() != ''){
				itmValue = field.getValue();
			/*	var valueField = field.valueField;
				var index = field.getStore().find(valueField,itmValue);
				if (index<0) itmValue = '';
			}*/
		} else if (itmType == 'datefield') {
			itmValue = field.getRawValue();
		} else if (itmType == 'timefield') {
			itmValue = field.getRawValue();
		} else if (itmType == 'checkboxgroup') {
			var chkGrpItems = field.getValue();
			for (var idx = 0; idx < chkGrpItems.length; idx++)
			{
				var cb = chkGrpItems[idx];
				itmValue = itmValue + "," + cb.inputValue;
			}
			if (itmValue) itmValue=itmValue.substring(1,itmValue.length);
		} else if (itmType=='radiogroup'){
			var chkGrpItems = field.getValue();
			if (chkGrpItems!=null)
			{
				itmValue = chkGrpItems.inputValue;
			}else {
				itmValue="";
			}
		}else if (itmType == 'label') {
			itmValue = field.text;
		} else {
			itmValue = field.getValue();
		}
	}
	return itmValue;
}

function Common_GetText()
{
	//checkbox,combo,datefield,timefield,numberfield,textarea,textfield
	var itmValue = '';
	var field = Ext.getCmp(arguments[0]);
	if (field) {
		var itmType = field.getXType();
		if (itmType == 'combo') {
			itmValue = field.getRawValue();
		} else if (itmType == 'datefield') {
			itmValue = field.getRawValue();
		} else if (itmType == 'timefield') {
			itmValue = field.getRawValue();
		} else if (itmType == 'checkboxgroup') {
			var chkGrpItems = field.getValue();
			for (var idx = 0; idx < chkGrpItems.length; idx++)
			{
				var cb = chkGrpItems[idx];
				itmValue = itmValue + "," + cb.boxLabel;
			}
			if (itmValue) itmValue=itmValue.substring(1,itmValue.length);
		} else {
			itmValue = field.getValue();
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
	var field = Ext.getCmp(arguments[0]);
	if (field) {
		var itmType = field.getXType();
		if (itmType == 'checkbox') {
			if (itmValue!=0&&itmValue!=false) {
				field.setValue(true);
			} else {
				field.setValue(false);
			}
		} else if (itmType == 'combo') {
			if (itmValue != ''){
				var store = field.getStore();
				if (store.getCount()>0){
					var selectedIndex = store.find(field.valueField,itmValue);
					if (selectedIndex > -1){
						field.setValue(itmValue);
						field.setRawValue(itmRawValue);
					} else {
						field.setValue('');
						field.setRawValue(itmRawValue);
					}
				} else {
					field.getStore().load({
						callback : function(records, options, success) {
							if (success){
								if (records.length > 0){
									var selectedIndex = store.find(field.valueField,itmValue);
									if (selectedIndex > -1){
										field.setValue(itmValue);
										field.setRawValue(itmRawValue);
									} else {
										field.setValue('');
										field.setRawValue(itmRawValue);
									}
								} else {
									field.setValue('');
									field.setRawValue(itmRawValue);
								}
							}
						}
					});
				}
			} else {
				field.setValue('');
				field.setRawValue(itmRawValue);
			}
		} else if (itmType == 'datefield') {
			field.setRawValue(itmValue);
		} else if (itmType == 'timefield') {
			field.setRawValue(itmValue);
		} else if (itmType == 'numberfield') {
			field.setValue(itmValue);
		} else if (itmType == 'textarea') {
			field.setValue(itmValue);
		} else if (itmType == 'textfield') {
			field.setValue(itmValue);
		} else if (itmType == 'checkboxgroup') {
			if ((itmValue == '')&&(itmRawValue == '')) {
				if (Object.prototype.toString.call(field.items) === '[object Array]') {
					for (var idx = 0; idx < field.items.length; idx++) {
						var cb = field.items[idx];
						cb.checked = false;
					}
				} else {
					for (var idx = 0; idx < field.items.length; idx++) {
						var cb = field.items.itemAt(idx);
						cb.setValue(false);
					}
				}
			} else {
				var cbValues = itmValue.split(',');
				var cbTexts = itmRawValue.split(',');
				if (Object.prototype.toString.call(field.items) === '[object Array]') {
					for (var idx = 0; idx < field.items.length; idx++) {
						var cb = field.items[idx];
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
					for (var idx = 0; idx < field.items.length; idx++) {
						var cb = field.items.itemAt(idx);
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
			field.setText(itmValue);
		} else if (itmType == 'radiogroup') {
			field.setValue(itmValue);
		} else {
			field.setValue(itmValue);
		}
	}
	return itmValue;
}

function Common_SetDisabled()
{
	var field = Ext.getCmp(arguments[0]);
	if (field) {
		field.setDisabled(arguments[1]);
	}
	return true;
}

function Common_SetVisible()
{
	var field = Ext.getCmp(arguments[0]);
	if (field) {
		field.setVisible(arguments[1]);
	}
	return true;
}

function Common_CheckboxGroupToDic()
{
	var anchor = (arguments[4] ? arguments[4] : '98%');
	
	var arrItem = new Array();
	//var objDictionarySrv = ExtTool.StaticServerObject("DHCWMR.SSService.DictionarySrv");
	//var strDicList = objDictionarySrv.GetDicsByType(arguments[2]);
	if (arguments[5]) {
		var lnkHospCmp = arguments[5];
		var HospID = Common_GetValue(lnkHospCmp);
	} else {
		var HospID = '';
	}
	var strDicList = ExtTool.RunServerMethod("DHCWMR.SSService.DictionarySrv","GetDicsByType",arguments[2],HospID);
	var dicList = strDicList.split(String.fromCharCode(1));
	for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
		var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
		var chkItem = {
			id : arguments[0] + '-' + dicSubList[0],
			boxLabel : dicSubList[2],
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
		,anchor : anchor
	});
	
	return cbgDictionary;
}
//CheckboxGroup(Common_CheckboxGroupToDic)引用例子
//obj.Operation_cbgEmerOperType = Common_CheckboxGroupToDic("Operation_cbgEmerOperType","手术类型","OperationType",4);

function Common_RadioGroupToDic()
{
	var anchor = (arguments[4] ? arguments[4] : '100%');
	
	var arrItem = new Array();
	//var objDictionarySrv = ExtTool.StaticServerObject("DHCWMR.SSService.DictionarySrv");
	//var strDicList = objDictionarySrv.GetDicsByType(arguments[2]);
	var strDicList = ExtTool.RunServerMethod("DHCWMR.SSService.DictionarySrv","GetDicsByType",arguments[2]);
	var dicList = strDicList.split(String.fromCharCode(1));
	for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
		var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
		var chkItem = {
			id : arguments[0] + '-' + dicSubList[0],
			boxLabel : dicSubList[2],
			labelSeparator :'',
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
		,fieldLabel : arguments[1]
		,xtype : 'checkboxgroup'
		,columns : (arguments[3] ? arguments[3] : 4)
		,items : arrItem
		,width : 10
		,anchor : anchor
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
		,fieldLabel : arguments[1]
		,labelSeparator :''
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
		,fieldLabel : arguments[1]
		,labelSeparator :''
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

function Common_TimeField()
{
	var anchor = (arguments[2] ? arguments[2] : '100%');
	
	var tmpTimeField = new Ext.form.TimeField({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
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
		,fieldLabel : arguments[1]
		,labelSeparator :''
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
		var AddItem = '';
	}
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
		,minChars : 0
		,displayField : 'DicDesc'
		,valueField : 'DicRowId'
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

function Common_TextField()
{
	var anchor = (arguments[2] ? arguments[2] : '100%');
	
	var tmpTextField = new Ext.form.TextField({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,width : 10
		,anchor : anchor
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
		,fieldLabel : arguments[1]
		,labelSeparator :''
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
		,labelSeparator :''
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
		,fieldLabel : arguments[1]
		,labelSeparator :''
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
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,height : 24
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
		,fieldLabel : arguments[1]
		,labelSeparator :''
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
		var AddItem = '';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.HospitalSrv';
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
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{LocDesc}</td>',
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
							callback : function(records, options, success){
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
function Common_LoadCurrPage(gridId,initFlag)
{
	var objGrid = Ext.getCmp(gridId);
	if (objGrid) {
		if (objGrid.getBottomToolbar()) {
			var start=objGrid.getBottomToolbar().cursor;
			var limit=objGrid.getBottomToolbar().pageSize;
			objGrid.getStore().removeAll();
			if (initFlag){
				objGrid.getStore().load({params:{start:0,limit:limit}});
			} else {
				objGrid.getStore().load({params:{start:start,limit:limit}});
			}
		}else{      //add by wuqk 2013-03-08
			objGrid.getStore().removeAll();
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
	
	if (Date.parse(startMonth+"/"+startDay+"/"+startYear) > Date.parse(endMonth+"/"+endDay+"/"+endYear)) { 
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
	if(isNaN(tmpDateTime)){
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
	}
	
	return tmpDateTime
}

function Common_ComboToCTHosp()
{
	if (arguments[2]) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '';
	}
	var anchor = (arguments[3] ? arguments[3] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.HospitalSrv';
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
			callback : function(records, options, success){
				for (var indRec = 0; indRec < records.length; indRec++){
					var objRec = records[indRec];
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
	var anchor = (arguments[3] ? arguments[3] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.HospitalSrv';
						param.QueryName = 'QrySSHospByCode';
						param.Arg1      = SSHospCode;
						param.ArgCnt    = 1;
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
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToSSHosp)引用例子
//obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院","");

function Common_ComboToMrType()
{
	var MrClass = arguments[2];
	var lnkHospCmp = arguments[3];
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.MrTypeSrv';
						param.QueryName = 'QueryMrType';
						param.Arg1      = MrClass;
						param.Arg2      = Common_GetValue(lnkHospCmp);
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'MrTypeRowId'
				}, 
				[
					{name: 'MrTypeID', mapping: 'MrTypeID'}
					,{name: 'MrTypeDesc', mapping: 'MrTypeDesc'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{MrTypeDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'MrTypeID'
		,displayField : 'MrTypeDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,editable : false
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success){
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
//ComboBox(Common_ComboToMrType)引用例子
//obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型","I","cboHospital");

function Common_ComboToWFItem()
{
	var lnkMrTypeCmp = arguments[2];
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.WorkFlowSrv';
						param.QueryName = 'QryWFItemByMrType';
						param.Arg1      = Common_GetValue(lnkMrTypeCmp);
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'WFItemID'
				}, 
				[
					{name: 'WFItemID', mapping: 'WFItemID'}
					,{name: 'WFItemDesc', mapping: 'WFItemDesc'}
					,{name: 'ItemID', mapping: 'ItemID'}
					,{name: 'ItemType', mapping: 'ItemType'}
					,{name: 'SubFlow', mapping: 'SubFlow'}
					,{name: 'PostStep', mapping: 'PostStep'}
					,{name: 'SysOpera', mapping: 'SysOpera'}
					,{name: 'CheckUser', mapping: 'CheckUser'}
					,{name: 'BeRequest', mapping: 'BeRequest'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{WFItemDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'WFItemID'
		,displayField : 'WFItemDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success){
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
//ComboBox(Common_ComboToWFItem)引用例子
//obj.cboWFItem = Common_ComboToWFItem("cboWFItem","操作项目","cboMrType");

function Common_RadioGroupToDC()
{
	var arrItem = new Array();
	//var objDictionarySrv = ExtTool.StaticServerObject("DHCWMR.SSService.DictionarySrv");
	//var strDicList = objDictionarySrv.GetDicsByType(arguments[2]);
	var strDicList = ExtTool.RunServerMethod("DHCWMR.SSService.DictionarySrv","GetDicsByTypeA",arguments[2],"","");
	var dicList = strDicList.split(String.fromCharCode(1));
	for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
		var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
		var chkItem = {
			id : arguments[0] + '-' + dicSubList[1],
			boxLabel : dicSubList[2],
			name : arguments[0] + '-' + dicSubList[1],
			inputValue : dicSubList[1],
			checked : false,
			style:"vertical-align:middle; margin-top:-2px;",  //fix IE11界面有多余的滚动条 
			
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
//CheckboxGroup(Common_RadioGroupToDC)引用例子
//obj.cbgWFIType = Common_RadioGroupToDC("cbgWFIType","项目类型","WorkType",3);

function Common_CheckboxGroupToDC()
{
	var arrItem = new Array();
	//var objDictionarySrv = ExtTool.StaticServerObject("DHCWMR.SSService.DictionarySrv");
	//var strDicList = objDictionarySrv.GetDicsByType(arguments[2]);
	if (arguments[4]) {
		var lnkHospCmp = arguments[4];
		var HospID = Common_GetValue(lnkHospCmp);
	} else {
		var HospID = '';
	}
	var strDicList = ExtTool.RunServerMethod("DHCWMR.SSService.DictionarySrv","GetDicsByTypeA",arguments[2],HospID,"1");
	var dicList = strDicList.split(String.fromCharCode(1));
	for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
		var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
		var chkItem = {
			id : arguments[0] + '-' + dicSubList[1],
			boxLabel : dicSubList[2],
			name : arguments[0] + '-' + dicSubList[1],
			inputValue : dicSubList[1],
			style:"vertical-align:middle; margin-top:-2px;",  //fix IE11界面有多余的滚动条 
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
		,anchor : '98%'
	});
	return cbgDictionary;
}
//CheckboxGroup(Common_CheckboxGroupToDC)引用例子
//obj.cbgWFIType = Common_CheckboxGroupToDC("cbgWFIType","项目类型","WorkType",3);

//借阅科室
function Common_ComboToLendLoc()
{
	var LocType = arguments[2];
	var AdmType = arguments[3];
	var lnkHospCmp = arguments[4];
	if (arguments.length>5) {
		var AddItem = arguments[5];
	} else {
		var AddItem = '';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.CommonSrv';
						param.QueryName = 'QryLoctionByAlias';
						param.Arg1      = tmpCombo.getRawValue();
						param.Arg2      = Common_GetValue(lnkHospCmp);
						param.Arg3      = ((LocType) ? LocType : '');
						param.Arg4      = ((AdmType) ? AdmType : '');
						param.Arg5      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 5;
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
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{LocRowId}</td>',
					'<td>{LocDesc}</td>',
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
							callback : function(records, options, success){
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

//借阅医师
function Common_ComboToLendUser()
{
	if (arguments.length>2) {
		var lnkLocCmp = arguments[2];
	} else {
		var lnkLocCmp = '';
	}
	if (arguments.length>3) {
		var AddItem = arguments[3];
	} else {
		var AddItem = '';
	}
	if (arguments.length>4) {
		var IntTp = arguments[4];
	} else {
		var IntTp = '';
	}
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.CommonSrv';
						param.QueryName = 'QryCareProvByAlias';
						param.Arg1      = tmpCombo.getRawValue();
						param.Arg2      = Common_GetValue(lnkLocCmp);
						param.Arg3      = IntTp;			//类型 DOCTOR、NURSE
						param.Arg4      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 4;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'CTPID'
				}, 
				[
					{name: 'CTPID', mapping: 'CTPID'}
					,{name: 'CTPCode', mapping: 'CTPCode'}
					,{name: 'CTPDesc', mapping: 'CTPDesc'}
					,{name: 'CTPPinYin', mapping: 'CTPPinYin'}
					,{name: 'CTPTpDesc', mapping: 'CTPTpDesc'}
					,{name: 'CTPIntTp', mapping: 'CTPIntTp'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{CTPCode}</td>',
					'<td>{CTPDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'CTPID'
		,displayField : 'CTPDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success){
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

//付款类型
function Common_ComboToSocialStatus()
{
	if (arguments.length>2) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.CommonSrv';
						param.QueryName = 'QuerySocialStatus';
						param.Arg1      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'ItemID'
				}, 
				[
					{name: 'ItemID', mapping: 'ItemID'}
					,{name: 'ItemCode', mapping: 'ItemCode'}
					,{name: 'ItemDesc', mapping: 'ItemDesc'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ItemDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'ItemID'
		,displayField : 'ItemDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success){
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

//证件类型
function Common_ComboToCardType()
{
	if (arguments.length>2) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.CommonSrv';
						param.QueryName = 'QueryCardType';
						param.Arg1      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'ItemID'
				}, 
				[
					{name: 'ItemID', mapping: 'ItemID'}
					,{name: 'ItemCode', mapping: 'ItemCode'}
					,{name: 'ItemDesc', mapping: 'ItemDesc'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ItemDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'ItemID'
		,displayField : 'ItemDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success){
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


//性别
function Common_ComboToSex()
{
	if (arguments.length>2) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.CommonSrv';
						param.QueryName = 'QuerySex';
						param.Arg1      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'ItemID'
				}, 
				[
					{name: 'ItemID', mapping: 'ItemID'}
					,{name: 'ItemCode', mapping: 'ItemCode'}
					,{name: 'ItemDesc', mapping: 'ItemDesc'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ItemDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'ItemID'
		,displayField : 'ItemDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success){
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

//婚姻状况
function Common_ComboToMarital()
{
	if (arguments.length>2) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.CommonSrv';
						param.QueryName = 'QueryMarital';
						param.Arg1      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'ItemID'
				}, 
				[
					{name: 'ItemID', mapping: 'ItemID'}
					,{name: 'ItemCode', mapping: 'ItemCode'}
					,{name: 'ItemDesc', mapping: 'ItemDesc'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ItemDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'ItemID'
		,displayField : 'ItemDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success){
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

//民族
function Common_ComboToNation()
{
	if (arguments.length>2) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.CommonSrv';
						param.QueryName = 'QueryNation';
						param.Arg1      = tmpCombo.getRawValue();
						param.Arg2      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'ItemID'
				}, 
				[
					{name: 'ItemID', mapping: 'ItemID'}
					,{name: 'ItemCode', mapping: 'ItemCode'}
					,{name: 'ItemDesc', mapping: 'ItemDesc'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ItemDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'ItemID'
		,displayField : 'ItemDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success){
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


//国籍
function Common_ComboToCountry()
{
	if (arguments.length>2) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.CommonSrv';
						param.QueryName = 'QueryCountry';
						param.Arg1      = tmpCombo.getRawValue();
						param.Arg2      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'ItemID'
				}, 
				[
					{name: 'ItemID', mapping: 'ItemID'}
					,{name: 'ItemCode', mapping: 'ItemCode'}
					,{name: 'ItemDesc', mapping: 'ItemDesc'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ItemDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'ItemID'
		,displayField : 'ItemDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success){
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

//联系关系
function Common_ComboToRelation()
{
	if (arguments.length>2) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.CommonSrv';
						param.QueryName = 'QueryRelation';
						param.Arg1      = tmpCombo.getRawValue();
						param.Arg2      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'ItemID'
				}, 
				[
					{name: 'ItemID', mapping: 'ItemID'}
					,{name: 'ItemCode', mapping: 'ItemCode'}
					,{name: 'ItemDesc', mapping: 'ItemDesc'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ItemDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'ItemID'
		,displayField : 'ItemDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success){
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

//职业
function Common_ComboToOccupation()
{
	if (arguments.length>2) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.CommonSrv';
						param.QueryName = 'QueryOccupation';
						param.Arg1      = tmpCombo.getRawValue();
						param.Arg2      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'ItemID'
				}, 
				[
					{name: 'ItemID', mapping: 'ItemID'}
					,{name: 'ItemCode', mapping: 'ItemCode'}
					,{name: 'ItemDesc', mapping: 'ItemDesc'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ItemDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'ItemID'
		,displayField : 'ItemDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success){
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

//省
function Common_ComboToProvince()
{
	if (arguments.length>2) {
		var lnkLocCmp = arguments[2];
	} else {
		var lnkLocCmp = '';
	}
	if (arguments.length>3) {
		var AddItem = arguments[3];
	} else {
		var AddItem = '';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.CommonSrv';
						param.QueryName = 'QueryProvince';
						param.Arg1      = tmpCombo.getRawValue();
						param.Arg2      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'ItemID'
				}, 
				[
					{name: 'ItemID', mapping: 'ItemID'}
					,{name: 'ItemCode', mapping: 'ItemCode'}
					,{name: 'ItemDesc', mapping: 'ItemDesc'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ItemDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'ItemID'
		,displayField : 'ItemDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success){
								field.setValue('');
							}
						});
					}
				}
			}
			,select : function(field,e){
				if (lnkLocCmp!='')
				{
					Ext.getCmp(lnkLocCmp).reset();
					Ext.getCmp(lnkLocCmp).getStore().load({});
				}
			}
		}
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}

//市
function Common_ComboToCity()
{
	if (arguments.length>2) {
		var lnkLocCmp = arguments[2];
	} else {
		var lnkLocCmp = '';
	}
	if (arguments.length>3) {
		var AddItem = arguments[3];
	} else {
		var AddItem = '';
	}

	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCWMR.SSService.CommonSrv';
						param.QueryName = 'QueryCity';
						param.Arg1      = tmpCombo.getRawValue();
						param.Arg2      = Common_GetValue(lnkLocCmp);
						param.Arg3      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 3;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'ItemID'
				}, 
				[
					{name: 'ItemID', mapping: 'ItemID'}
					,{name: 'ItemCode', mapping: 'ItemCode'}
					,{name: 'ItemDesc', mapping: 'ItemDesc'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		//,mode:'local'
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ItemDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'ItemID'
		,displayField : 'ItemDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success){
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


function Common_RadioGroupToDicNew()
{
	var anchor = (arguments[4] ? arguments[4] : '100%');
	var checkflg= (arguments[4] ? true : false);
	var arrItem = new Array();
	//var objDictionarySrv = ExtTool.StaticServerObject("DHCWMR.SSService.DictionarySrv");
	//var strDicList = objDictionarySrv.GetDicsByType(arguments[2]);
	var strDicList = ExtTool.RunServerMethod("DHCWMR.SSService.DictionarySrv","GetDicsByType",arguments[2]);
	var dicList = strDicList.split(String.fromCharCode(1));
	for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
		var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
		var chkItem = {
			id : arguments[0] + '-' + dicSubList[0],
			boxLabel : dicSubList[2],
			name : arguments[0] + '-' + dicSubList[0],
			inputValue : dicSubList[0],
			checked : (checkflg&&dicIndex==0)?true:false,
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
	
	var cbgDictionary = new Ext.form.RadioGroup ({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,labelSeparator :''
		,xtype : 'RadioGroup'
		,columns : (arguments[3] ? arguments[3] : 4)
		,items : arrItem
		,width : 10
		,anchor : anchor
	});
	return cbgDictionary;
}
