//�ύ���м���������Ϣ
var userdr = session['LOGON.USERCODE'];
subFun = function(){
 var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
    var len = rowObj.length;
    if(len > 0)
    {
	    //////////////////////////�ж��Ƿ��и����ϴ���¼///////////////////////////
				Ext.Ajax.request({
					url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'P008',
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'���ϴ�����!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
						
							return;
						}
						
					},
					scope: this			
				  });
		///////////////////////////////////////
	    
	    
    	Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫ�ύѡ������?�ύ�󲻿��޸ġ�����ɾ����', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				 	if(rowObj[0].get("DataStatus")!="���ύ"){
				        for(var i = 0; i < len; i++){     		
					          Ext.Ajax.request({
					                url: projUrl+'?action=sub&rowid='+rowObj[i].get("rowid"),
								    waitMsg:'�ύ��...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                			 	Ext.MessageBox.alert('��ʾ', '�ύ���');
											    		itemGrid.load({params:{start:0, limit:25}});
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