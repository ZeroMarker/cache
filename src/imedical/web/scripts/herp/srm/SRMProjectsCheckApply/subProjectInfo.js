//�ύר��������Ϣ
subFun = function(){
        var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
	    var len = rowObj.length;
	    if(len > 0)
	    {
	    	
//	    	var ConDate = rowObj[0].get("ConDate");	//��ͬ��
//		    if(ConDate == ""|| ConDate ==null){
//			
//	                Ext.Msg.show({title:'����',msg:'����д��Ŀ����ʱ�䣡',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
//	                return;
//	   }	
   
    	Ext.MessageBox.confirm('��ʾ',
    	'ȷ��Ҫ�ύѡ������?�ύ�󲻿��޸ġ�����ɾ����',
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				 	if(rowObj[0].get("ProjStatus")=="ִ��"){
				        for(var i = 0; i < len; i++){     	
//				              var ConDate=rowObj[i].get("ConDate");	
//				              if (ConDate!=""&&ConDate!=null){
//									ConDate=ConDate.format('Y-m-d');
//							  }
					          Ext.Ajax.request({
					              url: 'herp.srm.srmprojectscheckapplyexe.csp?action=ChangeCheckProjStatus&rowid='+rowObj[i].get("rowid"),
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