/**
 * name:Recording the Logs of Optionning By User 
 * author:LiMingzhong
 * Date:2012-2-13 
 * Desc:��¼������־
 */
var recordLogsFun = function (optionName){
	var userID = session['LOGON.USERID'];
	
	Ext.Ajax.request({
		url:'dhc.bonus.publicexe.csp?action=add&userID='+userID+'&optionName='+optionName,
		failure: function(result,request) {
			//Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			/*var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
				window.close();
			}else{
				var message = "";
				message = "SQLErr: " + jsonData.info;
				if(jsonData.info=='EmptyRecData'){
					message='���������Ϊ��!';
					Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}*/
		},
		scope: this
	});
}