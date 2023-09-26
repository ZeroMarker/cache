/*
var VENDORID;
if(typeof(VENDORUSERID) == 'undefined' || typeof(VENDORUSERPSWD) == 'undefined' || Ext.isEmpty(VENDORUSERID) || Ext.isEmpty(VENDORUSERPSWD)){
	alert('登录信息已失效,请重新登录!');
	window.open('', '_self');
	window.close();
}else{
	var result = tkMakeServerCall('web.DHCSTM.VendorUser', 'GetVenId', VENDORUSERID, VENDORUSERPSWD);
	VENDORID = Number(result);
	if(VENDORID <= 0){
		alert('登录信息已失效,请重新登录!');
		window.open('', '_self');
		window.close();
	}
}
*/


//2016-06-23 不再使用上面的验证, 通过session后台取值
var VENDORID = '', VENDOR_DESC = '';
var VendorInfo = tkMakeServerCall('web.DHCSTM.VendorUser', 'GetVenInfoBySession');
if(!Ext.isEmpty(VendorInfo)){
	VENDORID = VendorInfo.split('^')[0];
	VENDOR_DESC = VendorInfo.split('^')[1];
}

