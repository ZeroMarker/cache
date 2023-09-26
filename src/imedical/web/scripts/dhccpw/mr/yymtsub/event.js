
function InitMTSubWindowEvent(obj)
{
	obj.LoadEvent = function(args){
		obj.gpCPWMonistorStore.load({});
		obj.btnInputVar.on("click", obj.btnInputVar_OnClick, obj);
	};
	
	obj.btnInputVar_OnClick = function(){
		VarianceRecordHeader(obj.PathWayID,obj.UserID)
	}
}

function MonitorRstLookUpHeader(PathWayID,UserID)
{
		var objMTSubWindow = new InitMTSubWindow(PathWayID,UserID);
        objMTSubWindow.MTSubWindow.show();
		var numTop=(screen.availHeight-objMTSubWindow.MTSubWindow.height)/2;
		var numLeft=(screen.availWidth-objMTSubWindow.MTSubWindow.width)/2;
		objMTSubWindow.MTSubWindow.setPosition(numLeft,numTop);
        ExtDeignerHelper.HandleResize(objMTSubWindow);
}
