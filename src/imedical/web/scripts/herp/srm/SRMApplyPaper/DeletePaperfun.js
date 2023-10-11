delFun = function() {
 //var userid   = session['LOGON.USERID'];	
 var rowObj = itemGrid.getSelectionModel().getSelections();     
    var len = rowObj.length;
    if(len > 0)
    {
    	Ext.MessageBox.confirm('提示', 
    	    '确定要删除选定的行?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				        for(var i = 0; i < len; i++){   
				        	 var rowid=rowObj[i].get("rowid");
				        	 var SubUserDR=rowObj[i].get("SubUserDR");
				        	 //var data=rowid+"^"+userkdr;  		
				        	 //alert(data);
				        	 if(SubUserDR){
					          Ext.Ajax.request({
					              url: 'herp.srm.srmapplypaperexe.csp?action=delete&rowid='+rowid,
												waitMsg:'删除中...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
													  //alert(result.responseText)
														var jsonData = Ext.util.JSON.decode( result.responseText );
														//alert(jsonData);
						                if (jsonData.success=='true') { 
						                		Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
											    			itemGrid.load({params:{start:0, limit:25}});
									    			}
									    			else {
									    					var message = "SQLErr: " + jsonData.info;
									    					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									    			}
												},
					               scope: this
					          });
					        }else{
					        	Ext.Msg.show({title:'错误',msg:'只能删除自己申请的记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					        }
			        }	
			    }
		    } 
		);	
    }
    else
    {
    	Ext.Msg.show({title:'错误',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    }       


}


