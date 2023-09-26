function InitAddPrintFlagEvent(AddPrintFlag){
	var separate="^";
	AddPrintFlag.LoadEvent = function(){
	};
	AddPrintFlag.saveBtn_click = function(){
		var AddPrintFlagObj = AddPrintFlag.AddPrintFlag.getValue();
		var returnFlagIdS=""
		for(var i=0;i<AddPrintFlagObj.length;i++){
			var returnFlagId = AddPrintFlagObj[i].id.split("-")[1];
			returnFlagIdS += returnFlagId+separate;
		}
		parent.window.returnValue=returnFlagIdS;
		window.close();
	};
	AddPrintFlag.exitBtn_click = function(){
		window.close();
	};
}
