//Created by dongzt
// 20150114
//需求综合查询
function InitViewportEvent(obj) {
	
		obj.LoadEvent = function(){};
	obj.btnQuery_click = function()
	{
		//alert(1);
		obj.gridPMQueryAllStore.removeAll();
		obj.gridPMQueryAllStore.load({params : {start:0,limit:50}});
	}
	
	obj.btnExport_click = function(){
		if (obj.gridPMQueryAll.getStore().getCount() > 0)
		{
			//alert(obj.gridPMQueryAll.getStore().getCount());
			var strFileName="需求处理报表";
			var objExcelTool=Ext.dhcc.DataToExcelTool;
			objExcelTool.ExprotGrid(obj.gridPMQueryAll,strFileName);
		} else {
			ExtTool.alert("提示","查询列表数据为空!");
		}
	}
	
	
	
	obj.gridPMQueryAll_rowdblclick = function(objGrid, rowIndex)
	{
		/* var record = objGrid.getStore().getAt(rowIndex);
		alert(rowIndex);
		alert(record.get("DemandID"));
		
		var url="dhcmed.ninf.rep.infreport.csp?1=1&ReportID="+ReportID+"&AdminPower="+obj.AdminPower+"&2=2";
		var oWin = window.open(url,'',"height=" + (window.screen.availHeight - 100) + ",width=" + (window.screen.availWidth - 100) + ",top=20,left=50,resizable=no"); */
		
		var record = objGrid.getStore().getAt(rowIndex);
		/* alert(rowIndex);*/
		/* alert(record.get("DemandID")); 
		alert(record.get("DemandDesc")); 
		alert(record.get("DemandType")); 
		alert(record.get("EmergDegree")); 
		alert(record.get("PMModule")); 
		alert(record.get("LocName")); 
		alert(record.get("UserPhone")); 
		alert(record.get("UserName")); 
		alert(record.get("DemSituation")); 
		//alert(record.get("DemandID"));  */
		
		PDemandID=record.get("DemandID");
		PDemandName=record.get("DemandDesc");
		PDemandType=record.get("DemandType");
		PEmergDegree=record.get("EmergDegree");
		PPMModule=record.get("PMModule");
		PLocName=record.get("LocName");
		PUserName=record.get("UserName");
		PUserPhone=record.get("UserPhone");
		PDemSituation=record.get("DemSituation");
		EditDemDesc=record.get("EditDemDesc");
		EditUser=record.get("EditUser");
		
		var selectObj = obj.gridPMQueryAll.getSelectionModel().getSelected();
		if (selectObj){
			//alert(1);
			/* var objWinEdit = new InitwinScreen(selectObj);
			//objWinEdit.winfPProductDr.disabled=true;
			objWinEdit.winfDemName.disabled=true;
			objWinEdit.winfDemType.disabled=true;
			objWinEdit.winfEmergency.disabled=true;
			
			objWinEdit.winfModule.disabled=true;
			objWinEdit.winfLocation.disabled=true;
			objWinEdit.winfCreater.disabled=true;
			objWinEdit.winfPhone.disabled=true;
			objWinEdit.winfDemDesc.disabled=true;
			
			
			
			
			
			objWinEdit.winScreen.show(); */
			
			
			objWinDetail = new InitDescScreen();
			
			//alert(PDemandID);
			objWinDetail.DemandID.setValue(PDemandID);
			//alert(obj.DemandID.getValue());
			objWinDetail.winfDemName.setValue(PDemandName);
			objWinDetail.winfDemName.disabled=true;
			//alert(obj.winfDemName.getValue());
			
			objWinDetail.winfDemType.setValue(PDemandType);
			objWinDetail.winfDemType.disabled=true;
			objWinDetail.winfEmergency.setValue(PEmergDegree);
			objWinDetail.winfEmergency.disabled=true;
			objWinDetail.winfPhone.setValue(PUserPhone);
			
			objWinDetail.winfPhone.disabled=true;
			objWinDetail.winfDemDesc.setValue(PDemSituation); //
			//objWinDetail.winfDemDesc.disabled=true;
			objWinDetail.winfCreater.setValue(PUserName); 
			objWinDetail.winfCreater.disabled=true;
			objWinDetail.winfLocation.setValue(PLocName); //
			objWinDetail.winfLocation.disabled=true;
			objWinDetail.winfModule.setValue(PPMModule); 
			objWinDetail.winfModule.disabled=true;
			//var editNote="修改人:"+EditUser+"       内容:"+EditDemDesc;
			if(EditDemDesc!="")
			{objWinDetail.winfEditDemDesc.setValue(EditDemDesc);} 
			 
			 //操作列表
			objWinDetail.winfGPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Query.PMQueryAll';
			param.QueryName = 'QryDemList';
			param.Arg1 = PDemandID;    //obj.MenuID.getValue();
			param.ArgCnt = 1; 
			});
			
			//沟通记录列表
			objWinDetail.winfComlistStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Handle.PMHandle';
			param.QueryName = 'QryComContent';
			param.Arg1 = PDemandID;    //obj.MenuID.getValue();
			param.ArgCnt = 1; 
			});
			 //附件下载列表
			objWinDetail.winfDownLoadProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Query.PMQueryAll';
			param.QueryName = 'QryDownLoadList';
			param.Arg1 = "";
			param.Arg2 = PDemandID;    //obj.MenuID.getValue();
			param.ArgCnt = 2; 
			});
			objWinDetail.winfGPanelStore.load({});
			
			objWinDetail.winfComlistStore.load({}); 
				
			objWinDetail.winfDownLoadStore.load({}); 
		 
		
		
		
		objWinDetail.winScreen.show();
			
			
		}
		else{
			ExtTool.alert("提示","请先选中一行!");
		}
	
	
	}
	
	obj.WindowRefresh_Handler = function()
	{
		obj.gridPMQueryAllStore.load({});
	}
	
	obj.gridPMQueryAll.on('cellclick', function (grid, rowIndex, columnIndex, e) {
		
		var rec = e.getTarget('.RecInsert'); 	

		if (rec) 
		{ 
			var t = e.getTarget(); 
			var control = t.className; 
			//alert(control);
			 var record = obj.gridPMQueryAll.getStore().getAt(rowIndex);  
			//alert(1);
			var DemandID=record.get("DemandID");
			//alert(DemandID+"   1");
			objComRec = new InComRecSubScreen();
			//alert(objComRec)
			objComRec.DemandID.setValue(DemandID);
			objComRec.winScreen.show();
			
		}
		
		
	},  
this);  
}

/*
function InitwinScreenEvent(obj) {
	var parent=objControlArry['Viewport'];
	obj.LoadEvent = function(){
		var data = arguments[0][0];
  		if (data){
			
		
			//alert(PDemandID);
			obj.DemandID.setValue(PDemandID);
			//alert(obj.DemandID.getValue());
			obj.winfDemName.setValue(PDemandName);
			//alert(obj.winfDemName.getValue());
			obj.winfDemType.setValue(PDemandType);
			
			
			obj.winfEmergency.setValue(PEmergDegree);
			obj.winfModule.setValue(PPMModule);
			obj.winfLocation.setValue(PLocName);
			obj.winfCreater.setValue(PUserName);
			obj.winfPhone.setValue(PUserPhone);
			obj.winfDemDesc.setValue(PDemSituation);
			
			//alert(data);
			 //操作列表
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
			
	});
	
	//obj.winfGPanelStore.data.get("total");
	//alert(obj.DemandID.getValue());
	obj.winfGPanelStore.load({});
	obj.winfDownLoadStore.load({});
			

		
	}
	
};


}*/





