
function check(button) {
	if (button.locked == true) {
		button.setText("�ֹ����˹ر�");
		button.setTooltip( "�ֹ����˹ر�" );
		checkAndSaveButton.enable();
		ischecked.setValue('unchecked', true);
		var state  =ischecked.getValue().inputValue;
        //ischecked.getValue().inputValue
		DebitGrid.load({
		    params:{
		    start:0,
		    limit:25,
		    state:0
		   }
		
		
	    });
		CreditGrid.load({
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
		DebitGrid.load({
			params:{
			start:0,
			limit:25,
			state:''
			}
	    });
		CreditGrid.load({
		    params:{
			    start:0,
			    limit:25,
				state:''
			}
		});
	}

}

function save(ItemName,SubjName,checkitemId) {
    var savebuttonflag=false;
	var myData=[];
	var DebitrowObj = DebitGrid.getSelectionModel().getSelections();
	var CreditrowObj = CreditGrid.getSelectionModel().getSelections();
	var Debitlen = DebitrowObj.length;
	var Creditlen = CreditrowObj.length;
	//var len1=Debitlen<Creditlen?Debitlen:Creditlen;
	//var len2=Debitlen>Creditlen?Debitlen:Creditlen;
	var SumAmtDebit=0;
	var SumAmtCredit=0;
    ////ȡ�跽����ܺ�
	if (Debitlen < 0){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��֤�Ľ跽����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		
	}
	else{
		
		for(var i=0;i<Debitlen;i++){
			var CheckerName=DebitrowObj[i].get("CheckerName")
			if(CheckerName!=""){
				Ext.Msg.show({title:'ע��',msg:'ѡ������������Ѿ��˶Թ������ݣ�������ѡ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;	
				
			}
			SumAmtDebit=parseFloat(SumAmtDebit)+parseFloat(DebitrowObj[i].get("AmtDebit"));
		}
		var a=["�跽",SumAmtDebit];
	}
	/////ȡ��������ܺ�

	if (Creditlen < 0){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��֤�Ĵ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		
	}
	else{
		
		for(var i=0;i<Creditlen;i++){
			var CheckerNameC=CreditrowObj[i].get("CheckerName")
			if(CheckerNameC!=""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��֤�Ĵ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
				
			}
			SumAmtCredit=parseFloat(SumAmtCredit)+parseFloat(CreditrowObj[i].get("AmtCredit"));
		}
		var b=["����",SumAmtCredit];
	}

	var c=["���",parseFloat(SumAmtDebit)-parseFloat(SumAmtCredit)];
	myData.push(a);
	myData.push(b);
	myData.push(c);
	if(c[1]!=0){
			savebuttonflag=true;
		}


	

		var store = new Ext.data.ArrayStore({
			fields: [
			   {name: 'subj'},
			   {name: 'amount'}
			]
		});
		store.loadData(myData);
	   var grid = new Ext.grid.GridPanel({
	        store: store,
	        columns: [
	            {
	              
	                header   : '��Ŀ', 
	                width    : 160, 
					align    : 'center',
	                sortable : true, 
	                dataIndex: 'subj'
	            },
	            {
	                header   : '<div style="text-align:center">ѡ�н��ϼ�</div>', 
	                width    : 230, 
	                sortable : true, 
	                type:'numberField',
					align: 'right',
					renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					   return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
					},
	                dataIndex: 'amount'
	            }
	           ]
	           
	        
	       
	        // config options for stateful behavior
	       
	    });
	var debitrowidS="";
	var creditrowidS="";
	var window = new Ext.Window({
	  	title: ItemName+'___'+SubjName,
	    width: 500,
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
	      		for(var i = 0; i < Debitlen; i++){		
				  var debitrowid=DebitrowObj[i].get("rowid")
				  if(debitrowidS==""){
					  debitrowidS=debitrowid
					  
				  }else{
					 debitrowidS=debitrowidS+"*"+debitrowid
				  }
				 }
				for(var j=0;j<Creditlen;j++)	{
				   var creditrowid=	CreditrowObj[j].get("rowid")
				    if(creditrowidS==""){
						creditrowidS=creditrowid
					}else{
						creditrowidS=creditrowidS+"*"+creditrowid
					}
					}						
						Ext.Ajax.request({
							url: '../csp/herp.acct.acctmanualdealcacelexe.csp?action=handcheck&&debitrowid='+debitrowidS+'&creditrowid='+creditrowidS+'&checkitemId='+checkitemId+'&checkGroupId='+DebitrowObj[0].get("rowid")+'&userdr='+session['LOGON.USERID'],
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
													//itemGrid.load({params:{start:0, limit:25,SchemDR : curSchemeDr}});
									DebitGrid.load({
										params:{
										start:0,
										limit:25
									   
									   }	
									});
									CreditGrid.load({
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
}
/*
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
		url: '../csp/acctcheckexe.csp?action=autocheck&startdate='+startdate+'&enddate='+enddate
		+'&acctbankName='+acctbankName+'&method='+typename+'&miniAmount='+miniAmount
		+'&maxAmount='+maxAmount+'&settlementNo='+checkno+'&settlementNo='+0+'&userid'+session['LOGON.USERID'],
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			
				Ext.Msg.show({title:'ע��',msg:'����Ϊ'+jsonData.sum+'�ܽ��Ϊ'+jsonData.count,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
*/