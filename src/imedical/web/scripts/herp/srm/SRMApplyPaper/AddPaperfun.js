AddPaperfun = function() {

		var projUrl = 'herp.srm.srmapplypaperexe.csp';
		var userkdr = session['LOGON.USERID'];
		var username = session['LOGON.USERCODE'];

//论文题目
/*
var titleText = new Ext.form.TextField({
	fieldLabel:'论文名称',
	width : 150,
	allowBlank : false,
	selectOnFocus : true,
	labelSeparator:''
});
*/
var titleText = new Ext.form.TextArea
(
	{
		fieldLabel: '论文名称',
		width: 150,
		allowBlank: false,
		selectOnFocus: true,
		labelSeparator: ''
	}
);
	
//期刊
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
			width : 150,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : JournalDs,
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
			selectOnFocus : true,
			forceSelection : true,
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
			//allowBlank : false,
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
			fieldLabel : '内容',
			width : 150,
			listWidth : 150,
			selectOnFocus : true,
			//allowBlank : false,
			store : ContentStore,
			//anchor : '90%',
			value:'1', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
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
			fieldLabel : '第一(通讯)作者',
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
		
///////////////////作者科室/////////////////////////////  
var AuthorDeptCombo = new Ext.form.TextField({
				fieldLabel: '作者科室',
				width:150,
				allowBlank : false, 
				disabled:true,
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
			//allowBlank : false,
			store : IsMultiContributionStore,
			//anchor : '90%',
			value:'2', //默认值
			disabled:true,
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
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
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
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
			//allowBlank : false,
			store : PrjNameDs,
			//anchor : '90%',
			// value:'key', //默认值
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
var OutPrjNameField = new Ext.form.TextField({
	fieldLabel:'依托项目(院外)',
	width : 150,
	allowBlank : true,
	selectOnFocus : true,
	labelSeparator:''
});





///////////////////类型/////////////////////////////  
var aTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '科研'],['2', '教学']]
	});		
		
var aTypeCombox = new Ext.form.ComboBox({
	                   id : 'aTypeCombox',
		           fieldLabel : '类型',
	                   width : 150,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : aTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : '选择...',
		           mode : 'local', // 本地模式
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
	
///addwin的添加按钮
addButton = new Ext.Toolbar.Button({
		text:'保存',
		iconCls: 'save'
	});
			
	//////////////////////////  增加按钮响应函数   //////////////////////////////
addHandler = function(){      			
						
		        // var recordtype = RecordTypeField.getValue(); 
				//论文名称
				var title = titleText.getValue(); 
				
				///杂志社、内容
				var magazine = MagazineField.getValue(); 
				var content = ContentField.getValue(); 
				
				///作者及科室
				var author = AuthorCombo.getValue(); 
				
				///作者排名
			 //var participants = ParticipantsNameField.getValue();
//       var ptotal = ParticipantsGrid.getStore().getCount();
//			  if(ptotal>0){
//				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
//				for(var i=1;i<ptotal;i++){
//				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
//				  prawValue = prawValue+","+prow;
//				  };
//			  }
//			  var participants = prawValue;
			  
				///一稿多投、设计保密
				var ismulticontribution = IsMultiContribution.getValue(); 
				var iskeepsecret = IsKeepSecret.getValue(); 	
				var prjdr = PrjNameField.getValue(); 
				var pressdr = PressField.getValue();
				
				var type = aTypeCombox.getValue();
				
				var outprjname = OutPrjNameField.getValue();
				
			title = title.trim();
			
			
      		if(type=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'类型不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(title=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'论文题目不可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(magazine=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'期刊名称不可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(author=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'作者为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
    		
           if (formPanel.form.isValid()) {
			   Ext.Ajax.request({
					url: '../csp/herp.srm.srmapplypaperexe.csp?action=add&Title='+encodeURIComponent(title)+'&Author='+author+'&Magazine='+magazine+'&Content='+content+'&IsMultiContribution='+ismulticontribution+'&IsKeepSecret='+iskeepsecret+'&PrjDr='+prjdr+'&PressDR='+pressdr+'&SubUser='+userkdr+'&Type='+type+'&OutPrjName='+encodeURIComponent(outprjname),
					waitMsg:'保存中...',
					failure: function(result, request){
						
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'申请信息添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
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
					addwin.close();
			}
		
			else{
						Ext.Msg.show({title:'错误', msg:'请填写完整显示红色的必填内容。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}   
			
   }
	////// 添加监听事件 ////////////////	
addButton.addListener('click',addHandler,false);


///addwin的取消按钮
cancelButton = new Ext.Toolbar.Button({
			text:'关闭',
			iconCls : 'cancel'
		});
cancelHandler = function(){
			addwin.close();
		}
cancelButton.addListener('click',cancelHandler,false);

addwin = new Ext.Window({
			title: '新增论文投稿申请信息',
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


