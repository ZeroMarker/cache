/**��Ź��õ�js function
*/
///�жϼ�Ч�����Ƿ��Ѿ����
///Ӧ�����޸Ĺ���
///����������id

var ifAduitSchem=function ifAduitSchem(schemId,fn){
	Ext.Ajax.request({
		url: 'dhc.pa.paauditexe.csp?action=ifAuditSchem&schemDr='+schemId,
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			
			var flag = false;
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Ext.Msg.show({title:'����',msg:"�����Ѿ���ˣ����ܽ��иò���",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				flag = true;
			}
			if(fn)fn(flag);
		}
	});
	
	
};