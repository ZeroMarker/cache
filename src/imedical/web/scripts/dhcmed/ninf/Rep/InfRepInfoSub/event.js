
function InitInfRepInfoSubWindowEvent(obj) {
	obj.LoadEvent = function(args){
		obj.InfRepInfoSubGridPanelStore.load({});
	};
}

function HistoryReportLookUpHeader(EpisodeID,RepTypeCode)
{
	var objInfRepInfoSubWindow = new InitInfRepInfoSubWindow(EpisodeID,RepTypeCode);
	objInfRepInfoSubWindow.InfRepInfoSubWindow.show();
	ExtDeignerHelper.HandleResize(objInfRepInfoSubWindow);
}