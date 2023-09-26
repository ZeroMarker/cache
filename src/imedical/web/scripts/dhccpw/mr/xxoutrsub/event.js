
function InitOutReasonSubWindowEvent(obj) {
	obj.LoadEvent = function(args){
		obj.OutReasonSubGridPanelStore.load({});
	};
}

function OutReasonSubLookUpHeader(QryType,CPWID,DateFrom,DateTo,LocID,WardID,CPWDesc)
{
	var objOutReasonSubWindow = new InitOutReasonSubWindow(QryType,CPWID,DateFrom,DateTo,LocID,WardID,CPWDesc);
	objOutReasonSubWindow.OutReasonSubWindow.show();
	ExtDeignerHelper.HandleResize(objOutReasonSubWindow);
}