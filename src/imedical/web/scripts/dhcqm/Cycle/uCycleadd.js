sysorgaffiaddFun = function() {


	var uCodeField = new Ext.form.TextField({
		id: 'CodeField',
		fieldLabel: '��ȴ���',
		width:100,
		allowBlank:false,
		listWidth : 245,
		triggerAction: 'all',
		
		emptyText:'',
		name: 'CodeField',
		minChars: 1,
		pageSize: 10,
		editable:true
		
		
	});
	var uNameField = new Ext.form.TextField({
		id: 'NameField',
		fieldLabel: '�������',
		width:100,
		allowBlank:false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'NameField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
var uTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['N', '��'], ['Y', '��']]
	});
	var uisStopField = new Ext.form.ComboBox({
	    id : 'uisStopField',
		fieldLabel : '�Ƿ���Ч',
		width : 100,
		listWidth : 245,
		store : uTypeDs,
		value:'Y',
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		selectOnFocus:true,
		forceSelection : true
	});		
	/*var uTypeDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });


	uTypeDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.srmuserexe.csp'
		                     + '?action=caltypename&str='
		                     + encodeURIComponent(Ext.getCmp('uTypeField').getValue()),
		               method:'POST'
		              });
     	});
     
	var uTypeField = new Ext.form.ComboBox({
			id: 'uTypeField',
			fieldLabel: '�û�����',
			width:200,
			listWidth : 220,
			allowBlank: false,
			store: uTypeDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '',
			name: 'uTypeField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true
	});
	*/
//��ȡ��Ա����

	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [uCodeField, uNameField,uisStopField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '���',
			width : 300,
			height : 200,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '����',
				handler : function() {
					if (formPanel.form.isValid()) {
					var code = uCodeField.getValue();
					var name = uNameField.getValue();
					var Cycleactive = uisStopField.getValue();
					
					//var type = uTypeField.getValue();

					
			
					Ext.Ajax.request({
					url:'dhc.qm.uCycleexe.csp?action=add&Cyclecode='+code+'&Cyclename='+encodeURIComponent(name)+'&Cycleactive='+encodeURIComponent(Cycleactive),
					waitMsg:'������...',
					failure: function(result,request){		
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						}
						else
						{
							var message="�ظ����";
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : '�ر�',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};