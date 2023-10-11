

srmdeptuserEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
	}
	

	var uCodeField = new Ext.form.TextField({
		id: 'uCodeField',
		fieldLabel: '�û�����',
		width:180,
		listwidth:180,
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
		fieldLabel: '�û�����',
		width:180,
		listwidth:180,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uNameField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	////////////////////////��λ����--����20151103///////////////////////////
		var ueJobTypeDs = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['rowid', 'name'])
	});

	ueJobTypeDs.on('beforeload', function(ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
					url : itemGridUrl+'?action=caljobtype&str='+"",method:'POST'});
				});

	var ueJobTypeField = new Ext.form.ComboBox({
	    id:'ueJobTypeField',
		name:'ueJobTypeField',
		fieldLabel : '��λ����',
		store : ueJobTypeDs,
		displayField : 'name',
		valueField : 'rowid',
		typeAhead : true,
		forceSelection : true,
		triggerAction : 'all',
		//emptyText : '',
		width:180,
		listWidth : 250,
		pageSize : 10,
		minChars : 1,
		selectOnFocus : true,
		labelSeparator:''
	});
	var uTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��Ժְ��'], ['2', '�о���'], ['3', 'Ժ����Ա']]
	});
	var uTypeField = new Ext.form.ComboBox({
	    id : 'uTypeField',
		fieldLabel : '�û�����',
		width:180,
		listwidth:180,
		store : uTypeDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		//emptyText:'��ѡ��...',
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});	
	var uSexDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��'], ['0', 'Ů']]
	});
	var uSexField = new Ext.form.ComboBox({
	    id : 'uSexField',
		fieldLabel : '�û��Ա�',
		width:180,
		listwidth:180,
		store : uSexDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		//emptyText:'��ѡ��...',
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});	
	var uBirthDayField = new Ext.form.DateField({
		id: 'uBirthDayField',
		fieldLabel: '�û�����',
		width:180,
		listWidth : 245,

		triggerAction: 'all',
		//emptyText:'',
		name: 'uBirthDayField',
		//format:"Y-m-d",
		//value:"Y-m-d",
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uIDNumField = new Ext.form.TextField({
		id: 'uIDNumField',
		fieldLabel: '���֤��',
		width:180,
		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uIDNumField',
		regex:/(^\d{18}$)|(^\d{17}(\d|X)$)/,
		regexText:"���֤��ʽ����ȷ",
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var titleinfods = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['rowid', 'name'])
	});

	titleinfods.on('beforeload', function(ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
					url : itemGridUrl+'?action=Caltitleinfo', 
                    method:'POST'
				});
	});

	var uTitleDrField = new Ext.form.ComboBox({
		fieldLabel : '����ְ��',
		store : titleinfods,
		displayField : 'name',
		valueField : 'rowid',
		typeAhead : true,
		forceSelection : true,
		triggerAction : 'all',
		//emptyText : '',
		width:180,
		listWidth : 250,
		pageSize : 10,
		minChars : 1,
		selectOnFocus : true,
		labelSeparator:''
	});
	var uPhoneField = new Ext.form.TextField({
		id: 'uPhoneField',
		fieldLabel: '�绰����',
		width:180,

		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uPhoneField',
		regex:/[0-9]/,
		regexText:"�绰����ֻ��Ϊ����",
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uEMailField = new Ext.form.TextField({
		id: 'uEMailField',
		fieldLabel: '�����ַ',
		width:180,
		listWidth : 245,

		triggerAction: 'all',
		//emptyText:'',
		name: 'uEMailField',

		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var degree = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'], ['2', '�ڶ��о���'],['3','�о���']]
	});
	var uDegreeField = new Ext.form.ComboBox({
		id: 'uDegreeField',
		fieldLabel: '�û�ѧλ',
		width:180,
		listwidth:180,
		store : degree,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		//emptyText:'��ѡ��...',
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});

	
	var PerionDs1 = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});


PerionDs1.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmuserexe.csp'+'?action=GetPerion&str='+encodeURIComponent(Ext.getCmp('uCompDRField').getRawValue()),method:'POST'});
});

var uCompDRField= new Ext.form.ComboBox({
	id: 'uCompDRField',
	fieldLabel: '�û�����',
	width:180,
	listWidth : 250,
	//allowBlank: false,
	store:PerionDs1,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	name: 'uCompDRField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});
	var uMonographNumField = new Ext.form.TextField({
		id: 'uMonographNumField',
		fieldLabel: '����ר��',
		width:180,
		//allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uMonographNumField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uPaperNumField = new Ext.form.TextField({
		id: 'uPaperNumField',
		fieldLabel: '��������',
		width:180,
		//allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uPaperNumField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uPatentNumField = new Ext.form.TextField({
		id: 'uPatentNumField',
		fieldLabel: 'ר��',
		width:180,
		//allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uPatentNumField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uInvInCustomStanNumField = new Ext.form.TextField({
		id: 'uInvInCustomStanNumField',
		fieldLabel: '���Ƽ�����׼',
		width:180,
		//allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uInvInCustomStanNumField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var uTrainNumField = new Ext.form.TextField({
		id: 'uTrainNumField',
		fieldLabel: '�����˲�',
		width:180,
		//allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uTrainNumField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var uHoldTrainNumField = new Ext.form.TextField({
		id: 'uHoldTrainNumField',
		fieldLabel: '�ٰ���ѵ��',
		width:180,
		//allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uHoldTrainNumField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var uInTrainingNumField = new Ext.form.TextField({
		id: 'uInTrainingNumField',
		fieldLabel: '������ѵ��',
		width:180,
		//allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uInTrainingNumField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
	var ueIsTeacherDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['N', 'û��'], ['Y', '��']]
	});
	var ueIsTeacherField = new Ext.form.ComboBox({
	    id : 'ueIsTeacherField',
		fieldLabel : '��ʦ�ʸ�',
		width:180,
		listwidth:180,
		store : ueIsTeacherDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		//emptyText:'��ѡ��...',
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});
	var ueIsExpertDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['N', '��'], ['Y', '��']]
	});
	var ueIsExpertField = new Ext.form.ComboBox({
	    id : 'ueIsExpertField',
		fieldLabel : '�Ƿ�ר��',
		width:180,
		listwidth:180,
		store : ueIsExpertDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		//emptyText:'��ѡ��...',
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});
	var ueEthicalExpertsDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['N', '��'], ['Y', '��']]
	});
	var ueEthicalExpertsField = new Ext.form.ComboBox({
	    id : 'ueEthicalExpertsField',
		fieldLabel : '�Ƿ�����ר��',
		width:180,
		listwidth:180,
		store : ueEthicalExpertsDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		//emptyText:'��ѡ��...',
		selectOnFocus:true,
		forceSelection : true,
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
	var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.5',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								/* {
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									}, */
								  // RecordTypeField,
                   uCodeField, 
                   uNameField,  
				   ueJobTypeField,
				   uTitleDrField,
                   uTypeField,  
                   uSexField, 
                   uBirthDayField
                   
                   
                                 
								]	 
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									/* {
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									}, */
									uIDNumField,
                                    uPhoneField,
                                    uEMailField,
									uDegreeField,
									uCompDRField,
								    ueIsExpertField,
									ueIsTeacherField
								    //ueEthicalExpertsField
									]
									/* 
									eIsdriectField
									uMonographNumField,
									uPaperNumField,
									uPatentNumField,
									uInvInCustomStanNumField,
									uTrainNumField,
									uHoldTrainNumField,
									uInTrainingNumField */
																
								
							 }]
					}
				]			
	var formPanel = new Ext.form.FormPanel({
			//baseCls : 'x-plain',
			labelWidth : 90,
			labelAlign: 'right',
			frame: true,
			items: colItems
			//items : [uCodeField,uNameField,uTypeField,uSexField,uBirthDayField,uIDNumField,uTitleDrField,uPhoneField,uEMailField,uDegreeField,uCompDRField,uMonographNumField,uPaperNumField,uPatentNumField,uInvInCustomStanNumField,uTrainNumField,uHoldTrainNumField,uInTrainingNumField]
		});
				                                                                                            //
    //������
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                              //
			this.getForm().loadRecord(rowObj[0]);
			//alert(rowObj[0].get("Sex"));
			uCodeField.setValue(rowObj[0].get("Code"));	
			uNameField.setValue(rowObj[0].get("Name"));	
			var type=rowObj[0].get("Type");
			if (type=='��Ժְ��'){type=1;}else if(type=='�о���'){type=2;}else if(type=='Ժ����Ա'){type=3;}
			uTypeField.setValue(type);
			var sex=rowObj[0].get("Sex");
			if (sex=='��'){sex=1;}else if(sex=='Ů'){sex=0;}
			uSexField.setValue(sex);
			uBirthDayField.setValue(rowObj[0].get("BirthDay"));
			uIDNumField.setValue(rowObj[0].get("IDNum"));
			uTitleDrField.setRawValue(rowObj[0].get("TitleDr"));
			uPhoneField.setValue(rowObj[0].get("Phone"));
			uEMailField.setValue(rowObj[0].get("EMail"));
			var Degree=rowObj[0].get("Degree");
			if (Degree=='����'){Degree=1;}else if(Degree=='�ڶ��о���'){Degree=2;}else if(Degree=='�о���'){type=3;}
			uDegreeField.setValue(Degree);
			uCompDRField.setRawValue(rowObj[0].get("Compdr"));
			if(rowObj[0].get("IsValid")=="Y"){eIsdriectField.setValue(true);}
			
			ueIsTeacherField.setValue(rowObj[0].get("IsTeacher"));
			ueIsTeacherField.setRawValue(rowObj[0].get("IsTeacher"));
			ueIsExpertField.setValue(rowObj[0].get("IsExpert"));
			ueIsExpertField.setRawValue(rowObj[0].get("IsExpert"));
			ueEthicalExpertsField.setValue(rowObj[0].get("EthicalExperts"));
			ueEthicalExpertsField.setRawValue(rowObj[0].get("EthicalExperts"));
			
			var jobtype = rowObj[0].get("JobType");
	        ueJobTypeField.setRawValue(jobtype);  
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
				var type = uTypeField.getValue();
				var sex = uSexField.getValue();

				var birthday = uBirthDayField.getRawValue();
				 if (birthday!=="")
				    {
					 //birthday=birthday.format ('Y-m-d');
				    }

				var idnum = uIDNumField.getValue();
				var titledr = uTitleDrField.getValue();
				var phone = uPhoneField.getValue();
				var email = uEMailField.getValue();
				var degree = uDegreeField.getValue();
				var compdr = uCompDRField.getValue();
				var jobtype = ueJobTypeField.getValue();
				
			    var isteacher = ueIsTeacherField.getValue();
			    if(isteacher=="û��"){isteacher="N"}
				if(isteacher=="��"){isteacher="Y"}    
				var isexpert = ueIsExpertField.getValue();
			    if(isexpert=="��"){isexpert="N"}
				if(isexpert=="��"){isexpert="Y"} 
				var ethicalexperts = ueEthicalExpertsField.getValue();
			    if(ethicalexperts=="��"){ethicalexperts="N"}
				if(ethicalexperts=="��"){ethicalexperts="Y"}  
				
				/* var monographnum = uMonographNumField.getValue();
				var papernum = uPaperNumField.getValue();
				var patentnum = uPatentNumField.getValue();
				var invincustomstanNum = uInvInCustomStanNumField.getValue();
				var trainnum = uTrainNumField.getValue();
				var holdtrainnum = uHoldTrainNumField.getValue();
				var intrainingnum = uInTrainingNumField.getValue(); */
				
				var monographnum = "";
				var papernum = "";
				var patentnum = "";
				var invincustomstanNum = "";
				var trainnum = "";
				var holdtrainnum = "";
				var intrainingnum = "";
				
				var IsValid = "";
			    if (Ext.getCmp('eIsdriectField').checked) {IsValid="Y";}
			    else { IsValid="N";}
				
				
				var Code = rowObj[0].get("Code");     
				var Name = rowObj[0].get("Name");     
				var Type = rowObj[0].get("Type");     
				var Sex = rowObj[0].get("Sex");     
				var BirthDay = rowObj[0].get("BirthDay");     
				var IDNum = rowObj[0].get("IDNum");     
				var TitleDr = rowObj[0].get("TitleDr");     
				var Phone = rowObj[0].get("Phone");     
				var EMail = rowObj[0].get("EMail");     
				var Degree = rowObj[0].get("Degree");     
				var Compdr = rowObj[0].get("Compdr"); 
				var isvalid = rowObj[0].get("isvalid"); 
				var JobType = rowObj[0].get("JobType");
				
				
				//alert(jobtype);
				//alert(JobType);
				
				if(Code==code){code="";}
				if(Name==name){name="";}
				if(Type==type){type="";}
				if(Sex==sex){sex="";}
				if(BirthDay==birthday){birthday="";}
				if(IDNum==idnum){idnum="";}
				if(TitleDr==titledr){titledr="";}
				if(Phone==phone){phone="";}
				if(EMail==email){email="";}
				if(Degree==degree){degree="";}
				if(Compdr==compdr){compdr="";}
				
				if(isvalid==IsValid){IsValid="";}
				if(jobtype==JobType){jobtype="";}
				

				
				if(idnum!=""){
				if (!/(^\d{18}$)|(^\d{17}(\d|X)$)/.test(idnum)){Ext.Msg.show({title:'����',msg:'���֤�Ÿ�ʽ����ȷ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
				}
			    if(phone!=""){
				if (!/^((0\d{2,3}-\d{7,8})|(1\d{10}))$/.test(phone)){Ext.Msg.show({title:'����',msg:'�绰����ֻ����"����-����"��11λ�ֻ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
			    }
			  // var data=rowid+"^"+code+"^"+name+"^"+type+"^"+sex+"^"+birthday+"^"+idnum+"^"+titledr+"^"+phone+"^"+email+"^"+degree+"^"+compdr+"^"+monographnum+"^"+papernum+"^"+patentnum+"^"+invincustomstanNum+"^"+trainnum+"^"+holdtrainnum+"^"+intrainingnum
           
                Ext.Ajax.request({
				url:'herp.srm.srmuserexe.csp?action=edit&rowid='+rowid+'&code='+encodeURIComponent(code)
				+'&name='+encodeURIComponent(name)+'&type='+encodeURIComponent(type)+'&sex='+encodeURIComponent(sex)+'&birthday='+encodeURIComponent(birthday)+'&idnum='+encodeURIComponent(idnum)
				+'&titledr='+encodeURIComponent(titledr)+'&phone='+encodeURIComponent(phone)+'&email='+encodeURIComponent(email)+'&degree='+encodeURIComponent(degree)+'&compdr='+encodeURIComponent(compdr)+'&monographnum='+encodeURIComponent(monographnum)
				+'&papernum='+encodeURIComponent(papernum)+'&patentnum='+encodeURIComponent(patentnum)+'&invincustomstanNum='+encodeURIComponent(invincustomstanNum)+'&trainnum='+encodeURIComponent(trainnum)
				+'&holdtrainnum='+encodeURIComponent(holdtrainnum)+'&intrainingnum='+encodeURIComponent(intrainingnum)+'&IsValid='+IsValid+'&jobtype='+jobtype
				+'&isteacher='+encodeURIComponent(isteacher)+'&isexpert='+encodeURIComponent(isexpert)+'&ethicalexperts='+encodeURIComponent(ethicalexperts),
				
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
					var message="�ظ����";
					if(jsonData.info=='RepCode') message="����ظ���";
					if(jsonData.info=='RepName') message="�����ظ���";
					if(jsonData.info=='RepBirthDay') message="���ղ��ܴ��ڵ�ǰ���ڣ�";
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
			title: '�޸Ŀ�����Ա��Ϣ',
			iconCls: 'pencil',
			width : 630,
			height : 340,    
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
