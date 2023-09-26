delSchemFun = function(dataStore,grid,pagingTool){
    //定义并初始化行对象
	var rowObj=grid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要修改的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		var myRowid = rowObj[0].get("rowid");
	}
	function handler(id){
		if(id=="yes"){
			Ext.Ajax.request({
				url: 'dhc.pa.schemexe.csp?action=del&rowid='+myRowid,
				waitMsg:'删除中...',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						dataStore.load({params:{start:0,limit:pagingTool.pageSize}});
					}else{
						Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			});
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('提示','确实要删除该条记录吗?',handler);
};