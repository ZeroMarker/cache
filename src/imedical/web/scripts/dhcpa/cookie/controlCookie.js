//===========================================================================================
// 名    称: 控件cookie设置
// 描    述: combo控件的cookie设置
// 编 写 者：李明忠
// 编写日期: 2010-12-16
//===========================================================================================
//1、Ext.form.ComboBox的cookie值设置
//2、Ext.form.TextField的cookie值设置
//===========================================================================================

//本ComboBox是指需要从服务器端返回数据
//1.1、加载并设置ComboBox的实际值
//参数：dataStore-数据集;comboName-ComboBox名称;valueCookieName-ComboBox实际值cookie名称
var setAndLoadComboValueFromServer = function(dataStore,comboName,valueCookieName){
	dataStore.on('load', function(ds, o){
		comboName.setValue(getCookie(valueCookieName));
	});
}

//1.2、设置ComboBox的实际值
//参数：comboName-ComboBox名称;valueCookieName-ComboBox实际值cookie名称
var setComboValueFromServer = function(comboName,valueCookieName){
	comboName.setValue(getCookie(valueCookieName));
}

//本ComboBox是指在客户端写死且该ComboBox的dataStore不会变化
//2.1、设置ComboBox的显示值和实际值
//参数：comboName-ComboBox名称;rawValueCookieName-ComboBox显示值cookie名称;valueCookieName-ComboBox实际值cookie名称
var setComboValueFromClientOfNotChange = function(comboName,rawValueCookieName,valueCookieName){
	comboName.setRawValue(getCookie(rawValueCookieName));
	comboName.setValue(getCookie(valueCookieName));
}
//2.2、设置ComboBox的显示值
//参数：comboName-ComboBox名称;rawValueCookieName-ComboBox显示值cookie名称
var setComboRawValueFromClientOfNotChange = function(comboName,rawValueCookieName){
	comboName.setRawValue(getCookie(rawValueCookieName));
}
//2.3、设置ComboBox的实际值
//参数：comboName-ComboBox名称;valueCookieName-ComboBox实际值cookie名称
var setComboActValueFromClientOfNotChange = function(comboName,valueCookieName){
	comboName.setValue(getCookie(valueCookieName));
}

//本ComboBox是指在客户端写死且该ComboBox的dataStore会随着其他ComboBox值变化而变化
//3.1、加载ComboBox的变化数据值并设置ComboBox的实际值
//参数：dataStore-数据集;changeDataValue-ComboBox控件变化的数据;comboName-ComboBox名称;valueCookieName-ComboBox实际值cookie名称
var setComboValueFromClientOfChange = function(dataStore,changeDataValue,comboName,valueCookieName){
	dataStore.loadData(changeDataValue);	
	comboName.setValue(getCookie(valueCookieName));
}

//3.2、设置ComboBox的实际值
//参数：comboName-ComboBox名称;valueCookieName-ComboBox实际值cookie名称
var setComboActValueFromClientOfChange = function(comboName,valueCookieName){
	comboName.setValue(getCookie(valueCookieName));
}

//TextField的cookie值设置
//4、设置TextField的值
//参数：textFieldName-TextField名称;valueCookieName-TextField实际值cookie名称
var setTextFieldValue = function(textFieldName,valueCookieName){
	textFieldName.setValue(getCookie(valueCookieName));
}

//批量设置cookie值
//参数：dataStr字符串,格式：cookieName1^cookieValue1!cookieName2^cookieValue2!cookieName3^cookieValue3...
var setBathCookieValue = function(dataStr){
	var objArray=dataStr.split("!");
	var objLength=objArray.length;
	for(var i=0;i<objLength;i++){
		var array=objArray[i].split("^");
		var cookieName=array[0];
		var cookieValue=array[1];
		setCookie(cookieName,cookieValue);
	}
}

//批量删除cookie值
//参数：cookieNameStr字符串,格式：cookieName1^cookieName2^cookieName3...
var delBathCookieValue = function(cookieNameStr){
	var array=cookieNameStr.split("^");
	var length=array.length;
	for(var i=0;i<length;i++){
		var cookieName=array[i];
		delCookie(cookieName);
	}
}