
//UPDATE



srmyearnewEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid         = rowObj[0].get("rowid");
		var Code          = rowObj[0].get("Code");
		var Name          = rowObj[0].get("Name");
		var StrDate       = rowObj[0].get("StrDate");
		var EndDate       = rowObj[0].get("EndDate");		
	}
	
//Panel中会用到的输入框、下拉框、日期框等都可以用extjs源码中封装的组件来新建new:输入框定义
	var uCodeFieldEdit = new Ext.form.TextField({
		id: 'uCodeFieldEdit',
		fieldLabel: '年度编码',
		width:200,
		//allowBlank: false,
		listWidth : 260,
		//regex:/[0-9]/,
		//regexText:"年度编码只能为数字",
		triggerAction: 'all',
		emptyText:'',
		name: 'uCodeFieldEdit',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uNameFieldEdit = new Ext.form.TextField({
		id: 'uNameFieldEdit',
		fieldLabel: '年度名称',
		width:200,
		allowBlank: true,
		listWidth : 200,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uNameFieldEdit',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});

	var uStrDateFieldEdit = new Ext.form.DateField({
		id: 'uStrDateFieldEdit',
		fieldLabel: '开始日期',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uStrDateFieldEdit',
		//format:"Y-m-d",
		//value:"Y-m-d",
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	
	var uEndDateFieldEdit = new Ext.form.DateField({
		id: 'uEndDateFieldEdit',
		fieldLabel: '结束日期',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uEndDateFieldEdit',
		//format:"Y-m-d",
		//value:"Y-m-d",
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});	
	
	
		var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '1',
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
									uCodeFieldEdit,
									uNameFieldEdit,
									uStrDateFieldEdit,
								    uEndDateFieldEdit
                       
								]	 
							}]
					}
				]
	

     
	var formPanel = new Ext.form.FormPanel({
			//baseCls : 'x-plain',
			labelWidth : 100,
			frame: true,
			items: colItems
		});
				                                                                                         
    //面板加载，在这里控制的是在修改面板中是否有数据
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                           
			this.getForm().loadRecord(rowObj[0]);
			uCodeFieldEdit.setValue(rowObj[0].get("Code"));	
			uNameFieldEdit.setValue(rowObj[0].get("Name"));
			uStrDateFieldEdit.setValue(rowObj[0].get("StrDate"));	
			uEndDateFieldEdit.setValue(rowObj[0].get("EndDate"));		
			                                                                        
    });   
    	
	    //定义并初始化保存修改按钮
	    var editButton = new Ext.Toolbar.Button({
				text:'保存',
				iconCls: 'save'
			});                                                                                                                                            //
                    
		        //定义修改按钮响应函数
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");          
				var codeedit = uCodeFieldEdit.getValue();
				var nameedit = uNameFieldEdit.getValue();
				var strdataedit = uStrDateFieldEdit.getRawValue();
				var enddataedit = uEndDateFieldEdit.getRawValue();

				    if (strdataedit!=="")
				    {
					 //strdataedit=strdataedit.format ('Y-m-d');
				    }

				    if (enddataedit!=="")
				    {
					 //enddataedit=enddataedit.format ('Y-m-d');
				    }

				if(codeedit=="")
				{
					Ext.Msg.show({title:'错误',msg:'年度编码不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				};
					
				if(codeedit!=""){
					if (!/[0-9]/.test(codeedit)){Ext.Msg.show({title:'错误',msg:'年度编码只能是数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
				};
					
				if(codeedit!=""){
					if (!/^\d{0,4}$/.test(codeedit)){Ext.Msg.show({title:'错误',msg:'年度编码只能是四位以内整数!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
				};
				
				if(nameedit=="")
				{
					Ext.Msg.show({title:'错误',msg:'年度名称不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				};
					
                Ext.Ajax.request({
				url:'herp.srm.yearexe.csp?action=edit&rowid='+rowid+'&Code='+encodeURIComponent(codeedit)
					+'&Name='+encodeURIComponent(nameedit)+'&StrDate='+encodeURIComponent(strdataedit)+'&EndDate='+encodeURIComponent(enddataedit),
				
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
					if(jsonData.info=='RepCode') message="年度编号重复！";
					if(jsonData.info=='RepName') message="年度名称重复！";
					if(jsonData.info=='RepDate') message="输入的开始时间不能大于结束时间！";
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
			text:'关闭',
			iconCls : 'cancel'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改年度信息',
			iconCls : 'pencil',
			width : 380,
			height : 230,    
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
