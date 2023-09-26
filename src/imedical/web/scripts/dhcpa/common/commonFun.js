/**存放公用的js function
*/
///判断绩效方案是否已经审核
///应用于修改功能
///参数：方案id

var ifAduitSchem=function ifAduitSchem(schemId,fn){
	Ext.Ajax.request({
		url: 'dhc.pa.paauditexe.csp?action=ifAuditSchem&schemDr='+schemId,
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			
			var flag = false;
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Ext.Msg.show({title:'错误',msg:"方案已经审核，不能进行该操作",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				flag = true;
			}
			if(fn)fn(flag);
		}
	});
	
	
};