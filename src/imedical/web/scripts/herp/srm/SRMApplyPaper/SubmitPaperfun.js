function SubmitPaperfun()
{
	var userkdr=session['LOGON.USERCODE'];
  var rowObj = itemGrid.getSelectionModel().getSelections();     
  var len = rowObj.length;
    if(len > 0)
    {
    	Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫ�ύѡ���ļ�¼?', 
    	    function(btn) {
		if(btn=='yes')
		{	
			for(var i = 0; i < len; i++){   
			var rowid=rowObj[i].get("rowid");
			Ext.Ajax.request({
						url :'herp.srm.srmapplypaperexe.csp' + '?action=submit&rowid='+rowid+'&userdr='+userkdr,
						waitMsg : '�ύ��...',
						failure : function(result, request) {
								Ext.Msg.show({
											title : '����',
											msg : '������������!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
								},
						success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
										Ext.MessageBox.alert('��ʾ','�ύ���');
										itemGrid.load({params:{start:0,limit:25}});
								} else {
										var message = "SQLErr: "+ jsonData.info;
										Ext.Msg.show({
													title : '����',
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
