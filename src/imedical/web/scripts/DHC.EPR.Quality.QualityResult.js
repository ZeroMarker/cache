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
        url: '../EMRservice.Ajax.Quality.cls?Action=GetQualityResult&EpisodeID='+EpisodeID+'&RuleID='+RuleID+'&CTLocatID='+CTLocatID+'&userID='+userID,
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
            }, {
                field: 'StrDate',
                title: '起始时间',
                halign: 'center',
                align: 'center',
                width: 70
            }, {
                field: 'EndDate',
                title: '截止时间',
                halign: 'center',
                align: 'center',
                width: 70
            }, {
                field: 'Hours',
                title: '剩余时间(小时)',
                halign: 'center',
                align: 'center',
                width: 40
            }, {
                field: 'FinishDate',
                title: '完成时间',
                halign: 'center',
                align: 'center',
                width: 70
            }, {
                field: 'OverFlag',
                title: '超时',
                halign: 'center',
                align: 'center',
                width: 40
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
