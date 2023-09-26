
function InitPatMessageViewEvent(obj)
{	obj.LoadEvent = function(args)
	{
	}
	obj.PatientMessList_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.PatientMessListStore.getAt(rowIndex); 
		obj.MessContent.setValue(objRec.get("Message"));
	};
/*PatMessageView新增代码占位符*/
}
