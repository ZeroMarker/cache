var customerquery;
$(function() {
    if (envVar.method == '') return;

    customerquery = $("#customerquery")
    customerquery.datagrid({
        loadMsg: '数据装载中......',
        url: '../EMRservice.BL.OPCustomerQuery.cls?Flag=' + envVar.flag + '&PatientID=' + patInfo.PatientID + '&EpisodeID=' + patInfo.EpisodeID,
        singleSelect: false,
        rownumbers: true,
        pagination: envVar.pagination == 1,
        pageSize: 20,
        fit: true,
        fitColumns: true,
        columns: envVar.columns
    });
});

function refreshData() {
    customerquery.datagrid('reload');
}

function refData() {
    /*var d = "1{{ddd}}sfdsaf{{ccc}}fdsaf{{bbbb}}";
    var patt = /\{\{([^\}\}]+)\}\}/g;
    var arr = [];
    d.replace(patt, function($0, $1) { arr.push($1) });
    alert(arr.length);
    alert(d);
    return;*/

    var result = '',
        separate = '\n';

    var patt = /\{\{([^\}\}]+)\}\}/g;
    var refCols = [];

    envVar.refColumns.replace(patt, function($0, $1) { refCols.push($1) });

    var ckItems = customerquery.datagrid('getChecked');
    $.each(ckItems, function(index, item) {

        var text = envVar.refColumns;
        for (var idx = 0, len = refCols.length; idx < len; idx++) {
            text = text.replace('{{' + refCols[idx] + '}}', item[refCols[idx]]);
        }

        if (result != '') result = result + separate;
        result = result + text;
    });

    if (result != '') {
        var param = {
            "action": "insertText",
            "text": result
        };
        parent.eventDispatch(param);
        customerquery.datagrid("uncheckAll");
    }
}