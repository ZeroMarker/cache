addFun = function(typeValue,ds,pagingToolbar){
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel: '分组代码',
		allowBlank: false,
		width:150,
		listWidth : 150,
		emptyText:'分组代码...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(codeField.getValue()!=""){
						nameField.focus();
					}else{
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'错误',msg:'分组代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}




	});
	

	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel: '分组名称',
		allowBlank: false,
		width:180,
		listWidth : 180,
		emptyText:'分组名称...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(nameField.getValue()!=""){
						isInputField.focus();
					}else{
						Handler = function(){nameField.focus();}
						Ext.Msg.show({title:'错误',msg:'分组名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}




	});
	

	var TypeDs = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data : [['1','1-指标'],['2','2-绩效单元']]
	});
	var TField = new Ext.form.ComboBox({
		id: 'TField',
		fieldLabel: '分组类别',
		//width : 280,
		//listWidth : 280,
		selectOnFocus: true,
		allowBlank: false,
		store: TypeDs,
		anchor: '90%',
		value:'1', //默认值
		valueNotFoundText:'1-指标',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'选择分组类别...',
		mode: 'local', //本地模式
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(TField.getValue()!=""){
						descField.focus();
					}else{
						Handler = function(){TField.focus();}
						Ext.Msg.show({title:'错误',msg:'分组类别不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}




	});
	

	IDSet = new Ext.form.TextArea({
		id:'IDSet',
		width:355,
		height:60,
		labelWidth:20,
		fieldLabel: '指标或绩效单元',
		readOnly:true,
		itemCls:'sex-female', //向左浮动,处理控件横排
		clearCls:'allow-float' //允许两边浮动

	});
	

	var editorbutton = new Ext.Toolbar.Button({
		text:'编辑',
		itemCls:'age-field',
		handler:function(){
			var type=Ext.getCmp('TField').getValue();
			selection(type);
		}

	});
	

//是否录入
    var IsInputDs = new Ext.data.SimpleStore({
        fields: ['key','keyValue'],
        data : [['0','是'],['1','否']]
    });

	var isInputField = new Ext.form.ComboBox({
		id:'isInputField',
		width : 180,
        listWidth : 180,
        fieldLabel:'是否录入',
        selectOnFocus: true,
        allowBlank: false,
        store: IsInputDs,
        emptyText:'是否录入...',
        anchor: '90%',

		value:'1', //默认值
        valueNotFoundText : '否',
        displayField: 'keyValue',
        valueField: 'key',
        triggerAction: 'all',
        mode: 'local', //本地模式
        editable:false,
        pageSize: 10,
        minChars: 1,
        itemCls:'sex-male', //向左浮动,处理控件横排
        clearCls:'allow-float', //允许两边浮动









		selectOnFocus:true,
		forceSelection: true,
		//allowNegative:false,
		//allowDecimals:false,

		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(isInputField.getValue()!=""){
						//TypeField.focus();
						 descField.focus();
					}else{
						Handler = function(){isInputField.focus();}
						Ext.Msg.show({title:'错误',msg:'是否录入不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}




	});
		
	
		


	var descField = new Ext.form.TextField({
		id:'descField',
		fieldLabel: '分组描述',
		allowBlank: false,
		width:180,
		listWidth : 180,
		emptyText:'分组描述...',
		anchor: '90%',
		selectOnFocus:'true',
		itemCls:'sex-male', //向左浮动,处理控件横排
        clearCls:'allow-float', //允许两边浮动

		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					addButton.focus();
				}
			}
		}



	});
		

	//初始化面板
	formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 100,

		items:[
			codeField,
			nameField,
			TField,
			IDSet,
			editorbutton,
			isInputField,
			descField
		]




















	});
		

	//初始化添加按钮
	addButton = new Ext.Toolbar.Button({
		text:'添 加'
	});
		

	//定义添加按钮响应函数
	addHandler = function(){
		var code = codeField.getValue();
		var name = nameField.getValue();
		var type = Ext.getCmp('TField').getValue();
		var IDSet="";
		if(type==1){
			IDSet=KPIDrStr;
		}else{
			IDSet=deptIDStr;
		}

		var isInput = Ext.getCmp('isInputField').getValue();//是否录入
		var desc = descField.getValue();
		code = trim(code);
		if(code==""){
			Ext.Msg.show({title:'错误',msg:'分组代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		name = trim(name);
		if(name==""){
			Ext.Msg.show({title:'错误',msg:'分组名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		type = trim(type);
		if(type==""){
			Ext.Msg.show({title:'错误',msg:'分组类别为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		var data = code+"^"+name+"^"+IDSet+"^"+isInput+"^"+type+"^"+desc;
		data = trim(data);
		if(data==""){
			Ext.Msg.show({title:'错误',msg:'分组类别为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		
		


		Ext.Ajax.request({
			url: '../csp/dhc.pa.jxgroupexe.csp?action=add&data='+data,
			waitMsg:'保存中...',
			failure: function(result, request){
				Handler = function(){codeField.focus();}
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					ds.load({params:{start:0,limit:pagingToolbar.pageSize,type:typeValue}});
				}else{
					if(jsonData.info=='RepCode'){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'错误',msg:'此分组代码已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}

					if(jsonData.info=='RepName'){
						Handler = function(){nameField.focus();}
						Ext.Msg.show({title:'错误',msg:'此分组名称已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}


			},
			scope: this
		});
	}
	

	//添加保存按钮的监听事件
	addButton.addListener('click',addHandler,false);
	

	//初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
		text:'取消'
	});
	

	//定义取消按钮的响应函数
	cancelHandler = function(){
		addwin.close();
	}
	

	//添加取消按钮的监听事件
	cancelButton.addListener('click',cancelHandler,false);

	//初始化窗口
	addwin = new Ext.Window({
		title: '添加分组记录',
		width: 580,
        height:300,
		minWidth: 600, 
		minHeight: 290,
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
	

	//窗口显示
	addwin.show();
}