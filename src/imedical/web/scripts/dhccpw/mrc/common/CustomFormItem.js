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
			if (itmValue!=0&&itmValue!=false) {
				objItm.setValue(true);
			} else {
				objItm.setValue(false);
			}
		} else if (itmType == 'combo') {
			//update by zf 2015-06-13 下拉框Store未加载，赋值有问题
			if (itmValue != ''){
				var rowIndex = objItm.getStore().find(objItm.valueField,itmValue);
				if (rowIndex >-1){
					objItm.setValue(itmValue);
					objItm.setRawValue(itmRawValue);
				} else {
					var exp = 'var rd = new objItm.store.recordType({'
					+ '"' + objItm.valueField + '" : "' + itmValue + '"'
					+ ',"' + objItm.displayField + '" : "' + itmRawValue + '"'
					+ '})';
					eval(exp);  //update by pylian 20160324 fix IE11下调试时报错
					objItm.getStore().insert(0, rd);
					objItm.setValue(itmValue);
					objItm.setRawValue(itmRawValue);
				}
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
						param.ClassName = 'DHCMed.SSService.DictionarySrv';
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
	var tmpTextField = new Ext.form.TextField({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,width : 10
		,anchor : '100%'
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
//obj.IsActive = Common_Checkbox("IsActive","是否有效");

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

//表单项目子分类
function Common_ComboToItmSubCat(){
	var ItemCatID = arguments[2];
	var anchor = (arguments[3] ? arguments[3] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCCPW.MRC.FORM.ItemCatSrv';
						param.QueryName = 'QryItemSubCat';
						param.Arg1 = '';
						param.ArgCnt = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'SCID'
			}, 
			[
				{name: 'SCID', mapping: 'SCID'}
				,{name: 'SCCode', mapping: 'SCCode'}
				,{name: 'SCDesc', mapping: 'SCDesc'}
				,{name: 'SCPower', mapping: 'SCPower'}
				,{name: 'SCPowerDesc', mapping: 'SCPowerDesc'}
				,{name: 'CatID', mapping: 'CatID'}
				,{name: 'CatDesc', mapping: 'CatDesc'}
			])
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{SCDesc}</td>',
					'<td>{CatDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:200
		,valueField : 'SCID'
		,displayField : 'SCDesc'
		,editable : false
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : anchor
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToItmSubCat)引用例子
//obj.cboItemSubCat = Common_ComboToItmSubCat("cboItemSubCat","项目子分类");

//医嘱类型（长期医嘱、临时医嘱）
function Common_ComboToOECPriority(){
	var anchor = (arguments[2] ? arguments[2] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCCPW.MRC.FORM.LnkArcimSrv';
						param.QueryName = 'QryOECPriority';
						param.ArgCnt = 0;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'OECPRID'
			},
			[
				{name: 'OECPRID', mapping: 'OECPRID'}
				,{name: 'OECPRCode', mapping: 'OECPRCode'}
				,{name: 'OECPRDesc', mapping: 'OECPRDesc'}
			])
		})
		,minChars : 0
		,displayField : 'OECPRDesc'
		,valueField : 'OECPRID'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToOECPriority)引用例子
//obj.cboOECPriority = Common_ComboToOECPriority("cboOECPriority","医嘱类型");

//医嘱项（医嘱套？）
function Common_ComboToARCIM(){
	var anchor = (arguments[2] ? arguments[2] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCCPW.MRC.FORM.LnkArcimSrv';
						param.QueryName = 'QryArcimByAlias';
						param.Arg1 = tmpCombo.getRawValue();
						param.ArgCnt = 1;
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
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ArcimDesc}</td>',
					'<td>{ArcimCode}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:200
		,valueField : 'ArcimID'
		,displayField : 'ArcimDesc'
		,editable : true
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : anchor
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
//ComboBox(Common_ComboToARCIM)引用例子
//obj.cboArcim = Common_ComboToARCIM("cboArcim","医嘱项");

//剂量单位
function Common_ComboToDoseUom(){
	var cmpArcim = arguments[2];
	var anchor = (arguments[3] ? arguments[3] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCCPW.MRC.FORM.LnkArcimSrv';
						param.QueryName = 'QryDoseUomByArcim';
						var cmp = Ext.getCmp(cmpArcim);
						if (cmp) {
							var ArcimID = cmp.getValue();
						} else {
							var ArcimID = '';
						}
						param.Arg1 = ArcimID;
						param.ArgCnt = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'DoseUomID'
			},
			[
				{name: 'DoseUomID', mapping: 'DoseUomID'}
				,{name: 'DoseUomDesc', mapping: 'DoseUomDesc'}
			])
		})
		,minChars : 0
		,displayField : 'DoseUomDesc'
		,valueField : 'DoseUomID'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToDoseUom)引用例子
//obj.cboDoseUom = Common_ComboToDoseUom("cboDoseUom","剂量单位",lnkcmpname);

//疗程
function Common_ComboToPHCDuration(){
	var anchor = (arguments[2] ? arguments[2] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCCPW.MRC.FORM.LnkArcimSrv';
						param.QueryName = 'QryPHCDuration';
						param.Arg1 = tmpCombo.getRawValue();
						param.ArgCnt = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'DuratID'
			},
			[
				{name: 'DuratID', mapping: 'DuratID'}
				,{name: 'DuratDesc', mapping: 'DuratDesc'}
			])
		})
		,minChars : 0
		,displayField : 'DuratDesc'
		,valueField : 'DuratID'
		,editable : true
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToPHCDuration)引用例子
//obj.cboPHCDuration = Common_ComboToPHCDuration("cboPHCDuration","疗程");

//频次
function Common_ComboToPHCFreq(){
	var anchor = (arguments[2] ? arguments[2] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCCPW.MRC.FORM.LnkArcimSrv';
						param.QueryName = 'QryPHCFreq';
						param.Arg1 = tmpCombo.getRawValue();
						param.ArgCnt = 1;
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
		,editable : true
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToPHCFreq)引用例子
//obj.cboPHCFreq = Common_ComboToPHCFreq("cboPHCFreq","频次");

//用法
function Common_ComboToPHCInstruc(){
	var anchor = (arguments[2] ? arguments[2] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCCPW.MRC.FORM.LnkArcimSrv';
						param.QueryName = 'QryPHCInstruc';
						param.Arg1 = tmpCombo.getRawValue();
						param.ArgCnt = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'InstrucID'
			},
			[
				{name: 'InstrucID', mapping: 'InstrucID'}
				,{name: 'InstrucDesc', mapping: 'InstrucDesc'}
			])
		})
		,minChars : 0
		,displayField : 'InstrucDesc'
		,valueField : 'InstrucID'
		,editable : true
		,triggerAction : 'all'
		,width : 10
		,anchor : anchor
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToPHCInstruc)引用例子
//obj.cboPHCInstruc = Common_ComboToPHCInstruc("cboPHCInstruc","用法");


//临床路径类型
function Common_ComboToPathWayType(){
	var anchor = (arguments[2] ? arguments[2] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'web.DHCCPW.MRC.PathWayType';
						param.QueryName = 'GetPathWayType';
						param.ArgCnt = 0;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'typeRowid'
			},
			[
				{name: 'typeRowid', mapping: 'Rowid'}
				,{name: 'typeCode', mapping: 'code'}
				,{name: 'typeDesc', mapping: 'desc'}
			])
		})
		,minChars : 0
		,displayField : 'typeDesc'
		,valueField : 'typeRowid'
		,editable : false
		,triggerAction : 'all'
		,width : 100
		,anchor : anchor
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
//ComboBox(Common_ComboToPathWayType)引用例子
//obj.cboPathWayType = Common_ComboToPathWayType("cboPathWayType","路径类型");