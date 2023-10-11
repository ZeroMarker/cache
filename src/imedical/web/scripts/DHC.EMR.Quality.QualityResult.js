$(function() {
    setDataGrid();
    if(pageType=='KESY'){
		$('.pad-div').css({'width':'1178px','border':'1px solid #ccc','border-top':'0'})  
	}

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
        scrollbarSize :0,
        nowrap:false,
        columns: [
            [{
                field: 'Name',
                title: '姓名',
                halign: 'left',
                align: 'left',
                width: 100
            }, {
                field: 'StructName',
                title: '病历文书',
                halign: 'left',
                width: 540
            }, {
                field: 'StrDate',
                title: '起始时间',
                halign: 'left',
                align: 'left',
                width: 100
            }, {
                field: 'EndDate',
                title: '截止时间',
                halign: 'left',
                align: 'left',
                width: 100
            }, {
                field: 'Hours',
                title: '剩余时间(小时)',
                halign: 'left',
                align: 'left',
                width: 120
            }, {
                field: 'FinishDate',
                title: '完成时间',
                halign: 'left',
                align: 'left',
                width: 100
            }, {
                field: 'OverFlag',
                title: '超时',
                halign: 'left',
                align: 'left',
                width: 80,
                formatter:function(value){
	                return $g(value)
	            }
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
