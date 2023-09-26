function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
addFun = function(jxUnitDr,personDs,personGrid,personPagingToolbar){
	var userDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});

	userDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'../csp/dhc.pa.jxinpersonexe.csp?action=user&str='+encodeURIComponent(Ext.getCmp('userField').getRawValue()),method:'POST'})
	});

	var userField = new Ext.form.ComboBox({
		id: 'userField',
		fieldLabel: '内部人员',
		width:213,
		listWidth : 213,
        allowBlank: false,
		store: userDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择内部人员...',
		name: 'userField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(userField.getValue()!=""){
						remarkField.focus();
					}else{
						Handler = function(){userField.focus();}
						Ext.Msg.show({title:'错误',msg:'绩效方案不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	var remarkField = new Ext.form.TextField({
		id:'remarkField',
		fieldLabel: '人员备注',
		allowBlank: true,
		width:150,
		listWidth : 150,
		emptyText:'人员备注...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					addButton.focus();
				}
			}
		}
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth:100,
		items: [
			userField,
			remarkField
		]
	});
	
	var addButton = new Ext.Toolbar.Button({
		text:'添加'
	});
			
	//添加处理函数
	var addHandler = function(){
		var userDr = Ext.getCmp('userField').getValue();
		var remark = Ext.getCmp('remarkField').getValue();
		Ext.Ajax.request({
			url:'../csp/dhc.pa.jxinpersonexe.csp?action=add&jxUnitDr='+jxUnitDr+'&userDr='+userDr+'&remark='+encodeURIComponent(remark),
			waitMsg:'添加中..',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					personDs.load({params:{start:0, limit:personPagingToolbar.pageSize,jxUnitDr:jxUnitDr,dir:'asc',sort:'rowid'}});
				}else{
					if(jsonData.info=='RepRecode'){
						Handler = function(){userField.focus();}
						Ext.Msg.show({title:'提示',msg:'数据记录重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
					}
					if(jsonData.info=='NoUser'){
						Handler = function(){userField.focus();}
						Ext.Msg.show({title:'提示',msg:'没有用户记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
					}
					if(jsonData.info=='NoUnit'){
						Handler = function(){userField.focus();}
						Ext.Msg.show({title:'提示',msg:'没有绩效单元!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
					}
				}
			},
			scope: this
		});
	}

	//添加按钮的响应事件
	addButton.addListener('click',addHandler,false);

	//定义取消按钮
	var cancelButton = new Ext.Toolbar.Button({
		text:'取消'
	});

	//取消处理函数
	var cancelHandler = function(){
		win.close();
	}

	//取消按钮的响应事件
	cancelButton.addListener('click',cancelHandler,false);

	var win = new Ext.Window({
		title: '添加内部人员',
		width: 380,
		height:200,
		minWidth: 380,
		minHeight: 200,
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
	win.show();
}