$(function () {
	InitGridPatInfo();
})
function InitGridPatInfo(){
        var columns = [[
            {
                field: 'group',
                title: 'group',
                hidden: true
            },
            {
                field: 'field1',
                title: '属性',
                width: 100,
                align: 'right'
            },
            {
                field: 'value1',
                title: '值',
                width: 300,
                styler: function (value, row, index) {
                    if (row.field1 == $g('特殊人群')) {
                        if (value != '') {
                            return 'background:#d472ae;color:#fff;';
                        }
                    }
                }
            },
            {
                field: 'field2',
                title: '属性',
                width: 100,
                align: 'right'
            },
            {
                field: 'value2',
                title: '值',
                width: 300,
                styler: function (value, row, index) {
                    if (row.field2 == $g('患者状态')) {
                        if ([$g('病重'), $g('病危')].indexOf(value) >= 0) {
                            return 'background:#ee4f38;color:#fff;';
                        }
                    } else if (row.field2 == $g('出院时间')) {
                        if (value.trim() != '') {
                            return 'background:#03ceb4;color:#fff;';
                        }
                    }
                }
            }
       ]];
	var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.COM.Query',
            QueryName: 'AdmDetailGrp',
            Oeori: PHA_Oeori || '',
            AdmId: PHA_AdmId|| '',
            PrescNo: PHA_PrescNo|| ''
        },
        fit: true,
        fitColumns: true,
        showHeader: false,
        // showGroup: true,
        rownumbers: false,
        columns: columns,
        pageSize: 9999,
        pagination: false,
        singleSelect: true,
        nowrap: false,
        border: false,
        exportXls: false,
        onLoadSuccess: function (data) {
	        if (data.rows) {
                var rowsData = data.rows;
                // 合并列
                for (var i = 0; i < rowsData.length; i++) {
                    var rowData = rowsData[i];
                    if (rowData.field1 == $g('诊断') || rowData.field1 == $g('特殊人群')) {
                        $(this).datagrid('mergeCells', {
                            index: i,
                            field: 'value1',
                            rowspan: null,
                            colspan: 3
                        });
                    }
                }
            }
        }
    };

    PHA.Grid('gridPatInfo', dataGridOption);
}

function ReLoadUXAdmDetail(adm_opts){
	
	$("#gridPatInfo").datagrid("query",{
		Oeori: PHA_Oeori || '',
        AdmId: PHA_AdmId|| '',
        PrescNo: PHA_PrescNo|| ''
	});
}