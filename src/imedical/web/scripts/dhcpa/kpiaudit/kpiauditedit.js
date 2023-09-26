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
		myRowid = rowObj[0].get("rowid");
	
	
		var KPIDs = new Ext.data.Store({
		proxy:KPIIndexProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
				'rowid','name'
	 
			]),
		remoteSort: true
		});
		KPIDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:KPIAuditUrl+'?action=kpi&parent=0'});
		});

		var KPIIndex = new Ext.form.ComboBox({
					id:'KPIIndex',
					fieldLabel: 'KPIָ��',
					valueField: 'rowid',
					displayField:'name',
					emptyText:'��ѡ��ָ��...',
					triggerAction:'all',
					allowBlank: false,
					store:KPIDs,
					width:213,
			        listWidth : 213,
					minChars: 1,
					pageSize: 10,
					selectOnFocus:true,
					valueNotFoundText:rowObj[0].get("KPIName"),
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
				url:KPIAuditUrl+'?action=user&name='+user.getRawValue()});
		});

	var user = new Ext.form.ComboBox({
				id:'user',
				fieldLabel: '�û�',
				valueField: 'rowid',
				displayField:'name',
				emptyText:'��ѡ���û�...',
				triggerAction:'all',
				allowBlank: false,
				valueNotFoundText:rowObj[0].get("UserName"),
				store:userDs,
				width:213,
			    listWidth : 213,
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true			
			});
			
	 KPIDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:KPIAuditUrl+'?action=kpi&userCode='+Ext.getCmp('user').getValue()+"&str="+encodeURIComponent(Ext.getCmp('KPIIndex').getRawValue())});
		});
	user.on("select",function(cmb,rec,id){

        var userID=Ext.getCmp('user').getValue();
		KPIDs.proxy=new Ext.data.HttpProxy({url:KPIAuditUrl+'?action=kpi&userCode='+userID+"&str="+encodeURIComponent(Ext.getCmp('KPIIndex').getRawValue())});
		KPIDs.load({params:{str:userID}});
});
		// create form panel
	  var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [
				user,
				KPIIndex			
			]
		});
      formPanel.on('afterlayout', function(panel,layout) {
			this.getForm().loadRecord(rowObj[0]);
			user.setValue(rowObj[0].get("UserDr"));
			KPIIndex.setValue(rowObj[0].get("KPIDr"));
		});	
	  // define window and show it in desktop
	  var window = new Ext.Window({
		title: '�޸��û�KPIȨ��',
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
				
				var KPI = Ext.getCmp('KPIIndex').getValue();
				var userDr = Ext.getCmp('user').getValue();
				
				KPI = KPI.trim();
				userDr = userDr.trim();
				
				var data = KPI+'^'+userDr;

				if (formPanel.form.isValid()) {
							Ext.Ajax.request({
								url: KPIAuditUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
										if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
										if(jsonData.info=='RepKPI') message='KPI�ظ�!';
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