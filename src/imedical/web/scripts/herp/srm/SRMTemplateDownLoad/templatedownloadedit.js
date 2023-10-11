

srmtemplatedownloadEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid      = rowObj[0].get("rowid");
		var Year       = rowObj[0].get("Year");
		var SysNoDr    = rowObj[0].get("SysNoDr");
		var Desc       = rowObj[0].get("Desc");
		var Type       = rowObj[0].get("Type");
	}
	
	var YearDsEdit = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});


	YearDsEdit.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:projUrl+'?action=Year&str='+encodeURIComponent(Ext.getCmp('YearFieldEdit').getRawValue()),method:'POST'});
	});

	var YearFieldEdit = new Ext.form.ComboBox({
		id: 'YearFieldEdit',
		fieldLabel: '���',
		width:180,
		listWidth : 200,
		allowBlank : false, 
		store:YearDsEdit,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		anchor: '95%',
		//emptyText:'��ѡ��ʼʱ��...',
		name: 'YearFieldEdit',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	
	var SysNoDrDsEdit = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});


	SysNoDrDsEdit.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:projUrl+'?action=SysNoDr&str='+encodeURIComponent(Ext.getCmp('SysNoDrFieldEdit').getRawValue()),method:'POST'});
	});

	var SysNoDrFieldEdit = new Ext.form.ComboBox({
		id: 'SysNoDrFieldEdit',
		fieldLabel: 'ģ������ģ���',
		width:180,
		listWidth : 250,
		allowBlank : false, 
		store:SysNoDrDsEdit,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		anchor: '95%',
		//emptyText:'��ѡ��ʼʱ��...',
		name: 'SysNoDrFieldEdit',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});		
	var ueTypeField = new Ext.form.TextField({
		id: 'ueTypeField',
		fieldLabel: 'ģ������',
		width:200,
		allowBlank: false,
		value:Type,
		listWidth : 260,
		triggerAction: 'all',
		emptyText:'',
		name: 'ueTypeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var DescFieldEdit = new Ext.form.TextArea({
		id : 'DescFieldEdit',
		width : 160,
		height : 90,
		anchor: '95%',
		fieldLabel : 'ģ��˵��',
		allowBlank :true,
		selectOnFocus:'true',
		emptyText : '����дģ��˵������'
	});
	
	
	
	
		var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.9',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									},
								  // RecordTypeField,
                   YearFieldEdit, 
                   SysNoDrFieldEdit,
				   ueTypeField,
                   DescFieldEdit 
								]	 
							}
						]
					}
				]
	

     
	var formPanel = new Ext.form.FormPanel({
			//baseCls : 'x-plain',
			labelWidth : 90,
			frame: true,
			items: colItems
		});
				                                                                                         
    //�����أ���������Ƶ������޸�������Ƿ�������
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                           
			this.getForm().loadRecord(rowObj[0]);
			YearFieldEdit.setValue(rowObj[0].get("YearDr"));	
			YearFieldEdit.setRawValue(rowObj[0].get("Year"));
			SysNoDrFieldEdit.setValue(rowObj[0].get("SysNoDr"));
			SysNoDrFieldEdit.setRawValue(rowObj[0].get("SysNo"));
			
			DescFieldEdit.setValue(rowObj[0].get("Desc"));	
			ueTypeField.setValue(rowObj[0].get("Type"));	
			                                                                        
    });   
    	
	    //���岢��ʼ�������޸İ�ť
	    var editButton = new Ext.Toolbar.Button({
				text:'����'
			});                                                                                                                                            //
                    
		        //�����޸İ�ť��Ӧ����
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid       = rowObj[0].get("rowid");          
				var yearedit    = YearFieldEdit.getValue();
				var sysnodredit = SysNoDrFieldEdit.getValue();
				var descedit    = DescFieldEdit.getValue();
				var type    = ueTypeField.getValue();
				
				var Yearedit = rowObj[0].get("Year");     
				var SysNoDredit = rowObj[0].get("SysNoDr");     
				var Type    = ueTypeField.getValue();
				
				/* if(Yearedit==yearedit){yearedit="";}
				if(SysNoDredit==sysnodredit){sysnodredit="";}
				if(SysNoDredit==sysnodredit){sysnodredit="";}	 */
				
				if(yearedit==""){
					Ext.Msg.show({title:'����',msg:'���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
				if(type==""){
					Ext.Msg.show({title:'����',msg:'ģ������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
               
                Ext.Ajax.request({
				url:'herp.srm.templatedownloadexe.csp?action=edit&rowid='+rowid+'&year='+encodeURIComponent(yearedit)
					+'&sysnodr='+encodeURIComponent(sysnodredit)+'&desc='+encodeURIComponent(descedit)+'&type='+encodeURIComponent(type),
				
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					itemGridDs.load({params:{start:0, limit:25}});		
				}
				else
					{
					var message="�ظ����";
					/*
					if(jsonData.info=='RepCode') message="����ظ���";
					if(jsonData.info=='RepName') message="�����ظ���";
					*/
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
			width : 400,
			height : 350,    
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
