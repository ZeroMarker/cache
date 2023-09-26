
schemdeptAddFun= function(dataStore,grid,pagingTool) {

	var schemDs = new Ext.data.Store({
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});


	schemDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.pa.kpiSchemDeptexe.csp'+'?action=listSchem',method:'POST'});
	});	
	 
	var deptDs = new Ext.data.Store({
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});


	deptDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.pa.kpiSchemDeptexe.csp'+'?action=listDept',method:'POST'});
	});	
	var suserDs = new Ext.data.Store({
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','suser'])
	});


	suserDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.pa.kpiSchemDeptexe.csp'+'?action=listSuser',method:'POST'});
	});	
	/*var uCodeField = new Ext.form.TextField({
		id: 'uCodeField',
		fieldLabel: '�������',
		width:180,
		listWidth : 180,
		triggerAction: 'all',
		emptyText:'',
		name: 'uCodeField',
		minChars: 1,
		pageSize: 10,
		editable:true
		
	});*/
	var uNameField = new Ext.form.ComboBox({
		id:'uNameField',
		fieldLabel : '��Ŀ����',
		width : 185,
		listWidth : 185,
		selectOnFocus : true,
		allowBlank : false,
		store : schemDs,
		name:'uNameField',
		//valueNotFoundText : '',
		displayField: 'name',
		valueField: 'rowid',
		triggerAction : 'all',
		emptyText : '',
		editable : true,
		pageSize : 10,
		minChars : 1,
		selectOnFocus: true,
		forceSelection : true
	});
	var uJnameField = new Ext.form.ComboBox({
		id:'uJnameField',
		fieldLabel : '��ڿ���',
		width : 185,
		listWidth : 185,
		selectOnFocus : true,
		allowBlank : false,
		store : deptDs,
		name:'uJnameField',
		displayField: 'name',
		valueField: 'rowid',
		triggerAction : 'all',
		emptyText : '',
		editable : true,
		pageSize : 10,
		minChars : 1,
		selectOnFocus: true,
		forceSelection : true
	});
	var uSuserField = new Ext.form.ComboBox({
		id:'uSuserField',
		fieldLabel : '������',
		width : 185,
		listWidth : 185,
		selectOnFocus : true,
		allowBlank : false,
		store : suserDs,
		name:'uSuserField',
		displayField: 'suser',
		valueField: 'rowid',
		triggerAction : 'all',
		emptyText : '',
		editable : true,
		pageSize : 10,
		minChars : 1,
		selectOnFocus: true,
		forceSelection : true
	});
	

	
	
//��ȡ��Ϣ

	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [ uNameField,uJnameField,uSuserField]
		});
	 
	var addWin = new Ext.Window({
		    
			title : '���',
			width : 400,
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
										
					//var code = uCodeField.getValue();
					var name = uNameField.getValue();
					var jname = uJnameField.getValue();
					var suser = uSuserField.getValue();
					Ext.Ajax.request({
					url:'dhc.pa.kpiSchemdeptexe.csp?action=add&name='+encodeURIComponent(name)+'&jname='+encodeURIComponent(jname)+'&suser='+encodeURIComponent(suser),
					waitMsg:'������...',
					failure: function(result, request){		
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
						}
						else 
						{
							var message="�ظ����";
							if(jsonData.info=='RepScheme') message="�ظ���ӣ�";
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
						
					},
					scope: this			
				  });
				  //addWin.close();
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
