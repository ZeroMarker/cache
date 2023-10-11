//提交横向项目立项申请
subFun = function(){
 var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
 
    var len = rowObj.length;
    if(len > 0)
    {
    	var prjcn = rowObj[0].get("PrjCN");
    	var prjid = rowObj[0].get("rowid");
		
		/* var isethicalapproval = rowObj[0].get("IsEthicalApproval");
    	var ethicalauditstate = rowObj[0].get("EthicalAuditState");
		if (ethicalauditstate=="undefined"){ ethicalauditstate="";}
		if((isethicalapproval == "是")&&(ethicalauditstate == "")){	
         Ext.Msg.show({title:'警告',msg:'请先进行伦理审核再提交项目申请！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
		else{
		if(((isethicalapproval == "是")&&(ethicalauditstate == "通过"))||(isethicalapproval="否")){	
	     */
		/*if(prjcn == "" ){	
         Ext.Msg.show({title:'警告',msg:'请先添加合同信息再提交项目申请！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		 }
		 else{ 
		 */
		   //xm--20160524删除项目科目信息维护
		   /* Ext.Ajax.request({
			url:'herp.srm.horizonalprjapplyItemInfoexe.csp'+'?action=list&PrjDR='+prjid,
			waitMsg:'提交中...',
			failure: function(result, request){
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            },
			success: function(result, request){			
			 var jsonData = Ext.util.JSON.decode( result.responseText );
			 if (jsonData.results==0){
	         Ext.Msg.show({title:'警告',msg:'请填写经费信息!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			}else{ */
			 Ext.MessageBox.confirm('提示', '确定要提交选定的行?提交后不可修改、不可删除！', 
    	       function(btn) {
	    	     if(btn == 'yes')
		        {
				    for(var i = 0; i < len; i++){     	
					Ext.Ajax.request({
					url:'herp.srm.horizonprjsetupexe.csp?action=ChangeDataStatus&rowid='+rowObj[i].get("rowid"),
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
						var message = "提交失败";Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
					});
			        }
				}
			  })  
		//	 }
			
    }
    else
    {
    	Ext.Msg.show({title:'提示',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
    }       
};