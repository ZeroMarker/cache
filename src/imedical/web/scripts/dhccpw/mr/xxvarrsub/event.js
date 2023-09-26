
function InitVarReasonSubWindowEvent(obj) {
	obj.LoadEvent = function(args){
		obj.VarReasonSubGridPanelStore.load({});
	};
}

function VarReasonSubLookUpHeader(QryType,CPWID,DateFrom,DateTo,LocID,WardID,CPWDesc)
{
	var objVarReasonSubWindow = new InitVarReasonSubWindow(QryType,CPWID,DateFrom,DateTo,LocID,WardID,CPWDesc);
	objVarReasonSubWindow.VarReasonSubWindow.show();
	ExtDeignerHelper.HandleResize(objVarReasonSubWindow);
}