function InitDetailScreenEvent(obj) {
	var parent=objControlArry['Viewport'];
	obj.LoadEvent = function(){
		
		 /* //操作列表
			obj.winfGPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Query.PMQueryAll';
			param.QueryName = 'QryDemList';
			param.Arg1 = obj.DemandID.getValue();    //obj.MenuID.getValue();
			param.ArgCnt = 1; 
			});
			
			//附件下载列表
			obj.winfDownLoadProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Query.PMQueryAll';
			param.QueryName = 'QryDownLoadList';
			param.Arg1 = "";
			param.Arg2 = obj.DemandID.getValue();    //obj.MenuID.getValue();
			param.ArgCnt = 2; 
			
			obj.winfGPanelStore.load({});
				
			obj.winfDownLoadStore.load({}); */
			
	});
	
	//obj.winfGPanelStore.data.get("total");
	//alert(obj.DemandID.getValue());
	
	
	
/* 	obj.winfGPanelStore.load({});
	obj.winfDownLoadStore.load({}); */
			

		
	}
	
};
}
