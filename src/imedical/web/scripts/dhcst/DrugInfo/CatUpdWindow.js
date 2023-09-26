function CatUpd(Catid,Catdesc,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var CatCode = new Ext.form.TextField({
					fieldLabel : '代码',
					id : 'CatCode',
					name : 'CatCode',
					width:'250'
				});
	var CatDesc = new Ext.form.TextField({
					fieldLabel : '描述',
					id : 'CatDesc',
					name : 'CatDesc',
					width:'250'
				});
	// 确定按钮
	var returnBT = new Ext.Toolbar.Button({
				text : '确定',
				tooltip : '点击确定',
				iconCls : 'page_save',
				handler : function() {
					InsertData();
				}
			});

	// 取消按钮
	var cancelBT = new Ext.Toolbar.Button({
				text : '取消',
				tooltip : '点击取消',
				iconCls : 'page_delete',
				handler : function() {
					window.close();
				}
			});

	
		
	var window = new Ext.Window({
				title : '修改药学分类',
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
			Msg.info("warning", "代码不能为空!");
			return;
		}
		if (catdesc==""){
			Msg.info("warning", "描述不能为空!");
			return;
		}
		var url = "dhcst.phccatmaintainaction.csp?action=Update";
			var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{CatId:Catid,CatCode:catcode,CatDesc:catdesc},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 刷新界面
								var IngrRowid = jsonData.info;
								Msg.info("success", "保存成功!");
								Fn();
							} else {
								if (jsonData.info==-11){
									Msg.info("warning", "代码重复");
								}else if (jsonData.info==-12){
									Msg.info("warning", "名称重复");
								}else{
									Msg.info("error", "保存失败,错误代码:"+jsonData.info);
								}
							}
						},
						scope : this
					});
			loadMask.hide();
			window.close();	
		//if (selectModel== null) {
		//	Msg.info("error","请选择录入方式!");
		//} else {
		//	SelectData();
		//	window.close();
		//}
	}

}