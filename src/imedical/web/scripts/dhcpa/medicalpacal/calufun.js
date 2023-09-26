//计算
var userdr = session['LOGON.USERCODE'];

Calufun = function(){
 var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
    var len = rowObj.length;
    if(len > 0)
    {  
    	Ext.MessageBox.confirm('提示', 
    	    '确定要计算选定的行?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				    var  curstate=rowObj[0].get("auditstate");
					if ((curstate=="发布"))
					{
					Ext.Msg.show({title:'错误',msg:'已提交不能再计算!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				 	else{
				        for(var i = 0; i < len; i++){   
					  //cycleDr, frequency, period, schemDr,userCode
					      var cycleDr = rowObj[i].get("yearid");
						  var frequency = rowObj[i].get("frequency");
						  var period = rowObj[i].get("changedperiod");
						  var schemDr = rowObj[i].get("srowid");
						
					          Ext.Ajax.request({
					              	url: 'dhc.pa.basicuintpacaluexe.csp'+'?action=calu&cycleDr='+cycleDr+'&frequency='+frequency+'&period='+period+'&schemDr='+schemDr+'&userCode='+userCode,
									waitMsg:'计算中...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
									success: function(result, request){
											//console.log(result.responseText);
										var jsonData = Ext.util.JSON.decode( result.responseText );
										if (jsonData.success=='true') { 
											Ext.MessageBox.alert('提示', '计算完成');
											//alert(userdr);
											itemGrid.load({params:{start:0, limit:25,userCode:userCode}});
										}
										else {
											var message = "计算失败";
											Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										}
									},
					               scope: this
					          });
			        	}
					 }
			    }
		    } 
		);	
    }
    else
    {
    	Ext.Msg.show({title:'提示',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
    }       
	
};