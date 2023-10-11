submitFun = function(){ 

        var selectedRow = itemGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(selectedRow[0].get("VouchState")=="审核不通过"||selectedRow[0].get("VouchState")=="提交"||selectedRow[0].get("VouchState")=="审核通过"||selectedRow[0].get("VouchState")=="结账"||selectedRow[0].get("VouchState")=="记账")
		{
			      Ext.Msg.show({title:'注意',msg:'数据已提交！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		}
        function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:projUrl+'?action=submit&&rowid='+selectedRow[0].get("VouchID")+'&userid='+userid,
					waitMsg:'提交中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'提交成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0, limit:12,userid:userid}});
							
						}else{
							Ext.Msg.show({title:'错误',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
			    });
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要提交该条记录吗?',handler);

};



/////复制凭证
copyFun=function(){
		var selectedRow = itemGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要冲销的凭证!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
 		
        function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:projUrl+'?action=copy&&rowid='+selectedRow[0].get("VouchID")+'&userid='+userid,
					waitMsg:'提交中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'复制完成!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0, limit:12,userid:userid}});
							
						}else{
							Ext.Msg.show({title:'错误',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
			    });
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要复制此凭证吗?',handler);
	
}



/////作废凭证
cacelFun=function(){
	var selectedRow = itemGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要作废的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(selectedRow[0].get("VouchState")=="审核不通过"||selectedRow[0].get("VouchState")=="提交"||selectedRow[0].get("VouchState")=="审核通过"||selectedRow[0].get("VouchState")=="结账"||selectedRow[0].get("VouchState")=="记账"||selectedRow[0].get("IsCancel")=="是")
		{
			      Ext.Msg.show({title:'注意',msg:'数据已提交,不能作废！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		}
        function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:projUrl+'?action=cacel&&rowid='+selectedRow[0].get("VouchID")+'&userid='+userid,
					waitMsg:'提交中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'作废完成!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0, limit:12,userid:userid}});
							
						}else{
							Ext.Msg.show({title:'错误',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
			    });
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要作废此凭证吗?',handler);
	
}

/////冲销凭证
destroyFun=function(){
		var selectedRow = itemGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要冲销的凭证!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(selectedRow[0].get("IsDestroy")=="是")
		{
			      Ext.Msg.show({title:'注意',msg:'数据已冲销！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		} 
		if(selectedRow[0].get("IsCancel")=="是")
		{
			      Ext.Msg.show({title:'注意',msg:'数据已作废！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		} 
        function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:projUrl+'?action=destroy&&rowid='+selectedRow[0].get("VouchID")+'&userid='+userid,
					waitMsg:'提交中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'冲销完成!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0, limit:12,userid:userid}});
							
						}else{
							Ext.Msg.show({title:'错误',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
			    });
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要冲销此凭证吗?',handler);
	
}
