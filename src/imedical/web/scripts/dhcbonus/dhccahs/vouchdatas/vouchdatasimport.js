imporFun = function(dataStore,pagingTool,monthDr,type) {
var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});
var importaction="importCost"
if (type=="Z") var importaction="importdeper"
Ext.MessageBox.confirm('提示', 
    	    '确认导入数据?', 
    	    function(btn) 
				{
	    	     if(btn == 'yes')
		          {
				
					if(monthDr=="")
					  {
						Ext.Msg.show({title:'错误',msg:'请选择核算区间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					   }
					else
						{
					   loadMask.show();
						Ext.Ajax.request
						 ({ 
						   url: vouchDatasUrl+'?action='+importaction+'&monthDr='+monthDr+'&userCode='+userCode+'&inType='+type,
						   waitMsg:'保存中...',
						   failure: function(result, request) {loadMask.hide();Ext.Msg.show({title:'错误',msg:'网络连接出错！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});},
						   success: function(result, request)
						       {   loadMask.hide();
								    var jsonData = Ext.util.JSON.decode( result.responseText );
									var code=jsonData.info
									if(code=='1') var mess="导入成功!"
									if(code=='2') var mess="导入失败!"
									if(code=='3') var mess="数据已存在，请勿重复导入！"
									if (jsonData.success=='true')
									  {
										Ext.Msg.show({title:'提示',msg:mess,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                                         dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize,monthDr:monthDr}});									  }
								   else
									 {
									Ext.Msg.show({title:'注意',msg:mess,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									 }							   
								}, 
							scope: this
						});
					}
				 }
			})

};
