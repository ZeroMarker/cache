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
	var objItm = Ext.getCmp(arguments[0]);
	if (objItm) {
		var itmType = objItm.getXType();
		if (itmType == 'combo') {
			if (objItm.getRawValue() != ''){ 
				itmValue = objItm.getValue();
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
			if (itmValue) {
				objItm.setValue(true);
			} else {
				objItm.setValue(false);
			}
		} else if (itmType == 'combo') {
			objItm.setValue(itmValue);
			objItm.setRawValue(itmRawValue);
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
	//var objDictionarySrv = ExtTool.StaticServerObject("DHCMed.NINFService.Srv.CommonSrv");
	//var strDicList = objDictionarySrv.GetDicsByType(arguments[2]);
	var strDicList = ExtTool.RunServerMethod("DHCMed.NINFService.Srv.CommonSrv","GetDicsByType",arguments[2]);
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
	//var objDictionarySrv = ExtTool.StaticServerObject("DHCMed.NINFService.Srv.CommonSrv");
	//var strDicList = objDictionarySrv.GetDicsByType(arguments[2]);
	var strDicList = ExtTool.RunServerMethod("DHCMed.NINFService.Srv.CommonSrv","GetDicsByType",arguments[2]);
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
		,fieldLabel : arguments[1]
		,format : 'Y-m-d H:i'
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
		,format : 'Y-m-d'
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 10
		,anchor : anchor
		,value : new Date()
	});
	
	return tmpDateField;
}
//DateField(Common_DateFieldToDate)引用例子
//obj.Infection_txtInfDate = Common_DateFieldToDate("Infection_txtInfDate","感染日期");
	
function Common_DateFieldToDate1()
{
	var anchor = (arguments[2] ? arguments[2] : '100%');
	
	var tmpDateField = new Ext.form.DateField({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,format : 'Y-m-d'
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 10
		,anchor : anchor
	});
	
	return tmpDateField;
}

function Common_TextFieldToFormat()
{
	var formatStr = (arguments[2] ? arguments[2] : '');
	var tmpTimeField = new Ext.form.TextField({
		id : arguments[0]
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
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Srv.CommonCls';
						param.QueryName = 'QryDictionary';
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
//obj.Operation_cboAnaesthesia = Common_ComboToDic("Operation_cboAnaesthesia","麻醉方式","InfectionNarcosisType");
	
function Common_ComboToInfPos()
{
	var linkInfPosToDiag = arguments[2];
	var linkInfPosToOper = arguments[3];
	var anchor = (arguments[4] ? arguments[4] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Dic.InfPosition';
						param.QueryName = 'QryInfPosition';
						param.Arg1      = '1';
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'InfPosRowId'
			}, 
			[
				{name: 'InfPosRowId', mapping: 'InfPosRowId'}
				,{name: 'InfPosCode', mapping: 'InfPosCode'}
				,{name: 'InfPosDesc', mapping: 'InfPosDesc'}
			])
		})
		,minChars : 0
		,displayField : 'InfPosDesc'
		,valueField : 'InfPosRowId'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
		,listeners : {
			'select' :  function(objProxy, param){
				if (linkInfPosToDiag) {
					var objCmp = Ext.getCmp(linkInfPosToDiag);
					if (objCmp) {
						objCmp.getStore().removeAll();
						objCmp.getStore().load({});
						objCmp.clearValue();
					}
				}

				if (linkInfPosToOper) {
					var objCmp = Ext.getCmp(linkInfPosToOper);
					if (objCmp) {
						objCmp.getStore().removeAll();
						objCmp.getStore().load({});
						objCmp.clearValue();
					}
				}
			}
		}
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToInfPos)引用例子
//obj.Infection_cboInfPos = Common_ComboToInfPos("Infection_cboInfPos","感染部位");
	
function Common_ComboToInfDia()
{
	var linkInfPosToDiag = arguments[2];
	var anchor = (arguments[3] ? arguments[3] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Dic.InfDiagnose';
						param.QueryName = 'QryInfDiaByPos';
						param.Arg1  = Common_GetValue(linkInfPosToDiag);
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'InfDiaRowId'
			}, 
			[
				{name: 'InfDiaRowId', mapping: 'InfDiaRowId'}
				,{name: 'InfDiaICD', mapping: 'InfDiaICD'}
				,{name: 'InfDiaDesc', mapping: 'InfDiaDesc'}
			])
		})
		,minChars : 0
		,displayField : 'InfDiaDesc'
		,valueField : 'InfDiaRowId'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToInfDia)引用例子
//obj.Infection_cboInfDia = Common_ComboToInfDia("Infection_cboInfDia","感染诊断","Infection_cboInfPos");

function Common_ComboToInfDiagCat()
{
	var linkInfDiag = arguments[2];
	var anchor = (arguments[3] ? arguments[3] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Dic.MapDiagCat';
						param.QueryName = 'QryInfDiagCat';
						param.Arg1  = Common_GetValue(linkInfDiag);
						param.Arg2  = 'N';
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'IDCRowID'
			}, 
			[
				{name: 'IDCRowID', mapping: 'IDCRowID'}
				,{name: 'IDCCode', mapping: 'IDCCode'}
				,{name: 'IDCDesc', mapping: 'IDCDesc'}
			])
		})
		,minChars : 0
		,displayField : 'IDCDesc'
		,valueField : 'IDCRowID'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToInfDiagCat)引用例子
//obj.Infection_cboInfDiagCat = Common_ComboToInfDiagCat("Infection_cboInfDiagCat","诊断分类","Infection_cboInfDiag");

function Common_ComboToPathogeny()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Dic.Pathogeny';
						param.QueryName = 'QryPyToCombo';
						param.Arg1 =  tmpCombo.getRawValue();
						param.Arg2 =  "1";
						param.ArgCnt = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader(
				{
					root: 'record',
					totalProperty: 'total',
					idProperty: 'PyID'
				},
				[
					{name: 'PyID', mapping: 'PyID'}
					,{name: 'PyCode', mapping: 'PyCode'}
					,{name: 'PyDesc', mapping: 'PyDesc'}
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
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{PyDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'PyID'
		,displayField : 'PyDesc'
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
//ComboBox(Common_ComboToPathogeny)引用例子
//obj.LabSystem_cboPathogeny = Common_ComboToPathogeny("LabSystem_cboPathogeny","病原体");

function Common_ComboToAntibiotics()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Dic.Antibiotics';
						param.QueryName = 'QryAntiToCombo';
						param.Arg1 =  tmpCombo.getRawValue();
						param.Arg2 =  "1";
						param.ArgCnt = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader(
				{
					root: 'record',
					totalProperty: 'total',
					idProperty: 'AntiID'
				},
				[
					{name: 'AntiID', mapping: 'AntiID'}
					,{name: 'AntiCode', mapping: 'AntiCode'}
					,{name: 'AntiDesc', mapping: 'AntiDesc'}
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
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{AntiDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,ideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'AntiID'
		,displayField : 'AntiDesc'
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
//ComboBox(Common_ComboToAntibiotics)引用例子
//obj.LabSystem_cboAntibiotics = Common_ComboToAntibiotics("LabSystem_cboAntibiotics","抗生素");
	
function Common_ComboToSSUser()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Srv.CommonCls';
						param.QueryName = 'QryUserByAlias';
						param.Arg1      = tmpCombo.getRawValue();
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Rowid'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'Rowid', mapping: 'Rowid'}
				,{name: 'Code', mapping: 'Code'}
				,{name: 'Name', mapping: 'Name'}
				,{name: 'SSGroupDesc', mapping: 'SSGroupDesc'}
			])
		})
		,minChars : 2
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>姓名</th>',
					'<th>工号</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{Name}</td>',
					'<td>{Code}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'Rowid'
		,displayField : 'Name'
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
//ComboBox(Common_ComboToSSUser)引用例子
//obj.Operation_cboOperDoc = Common_ComboToSSUser("Operation_cboOperDoc","术者");
	
function Common_ComboToMRCICDDx()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Srv.CommonCls';
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
					,{name: 'ICD10', mapping: 'ICD10'}
					,{name: 'ICDDesc', mapping: 'ICDDesc'}
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
		,minListWidth:100
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
//ComboBox(Common_ComboToMRCICDDx)引用例子
//obj.Diagnose_cboDiagnose = Common_ComboToMRCICDDx("Diagnose_cboDiagnose","主要诊断");
	
function Common_ComboToORCOperation()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Srv.CommonCls';
						param.QueryName = 'QueryOperation';
						param.Arg1 =  tmpCombo.getRawValue();
						param.ArgCnt = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'OperRowId'
			}, 
			[
				{name: 'OperRowId', mapping: 'OperRowId'}
				,{name: 'OperDesc', mapping: 'OperDesc'}
				,{name: 'OperCM3', mapping: 'OperCM3'}
			])
		})
		,minChars : 2
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>手术名称</th>',
					'<th>CM3</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{OperDesc}</td>',
					'<td>{OperCM3}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'OperRowId'
		,displayField : 'OperDesc'
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
//ComboBox(Common_ComboToORCOperation)引用例子
//obj.Operation_cboOperation = Common_ComboToORCOperation("Operation_cboOperation","手术名称");
	
function Common_TextField()
{
	var tmpTextField = new Ext.form.TextField({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,width : 10
		,anchor : '100%'
	});
	
	return tmpTextField;
}

function Common_TextField1()
{
	if (typeof arguments[4] == 'undefined') arguments[4] = "";
	var tmpTextField = new Ext.form.TextField({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,width : arguments[2]
		,anchor : arguments[3]
		,emptyText : arguments[4]
	});
	
	return tmpTextField;
}

//TextField(Common_TextField)引用例子
//obj.Operation_txtResume = Common_TextField("Operation_txtResume","备注");


function Common_TextArea()
{
	var height = (arguments[2] ? arguments[2] : 10);
	var maxLength = (arguments[3] ? arguments[3] : 500);
	var anchor = (arguments[4] ? arguments[4] : '100%');
	
	var tmpTextField = new Ext.form.TextArea({
		id : arguments[0]
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
		,fieldLabel : arguments[1]
		,anchor : '100%'
	});
	
	return tmpCheckbox;
}
//Checkbox(Common_Checkbox)引用例子
//obj.Operation_chkIsCuteInf = Common_Checkbox("Operation_chkIsCuteInf","是否感染");
	
function Common_ComboToAdmAnti()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL + 
				'?1=1&ClassName=DHCMed.NINFService.Rep.AimReportOPR&QueryName=QryAdmAnti&Arg1=' + arguments[2] + '&Arg2=Y&ArgCnt=2&2=2'
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'OEORIID'
			}, 
			[
				{name: 'OEORIID', mapping: 'OEORIID'}
				,{name: 'OEORIPriority', mapping: 'OEORIPriority'}
				,{name: 'OEORIItmMast', mapping: 'OEORIItmMast'}
				,{name: 'OEOrdStartDate', mapping: 'OEOrdStartDate'}
				,{name: 'OEOrdEndDate', mapping: 'OEOrdEndDate'}
				,{name: 'OEORIInstr', mapping: 'OEORIInstr'}
				,{name: 'OEORIPHFreq', mapping: 'OEORIPHFreq'}
				,{name: 'OEORIQty', mapping: 'OEORIQty'}
				,{name: 'OEORIPackUom', mapping: 'OEORIPackUom'}
				,{name: 'OEORIDoseQty', mapping: 'OEORIDoseQty'}
				,{name: 'OEORIUnit', mapping: 'OEORIUnit'}
				,{name: 'OEORIDays', mapping: 'OEORIDays'}
				,{name: 'OEORIIDStr', mapping: 'OEORIIDStr'}
				,{name: 'OEORIDescStr', mapping: 'OEORIDescStr'}
			])
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>医嘱名称</th>',
					'<th>医嘱类型</th>',
					'<th>开始日期</th>',
					'<th>结束日期</th>',
					'<th>用法</th>',
					'<th>剂量</th>',
					'<th>剂量<br>单位</th>',
					'<th>频次</th>',
					'<th>用药<br>天数</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{OEORIItmMast}</td>',
					'<td>{OEORIPriority}</td>',
					'<td>{OEOrdStartDate}</td>',
					'<td>{OEOrdEndDate}</td>',
					'<td>{OEORIInstr}</td>',
					'<td>{OEORIDoseQty}</td>',
					'<td>{OEORIUnit}</td>',
					'<td>{OEORIPHFreq}</td>',
					'<td>{OEORIDays}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		,minListWidth:400
		,valueField : 'OEORIID'
		,displayField : 'OEORIItmMast'
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
//ComboBox(Common_ComboToAdmAnti)引用例子
//obj.OPR_cboAdmAnti = Common_ComboToAdmAnti("OPR_cboAdmAnti","抗生素");


function Common_ComboToArcim()
{
	var linkArcimType = arguments[2];
	var linkCmpList = arguments[3];
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Srv.CommonCls';
						param.QueryName = 'QryArcimByAlias';
						param.Arg1  = tmpCombo.getRawValue();
						param.Arg2  = Common_GetValue(linkArcimType);
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'ArcimID'
			}, 
			[
				{name: 'ArcimID', mapping: 'ArcimID'}
				,{name: 'ArcimCode', mapping: 'ArcimCode'}
				,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
			])
		})
		,minChars : 2
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>医嘱代码</th>',
					'<th>医嘱名称</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ArcimCode}</td>',
					'<td>{ArcimDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:300
		,valueField : 'ArcimID'
		,displayField : 'ArcimDesc'
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
			,'select' :  function(objProxy, param){
				if (linkCmpList) {
					var arrCmp = linkCmpList.split(',');
					for (var ind = 0; ind < arrCmp.length; ind++) {
						var cmp = arrCmp[ind];
						var objCmp = Ext.getCmp(cmp);
						if (objCmp) {
							objCmp.getStore().removeAll();
							objCmp.getStore().load({});
							objCmp.clearValue();
						}
					}
				}
			}
		}
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToArcim)引用例子
//obj.ANTI_cboArcim = Common_ComboToArcim("ANTI_cboArcim","药品医嘱","R","ANTI_cboDoseUnit");


function Common_ComboToDoseUnit()
{
	var linkCmp = arguments[2];
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Srv.CommonCls';
						param.QueryName = 'QryDoseUnit';
						param.Arg1      = Common_GetValue(linkCmp);
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'UnitID'
			}, 
			[
				{name: 'UnitID', mapping: 'UnitID'}
				,{name: 'UnitDesc', mapping: 'UnitDesc'}
			])
		})
		,minChars : 0
		,displayField : 'UnitDesc'
		,valueField : 'UnitID'
		,editable : true
		,triggerAction : 'all'
		,width : 10
		,anchor : '100%'
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToDoseUnit)引用例子
//obj.ANTI_cboDoseUnit = Common_ComboToDoseUnit("ANTI_cboDoseUnit","剂量单位","ANTI_cboArcim");

function Common_ComboToFreq()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Srv.CommonCls';
						param.QueryName = 'QryFreqByAlias';
						param.Arg1      = tmpCombo.getRawValue();
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'FreqID'
			}, 
			[
				{name: 'FreqID', mapping: 'FreqID'}
				,{name: 'FreqDesc', mapping: 'FreqDesc'}
			])
		})
		,minChars : 0
		,displayField : 'FreqDesc'
		,valueField : 'FreqID'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : '100%'
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToFreq)引用例子
//obj.Anti_cboFreq = Common_ComboToFreq("Anti_cboFreq","频次");

function Common_ComboToDateType()
{
	var tmpValue = arguments[3];
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL + '?1=1&ClassName=DHCMed.NINFService.Rep.AimReport&QueryName=QryDateType&Arg1=' + arguments[2] + '&ArgCnt=1&2=2'
				,failure : function() {
					Ext.Msg.alert("数据加载失败！请检查");
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'TypeCode'
			}, 
			[
				{name: 'TypeCode', mapping: 'TypeCode'}
				,{name: 'TypeDesc', mapping: 'TypeDesc'}
			])
		})
		,minChars : 0
		,displayField : 'TypeDesc'
		,valueField : 'TypeCode'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : '100%'
	});
	tmpCombo.getStore().load({
		callback : function(){
			var strValue = tmpValue;
			if (strValue!='') {
				var arrValue = strValue.split(CHR_1);
				for (var ind = 0; ind < arrValue.length; ind++)
				{
					var index = this.find('TypeDesc',arrValue[ind]);
					if (index > -1) {
						var objRec = this.getAt(index);
						if (objRec)
						{
							tmpCombo.setValue(objRec.get('TypeCode'));
							tmpCombo.setRawValue(objRec.get('TypeDesc'));
						}
					}
				}
			}
		}
	});
	return tmpCombo;
}
//ComboBox(Common_ComboToDateType)引用例子
//obj.cboDateType = Common_ComboToDateType("cboDateType","日期类型","MDR","填报日期");


function Common_ComboToDateType1()
{
	var tmpValue = arguments[2];
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL + '?1=1&ClassName=DHCMed.NINFService.Rep.InfReport&QueryName=QryDateType&ArgCnt=0&2=2'
				,failure : function() {
					Ext.Msg.alert("数据加载失败！请检查");
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'TypeCode'
			}, 
			[
				{name: 'TypeCode', mapping: 'TypeCode'}
				,{name: 'TypeDesc', mapping: 'TypeDesc'}
			])
		})
		,minChars : 0
		,displayField : 'TypeDesc'
		,valueField : 'TypeCode'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : '100%'
	});
	tmpCombo.getStore().load({
		callback : function(){
			var strValue = tmpValue;
			if (strValue!='') {
				var arrValue = strValue.split(CHR_1);
				for (var ind = 0; ind < arrValue.length; ind++)
				{
					var index = this.find('TypeDesc',arrValue[ind]);
					if (index > -1) {
						var objRec = this.getAt(index);
						if (objRec)
						{
							tmpCombo.setValue(objRec.get('TypeCode'));
							tmpCombo.setRawValue(objRec.get('TypeDesc'));
						}
					}
				}
			}
		}
	});
	return tmpCombo;
}
//ComboBox(Common_ComboToDateType1)引用例子
//obj.cboDateType = Common_ComboToDateType1("cboDateType","日期类型","MDR","填报日期");

function Common_DateFieldToMonth()
{
	var tmpDateField = new Ext.form.DateField({
		id : arguments[0]
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


function Common_DateFieldToMonth1()
{
	var tmpDateField = new Ext.form.DateField({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,plugins: 'monthPickerPlugin'
		,format :'Y-m'
		,editable : true
		,width : 10
		,anchor : '100%'
	});
	return tmpDateField;
}
//DateField(Common_DateFieldToMonth)引用例子
//obj.txtYearMonth = Common_DateFieldToMonth("txtYearMonth","年月");


/*
function Common_ComboToLoc()
{
	var LocType = arguments[2];
	var lnkLocCmp = arguments[3];
	var AdmType = arguments[4];
	if (arguments.length>5) {
		var AddItem = arguments[5];
	} else {
		var AddItem = '^-';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Srv.CommonCls';
						param.QueryName = 'QueryLoction';
						param.Arg1      = tmpCombo.getRawValue();
						param.Arg2      = '';
						param.Arg3      = Common_GetValue(lnkLocCmp);
						param.Arg4      = ((LocType) ? LocType : '');
						param.Arg5      = ((AdmType) ? AdmType : '');
						param.Arg6      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 6;
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
		/*
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
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'LocRowId'
		,displayField : 'LocDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		//////////////////
		,minChars : 0
		,displayField : 'LocDesc1'
		,valueField : 'LocRowId'
		,editable : true
		,triggerAction : 'all'
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
*/

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


//环境卫生学监测项目
function Common_ComboToEnviHyItem()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Dic.EnviHyItem';
						param.QueryName = 'QryEnviHyItem';
						param.Arg1      = '';
						param.Arg2      = '';
						param.Arg3      = '';
						param.Arg4      = '';
						param.Arg5      = '';
						param.Arg6      = '';
						param.Arg7      = '1';
						param.Arg8      = '';
						param.Arg9      = '';
						param.ArgCnt    = 9;
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
				,{name: 'ItemDesc', mapping: 'ItemDesc'}
			])
		})
		,minChars : 0
		,displayField : 'ItemDesc'
		,valueField : 'ItemID'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : '100%'
	});
	return tmpCombo;
}
//obj.cboEnviHyItem = Common_ComboToEnviHyItem("cboEnviHyItem","监测项目");

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


//Modified By LiYang 2012-11-27
//获取某个Episode的所有监控触发关键字
function GetEpisodeIntCtlResult(EpisodeID)
{
	var objResult = ExtTool.RunServerMethod("DHCMed.NINFService.Srv.INTInterface", "GetIntCntResult", "" , EpisodeID, "INFAW");
	return objResult;
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

//转科记录
function Common_ComboToTransLoc()
{
	var EpisodeID = arguments[2];
	var TransType = arguments[3];
	//var objDictionarySrv = ExtTool.StaticServerObject("DHCMed.NINFService.Srv.CommonSrv");
	//var strJson = objDictionarySrv.GetTransLocList(EpisodeID,TransType);
	var strJson = ExtTool.RunServerMethod("DHCMed.NINFService.Srv.CommonSrv","GetTransLocList",EpisodeID,TransType);
	var jsonData = Ext.util.JSON.decode(strJson);
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			data : jsonData,
			reader: new Ext.data.ArrayReader({
				idIndex: 0
			},Ext.data.Record.create([
				{name: 'TransID', mapping: 0}
				,{name: 'TransLocID', mapping: 1}
				,{name: 'TransLocDesc', mapping: 2}
				,{name: 'TransInTime', mapping: 3}
				,{name: 'TransOutTime', mapping: 4}
				,{name: 'PrevLocID', mapping: 5}
				,{name: 'PrevLocDesc', mapping: 6}
				,{name: 'NextLocID', mapping: 7}
				,{name: 'NextLocDesc', mapping: 8}
			]))
		})
		,mode : 'local'
		,editable : false
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>科室</th>',
					'<th>时间</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{TransLocDesc}</td>',
					'<td>{TransInTime}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,minListWidth:300
		,triggerAction : 'all'
		,valueField : 'TransID'
		,displayField : 'TransLocDesc'
		,emptyText:'请选择...'
		,width : 10
		,anchor : '100%'
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToTransLoc)引用例子
//obj.cboLoc = Common_ComboToTransLoc("cboLoc","填报科室",EpisodeID,TransType);

function Common_TextAreaToDC()
{
	var TextAreaID = arguments[0];
	var anchor = (arguments[3] ? arguments[3] : '100%');
	var InfPosCmpID = (arguments[4] ? arguments[4] : '');
	var InfDiagCmpID = (arguments[5] ? arguments[5] : '');
	var TypeCode = (arguments[6] ? arguments[6] : '');
	
	var tmpTextField = new Ext.form.TextArea({
		id : TextAreaID
		,fieldLabel : arguments[1]
		,preventScrollbars : true
		,width : 10
		,height : (arguments[2] ? arguments[2] : 10)
		,anchor : anchor
		,maxLength : 500
		,listeners : {
            'render' : function(){
				var _parentNode = Ext.getDom(TextAreaID).parentNode;
				Ext.get(_parentNode).createChild({
					tag : 'span',
					//src : '../scripts/dhcmed/img/find.gif'
					html : '<img id="' + TextAreaID + '-img" align="top" src="../scripts/dhcmed/img/finddic.gif"  alt="诊断依据和疾病病程" />'
				});
				
				Ext.lib.Event.addListener(TextAreaID + '-img','click',function(evt) {
					//取值感染部位ID
					var InfPosID = '';
					if (InfPosCmpID) {
						var InfPosCmp = Ext.getCmp(InfPosCmpID);
						if (InfPosCmp) {
							var InfPosID = InfPosCmp.getValue();
						}
					}
					//取值感染诊断ID
					var InfDiagID = '';
					if (InfDiagCmpID) {
						var InfDiagCmp = Ext.getCmp(InfDiagCmpID);
						if (InfDiagCmp) {
							var InfDiagID = InfDiagCmp.getValue();
						}
					}
					//诊断标准字典类型
					var IDGTypeCode=TypeCode;
					
					//设置窗体宽度与高度、X坐标和Y坐标
					var winHeight=400;
					var winWidth=600;
					//var winX=evt.clientX;
					//var winY=evt.clientY;
					
					//感染部位对应诊断依据列表
					var tmpGrid = new Ext.grid.EditorGridPanel({
						store : new Ext.data.GroupingStore({
							proxy: new Ext.data.HttpProxy({
								url : ExtToolSetting.RunQueryPageURL,
								listeners : {
									'beforeload' : function(objProxy, param){
										param.ClassName = 'DHCMed.NINFService.Dic.InfDiagnoseGist';
										param.QueryName = 'QryInfDiagGistList';
										param.Arg1      = IDGTypeCode;
										param.Arg2      = InfPosID;
										param.Arg3      = InfDiagID;
										param.ArgCnt    = 3;
									}
								}
							}),
							reader : new Ext.data.JsonReader({
								root : 'record',
								totalProperty : 'total',
								idProperty : 'IDGRowID'
							}, [
								{name : 'IsChecked',mapping : 'IsChecked'}
								,{name : 'IDGRowID',mapping : 'IDGRowID'}
								,{name : 'IDGTypeID',mapping : 'IDGTypeID'}
								,{name : 'IDGTypeDesc',mapping : 'IDGTypeDesc'}
								,{name : 'IDGCode',mapping : 'IDGCode'}
								,{name : 'IDGDesc',mapping : 'IDGDesc'}
								,{name : 'IDRowID',mapping : 'IDRowID'}
								,{name : 'IDDesc',mapping : 'IDDesc'}
							])
							,sortInfo:{field:'IDGRowID',direction:'ASC'}
							,groupField:'IDDesc'
						}),
						selModel : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
						columnLines : true,
						region : 'center',
						loadMask : true,
						height : 300,
						columns : [
							{header : '选择',width : 50,dataIndex : 'IsChecked',sortable : false,menuDisabled : true,align : 'center',
								renderer : function(v, m, rd, r, c, s) {
									var IsChecked = rd.get("IsChecked");
									if (IsChecked == '1') {
										return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
									} else {
										return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
									}
								}
							}
							,{header : '诊断标准',width : 500,dataIndex : 'IDGDesc',sortable : false, menuDisabled : true, align : 'left',
								renderer : function(v, m, rd, r, c, s) {
									m.attr = 'style="white-space:normal;"';
									return v;
								}
							}
							,{header : '感染诊断',width : 100,dataIndex : 'IDDesc', sortable: false, hidden:true}
						],
						view : new Ext.grid.GroupingView({
							forceFit:true,
							groupTextTpl:'{[values.rs[0].get("IDDesc")]}(共{[values.rs.length]}条诊断标准)',
							groupByText:'感染诊断'
						}),
						listeners : {
							'rowclick' : function() {
								var objRecOper = tmpGrid.getSelectionModel().getSelected();
								if (objRecOper.get("IsChecked") == '1') {
									var newValue = '0';
								} else {
									var newValue = '1';
								}
								objRecOper.set("IsChecked", newValue);
							}
						},
						viewConfig : {
							forceFit : true
						}
					});
					
					win = new Ext.Window({
						//id : 'win',
						width : winWidth,
						height : winHeight,
						//x : winX,
						//y : winY,
						resizable : false,
						closable : true,
						autoScroll:true,
						animCollapse : true,
						renderTo : document.body,
						layout : 'fit',
						modal : true,
						title : "",
						items : [
							tmpGrid
						],
						buttons : [{
							id : 'btnConfirm',
							text : '确定',
							listeners : {
								"click" : function(){
									var cmpText = '';
									var objCmp = Ext.getCmp(TextAreaID);
									if (objCmp) {
										cmpText = objCmp.getValue();
										
										var tmpReturn = '';
										var objStore = tmpGrid.getStore();
										for (var ind = 0; ind < objStore.getCount(); ind++) {
											var tmpRec = objStore.getAt(ind);
											if (tmpRec.get("IsChecked") == 1) {
												if (tmpReturn != '') {
													tmpReturn = tmpReturn + ' ';
												}
												tmpReturn = tmpReturn + tmpRec.get("IDGDesc");
											}
										}
										if ((tmpReturn != '')&&(cmpText != '')) {
											cmpText = cmpText + ' ';
										}
										cmpText = cmpText + tmpReturn
										objCmp.setValue(cmpText);
									}
									win.close();
								}
							}
						},{
							id : 'btnCancel',
							text : '取消',
							listeners : {
								"click" : function(){
									win.close();
								}
							}
						}],
						listeners :{
							'beforeshow' : function(){
								tmpGrid.getStore().load({});
							}
						}
					});
					win.show();
                });
            }
        }
	});
	
	return tmpTextField;
}
//TextField(Common_TextAreaToDC)引用例子
//obj.Operation_txtResume = Common_TextAreaToDC("Operation_txtResume","备注",50);

function Common_ComboToCate()
{
	var DicType = arguments[2];
	var lnkCmp = arguments[3];
	
	if (arguments.length>4) {
		var AddItem = arguments[4];
	} else {
		var AddItem = '^-';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName="DHCMed.NINF.Dic.Cate";
						param.QueryName="QueryByType";
						param.Arg1 = (lnkCmp ? Common_GetValue(lnkCmp) : '');
						param.Arg2 = DicType;
						param.Arg3 = 1;
						param.ArgCnt = 3;
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
					,{name: 'Description', mapping: 'Description'}
				]
			)
		})
		,minChars : 0
		,displayField : 'Description'
		,valueField : 'ID'
		,editable : true
		,triggerAction : 'all'
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
//ComboBox(Common_ComboToCate)引用例子
//obj.cboCate = Common_ComboToCate("cboCate","分类",'ANTCate','','');

function Common_ComboToCateItem()
{
	var DicType = arguments[2];
	var lnkCmp = arguments[3];
	
	if (arguments.length>4) {
		var AddItem = arguments[4];
	} else {
		var AddItem = '^-';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName="DHCMed.NINF.Dic.CateItem";
						param.QueryName="QueryByCate";
						param.Arg1 = (lnkCmp ? Common_GetValue(lnkCmp) : '');
						param.Arg2 = DicType;
						param.Arg3 = 1;
						param.ArgCnt = 3;
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
					,{name: 'Description', mapping: 'Description'}
				]
			)
		})
		,minChars : 0
		,displayField : 'Description'
		,valueField : 'ID'
		,editable : true
		,triggerAction : 'all'
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
//ComboBox(Common_ComboToCateItem)引用例子
//obj.cboCate = Common_ComboToCateItem("cboCate","分类",'ANTCate','','');

function Common_ComboToMRB()
{
	if (arguments.length>2) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '^-';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Dic.MRBSrv';
						param.QueryName = 'QryMRBToCombo';
						param.Arg1      =  "1";
						param.Arg2      = AddItem
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader(
				{
					root: 'record',
					totalProperty: 'total',
					idProperty: 'MRBID'
				},
				[
					{name: 'MRBID', mapping: 'MRBID'}
					,{name: 'MRBCode', mapping: 'MRBCode'}
					,{name: 'MRBDesc', mapping: 'MRBDesc'}
					,{name: 'MRBActive', mapping: 'MRBActive'}
					,{name: 'MRBActiveDesc', mapping: 'MRBActiveDesc'}
					,{name: 'MRBResume', mapping: 'MRBResume'}
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
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{MRBDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'MRBID'
		,displayField : 'MRBDesc'
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
//ComboBox(Common_ComboToMRB)引用例子
//obj.cboMRBDic = Common_ComboToMRB("cboMRBDic","多重耐药菌");


function Common_ComboToHandHyProducts()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Dic.HandHyProducts';
						param.QueryName = 'QryHHPToCombo';
						param.Arg1 =  tmpCombo.getRawValue();
						param.Arg2 =  "1";
						param.ArgCnt = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader(
				{
					root: 'record',
					totalProperty: 'total',
					idProperty: 'HHPID'
				},
				[
					{name: 'HHPID', mapping: 'HHPID'}
					,{name: 'HHPCode', mapping: 'HHPCode'}
					,{name: 'HHPDesc', mapping: 'HHPDesc'}
					,{name: 'HHPDescX', mapping: 'HHPDescX'}
					,{name: 'HHPDesc1', mapping: 'HHPDesc1'}
					,{name: 'HHPPinyin', mapping: 'HHPPinyin'}
					,{name: 'HHPSpec', mapping: 'HHPSpec'}
					,{name: 'HHPUnit', mapping: 'HHPUnit'}
					,{name: 'HHPActive', mapping: 'HHPActive'}
					,{name: 'HHPActiveDesc', mapping: 'HHPActiveDesc'}
					,{name: 'HHPResume', mapping: 'HHPResume'}
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
					'<th>规格</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{HHPDesc}</td>',
					'<td>{HHPSpec}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'HHPID'
		,displayField : 'HHPDescX'
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
//ComboBox(Common_ComboToHandHyProducts)引用例子
//obj.cboHandHyProducts = Common_ComboToHandHyProducts("cboHandHyProducts","手卫生用品");

function Common_ComboToLabLoc()
{
	if (arguments.length>2) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '^-';
	}
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Srv.CommonCls';
						param.QueryName = 'QueryLabUserLoc';
						param.Arg1      = tmpCombo.getRawValue();
						param.ArgCnt    = 1;
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
		/*
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
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'LocRowId'
		,displayField : 'LocDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		*/
		,minChars : 0
		,displayField : 'LocDesc1'
		,valueField : 'LocRowId'
		,editable : true
		,triggerAction : 'all'
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

function Common_ComboToSSHosp()
{
	var SSHospCode = arguments[2];
	var ProductCode = arguments[3];
	var anchor = (arguments[4] ? arguments[4] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
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
//ComboBox(Common_ComboToLabLoc)引用例子
//obj.cboLoc = Common_ComboToLabLoc("cboLoc","检验科室");

function Common_ComboToSSHospAA()
{
	var SSHospCode = arguments[2];
	var ProductCode = arguments[3];
	var anchor = (arguments[4] ? arguments[4] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
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

function Common_ComboRepStatus()
{
	var DicType = arguments[2];
	if (arguments[3]) {
		var AddItem = arguments[3];
	} else {
		var AddItem = '^-';
	}
	var anchor = (arguments[4] ? arguments[4] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName="DHCMed.SS.Dictionary";
						param.QueryName="QueryByType";
						param.Arg1 = DicType;
						param.Arg2 = 1;
						param.Arg3 = AddItem
						param.ArgCnt = 3;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'RowID'
				}, 
				[
					{name: 'RowID', mapping: 'RowID'}
					,{name: 'Code', mapping: 'Code'}
					,{name: 'Description', mapping: 'Description'}
				]
			)
		})
		,minChars : 0
		,displayField : 'Description'
		,valueField : 'RowID'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	return tmpCombo;
}
//ComboBox(Common_ComboRepStatus)引用例子
//obj.cboRepStatus = Common_ComboRepStatus("cboRepStatus","环境学报告状态");
