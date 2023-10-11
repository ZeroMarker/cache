/**
 * ģ��:     ��ҵ֤��Ч��Ԥ��
 * ��д����: 2021-12-24
 * ��д��:   yangsj
 */
 var cmbWidth = "250";
 
$(function () {
	SetPanel();
    InitDict();
    InitGrid();
    DefultQuery();
});

function SetPanel(){
	$('#panelCertExpDate').panel({
		title: PHA_COM.IsTabsMenu() !== true ? '��ҵ֤��Ч��Ԥ��' : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-template',
		bodyCls: 'panel-body-gray',
		fit: true
	});
}

function InitDict(){
	/* ��ҵ���� */
	PHA.ComboBox('EnterpType', {
        panelHeight: 'auto',
        editable: false,
        width: 100,
        data: [
            {
                RowId: "ALL",
                Description: $g('ȫ��'),
            },
            {
                RowId: "Vendor",
                Description: $g('��Ӫ��ҵ'),
            },
            {
                RowId: "Manf",
                Description: $g('������ҵ'),
            },
        ]
    });
	$('#EnterpType').combobox('setValue', "ALL");
	
	/* ��Ӫ��ҵ */
    PHA.ComboBox('Vendor', {
        width: cmbWidth,
        url: PHA_STORE.APCVendor().url,
    });
    
    /* ������ҵ  */
    PHA.ComboBox('Manf', {
        width: cmbWidth,
        url: PHA_STORE.PHManufacturer().url,
    });
}

function InitGrid(){
	InitGridEIC();
}

function InitGridEIC(){
	var columns = [
        [
            // OrgId, OrgType, OrgName, CertName, DateToDesc, DifDay
            { field: 'OrgId', 		title: 'OrgId', 	hidden: true },
            { field: 'OrgType', 	title: '��ҵ����', 	width: 120, 		align: 'left',
            	formatter: function (value, row, index) {
                    if (value == 'Vendor') {
                        return $g("��Ӫ��ҵ");
                    } else if (value == 'Manf'){
                        return $g("������ҵ");
                    }
                },
            },
            { field: 'OrgName', 	title: '��ҵ����', 	width: 200, 		align: 'left'	},
            { field: 'Group',		title: '��',		width: 40,			align: 'center',	formatter: PIVAS.Grid.Formatter.OeoriSign},
            { field: 'CertName', 	title: '֤������', 	width: 200, 		align: 'left'	},
            { field: 'CertText', 	title: '֤�����', 	width: 200, 		align: 'left'	},
            { field: 'DateToDesc', 	title: '��Ч��', 	width: 120, 		align: 'left'	},
            { field: 'DifDay', 		title: 'Ч������', 	width: 100, 		align: 'right'	,	styler:DaysStyler},
        ]
    ];
    
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName	: 'PHA.IN.Cert.Query',
            QueryName	: 'QueryCertExpDate',
            ParamsJson  : "{}",
            HospId 		: ""
        },
        gridSave	: false,
        pagination	: false,
        //idField	: 'EICId',
        fitColumns	: false,
        columns		: columns,
        toolbar		: '#CertExpDateBar',
        exportXls	: false,
        onClickRow	: function (rowIndex, rowData) {},
	    onDblClickRow: function (rowIndex, rowData) {Update()},
	    onLoadSuccess: function (data) {},
    };
    PHA.Grid('gridCertExpDate', dataGridOption);
}

function DaysStyler(value, row, index)
{
	var colorStyle = ""
    if (value <= 0) colorStyle = 'background:#ee4f38;color:white;';
    else if (value < 30) colorStyle = 'background:#f1c516;color:white;';
    else colorStyle = 'background:white;color:black;';
    
    return colorStyle;
}

function Query(){
	CleanGridCert();
	var ParamsJson = PHA.DomData('#CertExpDateBar', {
        doType: 'query',
        retType: 'Json'
    });
	$('#gridCertExpDate').datagrid('query', {
		ParamsJson : JSON.stringify(ParamsJson[0]),
		HospId 	   : PHA_COM.Session.HOSPID
    });
}

function CleanGridCert()
{
	$('#gridCertExpDate').datagrid('clearSelections');   
    $('#gridCertExpDate').datagrid('clear');
}

function DefultQuery()
{
	$('#Days').val(30);
	Query();
}

