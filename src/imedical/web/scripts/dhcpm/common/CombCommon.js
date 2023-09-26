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
	//alert(objItm);
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
	var objDictionarySrv = ExtTool.StaticServerObject("DHCMed.NINFService.Srv.CommonSrv");
	var strDicList = objDictionarySrv.GetDicsByType(arguments[2]);
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
//CheckboxGroup(Common_CheckboxGroupToDic)��������
//obj.Operation_cbgEmerOperType = Common_CheckboxGroupToDic("Operation_cbgEmerOperType","��������","OperationType",4);

function Common_RadioGroupToDic()
{
	var arrItem = new Array();
	var objDictionarySrv = ExtTool.StaticServerObject("DHCMed.NINFService.Srv.CommonSrv");
	var strDicList = objDictionarySrv.GetDicsByType(arguments[2]);
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
//CheckboxGroup(Common_RadioGroupToDic)��������
//obj.Operation_cbgEmerOperType = Common_RadioGroupToDic("Operation_cbgEmerOperType","��������","OperationType",4);
	
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
//DateField(Common_DateFieldToDateTime)��������
//obj.Operation_txtEndDateTime = Common_DateFieldToDateTime("Operation_txtEndDateTime","��ʼʱ��");
	
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
//DateField(Common_DateFieldToDate)��������
//obj.Infection_txtInfDate = Common_DateFieldToDate("Infection_txtInfDate","��Ⱦ����");

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
				if (formatStr == 'Сʱ:����') {
					var indHour = value.indexOf('Сʱ');
					var indMin = value.indexOf('����');
					var valHour = (indHour > -1 ? Ext.util.Format.substr(value, 0, indHour) : '0')
					var valMin =(indMin > -1 ? (indHour > -1 ? Ext.util.Format.substr(value, indHour + 2, indMin - indHour - 2) : Ext.util.Format.substr(value, 0, indMin)) : '0')
					valHour = parseInt(valHour);
					valMin = parseInt(valMin);
					valHour = valHour + ((valMin - valMin % 60) / 60);
					valMin = valMin % 60;
					this.setValue(valHour + 'Сʱ' + valMin + '����');
				} else if (formatStr) {
					val = parseInt('0' + value);
					this.setValue(val + formatStr);
				}
			};
			this.el.on("focus", focus, this);
			
			var blur = function(e,field){
				var value = this.getValue();
				if (formatStr == 'Сʱ:����') {
					var indHour = value.indexOf('Сʱ');
					var indMin = value.indexOf('����');
					var valHour = (indHour > -1 ? Ext.util.Format.substr(value, 0, indHour) : '0')
					var valMin =(indMin > -1 ? (indHour > -1 ? Ext.util.Format.substr(value, indHour + 2, indMin - indHour - 2) : Ext.util.Format.substr(value, 0, indMin)) : '0')
					valHour = parseInt(valHour);
					valMin = parseInt(valMin);
					valHour = valHour + ((valMin - valMin % 60) / 60);
					valMin = valMin % 60;
					if ((valHour > 0)||(valMin >0)) {
						this.setValue(valHour + 'Сʱ' + valMin + '����');
					} else {
						this.setValue('');
					}
				} else if (formatStr) {
					val = parseInt('0' + value);
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
//TimeField(Common_TextFieldToFormat)��������
//obj.Anti_txtTime = Common_TextFieldToFormat("Anti_txtTime","��ǰ��ҩʱ��");

function Common_ComboToDic()
{
	//alert(1);
	var PMFlag = arguments[2];
	if (arguments[3]) {
		var PMStatusDesc = arguments[3];
	} else {
		var PMStatusDesc = '';
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
						param.ClassName = 'DHCPM.Query.PMQueryLookUp';
						param.QueryName = 'PMDicLookUp';
						param.Arg1      = PMStatusDesc;
						param.Arg2      = PMFlag
						param.ArgCnt    = 2;
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
				,{name: 'desc', mapping: 'desc'}
				
			])
		})
		,minChars : 0
		,displayField : 'desc'
		,valueField : 'rowid'
		,editable : true
		,valueNotFoundText : ''
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToDic)��������
//obj.Operation_cboAnaesthesia = Common_ComboToDic("Operation_cboAnaesthesia","����ʽ","InfectionNarcosisType");
	
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
						param.Arg1      = '';
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
//ComboBox(Common_ComboToInfPos)��������
//obj.Infection_cboInfPos = Common_ComboToInfPos("Infection_cboInfPos","��Ⱦ��λ");
	
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
//ComboBox(Common_ComboToInfDia)��������
//obj.Infection_cboInfDia = Common_ComboToInfDia("Infection_cboInfDia","��Ⱦ���","Infection_cboInfPos");

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
					'<th>����</th>',
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
		,loadingText: '��ѯ��,���Ե�...'
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
//ComboBox(Common_ComboToPathogeny)��������
//obj.LabSystem_cboPathogeny = Common_ComboToPathogeny("LabSystem_cboPathogeny","��ԭ��");

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
					'<th>����</th>',
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
		,loadingText: '��ѯ��,���Ե�...'
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
//ComboBox(Common_ComboToAntibiotics)��������
//obj.LabSystem_cboAntibiotics = Common_ComboToAntibiotics("LabSystem_cboAntibiotics","������");
	
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
					'<th>����</th>',
					'<th>����</th>',
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
		,loadingText: '��ѯ��,���Ե�...'
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
//ComboBox(Common_ComboToSSUser)��������
//obj.Operation_cboOperDoc = Common_ComboToSSUser("Operation_cboOperDoc","����");
	
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
					'<th>�������</th>',
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
		,loadingText: '��ѯ��,���Ե�...'
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
//ComboBox(Common_ComboToMRCICDDx)��������
//obj.Diagnose_cboDiagnose = Common_ComboToMRCICDDx("Diagnose_cboDiagnose","��Ҫ���");
	
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
					'<th>��������</th>',
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
		,loadingText: '��ѯ��,���Ե�...'
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
//ComboBox(Common_ComboToORCOperation)��������
//obj.Operation_cboOperation = Common_ComboToORCOperation("Operation_cboOperation","��������");
	
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
//TextField(Common_TextField)��������
//obj.Operation_txtResume = Common_TextField("Operation_txtResume","��ע");


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
//TextField(Common_TextArea)��������
//obj.Operation_txtResume = Common_TextArea("Operation_txtResume","��ע",50);

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
//TextField(Common_tmpLabel)��������
//obj.Operation_txtResume = Common_Label("Operation_txtResume","��ע");

function Common_NumberField()
{
	var tmpNumberField = new Ext.form.NumberField({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,allowBlank: true
		,allowNegative : (arguments[2] ? true : false)
		,allowDecimals : (arguments[3] ? true : false)
		,decimalPrecision : (arguments[4] ? arguments[4] : 2)
        ,nanText :'��������Ч����ֵ'
		,width : 10
		,anchor : '100%'
	});
	
	return tmpNumberField;
}
//NumberField(Common_NumberField)��������  ������
//obj.Operation_txtOprCutCount = Common_NumberField("Operation_txtOprCutCount","�пڸ���",0,0);
	
function Common_Checkbox()
{
	var tmpCheckbox = new Ext.form.Checkbox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,anchor : '100%'
	});
	
	return tmpCheckbox;
}
//Checkbox(Common_Checkbox)��������
//obj.Operation_chkIsCuteInf = Common_Checkbox("Operation_chkIsCuteInf","�Ƿ��Ⱦ");
	
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
					'<th>ҽ������</th>',
					'<th>ҽ������</th>',
					'<th>��ʼ����</th>',
					'<th>��������</th>',
					'<th>�÷�</th>',
					'<th>����</th>',
					'<th>����<br>��λ</th>',
					'<th>Ƶ��</th>',
					'<th>��ҩ<br>����</th>',
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
		,loadingText: '��ѯ��,���Ե�...'
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
//ComboBox(Common_ComboToAdmAnti)��������
//obj.OPR_cboAdmAnti = Common_ComboToAdmAnti("OPR_cboAdmAnti","������");


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
					'<th>ҽ������</th>',
					'<th>ҽ������</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ArcimDesc}</td>',
					'<td>{ArcimCode}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:300
		,valueField : 'ArcimID'
		,displayField : 'ArcimDesc'
		,loadingText: '��ѯ��,���Ե�...'
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
//ComboBox(Common_ComboToArcim)��������
//obj.ANTI_cboArcim = Common_ComboToArcim("ANTI_cboArcim","ҩƷҽ��","R","ANTI_cboDoseUnit");


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
//ComboBox(Common_ComboToDoseUnit)��������
//obj.ANTI_cboDoseUnit = Common_ComboToDoseUnit("ANTI_cboDoseUnit","������λ","ANTI_cboArcim");

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
//ComboBox(Common_ComboToFreq)��������
//obj.Anti_cboFreq = Common_ComboToFreq("Anti_cboFreq","Ƶ��");

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
					Ext.Msg.alert("���ݼ���ʧ�ܣ�����");
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
//ComboBox(Common_ComboToDateType)��������
//obj.cboDateType = Common_ComboToDateType("cboDateType","��������","MDR","�����");

//add by dongzt
// 2015-01-16
//����ͳ��ά��
function Common_ComboStatisticType()
{
	var tmpValue = arguments[2];
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL + '?1=1&ClassName=DHCPM.Query.PMQueryLookUp&QueryName=QryStatisticType&ArgCnt=0&2=2'
				,failure : function() {
					Ext.Msg.alert("���ݼ���ʧ�ܣ�����");
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


function Common_ComboToDemDirect()
{
	var tmpValue = arguments[2];
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL + '?1=1&ClassName=DHCPM.Query.PMQueryLookUp&QueryName=QryDemDirectoty&ArgCnt=0&2=2'
				,failure : function() {
					Ext.Msg.alert("���ݼ���ʧ�ܣ�����");
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
//�����ʱ������
//add by dongzt
function Common_ComboToDateType1()
{
	var tmpValue = arguments[2];
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL + '?1=1&ClassName=DHCPM.Query.PMQueryLookUp&QueryName=QryDateType&ArgCnt=0&2=2'
				,failure : function() {
					Ext.Msg.alert("���ݼ���ʧ�ܣ�����");
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
//ComboBox(Common_ComboToDateType1)��������
//obj.cboDateType = Common_ComboToDateType1("cboDateType","��������","MDR","�����");

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


//add by dongzt ģ��
function Common_ComboDemModule()
{
	

	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCPM.Query.PMQueryLookUp';
						param.QueryName = 'SelectPMPModule';
						param.Arg1      = tmpCombo.getRawValue();
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
					{name: 'desc', mapping: 'desc'}
					,{name: 'rowid', mapping: 'rowid'}
				]
			)
		})
		
		,minChars : 0
		,displayField : 'desc'
		,valueField : 'rowid'
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

//add by dongzt ��������
function Common_ComboDemHandler()
{
	

	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCPM.Query.PMQueryLookUp';
						param.QueryName = 'COMMUuser';
						param.Arg1      = tmpCombo.getRawValue();
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'TUserRowid'
				}, 
				[
					{name: 'TUserRowid', mapping: 'TUserRowid'}
					,{name: 'TUserDesc', mapping: 'TUserDesc'}
				]
			)
		})
		
		,minChars : 0
		,displayField : 'TUserDesc'
		,valueField : 'TUserRowid'
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





//DateField(Common_DateFieldToMonth)��������
//obj.txtYearMonth = Common_DateFieldToMonth("txtYearMonth","����");
//add by dongzt ������
function Common_ComboUser()
{
	
	if (arguments[2]) {
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
						param.ClassName = 'DHCPM.Query.PMQueryLookUp';
						param.QueryName = 'PMUserLookUp';
						param.Arg1      = tmpCombo.getRawValue();
						param.Arg2      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 2;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'TUserRowid'
				}, 
				[
					{name: 'code', mapping: 'code'}
					,{name: 'TUserRowid', mapping: 'TUserRowid'}
					,{name: 'TUserDesc', mapping: 'TUserDesc'}
				]
			)
		})
		
		,minChars : 0
		,displayField : 'TUserDesc'
		,valueField : 'TUserRowid'
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



//add by dongzt �˵�
function Common_ComboMenu()
{
	
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCPM.Query.PMQueryLookUp';
						param.QueryName = 'MenuBySQL';
						param.Arg1      = tmpCombo.getRawValue();
						param.ArgCnt    = 1;
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
					,{name: 'Caption', mapping: 'Caption'}
				]
			)
		})
		
		,minChars : 0
		,displayField : 'Caption'
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


//add by dongzt ����
function Common_ComboLoc()
{
	
	if (arguments[2]) {
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
						param.ClassName = 'DHCPM.Query.PMQueryLookUp';
						param.QueryName = 'PMLocLookUp';
						param.Arg1      = tmpCombo.getRawValue();
						param.Arg2      = ((AddItem) ? AddItem : '');
						param.ArgCnt    = 2;
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
					,{name: 'desc', mapping: 'desc'}
				]
			)
		})
		
		,minChars : 0
		,displayField : 'desc'
		,valueField : 'rowid'
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
					'<th>����</th>',
					'<th>����</th>',
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
		,loadingText: '��ѯ��,���Ե�...'
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
//ComboBox(Common_ComboToLoc)��������
//obj.cboLoc = Common_ComboToLoc("cboLoc","�����");


//��������ѧ�����Ŀ
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
						param.Arg2      = '1';
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
				,{name: 'ItemContent', mapping: 'ItemContent'}
				,{name: 'ItemCategID', mapping: 'ItemCategID'}
				,{name: 'ItemCategDesc', mapping: 'ItemCategDesc'}
				,{name: 'ItemFreqID', mapping: 'ItemFreqID'}
				,{name: 'ItemFreqDesc', mapping: 'ItemFreqDesc'}
				,{name: 'ItemNormUomID', mapping: 'ItemNormUomID'}
				,{name: 'ItemNormUomDesc', mapping: 'ItemNormUomDesc'}
				,{name: 'ItemActive', mapping: 'ItemActive'}
				,{name: 'ItemActiveDesc', mapping: 'ItemActiveDesc'}
				,{name: 'ItemResume', mapping: 'ItemResume'}
			])
		})
		,minChars : 0
		,displayField : 'ItemDesc'
		,valueField : 'ItemID'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : '100%'
		/*
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>����</th>',
					'<th>����</th>',
					'<th>����</th>',
					'<th>Ƶ��</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ItemCode}</td>',
					'<td>{ItemDesc}</td>',
					'<td>{ItemCategDesc}</td>',
					'<td>{ItemFreqDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:500
		,valueField : 'ItemID'
		,displayField : 'ItemDesc'
		,loadingText: '��ѯ��,���Ե�...'
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
		*/
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//obj.cboEnviHyItem = Common_ComboToEnviHyItem("cboEnviHyItem","�����Ŀ");

//ˢ�µ�ǰҳ��
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
//��ȡĳ��Episode�����м�ش����ؼ���
function GetEpisodeIntCtlResult(EpisodeID)
{
	var objResult = ExtTool.RunServerMethod("DHCMed.NINFService.Srv.INTInterface", "GetIntCntResult", "" , EpisodeID, "INFAW");
	return objResult;
}

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

// ���ڴ�С�Ƚ�  ��ʽ��2013-03-22
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

//ת�Ƽ�¼
function Common_ComboToTransLoc()
{
	var EpisodeID = arguments[2];
	var TransType = arguments[3];
	var objDictionarySrv = ExtTool.StaticServerObject("DHCMed.NINFService.Srv.CommonSrv");
	var strJson = objDictionarySrv.GetTransLocList(EpisodeID,TransType);
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
					'<th>����</th>',
					'<th>ʱ��</th>',
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
		,emptyText:'��ѡ��...'
		,width : 10
		,anchor : '100%'
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToTransLoc)��������
//obj.cboLoc = Common_ComboToTransLoc("cboLoc","�����",EpisodeID,TransType);

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
					html : '<img id="' + TextAreaID + '-img" align="top" src="../scripts/dhcmed/img/checked.gif"  alt="������ݺͼ�������" />'  //finddic.gif
				});
				
				Ext.lib.Event.addListener(TextAreaID + '-img','click',function(evt) {
					//ȡֵ��Ⱦ��λID
					var InfPosID = '';
					if (InfPosCmpID) {
						var InfPosCmp = Ext.getCmp(InfPosCmpID);
						if (InfPosCmp) {
							var InfPosID = InfPosCmp.getValue();
						}
					}
					//ȡֵ��Ⱦ���ID
					var InfDiagID = '';
					if (InfDiagCmpID) {
						var InfDiagCmp = Ext.getCmp(InfDiagCmpID);
						if (InfDiagCmp) {
							var InfDiagID = InfDiagCmp.getValue();
						}
					}
					//��ϱ�׼�ֵ�����
					var IDGTypeCode=TypeCode;
					
					//���ô�������߶ȡ�X�����Y����
					var winHeight=400;
					var winWidth=600;
					//var winX=evt.clientX;
					//var winY=evt.clientY;
					
					//��Ⱦ��λ��Ӧ��������б�
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
							{header : 'ѡ��',width : 50,dataIndex : 'IsChecked',sortable : false,menuDisabled : true,align : 'center',
								renderer : function(v, m, rd, r, c, s) {
									var IsChecked = rd.get("IsChecked");
									if (IsChecked == '1') {
										return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
									} else {
										return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
									}
								}
							}
							,{header : '��ϱ�׼',width : 500,dataIndex : 'IDGDesc',sortable : false, menuDisabled : true, align : 'left',
								renderer : function(v, m, rd, r, c, s) {
									m.attr = 'style="white-space:normal;"';
									return v;
								}
							}
							,{header : '��Ⱦ���',width : 100,dataIndex : 'IDDesc', sortable: false, hidden:true}
						],
						view : new Ext.grid.GroupingView({
							forceFit:true,
							groupTextTpl:'{[values.rs[0].get("IDDesc")]}(��{[values.rs.length]}����ϱ�׼)',
							groupByText:'��Ⱦ���'
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
							text : 'ȷ��',
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
							text : 'ȡ��',
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
//TextField(Common_TextAreaToDC)��������
//obj.Operation_txtResume = Common_TextAreaToDC("Operation_txtResume","��ע",50);

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
//ComboBox(Common_ComboToCate)��������
//obj.cboCate = Common_ComboToCate("cboCate","����",'ANTCate','','');

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
//ComboBox(Common_ComboToCateItem)��������
//obj.cboCate = Common_ComboToCateItem("cboCate","����",'ANTCate','','');

function Common_ComboToMRB()
{
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
						param.Arg1 =  "1";
						param.ArgCnt = 1;
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
					'<th>����</th>',
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
		,loadingText: '��ѯ��,���Ե�...'
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
//ComboBox(Common_ComboToMRB)��������
//obj.cboMRBDic = Common_ComboToMRB("cboMRBDic","������ҩ��");


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
					'<th>����</th>',
					'<th>���</th>',
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
		,loadingText: '��ѯ��,���Ե�...'
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
//ComboBox(Common_ComboToHandHyProducts)��������
//obj.cboHandHyProducts = Common_ComboToHandHyProducts("cboHandHyProducts","��������Ʒ");

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
					'<th>����</th>',
					'<th>����</th>',
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
		,loadingText: '��ѯ��,���Ե�...'
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

//zzp
//2015-05-15
//��ȡ�ͻ���IP��ַ
function getIpAddress()
{
     try
     {
          var locator = new ActiveXObject ("WbemScripting.SWbemLocator");
          var service = locator.ConnectServer(".");
          var properties = service.ExecQuery("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled =True");
          var e = new Enumerator (properties);
          {
              var p = e.item();
              var ip = p.IPAddress(0);
              return ip
          }
     }
     catch(err)
     {
          return "";
     }
}
//zzp
//2015-05-22
//��ѡ���ļ�����
//��Σ��ļ���������Ϊ�գ�
//����ֵ���ļ�·��+�ļ���
function BrowseFolder(name) {
	 
	 var fd = new ActiveXObject("MSComDlg.CommonDialog");
       fd.Filter = "��������(*)"; //�^�V�ļ����
       fd.filename=name
       fd.FilterIndex = 2;
       fd.MaxFileSize = 128;
       //fd.ShowOpen();//�򿪶Ի���
       fd.ShowSave();//����Ի���
       VerStrstr=fd.filename;//fd.filename·��
}
//zzp
//2015-05-21
//�����������
//��Σ������������λ��
//����ֵ�����ֵ
function generateMixed(n) { 
var chars = new Array('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'); 
var res = ""; 
for (var i = 0; i < n ; i ++) { 
    var id = Math.ceil(Math.random()*35); 
    res += chars[id]; 
  } 
return res; 
} 
 
//zzp
//2015-05-21
//�ϴ������ظ������ú���
//��Σ������ļ�·��+����,ftp�������ļ�����,�������ͣ�UpLoad,DownLoad��
//����ֵ�� true:�ɹ�;false:ʧ�� 
function FileDownload(LocaName,FtpName,Type){
   var SizeType="",ret="Other";
   var SizeSwitch=1024*1024;
   var PortDll = new ActiveXObject("FtpPortDLL.FtpPortList");
   var objAudit = ExtTool.StaticServerObject("web.PMP.FileDownload");
   var FtpConfigRet=objAudit.FtpConfig();
   var sysFileSize=objAudit.FileSize();
   var sysRandomness=objAudit.Randomness();
   if((LocaName=="")||(Type=="")){
        ret='-1//��������ȷ';
		return ret;
   };
   if (FtpConfigRet==""){
        ret='-2//���ڡ��������á������á����ͱ��롱Ϊ��AdjunctIP����ftp·������!';
		return ret;
   };
   try{
	 var FTPConnectret=PortDll.FTPConnect(FtpConfigRet.split("#")[0],FtpConfigRet.split("#")[2],FtpConfigRet.split("#")[1]);
	   if(FTPConnectret==false){
	   ret="-4//�޷�����Ftp�������������������ӣ�"
	   return ret;
	   };
     if(Type=="UpLoad"){
       var FielSizeBit=PortDll.FileSize(LocaName);
	   var FielSize=FielSizeBit/SizeSwitch;
	   if (FielSize>sysFileSize){
	   SizeType="1";
	   };
	   if(FielSize>1000){
	   FielSize=FielSize/1024;
	   FielSize=FielSize.toFixed(2)+"GB"
	   }
	   else{
	   FielSize=FielSize.toFixed(2)+"M"
	   };
	   if (SizeType=="1"){
	    ret='-3//��������ҽԺ�涨��С����ǰ��СΪ��'+FielSize;
		return ret;
	   };
	   var SerialNumber=generateMixed(sysRandomness);
	   var OldName=LocaName.split("\\")[LocaName.split("\\").length-1];
	   var NewFileName=objAudit.NewFileName(OldName,SerialNumber);
	   var NewFileAddress=FtpConfigRet.split("#")[3]+NewFileName;
	   var ret=PortDll.FTPFileUpload(FtpConfigRet.split("#")[0],FtpConfigRet.split("#")[2],FtpConfigRet.split("#")[1],LocaName,NewFileAddress);
	   var ret=ret+"//"+NewFileName;
	   return ret
     };
	 if(Type=="DownLoad"){
	 var NewFileAddress=FtpConfigRet.split("#")[3]+FtpName;var ret=PortDll.FTPFileDownload(FtpConfigRet.split("#")[0],FtpConfigRet.split("#")[2],FtpConfigRet.split("#")[1],NewFileAddress,LocaName);
	 return ret
	 };
   }catch(err)
	{
	  ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}; 
  
};

//zzp
//2015-05-23
//�������ؽ���
function DownLoadWind (DemandID){
     var obj = new Object();
     var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	 var ip=getIpAddress();
     
     obj.winfDownLoadProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.winfDownLoadStore = new Ext.data.Store({
		proxy: obj.winfDownLoadProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			//idProperty: 'DemRowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'attachment', mapping: 'attachment'}
			,{name: 'UpDate', mapping: 'UpDate'}
			,{name: 'UpUser', mapping: 'UpUser'}
			,{name: 'DownLoadFlag', mapping: 'DownLoadFlag'}
			,{name:'ADRowid',mapping:'ADRowid'}
			,{name:'Filename',mapping:'Filename'}
		])
	});
	obj.winfDownLoadProxy.on('beforeload', function(objProxy, param){
	    param.ClassName = 'DHCPM.Query.PMQueryAll';
        param.QueryName = 'QryDownLoadList';
        param.Arg1 = "";
        param.Arg2 = DemandID;    //obj.MenuID.getValue();
        param.ArgCnt = 2; 
	});
	obj.winfGPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.winfDownPanel = new Ext.grid.GridPanel({
		id : 'winfDownPanel'
		,store : obj.winfDownLoadStore
		//,columnLines : true
		,height: 250
		,layout:'form'
		//,autoHeight:true
		,loadMask : true
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		,buttonAlign : 'center'
		,plugins : obj.winfGPanelCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '��������', width: 200, dataIndex: 'attachment', sortable: true,align : 'center'}
			,{header: 'Rowid', width: 100, hidden:true,dataIndex: 'ADRowid', sortable: true,align : 'center'}
			,{header: '�������ļ���', width: 100, hidden:true,dataIndex: 'Filename', sortable: true,align : 'center'}
			,{header: '�ϴ�����', width: 100, dataIndex: 'UpDate', sortable: true,align : 'center'}
			,{header: '�ϴ��û�', width: 100, dataIndex: 'UpUser', sortable: true,align : 'center'}
			,{header : "���ظ���",width : 150,dataIndex : 'node',align : 'center',align : 'center',renderer: function (value, metaData, record, rowIndex, colIndex, store) {
			   var strRet = "";
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='alarm_detail'>����</a>";
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
               return strRet}}]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.winfDownLoadStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
			})
           ,iconCls: 'icon-grid'
		   ,viewConfig : {
			//forceFit : true
			//,scrollOffset: 0
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
});
	obj.ContractaaPanal=new Ext.Panel({
			id : 'ContractaaPanal'
			,layout : 'fit'
			,width : '100%'
			,region : 'center'
			//,collapsible: true
			,border:true
			,items:[obj.winfDownPanel]
		});		
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 300
		,buttonAlign : 'center'
		,width : 600
		,layout:'fit'
		,border:true
		,modal:true
		,title : '��������'
		,items:[obj.ContractaaPanal]
	});
	obj.winfDownLoadStore.load({}); 
	DownLoadWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
  
    return obj;
};

function DownLoadWindEvent(obj){
     var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	 var ip=getIpAddress();
    obj.LoadEvent = function(args){
	
	obj.winfDownPanel.on('cellclick',obj.winfDownPanel_OnClick,obj);
	
	};
	
   obj.winfDownPanel_OnClick=function (grid, rowIndex, columnIndex, e){  
    var btn = e.getTarget('.controlBtn');  
     if (btn) {  
      var t = e.getTarget();  
      var record = obj.winfDownPanel.getStore().getAt(rowIndex);  
	  var attachName=record.get("attachment");
	  var ADRowid=record.get("ADRowid");
	  var Filename=record.get("Filename");
	  BrowseFolder(attachName);  //
	  if (VerStrstr==attachName){
	   return;
	   }
	  var retDownLoadFile=FileDownload(VerStrstr,Filename,"DownLoad");
	  if (retDownLoadFile==true){
	  var Down='���سɹ����ļ�������'+VerStrstr;
	  var retDownLoadFile=objApply.PMPDownloads(ADRowid,'PMP_ImprovementAdjunct',ip)
	  }
	  else{
	  var Down='����ʧ�ܣ�';
	  };
	  Ext.MessageBox.alert('Status', Down);
	  }  
	 }
}
//zzp
//2015-05-23
//�������ع��ý���
function AdjunctAllWind(cRowid,type){
    var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	var ip=getIpAddress();
    var obj = new Object();
	obj.AdjunctAllAdd = new Ext.Button({
		id : 'AdjunctAllAdd'
		,iconCls : 'icon-add'
		,text : '�ϴ�����'
	});
	obj.AdjunctAllRowid= new Ext.form.TextField({
		id : 'AdjunctAllRowid'
		,width : 200
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		,editable : true
		,hidden:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AdjunctAllType= new Ext.form.TextField({
		id : 'AdjunctAllType'
		,width : 200
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		,hidden:true
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.tbAdjunctAll = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tbAdjunctAll',
				items : [obj.AdjunctAllAdd,obj.AdjunctAllRowid,obj.AdjunctAllType]
			});
	//****************************** End ****************************
	obj.AdjunctAllTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.AdjunctAllTypeStore = new Ext.data.Store({
		proxy: obj.AdjunctAllTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['ConAdRowid'
		,'ConAdName'
		,'ConAdFileType'
		,'ConAdDate'
		,'ConAdUser'
		,'ConAdType'
		,'ConAdFtpName'
		,'ConAdFalg'
		,'ConAdAll'])
	});
	obj.AdjunctAllTypeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Document';
			param.QueryName = 'ContracAdjunctStore';
			param.Arg1 = cRowid;
			param.Arg2 = type; 
			param.ArgCnt = 2;
	});
	obj.gridContractCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.AdjunctAllPanel = new Ext.grid.GridPanel({
		id : 'AdjunctAllPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		//,region : 'west'
		//,split: true
		//,collapsible: true
		,width : 300
		,height: 100
		,minHeight: 10
        ,maxHeight: 500
		,plugins : obj.gridContractCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.AdjunctAllTypeStore
		,tbar:obj.tbAdjunctAll
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridContractCheckCol
			, { header : 'Rowid', width : 150, dataIndex : 'ConAdRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '��������', width : 230, dataIndex : 'ConAdName', sortable : false, align : 'center',editable: true }
			, { header : '�ļ�����', width : 70, dataIndex : 'ConAdFileType', sortable : false ,align : 'center'}
			, { header : '�ϴ�ʱ��', width : 150, dataIndex : 'ConAdDate', sortable : true, align : 'center' }
			, { header : '�ϴ���', width : 100, dataIndex : 'ConAdUser',sortable : true,align : 'center' }
			, { header : '�ϴ�����', width : 120, dataIndex : 'ConAdType',sortable : true,align : 'center'}
			, { header : '�������ļ���', width : 250, dataIndex : 'ConAdFtpName', hidden: true ,sortable : true, align : 'center' }
			, { header : '������־', width : 100, dataIndex : 'ConAdFalg', hidden: true ,sortable : true, align : 'center' }
			, { header : 'ȫ·��', width : 250, dataIndex : 'ConAdAll', hidden:true,sortable : true, align : 'center' }
			, {header : "����",width : 80,forceFit : true,dataIndex : 'node',align : 'center',renderer: function (value, metaData, record, rowIndex, colIndex, store) {
			   var strRet = "";
			   if(record.get("ConAdFalg")=="Y"){
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='Download'>����</a>";
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   }
			   else {
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='EditDetail'>ɾ��</a>";
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   };
			   return strRet;
			   }}]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.AdjunctAllTypeStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			//,scrollOffset: 0
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
	});
	//--------------------------------------------------------------------
    obj.ContractaPanal=new Ext.Panel({
			id : 'ContractaPanal'
			,layout : 'fit'
			,width : '100%'
			,region : 'center'
			//,collapsible: true
			,border:true
			,items:[obj.AdjunctAllPanel]
		});
    obj.menuwindContracAd = new Ext.Window({
		id : 'menuwindContracAd'
		,height : 360
		,buttonAlign : 'center'
		,width : 800
		,modal : true
		,title : '��������'
		,layout : 'fit'
		,border:true
		,items:[
			   obj.ContractaPanal
		]
	});
	obj.AdjunctAllTypeStore.load({}); 
	AdjunctAllWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;

}

function AdjunctAllWindEvent(obj){
  var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
  var objAudit=ExtTool.StaticServerObject("web.PMP.Document");
  var ip=getIpAddress();
  var dowmret=""
  obj.LoadEvent = function(args){
  obj.AdjunctAllAdd.on("click",obj.AdjunctAllAdd_OnClick,obj);
  
  obj.AdjunctAllPanel.on('cellclick',obj.AdjunctAllPanel_CellClick,obj)  
  }
  obj.AdjunctAllAdd_OnClick=function(){
    BrowseFolder('');
	var Rowid=obj.AdjunctAllRowid.getValue();
	var type=obj.AdjunctAllType.getValue();
	if (VerStrstr!=""){
	var FileName=objAudit.AddFileName(VerStrstr);  //User_"^"_type_"^"_flag_"^"_date
	var OldName=VerStrstr.split("\\")[VerStrstr.split("\\").length-1];
	var retDounload=FileDownload(VerStrstr,"","UpLoad");
	//alert(retDounload);
	var flag=retDounload.split("//")[0]
	if(flag=="true"){
	  var FileNameAddRet=objApply.AdjunctAll(VerStrstr,retDounload.split("//")[1],Rowid,type,ip);
	  dowmret='�����ϴ��ɹ�';
	}
	if(flag!="true"){
	  dowmret='�����ϴ�ʧ��'+retDounload.split("//")[1];
	};
	Ext.MessageBox.alert('Status',dowmret);
	obj.AdjunctAllTypeStore.load({}); 
	var Plant = obj.AdjunctAllTypeStore.recordType;
	//var p = new Plant({ConAdRowid:'',ConAdName:OldName,ConAdFileType:FileName.split("^")[1],ConAdDate:FileName.split("^")[3],ConAdUser:FileName.split("^")[0],ConAdType:FileName.split("^")[2],ConAdFtpName:'',ConAdFalg:'',ConAdAll:VerStrstr});
    //AdjunctObGrid.stopEditing();
    //obj.AdjunctAllTypeStore.insert(0, p);
	};
  }
  obj.AdjunctAllPanel_CellClick=function(grid, rowIndex, columnIndex, e){
	var btn = e.getTarget('.controlBtn');  
	if (btn){  
    var t = e.getTarget();  
    var record = obj.AdjunctAllPanel.getStore().getAt(rowIndex);  
	var control = t.className; 
	var ConAdRowid=record.get('ConAdRowid');
	var ConAdName=record.get('ConAdName');
	var ConAdFtpName=record.get('ConAdFtpName');
	if(control=="Download"){
	try{
	BrowseFolder(ConAdName);
	if (VerStrstr==ConAdName){
	return;
	}
	var ret=FileDownload(VerStrstr,ConAdFtpName,"DownLoad");
	if (ret==true){
	var Down='���سɹ����ļ�������'+VerStrstr;
	var ret=objApply.PMPDownloads(ConAdRowid,'PMP_ImprovementAdjunct',ip)
	}
	else{
	var Down='����ʧ�ܣ�';
	};
	Ext.MessageBox.alert('Status', Down);
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="EditDetail"){
	try{
	alert('ɾ��');
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	
	};
	};
};
//zzp
//2015-05-30
//��ȡ������Ϣ���ý���
function AppIngAllWind(Rowid,type){
    var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	var ip=getIpAddress();
    var obj = new Object();
	obj.IpmlAppingStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.IpmlAppingStore = new Ext.data.Store({
		proxy: obj.IpmlAppingStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['IAppRowid'
		,'IAppPJ1'
		,'IAppPJ2'
		,'IAppPJ3'
		,'IAppType'
		,'IAppUser'
		,'IAppDate'
		,'IAppMeau'
		,'IAppImprove'])
	});
	obj.IpmlAppingStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Document';
			param.QueryName = 'IpmlAppingStore';
			param.Arg1 = Rowid;
			param.Arg2 = type; 
			param.ArgCnt = 2;
	});
	obj.IpmlAppingCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.ImprovementAppraisalPanel = new Ext.grid.GridPanel({
		id : 'ImprovementAppraisalPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		//,region : 'west'
		//,split: true
		//,collapsible: true
		,width : 300
		,height: 100
		,minHeight: 10
        ,maxHeight: 500
		,plugins : obj.IpmlAppingCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.IpmlAppingStore
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.IpmlAppingCheckCol
			, { header : 'Rowid', width : 150, dataIndex : 'IAppRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '�Ľ��ٶ�', width : 100, dataIndex : 'IAppPJ1', sortable : false ,align : 'center'}
			, { header : '�Ľ�����', width : 100, dataIndex : 'IAppPJ2', sortable : true, align : 'center' }
			, { header : '����̬��', width : 100, dataIndex : 'IAppPJ3',sortable : true,align : 'center' }
			, { header : '���۱�־', width : 100, dataIndex : 'IAppType',sortable : true,align : 'center'}
			, { header : '�����û�', width : 100, dataIndex : 'IAppUser', sortable : true, align : 'center' }
			, { header : '����ʱ��', width : 150, dataIndex : 'IAppDate', sortable : true, align : 'center' }
			, { header : '��������', width : 200, dataIndex : 'IAppMeau', sortable : true, align : 'center' }
			, { header : '����id', width : 100, dataIndex : 'IAppImprove', hidden:true,sortable : true, align : 'center' }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.IpmlAppingStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			//,scrollOffset: 0
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
	});
	obj.IMPLPanal=new Ext.Panel({
			id : 'IMPLPanal'
			,layout : 'fit'
			,width : '100%'
			,region : 'center'
			//,collapsible: true
			,border:true
			,items:[obj.ImprovementAppraisalPanel]
		});
    obj.menuwindIMPL = new Ext.Window({
		id : 'menuwindIMPL'
		,height : 360
		,buttonAlign : 'center'
		,width : 900
		,modal : true
		,title : '���۹���'
		,layout : 'fit'
		,border:true
		,items:[
			   obj.IMPLPanal
		]
	});
	
    
	AppIngAllWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;

}

function AppIngAllWindEvent(obj){
    var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
    var objAudit=ExtTool.StaticServerObject("web.PMP.Document");
    var ip=getIpAddress();
    obj.LoadEvent = function(args){
	}
}
//zzp
//2015-05-30
//������ϸ����
function SelectIpml(DemandID){
    if(DemandID==""){
	return;
	};
    var objAudit=ExtTool.StaticServerObject("web.PMP.Document");
	var IpmlDetailRet=objAudit.IpmlDetail(DemandID);
    objWinDetail = new InitDescScreen();
	objWinDetail.DemandID.setValue(DemandID);
	//alert(obj.DemandID.getValue());
	objWinDetail.winfDemName.setValue(IpmlDetailRet.split("^")[0]);
	objWinDetail.winfDemName.disabled=true;
	//alert(obj.winfDemName.getValue());
	objWinDetail.winfDemType.setValue(IpmlDetailRet.split("^")[1]);
	objWinDetail.winfDemType.disabled=true;
	objWinDetail.winfEmergency.setValue(IpmlDetailRet.split("^")[2]);
	objWinDetail.winfEmergency.disabled=true;
	objWinDetail.winfPhone.setValue(IpmlDetailRet.split("^")[3]);
	objWinDetail.winfPhone.disabled=true;
	objWinDetail.winfDemDesc.setValue(IpmlDetailRet.split("^")[4]); //
	//objWinDetail.winfDemDesc.disabled=true;
	objWinDetail.winfCreater.setValue(IpmlDetailRet.split("^")[5]); 
	objWinDetail.winfCreater.disabled=true;
	objWinDetail.winfLocation.setValue(IpmlDetailRet.split("^")[6]); //
	objWinDetail.winfLocation.disabled=true;
	objWinDetail.winfModule.setValue(IpmlDetailRet.split("^")[7]); 
	objWinDetail.winfModule.disabled=true;
	objWinDetail.winfInHandler.setValue(IpmlDetailRet.split("^")[8]);
	//var editNote="�޸���:"+EditUser+"                             "+EditDemDesc;
	if(IpmlDetailRet.split("^")[8]!="")
	{objWinDetail.winfEditDemDesc.setValue(IpmlDetailRet.split("^")[9]);} 
	//�����б�
	objWinDetail.winfGPanelStoreProxy.on('beforeload', function(objProxy, param){
	param.ClassName = 'DHCPM.Query.PMQueryAll';
	param.QueryName = 'QryDemList';
	param.Arg1 = DemandID;    //obj.MenuID.getValue();
	param.ArgCnt = 1; 
	});
	//��ͨ��¼�б�
	objWinDetail.winfComlistStoreProxy.on('beforeload', function(objProxy, param){
	param.ClassName = 'DHCPM.Handle.PMHandle';
	param.QueryName = 'QryComContent';
	param.Arg1 = DemandID;    //obj.MenuID.getValue();
	param.ArgCnt = 1; 
	});
	//���������б�
	objWinDetail.winfDownLoadProxy.on('beforeload', function(objProxy, param){
	param.ClassName = 'DHCPM.Query.PMQueryAll';
	param.QueryName = 'QryDownLoadList';
	param.Arg1 = "";
	param.Arg2 = DemandID;    //obj.MenuID.getValue();
	param.ArgCnt = 2; 
	});
	objWinDetail.winfGPanelStore.load({});
	objWinDetail.winfComlistStore.load({}); 
	objWinDetail.winfDownLoadStore.load({}); 
    objWinDetail.winScreen.show();
}
//2015-05-30
//zzp 
//ģ���������
function ModeuleImproWind(){
    var obj = new Object();
	obj.ModeuleIMRowid= new Ext.form.TextField({
		id : 'ModeuleIMRowid'
		,width : 40
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ģ��id'
		,disabled:true
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,hidden:true
	});
	obj.ModeuleImproCode= new Ext.form.TextField({
		id : 'ModeuleImproCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�������'
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModeuleImproDesc= new Ext.form.TextField({
		id : 'ModeuleImproDesc'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModeuleImproSdate= new Ext.form.DateField({
		id : 'ModeuleImproSdate'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��ʼ����'
		,enableKeyEvents : true
	    //,emptyText:'��ѡ������'
	    ,format:'Y-m-d'
	   //,value:new Date().add(Date.DAY,0)
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModeuleImproEdate= new Ext.form.DateField({
		id : 'ModeuleImproEdate'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,enableKeyEvents : true
	    //,emptyText:'��ѡ������'
	    ,format:'Y-m-d'
	   //,value:new Date().add(Date.DAY,0)
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModeuleImproExport = new Ext.Button({
		id : 'ModeuleImproExport'
		,iconCls : 'icon-export'
		,text : '����'
	});
	obj.ModeuleImproPrint = new Ext.Button({
		id : 'ModeuleImproPrint'
		,iconCls : 'icon-print'
		,text : '��ӡ'
	});
	obj.ModeuleImproQuery = new Ext.Button({
		id : 'ModeuleImproQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.ModeuleImproBatch = new Ext.Button({
		id : 'ModeuleImproBatch'
		,iconCls : 'icon-update'
		,text : '����'
	});
	obj.ModeuleImprocancel = new Ext.Button({
		id : 'ModeuleImprocancel'
		,iconCls : 'icon-cancel'
		,text : '����'
	});
	obj.tbMODE = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tbMODE',
				items : [new Ext.Toolbar.TextItem('������룺'),obj.ModeuleImproCode,'-',new Ext.Toolbar.TextItem('�������ƣ�'),obj.ModeuleImproDesc,'-',new Ext.Toolbar.TextItem('��ʼ���ڣ�'),obj.ModeuleImproSdate,new Ext.Toolbar.TextItem('�������ڣ�'),obj.ModeuleImproEdate,'-',obj.ModeuleImproQuery,'-',obj.ModeuleImproBatch,'-',obj.ModeuleImproExport,'-',obj.ModeuleImproPrint,'-',obj.ModeuleImprocancel,obj.ModeuleIMRowid]
			});
	//******************�����б�grid*******************************
	obj.ModeuleImproStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ModeuleImproStore = new Ext.data.Store({
		proxy: obj.ModeuleImproStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['MIGridRowid'
		,'MIGridCode'
		,'MIGridDesc'
		,'MIGridType'
		,'MIGridMenu'
		,'MIGridStatus'
		,'MIGridCreatDate'
		,'MIGridCrectUser'
		,'MIGridSituation'
		,'MIGridStandby3'
		,'MIGridEmergency'
		,'MIGridTel'
		,'MIGridAdjunctFlag'
		,'MIGridApp'])
	});
	obj.ModeuleImproStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Document';
			param.QueryName = 'ModeuleImproStore';
			param.Arg1 = obj.ModeuleIMRowid.getValue();
			param.Arg2 = obj.ModeuleImproCode.getRawValue();
			param.Arg3 = obj.ModeuleImproDesc.getRawValue();   
			param.Arg4 = obj.ModeuleImproSdate.getRawValue();   //obj.ContractStatus.getRawValue(); ��ȡ�����ֵ  getValue()��ȡ��̨��ֵ
			param.Arg5 = obj.ModeuleImproEdate.getRawValue(); 
			param.ArgCnt = 5;
	});
	obj.ModeuleImproCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.ModeuleImproPanel = new Ext.grid.GridPanel({
		id : 'ModeuleImproPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		//,region : 'west'
		//,split: true
		//,collapsible: true
		,width : 300
		,height: 100
		,minHeight: 10
        ,maxHeight: 500
		,plugins : obj.ModeuleImproCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.ModeuleImproStore
		,tbar:obj.tbMODE
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridContractCheckCol
			, {header : "����",width : 200,forceFit : true,dataIndex : 'node',align : 'center',renderer: function (value, metaData, record, rowIndex, colIndex, store) {
			   var strRet = "";
			   if(record.get("MIGridAdjunctFlag")=="Y"){
			     if(record.get("MIGridApp")=="Y"){
				 formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='ContractDetail'>��������</a>";
			     formatStr=formatStr+" | <a href='javascript:void({1});' onclick='javscript:return false;' class='EditDetail'>���ظ���</a>";
				 formatStr=formatStr+" | <a href='javascript:void({2});' onclick='javscript:return false;' class='SelectApping'>�鿴����</a>";
			     strRet = "<div class='controlBtn'>" + formatStr + "</div>";
				 }
				 else{
				 formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='ContractDetail'>��������</a>";
			     formatStr=formatStr+" | <a href='javascript:void({1});' onclick='javscript:return false;' class='EditDetail'>���ظ���</a>";
			     strRet = "<div class='controlBtn'>" + formatStr + "</div>";
				 };
			   
			   }
			   else {
			   if(record.get("MIGridApp")=="Y"){
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='ContractDetail'>��������</a>";
			   formatStr=formatStr+" | <a href='javascript:void({1});' onclick='javscript:return false;' class='SelectApping'>�鿴����</a>";
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   }
			   else{
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='ContractDetail'>��������</a>";
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   };
			   };
			   return strRet;
			   }}
			, { header : 'Rowid', width : 150, dataIndex : 'MIGridRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '�������', width : 150, dataIndex : 'MIGridCode', sortable : false, align : 'center',editable: true }
			, { header : '��������', width : 200, dataIndex : 'MIGridDesc', sortable : false ,align : 'center'}
			, { header : '��������', width : 100, dataIndex : 'MIGridType', sortable : true, align : 'center' }
			, { header : '�˵�����', width : 100, dataIndex : 'MIGridMenu',sortable : true,align : 'center'}
			, { header : '����״̬', width : 100, dataIndex : 'MIGridStatus', sortable : true, align : 'center' }
			, { header : '��������', width : 100, dataIndex : 'MIGridCreatDate', sortable : true, align : 'center' }
			, { header : '�����û�', width : 100, dataIndex : 'MIGridCrectUser', sortable : true, align : 'center' }
			, { header : '������״', width : 100, dataIndex : 'MIGridSituation', sortable : true, align : 'center' }
			, { header : 'Ҫ��Ч��', width : 100, dataIndex : 'MIGridStandby3', sortable : true, align : 'center' }
			, { header : '�����̶�', width : 100, dataIndex : 'MIGridEmergency', sortable : true, align : 'center' }
			, { header : '��ϵ�绰', width : 100, dataIndex : 'MIGridTel', sortable : true, align : 'center' }
			, { header : '����������', width : 100, dataIndex : 'MIGridAssignEngineer', sortable : true, align : 'center' }
			, { header : '�Ƿ��и���', width : 100, dataIndex : 'MIGridAdjunctFlag',hidden:true, sortable : true, align : 'center' }
			, { header : '�Ƿ�����', width : 100, dataIndex : 'MIGridApp', hidden:true,sortable : true, align : 'center' }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.ModeuleImproStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			//,scrollOffset: 0
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
	});
	obj.ModeIMPROIPanal=new Ext.Panel({
			id : 'ModeIMPROIPanal'
			,layout : 'fit'
			,width : '100%'
			,region : 'center'
			//,collapsible: true
			,border:true
			,items:[obj.ModeuleImproPanel]
		});
	obj.menuwindMode = new Ext.Window({
		id : 'menuwindMode'
		,height : 450
		,buttonAlign : 'center'
		,width : 1020
		,modal : true
		,title : 'ģ��������ϸ'
		,layout : 'fit'
		,border:true
		,items:[
			   obj.ModeIMPROIPanal
		]
	});
	obj.ModeuleImproStore.removeAll();
	obj.ModeuleImproStore.load({params : {start:0,limit:20}});
	//******************End****************************************
	ModeuleImproWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

function ModeuleImproWindEvent(obj){
       var ip=getIpAddress();
       var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
       obj.LoadEvent = function(){
	    obj.ModeuleImproExport.on("click", obj.ModeuleImproExport_OnClick, obj);  //�����¼� 
		
		obj.ModeuleImproPrint.on("click", obj.ModeuleImproPrint_OnClick, obj);  //��ӡ �¼�
		
		obj.ModeuleImproQuery.on("click", obj.ModeuleImproQuery_OnClick, obj);  //��ѯ�¼�  
		
		obj.ModeuleImproBatch.on("click", obj.ModeuleImproBatch_OnClick, obj ); //�����¼� 
		
		obj.ModeuleImprocancel.on("click",obj.ModeuleImprocancel_OnClick,obj);  //�����¼�

        obj.ModeuleImproCode.on("specialkey", obj.ModeuleImproCode_specialkey,obj)  //��ͬ����س��¼�	
        
        obj.ModeuleImproDesc.on("specialkey", obj.ModeuleImproDesc_specialkey,obj)  //��ͬ����س��¼�	

        obj.ModeuleImproPanel.on('cellclick',obj.ModeuleImproPanel_CellClick,obj) 		
	  
	  };
	obj.ModeuleImproPanel_CellClick=function(grid, rowIndex, columnIndex, e){
	var btn = e.getTarget('.controlBtn');  
	if (btn){  
    var t = e.getTarget();  
    var record = obj.ModeuleImproPanel.getStore().getAt(rowIndex);  
	var control = t.className; 
	var MIGridRowid=record.get('MIGridRowid');
	if(control=="ContractDetail"){
	try{
	SelectIpml(MIGridRowid);
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="SelectApping"){
	try{
	distrObj = new AppIngAllWind(MIGridRowid,"Improvement");
	distrObj.IpmlAppingStore.removeAll();
	distrObj.IpmlAppingStore.load({params : {start:0,limit:10}});
	distrObj.menuwindIMPL.show();
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="EditDetail"){
	try{
	distrObj = new AdjunctAllWind(MIGridRowid,"Improvement");
	distrObj.AdjunctAllTypeStore.removeAll();
	distrObj.AdjunctAllType.setValue("Improvement")
	distrObj.AdjunctAllRowid.setValue(MIGridRowid)
	distrObj.AdjunctAllTypeStore.load({params : {start:0,limit:10}});
	distrObj.menuwindContracAd.show();
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	};
	}
	 obj.ModeuleImproCode_specialkey=function(field,e){
	     if (e.keyCode== 13){
	      obj.ModeuleImproQuery_OnClick();
	      };
	   };
	  obj.ModeuleImproDesc_specialkey=function(field,e){
	     if (e.keyCode== 13){
	      obj.ModeuleImproQuery_OnClick();
	      };
	   };
	  obj.ModeuleImproExport_OnClick=function(){
	  Ext.MessageBox.alert('Status','���ڿ����С�����');
	  };
	  obj.ModeuleImproPrint_OnClick=function(){
	  Ext.MessageBox.alert('Status','���ڿ����С�����');
	  };
	  obj.ModeuleImproQuery_OnClick=function(){
	  obj.ModeuleImproStore.removeAll();
	  obj.ModeuleImproStore.load({params : {start:0,limit:20}});
	  };
	  obj.ModeuleImproBatch_OnClick=function(){
	  obj.ModeuleImproCode.setValue('');
	  obj.ModeuleImproDesc.setValue('');
	  obj.ModeuleImproSdate.setValue('');
	  obj.ModeuleImproEdate.setValue('');
	  obj.ModeuleImproQuery_OnClick();
	  };
	  
	  obj.ModeuleImprocancel_OnClick=function(){
	  obj.menuwindMode.close();
	  };

}

function EditWind(Rowid,Type){
     var obj = new Object();
	 var objApply = ExtTool.StaticServerObject("web.PMP.Document");
	 var IPMLSituationRet=objApply.IPMLSituation(Rowid);
	 obj.EditRowid= new Ext.form.TextField({
		id : 'EditRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'rowid'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
		,value:Rowid
	   });
	 obj.EditStatus= new Ext.form.TextField({
		id : 'EditStatus'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'rowid'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
		,value:IPMLSituationRet.split("@@")[2]
	   });
	  obj.EditType= new Ext.form.TextField({
		id : 'EditType'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'rowid'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
		,value:Type
	   });
	 obj.EditSituation=new Ext.form.HtmlEditor({
	    id:'EditSituation'
	    ,xtype: "htmleditor",
        name: "content",
        fieldLabel: "��������",
        height: 190,
		value:IPMLSituationRet.split("@@")[0],
		enableSourceEdit: false
		//enableAlignments: false,//�Ƿ����ö��밴ť������������������ť 
        //enableColors: false,//�Ƿ�����ǰ��ɫ����ɫ��ť��Ĭ��Ϊtrue
        //enableFont: false,//�Ƿ���������ѡ��ť Ĭ��Ϊtrue
        //enableFontSize: false,//�Ƿ���������Ӵ���С��ť 
        //enableFormat: false,//�Ƿ����üӴ�б���»��߰�ť
        //enableLists: false, //�Ƿ������б�ť
		//enableLinks:false
	    });
	 obj.EditStandby3=new Ext.form.HtmlEditor({
	    id:'EditStandby3'
	    ,xtype: "htmleditor",
        name: "content",
        fieldLabel: "Ҫ��Ч��",
        height: 190,
		value:IPMLSituationRet.split("@@")[1],
		enableSourceEdit: false
		//enableAlignments: false,//�Ƿ����ö��밴ť������������������ť 
        //enableColors: false,//�Ƿ�����ǰ��ɫ����ɫ��ť��Ĭ��Ϊtrue
        //enableFont: false,//�Ƿ���������ѡ��ť Ĭ��Ϊtrue
        //enableFontSize: false,//�Ƿ���������Ӵ���С��ť 
        //enableFormat: false,//�Ƿ����üӴ�б���»��߰�ť
        //enableLists: false, //�Ƿ������б�ť
		//enableLinks:false
	    });
	 obj.EditSave = new Ext.Button({
		id : 'EditSave'
		,iconCls : 'icon-add'
		,text : '����'
	  });
	 obj.EditDelete = new Ext.Button({
		id : 'EditDelete'
		,iconCls : 'icon-add'
		,text : 'ȡ��'
	  });
	 obj.winTPanelMenuadd = new Ext.form.FormPanel({
		id : 'winTPanelMenuadd'
		//,labelAlign : 'right'
		,buttonAlign : 'center'
		,autoHeight : true
        ,autoWidth : true
		,layout : 'form'
		,hideLabel:false
		,labelAlign : "right"
		,labelWidth:60
		,frame : true
		,items:[obj.EditSituation,obj.EditStandby3]
	}); 
	 obj.menuwindadd = new Ext.Window({
		id : 'menuwindadd'
		,height : 460
		,buttonAlign : 'center'
		,width : 600
		,modal : true
		,title : '������'
		,layout : 'form'
		,border:true
		,labelWidth:60
		,items:[
			   obj.winTPanelMenuadd
		]
		,buttons:[
			   obj.EditSave
			  ,obj.EditDelete
		]
	  });
	 EditWindEvent(obj);
	 //�¼��������
	 obj.LoadEvent(arguments);
	 return obj;
}
function EditWindEvent(obj){
     var objApply = ExtTool.StaticServerObject("web.PMP.Document");
	 
    obj.LoadEvent = function(args){
	  
	   obj.EditSave.on("click", obj.EditSave_OnClick, obj);  //�����¼� 
	   
	   obj.EditDelete.on("click", obj.EditDelete_OnClick, obj);  //�����¼� 
	  }
	obj.EditSave_OnClick=function (){
	var IPMLSituationValue=objApply.IPMLSituation(obj.EditRowid.getValue());
	var EditSituationvalue=obj.EditSituation.getValue();
	var EditStandby3value=obj.EditStandby3.getValue();
	var EditStatusvalue=obj.EditStatus.getValue();
	var NewValue=EditSituationvalue+"@@"+EditStandby3value+"@@"+EditStatusvalue;
	if (NewValue==IPMLSituationValue){
	   Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '����û�б䶯�����豣��!',
			  icon : Ext.Msg.WARNING,
			  minWith:'200',
			  buttons : Ext.Msg.OK
			  });
	    return;
	}
	else{
	  var UpdateRet=objApply.EditUpdate(NewValue,obj.EditRowid.getValue());
	  if (UpdateRet=="1"){
	  Ext.MessageBox.alert('Status','�޸ĳɹ���');
	  obj.menuwindadd.close();
	  if (obj.EditType.getValue()=="Approval"){ExtTool.LoadCurrPage('DtlDataGridPanel');}
	  if (obj.EditType.getValue()=="Improvement"){ExtTool.LoadCurrPage('DtlDataGridPanel');}
	  }
	  else{
	  Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '�޸�ʧ�ܣ�������룺'+UpdateRet,
			  icon : Ext.Msg.WARNING,
			  minWith:'200',
			  buttons : Ext.Msg.OK
			  });
	    return;
	  };
	  };
    };
	obj.EditDelete_OnClick=function (){
	  obj.menuwindadd.close();
	  };
}
