//修改函数
addSchemDetailFun = function(node){
    //alert(node);
	if(node==null){
		Ext.Msg.show({title:'提示',msg:'请选择要添加指标的方案!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
	}else{
		
			var KPIIndexCombo = new Ext.ux.form.LovCombo({
				id:'KPIIndexCombo',
				fieldLabel: 'KPI指标',
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
				emptyText:'选择KPI指标...',
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
				text:'保存'
			});

			editHandler = function(){
				var name = KPIIndexCombo.getValue();
				name = trim(name);
                var data = node+'^'+name;
                data = trim(data);
                //alert(data);				
				Ext.Ajax.request({
					url: SchemUrl+'?action=addkpi&data='+data,
					waitMsg: '保存中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'提示',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							Ext.getCmp('detailReport').getNodeById("roo").reload();
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
	
			addButton.addListener('click',editHandler,false);
		
			cancel = new Ext.Toolbar.Button({
				text:'退出'
			});
			
			cancelHandler1 = function(){
				window.close();
			}

			cancel.addListener('click',cancelHandler1,false);
			
			var window = new Ext.Window({
				title: '选择指标',
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