//�޸ĺ���
addSchemDetailFun = function(node){
    //alert(node);
	if(node==null){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ���ָ��ķ���!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
	}else{
		
			var KPIIndexCombo = new Ext.ux.form.LovCombo({
				id:'KPIIndexCombo',
				fieldLabel: 'KPIָ��',
				hideOnSelect: false,
				store: new Ext.data.Store({
					autoLoad: true,
					proxy: new Ext.data.HttpProxy({url:SchemUrl+'?action=kpi&start=0&limit=25&schem='+node}),
					reader: new Ext.data.JsonReader({
						root: 'rows',
						totalProperty: 'results',
						id: 'rowid'
					},[
						'rowid','name','shortcut'
					])
				},[
					'rowid','name','shortcut'
				]),
				valueField:'rowid',
				displayField:'name',
				typeAhead: false,
				triggerAction: 'all',
				pageSize:10,
				listWidth:250,
				allowBlank: false,
				emptyText:'ѡ��KPIָ��...',
				editable:false,
				//allowBlank: false,
				anchor: '90%'
			});
				
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 60,
				items: [
					KPIIndexCombo
				]
			});	
			
			addButton = new Ext.Toolbar.Button({
				text:'����'
			});

			editHandler = function(){
				var name = KPIIndexCombo.getValue();
				name = trim(name);
                var data = node+'^'+name;
                data = trim(data);
                //alert(data);				
				Ext.Ajax.request({
					url: SchemUrl+'?action=addkpi&data='+data,
					waitMsg: '������...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'��ʾ',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							Ext.getCmp('detailReport').getNodeById("roo").reload();
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
	
			addButton.addListener('click',editHandler,false);
		
			cancel = new Ext.Toolbar.Button({
				text:'�˳�'
			});
			
			cancelHandler1 = function(){
				window.close();
			}

			cancel.addListener('click',cancelHandler1,false);
			
			var window = new Ext.Window({
				title: 'ѡ��ָ��',
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
				buttons:[addButton,cancel]
			});
			window.show();
		
	}
};