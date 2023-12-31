var addFun = function(dataStore,grid,pagingTool) {
	var mainUrl = 'dhc.ca.rolesexe.csp';
	//alert(userDr);
	if(monthDr==""||itemDr==""){
		Ext.Msg.show({title:'错误',msg:'请先选择核算区间和项目!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		allowBlank: true,
		emptyText: '备注...',
		anchor: '80%'
	});
/////////////////
	var servDeptDr='';
	var servedDeptDr='';
	/*
	var servDept = new Ext.form.TriggerField({
		allowBlank:false,
		fieldLabel:'服务部门',
		emptyText:'选择服务部门...'
	});
	
	var deptDr = '';
	var servDeptSelectWindow = function(){
		
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
				//unitDs.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listUnit&active=Y&unitTypeDr='+cmb.getValue(), method:'GET'});
				//unitDs.load({params:{start:0, limit:pagingTool.pageSize}});
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
				//deptDs.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listDept&active=Y&unitDr='+cmb.getValue(), method:'GET'});
				//deptDs.load({params:{start:0, limit:pagingTool.pageSize}});
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
  	    	servDeptDr = deptSelecter.getValue();
  	    	servDept.setValue(Ext.get('deptSelecter').getValue());
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
	};
servDept.onTriggerClick = servDeptSelectWindow;
/////////////////
/////////////////
	var servedDept = new Ext.form.TriggerField({
		allowBlank:false,
		fieldLabel:'被服务部门',
		emptyText:'选择被服务部门...'
	});
	
	var deptDr = '';
	var servedDeptSelectWindow = function(){
		
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
				//unitDs.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listUnit&active=Y&unitTypeDr='+cmb.getValue(), method:'GET'});
				//unitDs.load({params:{start:0, limit:pagingTool.pageSize}});
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
				//deptDs.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listDept&active=Y&unitDr='+cmb.getValue(), method:'GET'});
				//deptDs.load({params:{start:0, limit:pagingTool.pageSize}});
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
  	    	servedDeptDr = deptSelecter.getValue();
  	    	servedDept.setValue(Ext.get('deptSelecter').getValue());
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
	};
servedDept.onTriggerClick = servedDeptSelectWindow;
/////////////////
*/
		var servDeptDs = new Ext.data.Store({
			autoLoad: true,
			proxy: '',
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])
		});
		
		servDeptDs.on(
			'beforeload',
			function(ds, o){
				ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listDept&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('servDeptSelecter').getRawValue()+'&unitDr='+tmpUnitDr, method:'GET'});
			}
		);
  	
		var servDeptSelecter = new Ext.form.ComboBox({
			id:'servDeptSelecter',
			fieldLabel:'服务核算部门',
			store: servDeptDs,
			valueField:'rowId',
			displayField:'shortcut',
			typeAhead:true,
			pageSize:10,
			minChars:1,
			width:200,
			listWidth:240,
			triggerAction:'all',
			emptyText:'选择单位核算部门...',
		  allowBlank: true,
			selectOnFocus: true,
			forceSelection: true
		});        
		
		var servedDeptDs = new Ext.data.Store({
			autoLoad: true,
			proxy: '',
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])
		});
		
		servedDeptDs.on(
			'beforeload',
			function(ds, o){
				ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listDept&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('servedDeptSelecter').getRawValue()+'&unitDr='+tmpUnitDr, method:'GET'});
			}
		);
		
		var servedDeptSelecter = new Ext.form.ComboBox({
			id:'servedDeptSelecter',
			fieldLabel:'被服务核算部门',
			store: servedDeptDs,
			valueField:'rowId',
			displayField:'shortcut',
			typeAhead:true,
			pageSize:10,
			minChars:1,
			width:200,
			listWidth:240,
			triggerAction:'all',
			emptyText:'选择单位核算部门...',
		  allowBlank: false,
			selectOnFocus: true,
			forceSelection: true
		});            
///////////////////////////
		var valueField = new Ext.form.NumberField({
		id:'valueField',
    fieldLabel: '参数数值',
    allowBlank: false,
    emptyText:'参数数值...',
    anchor: '80%'
	});

	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 90,
		items: [
			servDeptSelecter,
			servedDeptSelecter,
			valueField,
			//servDept,
			//servedDept,
			remarkField
		]        
	});

  // define window and show it in desktop
  var awindow = new Ext.Window({
  	title: '添加参数数据表',
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
      		var value = valueField.getValue();
      		var remark = remarkField.getValue().trim();
			
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: paramDatasUrl+'?action=add&itemDr='+itemDr+'&servDeptDr='+servDeptSelecter.getValue()+'&remark='+remark+'&servedDeptDr='+servedDeptSelecter.getValue()+'&value='+value+'&intervalDr='+monthDr+'&inPersonDr='+userDr,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									paramDatasDs.setDefaultSort('rowid', 'desc');
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,monthDr:monthDr,itemDr:itemDr}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyName') message='输入的名称为空!';
									if(jsonData.info=='EmptyOrder') message='输入的序号为空!';
									if(jsonData.info=='Rep') message='输入的数据已经存在!';
									if(jsonData.info=='RepOrder') message='输入的序号已经存在!';
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
        handler: function(){awindow.close();}
      }]
    });
    awindow.show();
};