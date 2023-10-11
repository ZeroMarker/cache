

srmdeptuserEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
		var code =rowObj[0].get("code");
		var name =rowObj[0].get("name");
		var type =rowObj[0].get("type");
        var DeptClassID =rowObj[0].get("DeptClassID");
		var SuperDeptID =rowObj[0].get("SuperDeptID");
	}
	

	var uCodeField = new Ext.form.TextField({
		id: 'uCodeField',
		fieldLabel: '���ұ���',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uCodeField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uNameField = new Ext.form.TextField({
		id: 'uNameField',
		fieldLabel: '��������',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uNameField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
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
		               url: 'herp.srm.srmdeptexe.csp'
		                     + '?action=caltypename&str='
		                     + encodeURIComponent(Ext.getCmp('uTypeField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var uTypeField = new Ext.form.ComboBox({
			id: 'uTypeField',
			fieldLabel: '��������',
			width:200,
			listWidth : 225,
			allowBlank: true,
			store: uTypeDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			//��ʱΪ��
			disabled:true,
			//emptyText : '',
			name: 'uTypeField',
			pageSize: 10,
			minChars: 1,
			forceSelection : false,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});
/////////////////////�Ƿ���Ч/////////////////////////////
var eIsdriectField = new Ext.form.Checkbox({
                        id:'eIsdriectField',
						name:'eIsdriectField',
						fieldLabel : '�Ƿ���Ч',
						labelSeparator:'',
						renderer : function(v, p, record){
        	               p.css += ' x-grid3-check-col-td'; 
        	               return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
					});
/////////////////////���Ҽ���/////////////////////////////					
var ueDeptClassDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', 'һ������'], ['2', '��������'], ['3', '��������'],['4','�ļ�����']]
	});
	var ueDeptClassField = new Ext.form.ComboBox({
	    id : 'ueDeptClassField',
		fieldLabel : '���Ҽ���',
		width : 200,
		listWidth : 200,
		store : ueDeptClassDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		//emptyText:'��ѡ��...',
		value:DeptClassID,
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});	
/////////////////////�ϼ�����/////////////////////////////					
	var ueSuperDeptDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });

	ueSuperDeptDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.srmdeptexe.csp'
		                     + '?action=caldeptname&str='
		                     + encodeURIComponent(Ext.getCmp('ueSuperDeptField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var ueSuperDeptField = new Ext.form.ComboBox({
			id: 'ueSuperDeptField',
			fieldLabel: '�ϼ�����',
			width:200,
			listWidth : 250,
			allowBlank: true,
			store: ueSuperDeptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			//emptyText : '',
			name: 'ueSuperDeptField',
			//��ʱΪ��
			//disabled:true,
			pageSize: 10,
			value:SuperDeptID,
			minChars: 1,
			forceSelection : false,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 80,
			labelAlign: 'right',
			items : [uCodeField, uNameField,ueDeptClassField,ueSuperDeptField,eIsdriectField]
		});
    //������
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                             
			this.getForm().loadRecord(rowObj[0]);
			uCodeField.setValue(rowObj[0].get("Code"));	
			uNameField.setValue(rowObj[0].get("Name"));	
			//uTypeField.setValue(rowObj[0].get("Type"));
			
			if(rowObj[0].get("IsValid")=="Y"){eIsdriectField.setValue(true);}
			ueDeptClassField.setRawValue(rowObj[0].get("DeptClass"));	
			ueSuperDeptField.setRawValue(rowObj[0].get("SuperDept"));	
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
				var code = uCodeField.getValue();
				var name = uNameField.getValue(); 
				var deptclass = ueDeptClassField.getValue(); 
				var superdept = ueSuperDeptField.getValue(); 
				//var type = uTypeField.getValue(); 
				var type=""
				//alert(deptclass);
				var IsValid = "";
			    if (Ext.getCmp('eIsdriectField').checked) {IsValid="Y";}
			    else { IsValid="N";}
                
				/*
				var Code=rowObj[0].get("Code")
				var Name=rowObj[0].get("Name")
				var isvalid=rowObj[0].get("IsValid")
				var DeptClass=rowObj[0].get("DeptClass")
				var SuperDept=rowObj[0].get("SuperDept")
				//alert(DeptClass);
				
				if(Code==code){code="";}
				if(Name==name){name="";}
				if(IsValid==isvalid){IsValid="";}
				//if(DeptClass==deptclass){deptclass="";}
				if(SuperDept==superdept){superdept="";}
				if(deptclass=="�ļ�����"){deptclass=4;}
				if(deptclass=="��������"){deptclass=3;}
				if(deptclass=="��������"){deptclass=2;}
				if(deptclass=="һ������"){deptclass=1;}
				//alert(deptclass);
				*/
				if(code=="")
				{
					Ext.Msg.show({title:'����',msg:'���Ҵ��벻��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				};
				if(name=="")
				{
					Ext.Msg.show({title:'����',msg:'�������Ʋ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				};
				if(IsValid=="")
				{
					Ext.Msg.show({title:'����',msg:'��ѡ�������Ƿ���Ч',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				};
				
                Ext.Ajax.request({
				url:'herp.srm.srmdeptexe.csp?action=edit&rowid='+rowid+'&code='+encodeURIComponent(code)
				+'&name='+encodeURIComponent(name)+'&type='+type+'&IsValid='+IsValid+'&deptclass='+deptclass+'&superdept='+superdept,
				
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:25}});		
				}
				else
					{
					var message=jsonData.info;
					if(jsonData.info=='RecordExist') message="��¼�ظ�";
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
			title : '�޸Ŀ�����Ϣ',
			iconCls: 'pencil',
			width : 350,
			height : 210,    
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
