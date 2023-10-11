

EditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
		var SysNO =rowObj[0].get("SysNO");
		var Formula =rowObj[0].get("Formula");
	}
	
//���
var eYearListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
eYearListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : CalcFieldFormulaURL+'?action=yearlist&str='+encodeURIComponent(Ext.getCmp('eYearField').getRawValue()),
						method : 'POST'
					});
		});
var eYearField = new Ext.form.ComboBox({
            id:'eYearField',
			name:'eYearField',
			fieldLabel : '���',
			width : 180,
			listWidth : 250,
			selectOnFocus : true,
			//allowBlank : false,
			store : eYearListDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
			forceSelection : true
		});
	//ϵͳģ���
var eSysModListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
eSysModListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : FieldCoefficientUrl+'?action=sysmodelist&str='+encodeURIComponent(Ext.getCmp('eSysModListField').getRawValue()),
						method : 'POST'
					});
		});
var eSysModListField = new Ext.form.ComboBox({
            id:'eSysModListField',
			name:'eSysModListField',
			fieldLabel : 'ϵͳģ��',
			width : 180,
			listWidth : 250,
			selectOnFocus : true,
			//allowBlank : false,
			store : eSysModListDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true,
			forceSelection : true
		});
var hiddenField = new Ext.form.TextField({
		id: 'hiddenField',
		fieldLabel: '�洢��ʽ',
		width:180,
		listWidth : 250,
		triggerAction: 'all',
		emptyText:'',
		hidden:true,
		name: 'hiddenField',
		minChars: 1,
		pageSize: 10,
		labelSeparator:'',
		editable:true
	});
	
var eCalculateDescField = new Ext.form.TriggerField({
				fieldLabel : '��ʽ����',
				// disabled:true,
				editable : false,
				//hidden : true,
				width:180,
				labelSeparator:''
				// emptyText : '��ʽ����'
				//anchor : '100%'
			});

	eCalculateDescField.onTriggerClick = function() {
		formula(1, this);
	};
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 80,
			labelAlign:'right',
			items : [eYearField,eSysModListField, eCalculateDescField]
		});
    //������
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                             
			this.getForm().loadRecord(rowObj[0]);
			eYearField.setRawValue(rowObj[0].get("Year"));
			eSysModListField.setRawValue(rowObj[0].get("SysNO"));	
			eCalculateDescField.setValue(rowObj[0].get("Formula"));			
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
				var sysno = eSysModListField.getValue();
				var formula = eCalculateDescField.getValue(); 
                var year = eYearField.getValue();
				var codeformula = hiddenField.getValue();
				
				var SysNO=rowObj[0].get("SysNO")
				var Formula=rowObj[0].get("Formula")
				var Year=rowObj[0].get("Year")
				var CodeFormula=rowObj[0].get("CodeFormula")
				//alert(SysNO);
				if(SysNO==sysno){sysno="";}
				if(Formula==formula){formula="";}
				if(Year==year){year="";}
				if(CodeFormula==codeformula){codeformula="";}
				
				if(eYearField.getRawValue()=="")
				{
					Ext.Msg.show({title:'����',msg:'��Ȳ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
				if(eSysModListField.getRawValue()=="")
				{
					Ext.Msg.show({title:'����',msg:'ϵͳģ�鲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
				if(eCalculateDescField.getRawValue()=="")
				{
					Ext.Msg.show({title:'����',msg:'���㹫ʽ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
					
                Ext.Ajax.request({
				url:CalcFieldFormulaURL+'?action=edit&rowid='+rowid+'&Year='+year+'&SysNO='+encodeURIComponent(sysno)+'&Formula='+encodeURIComponent(formula)+'&CodeFormula='+encodeURIComponent(codeformula),
				
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGrid.load({params:{start:0, limit:25}});		
				}
				else
					{
					var message="�ظ����";
					if(jsonData.info=='RepSysMod') message="ϵͳģ���ظ���";
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
			text: '�ر�',
			iconCls: 'cancel'
		});
	
		//����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			editwin.close();
		};
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//���岢��ʼ������
		var editwin = new Ext.Window({
			title: '�޸Ŀ��м�Ч��ʽ',
			iconCls: 'pencil',
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
