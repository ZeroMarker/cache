

srmyearnewAddFun = function() {
	
	var uCodeFieldAdd = new Ext.form.TextField({
		id: 'uCodeFieldAdd',
		fieldLabel: '年度编码',
		width:200,
		//allowBlank: false,
		listWidth : 260,
		//regex:/[0-9]/,
		//regexText:"年度编码只能为数字",
		triggerAction: 'all',
		emptyText:'',
		name: 'uCodeFieldAdd',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uNameFieldAdd = new Ext.form.TextField({
		id: 'uNameFieldAdd',
		fieldLabel: '年度名称',
		width:200,
		//allowBlank: true,
		listWidth : 200,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uNameFieldAdd',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});

	var uStrDateFieldAdd = new Ext.form.DateField({
		id: 'uStrDateFieldAdd',
		fieldLabel: '开始日期',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uStrDateFieldAdd',
		//format:"Y-m-d",
		//value:"Y-m-d",
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	
	var uEndDateFieldAdd = new Ext.form.DateField({
		id: 'uEndDateFieldADD',
		fieldLabel: '结束日期',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uEndDateFieldADD',
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
								uCodeFieldAdd,
								uNameFieldAdd,
                                uStrDateFieldAdd,
								uEndDateFieldAdd 
								]	 
							}]
					}
				]			
	var formPanel = new Ext.form.FormPanel({
			//baseCls : 'x-plain',
			labelWidth : 100,   //调试panel中fieldLabel宽度
			frame: true,
			items: colItems
			//items : [uCodeField,uNameField,uTypeField,uSexField,uBirthDayField,uIDNumField,uTitleDrField,uPhoneField,uEMailField,uDegreeField,uCompDRField,uMonographNumField,uPaperNumField,uPatentNumField,uInvInCustomStanNumField,uTrainNumField,uHoldTrainNumField,uInTrainingNumField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '新增年度信息',
			iconCls: 'edit_add',
			width : 380,
			height : 230,
			layout : 'fit',//添加页面背景的高度
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',//添加页面的内边距
			buttonAlign : 'center',//添加页面的确定按钮和取消按钮的位置
			items : formPanel,
			buttons : [{		 
				text : '保存',
				iconCls : 'save',
				handler : function() {
					if (formPanel.form.isValid()) {
					var codeadd = uCodeFieldAdd.getValue();
					var nameadd = uNameFieldAdd.getValue();
					var strdataadd = uStrDateFieldAdd.getRawValue();
                    var enddataadd = uEndDateFieldAdd.getRawValue();

				    if (strdataadd!=="")
				    {
					 //strdataadd=strdataadd.format ('Y-m-d');
				    }

				    if (enddataadd!=="")
				    {
					 //enddataadd=enddataadd.format ('Y-m-d');
				    }
					if(codeadd=="")
					{
						Ext.Msg.show({title:'错误',msg:'年度编码不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					};
					
					if(codeadd!=""){
					   if (!/[0-9]/.test(codeadd)){Ext.Msg.show({title:'错误',msg:'年度编码只能是数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
					};
					
					if(codeadd!=""){
					   if (!/^\d{0,4}$/.test(codeadd)){Ext.Msg.show({title:'错误',msg:'年度编码只能是四位以内整数!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
					};
				
					if(nameadd=="")
					{
						Ext.Msg.show({title:'错误',msg:'年度名称不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					};
					
				Ext.Ajax.request({
					url:'herp.srm.yearexe.csp?action=add&Code='+encodeURIComponent(codeadd)
					+'&Name='+encodeURIComponent(nameadd)+'&StrDate='+encodeURIComponent(strdataadd)+'&EndDate='+encodeURIComponent(enddataadd),
					waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:25}});
						}
						else
						{	var message="重复添加";
							if(jsonData.info=='RepCode') message="年度编号重复！";
							if(jsonData.info=='RepName') message="年度名称重复！";
							if(jsonData.info=='RepDate') message="输入的开始时间不能大于结束时间！";
							
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : '关闭',
				iconCls : 'cancel',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();	
	};