editFun = function(jxUnitDr,personDs,personGrid,personPagingToolbar){
	var rowObj = personGrid.getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ��ڲ���¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else{
		var uDs = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
		});

		uDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:'dhc.pa.jxinpersonexe.csp?action=user&str='+Ext.getCmp('UserField').getRawValue(),method:'POST'})
		});

		var UserField = new Ext.form.ComboBox({
			id: 'UserField',
			fieldLabel: '�ڲ���Ա',
			width:213,
			listWidth : 213,
			allowBlank: false,
			store: uDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'��ѡ���ڲ���Ա...',
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
							RemarkField.focus();
						}else{
							Handler = function(){UserField.focus();}
							Ext.Msg.show({title:'����',msg:'�ڲ���Ա����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var RemarkField = new Ext.form.TextField({
			id:'RemarkField',
			fieldLabel: '��Ա��ע',
			allowBlank: true,
			width:150,
			listWidth : 150,
			emptyText:'��Ա��ע...',
			anchor: '90%',
			name:'remark',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						activeField.focus();
					}
				}
			}
		});
	
		var activeField = new Ext.form.Checkbox({
			id: 'activeField',
			labelSeparator: '��Ч��־:',
			allowBlank: false,
			checked: (rowObj[0].data['active'])=='Y'?true:false,
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						editButton.focus();
					}
				}
			}
		});
		
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth:100,
			items: [
				UserField,
				RemarkField,
				activeField
			]
		});
		
		formPanel.on('afterlayout', function(panel,layout) {
			this.getForm().loadRecord(rowObj[0]);
			UserField.setValue(rowObj[0].get('userDr'));
		});	
		
		var editButton = new Ext.Toolbar.Button({
			text:'�޸�'
		});
				
		//��Ӵ�����
		var editHandler = function(){
			var userDr = Ext.getCmp('UserField').getValue();
			var remark = Ext.getCmp('RemarkField').getValue();
			var active = (activeField.getValue()==true)?'Y':'N';
			var rowid=rowObj[0].get("rowid");
			Ext.Ajax.request({
				url:'dhc.pa.jxinpersonexe.csp?action=edit&jxUnitDr='+jxUnitDr+'&remark='+remark+'&userDr='+userDr+'&active='+active+'&rowid='+rowid,
				waitMsg:'�����..',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						personDs.load({params:{start:personPagingToolbar.cursor,limit:personPagingToolbar.pageSize,jxUnitDr:jxUnitDr,dir:'asc',sort:'rowid'}});
						win.close();
					}else{
						if(jsonData.info=='RepRecode'){
							Handler = function(){UserField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'���ݼ�¼�ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
						if(jsonData.info=='rowidEmpt'){
							Handler = function(){UserField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
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
			title: '�޸��ڲ���Ա',
			width: 380,
			height:200,
			minWidth: 380,
			minHeight: 200,
			layout:'fit',
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