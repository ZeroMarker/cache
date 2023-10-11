srmprojapplydetailEditFun = function() {
	
	var rowObj=DetailGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid      		= rowObj[0].get("rowid");
		var detailrowid1    = rowObj[0].get("detailrowid1");
		var detailrowid2    = rowObj[0].get("detailrowid2");
		var prjcnedit       = rowObj[0].get("PrjCN");
		var destinationedit = rowObj[0].get("Destination");
		var contentedit     = rowObj[0].get("Content");
		var checkedit       = rowObj[0].get("PrjCheck");
	}
	
	var PrjCNEdit = new Ext.form.TextField({
		id: 'PrjCNEdit',
		fieldLabel: '项目合同编号',
		width:500,
		anchor: '100%',
		allowBlank: false,
		listWidth : 260,
		triggerAction: 'all',
		//emptyText:'',
		name: 'PrjCN',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''

	});
	
	var DestinationEdit = new Ext.form.TextArea({
		id : 'DestinationEdit',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '研究目标',
		allowBlank :true,
		selectOnFocus:'true',
		labelSeparator:''

		//emptyText : '请填写研究目标……'
	});
		var ContentEdit = new Ext.form.TextArea({
		id : 'ContentEdit',
		width : 500,
		height : 120,
		anchor: '100%',
		fieldLabel : '研究内容',
		allowBlank :true,
		selectOnFocus:'true',
		labelSeparator:''

		//emptyText : '请填写研究内容……'
	});
		var CheckEdit = new Ext.form.TextArea({
		id : 'CheckEdit',
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
                                     PrjCNEdit, 
                                     DestinationEdit,  
				                     ContentEdit,
				                     CheckEdit
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
	
    //面板加载，在这里控制的是在修改面板中是否有数据
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                           
			this.getForm().loadRecord(rowObj[0]);

			PrjCNEdit.setValue(rowObj[0].get("PrjCN"));		
			DestinationEdit.setValue(rowObj[0].get("Destination"));
			ContentEdit.setValue(rowObj[0].get("Content"));	
			CheckEdit.setValue(rowObj[0].get("Check"));		
			                                                                    
    }); 


	var editWin = new Ext.Window({
			title : '修改项目研究信息',
			iconCls: 'pencil',
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
					
					var rowObj = DetailGrid.getSelectionModel().getSelections();
					var rowid = rowObj[0].get("rowid");
					
					
						
					var prjcn = PrjCNEdit.getValue();
					var destination = DestinationEdit.getValue();
					var content = ContentEdit.getValue();
			   		var check = CheckEdit.getValue();
			   		
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
					url:'herp.srm.srmprojapplydetailexe.csp?action=edit&rowid='+encodeURIComponent(rowid)
					+'&detailrowid1='+encodeURIComponent(detailrowid1)+'&detailrowid2='+encodeURIComponent(detailrowid2)
					+'&PrjCN='+encodeURIComponent(prjcn)+'&Destination='+encodeURIComponent(destination)
					+'&Content='+encodeURIComponent(content)+'&Check='+encodeURIComponent(check),
					waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
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
				  editWin.close();
				} 
				}					
			},
			{
				text : '关闭',iconCls : 'cancel',
				handler : function() {
					editWin.close();
				}
			}]
		});
		editWin.show();	
	
	
	
	
	
	
	
	
	};