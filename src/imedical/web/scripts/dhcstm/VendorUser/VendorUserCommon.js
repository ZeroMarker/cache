/*
var VENDORID;
if(typeof(VENDORUSERID) == 'undefined' || typeof(VENDORUSERPSWD) == 'undefined' || Ext.isEmpty(VENDORUSERID) || Ext.isEmpty(VENDORUSERPSWD)){
	alert('��¼��Ϣ��ʧЧ,�����µ�¼!');
	window.open('', '_self');
	window.close();
}else{
	var result = tkMakeServerCall('web.DHCSTM.VendorUser', 'GetVenId', VENDORUSERID, VENDORUSERPSWD);
	VENDORID = Number(result);
	if(VENDORID <= 0){
		alert('��¼��Ϣ��ʧЧ,�����µ�¼!');
		window.open('', '_self');
		window.close();
	}
}
*/


//2016-06-23 ����ʹ���������֤, ͨ��session��̨ȡֵ
var VENDORID = '', VENDOR_DESC = '';
var VendorInfo = tkMakeServerCall('web.DHCSTM.VendorUser', 'GetVenInfoBySession');
if(!Ext.isEmpty(VendorInfo)){
	VENDORID = VendorInfo.split('^')[0];
	VENDOR_DESC = VendorInfo.split('^')[1];
}

