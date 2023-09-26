//历次书写页面
function createMultiple(iframeScript, btnRefresh)
{
	var multipleEditWindowID = 'multipleEditWindow';
	var frameMultipleEditWindowID = 'frameMultipleEditWindow';
	var frameUrl = iframeScript;
	var win = Ext.getCmp(multipleEditWindowID);
	if(!win)
	{
		win = new Ext.Window({
			id: multipleEditWindowID,
			footer : false,
			width: 640,
			height: 480,
			iconCls: 'accordion',
			//collapsed: true,
			collapsible: true,
			shim: false,
			animCollapse: false,
			//constrainHeader: true,
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
				'beforeclose': function(panel){ btnRefresh.fireEvent('click'); this.hide(); return false; }
			},
			html: '<iframe id=' + frameMultipleEditWindowID + ' style="width:100%; height:100%;" src=' + frameUrl + '></iframe>'
		});					
	}
	else
	{
		var frame = document.getElementById(frameMultipleEditWindowID);
		frame.src = 'about:blank';
		frame.src =  frameUrl;
	}
	win.show.defer(100, win);
}
