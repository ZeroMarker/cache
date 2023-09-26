addFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
	
	/////接口部门套
	var deptSetDs = new Ext.data.Store({
		autoLoad: true,
		proxy: '',
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'},['shortcut','rowid'])
	});
	
	deptSetDs.on(
		'beforeload',
		function(ds, o){
			ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listDeptSet&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('deptSetSelecter').getRawValue(), method:'GET'});
		}
	);
	
	var deptSetSelecter = new Ext.form.ComboBox({
		id:'deptSetSelecter',
		fieldLabel:'部门套',
		store: deptSetDs,
		valueField:'rowid',
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:150,
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择接口部门套...',
		allowBlank: false,
		selectOnFocus: true,
		forceSelection: true
	});   
	
	/////接口项目套
	var itemSetDs = new Ext.data.Store({
		autoLoad: true,
		proxy: '',
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])
	});
	
	itemSetDs.on(
		'beforeload',
		function(ds, o){
			ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listItemSet&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('itemSetSelecter').getRawValue(), method:'GET'});
		}
	);
	
	var itemSetSelecter = new Ext.form.ComboBox({
		id:'itemSetSelecter',
		fieldLabel:'项目套',
		store: itemSetDs,
		valueField:'rowId',
		
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:150,
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择接口项目套...',
		allowBlank: true,
		selectOnFocus: true,
		forceSelection: true
	});
	
 
	
	/////数据项类别
	var itemTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy: '',
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'},['shortcut','rowid'])
	});
	
	itemTypeDs.on(
		'beforeload',
		function(ds, o){
			ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listItemType&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('itemTypeSelecter').getRawValue(), method:'GET'});
		}
	);
	
	var itemTypeSelecter = new Ext.form.ComboBox({
		id:'itemTypeSelecter',
		fieldLabel:'数据类',
		store: itemTypeDs,
		valueField:'rowid',
		disabled:true,
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:150,
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择数据项类别...',
		allowBlank: true,
		selectOnFocus: true,
		forceSelection: true
	});
	

	///////
		
	var orderField = new Ext.form.NumberField({
		id:'orderField',
    fieldLabel: '顺序',
    allowBlank: false,
    emptyText:'顺序...',
    anchor: '95%'
	});

	var codeField = new Ext.form.TextField({
		id:'codeField',
    fieldLabel: '代码',
    allowBlank: false,
    emptyText:'代码...',
    anchor: '95%'
	});

	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: '名称',
    allowBlank: false,
    emptyText:'名称...',
    anchor: '95%'
	});
	
	var itemSetRadio = new Ext.form.Radio({
		id: 'maleField',
		name:'Item',
		boxLabel: '项目套',
		value : 'Set', 
		checked: true
	});
	
	var itemTypeRadio = new Ext.form.Radio({
		id: 'femaleField',
		boxLabel: '数据类',
		name:'Item',
		value : 'Type', 
		checked: false
	});
	
	itemSetRadio.on(
		'check',
		function(radio,disabled){
			if(disabled==false){
				itemSetSelecter.setDisabled(true);
				itemSetSelecter.setValue('');
			}else{
				itemSetSelecter.setDisabled(false);
			}
		}
	);
	
	itemTypeRadio.on(
		'check',
		function(radio,disabled){
			if(disabled==false){
				itemTypeSelecter.setDisabled(true);
				itemTypeSelecter.setValue('');
			}else{
				itemTypeSelecter.setDisabled(false);
			}
		}
	);
	
	var flagPanel = new Ext.Panel({
		layout: 'table',
		border: true,
		isFormField: true,
		baseCls: 'x-plain',
		fieldLabel: '数据',
		defaults: {
			border: false,
			baseCls: 'x-plain'
		},
		items: [
			{
				items: itemSetRadio
			},
			{
				items: itemTypeRadio
			}
		]
	});

	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [
    	orderField,
    	codeField,
      nameField,
      
      deptSetSelecter,
      flagPanel,
      itemSetSelecter,
      itemTypeSelecter
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '添加',
    width: 400,
    height:300,
    minWidth: 400,
    minHeight: 300,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存',
      handler: function() {
      	var order = orderField.getValue();
      	var code = codeField.getValue();
      	var name = nameField.getValue();
      	
      	code = code.trim();
      	name = name.trim();

        if (formPanel.form.isValid()) {
        	if((itemSetSelecter.getValue()=='')&(itemTypeSelecter.getValue()=='')){
        		Ext.Msg.show({title:'错误',msg:'项目套和数据项不能全为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	}else{
        		Ext.Ajax.request({
							url: mainUrl+'?action=add&order='+order+'&code='+code+'&name='+name+'&deptSetDr='+deptSetSelecter.getValue()+'&itemSetDr='+itemSetSelecter.getValue()+'&itemTypeDr='+itemTypeSelecter.getValue(),
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
								}
								else
								{
									var message="SQLErr: "+jsonData.info;
									if(jsonData.info=='RepOrder') message='输入的顺序已经存在!';
									if(jsonData.info=='RepCode') message='输入的代码已经存在!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
				  		scope: this
						});
        	}

        }
        else{
					Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
	    }
    },
    {
			text: '取消',
      handler: function(){window.close();}
    }]
	});

  window.show();
};