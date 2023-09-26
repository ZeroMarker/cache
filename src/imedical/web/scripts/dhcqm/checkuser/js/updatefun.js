updatefun = function(){	
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var code="",name="",active="",rowid="",DR="";
	if(len<1){
		Ext.Msg.show({
							title : '注意',
							msg : '请选择需要修改的数据!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
					});
		return;
	}else{
	var flag=0;
	var name = rowObj[0].get("name");
	var active = rowObj[0].get("active");
	if(active=="是"){
		active="Y";
	}else{
		active="N";
	}
	
var newnamefieldDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

newnamefieldDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'dhc.qm.checkuserexe.csp'+'?action=GetUser',method:'POST'});
});
var newnamefield = new Ext.form.ComboBox({
	id: 'newnamefield',
	fieldLabel: '名称',
	width:150,
	listWidth : 200,
	allowBlank: true,
	store:newnamefieldDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	value:name,
	emptyText:'请选择名称...',
	name: 'newnamefield',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners:{
		change:function(){
			flag=1;
		}
	}
});


var ActiveStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['Y', '是'], ['N', '否']]
		});
var Active = new Ext.form.ComboBox({
			id:'Active',
			fieldLabel : '是否有效',
			width : 150,
			listWidth : 200,
			selectOnFocus : true,
			allowBlank : false,
			store : ActiveStore,
			name:'Active',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			value:active,
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
             	items: [
				   			newnamefield,							   
				   			Active

				 		]	 
			});
	
///addwin的添加按钮
addButton = new Ext.Toolbar.Button({
		text:'修改'
	});
			
	//////////////////////////  增加按钮响应函数   //////////////////////////////
addHandler = function(){    
				 var DR = rowObj[0].get("CheckDr");
				 var rowid = rowObj[0].get("rowid");		   	     
		   		 var newname = newnamefield.getValue();
		   		 var checktive = Active.getValue(); 
				 if (newname==""){
						Ext.Msg.show({title:'错误',msg:'请填写名称!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return false;
				 }
			   Ext.Ajax.request({
					url: '../csp/dhc.qm.checkuserexe.csp?action=update&rowid='+rowid+'&newname='+encodeURIComponent(newname)+'&checktive='+checktive+'&flag='+flag,				
					waitMsg:'保存中...',
					failure: function(result, request){											
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
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
							Ext.Msg.show({title:'修改失败',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
			title: '修改',
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
}


