//修改函数

updateSetDetailFun = function(node){
    //alert(node);
	if(node==null){
		Ext.Msg.show({title:'提示',msg:'请选择要修改的数据!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
	}else{
		if(node.attributes.id=="roo"){
			Ext.Msg.show({title:'提示',msg:'根节点不允许被修改!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}
		else if(node.attributes.submit=="Y"){
			Ext.Msg.show({title:'提示',msg:'已提交反馈,无需再编写反馈信息',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}
		else{
			//取该条记录的rowid
			var rowid = node.attributes.detailid;
		
			var NameField = new Ext.form.TextField({
				id:'NameField',
				fieldLabel: '反馈信息',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请输入反馈信息...',
				anchor: '90%',
				selectOnFocus:'true'
			});
				
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 60,
				items: [
					NameField
				]
			});	
		
			formPanel.on('afterlayout', function(panel,layout) {
				this.getForm().loadRecord(node);
				NameField.setValue(node.attributes.fbdesc);
			});	
			
			editButton = new Ext.Toolbar.Button({
				text:'提交'
			});

			editHandler = function(){
			    var name = NameField.getValue();
				name = trim(name);
			    if(name==""){
					Ext.Msg.show({title:'提示',msg:'请填写反馈信息',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}	
                var data = 	name+'^'+UserCode+'^Y';			
				Ext.Ajax.request({
					url: jxfeedbackURL+'?action=edit&data='+data+'&rowid='+rowid,
					waitMsg: '修改中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'提示',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							if(node.attributes.par=='0'){
							  Ext.getCmp('detailsetReport').getNodeById("roo").reload();
							}
							else{
							Ext.getCmp('detailsetReport').getNodeById(node.attributes.par).reload();
							}
							window.close();
						}else{
							var message = "";
							if(jsonData.info=='EmptyRecData') message='空数据!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			};
	
			editButton.addListener('click',editHandler,false);
		
			cancel = new Ext.Toolbar.Button({
				text:'退出'
			});
			
			cancelHandler1 = function(){
				window.close();
			}

			cancel.addListener('click',cancelHandler1,false);
			
			var window = new Ext.Window({
				title: '编写反馈信息',
				width: 420,
				height:200,
				minWidth: 420,
				minHeight: 100,
				layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: formPanel,
				buttons:[editButton,cancel]
			});
			window.show();
		}
	}
};