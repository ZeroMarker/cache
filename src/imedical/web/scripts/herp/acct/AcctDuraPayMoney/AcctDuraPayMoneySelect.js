SelectFun = function()
{	
    var Startyearmonth = new Ext.form.DateField({
		fieldLabel: '起始年月',
		name: 'Startyearmonth',
		width: 110,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Y-m',
		editable: false
	
	});
	 var Endyearmonth = new Ext.form.DateField({
		fieldLabel: '结束年月',
		name: 'Endyearmonth',
		width: 110,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Y-m',
		editable: false
	
	});
	var CompanyNameText = new Ext.form.TextField({
		fieldLabel : '供应商名称',
		id : ' CompanyNameText',
		name : ' CompanyNameText',
		width : 120,
		emptyText : '供应商名称'
});		



//////////////////// 查询按钮 //////////////////////
var findButton = new Ext.Toolbar.Button({
	id:'findbutton',
	text: '查询',
	tooltip: '查询',
	iconCls: 'find',
	handler: function(){
	   	var Start=Startyearmonth.getValue();
	   	var End=Endyearmonth.getValue();
		var Supplier=CompanyNameText.getValue();
		var sys=TotalSysTypeComb.getValue();
		SelectGrid.load({params:{start:0,limit:25,StartDate:Start,EndDate:End,str:Supplier,sys:sys}});
	}
});


 var Totalyearmonth = new Ext.form.DateField({
		fieldLabel: '批量生成年月',
		name: 'Totalyearmonth',
		width: 110,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Y-m',
		editable: false
	
	});
	var TotalSysTypeComb = new Ext.form.ComboBox({												
			width:60,
			listWidth : 150,
			anchor: '95%',
			store : new Ext.data.ArrayStore({
					fields : ['code', 'name'],
					data : [['WZ','总务'],['WS','卫材'],['YJ','药剂'],['YP','药品'],['ZC','固定资产']]
				}),
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			selectOnFocus:'true',
			columnWidth : .13
});	

var TotalCommitButton = new Ext.Toolbar.Button({
			text : '批量生成',
			tooltip : '批量生成',
			iconCls:'option',
			handler : function() {
			var Startyearm=Startyearmonth.getRawValue();
			var Endyearm=Endyearmonth.getRawValue();
			var sys=TotalSysTypeComb.getValue();
	
			if(Startyearm=="")
	        {	
		              Ext.Msg.show({title : '注意',
					  msg : '请选择起始年月',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		    });
		
		     return;
	        }
	        
	        if(Endyearm=="")
	        {	
		              Ext.Msg.show({title : '注意',
					  msg : '请选择结束年月',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		    });
		
		     return;
	        }
			if(sys=="")
	        {	
		              Ext.Msg.show({title : '注意',
					  msg : '请选择供应商类别',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		    });
		
		     return;
	        }
				
				Ext.MessageBox.confirm('提示', '请确认是否导入', function(btn){
				       
					if(btn=="yes")
					{
					var username = session['LOGON.USERNAME'];
						Ext.Ajax.request({
				url : 'herp.acct.acctPayMoneymainexe.csp?action=TotalSubmmit&str='+sys+'&StartDate='+Startyearm+'&EndDate='+Endyearm+'&username='+encodeURIComponent(username),
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
									mainGrid.load({params:{start:0,limit:25}});
									SelectGrid.load({params:{start:0,limit:25}});
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
				
				
				
			}})
var CommitButton = new Ext.Toolbar.Button({
			text : '导入',
			tooltip : '导入',
			iconCls:'option',
			handler : function() {
		    var selectedRow=SelectGrid.getSelectionModel().getSelections();
	        var length=selectedRow.length;
			if(length<=0)
	        {	
		              Ext.Msg.show({title : '注意',
					  msg : '请选择您需要导入的应付单',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		    });
		
		     return;
	        }
	        
	        var a=[];
	       
	        for(var i=0;i<=length-1;i++)
	        {
		        var SupplierCode = selectedRow[i].data['SupplierCode'];
		        a[i]=SupplierCode;
		    }
		   
		     var c=[];
	        
	        for(var i=0;i<=length-1;i++)
	        {
		        var rowid = selectedRow[i].data['rowid'];
		        c[i]=rowid;
		    }
		 
		    var len=a.length;
		    var n=0;
	        for(var i=0;i<=len-1;i++)
	        {
		       if(a[i]==a[0])
		       n++;
		    }
		    
		    
		    var m=[];
	       
	        for(var i=0;i<=length-1;i++)
	        {
		        var SupplierType = selectedRow[i].data['SupplierType'];
		        m[i]=SupplierType;
		    }
		    
		    var len=a.length;
		    var h=0;
	        for(var i=0;i<=len-1;i++)
	        {
		       if(m[i]==m[0])
		       h++;
		    }
		   
				
			if(!(n==len&&h==len))
			{
                  Ext.Msg.show({title : '注意',
					  msg : '请选择名称和类别相同的供应商',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		           });
		           return;
			}
			else
			{
				Ext.MessageBox.confirm('提示', '请确认是否导入', function(btn){
					if(btn=="yes")
					{
					var Str=c.join(",");
						Ext.Ajax.request({
				url : 'herp.acct.acctPayMoneymainexe.csp?action=SubmmitAgain&str='+Str,
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
                            var jsonresult= result.responseText.split("^"); 
                            
                            getMainJson= jsonresult[0];  
                            getStr=jsonresult[1];
                            var  resultStr=jsonresult[2];                           
							
							var jsonData=getMainJson.split("||");
							var SupplierCode=jsonData[0];
							var SupplierName=jsonData[1];
							var BankName=jsonData[2];
							var BankNo=jsonData[3];
							var PayableSum=jsonData[4];
							var ActualSum=jsonData[5];
							var SysType =jsonData[6];
							var Supplier=SupplierCode+"^"+SupplierName;
							
							SupplierComb.setRawValue(Supplier);
							BankNameText.setValue(BankName);
							BankNoText.setValue(BankNo);
							PayableText.setValue(PayableSum);
							ActualSumText.setValue(ActualSum);
							
							SysTypeComb.setValue(SysType);
							
						
							if (resultStr=="0") {
									Ext.MessageBox.alert('提示','导入完成');
									window.close();
									
							} else {
									var message = "意外错误";
									Ext.Msg.show({
											title : '错误',
											msg : message,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
										window.close();
							}
				},
				scope : this
				
		});
				}	
				
				else
				{
					return;
				}	
					
				})
				
		    }
			}
			
			
		});
//var tbar1 = new Ext.Toolbar(['年月:',Totalyearmonth,'-','系统类别:',TotalSysTypeComb,'-',TotalCommitButton]);
	var SelectGrid = new dhc.herp.Grid({
        title: '物资供应商应付款管理选择',
        width: 400,
        region: 'center',
        url: 'herp.acct.acctPayMoneySelectexe.csp',
		atLoad : true,
		//tbar:['一维码：',DimensionCodeText,'-','期间:',YearComb,'-',MonthComb,'-',SysComb,'-',DataStateComb,'-',StoreManComb,'-',findButton,'-',CollectDataButton,'-',DeleteDataButton,'-',AuditDataButton,'-',CacelDataButton,'-',VoucherCreateButton],
		//tbar:[AuditDataButton/*,'-',VoucherCreateButton*/],
        tbar:['起始年月:','-',Startyearmonth,'-','结束年月:','-',Endyearmonth,'-','供应商类别:','-',TotalSysTypeComb,'供应商名称','-',CompanyNameText,'-',findButton,'-',CommitButton,'-',TotalCommitButton],
		fields: [new Ext.grid.CheckboxSelectionModel({editable:false}),
		{

		     id:'rowid',
		     header: '物资付款数据采集表ID',
		     allowBlank: false,
		     width:100,
		     align:'right',
		     editable:false,
		     hidden:true,
		     dataIndex: 'rowid'
		}, {
		     id:'AcctYear',
		     header: '年度',
		     allowBlank: false,
		     width:80,
		     editable:false,
		     hidden:false,
			 //sortable:true,
		     dataIndex: 'AcctYear'
		    
		},{
		     id:'AcctMonth',
		     header: '月份',
		     allowBlank: false,
		     width:80,
		     editable:false,
		     hidden:false,
			 //sortable:true,
		     dataIndex: 'AcctMonth'
		} , {
		     id:'SupplierType',
		     header: '供应商类别',
		     allowBlank: false,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'SupplierType'
		},{
		     id:'SupplierCode',
		     header: '供应商编码',
		     allowBlank: false,
		     align:'left',		  
		     width:100,
		     editable:false,	     
		     dataIndex: 'SupplierCode'
		     
		
		}, {
		     id:'SupplierName',
		     header: '供应商名称',
		     allowBlank: false,
		     align:'left',
		     width:260,
		     editable:false,
		     dataIndex: 'SupplierName'
		},{
		     id:'APCVMContPerson',
		     header: '银行名称',
		     allowBlank: false,
		     align:'left',
		     width:260,
		     editable:false,
		     dataIndex: 'APCVMContPerson'
		},{
		     id:'APCVMCtrlAcctDR',
		     header: '银行编码',
		     allowBlank: false,
		     align:'left',
		     width:160,
		     editable:false,
		     dataIndex: 'APCVMCtrlAcctDR'
		}, {
		     id:'ItemValue',
		     header: '金额',
		     allowBlank: false,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'ItemValue'
		}]
    
    });
    

	
	SelectGrid.btnAddHide();  //隐藏保存按钮
	SelectGrid.btnDeleteHide(); //隐藏重置按钮
	SelectGrid.btnSaveHide();  //隐藏保存按钮
	SelectGrid.btnResetHide();  //隐藏重置按钮
	SelectGrid.btnPrintHide();  //隐藏打印按钮
	
	SelectGrid.load(({params:{start:0,limit:25}}));	
	
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
				text : '关闭'
			});

	// 定义取消按钮的响应函数
	cancelHandler = function() {
		window.close();
	}
	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [SelectGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				plain : true,
				width : 1000,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
	
	
};