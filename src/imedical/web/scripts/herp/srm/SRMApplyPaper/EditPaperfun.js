   var projUrl = 'herp.srm.srmapplypaperexe.csp';
   EditPaperfun = function(participantsids) {
	
	    var rowObj = itemGrid.getSelectionModel().getSelections();  
	    var rowid=rowObj[0].get("rowid");
		var oldprjdr=rowObj[0].get("PrjDR");
		var oldrecordtype=rowObj[0].get("RecordTypeDR");
		var oldJNameID=rowObj[0].get("JNameID");
		var oldFristAuthorNameID=rowObj[0].get("FristAuthorNameID");
		var oldContentID=rowObj[0].get("ContentID");
		var oldIsMultiContributionID=rowObj[0].get("IsMultiContributionID");
		var oldIsKeepSecretID=rowObj[0].get("IsKeepSecretID");
		var oldtypeid=rowObj[0].get("TypeID");
		//������Ŀ
		/*
		var addtitleText = new Ext.form.TextField({
			fieldLabel:'������Ŀ',
			width : 150,
			allowBlank : false,
			selectOnFocus : true,
			labelSeparator:''
		});
		*/
var addtitleText = new Ext.form.TextArea
(
	{
		fieldLabel: '��������',
		width: 150,
		allowBlank: false,
		selectOnFocus: true,
		labelSeparator: ''
	}
);
		
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
			         url : projUrl+'?action=JournalList&str='+encodeURIComponent(Ext.getCmp('MagazineField').getRawValue()),
			         method : 'POST'
				});
		});
		var MagazineField = new Ext.form.ComboBox({
		            id:'MagazineField',
			        name:'MagazineField',
			        fieldLabel : '�ڿ�����',
					store : JournalDs,
					displayField : 'name',
					valueField : 'rowid',
					//typeAhead : true,
					allowBlank : false, 
					forceSelection : true,
					triggerAction : 'all',
					//emptyText : '',
					width : 150,
					value:oldJNameID,
					listWidth : 260,
                    editable:true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
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
					fieldLabel : '������ʽ',
					width : 150,
					listWidth : 150,
					selectOnFocus : true,
					store : ContentStore,
					//anchor : '90%',
					value:oldContentID, //Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					//emptyText : '',
					mode : 'local', // ����ģʽ
					editable : true,
					pageSize : 10,
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
					fieldLabel : '��һ(ͨѶ)���� ',
					store : userDs,
					displayField : 'name',
					valueField : 'rowid',
					//typeAhead : true,
					allowBlank : false, 
					forceSelection : true,
					triggerAction : 'all',
					//emptyText : '',
					width : 150,
					listWidth : 260,
                    editable:true,
					value:oldFristAuthorNameID,
					pageSize : 10,
					minChars : 1,
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
						//anchor: '90%',
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
					store : IsMultiContributionStore,
					//anchor : '90%',
					value:'2', //Ĭ��ֵ
					disabled:true,
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					value:oldIsMultiContributionID,
					//emptyText : '',
					mode : 'local', // ����ģʽ
					editable : false,
					pageSize : 10,
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
					value:oldIsKeepSecretID, //Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					//emptyText : '',
					mode : 'local', // ����ģʽ
					editable : false,
					pageSize : 10,
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
					allowBlank : true,
					store : PrjNameDs,
					//anchor : '90%',
					value:oldprjdr, //Ĭ��ֵ
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
var eOutPrjNameField = new Ext.form.TextField({
	fieldLabel:'������Ŀ(Ժ��)',
	width : 150,
	allowBlank : true,
	selectOnFocus : true,
	labelSeparator:''
});




		///////////////////����/////////////////////////////  
var eTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var eTypeCombox = new Ext.form.ComboBox({
	                   id : 'eTypeCombox',
		           fieldLabel : '����',
	                   width : 150,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : eTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           value:oldtypeid,
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
						   eTypeCombox,
		                   addtitleText, 
		                   MagazineField,
		                   AuthorCombo
		                   //PressField,              
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
											
											IsMultiContribution,
		                   					ContentField,
											IsKeepSecret,
											PrjNameField,
											eOutPrjNameField					
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
			
					//������
		
				formPanel.on('afterlayout', function(panel, layout){
					this.getForm().loadRecord(rowObj[0]);
					addtitleText.setValue(rowObj[0].get("Title"));
					MagazineField.setRawValue(rowObj[0].get("JName"));
					ContentField.setRawValue(rowObj[0].get("Content"));
					AuthorCombo.setRawValue(rowObj[0].get("FristAuthorName"));
					//ParticipantsFields.setRawValue(rowObj[0].get("ParticipantsName"));
					IsMultiContribution.setRawValue(rowObj[0].get("IsMultiContribution"));
					IsKeepSecret.setRawValue(rowObj[0].get("IsKeepSecret"));
					PrjNameField.setRawValue(rowObj[0].get("PrjName"));
					PressField.setRawValue(rowObj[0].get("PressName"));
					eTypeCombox.setRawValue(rowObj[0].get("Type"));
					eOutPrjNameField.setValue(rowObj[0].get("OutPrjName"))
				});
		
		///addwin����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
				text:'����',
				iconCls: 'save'
			});
					
			//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
		addHandler = function(){
						var title = addtitleText.getValue(); 	
						///��־�硢����
						var magazine = MagazineField.getValue(); 
						var content = ContentField.getValue(); 
						var author = AuthorCombo.getValue(); 
					  
						///һ���Ͷ�����ܡ���ͬ��
						var ismulticontribution = IsMultiContribution.getValue(); 
						var iskeepsecret = IsKeepSecret.getValue(); 	
						var prjdr = PrjNameField.getValue(); 
						var pressdr = PressField.getValue();
						var type = eTypeCombox.getValue();
						
						var outprjname = eOutPrjNameField.getValue();
						
				  if (eTypeCombox.getRawValue()==""){
		        	Ext.Msg.show({title:'��ʾ',msg:'���Ͳ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		        	return;
		        	}
					
		          if (MagazineField.getRawValue()==""){
		        	Ext.Msg.show({title:'��ʾ',msg:'�ڿ����Ʋ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		        	return;
		        	}
		        	
		          if (title==""){
		        	Ext.Msg.show({title:'��ʾ',msg:'������Ŀ����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		        	return;
		        	}
		       if (AuthorCombo.getRawValue()==""){
		        	Ext.Msg.show({title:'��ʾ',msg:'���߲���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		        	return;
		        	}
                        //alert("magazine :"+magazine +"author: "+author );
		        /* var titlebf=rowObj[0].get("Title");
		        var authorbf=rowObj[0].get("FristAuthorName");
		        var magazinebf=rowObj[0].get("JName");
		        //var participantsbf=rowObj[0].get("ParticipantsName");
		        var contentbf=rowObj[0].get("Content");
		        var ismulticontributionbf=rowObj[0].get("IsMultiContribution");
		        var iskeepsecretbf=rowObj[0].get("IsKeepSecret");
		        var prjdrbf=rowObj[0].get("PrjDR");
		        var pressdrbf=rowObj[0].get("PressName");
		        var typebf=rowObj[0].get("Type");
		        
		        var outprjnamebf=rowObj[0].get("OutPrjName");
				 
				if(titlebf==title){title="";}
		        if(authorbf==author){author="";}
		        if(magazinebf==magazine){magazine="";}
		        if(contentbf==content){content="";}
		        if(ismulticontributionbf==ismulticontribution){ismulticontribution="";}
		        if(iskeepsecretbf==iskeepsecret){iskeepsecret="";}
		        if(prjdrbf==prjdr){prjdr="";}
		        if(pressdrbf==pressdr){pressdr="";}
				if(typebf==type){type="";} 
				if(outprjnamebf==outprjname){outprjname=""}
				*/
				
					   Ext.Ajax.request({
							url: '../csp/herp.srm.srmapplypaperexe.csp?action=update&rowid='+rowid+'&Title='+encodeURIComponent(title)+'&Author='+author+'&Magazine='+magazine+'&Content='+content+'&IsMultiContribution='+ismulticontribution+'&IsKeepSecret='+iskeepsecret+'&PrjDr='+prjdr+'&PressDR='+pressdr+'&Type='+type+'&OutPrjName='+encodeURIComponent(outprjname),
							waitMsg:'������...',
							failure: function(result, request){
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								//alert(result.responseText)
		            //alert(jsonData);
								if (jsonData.success=='true'){
									//var apllycode = jsonData.info;
									Ext.Msg.show({title:'ע��',msg:'������Ϣ�޸ĳɹ����������Ⱥ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
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
					//}
					editwin.close();
		   }
			////// ��Ӽ����¼� ////////////////	
		addButton.addListener('click',addHandler,false);
		
		
		///addwin��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
					text:'�ر�',
					iconCls : 'cancel'
				});
		cancelHandler = function(){
					editwin.close();
				}
		cancelButton.addListener('click',cancelHandler,false);
		
		editwin = new Ext.Window({
					title: '�޸�����Ͷ��������Ϣ',
					iconCls: 'pencil',
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
		editwin.show();		
			
}
