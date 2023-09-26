//修改函数
updateSetDetailFun = function(node){
    //alert(node);
	function isNumber(val)
	{
		 return typeof val == 'number' && isFinite(val);
	}

	if(node==null){
		Ext.Msg.show({title:'提示',msg:'请选择要修改的数据!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
	}else{
		if(node.attributes.id=="roo"){
			Ext.Msg.show({title:'提示',msg:'根节点不允许被修改!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}else{
			//取该条记录的rowid
			var rowid = node.attributes.detailid;
		
			var NameField = new Ext.form.TextField({
				id:'NameField',
				fieldLabel: '指标权重',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请输入指标权重...',
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
				NameField.setValue(node.attributes.rate);
			});	
			
			editButton = new Ext.Toolbar.Button({
				text:'修改'
			});

			editHandler = function(){
				var name = NameField.getValue();
				
				if(name>=0)
				{
				  name = trim(name);
				}
				else if(name<=1000)
				{
				 name = trim(name);
				}
				else
				{
				  Ext.Msg.show({title:'提示',msg:'修改权重请输入数字',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				
				Ext.Ajax.request({
					url: SchemUrl+'?action=editrate&data='+name+'&rowid='+rowid,
					waitMsg: '修改中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'提示',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							if(node.attributes.par=='0'){
							  //alert(node.attributes.par);
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
				title: '修改指标权重',
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