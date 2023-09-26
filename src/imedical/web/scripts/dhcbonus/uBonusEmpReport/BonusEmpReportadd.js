

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
		fieldLabel: '人员名称',
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
			fieldLabel: '报表名称',
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
		    
			title : '添加',
			width : 400,
			height : 300,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '保存',
				handler : function() {
					if (formPanel.form.isValid()) {
					var BonusEmployeeID = BonusEmployeeDsField.getValue();
					
					var BonusReportID = BonusReportDSField.getValue();

					Ext.Ajax.request({
					url:'dhc.bonus.uBonusEmpReportexe.csp?action=add&BonusEmployeeID='+BonusEmployeeID+'&BonusReportID='+BonusReportID,
					waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						}
						else
						{
							var message="重复添加";
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : '取消',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
