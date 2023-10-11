fundel = function() {

		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			//alert(rowid);
		}
		function handler(id){
			if(id=="yes"){
			
				  Ext.each(rowObj, function(record) {
				  if (Ext.isEmpty(record.get("rowid"))) {
				  itemGrid.getStore().remove(record);
				  return;}
					Ext.Ajax.request({
						url:'../csp/herp.acct.acctcashflowitemmainexe.csp?action=del&rowid='+rowid+'&acctbookid='+acctbookid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
								//detailGrid.load({params:{start:0, limit:20,checkmainid:rowid}});
							}else{
								//Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								var message="";
								if(jsonData.info=='msg') message='删除失败！该项目存在子级项目。 ';
								Ext.Msg.show({title:'提示',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							}
						},
						scope: this
					});
				});
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除该条记录吗? ',handler);
}


