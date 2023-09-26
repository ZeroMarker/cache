

BonusEmpReportAddFun = function() {

//-----------------
var BonusEmployeeDs = new Ext.data.Store({
	      autoLoad:true,
	      proxy : "",
	      reader : new Ext.data.JsonReader({
	                 totalProperty : 'results',
	                 root : 'rows'
	              }, ['rowid','name'])
});


BonusEmployeeDs.on('beforeload', function(ds, o){

	     ds.proxy=new Ext.data.HttpProxy({
	               url: 'dhc.bonus.uBonusEmpReportexe.csp'
	                     + '?action=listEmployee&str='
	                     + encodeURIComponent(Ext.getCmp('BonusEmployeeDsField').getRawValue()),
	               method:'POST'
	              });
	});

var BonusEmployeeDsField = new Ext.form.ComboBox({
		id: 'BonusEmployeeDsField',
		fieldLabel: '��Ա����',
		width:200,
		listWidth : 220,
		allowBlank: false,
		store: BonusEmployeeDs,
		displayField: 'name',
		valueField: 'rowid',
		triggerAction: 'all',
		typeAhead : true,
		//triggerAction : 'all',
		emptyText : '',
		name: 'BonusEmployeeDsField',
		pageSize: 10,
		minChars: 1,
		forceSelection : true,
		selectOnFocus:true,
	    editable:true
});

//----------------------------------------------
	var BonusReportDS = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });


	BonusReportDS.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'dhc.bonus.uBonusEmpReportexe.csp'
		                     + '?action=listReport&str='
		                     + encodeURIComponent(Ext.getCmp('BonusReportDSField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var BonusReportDSField = new Ext.form.ComboBox({
			id: 'BonusReportDSField',
			fieldLabel: '��������',
			width:200,
			listWidth : 220,
			allowBlank: false,
			store: BonusReportDS,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			//triggerAction : 'all',
			emptyText : '',
			name: 'BonusReportDSField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true
	});


//------------------------------------------------------	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [ BonusEmployeeDsField,BonusReportDSField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '���',
			width : 400,
			height : 300,
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
					var BonusEmployeeID = BonusEmployeeDsField.getValue();
					
					var BonusReportID = BonusReportDSField.getValue();

					Ext.Ajax.request({
					url:'dhc.bonus.uBonusEmpReportexe.csp?action=add&BonusEmployeeID='+BonusEmployeeID+'&BonusReportID='+BonusReportID,
					waitMsg:'������...',
					failure: function(result, request){		
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
				text : 'ȡ��',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
