function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
addFun = function(userDr,outDs,outPagingToolbar){
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel: '人员代码',
		allowBlank: false,
		width:150,
		listWidth : 150,
		emptyText:'接口人员代码...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(codeField.getValue()!=""){
						nameField.focus();
					}else{
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'错误',msg:'接口人员代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel: '人员名称',
		allowBlank: false,
		width:180,
		listWidth : 180,
		emptyText:'接口人员名称...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(nameField.getValue()!=""){
						interLocSetField.focus();
					}else{
						Handler = function(){nameField.focus();}
						Ext.Msg.show({title:'错误',msg:'接口人员名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});

	var interLocSetDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});

	interLocSetDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'../csp/dhc.pa.interpersonexe.csp?action=set&str='+encodeURIComponent(Ext.getCmp('interLocSetField').getRawValue()),method:'POST'})
	});

	var interLocSetField = new Ext.form.ComboBox({
		id: 'interLocSetField',
		fieldLabel: '所属接口套',
		width:213,
		listWidth : 213,
        allowBlank: false,
		store: interLocSetDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择接口套...',
		name: 'interLocSetField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(interLocSetField.getValue()!=""){
						remarkField.focus();
					}else{
						Handler = function(){interLocSetField.focus();}
						Ext.Msg.show({title:'错误',msg:'所属接口套不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
			codeField,
			nameField,
			interLocSetField,
			remarkField
		]
	});
	
	var addButton = new Ext.Toolbar.Button({
		text:'添加'
	});
			
	//添加处理函数
	var addHandler = function(){
		var code = Ext.getCmp('codeField').getValue();
		var name = Ext.getCmp('nameField').getValue();
		var interLocSetDr = Ext.getCmp('interLocSetField').getValue();
		var remark = Ext.getCmp('remarkField').getValue();
		
		code=trim(code);
		if(code==""){
			Ext.Msg.show({title:'提示',msg:'接口人员代码为空!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
			return false;
		}
		
		Ext.Ajax.request({
			url:'../csp/dhc.pa.interpersonexe.csp?action=add&inDr='+userDr+'&code='+code+'&name='+encodeURIComponent(name)+'&interLocSetDr='+interLocSetDr+'&remark='+encodeURIComponent(remark),
			waitMsg:'添加中..',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					outDs.load({params:{start:0, limit:outPagingToolbar.pageSize,inDr:userDr,dir:'asc',sort:'rowid'}});
				}else{
					if(jsonData.info=='RepRecode'){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'提示',msg:'数据记录重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
					}
					if(jsonData.info=='NoUser'){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'提示',msg:'没有内部人员记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
					}
					if(jsonData.info=='NoInterLocSetDr'){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'提示',msg:'没有接口套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
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