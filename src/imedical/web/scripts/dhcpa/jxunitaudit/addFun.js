addFun = function(store,pagingToolbar){
	var jxUnitDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitShortCut'])
	});

	

	var jxUnit = new Ext.ux.form.LovCombo({
		id:'jxUnit',
		fieldLabel:'绩效单元',
		width:213,
		listWidth : 213,
		allowBlank:true,
		store:jxUnitDs,
		valueField:'jxUnitDr',
		displayField:'jxUnitShortCut',
		emptyText:'请选择绩效单元...',
		triggerAction:'all',
		name: 'jxUnit',
		emptyText:'',
		minChars:1,
		//pageSize:10,
		//selectOnFocus:true,
		//forceSelection:'true',
		editable:false/*,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(jxUnit.getValue()!=""){
						userField.focus();
					}else{
						Handler = function(){jxUnit.focus();}
						Ext.Msg.show({title:'错误',msg:'绩效单元不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}*/
	});
	
	var userDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});

	userDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'../csp/dhc.pa.jxunitauditexe.csp?action=user&str='+encodeURIComponent(Ext.getCmp('userField').getRawValue()),method:'POST'})
	});

	var userField = new Ext.form.ComboBox({
		id: 'userField',
		fieldLabel: '权限用户',
		width:213,
		listWidth : 213,
        allowBlank: false,
		store: userDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择权限用户...',
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
						isReadField.focus();
					}else{
						Handler = function(){userField.focus();}
						Ext.Msg.show({title:'错误',msg:'权限用户不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var isReadField = new Ext.form.Checkbox({
		id: 'isRead',
		labelSeparator:'读权限',
		allowBlank: false,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					isWriteField.focus();
				}
			}
		}
	});
			
	var isWriteField = new Ext.form.Checkbox({
		id: 'isWrite',
		labelSeparator:'写权限',
		allowBlank: false,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					addButton.focus();
				}
			}
		}
	});
	
	jxUnitDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'dhc.pa.jxunitauditexe.csp?action=jxunit&str='+encodeURIComponent(Ext.getCmp('jxUnit').getRawValue())+"&userId="+Ext.getCmp('userField').getValue(),method:'POST'})
	});
	userField.on("select",function(cmb,rec,id ){
				jxUnitDs.proxy = new Ext.data.HttpProxy({
					url:'dhc.pa.jxunitauditexe.csp?action=jxunit&str='+encodeURIComponent(Ext.getCmp('jxUnit').getRawValue())+"&userId="+Ext.getCmp('userField').getValue(),method:'POST'})
				jxUnitDs.load({params:{userId:Ext.getCmp('userField').getValue()}});
			});
	formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth:70,
		items: [
			
			userField,
			jxUnit,
			isReadField,
			isWriteField
		]
	});
	
	//定义添加按钮
	var addButton = new Ext.Toolbar.Button({
		text:'添加'
	});
			
	//添加处理函数
	var addHandler = function(){
		var jxunitdr = Ext.getCmp('jxUnit').getValue();
		var userdr = Ext.getCmp('userField').getValue();
		var isRead = (isReadField.getValue()==true)?'Y':'N';
		var isWrite = (isWriteField.getValue()==true)?'Y':'N';
		userdr = trim(userdr);
		if(userdr==""){
			Ext.Msg.show({title:'提示',msg:'用户为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		var data = jxunitdr+"^"+userdr+"^"+isRead+"^"+isWrite;
		
		Ext.Ajax.request({
			url:'../csp/dhc.pa.jxunitauditexe.csp?action=add&data='+data,
			waitMsg:'添加中..',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					store.load({params:{start:0, limit:pagingToolbar.pageSize,jxunitdr:jxunitdr,dir:'asc',sort:'rowid'}});
				}else{
					if(jsonData.info=='RepRecode'){
						Handler = function(){jxUnit.focus();}
						Ext.Msg.show({title:'提示',msg:'该用户已经拥有该绩效单元的权限!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
					}
					if(jsonData.info=='dataEmpt'){
						Handler = function(){jxUnit.focus();}
						Ext.Msg.show({title:'错误',msg:'数据为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
		title: '添加绩效单元权限用户',
		width: 350,
		height:200,
		minWidth: 350,
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