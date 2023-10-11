AddPaperfun = function() {

		var projUrl = 'herp.srm.srmapplypaperexe.csp';
		var userkdr = session['LOGON.USERID'];
		var username = session['LOGON.USERCODE'];

//������Ŀ
/*
var titleText = new Ext.form.TextField({
	fieldLabel:'��������',
	width : 150,
	allowBlank : false,
	selectOnFocus : true,
	labelSeparator:''
});
*/
var titleText = new Ext.form.TextArea
(
	{
		fieldLabel: '��������',
		width: 150,
		allowBlank: false,
		selectOnFocus: true,
		labelSeparator: ''
	}
);
	
//�ڿ�
var JournalDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
JournalDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=JournalList&str='+encodeURIComponent(Ext.getCmp('MagazineField').getRawValue()),
						method : 'POST'
					});
		});
var MagazineField = new Ext.form.ComboBox({
            id:'MagazineField',
			name:'MagazineField',
			fieldLabel : '�ڿ�����',
			width : 150,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : JournalDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			//emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''
		});
//������
var PressDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
PressDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=PressList',
						method : 'POST'
					});
		});
var PressField = new Ext.form.ComboBox({
			fieldLabel : '����������',
			width : 150,
			listWidth : 260,
			selectOnFocus : true,
			//allowBlank : false,
			store : PressDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			//emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			disabled:true,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''
		});
//����
var ContentStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��ʵ'], ['2', 'Ƿ��ʵ'],['3', '����ʵ']]
		});
var ContentField = new Ext.form.ComboBox({
			fieldLabel : '����',
			width : 150,
			listWidth : 150,
			selectOnFocus : true,
			//allowBlank : false,
			store : ContentStore,
			//anchor : '90%',
			value:'1', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''
		});
//����
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
var AuthorCombo = new Ext.form.ComboBox({
			fieldLabel : '��һ(ͨѶ)����',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '',
			width : 150,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			allowBlank : false,
			selectOnFocus : true,
			labelSeparator:'',
		    listeners : {
				    	 select:{
                       fn:function(combo,record,index) { 
                       Ext.Ajax.request({			        
                       url: '../csp/herp.srm.srmapplypaperexe.csp?action=UserDeptList&userdr='+AuthorCombo.getValue(),	
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
						         if (jsonData.success=='true'){
							         var data = jsonData.info;
                                     AuthorDeptCombo.setValue(data);          
					         	}
				         	},
					       scope: this
				      	});              
                  }
                }			
						}
			});	
		
///////////////////���߿���/////////////////////////////  
var AuthorDeptCombo = new Ext.form.TextField({
				fieldLabel: '���߿���',
				width:150,
				allowBlank : false, 
				disabled:true,
				selectOnFocus:'true',
				labelSeparator:''
			});	         
//һ���Ͷ
var IsMultiContributionStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��'], ['2', '��']]
		});
var IsMultiContribution = new Ext.form.ComboBox({
			fieldLabel : '�Ƿ�һ���Ͷ',
			width : 150,
			listWidth : 150,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsMultiContributionStore,
			//anchor : '90%',
			value:'2', //Ĭ��ֵ
			disabled:true,
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''
					 });	

//��Ʊ���
var IsKeepSecretStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��'], ['2', '��']]
		});
var IsKeepSecret = new Ext.form.ComboBox({
			fieldLabel : '�Ƿ��漰����',
			width : 150,
			listWidth : 150,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsKeepSecretStore,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''
					 });	
////��������
var PrjNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
PrjNameDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=GetPrjName&str='+encodeURIComponent(Ext.getCmp('PrjNameField').getRawValue()),
						method : 'POST'
					});
		});
var PrjNameField = new Ext.form.ComboBox({
	        id:'PrjNameField',
			fieldLabel : '������Ŀ',
			width : 150,
			listWidth : 260,
			selectOnFocus : true,
			//allowBlank : false,
			store : PrjNameDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			//emptyText : '',
			//mode : 'local', // ����ģʽ
			name:'PrjNameField',
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''
		});

///Ժ�����п���
var OutPrjNameField = new Ext.form.TextField({
	fieldLabel:'������Ŀ(Ժ��)',
	width : 150,
	allowBlank : true,
	selectOnFocus : true,
	labelSeparator:''
});





///////////////////����/////////////////////////////  
var aTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var aTypeCombox = new Ext.form.ComboBox({
	                   id : 'aTypeCombox',
		           fieldLabel : '����',
	                   width : 150,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : aTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''
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
								  // RecordTypeField,
								  aTypeCombox,
                                  titleText,    
                                  MagazineField,       
                                  AuthorCombo,
                                  AuthorDeptCombo,
                                  // ParticipantsGrid,
					              // ParticipantsFields,
					         {
						         columnWidth : 1,
						         xtype : 'panel',
						         layout : "column",
						         items : [{
							         xtype : 'displayfield',
							         columnWidth : .05
							       },
							       //addParticipants,
							       {
							       xtype : 'displayfield',	
							       columnWidth : .07
							       }
							      // delParticipants
							       ]
						        }                    
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
									//PressField,
									IsMultiContribution,
									ContentField,
									IsKeepSecret,
									PrjNameField,
									OutPrjNameField							
								]
							 }]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 120,
				labelAlign:'right',
				//layout: 'form',
				frame: true,
				items: colItems
			});
	
///addwin����Ӱ�ť
addButton = new Ext.Toolbar.Button({
		text:'����',
		iconCls: 'save'
	});
			
	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
addHandler = function(){      			
						
		        // var recordtype = RecordTypeField.getValue(); 
				//��������
				var title = titleText.getValue(); 
				
				///��־�硢����
				var magazine = MagazineField.getValue(); 
				var content = ContentField.getValue(); 
				
				///���߼�����
				var author = AuthorCombo.getValue(); 
				
				///��������
			 //var participants = ParticipantsNameField.getValue();
//       var ptotal = ParticipantsGrid.getStore().getCount();
//			  if(ptotal>0){
//				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
//				for(var i=1;i<ptotal;i++){
//				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
//				  prawValue = prawValue+","+prow;
//				  };
//			  }
//			  var participants = prawValue;
			  
				///һ���Ͷ����Ʊ���
				var ismulticontribution = IsMultiContribution.getValue(); 
				var iskeepsecret = IsKeepSecret.getValue(); 	
				var prjdr = PrjNameField.getValue(); 
				var pressdr = PressField.getValue();
				
				var type = aTypeCombox.getValue();
				
				var outprjname = OutPrjNameField.getValue();
				
			title = title.trim();
			
			
      		if(type=="")
      		{
      			Ext.Msg.show({title:'����',msg:'���Ͳ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(title=="")
      		{
      			Ext.Msg.show({title:'����',msg:'������Ŀ����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(magazine=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�ڿ����Ʋ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(author=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
    		
           if (formPanel.form.isValid()) {
			   Ext.Ajax.request({
					url: '../csp/herp.srm.srmapplypaperexe.csp?action=add&Title='+encodeURIComponent(title)+'&Author='+author+'&Magazine='+magazine+'&Content='+content+'&IsMultiContribution='+ismulticontribution+'&IsKeepSecret='+iskeepsecret+'&PrjDr='+prjdr+'&PressDR='+pressdr+'&SubUser='+userkdr+'&Type='+type+'&OutPrjName='+encodeURIComponent(outprjname),
					waitMsg:'������...',
					failure: function(result, request){
						
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'������Ϣ��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
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
					addwin.close();
			}
		
			else{
						Ext.Msg.show({title:'����', msg:'����д������ʾ��ɫ�ı������ݡ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}   
			
   }
	////// ��Ӽ����¼� ////////////////	
addButton.addListener('click',addHandler,false);


///addwin��ȡ����ť
cancelButton = new Ext.Toolbar.Button({
			text:'�ر�',
			iconCls : 'cancel'
		});
cancelHandler = function(){
			addwin.close();
		}
cancelButton.addListener('click',cancelHandler,false);

addwin = new Ext.Window({
			title: '��������Ͷ��������Ϣ',
			iconCls: 'edit_add',
			width: 640,
			height: 340,
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


