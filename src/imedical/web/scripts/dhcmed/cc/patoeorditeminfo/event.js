
function InitOEWinEvent(obj)
{	obj.LoadEvent = function(args)
	{
	}
	obj.BtnFind_click = function()
	{
		obj.OEListGridStore.load({params : {start:0 ,limit:20}});	
	};
	obj.OEComBox_click = function()
	{
		obj.OEItemComBoxStore.load({});
		obj.OEItemComBox.setValue();
		obj.OEListGridStore.load({params : {start:0 ,limit:20}});
	}
}
