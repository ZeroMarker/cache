//�ύ��Ŀ��������
subFun = function(){
 var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
 
    var len = rowObj.length;
    if(len > 0)
    {
    	var checkflag = rowObj[0].get("checkflag");
	//alert(state);			
	/*if(checkflag == 0 ){
     Ext.Msg.show({title:'����',msg:'����������������ύ��Ŀ�������룡',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
     return;
   }*/
   
    	Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫ�ύѡ������?�ύ�󲻿��޸ġ�����ɾ����', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				 	if((rowObj[0].get("ProjStatusID")=="2")||((rowObj[0].get("ProjStatusID")=="3")&&(rowObj[0].get("ChkResult")=="2"))){
						//alert("");
				        for(var i = 0; i < len; i++){     		
					          Ext.Ajax.request({
					              url: 'herp.srm.srmhorizontalprjcheckapplyexe.csp?action=ChangeCheckProjStatus&rowid='+rowObj[i].get("rowid"),
												waitMsg:'�ύ��...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                			 	Ext.MessageBox.alert('��ʾ', '�ύ���');
														
											    		itemGrid.load({params:{start:0, limit:25,userdr:userdr}})
											    		
									    			}
									    			else {
									    					var message = "�ύʧ��";
									    					Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									    			}
												},
					               scope: this
					          });
			        	}
					 }else{
						 Ext.Msg.show({title:'����',msg:'��ѡ��������ύ���������ύ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						 //return;
					 }
			    }
		    } 
		);	
    }
    else
    {
    	Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
    }       
	
};