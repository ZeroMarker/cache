/**生成期间
author：cyl  2017-2-20
locSetField 接口套  periodType 期间类型
**/

autoPeriod=function(locSetFieldValue,periodType,periodMsg,ds,pagingToolbar){
	var msg="确定要生成"+periodMsg+"期间？";
	Ext.MessageBox.confirm('提示',msg,function(flag){
		if(flag=="yes"){
			var data=locSetFieldValue;
			
			Ext.Ajax.request({
				url: '../csp/dhc.pa.interperiodexe.csp?action=autoPeriod&data='+data+'&periodType='+periodType,
				waitMsg:'保存中...',
				failure: function(result, request){
					
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'提示',msg:'生成成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						ds.load({params:{start:0,limit:pagingToolbar.pageSize,locSetDr:locSetFieldValue}});
					}else{
						if(jsonData.info=='isExist'){
							
							Ext.Msg.show({title:'提示',msg:'该期间记录已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						
					}
				},
				scope: this
			});
		}
		
	});
}