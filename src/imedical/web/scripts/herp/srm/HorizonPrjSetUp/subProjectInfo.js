//�ύ������Ŀ��������
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
		if((isethicalapproval == "��")&&(ethicalauditstate == "")){	
         Ext.Msg.show({title:'����',msg:'���Ƚ�������������ύ��Ŀ���룡',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
		else{
		if(((isethicalapproval == "��")&&(ethicalauditstate == "ͨ��"))||(isethicalapproval="��")){	
	     */
		/*if(prjcn == "" ){	
         Ext.Msg.show({title:'����',msg:'������Ӻ�ͬ��Ϣ���ύ��Ŀ���룡',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		 }
		 else{ 
		 */
		   //xm--20160524ɾ����Ŀ��Ŀ��Ϣά��
		   /* Ext.Ajax.request({
			url:'herp.srm.horizonalprjapplyItemInfoexe.csp'+'?action=list&PrjDR='+prjid,
			waitMsg:'�ύ��...',
			failure: function(result, request){
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            },
			success: function(result, request){			
			 var jsonData = Ext.util.JSON.decode( result.responseText );
			 if (jsonData.results==0){
	         Ext.Msg.show({title:'����',msg:'����д������Ϣ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			}else{ */
			 Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ�ύѡ������?�ύ�󲻿��޸ġ�����ɾ����', 
    	       function(btn) {
	    	     if(btn == 'yes')
		        {
				    for(var i = 0; i < len; i++){     	
					Ext.Ajax.request({
					url:'herp.srm.horizonprjsetupexe.csp?action=ChangeDataStatus&rowid='+rowObj[i].get("rowid"),
					waitMsg:'�ύ��...',
					failure: function(result, request) {
				    Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
				    if (jsonData.success=='true') { 
						Ext.MessageBox.alert('��ʾ', '�ύ���');
						itemGrid.load({params:{start:0, limit:25,userdr:userdr}});
					}
					else {
						var message = "�ύʧ��";Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
    	Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
    }       
};