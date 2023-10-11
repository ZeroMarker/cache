AddPaperfun = function() {

		var projUrl = 'herp.srm.srmapplypaperexe.csp';
		var userkdr   = session['LOGON.USERID'];	
		//var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		//var len = rowObj.length;


//论文题目
var addtitleText = new Ext.form.TextField({
	fieldLabel:'论文题目',
	width : 100,
	selectOnFocus : true
});

var SubUserText = new Ext.form.TextField({
	fieldLabel:'申请人',
	width : 100,
	selectOnFocus : true
});
SubUserText.setValue(userkdr);

//收录数据库的类型
var RecordTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', 'SCIE'], ['2', 'CSTPCD'], ['3', '其他']]
		});
var RecordTypeField = new Ext.form.ComboBox({
			fieldLabel : '论文类型',
			width : 100,
			listWidth : 100,
			selectOnFocus : true,
			allowBlank : false,
			store : RecordTypeStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
		
//期刊名称
var JournalDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
JournalDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=JournalList',
						method : 'POST'
					});
		});
var JournalField = new Ext.form.ComboBox({
			fieldLabel : '期刊名称',
			width : 100,
			listWidth : 100,
			selectOnFocus : true,
			allowBlank : false,
			store : JournalDs,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//发表形式
var PTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '国内'], ['2', '国外']]
		});
var PTypeField = new Ext.form.ComboBox({
			fieldLabel : '发表形式',
			width : 100,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : PTypeStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//第一作者
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList',
						method : 'POST'
					});
		});
var addFristAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : '第一作者 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
		  listeners : {
				    	 select:{
                       fn:function(combo,record,index) { 
                       Ext.Ajax.request({			        
                       url: '../csp/herp.srm.srmapplypaperexe.csp?action=UserDeptList&userdr='+addFristAuthorCombo.getValue(),	
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
						         if (jsonData.success=='true'){
							         var data = jsonData.info;
                       FAuthorDeptCombo.setValue(data);          
					         	}
				         	},
					       scope: this
				      	});              
                  }
                },
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								if(addFristAuthorCombo.getValue()!=="")
								{	
									 addCorrAuthorCombo.focus();
								}else{
									Handler = function(){addFristAuthorCombo.focus();};
									Ext.Msg.show({title:'错误',msg:'第一作者不能为空!',buttons: 
                  Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
								}
              }
						}
			});	
		
///////////////////第一作者科室/////////////////////////////  
var FAuthorDeptCombo = new Ext.form.TextField({
				fieldLabel: '第一作者科室',
				width:180,
				allowBlank : false, 
				anchor: '95%',
				selectOnFocus:'true'
			});	
	
		
//并列第一作者		
var addTFAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : '并列第一作者 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
		  listeners : {
				    	 select:{
                       fn:function(combo,record,index) { 
                       Ext.Ajax.request({			        
                       url: '../csp/herp.srm.srmapplypaperexe.csp?action=UserDeptList&userdr='+addTFAuthorCombo.getValue(),	
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
						         if (jsonData.success=='true'){ 
							         var data = jsonData.info;
                       TFAuthorDeptCombo.setValue(data);          
					         	}
				         	},
					       scope: this
				      	});              
                  }
                },
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								if(addTFAuthorCombo.getValue()!=="")
								{	
									 IsGraduate.focus();
								}
								}
              }
						}
			});	
		
///////////////////并列第一作者科室/////////////////////////////  
var TFAuthorDeptCombo = new Ext.form.TextField({
				fieldLabel: '并列第一作者科室',
				width:180,
				allowBlank : false, 
				anchor: '95%',
				selectOnFocus:'true'
			});		
			
//第一作者是否为研究生
var IsGraduateStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['Y', '是'], ['N', '否']]
		});
var IsGraduate = new Ext.form.ComboBox({
			fieldLabel : '第一作者是否为研究生',
			width : 100,
			listWidth : 100,
			selectOnFocus : true,
			allowBlank : false,
			store : IsGraduateStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
	    listeners : {  
		           	select:{
                     fn:function(combo,record,index) { 
                   	if(IsGraduate.getValue()== "Y")
			                	{
				                       addMentor1Combo.enable();
                               
				                }
				             else
				             	{
				             		addMentor1Combo.disable();
				             		}
                  }
                },
			          specialKey : function(field, e) {
			                if (e.getKey() == Ext.EventObject.ENTER) {
			                	if(IsGraduate.getValue()== "Y")
			                	{
				                       addMentor1Combo.focus();
				                }
				                else
				                	{
				                		IsInTwoYear.focus();
				                	}
		                	} 
							  }
						  }
					 });	

//导师1
var addMentor1Combo = new Ext.form.ComboBox({
			fieldLabel : '导师1 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
//第一作者是否为毕业两年内研究生
var IsInTwoYearStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['Y', '是'], ['N', '否']]
		});
var IsInTwoYear = new Ext.form.ComboBox({
			fieldLabel : '第一作者是否为研究生',
			width : 100,
			listWidth : 100,
			selectOnFocus : true,
			allowBlank : false,
			store : IsInTwoYearStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
	    listeners : {  
		           	select:{
                     fn:function(combo,record,index) { 
                   	if(IsInTwoYear.getValue()== "Y")
			                	{
				                       addMentor2Combo.enable();
				                }
				             else
				             	{
				             		addMentor2Combo.disable();
				             		}
                  }
                },
			          specialKey : function(field, e) {
			                if (e.getKey() == Ext.EventObject.ENTER) {
			                 
				                       addCorrAuthorCombo.focus();								
		                	} 
							  }
						  }
					 });	
//导师2
var addMentor2Combo = new Ext.form.ComboBox({
			fieldLabel : '导师2 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
//通信作者		
var addCorrAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : '通信作者 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
	    listeners : {
				    	 select:{
                       fn:function(combo,record,index) { 
                       Ext.Ajax.request({			        
                       url: '../csp/herp.srm.srmapplypaperexe.csp?action=UserDeptList&userdr='+addCorrAuthorCombo.getValue(),	
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
						         if (jsonData.success=='true'){
							         var data = jsonData.info;
                       CorrAuthorDeptCombo.setValue(data);          
					         	}
				         	},
					       scope: this
				      	});              
                  }
                },
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								if(addCorrAuthorCombo.getValue()!=="")
								{	
									 CorrAuthorDeptCombo.focus();
								}else{
									Handler = function(){addCorrAuthorCombo.focus();};
									Ext.Msg.show({title:'错误',msg:'通讯作者不能为空!',buttons:
                  Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
								}
              }
						}
			});	
		
///////////////////通讯作者科室/////////////////////////////  
var CorrAuthorDeptCombo = new Ext.form.TextField({
				fieldLabel: '第一作者科室',
				width:180,
				allowBlank : false, 
				anchor: '95%',
				selectOnFocus:'true'
			});	
		
//并列通讯作者
	var addTCAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : '并列通信作者 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
		listeners : {
				    	 select:{
                       fn:function(combo,record,index) { 
                       Ext.Ajax.request({			        
                       url: '../csp/herp.srm.srmapplypaperexe.csp?action=UserDeptList&userdr='+addTCAuthorCombo.getValue(),	
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
						         if (jsonData.success=='true'){
							         var data = jsonData.info;
                       TCAuthorDeptCombo.setValue(data);          
					         	}
				         	},
					       scope: this
				      	});              
                  }
                },
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								if(addFristAuthorCombo.getValue()!=="")
								{	
									 CorrAuthor.focus();
								}else{
									Handler = function(){FristAuthor.focus();};
									Ext.Msg.show({title:'错误',msg:'序号不能为空!',buttons: 
                  Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
								}
              }
						}
			});	
		
///////////////////并列通讯作者科室/////////////////////////////  
var TCAuthorDeptCombo = new Ext.form.TextField({
				fieldLabel: '第一作者科室',
				width:180,
				allowBlank : false, 
				anchor: '95%',
				selectOnFocus:'true'
			});	
		
		
//科室
var subdeptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

subdeptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList&userdr='+userkdr, 
                        method:'POST'
					});
		});

var subdeptCombo = new Ext.form.ComboBox({
			fieldLabel : '申请人科室名称',
			store : subdeptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

//申请日期
var DateField = new Ext.form.DateField({
		id : 'DateField',
		fieldLabel:'申请日期',
		format : 'Y-m-d',
		width : 100,
		//allowBlank : false,
		emptyText : ''
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
								{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									},
									//uNameField,
									
									//uCodeField,
								   RecordTypeField,
                   addtitleText, 
                   SubUserText,  
                   subdeptCombo,  
                   DateField, 
                   JournalField,
                   PTypeField,
                   addFristAuthorCombo,
                   FAuthorDeptCombo,
                   addTFAuthorCombo,
                   TFAuthorDeptCombo              
								]	 
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									},
									IsGraduate,
									addMentor1Combo,
									IsInTwoYear,
									addMentor2Combo,
									addCorrAuthorCombo,
									CorrAuthorDeptCombo,
									addTCAuthorCombo,
									TCAuthorDeptCombo							
								]
							 }]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 90,
				//layout: 'form',
				frame: true,
				items: colItems
			});
	
///addwin的添加按钮
addButton = new Ext.Toolbar.Button({
		text:'添加'
	});
			
	//////////////////////////  增加按钮响应函数   //////////////////////////////
addHandler = function(){      			
						
		    var recordtype = RecordTypeField.getValue(); 
				var addtitle = addtitleText.getValue(); 
				
				///申请人、科室及申请日期
				var subuser = SubUserText.getValue();   
				var subdept = subdeptCombo.getValue(); 
				var subdate = DateField.getRawValue(); 
				
				///期刊名称及论文类型
				var journalname = JournalField.getValue(); 
				var ptype = PTypeField.getValue(); 
				
				///第一作者及科室
				var addfristAuthor = addFristAuthorCombo.getValue(); 
				var fAuthordept = FAuthorDeptCombo.getValue(); 
				
				///并列第一作者及科室
				var addtfAuthor = addTFAuthorCombo.getValue();
				var tfAuthordept = TFAuthorDeptCombo.getValue();
				 
				///是否研究生及导师
				var isgraduate = IsGraduate.getValue(); 
				var addMentor1 = addMentor1Combo.getValue(); 
				var isintwoyears = IsInTwoYear.getValue(); 	
				var addMentor2 = addMentor2Combo.getValue(); 
				
			  ///通讯作者及科室
        var addcorrAuthor = addCorrAuthorCombo.getValue();
        var corrAuthordept = CorrAuthorDeptCombo.getValue(); 
        
        ///并列通讯作者及科室
        var addtcorrAuthor = addTCAuthorCombo.getValue();
        var tcAuthordept = TCAuthorDeptCombo.getValue(); 
       
       var data=recordtype+"^"+addtitle+"^"+subuser+"^"+subdept+"^"+subdate+"^"+journalname+"^"+ptype+"^"+addfristAuthor+"^"+addtfAuthor+"^"+isgraduate+"^"+addMentor1+"^"+isintwoyears+"^"+addMentor2+"^"+addcorrAuthor+"^"+addtcorrAuthor
       alert(data)
       ////Insert(RecordType, DeptDr, Title, JournalDR, PType, FristAuthor, FAuthorDept, TFAuthor, TFAuthorDept, IsGraduate, Mentor1, IsInTwoYear, Mentor2, CorrAuthor, CorrAuthorDept, TCAuthor, TCAuthorDept, SubUser, SubDate  encodeURIComponent(data)
				if(formPanel.form.isValid()){
			   Ext.Ajax.request({
					//url: '../csp/herp.srm.srmapplypaperexe.csp?action=add&RecordType='+recordtype+'&DeptDr='+subdept+'&Title='+addtitle+'&JournalDR='+journalname+'&PType='+ptype+'&FristAuthor='+addfristAuthor+'&FAuthorDept='+fAuthordept+'&TFAuthor='+addtfAuthor+'&TFAuthorDept='+tfAuthordept+'&IsGraduate='+isgraduate+'&Mentor1='+addMentor1+'&IsInTwoYear='+isintwoyears+'&Mentor2='+addMentor2+'&CorrAuthor='+addcorrAuthor+'&CorrAuthorDept='+corrAuthordept+'&TCAuthor='+addtcorrAuthor+'&TCAuthorDept='+tcAuthordept+'&TCAuthor='+addtcorrAuthor+'&SubUser='+subuser+'&SubDate='+subdate,
					url: '../csp/herp.srm.srmapplypaperexe.csp?action=add&RecordType='+recordtype+'&Title='+addtitle+'&JournalDR='+journalname+'&PType='+ptype+'&FristAuthor='+addfristAuthor+'&TFAuthor='+addtfAuthor+'&IsGraduate='+isgraduate+'&Mentor1='+addMentor1+'&IsInTwoYear='+isintwoyears+'&Mentor2='+addMentor2+'&CorrAuthor='+addcorrAuthor+'&TCAuthor='+addtcorrAuthor+'&SubUser='+subuser+'&SubDate='+subdate,
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
            alert(jsonData);
						if (jsonData.success=='true'){
							//var apllycode = jsonData.info;
							Ext.Msg.show({title:'注意',msg:'申请信息添加成功，请稍作等候!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
									 itemGrid.load({params:{start:0,limit:25}});		
						}else
						{
							var message="";
							if(jsonData.info=='RepApply') message='重复申请，请更改论文名或期刊名!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
			addwin.close();
   }
	////// 添加监听事件 ////////////////	
addButton.addListener('click',addHandler,false);


///addwin的取消按钮
cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
cancelHandler = function(){
			addwin.close();
		}
cancelButton.addListener('click',cancelHandler,false);

addwin = new Ext.Window({
			title: '论文申请',
			width: 800,
			height: 600,
			//autoHeight: true,
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


