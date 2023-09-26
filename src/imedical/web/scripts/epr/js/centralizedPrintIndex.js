
//view******************************************
var view = new Ext.Viewport({
    id: 'viewpoint',
    layout: 'border',
    border: false,
    margins: '0 0 0 0',
    shim: false,
    collapsible: true,
    animCollapse: false,
    constrainHeader: true,        
	items: [{
		id: 'eprMainCenter',
		region: 'center',
 		layout: 'fit',
		html: '<iframe id ="centralizedPrint" style="width:100%; height:100%" src=' + 'dhc.epr.centralizedprintiframe.csp?EpisodeID=' + episodeID + '&PatientID=' + patientID + '></iframe>'
	},{
		id: 'eprEpisodelist',
		title: '病人列表',
        region: 'west',
		layout: 'fit',
		border: false,
		margins: '0 0 0 0',
		collapsible: true,
		collapsed: true,
		titleCollapse: true,
		split: true,
		height: 200,
       	minSize: 200,
        maxSize: 300,
		html:'<iframe id ="episodeListFrame" style="width:100%; height:100%" src=' + 'dhc.epr.centralizedprintlist.csp?EpisodeID=' +episodeID + '></iframe>'          
    }] 
});


//切换当前患者
function doSwitch(patientID,episodeID) {
	var src = "../csp/dhc.epr.centralizedprintiframe.csp?EpisodeID=" + episodeID + "&PatientID=" + patientID;
	Ext.get("centralizedPrint").dom.src = src;
	Ext.getCmp("eprEpisodelist").collapse(true);
}