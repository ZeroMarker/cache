function InitDetailScreenEvent(obj) {
	var parent=objControlArry['Viewport'];
	obj.LoadEvent = function(){
		
		 /* //�����б�
			obj.winfGPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Query.PMQueryAll';
			param.QueryName = 'QryDemList';
			param.Arg1 = obj.DemandID.getValue();    //obj.MenuID.getValue();
			param.ArgCnt = 1; 
			});
			
			//���������б�
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
