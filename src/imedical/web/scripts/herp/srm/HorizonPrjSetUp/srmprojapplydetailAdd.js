srmprojapplydetailAddFun = function() {
	
	//var rowid = rowObj[0].get("rowid");
	
	var PrjCN = new Ext.form.TextField({
		id: 'PrjCN',
		fieldLabel: '项目合同编号',
		width:500,
		allowBlank: false,
		listWidth : 260,
		anchor: '100%',
		triggerAction: 'all',
		//emptyText:'',
		name: 'PrjCN',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	
	var Destination = new Ext.form.TextArea({
		id : 'Destination',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '研究目标',
		allowBlank :true,
		selectOnFocus:'true',
		labelSeparator:''

		//emptyText : '请填写研究目标……'
	});
		var Content = new Ext.form.TextArea({
		id : 'Content',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '研究内容',
		allowBlank :true,
		selectOnFocus:'true',
		labelSeparator:''

		//emptyText : '请填写研究内容……'
	});
		var Check = new Ext.form.TextArea({
		id : 'Check',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '考核指标',
		allowBlank :true,
		selectOnFocus:'true',
		labelSeparator:''

		//emptyText : '请填写考核指标……'
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
                                     PrjCN, 
                                     Destination,  
				                     Content,
				                     Check
								]	 
							}]
					}
				]			
	var formPanel = new Ext.form.FormPanel({
			//baseCls : 'x-plain',
			labelWidth : 80,
			labelAlign:'right',
			frame: true,
			items: colItems
			//items : [uCodeField,uNameField,uTypeField,uSexField,uBirthDayField,uIDNumField,uTitleDrField,uPhoneField,uEMailField,uDegreeField,uCompDRField,uMonographNumField,uPaperNumField,uPatentNumField,uInvInCustomStanNumField,uTrainNumField,uHoldTrainNumField,uInTrainingNumField]
		});	
	
	var addWin = new Ext.Window({
			title : '新增项目研究信息',
			iconCls: 'edit_add',
			width : 650,
			height : 550,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,		
			buttons : [{		 
				text : '保存',iconCls: 'save',
				handler : function() {
					if (formPanel.form.isValid()) {
					
					var rowObj = itemGrid.getSelectionModel().getSelections();
					var rowid = rowObj[0].get("rowid");
					
					
						
					var prjcn = PrjCN.getValue();
					var destination = Destination.getValue();
					var content = Content.getValue();
			   		var check = Check.getValue();

					var prjcnlen=prjcn.length;
					var destinationlen=destination.length;
					var contentlen=content.length;
					var checklen=check.length;
					
					if(prjcnlen>20)
					{
						Ext.Msg.show({title:'错误',msg:'合同编号字数不能超过20!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					if(destinationlen>60)
					{
						Ext.Msg.show({title:'错误',msg:'研究目标字数不能超过60!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					if(contentlen>60)
					{
						Ext.Msg.show({title:'错误',msg:'研究内容字数不能超过60!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					if(checklen>60)
					{
						Ext.Msg.show({title:'错误',msg:'考核指标字数不能超过60!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
			   		
				Ext.Ajax.request({
					url:'herp.srm.srmprojapplydetailexe.csp?action=add&rowid='+encodeURIComponent(rowid)
					+'&PrjCN='+encodeURIComponent(prjcn)+'&Destination='+encodeURIComponent(destination)
					+'&Content='+encodeURIComponent(content)+'&Check='+encodeURIComponent(check),
					waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							DetailGrid.load({params:{start:0, limit:25}});
							//itemGrid.load({	params:{start:0, limit:25,userdr:userdr}});
						}
						else
						{	var message=jsonData.info;
						
						    if(jsonData.info=='RepCode') message="项目合同编号重复！";
							/*
							if(jsonData.info=='RepCode') message="编号重复！";
							if(jsonData.info=='RepID') message="身份证号码重复！";
							if(jsonData.info=='RepBirthDay') message="生日不能大于当前日期！";
						    */	
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
				text : '关闭',iconCls : 'cancel',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
