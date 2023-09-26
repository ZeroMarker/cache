schemdeptEditFun = function(itemGridDs,itemGrid,itemGridPagingToolbar) {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
    
	var len = rowObj.length;
	
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else if(len>1){
		Ext.Msg.show({title:'����',msg:'ֻ���޸ĵ�����¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
		
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
	
	var uNameField = new Ext.form.ComboBox({
		id:'uNameField',
		fieldLabel : '��Ŀ����',
		width : 185,
		listWidth : 185,
		selectOnFocus : true,
		allowBlank : false,
		store : schemDs,
		name:'uNameField',
		valueNotFoundText :rowObj[0].get("name"),
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
		valueNotFoundText :rowObj[0].get("jname"),
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
		valueNotFoundText :rowObj[0].get("userName"),
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
	 
				                                                                                            
    //������
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                              
			this.getForm().loadRecord(rowObj[0]);
			
			uNameField.setValue(rowObj[0].get("schemDr"));	
			uJnameField.setValue(rowObj[0].get("jxunitDr"));
			uSuserField.setValue(rowObj[0].get("userDr"));
			//uDescField.setValue(rowObj[0].get("desc"));
			
			                   
    });   
    
	    //���岢��ʼ�������޸İ�ť
	    var editButton = new Ext.Toolbar.Button({
				text:'����'
			});                                                                                                                                            
                    
		        //�����޸İ�ť��Ӧ����
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");   
		               
				
				var schemDr = uNameField.getValue(); 
				var jxunitDr = uJnameField.getValue();
				var userDr = uSuserField.getValue();
				
				var data=schemDr+"^"+jxunitDr+"^"+userDr;
                Ext.Ajax.request({
				url:'dhc.pa.kpiSchemDeptexe.csp?action=save&rowid='+rowid+'&data='+data,				
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});		
				}
				else
					{
						Ext.Msg.show({title:'����',msg:'�޸�ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				
					//var message="�ظ����";
					//if(jsonData.info=='RepCode') message="�����ظ���";
					//if(jsonData.info=='RepName') message="�����ظ���";
					//Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				};
			},
				scope: this
			});
			editwin.close();
		};
		//��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click',editHandler,false);
	
		//���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
	
		//����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			editwin.close();
		};
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//���岢��ʼ������
		var editwin = new Ext.Window({
			title: '�޸ļ�¼',
			width : 400,
			height : 200,    
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items:formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
		//������ʾ
		editwin.show();
	}
	

	
	};
