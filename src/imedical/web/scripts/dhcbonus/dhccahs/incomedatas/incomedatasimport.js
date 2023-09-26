imporFun = function(dataStore,pagingTool,monthDr,ruleDr,patType) {
var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});
 if(patType=="O") var importaction="importo";
 if(patType=="I") var importaction="importi";
 if(patType=="H") var importaction="importh";
 if(patType=="E") var importaction="importe";

  if(!isdeal(dataStore)) return;
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
					else if(ruleDr=="")
					   {
						Ext.Msg.show({title:'错误',msg:'请选择导入规则再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					   }
					else
						{
						 loadMask.show();
						Ext.Ajax.request
						 ({ 
						   url: 'dhc.ca.incomedatasexe.csp?action='+importaction+'&monthDr='+monthDr+'&ruleDr='+ruleDr+'&userCode='+userCode,
						   waitMsg:'保存中...',
						   failure: function(result, request) {loadMask.hide();Ext.Msg.show({title:'错误',msg:'网络连接出错！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});},
						   success: function(result, request)
						       {   loadMask.hide();
								    var jsonData = Ext.util.JSON.decode( result.responseText );
									var code=jsonData.info
									if(code=='1') var mess="导入成功!"
									if(code=='2') var mess="导入失败!"
									if(code=='31') var mess="门诊数据已存在，请勿重复导入!"
									if(code=='32') var mess="急诊数据已存在，请勿重复导入!"
									if(code=='33') var mess="体检数据已存在，请勿重复导入!"
									if(code=='34') var mess="住院数据已存在，请勿重复导入!"
									if (jsonData.success=='true')
									  {
										Ext.Msg.show({title:'注意',msg:mess,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										dataStore.load({params:{start:0, limit:pagingTool.pageSize, monthDr:monthDr}});
									  }
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
