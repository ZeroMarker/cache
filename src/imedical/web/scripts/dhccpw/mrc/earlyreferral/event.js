
function InitViewport1Event(obj) {
	obj.LoadEvent = function(args)
	{
		obj.BtnSave.on("click", obj.BtnSave_click, obj);  		 
	};
	
	obj.BtnSave_click = function()
	{
		var rec=obj.InCPWList.getSelectionModel().getSelected();
		if(!rec)
		{
			alert("请选择一条路径！！");	
			return;
		}
		var CPWID = rec.get("ID");
		var CPWDesc = rec.get("Desc");
		var CLPOSRowId = rec.get("CLPOSRowId");
		window.returnValue =""
		if (CPWID!="") window.returnValue = CPWID+"^"+CPWDesc+"^"+CLPOSRowId;
		window.close();
	}
}