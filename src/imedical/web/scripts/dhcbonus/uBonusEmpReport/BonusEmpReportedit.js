

BonusEmpReportEditFun = function() {
	
	var tmpBonusEmployeeID,tmpBonusReportID;
	
    var rowObj=itemGrid.getSelectionModel().getSelections(); //ѡ���еļ�¼
	var len = rowObj.length; //�ж�ѡ�ж�����
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var RowId = rowObj[0].get("RowId");
		var tmpBonusEmployeeID = rowObj[0].get("BonusEmployeeID");
		var tmpBonusReportID = rowObj[0].get("BonusReportID");
		//alert(RowId+"___"+tmpBonusEmployeeID+"___"+tmpBonusReportID);
	}
//-----------------	
var BonusEmployeeDs = new Ext.data.Store({
	      autoLoad:true,
	      proxy : "",
	      reader : new Ext.data.JsonReader({
	                 totalProperty : 'results',
	                 root : 'rows'
	              }, ['rowid','name'])  //�����̨������while�л�ȡ���ֶ�һ��
});


BonusEmployeeDs.on('beforeload', function(ds, o){

	     ds.proxy=new Ext.data.HttpProxy({
	               url: 'dhc.bonus.uBonusEmpReportexe.csp'
	                     + '?action=listEmployee&str='
	                     + encodeURIComponent(Ext.getCmp('BonusEmployeeDsField').getRawValue()),
	               method:'POST'
	              });
	});

var BonusEmployeeDsField = new Ext.form.ComboBox({
		id: 'BonusEmployeeDsField',
		fieldLabel: '��Ա����',
		width:200,
		listWidth : 220,
		allowBlank: false,
		store: BonusEmployeeDs,
		displayField: 'name',
		valueField: 'rowid',
		typeAhead : true,
		triggerAction : 'all',
		emptyText : '',
		name: 'BonusEmployeeDsField',
		pageSize: 10,
		minChars: 1,
		forceSelection : true,
		selectOnFocus:true,
	    editable:true
});

BonusEmployeeDsField.on('select',function(combo, record, index){
		 tmpBonusEmployeeID = combo.getValue();
	});

//---------------------
	var BonusReportDS = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
   });


	BonusReportDS.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'dhc.bonus.uBonusEmpReportexe.csp'
		                     + '?action=listReport&str='
		                     + encodeURIComponent(Ext.getCmp('BonusReportDSField').getRawValue()),
		               method:'POST'
		              });
   	});
   
	var BonusReportDSField = new Ext.form.ComboBox({
			id: 'BonusReportDSField',
			fieldLabel: '��������',
			width:200,
			listWidth : 220,
			allowBlank: false,
			store: BonusReportDS,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			emptyText : '',
			name: 'BonusReportDSField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true
	});
	
BonusReportDSField.on('select',function(combo, record, index){
		 tmpBonusReportID = combo.getValue();
	});
//--------------------------			                                                                                            //
    //�����ť���������	
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [BonusEmployeeDsField,BonusReportDSField]
		});

     formPanel.on('afterlayout', function(panel, layout) { 
                                                                                             
			this.getForm().loadRecord(rowObj[0]);
			BonusEmployeeDsField.setValue(rowObj[0].get("EmployeeName"));	
			BonusReportDSField.setValue(rowObj[0].get("ReportName"));	

			                                                                      
    });   
    
	    //���岢��ʼ�������޸İ�ť
 var editButton = new Ext.Toolbar.Button({
				text:'����'
			});                                                                                                                                            //
                    
		 //�����޸İ�ť��Ӧ��������
	 editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var RowId = rowObj[0].get("RowId");
		        var Person=BonusEmployeeDsField.getValue();
		        var Report=BonusReportDSField.getValue();  
		               
				if(Ext.getCmp('BonusEmployeeDsField').getRawValue()==""){var BonusEmployeeID="";}
				else{var BonusEmployeeID =tmpBonusEmployeeID;}
				if(Ext.getCmp('BonusReportDSField').getRawValue()==""){var BonusReportID="";}
				else{var BonusReportID = tmpBonusReportID;}
				//alert(RowId+"^"+BonusEmployeeID+"^"+BonusReportID);
				
				Person = Person.trim();
				Report = Report.trim();
				
				if(Person=="")
      			{
      			Ext.Msg.show({title:'����',msg:'��Ա����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      			};
      			if(Report=="")
      			{
      			Ext.Msg.show({title:'����',msg:'��������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      			};
      			
				if (formPanel.form.isValid()) {
                Ext.Ajax.request({
				url:'dhc.bonus.uBonusEmpReportexe.csp?action=edit&RowId='+RowId+'&BonusEmployeeID='+BonusEmployeeID
				+'&BonusReportID='+BonusReportID,
				
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
						var message="SQLErr: "+jsonData.info;
						if(jsonData.info=='RepName') message='�Ѵ�����ͬ��¼';
						Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					};
			},
				scope: this
			});
			editwin.close();
				}};
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
			title: '�޸���Ա����Ȩ��',
			width : 400,
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
