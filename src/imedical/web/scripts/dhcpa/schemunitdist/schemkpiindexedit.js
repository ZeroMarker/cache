//�޸ĺ���
updateSchemDetailFun = function(node){
    //alert(node);
	if(node==null){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ�޸ĵ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
	}else{
		if(node.attributes.id=="roo"){
			Ext.Msg.show({title:'��ʾ',msg:'���ڵ㲻�����޸�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}else{
			//ȡ������¼��rowid
			var rowid = node.attributes.detailid;
		
			var NameField = new Ext.form.TextField({
				id:'NameField',
				fieldLabel: 'ָ��˳��',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'��ָ������...',
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
				NameField.setValue(node.attributes.order);
			});	
			
			editButton = new Ext.Toolbar.Button({
				text:'�޸�'
			});

			editHandler = function(){
				var name = NameField.getValue();
				name = trim(name);		
				Ext.Ajax.request({
					url: SchemUrl+'?action=editorder&data='+name+'&rowid='+rowid,
					waitMsg: '�޸���...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							if(node.attributes.par=='0'){
							 Ext.getCmp('detailReport').getNodeById("roo").reload();
							}
							else{
							Ext.getCmp('detailReport').getNodeById(node.attributes.par).reload();
							}
							window.close();
						}else{
							var message = "";
							if(jsonData.info=='EmptyRecData') message='������!';
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			};
	
			editButton.addListener('click',editHandler,false);
		
			cancel = new Ext.Toolbar.Button({
				text:'�˳�'
			});
			
			cancelHandler1 = function(){
				window.close();
			}

			cancel.addListener('click',cancelHandler1,false);
			
			var window = new Ext.Window({
				title: '�޸�ָ��˳��',
				width: 420,
				height:300,
				minWidth: 420,
				minHeight: 200,
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