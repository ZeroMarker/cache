
//UPDATE



srmftpinfoconfigEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid         = rowObj[0].get("rowid");		
		var typeid 		  = rowObj[0].get("TypeDR");	
	}

var eTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '�ϴ�����'],['2', '��������'], ['3', '���м�Ч����']]
	});		
		
var eTypeCombox = new Ext.form.ComboBox({
	                   id : 'eTypeCombox',
		           fieldLabel : '��������',
	                   width : 200,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : eTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           value:typeid,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''
						  });	
//Panel�л��õ�����������������ڿ�ȶ�������extjsԴ���з�װ��������½�new:�������
	var uFtpIPFieldEdit = new Ext.form.TextField({
		id: 'uFtpIPFieldEdit',
		fieldLabel: 'IP',
		width:200,
		allowBlank: false,
		listWidth : 260,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uFtpIPFieldEdit',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uFtpUserFieldEdit = new Ext.form.TextField({
		id: 'uFtpUserFieldEdit',
		fieldLabel: '�û���',
		width:200,
		allowBlank: true,
		listWidth : 200,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uFtpUserFieldEdit',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uFtpPassWordFieldEdit = new Ext.form.TextField({
		id: 'uFtpPassWordFieldEdit',
		fieldLabel: '����',
		width:200,
		allowBlank: true,
		listWidth : 200,
		inputType: 'password',
		triggerAction: 'all',
		//emptyText:'',
		name: 'uFtpPassWordFieldEdit',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uFtpDescFieldEdit = new Ext.form.TextField({
		id: 'uFtpDescFieldEdit',
		fieldLabel: '����',
		width:200,
		allowBlank: true,
		listWidth : 260,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uFtpDescFieldEdit',
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
							columnWidth: '.8',
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
									eTypeCombox,
									uFtpIPFieldEdit,
									uFtpUserFieldEdit,
									uFtpPassWordFieldEdit,
								    uFtpDescFieldEdit
                       
								]	 
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									}
																
								]
							 }]
					}
				]
	

     
	var formPanel = new Ext.form.FormPanel({
			//baseCls : 'x-plain',
			labelWidth : 90,
			labelAlign:'right',
			frame: true,
			items: colItems
		});
				                                                                                         
    //�����أ���������Ƶ������޸�������Ƿ�������
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                           
			this.getForm().loadRecord(rowObj[0]);
			uFtpIPFieldEdit.setValue(rowObj[0].get("FtpIP"));	
			uFtpUserFieldEdit.setValue(rowObj[0].get("FtpUser"));
			uFtpPassWordFieldEdit.setValue(rowObj[0].get("FtpPassWord"));	
			uFtpDescFieldEdit.setValue(rowObj[0].get("FtpDesc"));	
            eTypeCombox.setRawValue(rowObj[0].get("Type"));				
			                                                                        
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
				var type = eTypeCombox.getValue();
				var ipedit = uFtpIPFieldEdit.getValue();
				var useredit = uFtpUserFieldEdit.getValue();
				var passwordedit = uFtpPassWordFieldEdit.getValue();
				var srcedit = uFtpDescFieldEdit.getValue();
               
                Ext.Ajax.request({
				url:'herp.srm.ftpinfoconfigexe.csp?action=edit&rowid='+rowid+'&type='+encodeURIComponent(type)+'&ftpip='+encodeURIComponent(ipedit)+'&ftpuser='+encodeURIComponent(useredit)
					+'&ftppassword='+encodeURIComponent(passwordedit)+'&ftpdesc='+encodeURIComponent(srcedit),
				
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
					//var message="�ظ����";
					//if(jsonData.info=='RepCode') message="����ظ���";
					//if(jsonData.info=='RepName') message="�����ظ���";
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
			title: '�޸�ftp��������Ϣ',
			iconCls: 'pencil',
			width : 430,
			height : 300,    
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
