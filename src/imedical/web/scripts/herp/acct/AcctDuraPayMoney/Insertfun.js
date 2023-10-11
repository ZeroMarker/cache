InsertFun = function()
{	
              
			     var Supplier=SupplierComb.getRawValue();
			     var SupplierArry=Supplier.split("^");
			     var len=SupplierArry.length;
			     var SupplierCode=""
			     var SupplierName=""
			     if(!Supplier)
			     {
				     Ext.Msg.show({title : '注意',
					  msg : '请选择供应商或导入应付单',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		           });
		           return;
				 }
			     
			     if(len==2)
			     {
				  SupplierCode=SupplierArry[0];
				  SupplierName=SupplierArry[1];
				 }
				if(len==1)
				 {
					 SupplierCode=SupplierComb.getValue();
					 SupplierName=SupplierComb.getRawValue();
			     }
			    
				 var SysType=SysTypeComb.getValue().trim();
				 var BankName=BankNameText.getValue().trim();
				 var BankNo=BankNoText.getValue().trim();
				 var MoneyType=MoneyTypeComb.getValue().trim();
				 var Percent=PercentText.getValue().trim();
				 var BalanceType=BalanceTypeComb.getValue().trim();
				 var Balance=BalanceComb.getValue().trim();
				 var Payable=PayableText.getValue().trim();
				 var ActualSum=ActualSumText.getValue().trim();
				 var Dept=DeptComb.getValue().trim();
				 var PayBillNo=PayableBillNoText.getValue().trim();
				 var use=UseText.getValue().trim();
				 var data=SupplierCode+"^"+SupplierName+"^"+SysType+"^"+BankName+"^"+BankNo+"^"+MoneyType+"^"+Percent+"^"+BalanceType+"^"+Balance+"^"+Payable+"^"+ActualSum+"^"+Dept+"^"+PayBillNo+"^"+use;
				 if (!SysType)
				 {
					 Ext.Msg.show({title : '注意',
					  msg : '请选择系统类别',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		           });
		            return;
			     }
			     if(!BankName)
				 {
					 Ext.Msg.show({title : '注意',
					  msg : '请填写银行名称',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		           });
		            return;
			     }
			     if(!BankNo)
				 {
					 Ext.Msg.show({title : '注意',
					  msg : '请填写银行账号',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		           });
		            return;
			     }
			     if(!MoneyType)
				 {
					 Ext.Msg.show({title : '注意',
					  msg : '请选择资金类型',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		           });
		            return;
			     }
			     
			     if(!Percent)
				 {
					 Ext.Msg.show({title : '注意',
					  msg : '请填写兑换比率',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		           });
		            return;
			     }
			     if(!BalanceType)
				 {
					 Ext.Msg.show({title : '注意',
					  msg : '请选择结算类型',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		           });
		            return;
			     }
			     /*
			     if(!Balance)
				 {
					 Ext.Msg.show({title : '注意',
					  msg : '请选择结算科目',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		           });
		            return;
			     }
			     */
			      if(!ActualSum)
				 {
					 Ext.Msg.show({title : '注意',
					  msg : '请填写实付金额',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		           });
		            return;
			     }
			     
//付款单导入方法--------------------------------------	
if(len==2)		  
{   
				
				
				Ext.MessageBox.confirm('提示', '请确认是否生成付款单', function(btn){
				       
					if(btn=="yes")
					{
					var username = session['LOGON.USERNAME'];
						Ext.Ajax.request({
				url : 'herp.acct.acctPayMoneymainexe.csp?action=submmit&str='+getStr+'&data='+encodeURIComponent(data)+'&username='+encodeURIComponent(username),
				waitMsg : '审核中...',
				failure : function(result, request) {

							Ext.Msg.show({
									title : '错误',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
                           
				var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
									Ext.MessageBox.alert('提示','成功生成付款单');
									 getMainJson=""
                                     getStr=""
                                     SupplierComb.setValue('');
									SysTypeComb.setValue('');
									BankNameText.setValue('');
									BankNoText.setValue('');
									ActualSumText.setValue('');
									PayableBillNoText.setValue('');
									UseText.setValue('');
									mainGrid.load({params:{start:0,limit:25}});
							} else {
									var message = "SQLErr: "+ jsonData.info;
									Ext.Msg.show({
											title : '错误',
											msg : message,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
				}
		});
					
					
					}
					else
					{  
					    return;
				    }
			
		});
		
}
if(len==1)		  
{   
				Ext.MessageBox.confirm('提示', '请确认是否生成付款单', function(btn){
				
					if(btn=="yes")
					{
					var username = session['LOGON.USERNAME'];
						Ext.Ajax.request({
				url : 'herp.acct.acctPayMoneymainexe.csp?action=SubmmitNoDetail&data='+encodeURIComponent(data)+'&username='+encodeURIComponent(username),
				waitMsg : '审核中...',
				failure : function(result, request) {

							Ext.Msg.show({
									title : '错误',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
                           
				var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
									Ext.MessageBox.alert('提示','成功生成付款单');
									mainGrid.load({params:{start:0,limit:25}});
									getMainJson=""
                                    getStr=""
                                    SupplierComb.setValue('');
									SysTypeComb.setValue('');
									BankNameText.setValue('');
									BankNoText.setValue('');
									ActualSumText.setValue('');
									PayableBillNoText.setValue('');
									UseText.setValue('');
									
							} else {
									var message = "SQLErr: "+ jsonData.info;
									Ext.Msg.show({
											title : '错误',
											msg : message,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
				}
		});
					
					}	
					else
					{
						return;
				    }	
			
			
		});
				
}

	
};