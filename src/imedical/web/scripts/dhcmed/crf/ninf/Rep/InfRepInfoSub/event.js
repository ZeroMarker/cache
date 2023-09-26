
function InitInfRepInfoSubWindowEvent(obj) {
	obj.LoadEvent = function(args){
		obj.InfRepInfoSubGridPanelStore.load({});
	};
}

function HistoryReportLookUpHeader(EpisodeID,RepTypeID)
{
	var objInfRepInfoSubWindow = new InitInfRepInfoSubWindow(EpisodeID,RepTypeID);
	objInfRepInfoSubWindow.InfRepInfoSubWindow.show();
	ExtDeignerHelper.HandleResize(objInfRepInfoSubWindow);
}