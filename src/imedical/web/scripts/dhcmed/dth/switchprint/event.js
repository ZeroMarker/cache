function InitSwitchPrintEvent(objSwitchPrint){
	var separate="^";
	objSwitchPrint.LoadEvent = function(){
	};
	objSwitchPrint.saveBtn_click = function(){
		var SwitchRes = objSwitchPrint.SwitchPrint.getValue();
		if (SwitchRes==""){
			ExtTool.alert("提示","至少选择一联打印");
			return;
		}
		var returnIdS=""
		for(var i=0;i<SwitchRes.length;i++){
			var returnId = SwitchRes[i].id.split("-")[1];
			returnIdS += returnId+separate;
		}
		parent.window.returnValue=returnIdS;
		window.close();
	};
	objSwitchPrint.exitBtn_click = function(){
		window.close();
	};
}
