/**
 * ����:	 ��ҩ��-����ҩ�ۺϲ�ѯ
 * ��д��:	 MaYuqiang
 * ��д����: 2020-12-28
 */
var PHA_HERB_QUERY_GENERALLY = {
    WardFlag: session['LOGON.WARDID'] != '' ? 'Y' : 'N',
    Pid: tkMakeServerCall('PHA.COM.Base', 'NewPid')
};
PHAHERB_COM.KillTmpOnUnLoad('PHA.HERB.Query.Generally', PHA_HERB_QUERY_GENERALLY.Pid);
var ComPropData		// ��������
var AppPropData		// ģ������
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;

$(function () {
    InitDict();
    InitGridInci();
    InitGridOrder();
    InitSetDefVal();
    InitConditionFold();
    /* */
    $('#btnFind').on('click', QueryHandler);
    $('#btnPrint').on('click', PrintHandler);
    $('#btnClean').on('click', CleanHandler);
    $('#conPatNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
	        if ($(this).val() != ""){
            	$(this).val(PHA_COM.FullPatNo($(this).val()));
	        }
        }
    });
    
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
        width: 1050,
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
    
    PHA.ComboBox('conPhaLoc', {
        width: combWidth,
        url: PHA_STORE.Pharmacy('').url,
        panelHeight: 'auto',
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
        }
    });
    PHA.ComboBox('conPhaUser', {
        width: combWidth,
        url: PHA_STORE.SSUser().url
    });
    PHA.ComboBox('conCookType', {
        width: combWidth,
        url: PHA_HERB_STORE.CookType('', DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID).url,
        panelHeight: 'auto'
    });
    PHA.ComboBox('conOut', {
        data: [
            { RowId: 'equal', Description: $g('����') },
            { RowId: 'not', Description: $g('����') }
        ],
        width: combWidth,
        panelHeight: 'auto',
        onSelect: function () {}
    });
    PHA.ComboBox('conWardLoc', {
        width: combWidth,
        url: PHA_STORE.WardLoc().url
    });
    PHA.ComboBox('conDocLoc', {
        width: combWidth,
        url: PHA_STORE.DocLoc().url
    });
    PHA.ComboBox('conForm', {
        width: combWidth,
        url: PHA_STORE.PHCForm().url
    });
    
    var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
        width: combWidth
    });
    PHA.LookUp('conInci', opts);
    /*
    PHA.TriggerBox('conPhcCat', {
        handler: function (data) {
            PHA_UX.DHCPHCCat('conPhcCat', {}, function (data) {
                $('#conPhcCat').triggerbox('setValue', data.phcCatDesc);
                $('#conPhcCat').triggerbox('setValueId', data.phcCatId);
            });
        }
    });
    */
    PHA.ComboBox('conIntrType', {
        width: combWidth,
        data: [
            { RowId: 'FH', Description: $g('���﷢ҩ') },
            { RowId: 'HH', Description: $g('������ҩ') },
            { RowId: 'PH', Description: $g('סԺ��ҩ') },
            { RowId: 'YH', Description: $g('סԺ��ҩ') }
        ],
        panelHeight: 'auto',        
        onSelect: function () {}
    });
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
    // Э����
    PHA.ComboBox('conAgreePre', {
        width: combWidth,
        data: [
            { RowId: 'equal', Description: $g('����') },
            { RowId: 'not', Description: $g('����') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
    });
    
    PHA.ComboBox('conUomType', {
        width: combWidth,
        data: [
            { RowId: 'bUom', Description: $g('������λ����') },
            { RowId: 'pUom', Description: $g('��ⵥλ����') },
            { RowId: 'pbUomDesc', Description: $g('��������λ') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
    });
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
                width: 80
            },
            {
                field: 'inciDesc',
                title: 'ҩƷ����',
                width: 150,
                sortable: true
            },
            {
                field: 'spec',
                title: '���',
                width: 80
            },
            {
                field: 'manfDesc',
                title: '������ҵ',
                width: 150
            },
            {
                field: 'goodName',
                title: '��Ʒ��',
                width: 100,
                hidden: true
            },
            {
                field: 'uomDesc',
                title: '��λ',
                width: 50
            },
            {
                field: 'qty',
                title: '�ϼ�����',
                width: 60,
                align: 'right',
                sortable: true
            },
            {
                field: 'amt',
                title: '�ϼƽ��',
                width: 70,
                align: 'right'
            },
            {
                field: 'opDispQty',
                title: '���﷢ҩ����',
                width: 80,
                align: 'right'
            },
            {
                field: 'opDispAmt',
                title: '���﷢ҩ���',
                width: 80,
                align: 'right'
            },{
                field: 'ipDispQty',
                title: 'סԺ��ҩ����',
                width: 80,
                align: 'right'
            },{
                field: 'ipDispAmt',
                title: 'סԺ��ҩ���',
                width: 80,
                align: 'right'
            },
            {
                field: 'opRetQty',
                title: '������ҩ����',
                width: 80,
                align: 'right'
            },
            {
                field: 'opRetAmt',
                title: '������ҩ���',
                width: 80,
                align: 'right'
            },{
                field: 'ipRetQty',
                title: 'סԺ��ҩ����',
                width: 80,
                align: 'right'
            },
            {
                field: 'ipRetAmt',
                title: 'סԺ��ҩ���',
                width: 80,
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
        pageNumber: 1,
        pageSize: 100,
        onSortColumn: function () {
             QueryHandler();
        },
        loadFilter: PHAHERB_COM.LocalFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            $('#gridOrder').datagrid('clear');
        },
        onSelect: function () {
            QueryOrderHandler();
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
                field: 'doseDateTime',
                title: '��ҩʱ��',
                width: 95,
                align: 'center'
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
                width: 80,
                styler: function (value, row, index) {
                    if (value === 'PH') {
                        return 'background-color:#FFB300;color:#FFFFFF;';
                    } else if (value === 'YH') {
                        return 'background-color:#F68300;color:#FFFFFF;';
                    } else if (value === 'FH') {
                        return 'background-color:#FF9898;color:#FFFFFF;';
                    } else if (value === 'HH') {
                        return 'background-color:#FF3D3D;color:#FFFFFF;';
                    }
                },
                formatter: function (value, row, index) {
                     switch(value) {
                            case 'PH' : 
                                return 'סԺ��ҩ'
                            case 'YH' : 
                                return 'סԺ��ҩ'
                            case 'FH' : 
                                return '���﷢ҩ'
                            case 'HH' : 
                                return '������ҩ'
                        }
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
                align: 'right',
                width: 75
            },
            {
                field: 'oeore',
                title: 'ִ�м�¼ID',
                formatter: function (value, row, index) {
                    var qOpts = "{oeore:'" + row.oeore + "'}";
                    //return '<a class="pha-grid-a" onclick="PHA_UX.TimeLine({},' + qOpts + ')">' + value + '</a>';
                },
                hidden: true
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
                title: '��ʿ����ҽ����Ϣ'
            },
            {
                field: 'nurAuditInfo',
                title: '��ҩ�����Ϣ'
            },
            {
                field: 'phaInfo',
                title: '������ҩ��Ϣ'
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: false,
        toolbar: [],
        pageNumber: 1,
        pageSize: 100,
        autoSizeColumn: true,
        onSortColumn: function () {
             QueryOrderHandler();
        },
        loadFilter: PHAHERB_COM.LocalFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
        }
    };
    PHA.Grid('gridOrder', dataGridOption);
}

function QueryHandler() {
    $('#gridInci').datagrid('loading');
    setTimeout(Query, 100);
}
function Query() {
    var pJson = GetParamsJson();
    var ret = $.cm(
        {
            ClassName: 'PHA.HERB.Query.Generally',
            MethodName: 'Collect',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_HERB_QUERY_GENERALLY.Pid,
            dataType: 'text'
        },
        false
    );

    var sort = $('#gridInci').datagrid('options').sortName;
    var order = $('#gridInci').datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.HERB.Query.Generally',
            QueryName: 'TotalInciData',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_HERB_QUERY_GENERALLY.Pid,
            rows: 9999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );

    var footer = $.cm(
        {
            ClassName: 'PHA.HERB.Query.Generally',
            MethodName: 'GetFooter',
            pid: PHA_HERB_QUERY_GENERALLY.Pid
        },
        false
    );
    rowsData.footer = footer;

    $('#gridInci').datagrid('loadData', rowsData);
}

function QueryOrderHandler() {
    $('#gridOrder').datagrid('loading');
    setTimeout(QueryOrder, 100);
}
function QueryOrder() {
    var pJson = GetParamsJson();
    pJson.inci = $('#gridInci').datagrid('getSelected').inci;
    var sort = $('#gridOrder').datagrid('options').sortName;
    var order = $('#gridOrder').datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.HERB.Query.Generally',
            QueryName: 'TotalOrderData',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_HERB_QUERY_GENERALLY.Pid,
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );
    $('#gridOrder').datagrid('loadData', rowsData);
}
function GetParamsJson() {
    return {
        startDate: $('#conStartDate').datebox('getValue') || '',
        endDate: $('#conEndDate').datebox('getValue') || '',
        startTime: $('#conStartTime').timespinner('getValue') || '',
        endTime: $('#conEndTime').timespinner('getValue') || '',
        phaLoc: $('#conPhaLoc').combobox('getValue') || '',
        wardLoc: $('#conWardLoc').combobox('getValue') || '',
        docLoc: $('#conDocLoc').combobox('getValue') || '',
        phaUser: $('#conPhaUser').combobox('getValue') || '',
        cookType: $('#conCookType').combobox('getValue') || '',
        inci: $('#conInci').lookup('getValue') || '',
        prescNo: $('#conPrescNo').val() || '',
        patNo: $('#conPatNo').val().trim(),     
        phcCat: "",	//$('#conPhcCat').triggerbox('getValue') || '',
        phcForm: $('#conForm').combobox('getValue') || '',
        intrType: $('#conIntrType').combobox('getValue') || '',
        outFlag: $('#conOut').combobox('getValue') || '',
        agreePre:$('#conAgreePre').combobox('getValue') || '' ,
        admType:$('#conAdmType').combobox('getValue') || '',
        uomType: $('#conUomType').combobox('getValue') || ''
    };
}

function CleanHandler() {
    InitSetDefVal();
    $('#conPhaLoc').combobox('select', session['LOGON.CTLOCID']);
    $('#conWardLoc').combobox('clear');
    $('#conDocLoc').combobox('clear');
    $('#conPhaUser').combobox('clear');
    $('#conCookType').combobox('clear');
    $('#conInci').lookup('clear');
    $('#gridInci').datagrid('clear');
    $('#conPrescNo').val('');
    $('#conPatNo').val(''), $('#conPhaNo').val('');
    //$('#conPhcCat').triggerbox('setValue', '');
    $('#conForm').combobox('clear');
    $('#conIntrType').combobox('clear');
    $('#conOut').combobox('clear');
    $('#conUomType').combobox('clear');
    $('#conAgreePre').combobox('clear');
    $('#conAdmType').combobox('clear');
    
}
function PrintHandler() {
    if ($('#gridInci').datagrid('getData').rows.length === 0) {
        PHA.Popover({
            msg: '���Ȳ�ѯ���ݣ� �ٽ��д�ӡ',
            type: 'alert'
        });
        return;
    }
    //��ȡ��������

    var para = {
        title: session['LOGON.HOSPDESC'] + '��ҩ�ۺϲ�ѯͳ��',
        countDate: $('#conStartDate').datebox('getValue') + '��' + $('#conEndDate').datebox('getValue'),
        printDate: PHA_UTIL.GetTime('', 'Y'),
        phLocDesc: $('#conPhaLoc').combobox('getText'),
        wardDesc: $('#conWardLoc').combobox('getText')
    };

    var list = JSON.parse(JSON.stringify($('#gridInci').datagrid('getData').originalRows));
    // ���Ӻϼ�
    var footer = JSON.parse(JSON.stringify($('#gridInci').datagrid('getData').footer[0]));
    footer.inciDesc = '�ϼ�';
    list.push(footer);
    PRINTCOM.XML({
        printBy: 'lodop',
        XMLTemplate: 'PHADispQueryGenerally',
        data: {
            Para: para,
            List: list
        },
        preview: false,
        listBorder: { style: 2, startX: 1, endX: 195 },
        page: {
            rows: 30,
            x: 185,
            y: 2,
            fontname: '����',
            fontbold: 'true',
            fontsize: '12',
            format: 'ҳ�룺{1}/{2}'
        }
    });
    
}

 /*  */
