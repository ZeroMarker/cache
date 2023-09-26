
function InitICUStrAdmSubWindowEvent(obj) {
	obj.LoadEvent = function(args){
		obj.ICUStrAdmSubGridPanelStore.load({});
	};
}

function StrAdmLookUpHeader(SurveryDate,LocID)
{
	//alert(SurveryDate);
	//alert(LocID);
	var objInitICUStrAdmSubWindow = new InitICUStrAdmSubWindow(SurveryDate,LocID);
	objInitICUStrAdmSubWindow.ICUStrAdmSubWindow.show();
	var numTop=(document.body.clientHeight-objInitICUStrAdmSubWindow.ICUStrAdmSubWindow.height)/2;
	var numLeft=(document.body.clientWidth-objInitICUStrAdmSubWindow.ICUStrAdmSubWindow.width)/2;
	objInitICUStrAdmSubWindow.ICUStrAdmSubWindow.setPosition(numLeft,numTop);
	ExtDeignerHelper.HandleResize(objInitICUStrAdmSubWindow);
	
}