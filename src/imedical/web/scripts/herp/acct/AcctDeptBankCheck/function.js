function check(button) {
	if (button.locked == true) {
		button.setText("手工对账关闭");
		button.setTooltip( "手工对账关闭" );
		checkAndSaveButton.enable();
		ischecked.setValue('unchecked', true);
		 var state  =ischecked.getValue().inputValue;
        //ischecked.getValue().inputValue
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,
		    state:0
		   }
		
		
	  });
		Detail.load({
		    params:{
			    start:0,
			    limit:25,
				state:0
			   }
			
			
		  });
		button.locked = false;
	} else if (button.locked == false) {
		button.setText("手工对账开启");
		button.setTooltip( "手工对账开启" );
		ischecked.setValue('all', true);
		checkAndSaveButton.disable();
		button.locked = true;
				itemGrid.load({
		    params:{
		    start:0,
		    limit:25,
		    state:''
		   }
		
		
	  });
		Detail.load({
		    params:{
			    start:0,
			    limit:25,
				state:''
			   }

		  });
	}

}
function save() {

		var savebuttonflag=false;
		var myData=[];
		var mainrowObj = itemGrid.getSelectionModel().getSelections();
		var detailrowObj = Detail.getSelectionModel().getSelections();
		var mainlen = mainrowObj.length;
		var detaillen = detailrowObj.length;
		//var len1=mainlen<detaillen?mainlen:detaillen;
		//var len2=mainlen>detaillen?mainlen:detaillen;
		var SumDeptAmtDebit=0;
		var SumDeptAmtCredit=0;
		var SumBankAmtDebit=0;
		var SumBankAmtCredit=0;
		 ////取单位金额总和
		 //alert(mainlen);
		if (mainlen < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要验证的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
		}
		else{
			
			for(var i=0;i<mainlen;i++){
				var ischeckedm=mainrowObj[i].get("ischecked")
				if(ischeckedm=="已对"){
				Ext.Msg.show({title:'注意',msg:'选择的数据中有已经核对过的数据，请重新选择!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;		
				}
				SumDeptAmtDebit=parseFloat(SumDeptAmtDebit)+parseFloat(mainrowObj[i].get("amtdebit"));
				SumDeptAmtCredit=parseFloat(SumDeptAmtCredit)+parseFloat(mainrowObj[i].get("amtcredit"),10);
				//alert(parseFloat(mainrowObj[i].get("amtcredit")),10);
				//alert(SumDeptAmtCredit);
			}
		}
		/////取银行对账单金额总和

		if (detaillen < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要验证的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			
		}
		else{
			
			for(var i=0;i<detaillen;i++){
				
				var ischeckedd=detailrowObj[i].get("ischecked")
				if(ischeckedd=="已对"){
				Ext.Msg.show({title:'注意',msg:'选择的数据中有已经核对过的数据，请重新选择!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;		
				}
				
				SumBankAmtDebit=parseFloat(SumBankAmtDebit)+parseFloat(detailrowObj[i].get("amtcredit"));
				SumBankAmtCredit=parseFloat(SumBankAmtCredit)+parseFloat(detailrowObj[i].get("amtdebit"));
				//alert(SumBankAmtCredit);
				
			}
		}

       // alert(SumDeptAmtDebit+"^"+SumDeptAmtCredit+"---"+SumBankAmtDebit+"^"+SumBankAmtCredit);

		var a=["借方",SumDeptAmtDebit,"贷方",SumBankAmtDebit,SumDeptAmtDebit-SumBankAmtDebit];
		var b=["贷方",SumDeptAmtCredit,"借方",SumBankAmtCredit,SumDeptAmtCredit-SumBankAmtCredit];
		//alert(b+"^"+a);
		myData.push(a);
		myData.push(b);
		if(a[4]||b[4]){
			savebuttonflag=true;
		}

	
	



		var store = new Ext.data.ArrayStore({
			fields: [
			   {name: 'bank'},
			   {name: 'bankamount',      type: 'float'},
			   {name: 'department'},
			   {name: 'departmentamount',  type: 'float'},
			   {name: 'balance',  type: 'float'},
			]
		});
		store.loadData(myData);
	    var grid = new Ext.grid.GridPanel({
	        store: store,
	        columns: [
	            {
	              
	                header   : '单位对账单选中', 
	                width    : 100, 
				    align:'center',
	                sortable : true, 
	                dataIndex: 'bank'
	            },
	            {
	                header   : '金额', 
	                width    : 120, 
					align:'center',
	                sortable : true, 
	                renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					   return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
					},
	                dataIndex: 'bankamount'
	            },
	            {
	                header   : '银行对账单', 
	                width    : 80, 
					 align:'center',
	                sortable : true, 
	                dataIndex: 'department'
	            },
	            {
	                header   : '金额', 
	                width    : 120, 
	                sortable : true, 
				    align:'center',
	                renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					   return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
					},
	                dataIndex: 'departmentamount'
	            },
	            {
	                header   : '差额', 
	                width    : 120, 
	                sortable : true, 
					align:'center',
	                renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					   return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
					},
	                dataIndex: 'balance'
	            }]
	           
	        
	       
	        // config options for stateful behavior
	       
	    });
		
		var bankrowidS="";
		var companyrowidS="";
		var window = new Ext.Window({
			title: '手工对账并保存',
			width: 600,
			height:200,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			//buttonAlign : "sorth",
			items:grid,
			buttons: [{
				text: '保存',
				disabled:savebuttonflag,
				handler: function() {
					for(var i = 0; i < detaillen; i++){	
					 var bankrowid=detailrowObj[i].get("rowid")
					 if(bankrowidS==""){
						 bankrowidS=bankrowid
					 }else{
						 bankrowidS=bankrowidS+"*"+bankrowid
					 }
					
					  }
					  
						for(var j=0;j<mainlen;j++)	{	
                           var companyrowid=mainrowObj[j].get("rowid")
						   if(companyrowidS==""){
						 companyrowidS=companyrowid
					      }else{
						  companyrowidS=companyrowidS+"*"+companyrowid
					      }
						   
                        	}
											
							Ext.Ajax.request({                                            
								url: '../csp/herp.acct.acctcheckexe.csp?action=handcheck&&bankrowid='+bankrowidS+'&companyrowid='+companyrowidS+'&checkGroupId='+detailrowObj[0].get("rowid")+'&bookID='+bookID,
								failure: function(result, request) {
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Ext.Msg.show({title:'注意',msg:'处理成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										//itemGrid.load({params:{start:0, limit:25,SchemDR : curSchemeDr}});
										itemGrid.load({
											params:{
											start:0,
											limit:25
										   
										   }
										});
										Detail.load({
											params:{
												start:0,
												limit:25
											   }
											
											
										  });
										window.close();
									}
									else {
										var tmpMsg = jsonData.info+"处理失败!";
										Ext.Msg.show({title:'错误',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
								scope: this
							});
					
				}
			},{
				text: '取消',
				handler: function(){window.close();}
			}]
		});
		window.show();

};
function autoCheck() {
	/////业务时间
    var OccurDateField = new Ext.form.Checkbox({
        id : 'OccurDate',
        fieldLabel: '业务时间',
		labelSeparator:''//去掉冒号
        
    });

	/////结算方式
    var CheqTypeField = new Ext.form.Checkbox({
        id : 'CheqType',
        fieldLabel: '结算方式'
    });
	/////票据号
    var CheqNoField = new Ext.form.Checkbox({
        id : 'CheqNo',
        fieldLabel: '票据号'
    });
	/////金额
    var AmountField = new Ext.form.Checkbox({
        id : 'Amount',
        fieldLabel: '金额',
		disabled : true,
		checked:true
    });
    
	//***定义结构***//
	var colItems =	[{    
		items:[{xtype:'panel',layout:'column',
				items: [{
					xtype : '',
					text : '',
					style:'text-align:left;padding-top:20px;',
					columnWidth:.36
				},OccurDateField,
				{
					xtype : 'tbtext',
					text : '业务时间',
					style:'padding:5px 0px 5px 5px;',
					columnWidth:.5
				}]
			},{xtype:'panel',layout:'column',
				items: [{
					xtype : '',
					text : '',
					style:'text-align:left;padding-top:20px;',
					columnWidth:.36
				},CheqTypeField,
				{
					xtype : 'tbtext',
					text : '结算方式',
					style:'padding:5px 0px 5px 5px;',
					columnWidth:.5
				}]
			},{xtype:'panel',layout:'column',
				items: [{
					xtype : '',
					text : '',
					style:'text-align:left;padding-top:20px;',
					columnWidth:.36
				},CheqNoField,
				{
					xtype : 'tbtext',
					text : '票据号',
					style:'padding:5px 0px 5px 5px;',
					columnWidth:.5
				}]
			},{xtype:'panel',layout:'column',
				items: [{
					xtype : '',
					text : '',
					style:'text-align:left;padding-top:20px;',
					columnWidth:.36
				},AmountField,
				{
					xtype : 'tbtext',
					text : '金额',
					style:'padding:5px 0px 5px 5px;',
					columnWidth:.5
				}]
			}]
	}];	
	//***加载面板(框架)***//
	var formPanel = new Ext.form.FormPanel({
		//labelWidth: 80,
		frame: true,
		items: colItems
	});
	//***确定按钮***//
	addButton = new Ext.Toolbar.Button({
		text:'确定'
	});
	addHandler = function(){
		var startdate= startDateField.getValue();
		if (startdate!=="")
		{
		   startdate=startdate.format ('Y-m-d');
		}
		//alert(startdate);
		var enddate = endDateField.getValue();
		if (enddate!=="")
		{
		   enddate=enddate.format ('Y-m-d');
		}
		var acctbankName =bankCombo.getValue();
		var typename = cheqtypename.getValue(); 
		var miniAmount = miniAmountField.getValue();
		var  maxAmount= maxAmountField.getValue();
		var checkno = cheqno.getValue();
		var IsOccurDate=Ext.getCmp('OccurDate').getValue();
		if(IsOccurDate==true){
			IsOccurDate=1;
		}else{
			IsOccurDate=0;
		}
		var IsCheqType=Ext.getCmp('CheqType').getValue();
		if(IsCheqType==true){
			IsCheqType=1;
		}else{
			IsCheqType=0;
		}
		var IsCheqNo=Ext.getCmp('CheqNo').getValue();
		if(IsCheqNo==true){
			IsCheqNo=1;
		}else{
			IsCheqNo=0;
		}
		var progressBar = Ext.Msg.show({
									title : "自动核销",
									msg : "'数据正在处理中...",
									width : 300,
									wait : true,
									closable : true
		});
		Ext.Ajax.request({
			url: '../csp/herp.acct.acctcheckexe.csp?action=autocheck&startdate='+startdate+'&enddate='+enddate
			+'&acctbankName='+acctbankName+'&method='+typename+'&miniAmount='+miniAmount
			+'&maxAmount='+maxAmount+'&settlementNo='+checkno+'&bookID='+bookID
			+'&IsCheqNo='+IsCheqNo+'&IsCheqType='+IsCheqType+'&IsOccurDate='+IsOccurDate,
			failure: function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				
					Ext.Msg.show({title:'注意',msg:'总数为'+jsonData.count+'  总金额为'+jsonData.sum,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					//itemGrid.load({params:{start:0, limit:25,SchemDR : curSchemeDr}});
					itemGrid.load({
						params:{
						start:0,
						limit:25
						}
					});
					Detail.load({
						params:{
							start:0,
							limit:25
						}
					});
					addwin.close();
					window.close();
		
			},
		scope: this
	});
	
		
	};
	//***添加监听事件***//	
	addButton.addListener('click',addHandler,false);

	cancelButton = new Ext.Toolbar.Button({
		text:'取消'
	});
	
	cancelHandler = function(){
		addwin.close();
	}
	
	cancelButton.addListener('click',cancelHandler,false);
	addwin = new Ext.Window({
		title: '对账条件',
		width: 330,
		height: 260,
		layout: 'fit',
		plain:true,
		modal:true,
		buttonAlign:'center',
		items: formPanel,
		buttons: [
			addButton,
			cancelButton
		]
	});		
	addwin.show();	
		
}