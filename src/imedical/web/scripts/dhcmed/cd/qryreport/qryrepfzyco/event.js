
function InitViewport1Event(obj) {

	obj.LoadEvent = function(args)
	{
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnExport.on("click",obj.btnExport_click,obj);
		obj.gridRepInfo.on("rowdblclick",obj.gridRepInfo_rowdblclick,obj);
		//obj.gridRepInfoStore.load({params : {start : 0,limit : 50}});
		obj.cboHospital.getStore().load({
			callback : function(){
				obj.gridRepInfoStore.load({params : {start : 0,limit : 50}});
			}
		});
	};
	
	obj.btnQuery_click = function(){
		obj.gridRepInfoStore.load({params : {start : 0,limit : 50}});
	}
	
	obj.btnExport_click = function(){
		if(obj.gridRepInfoStore.getCount()<=0){
			ExtTool.alert("错误","没有查询出数据!");
			return;
		}
		ExportGridByCls(obj.gridRepInfo,"一氧化碳中毒报告信息列表");
	}
	
	obj.gridRepInfo_rowdblclick = function(objGrid, rowIndex){
		var record = objGrid.getStore().getAt(rowIndex);
		var ReportID = record.get("ReportID");
		var EpisodeID = record.get("EpisodeID");
		var url="dhcmed.cd.reportfzyco.csp?1=1&ReportID="+ReportID+"&EpisodeID"+EpisodeID;
		var oWin = window.open(url,'',"height=" + (window.screen.availHeight - 100) + ",width=" + (window.screen.availWidth - 100) + ",top=20,left=50,resizable=no");
		//fix bug 191760 by mxp 打开报告审核 关闭后刷新查询列表
		var timer=window.setInterval(
			function(){
				if (oWin.closed == true){
					Common_LoadCurrPage("gridRepInfo");
					window.clearInterval(timer);
				}
			}
			,1000);
	}
}

