function check(button) {
	if (button.locked == true) {
		button.setText("�ֹ����˹ر�");
		button.setTooltip( "�ֹ����˹ر�" );
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
		button.setText("�ֹ����˿���");
		button.setTooltip( "�ֹ����˿���" );
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
		 ////ȡ��λ����ܺ�
		 //alert(mainlen);
		if (mainlen < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��֤������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
		}
		else{
			
			for(var i=0;i<mainlen;i++){
				var ischeckedm=mainrowObj[i].get("ischecked")
				if(ischeckedm=="�Ѷ�"){
				Ext.Msg.show({title:'ע��',msg:'ѡ������������Ѿ��˶Թ������ݣ�������ѡ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;		
				}
				SumDeptAmtDebit=parseFloat(SumDeptAmtDebit)+parseFloat(mainrowObj[i].get("amtdebit"));
				SumDeptAmtCredit=parseFloat(SumDeptAmtCredit)+parseFloat(mainrowObj[i].get("amtcredit"),10);
				//alert(parseFloat(mainrowObj[i].get("amtcredit")),10);
				//alert(SumDeptAmtCredit);
			}
		}
		/////ȡ���ж��˵�����ܺ�

		if (detaillen < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��֤������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			
		}
		else{
			
			for(var i=0;i<detaillen;i++){
				
				var ischeckedd=detailrowObj[i].get("ischecked")
				if(ischeckedd=="�Ѷ�"){
				Ext.Msg.show({title:'ע��',msg:'ѡ������������Ѿ��˶Թ������ݣ�������ѡ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;		
				}
				
				SumBankAmtDebit=parseFloat(SumBankAmtDebit)+parseFloat(detailrowObj[i].get("amtcredit"));
				SumBankAmtCredit=parseFloat(SumBankAmtCredit)+parseFloat(detailrowObj[i].get("amtdebit"));
				//alert(SumBankAmtCredit);
				
			}
		}

       // alert(SumDeptAmtDebit+"^"+SumDeptAmtCredit+"---"+SumBankAmtDebit+"^"+SumBankAmtCredit);

		var a=["�跽",SumDeptAmtDebit,"����",SumBankAmtDebit,SumDeptAmtDebit-SumBankAmtDebit];
		var b=["����",SumDeptAmtCredit,"�跽",SumBankAmtCredit,SumDeptAmtCredit-SumBankAmtCredit];
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
	              
	                header   : '��λ���˵�ѡ��', 
	                width    : 100, 
				    align:'center',
	                sortable : true, 
	                dataIndex: 'bank'
	            },
	            {
	                header   : '���', 
	                width    : 120, 
					align:'center',
	                sortable : true, 
	                renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					   return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
					},
	                dataIndex: 'bankamount'
	            },
	            {
	                header   : '���ж��˵�', 
	                width    : 80, 
					 align:'center',
	                sortable : true, 
	                dataIndex: 'department'
	            },
	            {
	                header   : '���', 
	                width    : 120, 
	                sortable : true, 
				    align:'center',
	                renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					   return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
					},
	                dataIndex: 'departmentamount'
	            },
	            {
	                header   : '���', 
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
			title: '�ֹ����˲�����',
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
				text: '����',
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
									Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Ext.Msg.show({title:'ע��',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
										var tmpMsg = jsonData.info+"����ʧ��!";
										Ext.Msg.show({title:'����',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
								scope: this
							});
					
				}
			},{
				text: 'ȡ��',
				handler: function(){window.close();}
			}]
		});
		window.show();

};
function autoCheck() {
	/////ҵ��ʱ��
    var OccurDateField = new Ext.form.Checkbox({
        id : 'OccurDate',
        fieldLabel: 'ҵ��ʱ��',
		labelSeparator:''//ȥ��ð��
        
    });

	/////���㷽ʽ
    var CheqTypeField = new Ext.form.Checkbox({
        id : 'CheqType',
        fieldLabel: '���㷽ʽ'
    });
	/////Ʊ�ݺ�
    var CheqNoField = new Ext.form.Checkbox({
        id : 'CheqNo',
        fieldLabel: 'Ʊ�ݺ�'
    });
	/////���
    var AmountField = new Ext.form.Checkbox({
        id : 'Amount',
        fieldLabel: '���',
		disabled : true,
		checked:true
    });
    
	//***����ṹ***//
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
					text : 'ҵ��ʱ��',
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
					text : '���㷽ʽ',
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
					text : 'Ʊ�ݺ�',
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
					text : '���',
					style:'padding:5px 0px 5px 5px;',
					columnWidth:.5
				}]
			}]
	}];	
	//***�������(���)***//
	var formPanel = new Ext.form.FormPanel({
		//labelWidth: 80,
		frame: true,
		items: colItems
	});
	//***ȷ����ť***//
	addButton = new Ext.Toolbar.Button({
		text:'ȷ��'
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
									title : "�Զ�����",
									msg : "'�������ڴ�����...",
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
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				
					Ext.Msg.show({title:'ע��',msg:'����Ϊ'+jsonData.count+'  �ܽ��Ϊ'+jsonData.sum,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
	//***��Ӽ����¼�***//	
	addButton.addListener('click',addHandler,false);

	cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});
	
	cancelHandler = function(){
		addwin.close();
	}
	
	cancelButton.addListener('click',cancelHandler,false);
	addwin = new Ext.Window({
		title: '��������',
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