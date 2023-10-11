function SubmitPaperfun()
{
	var userkdr=session['LOGON.USERCODE'];
  var rowObj = itemGrid.getSelectionModel().getSelections();     
  var len = rowObj.length;
    if(len > 0)
    {
    	Ext.MessageBox.confirm('提示', 
    	    '确定要提交选定的记录?', 
    	    function(btn) {
		if(btn=='yes')
		{	
			for(var i = 0; i < len; i++){   
			var rowid=rowObj[i].get("rowid");
			Ext.Ajax.request({
						url :'herp.srm.srmapplypaperexe.csp' + '?action=submit&rowid='+rowid+'&userdr='+userkdr,
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
			}	
		})
	}

}
