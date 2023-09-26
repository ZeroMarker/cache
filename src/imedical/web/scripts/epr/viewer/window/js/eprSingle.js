//Œ®“ª È–¥“≥√Ê
function createEprSingle(episodeID, patientID, printTemplateDocID, templateDocID)
{
	var singleEditWindowID = 'singleEditWindow';
	var frameSingleEditWindowID = 'frameSingleEditWindow';
	var frameUrl = 'epr.newfw.centerTabDetialNew.csp?episodeID=' + episodeID + '&patientID=' + patientID + '&templateDocId=' + templateDocID + '&printTemplateDocId=' + printTemplateDocID;
	var win = Ext.getCmp(singleEditWindowID);
	if(!win)
	{
		win = new Ext.Window({
			id: singleEditWindowID,
			footer : false,
			width: 640,
			height: 480,
			iconCls: 'accordion',
			//collapsed: true,
			collapsible: true,
			shim: false,
			animCollapse: false,
			constrainHeader: true,
			//layout: 'fit',
			border: false,
			maximizable: true,
			//minimizable: true,
			//renderTo: 'divCenter',
			modal: true,
			layoutConfig: {
				animate: false
			},
			listeners: 
			{
				'beforeclose': function(panel){ this.hide(); return false; }
			},
			html: '<iframe id=' + frameSingleEditWindowID + ' style="width:100%; height:100%;" src=' + frameUrl + '></iframe>'
		});					
	}
	else
	{
		var frame = document.getElementById(frameSingleEditWindowID);
		frame.src = 'about:blank';
		frame.src =  frameUrl;
	}
	win.show.defer(100, win);
}