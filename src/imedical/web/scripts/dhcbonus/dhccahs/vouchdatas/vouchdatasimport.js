imporFun = function(dataStore,pagingTool,monthDr,type) {
var loadMask = new Ext.LoadMask(document.body, {msg : '�������������������...'});
var importaction="importCost"
if (type=="Z") var importaction="importdeper"
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
					else
						{
					   loadMask.show();
						Ext.Ajax.request
						 ({ 
						   url: vouchDatasUrl+'?action='+importaction+'&monthDr='+monthDr+'&userCode='+userCode+'&inType='+type,
						   waitMsg:'������...',
						   failure: function(result, request) {loadMask.hide();Ext.Msg.show({title:'����',msg:'�������ӳ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});},
						   success: function(result, request)
						       {   loadMask.hide();
								    var jsonData = Ext.util.JSON.decode( result.responseText );
									var code=jsonData.info
									if(code=='1') var mess="����ɹ�!"
									if(code=='2') var mess="����ʧ��!"
									if(code=='3') var mess="�����Ѵ��ڣ������ظ����룡"
									if (jsonData.success=='true')
									  {
										Ext.Msg.show({title:'��ʾ',msg:mess,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                                         dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize,monthDr:monthDr}});									  }
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
