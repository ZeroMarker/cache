/**
  *name:tab of database
  *author:LY
  *Date:2013-08-07
  *武汉市第一医院excel文件上传功能
 */
//button:用于获取button的一些信息，audit：用来确定是审核还是取消审核，userid：审核人
var doaudit = function(button,status,userid){
	
				//alert(selectedcell+'111'+selectedcell.split("||")[1]);
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				var tmpRowid = selectedcell.split("||")[1];
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择需要'+button.getText()+'的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					
					
				}
				if (true) {

					Ext.MessageBox.confirm('提示', '确定要'+button.getText()+'选定的数据吗?', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : itemGridUrl + '?action=auditmian&rowid=' + rowObj[0].get("parref")+'&userid='+userid+'&status='+status,
								waitMsg : button.getText()+'中...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '错误',
												msg : '请检查网络连接!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : '注意',
													msg : '操作成功!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										dosearch(start,limit);
									} else {
										Ext.Msg.show({
													title : '错误',
													msg : '错误',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
									}
								},
								scope : this
							});
						}
					});
//					Ext.Msg.show({
//								title : '注意',
//								msg : '该病人未做此项检查!',
//								buttons : Ext.Msg.OK,
//								icon : Ext.MessageBox.WARNING
//							});
//					return;
				} else {

					Ext.MessageBox.confirm('提示', '确定要'+button.getText()+'选定的数据吗?', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : itemGridUrl + '?action=audit&rowid=' + tmpRowid+'&userid='+userid+'&status='+status,
								waitMsg : button.getText()+'中...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '错误',
												msg : '请检查网络连接!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : '注意',
													msg : '操作成功!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										dosearch(start,limit);
									} else {
										Ext.Msg.show({
													title : '错误',
													msg : '错误',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
									}
								},
								scope : this
							});
						}
					});
				}
};

