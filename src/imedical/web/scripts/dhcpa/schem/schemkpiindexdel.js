//删除函数
delSchemDetailFun = function(node){
	if(node!=null){
		if(node.attributes.parent=="0"){
			Ext.Msg.show({title:'提示',msg:'根节点不能删除!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}else{
			var end = node.attributes.isEnd;
				//获取记录的ID
				var rowid = node.attributes.detailid;
				var parent = node.attributes.parent;
				function handler(id){
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/dhc.pa.schemexe.csp?action=schemdetaildel&rowid='+rowid,
							waitMsg:'删除中...',
							failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Ajax.request({
										url:'../csp/dhc.pa.kpiindexexe.csp?action=findfather&parent='+parent,
										waitMsg:'删除中...',
										failure: function(result, request){
											Ext.Msg.show({title:'提示',msg:'已经删除成功,但是刷新任务失败,不影响数据',width:300,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										},
										success: function(result, request){
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') {
												Ext.Msg.show({title:'提示',msg:'删除成功!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
												if(jsonData.info==0){
													jsonData.info="roo";
												}
												Ext.getCmp('detailReport').getNodeById(jsonData.info).reload();
											}
										},
										scope: this
									});
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
			
		}
	}else{
		Ext.Msg.show({title:'错误',msg:'请选择记录！',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	}
};
