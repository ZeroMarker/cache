/**
  *name:tab of database
  *author:LY
  *Date:2013-08-07
  *�人�е�һҽԺexcel�ļ��ϴ�����
 */
//button:���ڻ�ȡbutton��һЩ��Ϣ��audit������ȷ������˻���ȡ����ˣ�userid�������
var doaudit = function(button,status,userid){
	
				//alert(selectedcell+'111'+selectedcell.split("||")[1]);
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				var tmpRowid = selectedcell.split("||")[1];
				if(len < 1){
					Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ'+button.getText()+'������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					
					
				}
				if (true) {

					Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ'+button.getText()+'ѡ����������?', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : itemGridUrl + '?action=auditmian&rowid=' + rowObj[0].get("parref")+'&userid='+userid+'&status='+status,
								waitMsg : button.getText()+'��...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '����',
												msg : '������������!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : 'ע��',
													msg : '�����ɹ�!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										dosearch(start,limit);
									} else {
										Ext.Msg.show({
													title : '����',
													msg : '����',
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
//								title : 'ע��',
//								msg : '�ò���δ��������!',
//								buttons : Ext.Msg.OK,
//								icon : Ext.MessageBox.WARNING
//							});
//					return;
				} else {

					Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ'+button.getText()+'ѡ����������?', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : itemGridUrl + '?action=audit&rowid=' + tmpRowid+'&userid='+userid+'&status='+status,
								waitMsg : button.getText()+'��...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '����',
												msg : '������������!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : 'ע��',
													msg : '�����ɹ�!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										dosearch(start,limit);
									} else {
										Ext.Msg.show({
													title : '����',
													msg : '����',
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

