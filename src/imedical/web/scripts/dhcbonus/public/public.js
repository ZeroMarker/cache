/**
 * name:Recording the Logs of Optionning By User 
 * author:LiMingzhong
 * Date:2012-2-13 
 * Desc:记录操作日志
 */
var recordLogsFun = function (optionName){
	var userID = session['LOGON.USERID'];
	
	Ext.Ajax.request({
		url:'dhc.bonus.publicexe.csp?action=add&userID='+userID+'&optionName='+optionName,
		failure: function(result,request) {
			//Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			/*var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
				window.close();
			}else{
				var message = "";
				message = "SQLErr: " + jsonData.info;
				if(jsonData.info=='EmptyRecData'){
					message='输入的数据为空!';
					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}*/
		},
		scope: this
	});
}