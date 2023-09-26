//�޸ĺ���
updateSetDetailFun = function(node){
    //alert(node);
	function isNumber(val)
	{
		 return typeof val == 'number' && isFinite(val);
	}

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
				fieldLabel: 'ָ��Ȩ��',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'������ָ��Ȩ��...',
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
				text:'�޸�'
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
				  Ext.Msg.show({title:'��ʾ',msg:'�޸�Ȩ������������',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				
				Ext.Ajax.request({
					url: SchemUrl+'?action=editrate&data='+name+'&rowid='+rowid,
					waitMsg: '�޸���...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
				title: '�޸�ָ��Ȩ��',
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