schemdeptEditFun = function(itemGridDs,itemGrid,itemGridPagingToolbar) {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
    
	var len = rowObj.length;
	
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else if(len>1){
		Ext.Msg.show({title:'错误',msg:'只能修改单条记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
		
		var schemDs = new Ext.data.Store({
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	    });


	   schemDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.pa.kpiSchemDeptexe.csp'+'?action=listSchem',method:'POST'});
	   });	
	 
	var deptDs = new Ext.data.Store({
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});


	deptDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.pa.kpiSchemDeptexe.csp'+'?action=listDept',method:'POST'});
	});	
	var suserDs = new Ext.data.Store({
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','suser'])
	});


	suserDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.pa.kpiSchemDeptexe.csp'+'?action=listSuser',method:'POST'});
	});	
	
	var uNameField = new Ext.form.ComboBox({
		id:'uNameField',
		fieldLabel : '项目名称',
		width : 185,
		listWidth : 185,
		selectOnFocus : true,
		allowBlank : false,
		store : schemDs,
		name:'uNameField',
		valueNotFoundText :rowObj[0].get("name"),
		displayField: 'name',
		valueField: 'rowid',
		triggerAction : 'all',
		emptyText : '',
		editable : true,
		pageSize : 10,
		minChars : 1,
		selectOnFocus: true,
		forceSelection : true
	});
	var uJnameField = new Ext.form.ComboBox({
		id:'uJnameField',
		fieldLabel : '归口科室',
		width : 185,
		listWidth : 185,
		selectOnFocus : true,
		allowBlank : false,
		store : deptDs,
		name:'uJnameField',
		displayField: 'name',
		valueNotFoundText :rowObj[0].get("jname"),
		valueField: 'rowid',
		triggerAction : 'all',
		emptyText : '',
		editable : true,
		pageSize : 10,
		minChars : 1,
		selectOnFocus: true,
		forceSelection : true
	});
	var uSuserField = new Ext.form.ComboBox({
		id:'uSuserField',
		fieldLabel : '负责人',
		width : 185,
		listWidth : 185,
		selectOnFocus : true,
		allowBlank : false,
		store : suserDs,
		name:'uSuserField',
		displayField: 'suser',
		valueField: 'rowid',
		triggerAction : 'all',
		valueNotFoundText :rowObj[0].get("userName"),
		emptyText : '',
		editable : true,
		pageSize : 10,
		minChars : 1,
		selectOnFocus: true,
		forceSelection : true
	});
	
	
//获取信息

	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [ uNameField,uJnameField,uSuserField]
		});
	 
				                                                                                            
    //面板加载
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                              
			this.getForm().loadRecord(rowObj[0]);
			
			uNameField.setValue(rowObj[0].get("schemDr"));	
			uJnameField.setValue(rowObj[0].get("jxunitDr"));
			uSuserField.setValue(rowObj[0].get("userDr"));
			//uDescField.setValue(rowObj[0].get("desc"));
			
			                   
    });   
    
	    //定义并初始化保存修改按钮
	    var editButton = new Ext.Toolbar.Button({
				text:'保存'
			});                                                                                                                                            
                    
		        //定义修改按钮响应函数
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");   
		               
				
				var schemDr = uNameField.getValue(); 
				var jxunitDr = uJnameField.getValue();
				var userDr = uSuserField.getValue();
				
				var data=schemDr+"^"+jxunitDr+"^"+userDr;
                Ext.Ajax.request({
				url:'dhc.pa.kpiSchemDeptexe.csp?action=save&rowid='+rowid+'&data='+data,				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});		
				}
				else
					{
						Ext.Msg.show({title:'错误',msg:'修改失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				
					//var message="重复添加";
					//if(jsonData.info=='RepCode') message="代码重复！";
					//if(jsonData.info=='RepName') message="名称重复！";
					//Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				};
			},
				scope: this
			});
			editwin.close();
		};
		//添加保存修改按钮的监听事件
		editButton.addListener('click',editHandler,false);
	
		//定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改记录',
			width : 400,
			height : 200,    
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items:formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
		//窗口显示
		editwin.show();
	}
	

	
	};
