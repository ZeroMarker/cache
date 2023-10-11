addFun = function(year) {
	var myMask = new Ext.LoadMask(Ext.getBody(), {
        msg: '预算采集中…',
        removeMask: true //完成后移除
    });
	
	 myMask.show();
	 
	
	Ext.Ajax.request({
		timeout : 30000000,
		url: '../csp/herp.budg.ctrlitembudgcreateexe.csp?action=collect&userdr='+userdr+'&year='+year,
		waitMsg:'数据采集中...',
		failure: function(result, request){
			myMask.hide();
	
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
		
			
			if (jsonData.info=='0'){
				myMask.hide();
							
				Ext.Msg.show({title:'注意',msg:'采集成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
				
				itemGrid.load({
					params : {
						start : 0,
						limit : 12,
						year:"",
						code:"",
						userdr:userdr
						
					
					}
				});

			}else
			{
				
				var message="采集失败";
				if(jsonData.info=='RepCode') message='输入的支票号已经存在!';
				if(jsonData.info=='RepName') message='输入的名称已经存在!';
				Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}
		},
		scope: this
	});
}


