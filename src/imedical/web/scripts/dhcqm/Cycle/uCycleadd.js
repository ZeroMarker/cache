sysorgaffiaddFun = function() {


	var uCodeField = new Ext.form.TextField({
		id: 'CodeField',
		fieldLabel: '年度代码',
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
		fieldLabel: '年度名称',
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
		data : [['N', '否'], ['Y', '是']]
	});
	var uisStopField = new Ext.form.ComboBox({
	    id : 'uisStopField',
		fieldLabel : '是否有效',
		width : 100,
		listWidth : 245,
		store : uTypeDs,
		value:'Y',
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
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
			fieldLabel: '用户类型',
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
//获取人员姓名

	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [uCodeField, uNameField,uisStopField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '添加',
			width : 300,
			height : 200,
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
					var code = uCodeField.getValue();
					var name = uNameField.getValue();
					var Cycleactive = uisStopField.getValue();
					
					//var type = uTypeField.getValue();

					
			
					Ext.Ajax.request({
					url:'dhc.qm.uCycleexe.csp?action=add&Cyclecode='+code+'&Cyclename='+encodeURIComponent(name)+'&Cycleactive='+encodeURIComponent(Cycleactive),
					waitMsg:'保存中...',
					failure: function(result,request){		
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
				text : '关闭',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};