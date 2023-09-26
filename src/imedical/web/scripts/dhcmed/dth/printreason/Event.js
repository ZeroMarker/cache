
function InitPrintReasonSubWindowEvent(obj) {
	obj.LoadEvent = function(args){
		obj.PrintReasonSubGridPanelStore.load({});
	};
}

function PrintReasonSubLookUpHeader(reportId)
{
	var objPrintReasonSubWindow = new InitPrintReasonSubWindow(reportId);
	objPrintReasonSubWindow.PrintReasonSubWindow.show();
	ExtDeignerHelper.HandleResize(objPrintReasonSubWindow);
}