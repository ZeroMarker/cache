
function InitViewport1Event(obj) {

	obj.LoadEvent = function(args)
	{
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnExport.on("click",obj.btnExport_click,obj);
		obj.btnExpInf.on("click",obj.btnExpInf_click,obj);
		obj.gridRepInfo.on("rowdblclick",obj.gridRepInfo_rowdblclick,obj);
		obj.gridRepInfoStore.load({params : {start : 0,limit : 50}});
		
	};
	
	obj.btnQuery_click = function(){
		obj.gridRepInfoStore.load({params : {start : 0,limit : 50}});
	}
	
	obj.btnExport_click = function(){
		if(obj.gridRepInfoStore.getCount()<=0){
			ExtTool.alert("����","û�в�ѯ������!");
			return;
		}
		ExportGridByCls(obj.gridRepInfo,"ְҵ��������Ϣ�б�");
	}
	
	obj.btnExpInf_click = function(){
		var RepIDStr=""
		for(var ind=0;ind<obj.gridRepInfoStore.getCount();ind++)
		{
			objRec = obj.gridRepInfoStore.getAt(ind);
			RepIDStr = RepIDStr+"^"+objRec.get("ReportID");
		}
		if(RepIDStr==""){
			ExtTool.alert("����","û�в�ѯ������!");
			return;
		}else{
			//alert(RepIDStr);
			ExportDataToExcel("","","",RepIDStr);
		}
	}
	
	obj.gridRepInfo_rowdblclick = function(objGrid, rowIndex){
		var record = objGrid.getStore().getAt(rowIndex);
		var ReportID = record.get("ReportID");
		var EpisodeID = record.get("EpisodeID");
		var url="dhcmed.cd.reportyszyb.csp?1=1&ReportID="+ReportID+"&EpisodeID="+EpisodeID;
		var oWin = window.open(url,'',"height=" + (window.screen.availHeight - 100) + ",width=" + (window.screen.availWidth - 100) + ",top=20,left=50,resizable=no");
	}
}
