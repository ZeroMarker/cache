var frmMainContent = new Ext.Viewport({
	id: 'viewport',
	margins:'0 0 0 0',           
	layout: "border",  
	border: false,
	items: [
		{
		border:false,
		title:'≤°»À¡–±Ì',
		region:'north',
		layout:'border',
		split: true,
		frame:true,
		collapsible: true,
		collapsed: true,
		height:260,
		//width:310,
		items: [{
			border: false,
			region: "center",
			layout: "fit",
			html:'<iframe id="PatientListPanel" name="PatientListPanel" style="width:100%;height:100%" src="epr.newfw.patientlist.csp?episodeID="'+ episodeID +'"></iframe>'
		}]
	},{
		border: false,
		region: "center",
		layout: "border",
		items: [{
			border: false,
			region: "center",
			layout: "fit",
			html:'<iframe id="episodelistbrowser" name="episodelistbrowser" style="width:100%;height:100%" src="epr.newfw.episodelistbrowser.csp?PatientID=' + patientID + '&EpisodeID="'+ episodeID +'"></iframe>'
		}]
    }]
});


function doSwitch(PatientID,EpisodeID,mradm) {
	var frame = document.getElementById("episodelistbrowser");
	frame.src = 'epr.newfw.episodelistbrowser.csp?PatientID=' + PatientID + '&EpisodeID='+ EpisodeID;
}