

srmdeptuserEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
	}
	

	var uCodeField = new Ext.form.TextField({
		id: 'uCodeField',
		fieldLabel: '用户编码',
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
		fieldLabel: '用户名称',
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
	////////////////////////岗位性质--新增20151103///////////////////////////
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
		fieldLabel : '岗位性质',
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
	var uPhoneField = new Ext.form.TextField({
		id: 'uPhoneField',
		fieldLabel: '电话号码',
		width:180,

		listWidth : 245,
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
	fieldLabel: '用户依托',
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
		editable:true
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
		editable:true
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
		editable:true
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
	
	var ueIsTeacherDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['N', '没有'], ['Y', '有']]
	});
	var ueIsTeacherField = new Ext.form.ComboBox({
	    id : 'ueIsTeacherField',
		fieldLabel : '教师资格',
		width:180,
		listwidth:180,
		store : ueIsTeacherDs,
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
	var ueIsExpertDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['N', '否'], ['Y', '是']]
	});
	var ueIsExpertField = new Ext.form.ComboBox({
	    id : 'ueIsExpertField',
		fieldLabel : '是否专家',
		width:180,
		listwidth:180,
		store : ueIsExpertDs,
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
	var ueEthicalExpertsDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['N', '否'], ['Y', '是']]
	});
	var ueEthicalExpertsField = new Ext.form.ComboBox({
	    id : 'ueEthicalExpertsField',
		fieldLabel : '是否伦理专家',
		width:180,
		listwidth:180,
		store : ueEthicalExpertsDs,
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
var eIsdriectField = new Ext.form.Checkbox({
                        id:'eIsdriectField',
						name:'eIsdriectField',
						fieldLabel : '是否有效',
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
    //面板加载
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                              //
			this.getForm().loadRecord(rowObj[0]);
			//alert(rowObj[0].get("Sex"));
			uCodeField.setValue(rowObj[0].get("Code"));	
			uNameField.setValue(rowObj[0].get("Name"));	
			var type=rowObj[0].get("Type");
			if (type=='本院职工'){type=1;}else if(type=='研究生'){type=2;}else if(type=='院外人员'){type=3;}
			uTypeField.setValue(type);
			var sex=rowObj[0].get("Sex");
			if (sex=='男'){sex=1;}else if(sex=='女'){sex=0;}
			uSexField.setValue(sex);
			uBirthDayField.setValue(rowObj[0].get("BirthDay"));
			uIDNumField.setValue(rowObj[0].get("IDNum"));
			uTitleDrField.setRawValue(rowObj[0].get("TitleDr"));
			uPhoneField.setValue(rowObj[0].get("Phone"));
			uEMailField.setValue(rowObj[0].get("EMail"));
			var Degree=rowObj[0].get("Degree");
			if (Degree=='本科'){Degree=1;}else if(Degree=='在读研究生'){Degree=2;}else if(Degree=='研究生'){type=3;}
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
    
	    //定义并初始化保存修改按钮
	    var editButton = new Ext.Toolbar.Button({
				text:'保存',
				iconCls: 'save'
			});                                                                                                                                            //
                    
		        //定义修改按钮响应函数
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
			    if(isteacher=="没有"){isteacher="N"}
				if(isteacher=="有"){isteacher="Y"}    
				var isexpert = ueIsExpertField.getValue();
			    if(isexpert=="否"){isexpert="N"}
				if(isexpert=="是"){isexpert="Y"} 
				var ethicalexperts = ueEthicalExpertsField.getValue();
			    if(ethicalexperts=="否"){ethicalexperts="N"}
				if(ethicalexperts=="是"){ethicalexperts="Y"}  
				
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
				if (!/(^\d{18}$)|(^\d{17}(\d|X)$)/.test(idnum)){Ext.Msg.show({title:'错误',msg:'身份证号格式不正确!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
				}
			    if(phone!=""){
				if (!/^((0\d{2,3}-\d{7,8})|(1\d{10}))$/.test(phone)){Ext.Msg.show({title:'错误',msg:'电话号码只能是"区号-号码"或11位手机号',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
			    }
			  // var data=rowid+"^"+code+"^"+name+"^"+type+"^"+sex+"^"+birthday+"^"+idnum+"^"+titledr+"^"+phone+"^"+email+"^"+degree+"^"+compdr+"^"+monographnum+"^"+papernum+"^"+patentnum+"^"+invincustomstanNum+"^"+trainnum+"^"+holdtrainnum+"^"+intrainingnum
           
                Ext.Ajax.request({
				url:'herp.srm.srmuserexe.csp?action=edit&rowid='+rowid+'&code='+encodeURIComponent(code)
				+'&name='+encodeURIComponent(name)+'&type='+encodeURIComponent(type)+'&sex='+encodeURIComponent(sex)+'&birthday='+encodeURIComponent(birthday)+'&idnum='+encodeURIComponent(idnum)
				+'&titledr='+encodeURIComponent(titledr)+'&phone='+encodeURIComponent(phone)+'&email='+encodeURIComponent(email)+'&degree='+encodeURIComponent(degree)+'&compdr='+encodeURIComponent(compdr)+'&monographnum='+encodeURIComponent(monographnum)
				+'&papernum='+encodeURIComponent(papernum)+'&patentnum='+encodeURIComponent(patentnum)+'&invincustomstanNum='+encodeURIComponent(invincustomstanNum)+'&trainnum='+encodeURIComponent(trainnum)
				+'&holdtrainnum='+encodeURIComponent(holdtrainnum)+'&intrainingnum='+encodeURIComponent(intrainingnum)+'&IsValid='+IsValid+'&jobtype='+jobtype
				+'&isteacher='+encodeURIComponent(isteacher)+'&isexpert='+encodeURIComponent(isexpert)+'&ethicalexperts='+encodeURIComponent(ethicalexperts),
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});		
				}
				else
					{
					var message="重复添加";
					if(jsonData.info=='RepCode') message="编号重复！";
					if(jsonData.info=='RepName') message="名称重复！";
					if(jsonData.info=='RepBirthDay') message="生日不能大于当前日期！";
					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				
				};
			},
				scope: this
			});
			editwin.close();
		};
		//添加保存修改按钮的监听事件
		editButton.addListener('click',editHandler,false);
	
		//定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
			text:'关闭',
			iconCls : 'cancel'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改科研人员信息',
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
		//窗口显示
		editwin.show();
	};
