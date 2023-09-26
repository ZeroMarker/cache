//修改函数
updatedetailaddFun = function(node){
    //alert(node.attributes.method);
	if(node==null){
		Ext.Msg.show({title:'提示',msg:'请选择要修改的数据!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
	}else{
		if((node.attributes.method=="扣分法")||(node.attributes.method=="加分法")){
			//取该条记录的rowid
			var rowid = node.attributes.detailid;
		
			var scoreField = new Ext.form.TextField({
				id:'scoreField',
				fieldLabel: '增减分设置',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请输入增减量...',
				anchor: '90%',
				selectOnFocus:'true'
			});
			
			var ValueField = new Ext.form.TextField({
				id:'ValueField',
				fieldLabel: '增减量设置',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请输入增减分...',
				anchor: '90%',
				selectOnFocus:'true'
			});
			
			var baseField = new Ext.form.TextField({
				id:'baseField',
				fieldLabel: '基础值设置',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请输入基础值...',
				anchor: '90%',
				selectOnFocus:'true'
			});
				
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 80,
				items: [
					scoreField,
					ValueField,
					baseField
				]
			});	
		
			formPanel.on('afterlayout', function(panel,layout) {
				this.getForm().loadRecord(node);
				scoreField.setValue(node.attributes.score);
				ValueField.setValue(node.attributes.changeValue);
				baseField.setValue(node.attributes.baseValue);
			});	
			
			editdetailsButton = new Ext.Toolbar.Button({
				text:'修改'
			});

			editHandler = function(){
				var name = scoreField.getValue();
				var changeValue = ValueField.getValue();
				var baseValue = baseField.getValue();
				var method = node.attributes.methodeCode;
				name = trim(name);	
                changeValue = trim(changeValue);
                baseValue = trim(baseValue);
				method = trim(method);
                var data = method+'^'+name+'^'+changeValue+"^"+baseValue;

				if (changeValue>=0)
				{}
				else if (changeValue<100000000000){
					
				}
				else 
				{
				    
					Ext.Msg.show({title:'提示',msg:'增减量请输入数字!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				if (name>=0){
				}
				else if (name<100000000000)
				{}
				else {
				    
				    Ext.Msg.show({title:'提示',msg:'增减分请输入数字!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				Ext.Ajax.request({
					url: SchemUrl+'?action=editaddvalue&data='+data+'&rowid='+rowid,
					waitMsg: '修改中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'提示',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							if(node.attributes.par=='0'){
							 Ext.getCmp('detailaddReport').getNodeById("roo").reload();
							}
							else{
							Ext.getCmp('detailaddReport').getNodeById(node.attributes.par).reload();
							}
							//alert("getAttention")
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
	
			editdetailsButton.addListener('click',editHandler,false);
		
			cancel = new Ext.Toolbar.Button({
				text:'退出'
			});
			
			cancelHandler1 = function(){
				window.close();
			}

			cancel.addListener('click',cancelHandler1,false);
			
			var window = new Ext.Window({
				title: '扣、加分法KPI标准制定',
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
				buttons:[editdetailsButton,cancel]
			});
			window.show();
		}else{
			//(node.attributes.method=="扣分法")||(node.attributes.method=="加分法")
			Ext.Msg.show({title:'提示',msg:'不是加、扣分法不允许被修改!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}
	}
};