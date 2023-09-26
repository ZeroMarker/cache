var episodeID = "";

var view = new Ext.Viewport({
	id: 'detailWinConfirm',
	shim: false,
	animCollapse: false,
	constrainHeader: true, 
	collapsible: true,
	margins:'0 0 0 0',           
	layout: "border",  
	border: false,              
	items: [{
		border:true,
		region:'center',
		layout:'fit',
		bodyStyle:'padding:0px 0px 0px 0px',
		split: true,
		collapsible: true,  
		items: grid
	}]
});



//取得操作记录列表数据源

    var url = '../DHCEPRFS.web.eprajax.AdmMRStatusMgr.cls?ActionType=getdetail&EpisodeID=' + episodeID;
    var store = new Ext.data.JsonStore({
        url: url,
        fields: [
            { name: 'ActionDesc' },
            { name: 'ActionUser' },
            { name: 'ActionDate' },
            { name: 'ActionTime' }
        ]
    });

    //测试数据源是否正常加载
    store.on('load', function() {
        //这个函数会在数据加载完后触发
        //debugger;
        //alert(store);
    });
    store.on('loadexception', function(proxy, options, response, e) {
        //数据加载异常
        //debugger;
        //alert(response.responseText);
        //alert(e);
        //var i = response.responseText.indexOf('\r\n')
        //alert(i);
    });


//创建历史操作记录列表的Grid

    var cm = new Ext.grid.ColumnModel([
        { header: '操作名称', dataIndex: 'ActionDesc', width: 100, sortable: true},
        { header: '操作医师', dataIndex: 'ActionUser', width: 100, sortable: true },
        { header: '操做日期', dataIndex: 'ActionDate', width: 100, sortable: true },
        { header: '操作时间', dataIndex: 'ActionTime', width: 100, sortable: true }
    ]);

	var tbarGrid =  new Ext.Toolbar({
		items:[
			'请输入就诊号：',
			{
				xtype:'textfield',
				id:'txtEpisodeID',
				width:150,
				emptyText:'就诊号'		
			},
			{
				xtype: 'button',
				id : 'btnSearch',
				text:'查询',
				cls: 'x-btn-text-icon',
				handler: doSearch
			}
		]
	});
	
    var grid = new Ext.grid.GridPanel({
        id: 'detailGridConfirm',
        layout: 'fit',
        border: false,
        store: store,
        cm: cm,
        forceFit: true,
        autoScroll: true,
        frame: true,
        stripeRows: true,
        columnLines: true,
		tbar:tbarGrid
    });
	
	function doSearch()
	{
		
		episodeID = Ext.getCmp('txtEpisodeID').getValue();
		
		var s = Ext.getCmp('detailGridConfirm').getStore();
		s.proxy.conn.url = '../DHCEPRFS.web.eprajax.AdmMRStatusMgr.cls?ActionType=getdetail&EpisodeID=' + episodeID;
		s.load();
	}
