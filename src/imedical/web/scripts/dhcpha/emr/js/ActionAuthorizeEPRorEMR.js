 //debugger;
Ext.QuickTips.init();

var authorizePanel = new Ext.Panel({
	id: 'authorizePanel',
	frame: true,
	html: getEPRorEMRhtml()
});

var view = new Ext.Viewport({
    id: 'authorizeViewPort',
    shim: false,
    animCollapse: false,
    constrainHeader: true,
    collapsible: true,
    margins: '0 0 0 0',
    layout: "fit",
    border: false,
    items: authorizePanel
});

function getEPRorEMRhtml()
{
	alert(DHCEMR);
	var html = "";
	if (DHCEMR == 0)
	{
		alert(DHCEMR);
		html = '<iframe id="frmEPRAuthorize" style="width:100%; height:100%" src="epr.newfw.actionauthorizeEPR.csp?EpisodeID=' + episodeID + '&ConsultID=' + consultID + '&ConsdocID=' + consdocID + '&ConslocID=' + consLocID + '&ConsultType=' + consultType + '&AppointType=' + appointType + '"></iframe>';
	}
	else if (DHCEMR == 1)
	{
		alert(DHCEMR);
		html = '<iframe id="frmEMRAuthorize" style="width:100%; height:100%" src="emr.authorizes.actionauthorize.csp?EpisodeID=' + episodeID + '&ConsultID=' + consultID + '&ConsdocID=' + consdocID + '&ConslocID=' + consLocID + '&ConsultType=' + consultType + '&AppointType=' + appointType + '"></iframe>';
	}
	return html;
}