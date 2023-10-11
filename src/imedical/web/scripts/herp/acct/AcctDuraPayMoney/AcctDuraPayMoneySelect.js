SelectFun = function()
{	
    var Startyearmonth = new Ext.form.DateField({
		fieldLabel: '��ʼ����',
		name: 'Startyearmonth',
		width: 110,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Y-m',
		editable: false
	
	});
	 var Endyearmonth = new Ext.form.DateField({
		fieldLabel: '��������',
		name: 'Endyearmonth',
		width: 110,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Y-m',
		editable: false
	
	});
	var CompanyNameText = new Ext.form.TextField({
		fieldLabel : '��Ӧ������',
		id : ' CompanyNameText',
		name : ' CompanyNameText',
		width : 120,
		emptyText : '��Ӧ������'
});		



//////////////////// ��ѯ��ť //////////////////////
var findButton = new Ext.Toolbar.Button({
	id:'findbutton',
	text: '��ѯ',
	tooltip: '��ѯ',
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
		fieldLabel: '������������',
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
					data : [['WZ','����'],['WS','����'],['YJ','ҩ��'],['YP','ҩƷ'],['ZC','�̶��ʲ�']]
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
			text : '��������',
			tooltip : '��������',
			iconCls:'option',
			handler : function() {
			var Startyearm=Startyearmonth.getRawValue();
			var Endyearm=Endyearmonth.getRawValue();
			var sys=TotalSysTypeComb.getValue();
	
			if(Startyearm=="")
	        {	
		              Ext.Msg.show({title : 'ע��',
					  msg : '��ѡ����ʼ����',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		    });
		
		     return;
	        }
	        
	        if(Endyearm=="")
	        {	
		              Ext.Msg.show({title : 'ע��',
					  msg : '��ѡ���������',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		    });
		
		     return;
	        }
			if(sys=="")
	        {	
		              Ext.Msg.show({title : 'ע��',
					  msg : '��ѡ��Ӧ�����',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		    });
		
		     return;
	        }
				
				Ext.MessageBox.confirm('��ʾ', '��ȷ���Ƿ���', function(btn){
				       
					if(btn=="yes")
					{
					var username = session['LOGON.USERNAME'];
						Ext.Ajax.request({
				url : 'herp.acct.acctPayMoneymainexe.csp?action=TotalSubmmit&str='+sys+'&StartDate='+Startyearm+'&EndDate='+Endyearm+'&username='+encodeURIComponent(username),
				waitMsg : '�����...',
				failure : function(result, request) {

							Ext.Msg.show({
									title : '����',
									msg : '������������!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
                           
				var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
									Ext.MessageBox.alert('��ʾ','�ɹ����ɸ��');
									 getMainJson=""
                                     getStr=""
									mainGrid.load({params:{start:0,limit:25}});
									SelectGrid.load({params:{start:0,limit:25}});
							} else {
									var message = "SQLErr: "+ jsonData.info;
									Ext.Msg.show({
											title : '����',
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
			text : '����',
			tooltip : '����',
			iconCls:'option',
			handler : function() {
		    var selectedRow=SelectGrid.getSelectionModel().getSelections();
	        var length=selectedRow.length;
			if(length<=0)
	        {	
		              Ext.Msg.show({title : 'ע��',
					  msg : '��ѡ������Ҫ�����Ӧ����',
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
                  Ext.Msg.show({title : 'ע��',
					  msg : '��ѡ�����ƺ������ͬ�Ĺ�Ӧ��',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		           });
		           return;
			}
			else
			{
				Ext.MessageBox.confirm('��ʾ', '��ȷ���Ƿ���', function(btn){
					if(btn=="yes")
					{
					var Str=c.join(",");
						Ext.Ajax.request({
				url : 'herp.acct.acctPayMoneymainexe.csp?action=SubmmitAgain&str='+Str,
				waitMsg : '�����...',
				failure : function(result, request) {

							Ext.Msg.show({
									title : '����',
									msg : '������������!',
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
									Ext.MessageBox.alert('��ʾ','�������');
									window.close();
									
							} else {
									var message = "�������";
									Ext.Msg.show({
											title : '����',
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
//var tbar1 = new Ext.Toolbar(['����:',Totalyearmonth,'-','ϵͳ���:',TotalSysTypeComb,'-',TotalCommitButton]);
	var SelectGrid = new dhc.herp.Grid({
        title: '���ʹ�Ӧ��Ӧ�������ѡ��',
        width: 400,
        region: 'center',
        url: 'herp.acct.acctPayMoneySelectexe.csp',
		atLoad : true,
		//tbar:['һά�룺',DimensionCodeText,'-','�ڼ�:',YearComb,'-',MonthComb,'-',SysComb,'-',DataStateComb,'-',StoreManComb,'-',findButton,'-',CollectDataButton,'-',DeleteDataButton,'-',AuditDataButton,'-',CacelDataButton,'-',VoucherCreateButton],
		//tbar:[AuditDataButton/*,'-',VoucherCreateButton*/],
        tbar:['��ʼ����:','-',Startyearmonth,'-','��������:','-',Endyearmonth,'-','��Ӧ�����:','-',TotalSysTypeComb,'��Ӧ������','-',CompanyNameText,'-',findButton,'-',CommitButton,'-',TotalCommitButton],
		fields: [new Ext.grid.CheckboxSelectionModel({editable:false}),
		{

		     id:'rowid',
		     header: '���ʸ������ݲɼ���ID',
		     allowBlank: false,
		     width:100,
		     align:'right',
		     editable:false,
		     hidden:true,
		     dataIndex: 'rowid'
		}, {
		     id:'AcctYear',
		     header: '���',
		     allowBlank: false,
		     width:80,
		     editable:false,
		     hidden:false,
			 //sortable:true,
		     dataIndex: 'AcctYear'
		    
		},{
		     id:'AcctMonth',
		     header: '�·�',
		     allowBlank: false,
		     width:80,
		     editable:false,
		     hidden:false,
			 //sortable:true,
		     dataIndex: 'AcctMonth'
		} , {
		     id:'SupplierType',
		     header: '��Ӧ�����',
		     allowBlank: false,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'SupplierType'
		},{
		     id:'SupplierCode',
		     header: '��Ӧ�̱���',
		     allowBlank: false,
		     align:'left',		  
		     width:100,
		     editable:false,	     
		     dataIndex: 'SupplierCode'
		     
		
		}, {
		     id:'SupplierName',
		     header: '��Ӧ������',
		     allowBlank: false,
		     align:'left',
		     width:260,
		     editable:false,
		     dataIndex: 'SupplierName'
		},{
		     id:'APCVMContPerson',
		     header: '��������',
		     allowBlank: false,
		     align:'left',
		     width:260,
		     editable:false,
		     dataIndex: 'APCVMContPerson'
		},{
		     id:'APCVMCtrlAcctDR',
		     header: '���б���',
		     allowBlank: false,
		     align:'left',
		     width:160,
		     editable:false,
		     dataIndex: 'APCVMCtrlAcctDR'
		}, {
		     id:'ItemValue',
		     header: '���',
		     allowBlank: false,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'ItemValue'
		}]
    
    });
    

	
	SelectGrid.btnAddHide();  //���ر��水ť
	SelectGrid.btnDeleteHide(); //�������ð�ť
	SelectGrid.btnSaveHide();  //���ر��水ť
	SelectGrid.btnResetHide();  //�������ð�ť
	SelectGrid.btnPrintHide();  //���ش�ӡ��ť
	
	SelectGrid.load(({params:{start:0,limit:25}}));	
	
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
				text : '�ر�'
			});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function() {
		window.close();
	}
	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	// ��ʼ�����
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