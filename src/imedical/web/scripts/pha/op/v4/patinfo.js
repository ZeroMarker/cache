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
                title: '����',
                width: 100,
                align: 'right'
            },
            {
                field: 'value1',
                title: 'ֵ',
                width: 300,
                styler: function (value, row, index) {
                    if (row.field1 == $g('������Ⱥ')) {
                        if (value != '') {
                            return 'background:#d472ae;color:#fff;';
                        }
                    }
                }
            },
            {
                field: 'field2',
                title: '����',
                width: 100,
                align: 'right'
            },
            {
                field: 'value2',
                title: 'ֵ',
                width: 300,
                styler: function (value, row, index) {
                    if (row.field2 == $g('����״̬')) {
                        if ([$g('����'), $g('��Σ')].indexOf(value) >= 0) {
                            return 'background:#ee4f38;color:#fff;';
                        }
                    } else if (row.field2 == $g('��Ժʱ��')) {
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
                // �ϲ���
                for (var i = 0; i < rowsData.length; i++) {
                    var rowData = rowsData[i];
                    if (rowData.field1 == $g('���') || rowData.field1 == $g('������Ⱥ')) {
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