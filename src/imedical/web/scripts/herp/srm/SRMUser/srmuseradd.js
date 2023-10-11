

srmdeptuserAddFun = function() {


	var uCodeField = new Ext.form.TextField({
		id: 'uCodeField',
		fieldLabel: '�û�����',
		width:180,
		allowBlank: false,
		listWidth : 260,
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
		allowBlank: false,
		listWidth : 260,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uNameField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
////////////////////////��λ����--����20151103///////////////////////////
	var uaJobTypeDs = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['rowid', 'name'])
	});

	uaJobTypeDs.on('beforeload', function(ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
					url : itemGridUrl+'?action=caljobtype&str='+encodeURIComponent(Ext.getCmp('uaJobTypeField').getRawValue()),method:'POST'});
				});

	var uaJobTypeField = new Ext.form.ComboBox({
	    id:'uaJobTypeField',
		name:'uaJobTypeField',
		fieldLabel : '��λ����',
		store : uaJobTypeDs,
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
//	var uTitleDrField = new Ext.form.TextField({
//		id: 'uTitleDrField',
//		fieldLabel: '����ְ��',
//		width:180,
//
//		listWidth : 245,
//		triggerAction: 'all',
//		emptyText:'',
//		name: 'uTitleDrField',
//		minChars: 1,
//		pageSize: 10,
//		editable:true
//	});
	var uPhoneField = new Ext.form.TextField({
		id: 'uPhoneField',
		fieldLabel: '�绰����',
		width:180,

		//listWidth : 245,
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
	
	/*var uCompDRField = new Ext.form.TextField({
		id: 'uCompDRField',
		fieldLabel: '�û���λ',
		width:180,
		//allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uCompDRField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});*/
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
	fieldLabel: '�û���λ',
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
		editable:true,
		labelSeparator:''
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
		editable:true,
		labelSeparator:''
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
		editable:true,
		labelSeparator:''
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
	
	var uIsTeacherDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['N', 'û��'], ['Y', '��']]
	});
	var uIsTeacherField = new Ext.form.ComboBox({
	    id : 'uIsTeacherField',
		fieldLabel : '��ʦ�ʸ�',
		width:180,
		listwidth:180,
		store : uIsTeacherDs,
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
	var uIsExpertDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['N', '��'], ['Y', '��']]
	});
	var uIsExpertField = new Ext.form.ComboBox({
	    id : 'uIsExpertField',
		fieldLabel : '�Ƿ�ר��',
		width:180,
		listwidth:180,
		store : uIsExpertDs,
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
	var uEthicalExpertsDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['N', '��'], ['Y', '��']]
	});
	var uEthicalExpertsField = new Ext.form.ComboBox({
	    id : 'uEthicalExpertsField',
		fieldLabel : '�Ƿ�����ר��',
		width:180,
		listwidth:180,
		store : uEthicalExpertsDs,
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
var aIsdriectField = new Ext.form.Checkbox({
                        id:'aIsdriectField',
						name:'aIsdriectField',
						fieldLabel : '�Ƿ���Ч'
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
				                     uaJobTypeField,
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
								    uIsExpertField,
									uIsTeacherField
								    //uEthicalExpertsField
									]
									/* 
									aIsdriectField
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
	
	var addWin = new Ext.Window({
		    
			title : '����������Ա��Ϣ',
			iconCls: 'edit_add',
			width : 630,
			height : 340,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '����',
				iconCls: 'save',
				handler : function() {
					if (formPanel.form.isValid()) {
					var code = uCodeField.getValue();
					var name = uNameField.getValue();
					var type = uTypeField.getValue();
					var sex = uSexField.getValue();
					var birthday = uBirthDayField.getRawValue();

					//alert(birthday);
					
					 if (birthday!=="")
					    {
						 //birthday=birthday.format ('Y-m-d');
						 //bdzjz1=$zdh(birthday,3);
						 //birthday=$zdh(birthday,3);
						 //alert(birthday);
					    }
					    //alert(birthday);

					var idnum = uIDNumField.getValue();
					var titledr = uTitleDrField.getValue();
					var phone = uPhoneField.getValue();
					var email = uEMailField.getValue();
					var degree = uDegreeField.getValue();
					var compdr = uCompDRField.getValue();
					var isteacher = uIsTeacherField.getValue();
					var isexpert = uIsExpertField.getValue();
					var ethicalexperts = uEthicalExpertsField.getValue();
					
							    					    					    					
					/* 
					var monographnum = uMonographmField.getValue();
					var papernum = uPaperNumField.getValue();
					var patentnum = uPatentNumField.getValue();
					var invincustomstanNum = uInvInCustomStanNumField.getValue();
					var trainnum = uTrainNumField.getValue();
					var holdtrainnum = uHoldTrainNumField.getValue();
					var InTrainingNum = uInTrainingNumField.getValue(); */
					var monographnum = "";
					var papernum = "";
					var patentnum = "";
					var invincustomstanNum = "";
					var trainnum = "";
					var holdtrainnum = "";
					var InTrainingNum = "";
					
					/*
					var IsValid = "";
			        if (Ext.getCmp('aIsdriectField').checked) {IsValid="Y";}
			        else { IsValid="N";}
			        */
			        var IsValid="Y";
					
					if(idnum!=""){
						if (!/(^\d{18}$)|(^\d{17}(\d|X)$)/.test(idnum)){Ext.Msg.show({title:'����',msg:'���֤�Ÿ�ʽ����ȷ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
						}
					    if(phone!=""){
						if (!/^((0\d{2,3}-\d{7,8})|(1\d{10}))$/.test(phone)){Ext.Msg.show({title:'����',msg:'�绰����ֻ����"����-����"��11λ�ֻ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
					    }
						var jobtype=uaJobTypeField.getValue();
						
						
				Ext.Ajax.request({
					url:'herp.srm.srmuserexe.csp?action=add&code='+encodeURIComponent(code)
					+'&name='+encodeURIComponent(name)+'&type='+type+'&sex='+encodeURIComponent(sex)+'&birthday='+encodeURIComponent(birthday)+'&idnum='+encodeURIComponent(idnum)
					+'&titledr='+encodeURIComponent(titledr)+'&phone='+encodeURIComponent(phone)+'&email='+encodeURIComponent(email)+'&degree='+encodeURIComponent(degree)+'&compdr='+encodeURIComponent(compdr)+'&monographnum='+encodeURIComponent(monographnum)
					+'&papernum='+encodeURIComponent(papernum)+'&patentnum='+encodeURIComponent(patentnum)+'&invincustomstanNum='+encodeURIComponent(invincustomstanNum)+'&trainnum='+encodeURIComponent(trainnum)
					+'&holdtrainnum='+encodeURIComponent(holdtrainnum)+'&InTrainingNum='+encodeURIComponent(InTrainingNum)+'&IsValid='+IsValid+'&jobtype='+jobtype
					+'&isteacher='+encodeURIComponent(isteacher)+'&isexpert='+encodeURIComponent(isexpert)+'&ethicalexperts='+encodeURIComponent(ethicalexperts),
					waitMsg:'������...',
					failure: function(result, request){		
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:25}});
						}
						else
						{	var message="�ظ����aaa";
						    if(jsonData.info=='RecordExist') message="��¼�ظ�";
							if(jsonData.info=='RepCode') message="����ظ���";
							if(jsonData.info=='RepID') message="���֤�����ظ���";
							if(jsonData.info=='RepBirthDay') message="���ղ��ܴ��ڵ�ǰ���ڣ�";
							
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : '�ر�',
				iconCls : 'cancel',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
