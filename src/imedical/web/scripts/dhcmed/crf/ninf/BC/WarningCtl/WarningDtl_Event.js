
function InitWarningDtlWinEvent(obj) {
	obj.LoadEvent = function(args){
		obj.WarningDtlGridPanelStore.load({});
		obj.RowExpander.on("expand",obj.RowExpander_expand,obj);
	};
	
	obj.RowExpander_expand = function(){
		var objRec = arguments[1];
		var EpisodeID = objRec.get("EpisodeID");
		var CtrlDtl = objRec.get("CtrlDtl");
		if ((!EpisodeID)||(!CtrlDtl)) return;
		
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.NINFService.BC.WarningSrv',
				QueryName : 'QryWarningCtrlDtl',
				Arg1 : CtrlDtl,
				ArgCnt : 1
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var arryData = new Array();
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					arryData[arryData.length] = objItem;
				}
				obj.RowTemplate.overwrite("divCtrlDtl-" + EpisodeID, arryData);
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("divCtrlDtl-" + EpisodeID);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
}

function WarningDtlLookUpHeader(aConfigCode, aWarningDate, aHospID, aDayCode, aLocID, aDataValue)
{
	var objWarningDtlWin = new InitWarningDtlWin(aConfigCode, aWarningDate, aHospID, aDayCode, aLocID, aDataValue);
	objWarningDtlWin.WarningDtlWin.show();
	ExtDeignerHelper.HandleResize(objWarningDtlWin);
}