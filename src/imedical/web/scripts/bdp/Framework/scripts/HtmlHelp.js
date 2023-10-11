



///var htmlurl = "../scripts/bdp/AppHelp/Electronic/MRCICDDx.htm";

///htmlhelpbtn
	var Helpwin = new Ext.Window({
		title : '页面说明',
		width:850,
		height: 550,
		layout : 'fit',
		plain : true,
		modal : true,
		frame : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		closeAction : 'hide',
		items : helphtml={
			html:' <iframe scrolling="auto" frameborder="0" width="100%" height="100%" src="'+htmlurl+'"></iframe>'
		}
	})
	// 刷新工作条
	var helphtmlbtn = new Ext.Button({
				id : 'helphtmlbtn',
				//disabled : Ext.BDP.FunLib.Component.DisableFlag('helphtmlbtn'),
				iconCls : 'icon-help',
				text : '页面说明',
				handler : function() {
					Helpwin.show()
				}
	})
	