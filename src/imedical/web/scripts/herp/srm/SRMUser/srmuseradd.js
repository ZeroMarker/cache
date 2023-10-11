

srmdeptuserAddFun = function() {


	var uCodeField = new Ext.form.TextField({
		id: 'uCodeField',
		fieldLabel: '用户编码',
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
		fieldLabel: '用户名称',
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
////////////////////////岗位性质--新增20151103///////////////////////////
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
		fieldLabel : '岗位性质',
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
		data : [['1', '本院职工'], ['2', '研究生'], ['3', '院外人员']]
	});
	var uTypeField = new Ext.form.ComboBox({
	    id : 'uTypeField',
		fieldLabel : '用户类型',
		width:180,
		listwidth:180,
		store : uTypeDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		//emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});	
	var uSexDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '男'], ['0', '女']]
	});
	var uSexField = new Ext.form.ComboBox({
	    id : 'uSexField',
		fieldLabel : '用户性别',
		width:180,
		listwidth:180,
		store : uSexDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		//emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});	
	var uBirthDayField = new Ext.form.DateField({
		id: 'uBirthDayField',
		fieldLabel: '用户生日',
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
		fieldLabel: '身份证号',
		width:180,
		listWidth : 245,

		triggerAction: 'all',
		//emptyText:'',
		name: 'uIDNumField',
		regex:/(^\d{18}$)|(^\d{17}(\d|X)$)/,
		regexText:"身份证格式不正确",
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
		fieldLabel : '技术职称',
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
//		fieldLabel: '技术职称',
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
		fieldLabel: '电话号码',
		width:180,

		//listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uPhoneField',
		regex:/[0-9]/,
		regexText:"电话号码只能为数字",
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uEMailField = new Ext.form.TextField({
		id: 'uEMailField',
		fieldLabel: '邮箱地址',
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
		data : [['1', '本科'], ['2', '在读研究生'],['3','研究生']]
	});
	var uDegreeField = new Ext.form.ComboBox({
		id: 'uDegreeField',
		fieldLabel: '用户学位',
		width:180,
		listwidth:180,
		store : degree,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		//emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});
	
	/*var uCompDRField = new Ext.form.TextField({
		id: 'uCompDRField',
		fieldLabel: '用户单位',
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
	fieldLabel: '用户单位',
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
		fieldLabel: '出版专著',
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
		fieldLabel: '发表论文',
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
		fieldLabel: '专利',
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
		fieldLabel: '定制技术标准',
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
		fieldLabel: '培养人才',
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
		fieldLabel: '举办培训班',
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
		fieldLabel: '参与培训班',
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
		data : [['N', '没有'], ['Y', '有']]
	});
	var uIsTeacherField = new Ext.form.ComboBox({
	    id : 'uIsTeacherField',
		fieldLabel : '教师资格',
		width:180,
		listwidth:180,
		store : uIsTeacherDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		//emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});
	var uIsExpertDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['N', '否'], ['Y', '是']]
	});
	var uIsExpertField = new Ext.form.ComboBox({
	    id : 'uIsExpertField',
		fieldLabel : '是否专家',
		width:180,
		listwidth:180,
		store : uIsExpertDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		//emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});
	var uEthicalExpertsDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['N', '否'], ['Y', '是']]
	});
	var uEthicalExpertsField = new Ext.form.ComboBox({
	    id : 'uEthicalExpertsField',
		fieldLabel : '是否伦理专家',
		width:180,
		listwidth:180,
		store : uEthicalExpertsDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		//emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});
	
/////////////////////是否有效/////////////////////////////
var aIsdriectField = new Ext.form.Checkbox({
                        id:'aIsdriectField',
						name:'aIsdriectField',
						fieldLabel : '是否有效'
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
		    
			title : '新增科研人员信息',
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
				text : '保存',
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
						if (!/(^\d{18}$)|(^\d{17}(\d|X)$)/.test(idnum)){Ext.Msg.show({title:'错误',msg:'身份证号格式不正确!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
						}
					    if(phone!=""){
						if (!/^((0\d{2,3}-\d{7,8})|(1\d{10}))$/.test(phone)){Ext.Msg.show({title:'错误',msg:'电话号码只能是"区号-号码"或11位手机号!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
					    }
						var jobtype=uaJobTypeField.getValue();
						
						
				Ext.Ajax.request({
					url:'herp.srm.srmuserexe.csp?action=add&code='+encodeURIComponent(code)
					+'&name='+encodeURIComponent(name)+'&type='+type+'&sex='+encodeURIComponent(sex)+'&birthday='+encodeURIComponent(birthday)+'&idnum='+encodeURIComponent(idnum)
					+'&titledr='+encodeURIComponent(titledr)+'&phone='+encodeURIComponent(phone)+'&email='+encodeURIComponent(email)+'&degree='+encodeURIComponent(degree)+'&compdr='+encodeURIComponent(compdr)+'&monographnum='+encodeURIComponent(monographnum)
					+'&papernum='+encodeURIComponent(papernum)+'&patentnum='+encodeURIComponent(patentnum)+'&invincustomstanNum='+encodeURIComponent(invincustomstanNum)+'&trainnum='+encodeURIComponent(trainnum)
					+'&holdtrainnum='+encodeURIComponent(holdtrainnum)+'&InTrainingNum='+encodeURIComponent(InTrainingNum)+'&IsValid='+IsValid+'&jobtype='+jobtype
					+'&isteacher='+encodeURIComponent(isteacher)+'&isexpert='+encodeURIComponent(isexpert)+'&ethicalexperts='+encodeURIComponent(ethicalexperts),
					waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:25}});
						}
						else
						{	var message="重复添加aaa";
						    if(jsonData.info=='RecordExist') message="记录重复";
							if(jsonData.info=='RepCode') message="编号重复！";
							if(jsonData.info=='RepID') message="身份证号码重复！";
							if(jsonData.info=='RepBirthDay') message="生日不能大于当前日期！";
							
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : '关闭',
				iconCls : 'cancel',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
