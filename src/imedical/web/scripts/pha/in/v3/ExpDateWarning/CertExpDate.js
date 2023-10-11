/**
 * 模块:     企业证件效期预警
 * 编写日期: 2021-12-24
 * 编写人:   yangsj
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
		title: PHA_COM.IsTabsMenu() !== true ? '企业证件效期预警' : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-template',
		bodyCls: 'panel-body-gray',
		fit: true
	});
}

function InitDict(){
	/* 企业类型 */
	PHA.ComboBox('EnterpType', {
        panelHeight: 'auto',
        editable: false,
        width: 100,
        data: [
            {
                RowId: "ALL",
                Description: $g('全部'),
            },
            {
                RowId: "Vendor",
                Description: $g('经营企业'),
            },
            {
                RowId: "Manf",
                Description: $g('生产企业'),
            },
        ]
    });
	$('#EnterpType').combobox('setValue', "ALL");
	
	/* 经营企业 */
    PHA.ComboBox('Vendor', {
        width: cmbWidth,
        url: PHA_STORE.APCVendor().url,
    });
    
    /* 生产企业  */
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
            { field: 'OrgType', 	title: '企业类型', 	width: 120, 		align: 'left',
            	formatter: function (value, row, index) {
                    if (value == 'Vendor') {
                        return $g("经营企业");
                    } else if (value == 'Manf'){
                        return $g("生产企业");
                    }
                },
            },
            { field: 'OrgName', 	title: '企业名称', 	width: 200, 		align: 'left'	},
            { field: 'Group',		title: '组',		width: 40,			align: 'center',	formatter: PIVAS.Grid.Formatter.OeoriSign},
            { field: 'CertName', 	title: '证件类型', 	width: 200, 		align: 'left'	},
            { field: 'CertText', 	title: '证件编号', 	width: 200, 		align: 'left'	},
            { field: 'DateToDesc', 	title: '有效期', 	width: 120, 		align: 'left'	},
            { field: 'DifDay', 		title: '效期天数', 	width: 100, 		align: 'right'	,	styler:DaysStyler},
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

