function SubmitPaperfun()
{
        //alert("adfasjdkl");
	var records = itemGrid.getSelectionModel().getSelections();
          
	var len = records.length;
	    //�ж��Ƿ�ѡ����Ҫ�޸ĵ�����	 
        if(len=="")
        {
		Ext.Msg.show({title:'����',msg:'��ѡ����Ҫ�ύ�ļ�¼��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	};
    
	Ext.MessageBox.confirm('��ʾ', '�ύ�������ֻ�ܳ��� �����ٱ༭  ��ȷ���Ƿ��ύ', function(btn){
                var rowid=records[0].get("rowid");
		if(btn=='yes')
		{	
				
			//alert(rowid);
	
			Ext.Ajax.request({
						url :'herp.srm.paperublishregisterexe.csp' + '?action=submit&rowid='+rowid,
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
		
		
		})

}
