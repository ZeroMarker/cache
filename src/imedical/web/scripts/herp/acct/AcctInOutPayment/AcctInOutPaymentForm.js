
	var userid=session['LOGON.USERID'];
	var bookID=IsExistAcctBook();
//=================================查询条件 FormPanel==========================//
  /*	//会计期间
  	var periodDate = new Ext.form.DateField({
		  fieldLabel: '会计期间',
		  name: 'periodDate',
		  id: 'dtMonth',  
          width:130, 
          plugins: 'monthPickerPlugin',  
          format: 'Y-m',  
          editable : false,
		  allowBlank : false,
		  emptyText:'请选择年月...',
		  maxValue : new Date(),
		  plugins: 'monthPickerPlugin',
		  listeners : {
				scope : this,
				'select' : function(dft){
				}	
		  }
  	});*/
      
	//显示会计当前
var periodDate = new Ext.form.DisplayField({	
    id: 'dtMonth',
    name: 'periodDate',
    style:'text-align:left;color:black;padding-top:3px;', //文本框对齐方式  
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
	
	
  	//收支凭证模板
  
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
		fieldLabel : '收支凭证模板',
		store: acctTempletStore,
		emptyText:'请选择收支凭证模板...',
		valueField : 'rowid',
		displayField : 'templetName',
		width:200,
		//style:'line-height:16px',
		listWidth : 200,
		allowBlank: true,
		//anchor: '90%',
		value:'', //默认值
		valueNotFoundText:'',
		triggerAction: 'all',
		mode: 'local', //本地模式
		//editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true',
		editable:true,
		resizable:true 	
	
	});
    //----------------- 查询按钮-----------------//
	var buttQuery = new Ext.Button({
    	text:"查询",
    	width:55,
    	iconCls:'find',
    	handler:function(){ Query();}
    
    });
    
 	//------------期末收支预结转--按钮---------//
 	var inOutPaymentEnd = new Ext.Button({
    	text:"&nbsp;期末收支预结转&nbsp;",
		iconCls:'option',
    	handler:function(){ 
	    	//var period = Ext.util.Format.date(periodDate.getValue(),'Y-m');
	    	var tempId = acctTemplet.getValue();
	    	var period = periodDate.getValue();
			
	    	if(userid==""){
		
					AddAcctBook();
			}else{
				 if(tempId==""){
					Ext.Msg.show({title:'错误',msg:'收支结转模板不能为空 ',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}else{
					Ext.MessageBox.confirm('提示', '是否要进行期末收支预结转? ', function(btn){
				
						if(btn=="yes"){
							//当确认进行结转时
							Ext.Ajax.request({
								url:'../csp/herp.acct.inoutpaymentexe.csp?action=InOutPayment&period='+period+'&tempId='+tempId+'&bookId='+bookID,
								waitMsg:'期末收支预结转中...',
								failure: function(result, request){
			
									Ext.Msg.show({title:'错误',msg:'请检查网络连接! ',buttons: Ext.Msg.OK});
						
								},
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									var infomsg=jsonData.info;
									if (jsonData.success=='true'){				
										Ext.Msg.show({title:'注意',msg:'结转成功 ',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
										 QueryTemp();
									}else if(infomsg=="NoData"){
										Ext.Msg.show({title:'提示',msg:'没有可结转内容 ',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
									}
									
									else
									{
										var message="结转数据出错 ";
										Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
 	
 	//--------------- 生成凭证--按钮---------//
 	var acctBuild = new Ext.Button({
		text : '&nbsp;生成凭证',
		width:80,
		tooltip : '生成凭证',
		iconCls : 'createvouch',
    	handler:function(){
	  	    //var period = Ext.util.Format.date(periodDate.getValue(),'Y-m');
	  	    var period = periodDate.getValue();
	    	var tempId = acctTemplet.getValue();
	    	if(userid==""){
				AddAcctBook();
			}else{
				 if(tempId==""){
					Ext.Msg.show({title:'错误',msg:'收支结转模板不能为空 ',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}else{
					Ext.MessageBox.confirm('提示', '是否要生成凭证? ', function(btn){
					
						if(btn=="yes"){
							//当确认进行结转时
							Ext.Ajax.request({
								url:'../csp/herp.acct.inoutpaymentexe.csp?action=AcctVouchBuild&period='+period+'&tempId='+tempId+'&bookId='+bookID+'&userid='+userid,
								waitMsg:'凭证生成中...',
								failure: function(result, request){
			
									Ext.Msg.show({title:'错误',msg:'请检查网络连接! ',buttons: Ext.Msg.OK});
						
								},
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									
									if (jsonData.success=='true'){				
										Ext.Msg.show({title:'注意',msg:'生成凭证成功 ',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
										Query();
									}else{
										var infomsg=jsonData.info;
										if(infomsg.indexOf("hasVouch")==0){
											var vouchNo=infomsg.split("#")[1];
											Ext.Msg.show({title:'注意',msg:'该会计期间已经生成了凭证且未作废  </br>凭证号为:'+vouchNo,icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
										}else if(infomsg=="00"){
											Ext.Msg.show({title:'注意',msg:'该会计期间未进行期末收支预结转 ',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
										}else{
											var message="生成凭证失败 ";
											Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
   