delFun = function() {
	var rowObj = itemGrid.getSelectionModel().getSelections();
	
    var len = rowObj.length;
   
     if(len == 1){
    	Ext.MessageBox.confirm('提示', 
    	    '确定要删除选定的行?', 
    	    function(btn) {
	    	if(btn == 'yes'){	
				var rowid=rowObj[0].get("rowid");	
				Ext.Ajax.request({
				  url:'herp.acct.acctsubjserverexe.csp?action=isfathercode&rowid='+rowid,
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') { 
						var data = jsonData.info;
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
								itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
								CheckitemGrid.load({params:{start:0,limit:25}});
							}else{
								Ext.Msg.show({title:'错误',msg:'该科目已启用,删除失败!  ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});			                
					} else if(data==1){
						Ext.MessageBox.confirm('提示', '存在子科目，确定要删除选定的行?', 
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
								itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
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
    }else if(len<1)
    {
    	Ext.Msg.show({title:'错误',msg:'请选择需要删除的数据! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
    }else if(len>1){
	    Ext.MessageBox.confirm('提示', 
    	    '确定要删除选定的行?', 
    	function(btn) {
		if(btn == 'yes'){
			for(var i = 0; i < len; i++){   
			var rowid=rowObj[i].get("rowid");
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
						itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						CheckitemGrid.load({params:{start:0,limit:25}});
					}else{
						Ext.Msg.show({title:'错误',msg:'该科目已启用,删除失败! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			});	
			}
		}
		});
		
	}

}


