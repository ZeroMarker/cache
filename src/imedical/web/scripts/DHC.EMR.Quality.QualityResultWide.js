$(function() {
    setDataGrid();
    getQualityResult();

});
//��������
function setDataGrid() {
    $('#QualityData').datagrid({
        pageSize: 30,
        pageList: [10, 20, 30],
        loadMsg: '����װ����......',
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
                title: '����',
                halign: 'center',
                align: 'center',
                width: 40
            }, {
                field: 'StructName',
                title: '��������',
                halign: 'center',
                width: 150
            }, {
                field: 'StrDate',
                title: '��ʼʱ��',
                halign: 'center',
                align: 'center',
                width: 70
            }, {
                field: 'EndDate',
                title: '��ֹʱ��',
                halign: 'center',
                align: 'center',
                width: 70
            }, {
                field: 'Hours',
                title: 'ʣ��ʱ��(Сʱ)',
                halign: 'center',
                align: 'center',
                width: 40
            }, {
                field: 'FinishDate',
                title: '���ʱ��',
                halign: 'center',
                align: 'center',
                width: 70
            }, {
                field: 'OverFlag',
                title: '��ʱ',
                halign: 'center',
                align: 'center',
                width: 40
            }]
        ],
        view: groupview,
        groupField: 'Name',
        groupFormatter: function(value, rows) {
            return value + ' �� ' + rows.length;
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

function getQualityResult()
{
	
	$('#dgCurQualityResult').datagrid({ 
			fitColumns: true,
			method: 'post',
            loadMsg: '������......',
			autoRowHeight: true,
			url:'../EPRservice.Quality.Ajax.GetQualityResult.cls',
			queryParams: {
            	RuleID:"1",
                EpisodeID:EpisodeID,
                SSGroupID:SSGroupID,
                CTLocatID:CTLocatID,
                Action:"A"
            },
			fit:true,
			nowrap:false,
			columns:[[
				{field:'EntryName',title:'������Ŀ',width:300},
				{field:'ResumeText',title:'��ע',width:100,align:'center'},
				{field:'SignUserName',title:'�ʿ�Ա',width:80,align:'center'},
				{field:'ReportDate',title:'�ʿ�����',width:80,align:'center'},
				{field:'CtLocName',title:'���ο���',width:80,align:'center'},
				{field:'EmployeeName',title:'������',width:80,align:'center'}
				
			]]
	  }); 
}