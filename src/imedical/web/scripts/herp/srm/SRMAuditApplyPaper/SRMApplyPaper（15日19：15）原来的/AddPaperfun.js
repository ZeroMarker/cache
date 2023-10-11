AddPaperfun = function() {

		var projUrl = 'herp.srm.srmapplypaperexe.csp';
		var userkdr   = session['LOGON.USERID'];	
		//var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		//var len = rowObj.length;


//������Ŀ
var addtitleText = new Ext.form.TextField({
	fieldLabel:'������Ŀ',
	width : 100,
	selectOnFocus : true
});

var SubUserText = new Ext.form.TextField({
	fieldLabel:'������',
	width : 100,
	selectOnFocus : true
});
SubUserText.setValue(userkdr);

//��¼���ݿ������
var RecordTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', 'SCIE'], ['2', 'CSTPCD'], ['3', '����']]
		});
var RecordTypeField = new Ext.form.ComboBox({
			fieldLabel : '��������',
			width : 100,
			listWidth : 100,
			selectOnFocus : true,
			allowBlank : false,
			store : RecordTypeStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
		
//�ڿ�����
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
			fieldLabel : '�ڿ�����',
			width : 100,
			listWidth : 100,
			selectOnFocus : true,
			allowBlank : false,
			store : JournalDs,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//������ʽ
var PTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '����'], ['2', '����']]
		});
var PTypeField = new Ext.form.ComboBox({
			fieldLabel : '������ʽ',
			width : 100,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : PTypeStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//��һ����
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
			fieldLabel : '��һ���� ',
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
									Ext.Msg.show({title:'����',msg:'��һ���߲���Ϊ��!',buttons: 
                  Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
								}
              }
						}
			});	
		
///////////////////��һ���߿���/////////////////////////////  
var FAuthorDeptCombo = new Ext.form.TextField({
				fieldLabel: '��һ���߿���',
				width:180,
				allowBlank : false, 
				anchor: '95%',
				selectOnFocus:'true'
			});	
	
		
//���е�һ����		
var addTFAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : '���е�һ���� ',
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
		
///////////////////���е�һ���߿���/////////////////////////////  
var TFAuthorDeptCombo = new Ext.form.TextField({
				fieldLabel: '���е�һ���߿���',
				width:180,
				allowBlank : false, 
				anchor: '95%',
				selectOnFocus:'true'
			});		
			
//��һ�����Ƿ�Ϊ�о���
var IsGraduateStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['Y', '��'], ['N', '��']]
		});
var IsGraduate = new Ext.form.ComboBox({
			fieldLabel : '��һ�����Ƿ�Ϊ�о���',
			width : 100,
			listWidth : 100,
			selectOnFocus : true,
			allowBlank : false,
			store : IsGraduateStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
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

//��ʦ1
var addMentor1Combo = new Ext.form.ComboBox({
			fieldLabel : '��ʦ1 ',
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
//��һ�����Ƿ�Ϊ��ҵ�������о���
var IsInTwoYearStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['Y', '��'], ['N', '��']]
		});
var IsInTwoYear = new Ext.form.ComboBox({
			fieldLabel : '��һ�����Ƿ�Ϊ�о���',
			width : 100,
			listWidth : 100,
			selectOnFocus : true,
			allowBlank : false,
			store : IsInTwoYearStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
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
//��ʦ2
var addMentor2Combo = new Ext.form.ComboBox({
			fieldLabel : '��ʦ2 ',
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
//ͨ������		
var addCorrAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : 'ͨ������ ',
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
									Ext.Msg.show({title:'����',msg:'ͨѶ���߲���Ϊ��!',buttons:
                  Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
								}
              }
						}
			});	
		
///////////////////ͨѶ���߿���/////////////////////////////  
var CorrAuthorDeptCombo = new Ext.form.TextField({
				fieldLabel: '��һ���߿���',
				width:180,
				allowBlank : false, 
				anchor: '95%',
				selectOnFocus:'true'
			});	
		
//����ͨѶ����
	var addTCAuthorCombo = new Ext.form.ComboBox({
			fieldLabel : '����ͨ������ ',
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
									Ext.Msg.show({title:'����',msg:'��Ų���Ϊ��!',buttons: 
                  Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
								}
              }
						}
			});	
		
///////////////////����ͨѶ���߿���/////////////////////////////  
var TCAuthorDeptCombo = new Ext.form.TextField({
				fieldLabel: '��һ���߿���',
				width:180,
				allowBlank : false, 
				anchor: '95%',
				selectOnFocus:'true'
			});	
		
		
//����
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
			fieldLabel : '�����˿�������',
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

//��������
var DateField = new Ext.form.DateField({
		id : 'DateField',
		fieldLabel:'��������',
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
	
///addwin����Ӱ�ť
addButton = new Ext.Toolbar.Button({
		text:'���'
	});
			
	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
addHandler = function(){      			
						
		    var recordtype = RecordTypeField.getValue(); 
				var addtitle = addtitleText.getValue(); 
				
				///�����ˡ����Ҽ���������
				var subuser = SubUserText.getValue();   
				var subdept = subdeptCombo.getValue(); 
				var subdate = DateField.getRawValue(); 
				
				///�ڿ����Ƽ���������
				var journalname = JournalField.getValue(); 
				var ptype = PTypeField.getValue(); 
				
				///��һ���߼�����
				var addfristAuthor = addFristAuthorCombo.getValue(); 
				var fAuthordept = FAuthorDeptCombo.getValue(); 
				
				///���е�һ���߼�����
				var addtfAuthor = addTFAuthorCombo.getValue();
				var tfAuthordept = TFAuthorDeptCombo.getValue();
				 
				///�Ƿ��о�������ʦ
				var isgraduate = IsGraduate.getValue(); 
				var addMentor1 = addMentor1Combo.getValue(); 
				var isintwoyears = IsInTwoYear.getValue(); 	
				var addMentor2 = addMentor2Combo.getValue(); 
				
			  ///ͨѶ���߼�����
        var addcorrAuthor = addCorrAuthorCombo.getValue();
        var corrAuthordept = CorrAuthorDeptCombo.getValue(); 
        
        ///����ͨѶ���߼�����
        var addtcorrAuthor = addTCAuthorCombo.getValue();
        var tcAuthordept = TCAuthorDeptCombo.getValue(); 
       
       var data=recordtype+"^"+addtitle+"^"+subuser+"^"+subdept+"^"+subdate+"^"+journalname+"^"+ptype+"^"+addfristAuthor+"^"+addtfAuthor+"^"+isgraduate+"^"+addMentor1+"^"+isintwoyears+"^"+addMentor2+"^"+addcorrAuthor+"^"+addtcorrAuthor
       alert(data)
       ////Insert(RecordType, DeptDr, Title, JournalDR, PType, FristAuthor, FAuthorDept, TFAuthor, TFAuthorDept, IsGraduate, Mentor1, IsInTwoYear, Mentor2, CorrAuthor, CorrAuthorDept, TCAuthor, TCAuthorDept, SubUser, SubDate  encodeURIComponent(data)
				if(formPanel.form.isValid()){
			   Ext.Ajax.request({
					//url: '../csp/herp.srm.srmapplypaperexe.csp?action=add&RecordType='+recordtype+'&DeptDr='+subdept+'&Title='+addtitle+'&JournalDR='+journalname+'&PType='+ptype+'&FristAuthor='+addfristAuthor+'&FAuthorDept='+fAuthordept+'&TFAuthor='+addtfAuthor+'&TFAuthorDept='+tfAuthordept+'&IsGraduate='+isgraduate+'&Mentor1='+addMentor1+'&IsInTwoYear='+isintwoyears+'&Mentor2='+addMentor2+'&CorrAuthor='+addcorrAuthor+'&CorrAuthorDept='+corrAuthordept+'&TCAuthor='+addtcorrAuthor+'&TCAuthorDept='+tcAuthordept+'&TCAuthor='+addtcorrAuthor+'&SubUser='+subuser+'&SubDate='+subdate,
					url: '../csp/herp.srm.srmapplypaperexe.csp?action=add&RecordType='+recordtype+'&Title='+addtitle+'&JournalDR='+journalname+'&PType='+ptype+'&FristAuthor='+addfristAuthor+'&TFAuthor='+addtfAuthor+'&IsGraduate='+isgraduate+'&Mentor1='+addMentor1+'&IsInTwoYear='+isintwoyears+'&Mentor2='+addMentor2+'&CorrAuthor='+addcorrAuthor+'&TCAuthor='+addtcorrAuthor+'&SubUser='+subuser+'&SubDate='+subdate,
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
            alert(jsonData);
						if (jsonData.success=='true'){
							//var apllycode = jsonData.info;
							Ext.Msg.show({title:'ע��',msg:'������Ϣ��ӳɹ����������Ⱥ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
									 itemGrid.load({params:{start:0,limit:25}});		
						}else
						{
							var message="";
							if(jsonData.info=='RepApply') message='�ظ����룬��������������ڿ���!';
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
			addwin.close();
   }
	////// ��Ӽ����¼� ////////////////	
addButton.addListener('click',addHandler,false);


///addwin��ȡ����ť
cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
cancelHandler = function(){
			addwin.close();
		}
cancelButton.addListener('click',cancelHandler,false);

addwin = new Ext.Window({
			title: '��������',
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


