//提交专利申请信息
subFun = function(){
        var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
	    var len = rowObj.length;
	    if(len > 0)
	    {
	    	
//	    	var ConDate = rowObj[0].get("ConDate");	//合同号
//		    if(ConDate == ""|| ConDate ==null){
//			
//	                Ext.Msg.show({title:'警告',msg:'请填写项目结题时间！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
//	                return;
//	   }	
   
    	Ext.MessageBox.confirm('提示',
    	'确定要提交选定的行?提交后不可修改、不可删除！',
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				 	if(rowObj[0].get("ProjStatus")=="执行"){
				        for(var i = 0; i < len; i++){     	
//				              var ConDate=rowObj[i].get("ConDate");	
//				              if (ConDate!=""&&ConDate!=null){
//									ConDate=ConDate.format('Y-m-d');
//							  }
					          Ext.Ajax.request({
					              url: 'herp.srm.srmprojectscheckapplyexe.csp?action=ChangeCheckProjStatus&rowid='+rowObj[i].get("rowid"),
												waitMsg:'提交中...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                			 	Ext.MessageBox.alert('提示', '提交完成');
														
											    		itemGrid.load({params:{start:0, limit:25,userdr:userdr}});
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
		    } 
		);	
    }
    else
    {
    	Ext.Msg.show({title:'提示',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
    }       
	
};