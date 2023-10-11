

syseaflowEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections(); //ѡ���еļ�¼
	var len = rowObj.length; //�ж�ѡ�ж�����
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
		var tmpTypeID = rowObj[0].get("TypeID");
		var tmpSysModuleID =rowObj[0].get("SysModuleID");
		var tmpEAFMDr =rowObj[0].get("EAFMDr");
	}
//-----------------	
///////////////////����/////////////////////////////  
var TypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var TypeCombox = new Ext.form.ComboBox({
	                   id : 'TypeCombox',
		           fieldLabel : '����',
	                   width : 200,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : TypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           value:tmpTypeID,
		           selectOnFocus : true,
		           forceSelection : true,
		           labelSeparator:''
						  });	
TypeCombox.on('select',function(combo, record, index){
		 tmpTypeID = combo.getValue();
	});
///////////////////////////////////////////
var SysModuleDs = new Ext.data.Store({
	      autoLoad:true,
	      proxy : "",
	      reader : new Ext.data.JsonReader({
	                 totalProperty : 'results',
	                 root : 'rows'
	              }, ['rowid','name'])  //�����̨������while�л�ȡ���ֶ�һ��
});


SysModuleDs.on('beforeload', function(ds, o){

	     ds.proxy=new Ext.data.HttpProxy({
	               url: 'herp.srm.syseaflowexe.csp'
	                     + '?action=listSysModule&str='
	                     + encodeURIComponent(Ext.getCmp('SysModuleDsField').getRawValue()),
	               method:'POST'
	              });
	});

var SysModuleDsField = new Ext.form.ComboBox({
		id: 'SysModuleDsField',
		fieldLabel: 'ϵͳģ��',
		width:200,
		listWidth : 250,
		allowBlank: false,
		store: SysModuleDs,
		displayField: 'name',
		valueField: 'rowid',
		typeAhead : true,
		triggerAction : 'all',
		emptyText : '',
		name: 'SysModuleDsField',
		pageSize: 10,
		minChars: 1,
		forceSelection : true,
		selectOnFocus:true,
	    editable:true,
	    labelSeparator:''
});

SysModuleDsField.on('select',function(combo, record, index){
		 tmpSysModuleID = combo.getValue();
	});

//---------------------
	var EAFMDrDS = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
   });


	EAFMDrDS.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.syseaflowexe.csp'
		                     + '?action=listEAFMain&str='
		                     + encodeURIComponent(Ext.getCmp('EAFMDrDSField').getRawValue()),
		               method:'POST'
		              });
   	});
   
	var EAFMDrDSField = new Ext.form.ComboBox({
			id: 'EAFMDrDSField',
			fieldLabel: '��������',
			width:200,
			listWidth : 250,
			allowBlank: false,
			store: EAFMDrDS,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			emptyText : '',
			name: 'EAFMDrDSField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});
	
EAFMDrDSField.on('select',function(combo, record, index){
		 tmpEAFMDr = combo.getValue();
	});
//--------------------------			                                                                                            //
    //�����ť���������	
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			labelAlign: 'right',
			items : [TypeCombox,SysModuleDsField,EAFMDrDSField]
		});

     formPanel.on('afterlayout', function(panel, layout) { 
                                                                                             
			this.getForm().loadRecord(rowObj[0]);
			TypeCombox.setRawValue(rowObj[0].get("Type"));	
			SysModuleDsField.setRawValue(rowObj[0].get("SysModuleName"));	
			EAFMDrDSField.setRawValue(rowObj[0].get("EAFMName"));	

			                                                                      
    });   
    
	    //���岢��ʼ�������޸İ�ť
 var editButton = new Ext.Toolbar.Button({
				text:'����',
				iconCls: 'save'
			});                                                                                                                                            //
                    
		 //�����޸İ�ť��Ӧ��������
	 editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");          
				//var SysModuleID = SysModuleDsField.getValue();
				var SysModuleID =tmpSysModuleID;
				//alert(SysModuleID);
				//var EAFMDr = EAFMDrDSField.getValue(); 
				var EAFMDr = tmpEAFMDr;
		        var Type=tmpTypeID;
                
                Ext.Ajax.request({
				url:'herp.srm.syseaflowexe.csp?action=edit&rowid='+rowid+'&Type='+Type+'&SysModuleID='+SysModuleID
				+'&EAFMDr='+EAFMDr,
				
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
						var message="ͬһ����ģ��ֻ�ܶ�Ӧһ����������";
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
			title: '�޸�ҵ����������Ϣ',
  			iconCls: 'pencil',
			width : 400,
			height : 180,    
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
