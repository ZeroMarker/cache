
function InitSendMassageEvent(obj) {
	obj.LoadEvent = function(args){
		obj.btnCancel.on("click",obj.btnCancel_click,obj);
	};
	
	obj.btnCancel_click = function()
	{
		obj.winSendFeedback.close();
	};
	
	obj.LoadPage = function(){
		var objPatXTemplateDiv = document.getElementById('PatXTemplateDIV');
		if (objPatXTemplateDiv) {
			obj.LoadCasesXDtl('PatXTemplateDIV','INTCCS',obj.EpisodeID,obj.CasesXDates);
		}
	};
}