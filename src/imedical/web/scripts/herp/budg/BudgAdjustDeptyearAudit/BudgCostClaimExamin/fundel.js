//删除函数

delFun = function(rowid){
                               
				function handlera(id){
                                  if(id=="yes"){
			    Ext.MessageBox.confirm('提示','删除之后不能恢复，您确定删吗?',handler);}
                                  else
                            {        return false;   }                      
  
                                    }
   
				function handler(id){
		
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/herp.budg.costclaimapplyexe.csp?action=del&rowid='+rowid,
							waitMsg:'删除中...',
							failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'删除成功!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:12}});
								}else
						{	if(jsonData.info=='fail') message='保存到相应的组失败!';
							else message='删除失败!';
							Ext.Msg.show({title:'错误',msg:message,buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}							
								},
							scope: this
						});
					}else{
						return false;
					}
				}

			    Ext.MessageBox.confirm('提示','您真的要删除吗?',handlera);
                            
 
	

};





///////撤销函数

backoutfun= function(rowid,userid){

			
		userid=8;
					
				Ext.Ajax.request({
							url:'../csp/herp.budg.costclaimapplyexe.csp?action=backout&rowid='+rowid

+"&userid="+userid,
							waitMsg:'撤销中...',
							failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'撤销成功!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:12}});
								}
                                                else if(jsonData.success=='hhhh')
                                                 {
                                                 Ext.Msg.show({title:'提示',msg:'审批已完成不允许撤销！',buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                                                  }
                                                else
						{	if(jsonData.info=='fail') message='保存到相应的组失败!';
							else message='撤销失败!';
							Ext.Msg.show({title:'错误',msg:message,buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}							
								},
							scope: this
						});
					
			
			
                          
	
};




///////提交函数


submitfun= function(rowid,userid,billcodes){




		function handlera(id){
                                  if(id=="yes"){
			    Ext.MessageBox.confirm('提示','提交之后不能修改，您确定提交吗?',handler);}
                                  else
                            {        return false;   }                      
  
                                    }
   
				function handler(id){
		
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/herp.budg.costclaimapplyexe.csp?action=submit&rowid='+rowid

+"&userid="+userid+"&billcodes="+billcodes,
							waitMsg:'删除中...',
							failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'提交成功!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:12}});
								}else
						{	if(jsonData.info=='fail') message='保存到相应的组失败!';
							else message='提交失败!';
							Ext.Msg.show({title:'错误',msg:message,buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}							
								},
							scope: this
						});
					}else{
						return false;
					}
				}

			    Ext.MessageBox.confirm('提示','您真的要提交吗?',handlera);
                            
 
                          
	
};



///////////////修改函数
modificationfun= function(rowid){



Ext.Msg.show({title:'提示',msg:'修改成功!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});

};







////////////审批函数

examine= function(rowid,userid,billcodes){


alert("审批qs");

  function handlera(id){
            if(id=="yes")
			{
			  Ext.MessageBox.confirm('提示','您将审批通过此报销单，您确定吗?',handler);
             }
            else
              {      
              Ext.MessageBox.confirm('提示','您确定不通过此报销单吗?',handler1);
              }                      
  
           }
   
   function handler(id){
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/herp.budg.costclaimexamiexe.csp?action=pass&rowid='+rowid+"&userid="+userid+"&billcodes="+billcodes,
							waitMsg:'删除中...',
							failure: function(result, request){
						    Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'提交成功!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:12}});
								}else
						{	if(jsonData.info=='fail') message='保存到相应的组失败!';
							else message='提交失败!';
							Ext.Msg.show({title:'错误',msg:message,buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}							
								},
							scope: this
						});
					}else{
						return false;
					}
				}


	function handler1(id){
		
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/herp.budg.costclaimexamiexe.csp?action=nopass&rowid='+rowid+"&userid="+userid+"&billcodes="+billcodes,
							waitMsg:'删除中...',
							failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'提交成功!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:12}});
								}else
						{	if(jsonData.info=='fail') message='保存到相应的组失败!';
							else message='提交失败!';
							Ext.Msg.show({title:'错误',msg:message,buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}							
								},
							scope: this
						});
					}else{
						return false;
					}
				}

			    Ext.MessageBox.confirm('提示','是否审批通过?',handlera);
                            
}; 




/////查看文件

/*
function MSComDlg_CommonDialog(cmd){
   ////if(!ActiveXObject)return;
    var obj=new ActiveXObject('MSComDlg.CommonDialog');
    var filename=false;
    try{
        switch(cmd){
        case 2:
            obj.ShowColor();
            break;
        case 3:
            obj.ShowFont();
            break;
        case 4:
            obj.ShowHelp();
            break;
        default:
            obj.Filter='所有文件(*.*)';
            obj.FilterIndex = 1;
            obj.MaxFileSize = 255;
            if(cmd==0){
                obj.ShowSave();
            }else{
                obj.ShowOpen();
            }
        }
        filename = obj.filename;
    }catch(e){alert(e.message);}
    return filename;
} 
*/