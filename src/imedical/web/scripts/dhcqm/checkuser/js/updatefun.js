updatefun = function(){	
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var code="",name="",active="",rowid="",DR="";
	if(len<1){
		Ext.Msg.show({
							title : 'ע��',
							msg : '��ѡ����Ҫ�޸ĵ�����!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
					});
		return;
	}else{
	var flag=0;
	var name = rowObj[0].get("name");
	var active = rowObj[0].get("active");
	if(active=="��"){
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
	fieldLabel: '����',
	width:150,
	listWidth : 200,
	allowBlank: true,
	store:newnamefieldDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	value:name,
	emptyText:'��ѡ������...',
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
			data : [['Y', '��'], ['N', '��']]
		});
var Active = new Ext.form.ComboBox({
			id:'Active',
			fieldLabel : '�Ƿ���Ч',
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
			mode : 'local', // ����ģʽ
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
	
///addwin����Ӱ�ť
addButton = new Ext.Toolbar.Button({
		text:'�޸�'
	});
			
	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
addHandler = function(){    
				 var DR = rowObj[0].get("CheckDr");
				 var rowid = rowObj[0].get("rowid");		   	     
		   		 var newname = newnamefield.getValue();
		   		 var checktive = Active.getValue(); 
				 if (newname==""){
						Ext.Msg.show({title:'����',msg:'����д����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return false;
				 }
			   Ext.Ajax.request({
					url: '../csp/dhc.qm.checkuserexe.csp?action=update&rowid='+rowid+'&newname='+encodeURIComponent(newname)+'&checktive='+checktive+'&flag='+flag,				
					waitMsg:'������...',
					failure: function(result, request){											
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							itemGridDs.load({
											params : {
														start : 0,
														limit : itemGridPagingToolbar.pageSize
													}
							});			
						}else
						{
							var message="";
							if(jsonData.info=='RepName') message='�����ظ�!';
							Ext.Msg.show({title:'�޸�ʧ��',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
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
			title: '�޸�',
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


