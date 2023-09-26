kpischemAddFun = function() {
	var uCodeField = new Ext.form.TextField({
		id: 'uCodeField',
		fieldLabel: '���',
		anchor: '90%',
		//width:150,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uCodeField',
		minChars: 1,
		pageSize: 10,
		editable:true
		
	});
	var uNameField = new Ext.form.TextField({
		id: 'uNameField',
		fieldLabel: '����',
		anchor: '90%',
		//width:150,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uNameField',
		minChars: 1,
		pageSize: 10,
		editable:true
		
	});
	var uShortcutField = new Ext.form.TextField({
		id: 'uShortcutField',
		fieldLabel: '��д',
		anchor: '90%',
		//width:150,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uShortcutField',
		minChars: 1,
		pageSize: 10,
		editable:true
		
	});
	
	var uFrequencyField = new Ext.form.ComboBox({
			id:'uFrequencyField',
			fieldLabel: '����Ƶ��',
			anchor: '90%',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
			})			
		});
	var uDescField = new Ext.form.TextField({
		id: 'uDescField',
		fieldLabel: '����',
		anchor: '90%',
		//width:150,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uDescField',
		minChars: 1,
		pageSize: 10,
		editable:true
		
	});
	
//��ȡ��Ϣ

	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [uCodeField, uNameField, uShortcutField, uFrequencyField, uDescField]
		});
	 
	var addWin = new Ext.Window({
		    
			title : '���',
			width : 400,
			height : 220,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '����',
				handler : function() {
					var code = uCodeField.getValue();
					var name = uNameField.getValue();
					var shortcut = uShortcutField.getValue();
					var frequency = uFrequencyField.getValue();
					var desc = uDescField.getValue();
					if(code==""){
						Ext.Msg.show({title:'ע��',msg:'��ά���Բ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}
					if(name==""){
						Ext.Msg.show({title:'ע��',msg:'��ά���Բ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}
					Ext.Ajax.request({
					url:'dhc.pa.Selfmanageexe.csp?action=adddept&code='+encodeURIComponent(code)+'&name='+encodeURIComponent(name)+'&shortcut='+encodeURIComponent(shortcut)
					+'&frequency='+encodeURIComponent(frequency)+'&desc='+encodeURIComponent(desc),
					waitMsg:'������...',
					failure: function(result, request){		
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						var jsonInfo=jsonData.info;
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						}else{
							var message="";
							var infoArr=jsonInfo.split("^");
							for(var i=1,len=infoArr.length;i<len;i++){
								var info=infoArr[i];
								if(info=='isCode') message=message+"�����ظ���</br>";
								if(info=='isName') message=message+"�����ظ���</br>";
							}
						
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
						
					},
					scope: this			
				  });
				  addWin.close();
				} 
				
									
			},
			{
				text : 'ȡ��',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
