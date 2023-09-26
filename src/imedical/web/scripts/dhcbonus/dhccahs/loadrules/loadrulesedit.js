editFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();

	var rowObj = grid.getSelections();
	var len = rowObj.length;
	var id = 0;
	var deptDr = '';
	var trigger = '';
	
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		id = rowObj[0].get("rowId");
		deptSetDr = rowObj[0].get("deptSetDr");
		itemSetDr = rowObj[0].get("itemSetDr");
		itemTypeDr = rowObj[0].get("itemTypeDr");
	}
	
		/////接口部门套
	var deptSetDs = new Ext.data.Store({
		autoLoad: true,
		proxy:'',// new Ext.data.HttpProxy({url:mainUrl+'?action=listDeptSet&active=Y', method:'GET'}),
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
		name:'deptSetName',
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择接口部门套...',
		allowBlank: false,
		selectOnFocus: true,
		forceSelection: true
	});   
	
	deptSetSelecter.on(
		"select",
		function(cmb,rec,id ){
			deptSetDr = cmb.getValue();
		}
	);
	
	deptSetSelecter.on(
		"focus",
		function(cmb){
			cmb.setValue('');
		}
	);
	
	/////接口项目套
	var itemSetDs = new Ext.data.Store({
		autoLoad: true,
		proxy:'',// new Ext.data.HttpProxy({url:mainUrl+'?action=listItemSet&active=Y', method:'GET'}),
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
		name:'itemSetName',
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择接口项目套...',
		allowBlank: true,
		selectOnFocus: true,
		forceSelection: true
	});
	
	itemSetSelecter.on(
		"select",
		function(cmb,rec,id ){
			itemSetDr = cmb.getValue();
		}
	); 
	
	itemSetSelecter.on(
		"focus",
		function(cmb){
			cmb.setValue('');
		}
	);
	
	/////数据项类别
	var itemTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy: '',//new Ext.data.HttpProxy({url:mainUrl+'?action=listItemType&active=Y', method:'GET'}),
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
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		disabled:true,
		width:150,
		name:'itemTypeName',
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择数据项类别...',
		allowBlank: true,
		selectOnFocus: true,
		forceSelection: true
	});
	
	itemTypeSelecter.on(
		"select",
		function(cmb,rec,id ){
			itemTypeDr = cmb.getValue();
		}
	);
	
	itemTypeSelecter.on(
		"focus",
		function(cmb){
			cmb.setValue('');
		}
	);
	///////
	
	var orderField = new Ext.form.TextField({
		id:'orderField',
    fieldLabel: '顺序',
    allowBlank: false,
    emptyText:'顺序...',
    name:'order',
    anchor: '95%'
	});
	
	var codeField = new Ext.form.TextField({
		id:'codeField',
    fieldLabel: '代码',
    allowBlank: false,
    emptyText:'代码...',
    name:'code',
    anchor: '95%'
	});

	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: '名称',
    allowBlank: false,
    emptyText:'名称...',
    name:'name',
    anchor: '95%'
	});
	
	var itemSetRadio = new Ext.form.Radio({
		id: 'maleField',
		name:'Item',
		fieldLabel: '数据',
		boxLabel: '项目套',
		value : 'Set', 
		allowBlank: true,
		checked: true
	});
	
	var itemTypeRadio = new Ext.form.Radio({
		id: 'femaleField',
		boxLabel: '数据类',
		hideLabel: true,
		name:'Item',
		value : 'Type', 
		allowBlank: true,
		checked: false
	});
	
	itemSetRadio.on(
		'check',
		function(radio,disabled){
			if(disabled===false){
				itemSetSelecter.setDisabled(true);
				itemSetSelecter.setValue('');
				itemSetDr='';
			}else{
				itemSetSelecter.setDisabled(false);
			}
		}
	);
	
	itemTypeRadio.on(
		'check',
		function(radio,disabled){
			if(disabled===false){
				itemTypeSelecter.setDisabled(true);
				itemTypeSelecter.setValue('');
				itemTypeDr='';
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
	
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
	});

  var window = new Ext.Window({
  	title: '修改',
    width: 400,
    height:300,
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
      	
      	order = order.trim();	
      	code = code.trim();
      	name = name.trim();
      	
        if(formPanel.form.isValid()){
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
      handler: function(){
      	window.close();
      }
    }]
  });
  window.show();
};