//ɾ������

delFun = function(rowid){
                               
				function handlera(id){
                                  if(id=="yes"){
			    Ext.MessageBox.confirm('��ʾ','ɾ��֮���ָܻ�����ȷ��ɾ��?',handler);}
                                  else
                            {        return false;   }                      
  
                                    }
   
				function handler(id){
		
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/herp.budg.costclaimapplyexe.csp?action=del&rowid='+rowid,
							waitMsg:'ɾ����...',
							failure: function(result, request){
								Ext.Msg.show({title:'����',msg:'������������!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:12}});
								}else
						{	if(jsonData.info=='fail') message='���浽��Ӧ����ʧ��!';
							else message='ɾ��ʧ��!';
							Ext.Msg.show({title:'����',msg:message,buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}							
								},
							scope: this
						});
					}else{
						return false;
					}
				}

			    Ext.MessageBox.confirm('��ʾ','�����Ҫɾ����?',handlera);
                            
 
	

};





///////��������

backoutfun= function(rowid,userid){

			
		userid=8;
					
				Ext.Ajax.request({
							url:'../csp/herp.budg.costclaimapplyexe.csp?action=backout&rowid='+rowid

+"&userid="+userid,
							waitMsg:'������...',
							failure: function(result, request){
								Ext.Msg.show({title:'����',msg:'������������!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'��ʾ',msg:'�����ɹ�!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:12}});
								}
                                                else if(jsonData.success=='hhhh')
                                                 {
                                                 Ext.Msg.show({title:'��ʾ',msg:'��������ɲ���������',buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                                                  }
                                                else
						{	if(jsonData.info=='fail') message='���浽��Ӧ����ʧ��!';
							else message='����ʧ��!';
							Ext.Msg.show({title:'����',msg:message,buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}							
								},
							scope: this
						});
					
			
			
                          
	
};




///////�ύ����


submitfun= function(rowid,userid,billcodes){




		function handlera(id){
                                  if(id=="yes"){
			    Ext.MessageBox.confirm('��ʾ','�ύ֮�����޸ģ���ȷ���ύ��?',handler);}
                                  else
                            {        return false;   }                      
  
                                    }
   
				function handler(id){
		
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/herp.budg.costclaimapplyexe.csp?action=submit&rowid='+rowid

+"&userid="+userid+"&billcodes="+billcodes,
							waitMsg:'ɾ����...',
							failure: function(result, request){
								Ext.Msg.show({title:'����',msg:'������������!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'��ʾ',msg:'�ύ�ɹ�!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:12}});
								}else
						{	if(jsonData.info=='fail') message='���浽��Ӧ����ʧ��!';
							else message='�ύʧ��!';
							Ext.Msg.show({title:'����',msg:message,buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}							
								},
							scope: this
						});
					}else{
						return false;
					}
				}

			    Ext.MessageBox.confirm('��ʾ','�����Ҫ�ύ��?',handlera);
                            
 
                          
	
};



///////////////�޸ĺ���
modificationfun= function(rowid){



Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});

};







////////////��������

examine= function(rowid,userid,billcodes){


alert("����qs");

  function handlera(id){
            if(id=="yes")
			{
			  Ext.MessageBox.confirm('��ʾ','��������ͨ���˱���������ȷ����?',handler);
             }
            else
              {      
              Ext.MessageBox.confirm('��ʾ','��ȷ����ͨ���˱�������?',handler1);
              }                      
  
           }
   
   function handler(id){
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/herp.budg.costclaimexamiexe.csp?action=pass&rowid='+rowid+"&userid="+userid+"&billcodes="+billcodes,
							waitMsg:'ɾ����...',
							failure: function(result, request){
						    Ext.Msg.show({title:'����',msg:'������������!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'��ʾ',msg:'�ύ�ɹ�!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:12}});
								}else
						{	if(jsonData.info=='fail') message='���浽��Ӧ����ʧ��!';
							else message='�ύʧ��!';
							Ext.Msg.show({title:'����',msg:message,buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}							
								},
							scope: this
						});
					}else{
						return false;
					}
				}


	function handler1(id){
		
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/herp.budg.costclaimexamiexe.csp?action=nopass&rowid='+rowid+"&userid="+userid+"&billcodes="+billcodes,
							waitMsg:'ɾ����...',
							failure: function(result, request){
								Ext.Msg.show({title:'����',msg:'������������!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'��ʾ',msg:'�ύ�ɹ�!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:12}});
								}else
						{	if(jsonData.info=='fail') message='���浽��Ӧ����ʧ��!';
							else message='�ύʧ��!';
							Ext.Msg.show({title:'����',msg:message,buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}							
								},
							scope: this
						});
					}else{
						return false;
					}
				}

			    Ext.MessageBox.confirm('��ʾ','�Ƿ�����ͨ��?',handlera);
                            
}; 




/////�鿴�ļ�

/*
function MSComDlg_CommonDialog(cmd){
   ////if(!ActiveXObject)return;
    var obj=new ActiveXObject('MSComDlg.CommonDialog');
    var filename=false;
    try{
        switch(cmd){
        case 2:
            obj.ShowColor();
            break;
        case 3:
            obj.ShowFont();
            break;
        case 4:
            obj.ShowHelp();
            break;
        default:
            obj.Filter='�����ļ�(*.*)';
            obj.FilterIndex = 1;
            obj.MaxFileSize = 255;
            if(cmd==0){
                obj.ShowSave();
            }else{
                obj.ShowOpen();
            }
        }
        filename = obj.filename;
    }catch(e){alert(e.message);}
    return filename;
} 
*/