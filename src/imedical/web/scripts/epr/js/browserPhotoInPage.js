//add by niucaicai on 2012-9-18
var PanelWithPageToobar = new Ext.Panel({
	id: 'PanelWithPageToobar',
	name: 'PanelWithPageToobar',
	layout: 'fit',
	//title: '分页浏览',
	autoScroll: true,
	items:[{
			border: false,
      		id: 'browserPhoto',
      		layout: 'fit',
			//避免了传递的参数超出GET的最大值而导致的数据丢失    2012-10-17 by niucaicai
      		html:'<iframe id="browserPhoto" style="width:100%; height:100%" src="epr.newfw.episodelistbrowserphoto.csp?PatientID='+ patientID +'&EpisodeID='+ episodeID+ '"></iframe>'// +'&ImageList='+ escape(imageList) + '"></iframe>'
        }],
	bbar: [
			{
				id: 'picCount',
				name: 'picCount',
				cls: 'x-btn-text-icon',
				pressed: false
			},
			{
				id: 'displayMessage',
				name: 'displayMessage',
				cls: 'x-btn-text-icon',
				pressed: false
			},
			'->','-',
			{
				id: 'btnPageUp',
				name: 'btnPageUp',
				text: '上一页',
				cls: 'x-btn-text-icon',
				icon: '../scripts/epr/Pics/pageup.gif',
				pressed: false
			},
			{
				id: 'pageFieldLabel',
				name: 'pageFieldLabel',
				text: '页码'
			},
			{
				id: 'pageField',
				name: 'pageField',
				xtype: 'textfield',
				width: 40
			},
			{
				id: 'GotoCurPage',
				name: 'GotoCurPage',
				text: '跳'
			},
			{
				id: 'pageCount',
				name: 'pageCount'
			},

			{
				id: 'btnPageDown',
				name: 'btnPageDown',
				text: '下一页',
				cls: 'x-btn-text-icon',
				icon: '../scripts/epr/Pics/pagedown.gif',
				pressed: false
			},
			{
				id: 'btnPrintPic',
				name: 'btnPrintPic',
				text: '打印',
				cls: 'x-btn-text-icon',
				icon: '../scripts/epr/Pics/printer.gif',
				pressed: false
			}			
		]
});

var tabPortncc = new Ext.Viewport({
    layout:'border',
	//height:100,
	autoScroll: true,
    items:[{
        region:'center',
        layout:'fit',
        items:PanelWithPageToobar
    }]
});
