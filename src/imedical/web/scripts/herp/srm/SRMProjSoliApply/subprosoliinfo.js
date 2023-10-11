//提交项目征集申请信息
var userdr = session['LOGON.USERCODE'];
subFun = function(){
 var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
   
   	
	
   
   
    var len = rowObj.length;
    if(len > 0)
    {
	    	//////////////////////////判断是否有附件上传记录///////////////////////////
				
		///////////////////////////////////////
    	Ext.MessageBox.confirm('提示', 
    	    '确定要提交选定的行?提交后不可修改、不可删除！', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
					Ext.Ajax.request({
						url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'P011',
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){				
								Ext.Msg.show({title:'注意',msg:'请上传附件!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
								return;
							}
							else{
								if(rowObj[0].get("DataStatus")!="已提交"){
								for(var i = 0; i < len; i++){     		
									Ext.Ajax.request({
										url: 'herp.srm.srmprosoliapplyexe.csp?action=sub&rowid='+rowObj[i].get("rowid"),
										waitMsg:'提交中...',
										failure: function(result, request) {
						            		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
										success: function(result, request) {
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') { 
						                		Ext.MessageBox.alert('提示', '提交完成');
											    itemGrid.load({params:{start:0, limit:25}});
									    	}
									    	else {
									    		var message = "提交失败";
									    		Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									    	}
										},
										scope: this
									});
								}
								}else{
									Ext.Msg.show({title:'错误',msg:'您选择的行已提交，不可再提交!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									//return;
								}
							}
						},
						scope: this			
					});
				 	
			    }
		    });	
    }
    else
    {
    	Ext.Msg.show({title:'提示',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
    }       
	
};