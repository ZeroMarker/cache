

srmtemplatedownloadEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid      = rowObj[0].get("rowid");
		var Year       = rowObj[0].get("Year");
		var SysNoDr    = rowObj[0].get("SysNoDr");
		var Desc       = rowObj[0].get("Desc");
		var Type       = rowObj[0].get("Type");
	}
	
	var YearDsEdit = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});


	YearDsEdit.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:projUrl+'?action=Year&str='+encodeURIComponent(Ext.getCmp('YearFieldEdit').getRawValue()),method:'POST'});
	});

	var YearFieldEdit = new Ext.form.ComboBox({
		id: 'YearFieldEdit',
		fieldLabel: '年度',
		width:180,
		listWidth : 200,
		allowBlank : false, 
		store:YearDsEdit,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		anchor: '95%',
		//emptyText:'请选择开始时间...',
		name: 'YearFieldEdit',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	
	var SysNoDrDsEdit = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});


	SysNoDrDsEdit.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:projUrl+'?action=SysNoDr&str='+encodeURIComponent(Ext.getCmp('SysNoDrFieldEdit').getRawValue()),method:'POST'});
	});

	var SysNoDrFieldEdit = new Ext.form.ComboBox({
		id: 'SysNoDrFieldEdit',
		fieldLabel: '模板所属模块号',
		width:180,
		listWidth : 250,
		allowBlank : false, 
		store:SysNoDrDsEdit,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		anchor: '95%',
		//emptyText:'请选择开始时间...',
		name: 'SysNoDrFieldEdit',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});		
	var ueTypeField = new Ext.form.TextField({
		id: 'ueTypeField',
		fieldLabel: '模板类型',
		width:200,
		allowBlank: false,
		value:Type,
		listWidth : 260,
		triggerAction: 'all',
		emptyText:'',
		name: 'ueTypeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var DescFieldEdit = new Ext.form.TextArea({
		id : 'DescFieldEdit',
		width : 160,
		height : 90,
		anchor: '95%',
		fieldLabel : '模板说明',
		allowBlank :true,
		selectOnFocus:'true',
		emptyText : '请填写模板说明……'
	});
	
	
	
	
		var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.9',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									},
								  // RecordTypeField,
                   YearFieldEdit, 
                   SysNoDrFieldEdit,
				   ueTypeField,
                   DescFieldEdit 
								]	 
							}
						]
					}
				]
	

     
	var formPanel = new Ext.form.FormPanel({
			//baseCls : 'x-plain',
			labelWidth : 90,
			frame: true,
			items: colItems
		});
				                                                                                         
    //面板加载，在这里控制的是在修改面板中是否有数据
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                           
			this.getForm().loadRecord(rowObj[0]);
			YearFieldEdit.setValue(rowObj[0].get("YearDr"));	
			YearFieldEdit.setRawValue(rowObj[0].get("Year"));
			SysNoDrFieldEdit.setValue(rowObj[0].get("SysNoDr"));
			SysNoDrFieldEdit.setRawValue(rowObj[0].get("SysNo"));
			
			DescFieldEdit.setValue(rowObj[0].get("Desc"));	
			ueTypeField.setValue(rowObj[0].get("Type"));	
			                                                                        
    });   
    	
	    //定义并初始化保存修改按钮
	    var editButton = new Ext.Toolbar.Button({
				text:'保存'
			});                                                                                                                                            //
                    
		        //定义修改按钮响应函数
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid       = rowObj[0].get("rowid");          
				var yearedit    = YearFieldEdit.getValue();
				var sysnodredit = SysNoDrFieldEdit.getValue();
				var descedit    = DescFieldEdit.getValue();
				var type    = ueTypeField.getValue();
				
				var Yearedit = rowObj[0].get("Year");     
				var SysNoDredit = rowObj[0].get("SysNoDr");     
				var Type    = ueTypeField.getValue();
				
				/* if(Yearedit==yearedit){yearedit="";}
				if(SysNoDredit==sysnodredit){sysnodredit="";}
				if(SysNoDredit==sysnodredit){sysnodredit="";}	 */
				
				if(yearedit==""){
					Ext.Msg.show({title:'错误',msg:'年度为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
				if(type==""){
					Ext.Msg.show({title:'错误',msg:'模板类型为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
               
                Ext.Ajax.request({
				url:'herp.srm.templatedownloadexe.csp?action=edit&rowid='+rowid+'&year='+encodeURIComponent(yearedit)
					+'&sysnodr='+encodeURIComponent(sysnodredit)+'&desc='+encodeURIComponent(descedit)+'&type='+encodeURIComponent(type),
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					itemGridDs.load({params:{start:0, limit:25}});		
				}
				else
					{
					var message="重复添加";
					/*
					if(jsonData.info=='RepCode') message="编号重复！";
					if(jsonData.info=='RepName') message="名称重复！";
					*/
					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
			height : 350,    
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
		//窗口显示
		editwin.show();
	};
