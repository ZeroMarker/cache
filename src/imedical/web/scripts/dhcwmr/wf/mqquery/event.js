
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args)
  {};
	obj.btnQuery_click = function()
	{
		obj.gridResultStore.load({});
	};
/*viewScreen新增代码占位符*/}

function ShowPatInfo(MainID, VolID) {
	window.open(
		"./dhcwmr.ss.pat.info.csp?MainID=" + MainID + "&VolID=" + VolID
		, "_blank"
	);
}