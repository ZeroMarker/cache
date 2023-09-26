
SRMSystemModEditFun = function() {
	
   var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("Rowid");
		var code =rowObj[0].get("Cyclecode");
		var name =rowObj[0].get("Cyclename");
		var IsValid =rowObj[0].get("Cycleactive");

	}
	

	var CodeField = new Ext.form.TextField({
		id: 'CodeField',
		fieldLabel: '��ȴ���',
		width:100,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'CodeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var NameField = new Ext.form.TextField({
		id: 'NameField',
		fieldLabel: '�������',
		width:100,
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
	/*
	var uTypeDs = new Ext.data.Store({
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
		                     + encodeURIComponent(Ext.getCmp('uTypeField').getRawValue()),
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
	});*/
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [CodeField, NameField,uisStopField]
		});
				                                                                                            //
    //������
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                              //
			this.getForm().loadRecord(rowObj[0]);
			CodeField.setValue(rowObj[0].get("Cyclecode"));	
			NameField.setValue(rowObj[0].get("Cyclename"));
			 	
			//uTypeField.setValue(rowObj[0].get("Type"));
			var Cycleactive = rowObj[0].get("Cycleactive")
			if (Cycleactive=="��")
			{
				Cycleactive='N';
			} 
			else
			{
				Cycleactive='Y';	
			} 
			 uisStopField.setValue(Cycleactive);                                                                      //
    });   
    
	    //���岢��ʼ�������޸İ�ť
	    var editButton = new Ext.Toolbar.Button({
				text:'����'
			});                                                                                                                                            //
                    
		        //�����޸İ�ť��Ӧ����
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowId = rowObj[0].get("Rowid");          
				var code = CodeField.getValue();
				var name = NameField.getValue(); 
				//var type = uTypeField.getValue(); 
                var Cycleactive = uisStopField.getValue();
                Ext.Ajax.request({
				url:'dhc.qm.uCycleexe.csp?action=edit&rowId='+rowId+'&Cyclecode='+code
				+'&Cyclename='+encodeURIComponent(name)+'&Cycleactive='+encodeURIComponent(Cycleactive),
				
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
						var message="�Ѵ�����ͬ��¼";
						Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
			width : 300,
			height : 200,    
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
		//������ʾ
		editwin.show();
	};
