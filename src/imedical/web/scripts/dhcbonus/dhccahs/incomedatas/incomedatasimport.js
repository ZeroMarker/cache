imporFun = function(dataStore,pagingTool,monthDr,ruleDr,patType) {
var loadMask = new Ext.LoadMask(document.body, {msg : '�������������������...'});
 if(patType=="O") var importaction="importo";
 if(patType=="I") var importaction="importi";
 if(patType=="H") var importaction="importh";
 if(patType=="E") var importaction="importe";

  if(!isdeal(dataStore)) return;
Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ�ϵ�������?', 
    	    function(btn) 
				{
	    	     if(btn == 'yes')
		          {
				
					if(monthDr=="")
					  {
						Ext.Msg.show({title:'����',msg:'��ѡ���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					   }
					else if(ruleDr=="")
					   {
						Ext.Msg.show({title:'����',msg:'��ѡ�����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					   }
					else
						{
						 loadMask.show();
						Ext.Ajax.request
						 ({ 
						   url: 'dhc.ca.incomedatasexe.csp?action='+importaction+'&monthDr='+monthDr+'&ruleDr='+ruleDr+'&userCode='+userCode,
						   waitMsg:'������...',
						   failure: function(result, request) {loadMask.hide();Ext.Msg.show({title:'����',msg:'�������ӳ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});},
						   success: function(result, request)
						       {   loadMask.hide();
								    var jsonData = Ext.util.JSON.decode( result.responseText );
									var code=jsonData.info
									if(code=='1') var mess="����ɹ�!"
									if(code=='2') var mess="����ʧ��!"
									if(code=='31') var mess="���������Ѵ��ڣ������ظ�����!"
									if(code=='32') var mess="���������Ѵ��ڣ������ظ�����!"
									if(code=='33') var mess="��������Ѵ��ڣ������ظ�����!"
									if(code=='34') var mess="סԺ�����Ѵ��ڣ������ظ�����!"
									if (jsonData.success=='true')
									  {
										Ext.Msg.show({title:'ע��',msg:mess,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										dataStore.load({params:{start:0, limit:pagingTool.pageSize, monthDr:monthDr}});
									  }
								   else
									 {
									Ext.Msg.show({title:'ע��',msg:mess,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									 }							   
								}, 
							scope: this
						});
					}
				 }
			})

};
