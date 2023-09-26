function showConfirmDetail(episodeID) {
    setDllVisibility("hidden");
    var win = new Ext.Window({
        id: 'detailWinConfirm',
        layout: 'fit', 	//自动适应Window大小 
        title: '归档确认记录明细',
        //broder: false,
        frame: true,
        width: 780,
        height: 650,
        shim: false,
        //closeAction:'hide',    
        animCollapse: false,
        constrainHeader: true,
        resizable: true,
        modal: true,
        raggable: true, //不可拖动
        items: [
		    new Ext.Panel({
		        id: 'detailPanelConfirm',
		        layout: 'fit',
		        border: false,
		        items: getGridPanelConfirm(episodeID)
		    })
	    ]
    });

    win.on('close', function() {
        setDllVisibility("visible");
    });

    win.show();
}

//取得操作记录列表数据源
function GetGridStoreConfirm(episodeID) {
    //debugger;
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

    return store;
}

//创建历史操作记录列表的Grid
function getGridPanelConfirm(episodeID) {
    //debugger;
    var store = GetGridStoreConfirm(episodeID);
    store.load();

    var cm = new Ext.grid.ColumnModel([
        { header: '操作名称', dataIndex: 'ActionDesc', width: 100, sortable: true},
        { header: '操作医师', dataIndex: 'ActionUser', width: 100, sortable: true },
        { header: '操做日期', dataIndex: 'ActionDate', width: 100, sortable: true },
        { header: '操作时间', dataIndex: 'ActionTime', width: 100, sortable: true }
    ]);

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
        columnLines: true
    });

    return grid;
}