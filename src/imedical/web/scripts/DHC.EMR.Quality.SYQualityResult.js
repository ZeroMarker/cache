$(function() {
    setDataGrid();

});
//设置数据
function setDataGrid() {
    $('#QualityData').datagrid({
        pageSize: 30,
        pageList: [10, 20, 30],
        loadMsg: '数据装载中......',
        autoRowHeight: true,
        url: '../EMRservice.Ajax.Quality.cls?Action='+Action+'&EpisodeID='+EpisodeID+'&RuleID='+RuleID+'&CTLocatID='+CTLocatID+'&userID='+userID,
        rownumbers: true,
        pagination: false,
        singleSelect: false,
        fitColumns: true,
        fit: true,
        columns: [
            [{
                field: 'Name',
                title: '姓名',
                halign: 'center',
                align: 'center',
                width: 40
            }, {
                field: 'StructName',
                title: '病历文书',
                halign: 'center',
                width: 150
            }]
        ],
        view: groupview,
        groupField: 'Name',
        groupFormatter: function(value, rows) {
            return value + ' － ' + rows.length;
        },
        onCheck: function(rowIndex, rowData) {

        },
        onUncheck: function(rowIndex, rowData) {

        },
        onCheckAll: function(rows) {

        },
        onUncheckAll: function(rows) {

        }
    });
}
