addfun = function(){	
var namefieldDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

namefieldDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'dhc.qm.checkuserexe.csp'+'?action=GetUser',method:'POST'});
});
var namefield = new Ext.form.ComboBox({
			fieldLabel : '名称',
			store : namefieldDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
});

var CheckActiveStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['Y', '是'], ['N', '否']]
		});
var CheckActive = new Ext.form.ComboBox({
			id:'CheckActive',
			fieldLabel : '是否有效',
			width : 150,
			listWidth : 200,
			selectOnFocus : true,
			allowBlank : false,
			store : CheckActiveStore,
			name:'CheckActive',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			//value:'1',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			minChars : 1,
			forceSelection : true
		});
		
			
			var formPanel = new Ext.form.FormPanel({
				height: 200,
              	width: 300,
             	 labelWidth: 60,
              	labelAlign: "right",
              	frame: true,
              	defaults:{
                 	xtype:"textfield",
                 	width:180
              	},
             	items: [namefield,CheckActive]	 
			});
	
///addwin的添加按钮
addButton = new Ext.Toolbar.Button({
		text:'添加'
	});
			
	//////////////////////////  增加按钮响应函数   //////////////////////////////
addHandler = function(){    
	
		   	     var name = namefield.getValue(); 
		   		 var active = CheckActive.getValue();	   		 	   		
				 if (name==""){
						Ext.Msg.show({title:'错误',msg:'请填写名称!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return false;
				 }      			
			   Ext.Ajax.request({
					url: '../csp/dhc.qm.checkuserexe.csp?action=add&name='+encodeURIComponent(name)+'&active='+encodeURIComponent(active),	
					waitMsg:'保存中...',
					failure: function(result, request){											
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'添加成功，请稍作等候!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							itemGridDs.load({
											params : {
														start : 0,
														limit : itemGridPagingToolbar.pageSize
													}
							});			
						}else
						{
							var message="";
							if(jsonData.info=='RepName') message='名称重复!';
							if(jsonData.info=='RepCode') message='编码重复!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
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
			title: '添加',
			width: 400,
			height: 200,
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


