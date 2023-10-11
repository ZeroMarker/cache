/**
 * ����:	 סԺҩ�� - ��ҩͳ��
 * ��д��:	 yunhaibao
 * ��д����: 2020-11-12
 */
var PHA_HERB_QUERY_STAT = {
    WardFlag: session['LOGON.WARDID'] != '' ? 'Y' : 'N',
    Pid: tkMakeServerCall('PHA.COM.Base', 'NewPid')
};
PHAHERB_COM.KillTmpOnUnLoad('PHA.HERB.Query.Stat', PHA_HERB_QUERY_STAT.Pid);
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var ComPropData		// ��������
var AppPropData		// ģ������
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;

$(function () {
    InitDict();
    InitGridGrp();
    InitGridInci();
    InitGridOrder();
    InitSetDefVal();
    InitConditionFold();
    $('#btnClean').on('click', CleanHandler);
    $('#btnFind').on('click', QueryHandler);
    $('#btnFindInci').on('click', QueryInciHandler);
});

//�����۵�
function InitConditionFold()
{
	PHA.ToggleButton("moreorless", {
        buttonTextArr: [$g('����'), $g('����')],
        selectedText: $g('����'),
        onClick: function(oldText, newText){
        }	
    });	

    $("#moreorless").popover({
        trigger: 'click',	
        placement: 'auto',
        content: 'content',
        dismissible: false,
        width: 1000,
        padding: false,
        url: '#js-pha-moreorless'
    });
}

/**
 * ���ؼ�����ʼֵ
 * @method InitSetDefVal
 */
 function InitSetDefVal() {
	//��������
	// ��������
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
		}, false)

    $("#conStartDate").datebox("setValue", ComPropData.QueryStartDate);
    $("#conEndDate").datebox("setValue", ComPropData.QueryEndDate);
	$('#conStartTime').timespinner('setValue', ComPropData.QueryStartTime);
	$('#conEndTime').timespinner('setValue', ComPropData.QueryEndTime);
	
}

function InitDict() {
    var combWidth = 160;
    // ��ҩ����
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('IP').url,
        panelHeight: 'auto',
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', gLocId);
        }
    });
    // ���ܷ�ʽ
    PHA.ComboBox('conWay', {
        data: [
            { RowId: 'WARD', Description: $g('��������') },
            { RowId: 'DOCLOC', Description: $g('���һ���') },
            { RowId: 'PREFORM', Description: $g('��������') }
        ],
        panelHeight: 'auto',
        editable: false,
        width: combWidth,
        onSelect: function () {
            QueryHandler();
        }
    });
    $('#conWay').combobox('setValue', 'WARD');
    // ��������
    PHA.ComboBox('conAdmType', {
        width: combWidth,
        data: [
            { RowId: 'O', Description: $g('�ż���') },
            { RowId: 'I', Description: $g('סԺ') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
    });
    // ��ҩ����
    PHA.ComboBox('conWardLoc', {
        url: PHA_STORE.WardLoc().url,
        width: combWidth
    });
    // ��������
    PHA.ComboBox('conDocLoc', {
        url: PHA_STORE.DocLoc().url,
        width: combWidth
    });
    // ��ҩ��ʽ
    PHA.ComboBox('conCookType', {
        width: combWidth,
        url: PHA_HERB_STORE.CookType('', gLocId).url,
        panelHeight: 'auto'
    });
    // ����
    PHA.ComboBox('conForm', {
        width: combWidth,
        url: PHA_HERB_STORE.HMPreForm(gLocId).url
    });
    // �����ѱ�
    PHA.ComboBox('conBillType', {
        width: combWidth,
        url: PHA_STORE.PACAdmReason(gHospId).url
    });
    var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
        width: 238
    });
    PHA.LookUp('conInci', opts);

    PHA.ComboBox('conIntrType', {
        data: [
            { RowId: 'PH', Description: $g('סԺ��ҩ') },
            { RowId: 'YH', Description: $g('סԺ��ҩ') },
            { RowId: 'FH', Description: $g('���﷢ҩ') },
            { RowId: 'HH', Description: $g('������ҩ') }
        ],
        panelHeight: 'auto',
        multiple: true,
        width: combWidth,
        editable: false,
        onSelect: function () {}
    });
}
function InitGridGrp() {
    var columns = [
        [
            {
                field: 'grpID',
                title: 'grpID',
                width: 100,
                hidden: true
            },
            {
                field: 'itmChk',
                checkbox: true
            },
            {
                field: 'grpDesc',
                title: '����',
                width: 165,
                sortable: true
            },

            {
                field: 'dispAmt',
                title: '��ҩ���',
                width: 90,
                align: 'right',
                sortable: true
            },
            {
                field: 'retAmt',
                title: '��ҩ���',
                width: 90,
                align: 'right',
                sortable: true
            },
            {
                field: 'amt',
                title: '�ϼƽ��',
                width: 90,
                align: 'right',
                sortable: true
            },
            {
                field: 'grpStr',
                title: 'grpStr',
                width: 70,
                align: 'right',
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: true,
        showFooter: true,
        autoSizeColumn:true,
        toolbar: [],
        pageNumber: 1,
        pagination: false,
        singleSelect: false,
        onSortColumn: function () {
            QueryHandler();
        },
        queryOnSelect: false,
        loadFilter: PHA.LocalFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            $('#gridOrder').datagrid('clear');
            $('#gridInci').datagrid('clear');
        },
        onClickCell: function (rowIndex, field, value) {
            if (field !== 'itmChk') {
                $(this).datagrid('options').queryOnSelect = true;
            }
        },
        onSelect: SelectHandler,
        onUnselect: SelectHandler
    };
    PHA.Grid('gridGrp', dataGridOption);

    function SelectHandler(rowIndex, rowData) {
        if ($(this).datagrid('options').queryOnSelect == true) {
            $(this).datagrid('options').queryOnSelect = false;
            QueryInciHandler();
        }
    }
}
function InitGridInci() {
    var columns = [
        [
            {
                field: 'inci',
                title: 'inci',
                width: 100,
                hidden: true
            },
            {
                field: 'inciCode',
                title: 'ҩƷ����',
                width: 100,
                align: 'left',
                formatter: function (value, row, index) {
                    var inci = row.inci || '';
                    if (inci === '') {
                        return value;
                    }
                    return '<a class="pha-grid-a" onclick="QueryOrderHandler(' + inci + ')">' + value + '</a>';
                }
            },
            {
                field: 'inciDesc',
                title: 'ҩƷ����',
                width: 200,
                sortable: true,
                align: 'left'
            },
            {
                field: 'manfDesc',
                title: '������ҵ',
                width: 150,
                align: 'left'
            },
            {
                field: 'uomDesc',
                title: '��λ',
                width: 50,
                align: 'left'
            },
            {
                field: 'dispQty',
                title: '��ҩ����',
                width: 70,
                align: 'right'
            },
            {
                field: 'retQty',
                title: '��ҩ����',
                width: 70,
                align: 'right'
            },
            {
                field: 'qty',
                title: '�ϼ�����',
                width: 70,
                align: 'right',
                sortable: true
            },
            {
                field: 'dispAmt',
                title: '��ҩ���',
                width: 70,
                align: 'right',
                sortable: true
            },
            {
                field: 'retAmt',
                title: '��ҩ���',
                width: 70,
                align: 'right',
                sortable: true
            },
            {
                field: 'amt',
                title: '�ϼƽ��',
                width: 70,
                align: 'right'
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: true,
        showFooter: true,
        toolbar: [],
        pageSize: 100,
        pageNumber: 1,
        autoSizeColumn:true,
        onSortColumn: function () {
            QueryInciHandler();
        },
        loadFilter: PHAHERB_COM.LocalFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            // $('#gridOrder').datagrid('clear');
        },
        onSelect: function () {
            // QueryOrderHandler();
        }
    };
    PHA.Grid('gridInci', dataGridOption);
}

function InitGridOrder() {
    var columns = [
        [
            {
                field: 'docLocDesc',
                title: '��������',
                width: 150
            },
            {
                field: 'locDesc',
                title: '��ҩ����',
                width: 150
            },
            {
                field: 'bedNo',
                title: '����',
                width: 70
            },
            {
                field: 'patNo',
                title: '�ǼǺ�',
                width: 100,
                formatter: function (value, row, index) {
                    var qOpts = "{AdmId:'" + row.adm + "'}";
                    return '<a class="pha-grid-a" onclick="PHA_UX.AdmDetail({},' + qOpts + ')">' + value + '</a>';
                }
            },
            {
                field: 'patName',
                title: '����',
                width: 100
            },
            {
                field: 'dosage',
                title: '����',
                width: 100
            },
            {
                field: 'freqDesc',
                title: 'Ƶ��',
                width: 100
            },
            {
                field: 'instrucDesc',
                title: '�÷�',
                width: 100
            },
            {
                field: 'busiType',
                title: '����',
                width: 50,
                styler: function (value, row, index) {
                    if (value === 'PH' || value === 'FH') {
                        return 'background-color:#e3f7ff;color:#1278b8;';
                    } else if (value === 'YH' || value === 'HH') {
                        return 'background-color:#ffe3e3;color:#ff3d2c;';
                    }
                },
                formatter: function (value, row, index) {
                    return value === 'PH' || value === 'FH' ? '��ҩ' : '��ҩ';
                }
            },
            {
                field: 'qtyUom',
                title: '����',
                width: 75
            },
            {
                field: 'spAmt',
                title: '���',
                width: 75,
                align: 'right'
            },
            {
                field: 'oeore',
                title: 'ִ�м�¼ID',
                width: 100,
                formatter: function (value, row, index) {
	                var busiType = row.busiType;
	                if (busiType ===  'P' || busiType === 'Y'){
                    	var qOpts = "{oeore:'" + row.oeore + "'}";
                    	return '<a class="pha-grid-a" onclick="PHA_UX.TimeLine({},' + qOpts + ')">' + value + '</a>';
                	}else{
	                	return value
	                }
                }
            },
            {
                field: 'prescNo',
                title: '������',
                width: 120,
                align: 'center'
            },
            {
                field: 'oeoriDateTime',
                title: '����ʱ��',
                width: 155,
                align: 'center'
            },
            {
                field: 'nurSeeInfo',
                title: '��ʿ����ҽ����Ϣ',
                width: 250,
                tipWidth: 'auto'
            },
            {
                field: 'nurAuditInfo',
                title: '��ҩ�����Ϣ',
                width: 210
            },
            {
                field: 'phaInfo',
                title: '������ҩ��Ϣ',
                width: 250
            },
            {
                field: 'phaNo',
                title: 'ҵ�񵥺�',
                width: 250,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: false,
        pageNumber: 1,
        border: true,
        toolbar: null,
        pageSize: 100,
        pageNumber: 1,
        bodyCls: 'panel-body-gray',
        loadFilter: PHAHERB_COM.LocalFilter,
        onSortColumn: function () {
            QueryOrderHandler();
        },

        onLoadSuccess: function () {
            $(this).datagrid('loaded');
        }
    };
    PHA.Grid('gridOrder', dataGridOption);
}
function QueryHandler() {
    $('#gridGrp').datagrid('clearChecked');
    $('#gridGrp').datagrid('loading');
    setTimeout(Query, 100);
}
function Query() {
    var pJson = GetParamsJson();

    var ret = $.cm(
        {
            ClassName: 'PHA.HERB.Query.Stat',
            MethodName: 'Collect',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_HERB_QUERY_STAT.Pid,
            dataType: 'text'
        },
        false
    );

    var sort = $('#gridGrp').datagrid('options').sortName;
    var order = $('#gridGrp').datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.HERB.Query.Stat',
            QueryName: 'TotalGrpData',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_HERB_QUERY_STAT.Pid,
            rows: 9999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );

    var footer = $.cm(
        {
            ClassName: 'PHA.HERB.Query.Stat',
            MethodName: 'GetFooter',
            pid: PHA_HERB_QUERY_STAT.Pid,
            type: 'TotalGrpData'
        },
        false
    );
    rowsData.footer = footer;

    $('#gridGrp').datagrid('loadData', rowsData);
    $('#gridGrp').datagrid('getData').originalRows = rowsData.rows;
}

function QueryInciHandler() {
    $('#gridInci').datagrid('loading');
    setTimeout(QueryInci, 100);
}
function QueryInci() {
    var pJson = GetParamsJson();
    var grpIDArr = [];
    var chkRows = $('#gridGrp').datagrid('getChecked');
    for (var i = 0; i < chkRows.length; i++) {
        grpIDArr.push(chkRows[i].grpID);
    }
    pJson.grpID = grpIDArr.join(',');

    var sort = $('#gridInci').datagrid('options').sortName;
    var order = $('#gridInci').datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.HERB.Query.Stat',
            QueryName: 'TotalInciData',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_HERB_QUERY_STAT.Pid,
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );
    var footer = $.cm(
        {
            ClassName: 'PHA.HERB.Query.Stat',
            MethodName: 'GetFooter',
            pid: PHA_HERB_QUERY_STAT.Pid,
            type: 'TotalInciData'
        },
        false
    );
    rowsData.footer = footer;
    $('#gridInci').datagrid('loadData', rowsData);
}
function GetParamsJson() {
    return {
        startDate: $('#conStartDate').datebox('getValue') || '',
        endDate: $('#conEndDate').datebox('getValue') || '',
        startTime: $('#conStartTime').timespinner('getValue') || '',
        endTime: $('#conEndTime').timespinner('getValue') || '',
        phaLocId: $('#conPhaLoc').combobox('getValue') || '',
        admType: $('#conAdmType').combobox('getValue') || '',
        docLocId: $('#conDocLoc').combobox('getValue') || '',
        formId: $('#conForm').combobox('getValue') || '',
        statWay: $('#conWay').combobox('getValue') || '',
        wardLocId: $('#conWardLoc').combobox('getValue') || '',
        cookType: $('#conCookType').combobox('getValue') || '',
        intrType: $('#conIntrType').combobox('getValues').join(','),
        inci: $('#conInci').lookup('getValue') || '',
        billType: $('#conBillType').combobox('getValue') || ''   
        
    };
}
function QueryOrderHandler(inci) {
    var pJson = GetParamsJson();
    var grpStrArr = [];
    var chkRows = $('#gridGrp').datagrid('getChecked');
    for (var i = 0; i < chkRows.length; i++) {
        grpStrArr.push(chkRows[i].grpStr);
    }
    pJson.grpStr = grpStrArr.join(',');
    pJson.inci = inci;
    var sort = $('#gridOrder').datagrid('options').sortName;
    var order = $('#gridOrder').datagrid('options').sortOrder;
	
    var rowsData = $.cm(
        {
            ClassName: 'PHA.HERB.Query.Stat',
            QueryName: 'TotalOrderData',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_HERB_QUERY_STAT.Pid,
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );

    $('#gridOrder').datagrid('loadData', rowsData);
    $('#winOrder').window('open');
}

function CleanHandler() {
    InitSetDefVal();
    $('#conPhaLoc').combobox('clear');
    $('#conPhaLoc').combobox('select', session['LOGON.CTLOCID']);
    $('#conInci').lookup('clear');
    $('#conDispCat').combobox('clear');
    $('#conPoison').combobox('clear');
    $('#conAdmType').combobox('clear');
    $('#conWay').combobox('setValue', 'WARD');
    // uomType: $('#conUomType').combobox('getValue') || '',
    $('#conIntrType').combobox('clear');
    $('#conWardLoc').combobox('clear');
    $('#conForm').combobox('clear');
    $('#conCookType').combobox('clear');
    $('#conDocLoc').combobox('clear');
    $('#conBillType').combobox('clear');
    $('#gridGrp').datagrid('clear').datagrid('clearChecked');
    $('#gridInci').datagrid('clear');
    $('#gridOrder').datagrid('clear');
}
