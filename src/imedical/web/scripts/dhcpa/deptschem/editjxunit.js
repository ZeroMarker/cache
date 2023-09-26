editJXUnitFun = function(schemGrid,jxUnitDs,jxUnitGrid,pagingToolbar){
	var rowObj = jxUnitGrid.getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵĻ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else{
		var userCode = session['LOGON.USERCODE'];
	
		var UnitDs = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitCode','jxUnitName','jxLocTypeName'])
		});

		UnitDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:'../csp/dhc.pa.deptschemexe.csp?action=jxunit&userCode='+userCode+'&str='+Ext.getCmp('UnitField').getRawValue(),method:'POST'})
		});

		var UnitField = new Ext.form.ComboBox({
			id: 'UnitField',
			fieldLabel: '��Ч��Ԫ',
			width:230,
			listWidth : 230,
			allowBlank: false,
			store: UnitDs,
			valueField: 'jxUnitDr',
			displayField: 'jxUnitName',
			triggerAction: 'all',
			emptyText:'��ѡ��Ч��Ԫ...',
			valueNotFoundText:rowObj[0].get("parRefName"),
			name: 'UnitField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true
		});
		//UnitDs.load({params:{start:0, limit:UnitField.pageSize}});
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth:60,
			items: [
				UnitField
			]
		});
		
		formPanel.on('afterlayout', function(panel,layout) {
			this.getForm().loadRecord(rowObj[0]);
			UnitField.setValue(rowObj[0].get("parRef"));
			
		});	
		
		var editButton = new Ext.Toolbar.Button({
			text:'�޸�'
		});
				
		//��Ӵ�����
		var editHandler = function(){
			var jxunitdr = Ext.getCmp('UnitField').getValue();
			jxunitdr = trim(jxunitdr);
			if(jxunitdr==""){
				Ext.Msg.show({title:'��ʾ',msg:'��Ч��ԪΪ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			var schemDr=schemGrid.getSelections()[0].get("rowid");
			schemDr = trim(schemDr);
			if(schemDr==""){
				Ext.Msg.show({title:'��ʾ',msg:'��Ч����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			Ext.Ajax.request({
				url:'../csp/dhc.pa.deptschemexe.csp?action=edit&schemDr='+schemDr+'&jxunitdr='+jxunitdr+'&rowid='+rowObj[0].get("rowid"),
				waitMsg:'�޸���..',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						jxUnitDs.load({params:{start:pagingToolbar.cursor, limit:pagingToolbar.pageSize,schemDr:schemGrid.getSelections()[0].get("rowid"),dir:'asc',sort:'rowid'}});
						win.close();
					}else{
						var message = "";
						message = "SQLErr: " + jsonData.info;
						if(jsonData.info=='RepRecode'){
							Handler = function(){UnitField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'���ݼ�¼�ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
						if(jsonData.info=='rowidEmpt'){
							Handler = function(){UnitField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'��������,����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
						
							Ext.Msg.show({title:'����',msg:'�޸�ʧ��!',icon:Ext.MessageBox.ERROR,buttons:Ext.Msg.OK,msg:message});
					
						
					}
				},
				scope: this
			});
		}

		//��Ӱ�ť����Ӧ�¼�
		editButton.addListener('click',editHandler,false);

		//����ȡ����ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});

		//ȡ��������
		var cancelHandler = function(){
			win.close();
		}

		//ȡ����ť����Ӧ�¼�
		cancelButton.addListener('click',cancelHandler,false);

		var win = new Ext.Window({
			title: '�޸ļ�Ч��Ԫ',
			width: 380,
			height:120,
			minWidth: 380,
			minHeight: 120,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
		win.show();	
	}
}