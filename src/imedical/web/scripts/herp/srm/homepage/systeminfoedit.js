

SystemInfoEditFun = function() {
	
    var rowObj=SystemMessageGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
		var title =rowObj[0].get("title");
		var message =rowObj[0].get("message");
		var IsAttachment =rowObj[0].get("IsAttachment");
	}
	

	var eTextField = new Ext.form.TextField({
		id: 'eTextField',
		fieldLabel: '��Ŀ',
		width:200,
		allowBlank: false,
		listWidth : 260,
		triggerAction: 'all',
		emptyText:'',
		name: 'eTextField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var eMessageField = new Ext.form.TextArea({
		id: 'eMessageField',
		fieldLabel: '����',
		width:200,
		allowBlank: false,
		//listWidth : 260,
		triggerAction: 'all',
		name: 'eMessageField',
		grow: true,
        growMin:60,//��ʾ�ĸ߶�
        growMax:100//������ʾ�߶�
	});
	
/////////////////////�Ƿ��и���/////////////////////////////
var eIsAttachmentField = new Ext.form.Checkbox({
                        id:'eIsAttachmentField',
						name:'eIsAttachmentField',
						fieldLabel : '�Ƿ��и���',
						renderer : function(v, p, record){
        	               p.css += ' x-grid3-check-col-td'; 
        	               return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
	});
	
	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 50,
			frame: true,
			//items: colItems
			items : [eTextField,eMessageField,eIsAttachmentField]
		});
				                                                                                            //
    //������
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                              //
			this.getForm().loadRecord(rowObj[0]);	
			eTextField.setValue(rowObj[0].get("title"));
			eMessageField.setValue(rowObj[0].get("message"));
			if(rowObj[0].get("IsAttachment")=="1"){eIsAttachmentField.setValue(true);}
    });   
    
	    //���岢��ʼ�������޸İ�ť
	    var editButton = new Ext.Toolbar.Button({
				text:'����'
			});                                                                                                                                            //
                    
		        //�����޸İ�ť��Ӧ����
			    editHandler = function(){
		
		        var rowObj=SystemMessageGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");     

				var esysteminfotitle = eTextField.getValue();
				var esysteminfomessage = eMessageField.getValue();
				
				var eIsValid = "";
			    if (Ext.getCmp('eIsAttachmentField').checked) {eIsValid="1";}
			    else { eIsValid="0";}
				
				
				var etitle = rowObj[0].get("title");     
				var emessage = rowObj[0].get("message");     
				var isvalid = rowObj[0].get("IsAttachment"); 
				
				if(esysteminfotitle==etitle){esysteminfotitle="";}
				if(esysteminfomessage==emessage){message="";}
				if(isvalid==eIsValid){eIsValid="";}
				
			  // var data=rowid+"^"+code+"^"+name+"^"+type+"^"+sex+"^"+birthday+"^"+idnum+"^"+titledr+"^"+phone+"^"+email+"^"+degree+"^"+compdr+"^"+monographnum+"^"+papernum+"^"+patentnum+"^"+invincustomstanNum+"^"+trainnum+"^"+holdtrainnum+"^"+intrainingnum
           
                Ext.Ajax.request({
				url:HomePageUrl+'?action=edit&rowid='+rowid+'&title='+encodeURIComponent(esysteminfotitle)
					+'&message='+encodeURIComponent(esysteminfomessage)+'&subuser='+subuser+'&IsAttachment='+encodeURIComponent(eIsValid),
				
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					SystemMessageDs.load({params:{start:0, limit:10}});		
				}
				else
					{
					var message="�ظ����";
					if(jsonData.info=='RepCode') message="����ظ���";
					if(jsonData.info=='RepName') message="�����ظ���";
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
			title: '�޸�ϵͳ��Ϣ',
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
