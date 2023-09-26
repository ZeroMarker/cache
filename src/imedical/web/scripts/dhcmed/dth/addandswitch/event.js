function InitAddAndSwitchEvent(objAddAndSwitch){
	var separate="^";
	objAddAndSwitch.LoadEvent = function(){
	};
	objAddAndSwitch.saveBtn_click = function(){
		var SwitchRes = objAddAndSwitch.SwitchPrint.getValue();
		var AddPrintFlag = objAddAndSwitch.AddPrintFlag.getValue();
		if (SwitchRes==""){
			ExtTool.alert("提示","至少选择一联打印");
			return;
		}
		var returnIdS="";
		var returnFlagIds="";
		for(var i=0;i<SwitchRes.length;i++){
			var returnId = SwitchRes[i].id.split("-")[1];
			returnIdS += returnId+separate;
		}
		for(var i=0;i<AddPrintFlag.length;i++){
			var returnFlagId = AddPrintFlag[i].id.split("-")[1];
			returnFlagIds += returnFlagId+separate;
		}
		SwitchFlagIds = returnIdS+"-"+returnFlagIds
		parent.window.returnValue=SwitchFlagIds;
		window.close();
	};
	objAddAndSwitch.exitBtn_click = function(){
		window.close();
	};
}
