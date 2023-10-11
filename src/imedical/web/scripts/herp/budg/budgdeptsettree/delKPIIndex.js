//删除函数
delFun = function(node){
	if(node!=null){
		if(node.attributes.id=="roo"){
			Ext.Msg.show({title:'提示',msg:'根节点不能删除!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}else{
			var end = node.attributes.islast;
			if(end=="Y"){
				//获取记录的ID
				var rowid = node.attributes.id;
				var parent = node.attributes.supdeptid;
				function handler(id){
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/herp.budg.budgdeptsettreeexe.csp?action=del&rowid='+rowid,
							waitMsg:'删除中...',
							failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									
										Ext.getCmp('detailReport').getNodeById(jsonData.info).reload();
										Ext.Msg.show({title:'提示',msg:'删除成功!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									
								}else {
									if(jsonData.info=='childNode'){
										Ext.Msg.show({title:'提示',msg:'该记录下存在子节点,请先删除!',width:300,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									}
								}
							},
							scope: this
						});
					}else{
						return false;
					}
				}
				Ext.MessageBox.confirm('提示','确实要删除吗?',handler);
			}else{
				Ext.Msg.show({title:'提示',msg:'非末端不能删除!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
		}
	}else{
		Ext.Msg.show({title:'错误',msg:'请选择记录！',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	}
};
