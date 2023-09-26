$(function() {
    strXml = convertToXml(scheme);
    $('#currentEpisode').attr("checked", true);
    $("#comboxEpisode").hide();
    initEpisodeList("#EpisodeList");
    $('#seekform').find(':radio').change(function() {
        if (this.id == "allEpisode") {
            $("#comboxEpisode").show();
        } else {
            $("#comboxEpisode").hide();
            queryData();
        }
    });
    setDataGrid();
    queryData();
});

function getCheckedIds() {
    var ordItemId = '';
    var ids = $('#lisData').datagrid('getChecked');
    for(var i=0;i<ids.length;i++) {
        quoteData[ids[i].OEordItemRowID] = {}
        if (''==ordItemId) { ordItemId = ids[i].OEordItemRowID; }
        else { ordItemId = ordItemId + '^' + ids[i].OEordItemRowID; }
    }    
    return ordItemId;
}

//设置数据
function setDataGrid() {
        $('#lisData').datagrid({
            pageSize: 10,
            pageList: [10, 20, 30],
            loadMsg: '数据装载中......',
            autoRowHeight: true,
            url: '../EMRservice.Ajax.lisData.cls?Action=GetLisData',
            rownumbers: true,
            pagination: true,
            singleSelect: 'Y'==singleSelect,
            idField: 'OEordItemRowID',
            fit: true,
            columns: getColumnScheme("show>parent>item"),
            onCheck: function(rowIndex, rowData) {
                //debugger;
                //var ordItemId = rowData.OEordItemRowID;
                quoteData = {};
                var ordItemId = getCheckedIds();
                //quoteData[ordItemId] = {};
                $('#lisSubData').datagrid('load', {
                    Action: 'GetMultiSubLis',
                    ID: ordItemId
                });
            },
            onUncheck: function(rowIndex, rowData) {
                /*$('#lisSubData').datagrid('uncheckAll');
                $('#lisSubData').datagrid('loadData', {
                    total: 0,
                    rows: []
                });*/
                //delete quoteData[rowData.OEordItemRowID];
                quoteData = {};
                var ordItemId = getCheckedIds();
                //quoteData[ordItemId] = {};
                $('#lisSubData').datagrid('load', {
                    Action: 'GetMultiSubLis',
                    ID: ordItemId
                });                
            },
            onCheckAll: function(rows) {
                quoteData = {};
                /*var length = rows.length;
                for (i = 0; i < length; i++) {
                    quoteData[rows[i].OEordItemRowID] = {};
                    $('#lisSubData').datagrid('load', {
                        Action: 'GetSubLis',
                        ID: rows[i].OEordItemRowID
                    });
                }*/
                var ordItemId = getCheckedIds();
                //quoteData[ordItemId] = {};
                $('#lisSubData').datagrid('load', {
                    Action: 'GetMultiSubLis',
                    ID: ordItemId
                });                
            },
            onUncheckAll: function(rows) {
                quoteData = {};
                $('#lisSubData').datagrid('loadData', {
                    total: 0,
                    rows: []
                });
            }
        });
        $('#lisSubData').datagrid({
            loadMsg: '数据装载中......',
            autoRowHeight: true,
            url: '../EMRservice.Ajax.lisData.cls?Action=GetSubLis',
            rownumbers: true,
            singleSelect: false,
            fit: true,
            columns: getColumnScheme("show>child>item"),
            onCheck: function(rowIndex, rowData) {
                quoteData[rowData.OeordID]["child" + rowIndex] = {
                    "ItemDesc": rowData.ItemDesc,
                    "Synonym": rowData.Synonym,
                    "ItemResult": rowData.ItemResult,
                    "ItemUnit": rowData.ItemUnit,
                    "AbnorFlag": rowData.AbnorFlag,
                    "ItemRanges": rowData.ItemRanges
                };
            },
            onUncheck: function(rowIndex, rowData) {
                delete quoteData[rowData.OeordID]["child" + rowIndex];
            },
            onCheckAll: function(rows) {
                var length = rows.length;
                if (length <= 0) return;
                delete quoteData[rows[0].OeordID]
                quoteData[rows[0].OeordID] = {};
                for (i = 0; i < length; i++) {
                    quoteData[rows[i].OeordID]["child" + i] = {
                        "ItemDesc": rows[i].ItemDesc,
                        "Synonym": rows[i].Synonym,
                        "ItemResult": rows[i].ItemResult,
                        "ItemUnit": rows[i].ItemUnit,
                        "AbnorFlag": rows[i].AbnorFlag,
                        "ItemRanges": rows[i].ItemRanges
                    };
                }
            },
            onUncheckAll: function(rows) {
                if (rows[0]) {
                    quoteData[rows[0].OeordID] = {};
                };

            },
            rowStyler: function(index, row) {
                if (row.AbnorFlag != "") {
                    return 'color:#FF0000;';
                }
            },
            onLoadSuccess: function(data) { //当表格成功加载时执行               
                var rowData = data.rows;
                $.each(rowData, function(idx, val) { //遍历JSON
                    if (val.AbnorFlag != "") {
                        $("#lisSubData").datagrid("selectRow", idx); //选中行
                    }
                });
            }
        });
    }
    // 查询
function queryData() {
        var stDateTime = "",
            endDateTime = "";
        var epsodeIds = episodeID;
        if ($('#allEpisode')[0].checked) {
            epsodeIds = "";
            var values = $('#EpisodeList').combogrid('getValues');
            for (var i = 0; i < values.length; i++) {
                epsodeIds = (i == 0) ? "" : epsodeIds + ",";
                epsodeIds = epsodeIds + values[i];
            }
        }
        $('#lisData').datagrid('reload', {
            ID: epsodeIds,
            StartDateTime: stDateTime,
            EndDateTime: endDateTime
        });
    }
    //引用数据
function getData() {
    var result = "";
    var parentList = getRefScheme("reference>parent>item");
    var childList = getRefScheme("reference>child>item");
    var separate = $(strXml).find("reference>separate").text();

    separate = (separate == "enter") ? "\n" : separate;
    var checkedItems = $('#lisData').datagrid('getChecked');
    $.each(checkedItems, function(index, item) {
        if (quoteData[item.OEordItemRowID]) {
            //收集父内容
            for (var i = 0; i < parentList.length; i++) {
                result = result + parentList[i].desc + item[parentList[i].code] + parentList[i].separate;
            }
            //收集子表内容
            $.each(quoteData[item.OEordItemRowID], function(index, item) {
                for (j = 0; j < childList.length; j++) {
                    if (childList[j].code == "ItemUnit") {
            //判断单位是否需要加"*"号
            if (item[childList[j].code].indexOf("10") == 0){
                item[childList[j].code] = "*" + item[childList[j].code];
            }
            result = result + childList[j].desc + item[childList[j].code] + childList[j].separate;
            }else{
            result = result + childList[j].desc + item[childList[j].code] + childList[j].separate;
            }
                }
            });
            result = result + separate;
        }
    });

    var param = {
        "action": "insertText",
        "text": result
    };
    invoker.eventDispatch(param);
    UnCheckAll();
}

//去掉选择
function UnCheckAll() {
    $("#lisData").datagrid("uncheckAll");
}
