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
		if (mainlen < 0){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��֤������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
		}
		else{
			
			for(var i=0;i<mainlen;i++){
				SumDeptAmtDebit=parseFloat(SumDeptAmtDebit)+parseFloat(mainrowObj[i].get("amtdebit"));
				SumDeptAmtCredit=parseFloat(SumDeptAmtCredit)+parseFloat(mainrowObj[i].get("amtcredit"));
			}
		}
		/////ȡ���ж��˵�����ܺ�

		if (detaillen < 0){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��֤������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			
		}
		else{
			
			for(var i=0;i<detaillen;i++){
				SumBankAmtDebit=parseFloat(SumBankAmtDebit)+parseFloat(detailrowObj[i].get("amtcredit"));
				SumBankAmtCredit=parseFloat(SumBankAmtCredit)+parseFloat(detailrowObj[i].get("amtdebit"));
			}
		}




		var a=["�跽",SumDeptAmtDebit,"����",SumBankAmtDebit,SumDeptAmtDebit-SumBankAmtDebit];
		var b=["����",SumDeptAmtCredit,"�跽",SumBankAmtCredit,SumDeptAmtCredit-SumBankAmtCredit];
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
	              
	                header   : '���ж��˵�', 
	                width    : 80, 
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
	                header   : '��λ���˵�ѡ��', 
	                width    : 100, 
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
					for(var i = 0; i < mainlen; i++){	
						for(var j=0;j<detaillen;j++)	{			
							Ext.Ajax.request({
								url: '../csp/herp.acct.acctcheckexe.csp?action=handcheck&&bankrowid='+detailrowObj[j].get("rowid")+'&companyrowid='+mainrowObj[i].get("rowid")+'&checkGroupId='+detailrowObj[0].get("rowid")+'&userid='+session['LOGON.USERID'],
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
					}
				}
			},{
				text: 'ȡ��',
				handler: function(){window.close();}
			}]
		});
		window.show();

};
function autoCheck() {
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
        var state  =ischecked.getValue().inputValue;

	Ext.Ajax.request({
		url: '../csp/herp.acct.acctcheckexe.csp?action=autocheck&startdate='+startdate+'&enddate='+enddate
		+'&acctbankName='+acctbankName+'&method='+typename+'&miniAmount='+miniAmount
		+'&maxAmount='+maxAmount+'&settlementNo='+checkno+'&settlementNo='+0+'&userid'+session['LOGON.USERID'],
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			
				Ext.Msg.show({title:'ע��',msg:'����Ϊ'+jsonData.sum+'  �ܽ��Ϊ'+jsonData.count,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
			
		
		},
	  	scope: this
	});
}