addRdeptsFun = function(dataStore,grid,pagingTool,parRef) {
	Ext.QuickTips.init();
	var mainUrl = 'dhc.ca.rdeptsexe.csp';	
	var deptTrigger = new Ext.form.TriggerField({
		allowBlank:false,
		fieldLabel:'部门名称',
		emptyText:'选择单位部门...'
	});
	
	var deptDr = '';
/////////////////////////////////////////////////	
	//var deptSelectWindow = function(){	//zhw 注释掉 20160821
		
		var typeDs = new Ext.data.Store({
			autoLoad: true,
			proxy: '',
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])
		});
		
		typeDs.on(
			'beforeload',
			function(ds, o){
				ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listType&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('typeSelecter').getRawValue(), method:'GET'});
			}
		);
  	
		var typeSelecter = new Ext.form.ComboBox({
			id:'typeSelecter',
			fieldLabel:'类别名称',
			store: typeDs,
			valueField:'rowId',
			displayField:'shortcut',
			typeAhead:true,
			pageSize:10,
			minChars:1,
			width:150,
			listWidth:250,
			triggerAction:'all',
			emptyText:'选择单位类别...',
			allowBlank: false,
			selectOnFocus: true,
			forceSelection: true
		});
  	
		typeSelecter.on(
			"select",
			function(cmb,rec,id ){
				unitDs.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listUnit&active=Y&unitTypeDr='+cmb.getValue(), method:'GET'});		// zhw 20160821 去掉注释
				unitDs.load({params:{start:0, limit:pagingTool.pageSize}});		// zhw 20160821 去掉注释
  	  	unitSelecter.setValue('');
  	  	deptSelecter.setValue('');
			}
		);
  	
		var unitDs = new Ext.data.Store({
			autoLoad: true,
			proxy: '',
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])
		});
		
		unitDs.on(
			'beforeload',
			function(ds, o){
				ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listUnit&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('unitSelecter').getRawValue()+'&unitTypeDr='+typeSelecter.getValue(), method:'GET'});
			}
		);
  	
		var unitSelecter = new Ext.form.ComboBox({
			id:'unitSelecter',
			fieldLabel:'单位名称',
			store: unitDs,
			valueField:'rowId',
			displayField:'shortcut',
			typeAhead:true,
			pageSize:10,
			minChars:1,
			width:150,
			listWidth:250,
			triggerAction:'all',
			emptyText:'选择单位名称...',
		  allowBlank: false,
			selectOnFocus: true,
			forceSelection: true
		});
  	
		unitSelecter.on(
			"select",
			function(cmb,rec,id){
				deptDs.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listDept&active=Y&unitDr='+cmb.getValue(), method:'GET'});		// zhw 20160821 去掉注释
				deptDs.load({params:{start:0, limit:pagingTool.pageSize}});		// zhw 20160821 去掉注释
				deptSelecter.setValue('');
			}
		);
  	
		var deptDs = new Ext.data.Store({
			autoLoad: true,
			proxy: '',
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])
		});
		
		deptDs.on(
			'beforeload',
			function(ds, o){
				ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listDept&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('deptSelecter').getRawValue()+'&unitDr='+unitSelecter.getValue(), method:'GET'});
			}
		);
  	
		var deptSelecter = new Ext.form.ComboBox({
			id:'deptSelecter',
			fieldLabel:'部门名称',
			store: deptDs,
			valueField:'rowId',
			displayField:'shortcut',
			typeAhead:true,
			pageSize:10,
			minChars:1,
			width:150,
			listWidth:250,
			triggerAction:'all',
			emptyText:'选择单位部门...',
		  allowBlank: false,
			selectOnFocus: true,
			forceSelection: true
		});                     
			
		var formPanel = new Ext.form.FormPanel({
  		baseCls: 'x-plain',
  	  labelWidth: 60,
  	  items: [
  	    typeSelecter,
  	    unitSelecter,
  	    deptSelecter
			]
		});
		/*
		var window = new Ext.Window({
  		title: '添加单位部门',
  	  width: 300,
  	  height:200,
  	  layout: 'fit',
  	  plain:true,
  	  modal:true,
  	  bodyStyle:'padding:5px;',
  	  buttonAlign:'center',
  	  items: formPanel,
  	  buttons: [{
  	  	text: '确定',
  	    handler: function() {
  	    	deptDr = deptSelecter.getValue();
  	    	deptTrigger.setValue(Ext.get('deptSelecter').getValue());
  	    	window.close();
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
	};*/	 //zhw 注释掉 20160821 
//////////////////////////////////////////////////////////	
	//deptTrigger.onTriggerClick = deptSelectWindow;	 //zhw 注释掉 20160821 

	var orderField = new Ext.form.NumberField({
		id:'orderField',
    fieldLabel: '部门顺序',
    allowBlank: false,
    emptyText:'部门顺序...',
    //anchor: '95%'	//zhw 注释掉 20160821
	width:150,		//zhw 增加 20160821
	listWidth:250	//zhw 增加 20160821
	});

	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [
    	orderField,
    	typeSelecter,  //zhw 增加 20160821
    	unitSelecter,  //zhw 增加 20160821
    	deptSelecter
      	//deptTrigger  //zhw 注释掉 20160821
		]
	});

  // define window and show it in desktop
  
  var window = new Ext.Window({
  	title: '添加可用部门',
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
		var deptDr = deptSelecter.getValue();
        if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: mainUrl+'?action=add&parRef='+parRef+'&deptDr='+deptDr+'&order='+order,
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
								if(jsonData.info=='RepDept') message='输入的部门已经存在!';
							  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
				  	scope: this
					});
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