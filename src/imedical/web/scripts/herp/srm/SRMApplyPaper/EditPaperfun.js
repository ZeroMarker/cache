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
		//论文题目
		/*
		var addtitleText = new Ext.form.TextField({
			fieldLabel:'论文题目',
			width : 150,
			allowBlank : false,
			selectOnFocus : true,
			labelSeparator:''
		});
		*/
var addtitleText = new Ext.form.TextArea
(
	{
		fieldLabel: '论文名称',
		width: 150,
		allowBlank: false,
		selectOnFocus: true,
		labelSeparator: ''
	}
);
		
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
			         url : projUrl+'?action=JournalList&str='+encodeURIComponent(Ext.getCmp('MagazineField').getRawValue()),
			         method : 'POST'
				});
		});
		var MagazineField = new Ext.form.ComboBox({
		            id:'MagazineField',
			        name:'MagazineField',
			        fieldLabel : '期刊名称',
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
		//出版社
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
					fieldLabel : '出版社名称',
					width : 150,
					listWidth : 260,
					selectOnFocus : true,
					store : PressDs,
					//anchor : '90%',
					// value:'key', //默认值
					valueNotFoundText : '',
					displayField : 'name',
					valueField : 'rowid',
					triggerAction : 'all',
					//emptyText : '',
					//mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					disabled:true,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});		
		//内容
		var ContentStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['1', '真实'], ['2', '欠真实'],['3', '不真实']]
				});
		var ContentField = new Ext.form.ComboBox({
					fieldLabel : '发表形式',
					width : 150,
					listWidth : 150,
					selectOnFocus : true,
					store : ContentStore,
					//anchor : '90%',
					value:oldContentID, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					//emptyText : '',
					mode : 'local', // 本地模式
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});
		//作者
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
					fieldLabel : '第一(通讯)作者 ',
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
				
		///////////////////作者科室/////////////////////////////  
		var AuthorDeptCombo = new Ext.form.TextField({
						fieldLabel: '作者科室',
						width:150,
						allowBlank : false, 
						//anchor: '90%',
						selectOnFocus:'true',
						labelSeparator:''
					});	
			
		
		//一稿多投
		var IsMultiContributionStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['1', '是'], ['2', '否']]
				});
		var IsMultiContribution = new Ext.form.ComboBox({
					fieldLabel : '是否一稿多投',
					width : 150,
					listWidth : 150,
					selectOnFocus : true,
					store : IsMultiContributionStore,
					//anchor : '90%',
					value:'2', //默认值
					disabled:true,
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					value:oldIsMultiContributionID,
					//emptyText : '',
					mode : 'local', // 本地模式
					editable : false,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
							 });	
		
		//设计保密
		var IsKeepSecretStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['1', '是'], ['2', '否']]
				});
		var IsKeepSecret = new Ext.form.ComboBox({
					fieldLabel : '是否涉及保密',
					width : 150,
					listWidth : 150,
					selectOnFocus : true,
					//allowBlank : false,
					store : IsKeepSecretStore,
					//anchor : '90%',
					value:oldIsKeepSecretID, //默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					//emptyText : '',
					mode : 'local', // 本地模式
					editable : false,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
							 });	
		////课题名称
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
					fieldLabel : '依托项目',
					width : 150,
					listWidth : 260,
					selectOnFocus : true,
					allowBlank : true,
					store : PrjNameDs,
					//anchor : '90%',
					value:oldprjdr, //默认值
					valueNotFoundText : '',
					displayField : 'name',
					valueField : 'rowid',
					triggerAction : 'all',
					//emptyText : '',
					//mode : 'local', // 本地模式
					name:'PrjNameField',
					editable : true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					labelSeparator:''
				});
				
///院外依托课题
var eOutPrjNameField = new Ext.form.TextField({
	fieldLabel:'依托项目(院外)',
	width : 150,
	allowBlank : true,
	selectOnFocus : true,
	labelSeparator:''
});




		///////////////////类型/////////////////////////////  
var eTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '科研'],['2', '教学']]
	});		
		
var eTypeCombox = new Ext.form.ComboBox({
	                   id : 'eTypeCombox',
		           fieldLabel : '类型',
	                   width : 150,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : eTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : '选择...',
		           mode : 'local', // 本地模式
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
			
					//面板加载
		
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
		
		///addwin的添加按钮
		addButton = new Ext.Toolbar.Button({
				text:'保存',
				iconCls: 'save'
			});
					
			//////////////////////////  增加按钮响应函数   //////////////////////////////
		addHandler = function(){
						var title = addtitleText.getValue(); 	
						///杂志社、内容
						var magazine = MagazineField.getValue(); 
						var content = ContentField.getValue(); 
						var author = AuthorCombo.getValue(); 
					  
						///一稿多投、保密、合同号
						var ismulticontribution = IsMultiContribution.getValue(); 
						var iskeepsecret = IsKeepSecret.getValue(); 	
						var prjdr = PrjNameField.getValue(); 
						var pressdr = PressField.getValue();
						var type = eTypeCombox.getValue();
						
						var outprjname = eOutPrjNameField.getValue();
						
				  if (eTypeCombox.getRawValue()==""){
		        	Ext.Msg.show({title:'提示',msg:'类型不可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		        	return;
		        	}
					
		          if (MagazineField.getRawValue()==""){
		        	Ext.Msg.show({title:'提示',msg:'期刊名称不可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		        	return;
		        	}
		        	
		          if (title==""){
		        	Ext.Msg.show({title:'提示',msg:'论文题目不可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		        	return;
		        	}
		       if (AuthorCombo.getRawValue()==""){
		        	Ext.Msg.show({title:'提示',msg:'作者不可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
							waitMsg:'保存中...',
							failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								//alert(result.responseText)
		            //alert(jsonData);
								if (jsonData.success=='true'){
									//var apllycode = jsonData.info;
									Ext.Msg.show({title:'注意',msg:'申请信息修改成功，请稍作等候!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
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
					//}
					editwin.close();
		   }
			////// 添加监听事件 ////////////////	
		addButton.addListener('click',addHandler,false);
		
		
		///addwin的取消按钮
		cancelButton = new Ext.Toolbar.Button({
					text:'关闭',
					iconCls : 'cancel'
				});
		cancelHandler = function(){
					editwin.close();
				}
		cancelButton.addListener('click',cancelHandler,false);
		
		editwin = new Ext.Window({
					title: '修改论文投稿申请信息',
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
