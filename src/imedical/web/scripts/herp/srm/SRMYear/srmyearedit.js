
//UPDATE



srmyearnewEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid         = rowObj[0].get("rowid");
		var Code          = rowObj[0].get("Code");
		var Name          = rowObj[0].get("Name");
		var StrDate       = rowObj[0].get("StrDate");
		var EndDate       = rowObj[0].get("EndDate");		
	}
	
//Panel�л��õ�����������������ڿ�ȶ�������extjsԴ���з�װ��������½�new:�������
	var uCodeFieldEdit = new Ext.form.TextField({
		id: 'uCodeFieldEdit',
		fieldLabel: '��ȱ���',
		width:200,
		//allowBlank: false,
		listWidth : 260,
		//regex:/[0-9]/,
		//regexText:"��ȱ���ֻ��Ϊ����",
		triggerAction: 'all',
		emptyText:'',
		name: 'uCodeFieldEdit',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uNameFieldEdit = new Ext.form.TextField({
		id: 'uNameFieldEdit',
		fieldLabel: '�������',
		width:200,
		allowBlank: true,
		listWidth : 200,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uNameFieldEdit',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});

	var uStrDateFieldEdit = new Ext.form.DateField({
		id: 'uStrDateFieldEdit',
		fieldLabel: '��ʼ����',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uStrDateFieldEdit',
		//format:"Y-m-d",
		//value:"Y-m-d",
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	
	var uEndDateFieldEdit = new Ext.form.DateField({
		id: 'uEndDateFieldEdit',
		fieldLabel: '��������',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uEndDateFieldEdit',
		//format:"Y-m-d",
		//value:"Y-m-d",
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});	
	
	
		var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '1',
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
									uCodeFieldEdit,
									uNameFieldEdit,
									uStrDateFieldEdit,
								    uEndDateFieldEdit
                       
								]	 
							}]
					}
				]
	

     
	var formPanel = new Ext.form.FormPanel({
			//baseCls : 'x-plain',
			labelWidth : 100,
			frame: true,
			items: colItems
		});
				                                                                                         
    //�����أ���������Ƶ������޸�������Ƿ�������
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                           
			this.getForm().loadRecord(rowObj[0]);
			uCodeFieldEdit.setValue(rowObj[0].get("Code"));	
			uNameFieldEdit.setValue(rowObj[0].get("Name"));
			uStrDateFieldEdit.setValue(rowObj[0].get("StrDate"));	
			uEndDateFieldEdit.setValue(rowObj[0].get("EndDate"));		
			                                                                        
    });   
    	
	    //���岢��ʼ�������޸İ�ť
	    var editButton = new Ext.Toolbar.Button({
				text:'����',
				iconCls: 'save'
			});                                                                                                                                            //
                    
		        //�����޸İ�ť��Ӧ����
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");          
				var codeedit = uCodeFieldEdit.getValue();
				var nameedit = uNameFieldEdit.getValue();
				var strdataedit = uStrDateFieldEdit.getRawValue();
				var enddataedit = uEndDateFieldEdit.getRawValue();

				    if (strdataedit!=="")
				    {
					 //strdataedit=strdataedit.format ('Y-m-d');
				    }

				    if (enddataedit!=="")
				    {
					 //enddataedit=enddataedit.format ('Y-m-d');
				    }

				if(codeedit=="")
				{
					Ext.Msg.show({title:'����',msg:'��ȱ��벻��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				};
					
				if(codeedit!=""){
					if (!/[0-9]/.test(codeedit)){Ext.Msg.show({title:'����',msg:'��ȱ���ֻ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
				};
					
				if(codeedit!=""){
					if (!/^\d{0,4}$/.test(codeedit)){Ext.Msg.show({title:'����',msg:'��ȱ���ֻ������λ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
				};
				
				if(nameedit=="")
				{
					Ext.Msg.show({title:'����',msg:'������Ʋ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				};
					
                Ext.Ajax.request({
				url:'herp.srm.yearexe.csp?action=edit&rowid='+rowid+'&Code='+encodeURIComponent(codeedit)
					+'&Name='+encodeURIComponent(nameedit)+'&StrDate='+encodeURIComponent(strdataedit)+'&EndDate='+encodeURIComponent(enddataedit),
				
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
					if(jsonData.info=='RepCode') message="��ȱ���ظ���";
					if(jsonData.info=='RepName') message="��������ظ���";
					if(jsonData.info=='RepDate') message="����Ŀ�ʼʱ�䲻�ܴ��ڽ���ʱ�䣡";
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
			text:'�ر�',
			iconCls : 'cancel'
		});
	
		//����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			editwin.close();
		};
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//���岢��ʼ������
		var editwin = new Ext.Window({
			title: '�޸������Ϣ',
			iconCls : 'pencil',
			width : 380,
			height : 230,    
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
