var init =function(){
	var columns = [
        [{
            field: 'MKBTDesc',
            title: 'ICD版本',
            width: 100
        }]
    ];
    var datagrid = $HUI.datagrid("#datagrid", {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCBL.MKB.MKBEChartsInterface",
            QueryName: "GetMKBVersion",
            dataflag:MKBVDataFlag,
            dataid:MKBVDataID
        },
        columns: columns, 
        pagination: true, 
        pageSize: 20,
        pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500, 1000],
        singleSelect: true,
        remoteSort: false,
        idField: 'MKBTDesc',
        rownumbers: true, 
        fitColumns: true
    });
}
$(init);