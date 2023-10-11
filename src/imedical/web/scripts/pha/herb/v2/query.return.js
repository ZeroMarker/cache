/**
 * ����:	 ��ҩ�� - ��ҩ����ѯ
 * ��д��:	 MaYuqiang
 * ��д����: 2020-12-30
 */
var PHA_HERB_QUERY_RETURN = {
    WardFlag: session['LOGON.WARDID'] || '' !== '' ? 'Y' : 'N',
    Pid: tkMakeServerCall('PHA.COM.Base', 'NewPid')
};
var ComPropData		// ��������
var AppPropData		// ģ������
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;

$(function () {
    $('#conPatNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $(this).val(PHA_COM.FullPatNo($(this).val()));
        }
    });
    InitDict();
    InitGridRet();
    //InitGridInci();
    InitGridDetail();
    InitSetDefVal();
    InitConditionFold();
    $('#btnClean').on('click', CleanHandler);
    $('#btnPrint').on('click', PrintHandler);
    $('#btnFind').on('click', QueryHandler);
    $('#btnCancel').on('click', CancelReturn);

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
    // ��ҩ����
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('IP').url,
        panelHeight: 'auto',
        width: combWidth,
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
        }
    });
    // ��ҩ��ʽ
    PHA.ComboBox('conWay', {
        data: [
            { RowId: 'REQ', Description: $g('������ҩ') },
            { RowId: 'RET', Description: $g('ֱ����ҩ') }
        ],
        panelHeight: 'auto',
        width: combWidth,
        onSelect: function () {
            // QueryHandler();
        }
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
        url: PHA_HERB_STORE.CookType('', DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID).url,
        panelHeight: 'auto'
    });
    // ��������
    PHA.ComboBox('conForm', {
        width: combWidth,
        url: PHA_HERB_STORE.HMPreForm(gLocId).url
    });
    // ��������
    PHA.ComboBox('conAdmType', {
        width: combWidth,
        data: [
            { RowId: 'O,E', Description: $g('�ż���') },
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

    var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
        width: combWidth
    });
    PHA.LookUp('conInci', opts);

}
function InitGridRet() {
    var columns = [
        [
            {
                field: 'phbrId',
                title: 'phbrId',
                width: 100,
                hidden: true
            },
            {
                field: 'prescNo',
                title: '������',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'locDesc',
                title: 'ҩ��',
                width: 150,
                hidden: PHA_HERB_QUERY_RETURN.WardFlag === 'Y' ? false : true,
                align: 'left',
                sortable: true
            },
            {
                field: 'deptDesc',
                title: '���� / ����(����)',
                width: 150,
                align: 'left',
                sortable: true
            },
            {
                field: 'admType',
                title: '��������',
                width: 80,
                align: 'left',
                sortable: true
            },
            {
                field: 'retDate',
                title: '��ҩ����',
                width: 95,
                align: 'left',
                sortable: true
            },
            {
                field: 'retTime',
                title: '��ҩʱ��',
                width: 95,
                align: 'left',
                sortable: true
            },
            {
                field: 'userName',
                title: '��ҩ��',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'retSpAmt',
                title: '��ҩ���',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'cookType',
                title: '��ҩ��ʽ',
                width: 90,
                align: 'left',
                sortable: true
            },
            {
                field: 'prescForm',
                title: '��������',
                width: 90,
                align: 'left',
                sortable: true
            },
            {
                field: 'agreePrescFlag',
                title: 'Э����',
                width: 80,
                align: 'left',
                sortable: true
            },
            {
                field: '��ҩ���뵥Id',
                title: 'phbrrId',
                width: 90,
                sortable: true,
                hidden: true
            },
            {
                field: 'cancelRetUser',
                title: '������ҩ��',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'cancelRetDate',
                title: '����ʱ��',
                width: 200,
                align: 'left',
                sortable: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        //exportXls: false,
        columns: columns,
        fitColumns: true,
        //showFooter: true,
        toolbar: [],
        pageNumber: 1,
        pageSize: 100,
        autoSizeColumn: true,
        singleSelect: true,
        selectOnCheck: false,
        checkOnSelect: false,
        queryOnSelect: false,
        onSortColumn: function () {
            QueryHandler();
        },
        loadFilter: PHAHERB_COM.LocalFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            $('#gridDetail').datagrid('clear');
            $('#gridInci').datagrid('clear');
        },
        onSelect: SelectHandler,
        onUnselect: SelectHandler
    };
    PHA.Grid('gridRet', dataGridOption);

    function SelectHandler(rowIndex, rowData) {
        if ($(this).datagrid('options').queryOnSelect === false) {
            $(this).datagrid('options').queryOnSelect = true;
            $(this).datagrid('unselectAll');
            $(this).datagrid('selectRow', rowIndex);

            QueryDetailHandler(rowData.phbrId);
            QueryInciHandler(rowData.phbrId);

            $(this).datagrid('options').queryOnSelect = false;
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
                title: '����',
                width: 100
            },
            {
                field: 'inciDesc',
                title: '����',
                width: 300,
                sortable: true
            },
            {
                field: 'manfDesc',
                title: '������ҵ',
                width: 200
            },
            {
                field: 'uomDesc',
                title: '��λ',
                width: 100
            },
            {
                field: 'retQty',
                title: '��ҩ����',
                width: 100,
                align: 'right'
            },
            {
                field: 'sp',
                title: '�ۼ�',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'spAmt',
                title: '���',
                width: 100,
                align: 'right'
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: false,
        toolbar: [],
        pageSize: 100,
        pageNumber: 1,
        loadFilter: PHAHERB_COM.LoadFilter,
        onSortColumn: function () {
            QueryInciHandler();
        },
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
        }
    };
    PHA.Grid('gridInci', dataGridOption);
}

function InitGridDetail() {
    var columns = [
        [
            {
                field: 'phbriId',
                title: '��ҩ��ҩ�ӱ�ID',
                width: 100,
                hidden: true
            },
            {
                field: 'docLocDesc',
                title: '��������',
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
                width: 95
            },
            {
                field: 'inciCode',
                title: '����',
                width: 100,
                sortable: true
            },
            {
                field: 'inciDesc',
                title: '����',
                width: 300,
                sortable: true
            },
            {
                field: 'spec',
                title: '���',
                width: 100,
                hidden: true
            },
            {
                field: 'manfDesc',
                title: '������ҵ',
                width: 150
            },

            {
                field: 'uomDesc',
                title: '��λ',
                width: 75
            },

            {
                field: 'retQty',
                title: '��ҩ����',
                width: 75,
                align: 'right'
            },
            {
                field: 'reqQty',
                title: '��������',
                width: 75,
                align: 'right'
            },
            {
                field: 'dispQty',
                title: '��ҩ����',
                width: 75,
                align: 'right'
            },
            {
                field: 'sp',
                title: '�ۼ�',
                width: 100,
                align: 'right'
            },
            {
                field: 'spAmt',
                title: '���',
                width: 100,
                align: 'right'
            },
            {
                field: 'phbdicId',
                title: '��ҩ���ID'
            },
            {
                field: 'oeore',
                title: 'ִ�м�¼ID',
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: false,
        autoSizeColumn: true,
        pageNumber: 1,
        toolbar: [],
        pageSize: 100,
        pageNumber: 1,
        loadFilter: PHAHERB_COM.LocalFilter,
        onSortColumn: function () {
            QueryDetailHandler();
        },
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            /* */
            $('.pha-res-body .pha-tag').click(function (e) {
                var rowIndex = $(e.target).closest('tr').attr('datagrid-row-index') * 1;
                var rowData = $('#gridDetail').datagrid('getRows')[rowIndex]; 
            });
            
        }
    };
    PHA.Grid('gridDetail', dataGridOption);
}

function QueryHandler() {
	if($('#conPhaLoc').combobox('getValue') === ''){
        PHA.Popover({
            msg: '����ѡ����ҩҩ��',
            type: 'alert'
        });		
		return;		
	}
	
    $('#gridRet').datagrid('clearChecked');
    $('#gridRet').datagrid('loading');
    setTimeout(Query, 100);
}
function Query() {
    $('#gridRet').datagrid('clear');
    var pJson = GetParamsJson();
    var sort = $('#gridRet').datagrid('options').sortName;
    var order = $('#gridRet').datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.HERB.Query.Return',
            QueryName: 'HerbReturn',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );
    $('#gridRet').datagrid('loadData', rowsData);
}

function QueryInciHandler() {
    $('#gridInci').datagrid('loading');
    setTimeout(QueryInci, 100);
}
function QueryInci() {
    var gridSel = $('#gridRet').datagrid('getSelected') || '';
    if (gridSel === '') {
        $('#gridInci').datagrid('clear');
    }
    var pJson = GetParamsJson();
    pJson.phbrId = gridSel.phbrId;

    var sort = ""   //$('#gridInci').datagrid('options').sortName;
    var order = ""  //$('#gridInci').datagrid('options').sortOrder;

    var rowsData = $.cm(
        {
            ClassName: 'PHA.HERB.Query.Return',
            QueryName: 'HerbReturnInci',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );
    $('#gridInci').datagrid('loadData', rowsData);
}
function GetParamsJson() {
    return {
        startDate: $('#conStartDate').datebox('getValue') || '',
        endDate: $('#conEndDate').datebox('getValue') || '',
        startTime: $('#conStartTime').timespinner('getValue') || '',
        endTime: $('#conEndTime').timespinner('getValue') || '',
        phaLoc: $('#conPhaLoc').combobox('getValue') || '',
        docLoc: $('#conDocLoc').combobox('getValue') || '',
        patNo: $('#conPatNo').val() || '',
        prescNo: $('#conPrescNo').val() || '',
        wardLoc: $('#conWardLoc').combobox('getValue'),
        inci: $('#conInci').lookup('getValue') || '',
        admType: $('#conAdmType').combobox('getValue') || '',
        retWay: $('#conWay').combobox('getValue') || '',
        cookType: $('#conCookType').combobox('getValue') || '',
        agreePre: $('#conAgreePre').combobox('getValue') || '',
        formId: $('#conForm').combobox('getValue') || ''
    };
}

function QueryDetailHandler() {
    $('#gridDetail').datagrid('loading');
    setTimeout(QueryDetail, 100);
}

function QueryDetail() {
    
    var gridSel = $('#gridRet').datagrid('getSelected') || '';
    if (gridSel === '') {
        $('#gridDetail').datagrid('clear');
    }
    var pJson = GetParamsJson();
    pJson.phbrId = gridSel.phbrId;
    var sort = $('#gridRet').datagrid('options').sortName;
    var order = $('#gridRet').datagrid('options').sortOrder;

    var rowsData = $.cm(
        {
            ClassName: 'PHA.HERB.Query.Return',
            QueryName: 'HerbReturnDetail',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );
    $('#gridDetail').datagrid('loadData', rowsData);
}

function CleanHandler() {
    InitSetDefVal();
    $('#conPhaLoc').combobox('clear');
    $('#conPhaLoc').combobox('select', session['LOGON.CTLOCID']);
    $('#conInci').lookup('clear');
    $('#conWay').combobox('clear');
    $('#conAdmType').combobox('clear');
    $('#conCookType').combobox('clear');
    $('#conAgreePre').combobox('clear');
    $('#conForm').combobox('clear');
    $('#conDocLoc').combobox('clear');
    $('#conWardLoc').combobox('clear');
    $('#conRetNo').val('');
    $('#conReqNo').val('');
    $('#conPatNo').val('');
    $('#conPrescNo').val('');
    $('#gridRet').datagrid('clear').datagrid('clearChecked');
    $('#gridInci').datagrid('clear');
    $('#gridDetail').datagrid('clear');
}

function PrintHandler() {
    var gridSel = $('#gridRet').datagrid('getSelected') || '';
    if (gridSel === '') {
        PHA.Popover({
            msg: '����ѡ����Ҫ��ӡ����ҩ��',
            type: 'alert'
        });
        return;
    }
    var phbrId = gridSel.phbrId
    HERB_PRINTCOM.ReturnDoc(phbrId, '��');
}

/* ������ҩ */
function CancelReturn(){
    var gridSel = $('#gridRet').datagrid('getSelected') || '';
    if (gridSel == '') {
        PHA.Popover({
            msg: '����ѡ����Ҫ��������ҩ��',
            type: 'alert'
        });
        return;
    }
    var phbrId = gridSel.phbrId ;
    $.m({
		ClassName: "PHA.HERB.Return.Save",
		MethodName: "CancelReturn",
        phbrId: phbrId,
        userId: gUserID
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
        }
        else {
	        $.messager.alert('��ʾ', "�����ɹ�", 'success');
            Query();
			return; 
	    }
	});
	
}
