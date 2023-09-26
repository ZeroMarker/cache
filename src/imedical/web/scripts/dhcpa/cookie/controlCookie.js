//===========================================================================================
// ��    ��: �ؼ�cookie����
// ��    ��: combo�ؼ���cookie����
// �� д �ߣ�������
// ��д����: 2010-12-16
//===========================================================================================
//1��Ext.form.ComboBox��cookieֵ����
//2��Ext.form.TextField��cookieֵ����
//===========================================================================================

//��ComboBox��ָ��Ҫ�ӷ������˷�������
//1.1�����ز�����ComboBox��ʵ��ֵ
//������dataStore-���ݼ�;comboName-ComboBox����;valueCookieName-ComboBoxʵ��ֵcookie����
var setAndLoadComboValueFromServer = function(dataStore,comboName,valueCookieName){
	dataStore.on('load', function(ds, o){
		comboName.setValue(getCookie(valueCookieName));
	});
}

//1.2������ComboBox��ʵ��ֵ
//������comboName-ComboBox����;valueCookieName-ComboBoxʵ��ֵcookie����
var setComboValueFromServer = function(comboName,valueCookieName){
	comboName.setValue(getCookie(valueCookieName));
}

//��ComboBox��ָ�ڿͻ���д���Ҹ�ComboBox��dataStore����仯
//2.1������ComboBox����ʾֵ��ʵ��ֵ
//������comboName-ComboBox����;rawValueCookieName-ComboBox��ʾֵcookie����;valueCookieName-ComboBoxʵ��ֵcookie����
var setComboValueFromClientOfNotChange = function(comboName,rawValueCookieName,valueCookieName){
	comboName.setRawValue(getCookie(rawValueCookieName));
	comboName.setValue(getCookie(valueCookieName));
}
//2.2������ComboBox����ʾֵ
//������comboName-ComboBox����;rawValueCookieName-ComboBox��ʾֵcookie����
var setComboRawValueFromClientOfNotChange = function(comboName,rawValueCookieName){
	comboName.setRawValue(getCookie(rawValueCookieName));
}
//2.3������ComboBox��ʵ��ֵ
//������comboName-ComboBox����;valueCookieName-ComboBoxʵ��ֵcookie����
var setComboActValueFromClientOfNotChange = function(comboName,valueCookieName){
	comboName.setValue(getCookie(valueCookieName));
}

//��ComboBox��ָ�ڿͻ���д���Ҹ�ComboBox��dataStore����������ComboBoxֵ�仯���仯
//3.1������ComboBox�ı仯����ֵ������ComboBox��ʵ��ֵ
//������dataStore-���ݼ�;changeDataValue-ComboBox�ؼ��仯������;comboName-ComboBox����;valueCookieName-ComboBoxʵ��ֵcookie����
var setComboValueFromClientOfChange = function(dataStore,changeDataValue,comboName,valueCookieName){
	dataStore.loadData(changeDataValue);	
	comboName.setValue(getCookie(valueCookieName));
}

//3.2������ComboBox��ʵ��ֵ
//������comboName-ComboBox����;valueCookieName-ComboBoxʵ��ֵcookie����
var setComboActValueFromClientOfChange = function(comboName,valueCookieName){
	comboName.setValue(getCookie(valueCookieName));
}

//TextField��cookieֵ����
//4������TextField��ֵ
//������textFieldName-TextField����;valueCookieName-TextFieldʵ��ֵcookie����
var setTextFieldValue = function(textFieldName,valueCookieName){
	textFieldName.setValue(getCookie(valueCookieName));
}

//��������cookieֵ
//������dataStr�ַ���,��ʽ��cookieName1^cookieValue1!cookieName2^cookieValue2!cookieName3^cookieValue3...
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

//����ɾ��cookieֵ
//������cookieNameStr�ַ���,��ʽ��cookieName1^cookieName2^cookieName3...
var delBathCookieValue = function(cookieNameStr){
	var array=cookieNameStr.split("^");
	var length=array.length;
	for(var i=0;i<length;i++){
		var cookieName=array[i];
		delCookie(cookieName);
	}
}