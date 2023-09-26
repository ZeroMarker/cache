editSchemFun = function(dataStore,grid,pagingTool) {
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("DSArowid");

		//alert(myRowid);
		var DeptDs = new Ext.data.Store({
		proxy:DeptIndexProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
				'rowid','name'
	 
			]),
		remoteSort: true
		});
		DeptDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:DeptAuditUrl+'?action=name&parent=0'});
		});

		var DeptIndex = new Ext.form.ComboBox({
					id:'DeptIndex',
					fieldLabel: '�Բ�����',
					valueField: 'rowid',
					displayField:'name',
					emptyText:'��ѡ���Բ�����...',
					triggerAction:'all',
					allowBlank: false,
					store:DeptDs,
					width:213,
			        listWidth : 213,
					minChars: 1,
					pageSize: 10,
					selectOnFocus:true,
					valueNotFoundText:rowObj[0].get("dsc_name"),
					forceSelection:'true',
					editable:true			
				});

		   var userDs = new Ext.data.Store({
			proxy:"",
			reader: new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: 'results'
			}, [
					'rowid','name'
		 
				]),
			remoteSort: true
			});
		userDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:DeptAuditUrl+'?action=user&str='+encodeURIComponent(Ext.getCmp('user')+user.getRawValue())});
		});

	var user = new Ext.form.ComboBox({
				id:'user',
				fieldLabel: '�û�����',
				valueField: 'rowid',
				displayField:'name',
				emptyText:'��ѡ���û�...',
				triggerAction:'all',
				allowBlank: false,
				valueNotFoundText:rowObj[0].get("ssusr_name"),
				store:userDs,
				width:213,
			    listWidth : 213,
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true			
			});
			
	DeptDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:DeptAuditUrl+'?action=name&str='+encodeURIComponent(Ext.getCmp('DeptIndex').getRawValue())});
		});

		// create form panel
	  var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [
				user,
				DeptIndex			
			]
		});
      formPanel.on('afterlayout', function(panel,layout) {
			this.getForm().loadRecord(rowObj[0]);
			user.setValue(rowObj[0].get("ssuser"));
			//alert(rowObj[0].get("ssuser"));
			DeptIndex.setValue(rowObj[0].get("dschemDr"));
		});	
	  // define window and show it in desktop
	  var window = new Ext.Window({
		title: '�޸��û��Բ�Ȩ��',
		width: 400,
		height:200,
		minWidth: 200,
		minHeight: 100,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '�޸�',
			handler: function() {
				// check form value
				
			var Dept = DeptIndex.getValue();
		    var userDr = user.getValue();

				if (formPanel.form.isValid()) {
							Ext.Ajax.request({
								url: DeptAuditUrl+'?action=edit&DschemDr='+Dept+'&DuserDr='+userDr+'&rowid='+myRowid,
								failure: function(result, request) {
									Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
										window.close();
									}
									else
									{
										var message = "";
										message = "SQLErr: " + jsonData.info;
										if(jsonData.info=='') message='���������Ϊ��!';
								        if(jsonData.info=='NoschemDr') message='û��ѡ�񷽰�!';
										if(jsonData.info=='NoUserDr') message='û��ѡ���û�!';
										if(jsonData.info=='reRecord') message='�û����ƺ��Բ������ظ�!';
									  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
							scope: this
							});
				}
				else{
							Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
				}
			},
			{
					text: 'ȡ��',
			handler: function(){window.close();}
		  }]
		});

		window.show();
	}
};