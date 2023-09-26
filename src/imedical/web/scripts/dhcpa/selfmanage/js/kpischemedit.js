

kpischemEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
    
	var len = rowObj.length;
//	console.log(rowObj[0]);
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else if(len>1){
		Ext.Msg.show({title:'����',msg:'ֻ���޸ĵ�����¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
		
		var code =rowObj[0].get("code");
		var name =rowObj[0].get("name");
		var shortcut =rowObj[0].get("shortcut");
		var frequency =rowObj[0].get("frequency");
		var desc =rowObj[0].get("desc");
		
	}
	

	var uCodeField = new Ext.form.TextField({
		id: 'uCodeField',
		fieldLabel: '���',
		anchor: '90%',
		//width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uCodeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
	var uNameField = new Ext.form.TextField({
		id: 'uNameField',
		fieldLabel: '����',
		anchor: '90%',
		//width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uNameField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var uShortcutField = new Ext.form.TextField({
		id: 'uShortcutField',
		fieldLabel: '��д',
		anchor: '90%',
		//width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uShortcutField',
		minChars: 1,
		pageSize: 10,
		editable:true
		
	});
	var uFrequencyField = new Ext.form.ComboBox({
			id:'uFrequencyField',
			fieldLabel: '����Ƶ��',
			anchor: '90%',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			name:'',
			mode:'local',
			valueNotFoundText:rowObj[0].get('periodTypeName'),
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
			})			
		});
	var uDescField = new Ext.form.TextField({
		id: 'uDescField',
		fieldLabel: '����',
		anchor: '90%',
		//width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uDescField',
		minChars: 1,
		pageSize: 10,
		editable:true
		
	});
	var isStopField = new Ext.form.Checkbox({  //2016-8-3 add cyl
		id: 'isStop',
		fieldLabel:'�Ƿ�ͣ��',
		allowBlank: false
	});
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [uCodeField, uNameField,uShortcutField,uFrequencyField,uDescField,isStopField]
		});
				                                                                                            
    //������
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                              
			this.getForm().loadRecord(rowObj[0]);
			uCodeField.setValue(rowObj[0].get("code"));	
			uNameField.setValue(rowObj[0].get("name"));	
			uShortcutField.setValue(rowObj[0].get("shortcut"));
			uFrequencyField.setValue(rowObj[0].get("frequency"));
			isStopField.setValue(rowObj[0].get("isStop")=="Y"?"on":"");
			uDescField.setValue(rowObj[0].get("desc"));                   
    });   
    
	    //���岢��ʼ�������޸İ�ť
	    var editButton = new Ext.Toolbar.Button({
				text:'����'
			});                                                                                                                                            
                    
		        //�����޸İ�ť��Ӧ����
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");   
		               
				var code = uCodeField.getValue();
				var name = uNameField.getValue(); 
				var shortcut = uShortcutField.getValue();
				var frequency = uFrequencyField.getValue();
				var desc = uDescField.getValue();
				var isStop = (isStopField.getValue()==true)?'Y':'N';
                Ext.Ajax.request({
				url:'dhc.pa.Selfmanageexe.csp?action=editdept&rowid='+rowid+'&code='+code+'&name='+encodeURIComponent(name)+'&shortcut='+encodeURIComponent(shortcut)+'&isStop='+isStop
					+'&frequency='+encodeURIComponent(frequency)+'&desc='+encodeURIComponent(desc),
				
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
			   	var jsonInfo=jsonData.info;
			   
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});		
				}
				else
					{
					var message="";
					var infoArr=jsonInfo.split("^");
					for(var i=1,len=infoArr.length;i<len;i++){
						var info=infoArr[i];
						if(info=='isCode') message=message+"�����ظ���</br>";
						if(info=='isName') message=message+"�����ظ���</br>";
					}
				
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
			height : 250,    
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
