var userid = session['LOGON.USERID'];



//��Ӱ�ť
var addButtons = new Ext.Toolbar.Button({
    text: '���',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){
               var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
	        var rowid     = rowObj[0].get("rowid");
		var cField = new Ext.form.TextField({
			id:'cField',
			fieldLabel: '�����Ŀ����',
			allowBlank: false,
			width:100,
			listWidth : 100,
			emptyText:'�����Ŀ����...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(cField.getValue()!==""){
							nField.focus();
						}else{
							Handler = function(){cField.focus();};
							Ext.Msg.show({title:'����',msg:'��Ų���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var nField = new Ext.form.TextField({
			id:'nField',
			fieldLabel: '�����Ŀ����',
			allowBlank: false,
			width:100,
			listWidth : 180,
			emptyText:'�����Ŀ����...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(nField.getValue()!==""){
							aField.focus();
						}else{
							Handler = function(){nField.focus();};
							Ext.Msg.show({title:'����',msg:'���Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		

	var direct = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [[1,'��'],[0,'��']]
	});
	var aField = new Ext.form.ComboBox({
		id: 'aField',
		fieldLabel: '�Ƿ���Ч',
		//listWidth : 130,
		selectOnFocus: true,
		allowBlank: false,
		store: direct ,
		anchor: '90%',
		value:1, //Ĭ��ֵ
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'ϵͳ...',
		mode: 'local', //����ģʽ
		editable:false,
		selectOnFocus: true,
		forceSelection: true,
		listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
	});

		//��ʼ�����
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 150,
			items: [
				cField,
				nField,
				aField
			]
		});
		
		//��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
			text:'�� ��'
		});
		
		//������Ӱ�ť��Ӧ����
		addHandler = function(){
            //alert("wwww")
                         
			var code = cField.getValue();
			var name = nField.getValue();
		        var IsValid = aField.getValue();
                  
			if(code==""){
				Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(name==""){
				Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
                        /*
			if(IsValid==""){
				Ext.Msg.show({title:'����',msg:'�Ƿ���ЧΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
                         */
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.acct.acctsubjvindicdetail.csp?action=add&code='+code+'&name='+name+'&rowid='+rowid+'&userid='+userid+'&IsValid='+IsValid),
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){aField.focus();};
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){aField.focus();};
						Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						detailGrid.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
					}
					else
							{
								var message="";

								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
				},
				scope: this
			});
			addwin.close();
		};
	
		//��ӱ��水ť�ļ����¼�
		addButton.addListener('click',addHandler,false);
	
		//��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
	
		//����ȡ����ť����Ӧ����
		cancelHandler = function(){
			addwin.close();
		};
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//��ʼ������
		addwin = new Ext.Window({
			title: '��Ӽ�¼',
			width: 400,
			height:200,
			minWidth: 400, 
			minHeight: 200,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});
	
		//������ʾ
		addwin.show();

      
	}	
});



//�޸İ�ť
var editButtons = new Ext.Toolbar.Button({
  text: '�޸�',
    tooltip:'�޸�',        
    iconCls:'add',
	handler:function(){
               var rowObj=detailGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
		   Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		   return;
		}
                else
               {
                   var rowid     = rowObj[0].get("rowid");
                   var CheckCode = rowObj[0].get("CheckTypeCode");
                   var CheckName = rowObj[0].get("CheckTypeName");
                }
	      
		var cField = new Ext.form.TextField({
			id:'cField',
			fieldLabel: '�����Ŀ����',
			allowBlank: false,
			width:100,
                        value:CheckCode,
			listWidth : 100,
			emptyText:'�����Ŀ����...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(cField.getValue()!==""){
							nField.focus();
						}else{
							Handler = function(){cField.focus();};
							Ext.Msg.show({title:'����',msg:'��Ų���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var nField = new Ext.form.TextField({
			id:'nField',
			fieldLabel: '�����Ŀ����',
			allowBlank: false,
			width:100,
                        value:CheckName,
			listWidth : 180,
			emptyText:'�����Ŀ����...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(nField.getValue()!==""){
							aField.focus();
						}else{
							Handler = function(){nField.focus();};
							Ext.Msg.show({title:'����',msg:'���Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		

	var direct = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [[1,'��'],[0,'��']]
	});
	var aField = new Ext.form.ComboBox({
		id: 'aField',
		fieldLabel: '�Ƿ���Ч',
		//listWidth : 130,
		selectOnFocus: true,
		allowBlank: false,
		store: direct ,
		anchor: '90%',
		value:1, //Ĭ��ֵ
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'ϵͳ...',
		mode: 'local', //����ģʽ
		editable:false,
		selectOnFocus: true,
		forceSelection: true,
		listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
	});

		//��ʼ�����
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 150,
			items: [
				cField,
				nField,
				aField
			]
		});
		
		//��ʼ���޸İ�ť
		addButton = new Ext.Toolbar.Button({
			text:'�޸�'
		});
		
		//�����޸İ�ť��Ӧ����
		addHandler = function(){
                        
			var code = cField.getValue();
			var name = nField.getValue();
			var IsValid = aField.getValue();

			if(code==""){
				Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(name==""){
				Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}

			Ext.Ajax.request({
				url: encodeURI('../csp/herp.acct.acctsubjvindicdetail.csp?action=edit&code='+code+'&name='+name+'&rowid='+rowid+'&userid='+userid+'&IsValid='+IsValid),
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){aField.focus();};
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){aField.focus();};
						Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						detailGrid.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
					}
					else
					{
					 var message="";
                                         Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			});
			addwin.close();
		};
	
		//��ӱ��水ť�ļ����¼�
		addButton.addListener('click',addHandler,false);
	
		//��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
	
		//����ȡ����ť����Ӧ����
		cancelHandler = function(){
			addwin.close();
		};
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//��ʼ������
		addwin = new Ext.Window({
			title: '��Ӽ�¼',
			width: 400,
			height:200,
			minWidth: 400, 
			minHeight: 200,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});
	
		//������ʾ
		addwin.show();

      
	}	

});




///ɾ����ť
var delButtons = new Ext.Toolbar.Button({
	text: 'ɾ��',
   // tooltip:'ɾ��',       
    id:'delButton', 
    iconCls:'remove',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj       = itemGrid.getSelectionModel().getSelections();
		var detailrowObj = detailGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = detailrowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
                        var detailrowid = detailrowObj[0].get("rowid");
		}
		function handler(id){
			if(id=="yes"){
			
				  Ext.each(detailrowObj, function(record) {
				  if (Ext.isEmpty(record.get("rowid"))) {
				  detailGrid.getStore().remove(record);
				  return;}
					Ext.Ajax.request({
						url:'herp.acct.acctsubjvindicdetail.csp?action=del&rowid='+rowid+'&detailrowid='+detailrowid,
						waitMsg:'ɾ����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
								detailGrid.load({params:{start:0, limit:20,checkmainid:rowid}});
							}else{
								Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				});
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��������¼��?',handler);
	}
});

var detailGrid = new dhc.herp.Gridlyf({
        title:'����������Ŀ',
        region: 'east',
        layout:'fit',
        width:300,
        readerModel:'remote',
        url: 'herp.acct.acctsubjvindicdetail.csp',
        tbar:[addButtons,'-',editButtons,'-',delButtons],
		atLoad : true, // �Ƿ��Զ�ˢ��
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
	    editable:false,
            hidden: true
        },{
            id:'CheckTypeCode',
            header: '������Ŀ����',
	    editable:false,
	    hidden:false,
            dataIndex: 'CheckTypeCode'
        
        },{
            id:'CheckTypeName',
            header: '������Ŀ����',
	    allowBlank: false,
	    width:170,
	    editable:false,
            dataIndex: 'CheckTypeName'
        }]
  
   });

