function SubmitPaperfun()
{
        //alert("adfasjdkl");
	var records = itemGrid.getSelectionModel().getSelections();
          
	var len = records.length;
	    //判断是否选择了要修改的数据	 
        if(len=="")
        {
		Ext.Msg.show({title:'错误',msg:'请选择需要提交的记录！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	};
    
	Ext.MessageBox.confirm('提示', '提交后的数据只能撤销 不可再编辑  请确定是否提交', function(btn){
                var rowid=records[0].get("rowid");
		if(btn=='yes')
		{	
				
			//alert(rowid);
	
			Ext.Ajax.request({
						url :'herp.srm.paperublishregisterexe.csp' + '?action=submit&rowid='+rowid,
						waitMsg : '提交中...',
						failure : function(result, request) {
								Ext.Msg.show({
											title : '错误',
											msg : '请检查网络连接!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
								},
						success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
										Ext.MessageBox.alert('提示','提交完成');
										itemGrid.load({params:{start:0,limit:25}});
								} else {
										var message = "SQLErr: "+ jsonData.info;
										Ext.Msg.show({
													title : '错误',
													msg : message,
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
													});
										}
								},
										scope : this
							});
					
			
			}
		
		
		})

}
