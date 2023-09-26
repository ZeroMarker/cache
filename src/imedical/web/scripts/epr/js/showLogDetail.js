function showLogDetail(episodeID, printTemplateDocId, EPRNum) {
    setDllVisibility("hidden");
    var win = new Ext.Window({
        id: 'detailWin',
        layout: 'fit', 	//自动适应Window大小 
        title: '操作记录明细',
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
		        id: 'detailPanel',
		        layout: 'fit',
		        border: false,
		        items: getGridPanel(episodeID, printTemplateDocId, EPRNum)
		    })
	    ]
    });

    win.on('close', function() {
        setDllVisibility("visible");
    });

    win.show();
}

//取得操作记录列表数据源
function GetGridStore(episodeID, printTemplateDocId, EPRNum) {
    //debugger;
    var url = '../web.eprajax.ajaxGetLog.cls?EpisodeID=' + episodeID + '&PrintDocID=' + printTemplateDocId + '&EPRNum=' + EPRNum;
    var store = new Ext.data.JsonStore({
        url: url,
        fields: [
            { name: 'OrderID', type: 'int' },
            { name: 'UserName' },
            { name: 'OperDate' },
            { name: 'OperTime' },
            { name: 'MachineIP' },
            { name: 'Action' },
            { name: 'TplName' },
            { name: 'TplCreateDate' },
            { name: 'TplCreateTime' }
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
function getGridPanel(episodeID, printTemplateDocId, EPRNum) {
    //debugger;
    var store = GetGridStore(episodeID, printTemplateDocId, EPRNum);
    store.load();

    store.setDefaultSort('OrderID', 'asc');

    var cm = new Ext.grid.ColumnModel([
        { header: '顺序号', dataIndex: 'OrderID', width: 50, sortable: true, type: 'int' },
        { header: '操作医师', dataIndex: 'UserName', width: 75, sortable: true },
        { header: '操做日期', dataIndex: 'OperDate', width: 75, sortable: true },
        { header: '操作时间', dataIndex: 'OperTime', width: 70, sortable: true },
        { header: 'IP地址', dataIndex: 'MachineIP', width: 85, sortable: true },
        { header: '操作名称', dataIndex: 'Action', width: 95, sortable: true },
        { header: '模板名称', dataIndex: 'TplName', width: 120, sortable: true, resizable: true },
        { header: '创建日期', dataIndex: 'TplCreateDate', width: 75, sortable: true },
        { header: '创建时间', dataIndex: 'TplCreateTime', width: 75, sortable: true }
    ]);

    var grid = new Ext.grid.GridPanel({
        id: 'detailGrid',
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