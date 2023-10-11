
	var userid=session['LOGON.USERID'];
	var bookID=IsExistAcctBook();
//=================================��ѯ���� FormPanel==========================//
  /*	//����ڼ�
  	var periodDate = new Ext.form.DateField({
		  fieldLabel: '����ڼ�',
		  name: 'periodDate',
		  id: 'dtMonth',  
          width:130, 
          plugins: 'monthPickerPlugin',  
          format: 'Y-m',  
          editable : false,
		  allowBlank : false,
		  emptyText:'��ѡ������...',
		  maxValue : new Date(),
		  plugins: 'monthPickerPlugin',
		  listeners : {
				scope : this,
				'select' : function(dft){
				}	
		  }
  	});*/
      
	//��ʾ��Ƶ�ǰ
var periodDate = new Ext.form.DisplayField({	
    id: 'dtMonth',
    name: 'periodDate',
    style:'text-align:left;color:black;padding-top:3px;', //�ı�����뷽ʽ  
    triggerAction: 'all',
	disabled:false
});

Ext.Ajax.request({
        url:'../csp/herp.acct.inoutpaymentexe.csp?action=GetAcctCurYearMonth&bookId='+bookID,
        method: 'POST',
        success: function(result, request) {
        var jsonData = Ext.util.JSON.decode( result.responseText );
        if (jsonData.success=='true'){
			rtndata= jsonData.info;	
			periodDate.setValue(rtndata);
			
			//alert(rtndata)
                  }
             }
			 
});
	
	//alert(periodDate);
	
	
  	//��֧ƾ֤ģ��
  
  	var acctTempletStore = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','templetNo','templetName'])
	});
	acctTempletStore.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/herp.acct.inoutpaymentexe.csp?action=GetAcctTemplet&bookId='+bookID,method:'POST'});
		ds.baseParams={
			limit:10
		};
	});
	acctTempletStore.load({params:{start:0,limit:10}});
 	var acctTemplet = new Ext.form.ComboBox({
		id : 'acctTemplet',
		fieldLabel : '��֧ƾ֤ģ��',
		store: acctTempletStore,
		emptyText:'��ѡ����֧ƾ֤ģ��...',
		valueField : 'rowid',
		displayField : 'templetName',
		width:200,
		//style:'line-height:16px',
		listWidth : 200,
		allowBlank: true,
		//anchor: '90%',
		value:'', //Ĭ��ֵ
		valueNotFoundText:'',
		triggerAction: 'all',
		mode: 'local', //����ģʽ
		//editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true',
		editable:true,
		resizable:true 	
	
	});
    //----------------- ��ѯ��ť-----------------//
	var buttQuery = new Ext.Button({
    	text:"��ѯ",
    	width:55,
    	iconCls:'find',
    	handler:function(){ Query();}
    
    });
    
 	//------------��ĩ��֧Ԥ��ת--��ť---------//
 	var inOutPaymentEnd = new Ext.Button({
    	text:"&nbsp;��ĩ��֧Ԥ��ת&nbsp;",
		iconCls:'option',
    	handler:function(){ 
	    	//var period = Ext.util.Format.date(periodDate.getValue(),'Y-m');
	    	var tempId = acctTemplet.getValue();
	    	var period = periodDate.getValue();
			
	    	if(userid==""){
		
					AddAcctBook();
			}else{
				 if(tempId==""){
					Ext.Msg.show({title:'����',msg:'��֧��תģ�岻��Ϊ�� ',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}else{
					Ext.MessageBox.confirm('��ʾ', '�Ƿ�Ҫ������ĩ��֧Ԥ��ת? ', function(btn){
				
						if(btn=="yes"){
							//��ȷ�Ͻ��н�תʱ
							Ext.Ajax.request({
								url:'../csp/herp.acct.inoutpaymentexe.csp?action=InOutPayment&period='+period+'&tempId='+tempId+'&bookId='+bookID,
								waitMsg:'��ĩ��֧Ԥ��ת��...',
								failure: function(result, request){
			
									Ext.Msg.show({title:'����',msg:'������������! ',buttons: Ext.Msg.OK});
						
								},
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									var infomsg=jsonData.info;
									if (jsonData.success=='true'){				
										Ext.Msg.show({title:'ע��',msg:'��ת�ɹ� ',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
										 QueryTemp();
									}else if(infomsg=="NoData"){
										Ext.Msg.show({title:'��ʾ',msg:'û�пɽ�ת���� ',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
									}
									
									else
									{
										var message="��ת���ݳ��� ";
										Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
								scope: this
					
							});
						}
					});
				}
		 	}
    	}
    
    });
 	
 	//--------------- ����ƾ֤--��ť---------//
 	var acctBuild = new Ext.Button({
		text : '&nbsp;����ƾ֤',
		width:80,
		tooltip : '����ƾ֤',
		iconCls : 'createvouch',
    	handler:function(){
	  	    //var period = Ext.util.Format.date(periodDate.getValue(),'Y-m');
	  	    var period = periodDate.getValue();
	    	var tempId = acctTemplet.getValue();
	    	if(userid==""){
				AddAcctBook();
			}else{
				 if(tempId==""){
					Ext.Msg.show({title:'����',msg:'��֧��תģ�岻��Ϊ�� ',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}else{
					Ext.MessageBox.confirm('��ʾ', '�Ƿ�Ҫ����ƾ֤? ', function(btn){
					
						if(btn=="yes"){
							//��ȷ�Ͻ��н�תʱ
							Ext.Ajax.request({
								url:'../csp/herp.acct.inoutpaymentexe.csp?action=AcctVouchBuild&period='+period+'&tempId='+tempId+'&bookId='+bookID+'&userid='+userid,
								waitMsg:'ƾ֤������...',
								failure: function(result, request){
			
									Ext.Msg.show({title:'����',msg:'������������! ',buttons: Ext.Msg.OK});
						
								},
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									
									if (jsonData.success=='true'){				
										Ext.Msg.show({title:'ע��',msg:'����ƾ֤�ɹ� ',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
										Query();
									}else{
										var infomsg=jsonData.info;
										if(infomsg.indexOf("hasVouch")==0){
											var vouchNo=infomsg.split("#")[1];
											Ext.Msg.show({title:'ע��',msg:'�û���ڼ��Ѿ�������ƾ֤��δ����  </br>ƾ֤��Ϊ:'+vouchNo,icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
										}else if(infomsg=="00"){
											Ext.Msg.show({title:'ע��',msg:'�û���ڼ�δ������ĩ��֧Ԥ��ת ',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
										}else{
											var message="����ƾ֤ʧ�� ";
											Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										}
									}
								},
								scope: this
					
							});
						}
		
					});
				}	
			}
		}
 	});
   