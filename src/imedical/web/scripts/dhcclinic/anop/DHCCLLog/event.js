//dyl+20171031+»’÷æ≤È—Ø
function InitViewScreenEvent(obj)
{
var _DHCCLLog=ExtTool.StaticServerObject('web.DHCCLLog');
obj.LoadEvent = function(args)
	{
		var Rowid="";
		 
	};
	obj.btnSch_click = function()
	{
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});
	}
 obj.LogValue_select=function()
	 {
	  obj.EditValueStore.reload({});
	  obj.OriginValueStore.reload({});
	 }
}