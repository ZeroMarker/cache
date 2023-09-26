stopFun=function(itemGrid,itemGridDs,itemGridPagingToolbar,flag){
	var mess= flag=="stop"?"停用":"启用";
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		Ext.Msg.show({title : '注意',msg : '请选择需要'+mess+'的数据!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
		return;
	} else {
		Ext.MessageBox.confirm('提示', '确定要'+mess+'选定的行?', function(btn) {
			if (btn == 'yes') {
				for(var i = 0; i < len; i++){   
					var tmpRowid=rowObj[i].get("rowid");
					Ext.Ajax.request({
						url : '../csp/dhc.pa.Selfmanageexe.csp?action=stop&rowid=' + tmpRowid+'&flag='+flag,
						waitMsg : mess+'中...',
						failure : function(result, request) {
							Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({title : '注意',msg : mess+'成功!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
								itemGridDs.load({params : {start : 0,limit : itemGridPagingToolbar.pageSize}});
							} else {
								Ext.Msg.show({title : '错误',msg : '错误',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
							}
						},
						scope : this
					});
				}
			}
		});
	}
};