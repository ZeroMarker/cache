editFun = function(ds,grid,pagingToolbar){
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵĿ��˷�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else{
		
		var JXUnitDs = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitShortCut'])
		});
       /*
		JXUnitDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:'dhc.pa.jxunitauditexe.csp?action=jxunit&str='+Ext.getCmp('JXUnit').getRawValue(),method:'POST'})
		});
        */
		var JXUnit = new Ext.form.ComboBox({
			id:'JXUnit',
			fieldLabel:'��Ч��Ԫ',
			width:213,
			listWidth : 213,
			allowBlank:true,
			store:JXUnitDs,
			valueField:'jxUnitDr',
			displayField:'jxUnitShortCut',
			emptyText:'��ѡ��Ч��Ԫ...',
			triggerAction:'all',
			name: 'JXUnit',
			emptyText:'',
			minChars:1,
			pageSize:10,
			selectOnFocus:true,
			forceSelection:'true',
			valueNotFoundText:rowObj[0].get("jxUnitName"),
			editable:true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(JXUnit.getValue()!=""){
							UserField.focus();
						}else{
							Handler = function(){JXUnit.focus();}
							Ext.Msg.show({title:'����',msg:'��Ч��Ԫ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var UserDs = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
		});

		UserDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:'../csp/dhc.pa.jxunitauditexe.csp?action=user&str='+encodeURIComponent(Ext.getCmp('UserField').getRawValue()),method:'POST'})
		});

		var UserField = new Ext.form.ComboBox({
			id: 'UserField',
			fieldLabel: 'Ȩ���û�',
			width:213,
			listWidth : 213,
			allowBlank: false,
			store: UserDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'��ѡ��Ȩ���û�...',
			name: 'UserField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			valueNotFoundText:rowObj[0].get("userName"),
			editable:true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(UserField.getValue()!=""){
							IsReadField.focus();
						}else{
							Handler = function(){UserField.focus();}
							Ext.Msg.show({title:'����',msg:'Ȩ���û�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var IsReadField = new Ext.form.Checkbox({
			id: 'IsReadField',
			labelSeparator:'��Ȩ��',
			allowBlank: false,
			checked:(rowObj[0].get("isRead"))=='Y'?true:false,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						IsWriteField.focus();
					}
				}
			}
		});
				
		var IsWriteField = new Ext.form.Checkbox({
			id: 'IsWriteField',
			labelSeparator:'дȨ��',
			allowBlank: false,
			checked:(rowObj[0].get("isWrite"))=='Y'?true:false,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						editButton.focus();
					}
				}
			}
		});
		
		JXUnitDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:'dhc.pa.jxunitauditexe.csp?action=jxunit&str='+encodeURIComponent(Ext.getCmp('JXUnit').getRawValue())+"&userId="+Ext.getCmp('UserField').getValue(),method:'POST'})
	});
	UserField.on("select",function(cmb,rec,id ){
				JXUnitDs.proxy = new Ext.data.HttpProxy({
					url:'dhc.pa.jxunitauditexe.csp?action=jxunit&str='+encodeURIComponent(Ext.getCmp('JXUnit').getRawValue())+"&userId="+Ext.getCmp('UserField').getValue(),method:'POST'})
				JXUnitDs.load({params:{userId:Ext.getCmp('UserField').getValue()}});
			});
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 70,
			items: [
				
				UserField,
				JXUnit,
				IsReadField,
				IsWriteField
			]
		});	
		
		formPanel.on('afterlayout', function(panel,layout) {
			this.getForm().loadRecord(rowObj[0]);
			UserField.setValue(rowObj[0].get("userDr"));
			JXUnit.setValue(rowObj[0].get("jxUnitDr"));
		});	
		
		editButton = new Ext.Toolbar.Button({
				text:'�޸�'
		});

		editHandler = function(){
			var jxunitdr = Ext.getCmp('JXUnit').getValue();
			var userdr = Ext.getCmp('UserField').getValue();
			var isRead = (IsReadField.getValue()==true)?'Y':'N';
			var isWrite = (IsWriteField.getValue()==true)?'Y':'N';
			userdr = trim(userdr);
			if(userdr==""){
				Ext.Msg.show({title:'��ʾ',msg:'Ȩ���û�Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			jxunitdr = trim(jxunitdr);
			if(jxunitdr==""){
				Ext.Msg.show({title:'��ʾ',msg:'��Ч��ԪΪ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			
			var data = jxunitdr+"^"+userdr+"^"+isRead+"^"+isWrite;
			Ext.Ajax.request({
				url: '../csp/dhc.pa.jxunitauditexe.csp?action=edit&data='+data+'&rowid='+rowObj[0].get("rowid"),
				waitMsg: '�޸���...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						ds.load({params:{start:pagingToolbar.cursor, limit:pagingToolbar.pageSize,jxunitdr:jxunitdr,dir:'asc',sort:'rowid'}});
						window.close();
					}else{
						var message = "";
						if(jsonData.info=='RepRecode') message='Ȩ���û����ݼ�¼�ظ�!';
						if(jsonData.info=='dataEmpt') message='������!';
						if(jsonData.info=='rowidEmpt') message='��������!';
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
			title: '�޸ļ�Ч��ԪȨ���û�',
			width: 350,
			height:200,
			minWidth: 350,
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