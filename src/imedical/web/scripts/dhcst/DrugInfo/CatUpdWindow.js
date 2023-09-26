function CatUpd(Catid,Catdesc,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var CatCode = new Ext.form.TextField({
					fieldLabel : '����',
					id : 'CatCode',
					name : 'CatCode',
					width:'250'
				});
	var CatDesc = new Ext.form.TextField({
					fieldLabel : '����',
					id : 'CatDesc',
					name : 'CatDesc',
					width:'250'
				});
	// ȷ����ť
	var returnBT = new Ext.Toolbar.Button({
				text : 'ȷ��',
				tooltip : '���ȷ��',
				iconCls : 'page_save',
				handler : function() {
					InsertData();
				}
			});

	// ȡ����ť
	var cancelBT = new Ext.Toolbar.Button({
				text : 'ȡ��',
				tooltip : '���ȡ��',
				iconCls : 'page_delete',
				handler : function() {
					window.close();
				}
			});

	
		
	var window = new Ext.Window({
				title : '�޸�ҩѧ����',
				width : 350,
				height : 130,
				layout:'fit',
			    plain:true,
			    modal:true,
				items:[{
					xtype:'fieldset',
					id:'InputModel',
					labelWidth:50,
					items : [CatCode,CatDesc]
					}
					],
				bbar:['->',cancelBT,'->',returnBT]			
			});

	window.show();	
	SetCatInfo();
	function SetCatInfo(){
	  var url="dhcst.phccatmaintainaction.csp?action=GetCatCode&CatId="+Catid;
	  var Catcode=ExecuteDBSynAccess(url);
	  Ext.getCmp('CatCode').setValue(Catcode);
	  Ext.getCmp('CatDesc').setValue(Catdesc);
	}


	function InsertData() {
		var catcode = Ext.getCmp('CatCode').getValue();	
		var catdesc=Ext.getCmp('CatDesc').getValue();
		if (catcode==""){
			Msg.info("warning", "���벻��Ϊ��!");
			return;
		}
		if (catdesc==""){
			Msg.info("warning", "��������Ϊ��!");
			return;
		}
		var url = "dhcst.phccatmaintainaction.csp?action=Update";
			var loadMask=ShowLoadMask(Ext.getBody(),"������...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{CatId:Catid,CatCode:catcode,CatDesc:catdesc},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ˢ�½���
								var IngrRowid = jsonData.info;
								Msg.info("success", "����ɹ�!");
								Fn();
							} else {
								if (jsonData.info==-11){
									Msg.info("warning", "�����ظ�");
								}else if (jsonData.info==-12){
									Msg.info("warning", "�����ظ�");
								}else{
									Msg.info("error", "����ʧ��,�������:"+jsonData.info);
								}
							}
						},
						scope : this
					});
			loadMask.hide();
			window.close();	
		//if (selectModel== null) {
		//	Msg.info("error","��ѡ��¼�뷽ʽ!");
		//} else {
		//	SelectData();
		//	window.close();
		//}
	}

}