
 function  save() { 
 if(typename.getValue()==""){
	Ext.Msg.show({title:'ע��',msg:'��ѡ���˼��᷽ʽ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	return;
 }
 else if(typename.getValue()==2)
 { 
	itemGrid.save();
 }
 else
 {
	 var value=Paramproportion.getValue()
	 // alert(value)
	 if(value>=1||value<0){
		Ext.Msg.show({title:'����',msg:'������1���ڵ�ֵ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); 
		return;
	 }else{
			Ext.Ajax.request({
					url: '../csp/herp.acct.acctbaddebtsexe.csp?action=update&value='+value+'&bookID='+bookID,method:'POST',
					
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					//itemGrid.load({params:{start:0, limit:25,SchemDR : curSchemeDr}});
						}
						else {
						var tmpMsg = "����ʧ��! ";
						Ext.Msg.show({title:'����',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
				  	scope: this
			});
		}
	}
}

