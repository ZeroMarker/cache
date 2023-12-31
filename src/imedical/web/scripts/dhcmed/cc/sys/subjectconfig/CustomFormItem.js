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
			var cbValues = itmValue.split(',');
			var cbTexts = itmRawValue.split(',');
			if (Object.prototype.toString.call(objItm.items) === '[object Array]') {
				for (var idx = 0; idx < objItm.items.length; idx++) {
					var cb = objItm.items[idx];
					cb.checked = false;
					for (var indValue = 0; indValue < cbValues.length; indValue++) {
						if (!cbValues[indValue]) continue;
						if (cb.inputValue == cbValues[indValue]) {
							cb.checked = true;
						}
					}
					for (var indText = 0; indText < cbTexts.length; indText++) {
						if (!cbTexts[indText]) continue;
						if (cb.boxLabel == cbTexts[indText]) {
							cb.checked = true;
						}
					}
				}
			} else {
				for (var idx = 0; idx < objItm.items.length; idx++) {
					var cb = objItm.items.itemAt(idx);
					cb.setValue(false);
					for (var indValue = 0; indValue < cbValues.length; indValue++) {
						if (!cbValues[indValue]) continue;
						if (cb.inputValue == cbValues[indValue]) {
							cb.setValue(true);
						}
					}
					for (var indText = 0; indText < cbTexts.length; indText++) {
						if (!cbTexts[indText]) continue;
						if (cb.boxLabel == cbTexts[indText]) {
							cb.checked = true;
						}
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
	var objDictionarySrv = ExtTool.StaticServerObject("DHCMed.NINFService.Srv.CommonCls");
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
//CheckboxGroup(Common_CheckboxGroupToDic)引用例子
//obj.Operation_cbgEmerOperType = Common_CheckboxGroupToDic("Operation_cbgEmerOperType","手术类型","OperationType",4);

function Common_RadioGroupToDic()
{
	var arrItem = new Array();
	var objDictionarySrv = ExtTool.StaticServerObject("DHCMed.NINFService.Srv.CommonCls");
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
					} else {
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
					}
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
	var tmpDateField = new Ext.form.DateField({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,format : 'Y-m-d H:i'
		,altFormats : 'Y-m-d H:i|d/m/Y H:i'
		,width : 10
		,anchor : '100%'
	});
	
	return tmpDateField;
}
//DateField(Common_DateFieldToDateTime)引用例子
//obj.Operation_txtEndDateTime = Common_DateFieldToDateTime("Operation_txtEndDateTime","开始时间");
	
function Common_DateFieldToDate()
{
	var tmpDateField = new Ext.form.DateField({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,format : 'Y-m-d'
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 10
		,anchor : '100%'
		,value : new Date()
	});
	
	return tmpDateField;
}
//DateField(Common_DateFieldToDate)引用例子
//obj.Infection_txtInfDate = Common_DateFieldToDate("Infection_txtInfDate","感染日期");

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
//TimeField(Common_TextFieldToFormat)引用例子
//obj.Anti_txtTime = Common_TextFieldToFormat("Anti_txtTime","术前用药时间");
	
function Common_ComboToDic()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL + '?1=1&ClassName=DHCMed.NINFService.Srv.CommonCls&QueryName=QryDictionary&Arg1=' + arguments[2] + '&ArgCnt=1&2=2'
				,failure : function() {
					//Ext.Msg.alert("数据加载失败！请检查");
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
		,anchor : '100%'
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToDic)引用例子
//obj.Operation_cboAnaesthesia = Common_ComboToDic("Operation_cboAnaesthesia","麻醉方式","InfectionNarcosisType");
	
function Common_ComboToInfPos()
{
	var linkInfPosToDiag = arguments[2];
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
		,anchor : '100%'
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
		,anchor : '100%'
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToInfDia)引用例子
//obj.Infection_cboInfDia = Common_ComboToInfDia("Infection_cboInfDia","感染诊断","Infection_cboInfPos");

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
						param.QueryName = 'QryPathogeny';
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
				'<tpl for="."><tr>',
					'<td><div class="search-item">{PyDesc}</div></td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:true
		,triggerAction : 'all'
		,itemSelector: 'div.search-item'
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
						param.QueryName = 'QryAntibiotics';
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
				'<tpl for="."><tr>',
					'<td><div class="search-item">{AntiDesc}</div></td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:true
		,triggerAction : 'all'
		,itemSelector: 'div.search-item'
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
					'<th>代码</th>',
				'</tr></thead>',
				'<tpl for="."><tr>',
					'<td><div class="search-item">{Name}</div></td>',
					'<td>{Code}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:true
		,triggerAction : 'all'
		,itemSelector: 'div.search-item'
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
				'<tpl for="."><tr>',
					'<td><div class="search-item">{ICDDesc}</div></td>',
					'<td>{ICD10}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:true
		,triggerAction : 'all'
		,itemSelector: 'div.search-item'
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
				'<tpl for="."><tr>',
					'<td><div class="search-item">{OperDesc}</div></td>',
					'<td>{OperCM3}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:true
		,triggerAction : 'all'
		,itemSelector: 'div.search-item'
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
//TextField(Common_TextField)引用例子
//obj.Operation_txtResume = Common_TextField("Operation_txtResume","备注");


function Common_TextArea()
{
	var tmpTextField = new Ext.form.TextArea({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,width : 10
		,height : (arguments[2] ? arguments[2] : 10)
		,anchor : '100%'
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
//obj.Operation_txtResume = Common_tmpLabel("Operation_txtResume","备注");

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
				'<tpl for="."><tr>',
					'<td><div class="search-item">{ArcimDesc}</div></td>',
					'<td>{ArcimCode}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:true
		,triggerAction : 'all'
		,itemSelector: 'div.search-item'
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

function Common_ComboToLoc()
{
	var LocType = arguments[2];
	var lnkLocCmp = arguments[3];
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
						param.ArgCnt    = 4;
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
				'<tpl for="."><tr>',
					'<td><div class="search-item">{LocDesc}</div></td>',
					'<td>{LocRowId}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:true
		,triggerAction : 'all'
		,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'LocRowId'
		,displayField : 'LocDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		*/
		,minChars : 0
		,displayField : 'LocDesc'
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
					'<th>代码</th>',
					'<th>名称</th>',
					'<th>分类</th>',
					'<th>频次</th>',
				'</tr></thead>',
				'<tpl for="."><tr>',
					'<td>{ItemCode}</td>',
					'<td><div class="search-item">{ItemDesc}</div></td>',
					'<td>{ItemCategDesc}</td>',
					'<td>{ItemFreqDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:true
		,triggerAction : 'all'
		,itemSelector: 'div.search-item'
		,minListWidth:500
		,valueField : 'ItemID'
		,displayField : 'ItemDesc'
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
		*/
	});
	//tmpCombo.getStore().load({});
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
	}
}

function Common_ComboToSubject()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.CCService.Sys.SubjectSrv';
						param.QueryName = 'QrySubject';
						param.Arg1      = '';
						param.Arg2      = 1; //Modified By LiYang 2014-11-07 FixBug:3599 医政管理-监控中心-基础配置-主题配置-【监控主题】下拉框中显示无效的数据
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
				,{name: 'Code', mapping: 'Code'}
				,{name: 'Title', mapping: 'Title'}
			])
		})
		,minChars : 0
		,displayField : 'Title'
		,valueField : 'Code'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : '100%'
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToSubject)引用例子
//obj.cboSubject = Common_ComboToSubject("cboSubject","监控主题");
