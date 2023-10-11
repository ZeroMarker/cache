delFun = function() {
	// var rowObj = itemGrid.getSelectionModel().getSelections();
    // var len = rowObj.length;
  if(tmpNode!=""){
		var selectrowid=tmpNode.attributes["rowid"];
    	Ext.MessageBox.confirm('提示', 
    	    '确定要删除选定的行?', 
    	    function(btn) {
	    	if(btn == 'yes'){
					//根据选中判断是否为非末级科目
				var rowid=tmpNode.attributes["rowid"];
				Ext.Ajax.request({
				  url:'herp.acct.acctsubjserverexe.csp?action=isfathercode&rowid='+rowid,
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') { 
						var data = jsonData.info;
						//如果是末级科目
						if(data==0){
						Ext.Ajax.request({
						url:'herp.acct.acctsubjserverexe.csp?action=delsj&rowid='+rowid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
								tmpNode.remove();
								// tmpNode.expand(false);
								CheckitemGrid.load({params:{start:0,limit:25}});
							}else{
								Ext.Msg.show({title:'错误',msg:'该科目已启用,删除失败!  ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});	
					} else if(data==1){			//非末级
						Ext.MessageBox.confirm('提示', '存在子科目,点击"Yes"会删除所有子科目请谨慎使用,,是否继续?', 
    	    			function(btn){
						if(btn == 'yes'){	
							Ext.Ajax.request({
							url:'herp.acct.acctsubjserverexe.csp?action=delsj&rowid='+rowid,
							waitMsg:'删除中...',
							failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true'){
									Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									tmpNode.remove();
									tmpNode.expand(false);
									CheckitemGrid.load({params:{start:0,limit:25}});
								}else{
									Ext.Msg.show({title:'错误',msg:'该科目已启用,删除失败!  ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
							});
						}
						});
						}
						}
					},
					scope: this
				});
			    }
		    });	
    }else{
    	Ext.Msg.show({title:'错误',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    }

}


