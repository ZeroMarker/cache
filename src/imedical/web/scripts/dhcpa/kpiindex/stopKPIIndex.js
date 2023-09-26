//删除函数
stopFun = function(node){
	if(node!=null){
		if(node.attributes.id=="roo"){
			Ext.Msg.show({title:'提示',msg:'根节点不能停用!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}else{
			var end = node.attributes.isStop;
			if(end=="N"){
				//获取记录的ID
				var rowid = node.attributes.id;
				var parent = node.attributes.parent;
				function handler(id){
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/dhc.pa.kpiindexexe.csp?action=stopKPI&rowid='+rowid,
							waitMsg:'操作中...',
							failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'停用成功!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									if(jsonData.info==0){
										jsonData.info="roo";
									}
									Ext.getCmp('detailReport').getNodeById(jsonData.info).reload();
								}else if(jsonData.info=='childNode'){
										Ext.Msg.show({title:'提示',msg:'该记录下存在未停用子节点,请先置为停用!',width:300,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
							},
							scope: this
						});
					}else{
						return false;
					}
				}
				Ext.MessageBox.confirm('提示','确实要停用该指标吗?',handler);
			}else{
				Ext.Msg.show({title:'提示',msg:'该指标已经停用!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}
		}
	}else{
		Ext.Msg.show({title:'错误',msg:'请选择记录！',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	}
};
