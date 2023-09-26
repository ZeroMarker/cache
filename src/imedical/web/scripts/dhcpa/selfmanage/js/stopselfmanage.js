stopFun=function(itemGrid,itemGridDs,itemGridPagingToolbar,flag){
	var mess= flag=="stop"?"ͣ��":"����";
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		Ext.Msg.show({title : 'ע��',msg : '��ѡ����Ҫ'+mess+'������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
		return;
	} else {
		Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ'+mess+'ѡ������?', function(btn) {
			if (btn == 'yes') {
				for(var i = 0; i < len; i++){   
					var tmpRowid=rowObj[i].get("rowid");
					Ext.Ajax.request({
						url : '../csp/dhc.pa.Selfmanageexe.csp?action=stop&rowid=' + tmpRowid+'&flag='+flag,
						waitMsg : mess+'��...',
						failure : function(result, request) {
							Ext.Msg.show({title : '����',msg : '������������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({title : 'ע��',msg : mess+'�ɹ�!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
								itemGridDs.load({params : {start : 0,limit : itemGridPagingToolbar.pageSize}});
							} else {
								Ext.Msg.show({title : '����',msg : '����',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
							}
						},
						scope : this
					});
				}
			}
		});
	}
};