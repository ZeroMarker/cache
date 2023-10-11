var userid = session['LOGON.USERID'];		
editFun = function() {
	
	// var rowObj = itemGrid.getSelectionModel().getSelections(); 
	 var rowid=tmpNode.attributes["rowid"];
    // var rowid=rowObj[0].get("rowid");
	var esjcodeField = new Ext.form.TextField({
		fieldLabel: '��Ŀ����',
		width:180,
		//anchor: '100%',
		allowBlank : false,  
		selectOnFocus:'true',
		listeners : {
			specialKey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if (esjcodeField.getValue() != "") {
						esjnameField.focus();
					} else {
						Handler = function() {
							esjcodeField.focus();
						}
						Ext.Msg.show({
							title : '����',
							msg : '��Ŀ���벻��Ϊ��!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR,
							fn : Handler
						});
					}
				}
			}
		}
	
	});	
	
	//��Ŀ����
	var esjnameField = new Ext.form.TextField({
		fieldLabel: '��Ŀ����',
		width:180,
		allowBlank : false, 
		selectOnFocus:'true',
		listeners : {
			specialKey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if (esjnameField.getValue() != "") {
						edirectionField.focus();
					} else {
						Handler = function() {
							esjnameField.focus();
						}
						Ext.Msg.show({
							title : '����',
							msg : '�������Ʋ���Ϊ��!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR,
							fn : Handler
						});
					}
				}
			}
		}
	});
	
	//���ױ���--ȥ��ǰ���洫���ֵ��(δ��)
	var ebookidField = new Ext.form.TextField({
		fieldLabel: '��ǰ����',
		width:180, 
		selectOnFocus:'true'
	});	
	ebookidField.setValue(acctbookid);
	ebookidField.disable();

	//��Ŀȫ��(δ��)--��������ƴ��
	var esjnameAllField = new Ext.form.TextField({
		fieldLabel: '��Ŀȫ��',
		width:180,
		emptyText:'ϵͳ���ݱ�������Զ�����',
		disabled:true, 
		selectOnFocus:'true'
	});
	
	//�����ɿ�Ŀ��������ĸƴ��
	var espellField = new Ext.form.TextField({
	fieldLabel: 'ƴ����',
	width:180, 
	disabled:true,
	selectOnFocus:'true'
	});	
	
	var edefinecodeField = new Ext.form.TextField({
	fieldLabel: '�Զ�����',
	width:180, 
	//disabled:true,
	selectOnFocus:'true'
	});	
	
	//�ϼ�����--�Զ����ɣ����ɱ༭��(δ��)
	var esupercodeField = new Ext.form.TextField({
	fieldLabel: '�ϼ�����',
	width:180, 
	//disabled:true,
	selectOnFocus:'true'
	});	
	ebookidField.disable();
	
	//��Ŀ���
	var esjtypeDs = new Ext.data.Store({
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
	});
	esjtypeDs.on('beforeload', function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({
			url : projUrl+'?action=sjtypelist&str',method:'POST'
		});
	});
	var esjtypeField = new Ext.form.ComboBox({
		id: 'esjtypeField',
		fieldLabel: '��Ŀ���',
		width:180,
		listWidth : 265,
		store: esjtypeDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ���Ŀ����...',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true	
	});

	//��Ŀ����
	var esjnatureDs = new Ext.data.Store({
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
	});
	esjnatureDs.on('beforeload', function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({
			url : projUrl+'?action=sjnaturelist&str',method:'POST'
		});
	});
	var esjnatureField = new Ext.form.ComboBox({
		id: 'esjnatureField',
		fieldLabel: '��Ŀ����',
		width:180, 
		listWidth : 265,
		allowBlank: true,
		store: esjnatureDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ���Ŀ����...',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true	
	});

	//��Ŀ����
	var esjlevelDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [
				['1','1'],['2','2'],['3','3'],['4','4'],
				['5','5'],['6','6'],['7','7'],['8','8'],
				['9','9'],['10','10'],['11','11'],['12','12']
			]
		});
		var esjlevelField= new Ext.form.ComboBox({
			id : 'esjlevelField',
			fieldLabel : '��Ŀ����',
			width : 180,
			selectOnFocus : true,
			allowBlank : false,
			store : esjlevelDs,			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // ����ģʽ
			editable : false,
			selectOnFocus : true,
			forceSelection : true
		});	
	
	//�Ƿ�ͣ��
	var eIsStopField = new Ext.form.Checkbox({
		id : 'eIsStopField',
		fieldLabel: '�Ƿ�ͣ��',
		//labelSeparator : '�Ƿ�ͣ��:',
		allowBlank : false
	});
	//��Һ���
	var eIsFcField = new Ext.form.Checkbox({
		id : 'eIsFcField',
		fieldLabel: '��Һ���',
		//labelSeparator : '��Һ���:',
		allowBlank : false
	});
	//��������
	var eIsNumField = new Ext.form.Checkbox({
		id : 'eIsNumField',
		fieldLabel: '��������',
		//labelSeparator : '��������:',
		allowBlank : false,
		listeners : {
			check: function (obj, eIsNum) {                     
				if (eIsNum) {
					 eNumUnitField.enable();
				} else {
					eNumUnitField.disable();
				}
			}                 
		}
	});
	//��������
	var eIsCheckField = new Ext.form.Checkbox({
		id : 'eIsCheckField',
		fieldLabel: '��������',
		//labelSeparator : '��������:',
		allowBlank : false,
		selectOnFocus : true,
		triggerAction : 'all',
		forceSelection : true,
		listeners : {
			check: function (obj, eIsCheck) {                     
				if (eIsCheck) {
					// eCheckFieldSet.enable();
				} else {
					// eCheckFieldSet.disable();
				}
			}                 
		}		
	});

	//�������
	var edirectionStore = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��'], ['-1', '��']]
		});
		var edirectionField = new Ext.form.ComboBox({
			id : 'edirectionField',
			fieldLabel : '�������',
			width:180, 
			selectOnFocus : true,
			allowBlank : false,
			store : edirectionStore,
			//anchor : '95%',			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // ����ģʽ
			editable : false,
			value:1,
			selectOnFocus : true,
			forceSelection : true
		});
		

	//�Ƿ�ĩ��
	var eIsLastFieldStore = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��'], ['0', '��']]
		});
		var eIsLastField = new Ext.form.ComboBox({
			id : 'eIsLastField',
			fieldLabel : '�Ƿ�ĩ��',
			width:180, 
			selectOnFocus : true,
			allowBlank : false,
			store : eIsLastFieldStore,
			//anchor : '95%',			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // ����ģʽ
			editable : false,
			value:1,
			selectOnFocus : true,
			forceSelection : true
		});	

	//������λ
	var eNumUnitDs = new Ext.data.Store({
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','desc'])
	});
	eNumUnitDs.on('beforeload', function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({
			url : projUrl+'?action=numunitlist',method:'POST'
		});
	});
	var eNumUnitField = new Ext.form.ComboBox({
		id: 'eNumUnitField',
		fieldLabel: '������λ',
		width:180, 
		listWidth : 265,
		allowBlank: true,
		store: eNumUnitDs,
		valueField: 'rowid',
		displayField: 'desc',
		triggerAction: 'all',
		emptyText:'��ѡ�������λ',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true	
	});
eNumUnitField.disable();
	//�ֽ����б�ʶ
	var eIsCashFieldStore = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '�ֽ�'],['2', '����'] ,['0', '����']]
		});
		var eIsCashField = new Ext.form.ComboBox({
			id : 'eIsCashField',
			fieldLabel : '�ֽ����б�ʶ',
			width:180, 
			selectOnFocus : true,
			allowBlank : false,
			store : eIsCashFieldStore,
			//anchor : '95%',			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // ����ģʽ
			editable : false,
			value:'0',
			selectOnFocus : true,
			forceSelection : true,
						listeners:{
				select:{
                     fn:function(combo,record,index) { 
                   	if(eIsCashField.getValue()== "1"||eIsCashField.getValue()== "2")
			                	{ //����ֽ����еĿ�Ŀ
				                       eIsCashFlow.enable();//�Ƿ��ֽ���������
									   //����ֽ�������
									   if(eIsCashFlow.getRawValue()=="��"){
										 eCashFlowField.enable();
									   }else{
										 eCashFlowField.disable();
										 eCashFlowField.setValue(0);
										 eCashFlowField.setRawValue("");
									   }
                               
				                }
				             else
				             	{ //����������ÿ�
				             		eIsCashFlow.disable();
									eCashFlowField.disable();
									eIsCashFlow.setValue(0);
									eIsCashFlow.setRawValue("��");
									eCashFlowField.setValue(0);
									eCashFlowField.setRawValue("");
				             		}
                  }
                }
			}
		});	

	//��Ŀ����
	var esubjGroupStore = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['01', 'ҽ��'], ['02', 'ҩ��'],['03', '����'],['09', '����']]
		});
		var esubjGroup = new Ext.form.ComboBox({
			id : 'esubjGroup',
			fieldLabel : '��Ŀ����',
			width:180, 
			selectOnFocus : true,
			allowBlank : false,
			store : esubjGroupStore,
			//anchor : '95%',			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // ����ģʽ
			editable : false,
			value:'09',
			selectOnFocus : true,
			forceSelection : true
		});	
	
	//�ֽ����б�ʶ
	var eIsCashFlowStore = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��'], ['0', '��']]
		});
		var eIsCashFlow = new Ext.form.ComboBox({
			id : 'eIsCashFlow',
			fieldLabel : '�ֽ�������Ŀ',
			width:180, 
			selectOnFocus : true,
			//allowBlank : false,
			store : eIsCashFlowStore,
			//anchor : '95%',			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // ����ģʽ
			editable : false,
			value:0,
			selectOnFocus : true,
			forceSelection : true,
			listeners:{
                select:{
                    fn:function(combo,record,index) { 
                    if(eIsCashFlow.getValue()== "1")
                                {  //������ֽ�,�ֽ�������Ŀ����
                                       eCashFlowField.enable();
                                }
                             else
                                {
										eCashFlowField.disable();
										eCashFlowField.setValue(0);
										eCashFlowField.setRawValue("");
                                }
                  }
                }
            }
		});	
	
	var eStartDateField = new Ext.form.DateField({
		id : 'eStartDateField',
		fieldLabel: '��������',
		format : 'Y-m',
		width : 180,
		emptyText : '',
		plugins: 'monthPickerPlugin'
	});
	
	var eEndDateField = new Ext.form.DateField({
		id : 'eEndDateField',
		fieldLabel: 'ͣ������',
		format : 'Y-m',
		width : 180,
		emptyText : '',
		plugins: 'monthPickerPlugin'
	});
	
	
	//�ֽ�������
	var eCashFlowDs = new Ext.data.Store({
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
	});
	eCashFlowDs.on('beforeload', function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({
			url : projUrl+'?action=cashflowlist',method:'POST'
		});
	});
	var eCashFlowField = new Ext.form.ComboBox({
		id: 'eCashFlowField',
		fieldLabel: '�ֽ�������',
		width:180, 
		listWidth : 265,
		allowBlank: true,
		store: eCashFlowDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ���ֽ�������',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true	
	});
	
		var eSJFieldSet = new Ext.form.FieldSet({
		title : '�޸Ļ�ƿ�Ŀ',
		height : 320,
		columnWidth:1,
		layout:'column',
		labelSeparator : '��',
		items : [{
			columnWidth:.4,
			layout:'form',
			items: [
					{
						xtype : 'displayfield',
						value : '',
						columnWidth :.4
					},
					esjlevelField,     
					esjcodeField,        
					esjnameField,
					esjtypeField,        
					esjnatureField,
					esupercodeField, 		
					edefinecodeField,    
					 eNumUnitField 				
					]	
		},{
			columnWidth:.4,
			layout:'form',
			items: [
					{
						xtype : 'displayfield',
						value : '',
						columnWidth : .4
					}, 
					  edirectionField,   
					  eIsLastField,  
					  esubjGroup,  
					  eIsCashField,  					  
					  eIsCashFlow,    
					  eCashFlowField,
					  eStartDateField,
					  eEndDateField  
					]	
		},{
			columnWidth:.2,
			layout:'form',
			items: [
					{
						xtype : 'displayfield',
						value : '',
						columnWidth : .2
					},     
					eIsStopField,  		
					eIsFcField,
					eIsNumField,       
					eIsCheckField 					
					]	
		}]
	});

//***����ṹ***//
	var colItems =	[{
		layout: 'column',
		border: false,
		defaults: {
			columnWidth: '1.0',
			bodyStyle:'padding:1px 1px 0',
			border: false
			},            
		items:[{
			xtype: 'fieldset',
			autoHeight: true,
			items:[
				eSJFieldSet	
			]
		}]
	}];
	
	//***�������(���)***//
	var formPanel = new Ext.form.FormPanel({
		labelWidth: 80,
		frame: true,
		items: colItems
	});
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(tmpNode);
			esjcodeField.setValue(tmpNode.attributes["SubjCode"]); //�༭ʱ,��Ŀ����
			var SubjNames=tmpNode.attributes["SubjName"];			//��Ŀ����--��ʱ��ҳ����ֵ(���пո�)
			var SubjNames=SubjNames.split(";");
            SubjName = SubjNames[SubjNames.length-1];			//��Ŀ����ȥ���ո�
			esjnameField.setRawValue(SubjName);		
			//
			edefinecodeField.setValue(tmpNode.attributes["DefineCode"]);	//�Զ������		
			esupercodeField.setValue(tmpNode.attributes["SuperSubjCode"]);//�ϼ�����
			esupercodeField.disable();
			
			var esjlevel=tmpNode.attributes["SubjLevel"];		//��Ŀ����
			esjlevelField.setValue(esjlevel);
			esjtypeField.setValue(tmpNode.attributes["SubjTypeID"]); //��ȡ��Ŀ����ID
			esjtypeField.setRawValue(tmpNode.attributes["SubjTypeName"]);//��ʾ��Ŀ��������
			
			esjnatureField.setValue(tmpNode.attributes["SubjNatureID"]);//��ȡ��Ŀ����ID
			esjnatureField.setRawValue(tmpNode.attributes["SubjNatureName"]);//��ʾ��Ŀ��������
			//�Ƿ�ĩ����Ŀ
			var eIsLast=tmpNode.attributes["IsLast"];		//�Ƿ�ĩ����Ŀ
			if(eIsLast=="��"){
				eIsLastField.setValue(1);
			}else{
				eIsLastField.setValue(0);
			};
			//�������
			var edirection=tmpNode.attributes["Direction"];
			if(edirection=="��"){
				edirectionField.setValue(1);
			}else{
				edirectionField.setValue(-1);
			};
			
			//�ֽ�������Ŀ
			var iscashflow= tmpNode.attributes["IsCashFlow"];
			if(iscashflow=="��"){
				eIsCashFlow.setValue(1);
				eIsCashFlow.setRawValue("��");
			}else{
				eIsCashFlow.setValue(0);
				eIsCashFlow.setRawValue("��");
				eCashFlowField.disable();
				eCashFlowField.setValue(0);
				eCashFlowField.setRawValue("");
			}
			
			
			
			//�ֽ���������(�ֽ����б�־)
			var eiscash=tmpNode.attributes["IsCash"];
			if(eiscash=="�ֽ�"){
				eIsCashField.setValue(1);
			}else if(eiscash=="����"){
				eIsCashField.setValue(2);
			}else{
				eIsCashField.setValue(0);//�ֽ����б�־����
				
				eIsCashFlow.disable();
				eIsCashFlow.setValue(0);//�Ƿ��ֽ�������Ŀ
				eIsCashFlow.setRawValue("��");//��
				eCashFlowField.disable();//
				eCashFlowField.setValue(0);//�ֽ��������ÿ�
				eCashFlowField.setRawValue("");
				
				
				
				
			}
			//������λ
			eNumUnitField.setRawValue(tmpNode.attributes["NumUnit"]);
			//��������
			var eIsNum=tmpNode.attributes["IsNum"];
			if(eIsNum=="��"){
				eIsNumField.setValue(true);
				eNumUnitField.enable();
			}else{
				eIsNumField.setValue(false);
				eNumUnitField.disable();
			};
			//��Һ���
			var eIsFc= tmpNode.attributes["IsFc"];
			if(eIsFc=="��"){
				eIsFcField.setValue(true);
			}else{
				eIsFcField.setValue(false);
			};
			//��������
			var eIsCheck=tmpNode.attributes["IsCheck"];
			if(eIsCheck=="��"){
				eIsCheckField.setValue(true);
			}else{
				eIsCheckField.setValue(false);
			};
			//�Ƿ�ͣ��
			var eIsStop=tmpNode.attributes["IsStop"];
			if(eIsStop=="��"){
				eIsStopField.setValue(true);
			}else{
				eIsStopField.setValue(false);
			};
			
			//��Ŀ����
			var esubjgroup=tmpNode.attributes["subjGroup"];
			if(esubjgroup=="ҽ��"){
				esubjGroup.setValue("01");
			}else if(esubjgroup=="ҩ��"){
				esubjGroup.setValue("02");
			}else if(esubjgroup=="����"){
				esubjGroup.setValue("03");
			}else {
				esubjGroup.setValue("09");
			}
			
			//�ֽ�������
			eCashFlowField.setValue(tmpNode.attributes["CashFlowID"]);
			eCashFlowField.setRawValue(tmpNode.attributes["CashItemName"]);

			eStartDateField.setValue(tmpNode.attributes["StartYM"]);
			eEndDateField.setValue(tmpNode.attributes["EndYM"]);
			
		
			
		});
	
	//***ȷ����ť***//
	addButton = new Ext.Toolbar.Button({
		text:'�����޸�'
	});

	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
	addHandler = function(){ 

	var esjcode=esjcodeField.getValue(); 
	var esjname=esjnameField.getValue(); 
	var esjnameAll=esjnameAllField.getValue(); 
	var espell=espellField.getValue(); 
	
	var edefinecode=edefinecodeField.getValue(); 
	var esupercode=esupercodeField.getValue(); 
	var esjlevel=esjlevelField.getValue();
	var esjtype=esjtypeField.getValue(); 
	var esjnature=esjnatureField.getValue(); 
	var eIsLast=eIsLastField.getValue(); 
	var edirection=edirectionField.getValue(); 
	var eNumUnit=eNumUnitField.getValue();
		
	var eIsCash=eIsCashField.getValue(); 
	var eIsNum = (eIsNumField.getValue() == true) ? '1' : '0';
	var eIsFc = (eIsFcField.getValue() == true) ? '1' : '0';	
	var eIsCheck = (eIsCheckField.getValue() == true) ? '1' : '0';
	var eIsStop = (eIsStopField.getValue() == true) ? '1' : '0';
	var esjGroup=esubjGroup.getValue(); 
	var eCashFlow=eCashFlowField.getValue();
   var eStartDate=eStartDateField.getValue();
	if (eStartDate!=="")
	{
	  eStartDate=eStartDate.format ('Y-m');
	}

	var eEndDate=eEndDateField.getValue();
	if (eEndDate!=="")
	{
	  eEndDate=eEndDate.format ('Y-m');	
	}
	
	var eICFlow=eIsCashFlow.getValue(); 

	if((esjname=="")||(esjcode==""))
	{
		Ext.Msg.show({title:'����',msg:'��������Ʋ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	};
	
	var len3=0;
	var flag=1;
	Ext.Ajax.request({
		    async: false,
			url: '../csp/herp.acct.acctSubjTreeExe.csp?action=editLength&acctbookid='+acctbookid+'&esjlevel='+esjlevel,
			waitMsg:'������...',
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					 len3= jsonData.info;
					 var len4  = esjcode.length;
					if(len4!=len3){
					Ext.Msg.show({title:'����',msg:'��Ŀ���벻�淶',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					flag=2;
					return;
					};
				}
			}
	});

	var edata=esjcode+"|"+esjname+"|" +edefinecode+"|"+esupercode+"|"+esjlevel+"|"+esjtype+"|"+esjnature+"|"+
	eIsLast+"|"+edirection +"|"+eIsCash+"|"+eIsNum +"|"+eNumUnit+"|"+ eIsFc+"|"+ eIsCheck+"|"+ eIsStop +"|"+
	esjGroup +"|"+eCashFlow +"|"+eStartDate+"|"+eEndDate +"|"+eICFlow
   Ext.Ajax.request({
			url: '../csp/herp.acct.acctSubjTreeExe.csp?action=updatesj&edata='+encodeURIComponent(edata)+'&acctbookid='+acctbookid+'&rowid='+rowid,
			waitMsg:'������...',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					addwin.close();	//��ӳɹ��رմ���
					Ext.Msg.show({title:'ע��',msg:'�����޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							// mainGrid.load({params:{start:0, limit:25}});
							 // if(tmpNode==""){
								// mainGrid.root.reload();
								// }
								// else{
								// mainGrid.loader.load(tmpNode);
								// tmpNode.expand(false);
								// } 
								//ĩ�� ��ʾ
								if(eIsLast==1){
									var tmpPar=tmpNode.parentNode;
									mainGrid.loader.load(tmpPar);
									tmpPar.expand(false);
								}
								else{	
								mainGrid.root.reload();
								}
								tmpNode = "";
								
							CheckitemGrid.load({params:{start:0,limit:25}});		
				}else
				{
					var message="";
					if(jsonData.info=='RepCode') message='¼��ı����Ѵ���,�����˶Ժ���������!';
					if(jsonData.info=='err1') message=	'��Ŀ�������Ŀ�������ƥ��!';
					if(jsonData.info=='err2') message=  'δ�ҵ��ϼ���Ŀ����,����¼���ϼ���Ŀ!!';
					if(jsonData.info=='NotExist') message='����ֱ���޸ķ�ͬ������'
					Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
			scope: this
		});
	//addwin.close();
	
	}	
			//***��Ӽ����¼�***//	
	addButton.addListener('click',addHandler,false);

	cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});
	
	cancelHandler = function(){
		addwin.close();
	}
	
	cancelButton.addListener('click',cancelHandler,false);

	//***����һ������***//
	addwin = new Ext.Window({
		title: '�޸Ŀ�Ŀ',
		width: 750,
		height:380,
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
	addwin.show();
		
}


