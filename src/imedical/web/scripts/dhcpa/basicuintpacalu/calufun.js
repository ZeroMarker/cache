//����
var userdr = session['LOGON.USERCODE'];

Calufun = function(){
 var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
    var len = rowObj.length;
    if(len > 0)
    {  
    	Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫ����ѡ������?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				
				    var  curstate=rowObj[0].get("auditstate");
					if ((curstate=="���ύ")||(curstate=="���ͨ��")||(curstate=="����"))
					{
					Ext.Msg.show({title:'����',msg:'���ύ�����ټ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				 	else{
				        for(var i = 0; i < len; i++){   
					  //cycleDr, frequency, period, schemDr,userCode
					      var cycleDr = rowObj[i].get("yearid");
						  var frequency = rowObj[i].get("checkperiodType");
						  var period = rowObj[i].get("changedperiod");
						  var schemDr = rowObj[i].get("schemrowid");
						/* var myMask = new Ext.LoadMask(Ext.getBody(), {  
							msg: '�����У����Ժ�',  
							removeMask: true //��ɺ��Ƴ�  
						});  
						myMask.show(); */
					          Ext.Ajax.request({
					              	url: 'dhc.pa.basicuintpacaluexe.csp'+'?action=calu&cycleDr='+cycleDr+'&frequency='+frequency+'&period='+period+'&schemDr='+schemDr+'&userCode='+userCode,
									waitMsg:'������...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
									success: function(result, request){
										var jsonData = Ext.util.JSON.decode( result.responseText );
										
										if (jsonData.success=='true') { 
											//myMask.close(); 
											Ext.MessageBox.alert('��ʾ', '�������');
											//alert(userdr);
											itemGrid.load({params:{start:0, limit:25,userCode:userCode}});
										}
										else {
											//myMask.close();
											var message = "����ʧ��";
											Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										}
										
									},
					               scope: this
					          });
			        	}
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