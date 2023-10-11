/**
 * 名称:	 草药房 - 退药单查询
 * 编写人:	 MaYuqiang
 * 编写日期: 2020-12-30
 */
var PHA_HERB_QUERY_RETURN = {
    WardFlag: session['LOGON.WARDID'] || '' !== '' ? 'Y' : 'N',
    Pid: tkMakeServerCall('PHA.COM.Base', 'NewPid')
};
var ComPropData		// 公共配置
var AppPropData		// 模块配置
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

//条件折叠
function InitConditionFold()
{
	PHA.ToggleButton("moreorless", {
        buttonTextArr: [$g('更多'), $g('隐藏')],
        selectedText: $g('更多'),
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
 * 给控件赋初始值
 * @method InitSetDefVal
 */
 function InitSetDefVal() {
	//界面配置
	// 公共设置
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
    // 退药科室
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('IP').url,
        panelHeight: 'auto',
        width: combWidth,
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
        }
    });
    // 退药方式
    PHA.ComboBox('conWay', {
        data: [
            { RowId: 'REQ', Description: $g('申请退药') },
            { RowId: 'RET', Description: $g('直接退药') }
        ],
        panelHeight: 'auto',
        width: combWidth,
        onSelect: function () {
            // QueryHandler();
        }
    });
    // 领药病区
    PHA.ComboBox('conWardLoc', {
        url: PHA_STORE.WardLoc().url,
        width: combWidth
    });
    // 开单科室
    PHA.ComboBox('conDocLoc', {
        url: PHA_STORE.DocLoc().url,
        width: combWidth
    });
    // 煎药方式
    PHA.ComboBox('conCookType', {
        width: combWidth,
        url: PHA_HERB_STORE.CookType('', DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID).url,
        panelHeight: 'auto'
    });
    // 处方剂型
    PHA.ComboBox('conForm', {
        width: combWidth,
        url: PHA_HERB_STORE.HMPreForm(gLocId).url
    });
    // 就诊类型
    PHA.ComboBox('conAdmType', {
        width: combWidth,
        data: [
            { RowId: 'O,E', Description: $g('门急诊') },
            { RowId: 'I', Description: $g('住院') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
    });
    // 协定方
    PHA.ComboBox('conAgreePre', {
        width: combWidth,
        data: [
            { RowId: 'equal', Description: $g('仅有') },
            { RowId: 'not', Description: $g('不含') }
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
                title: '处方号',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'locDesc',
                title: '药房',
                width: 150,
                hidden: PHA_HERB_QUERY_RETURN.WardFlag === 'Y' ? false : true,
                align: 'left',
                sortable: true
            },
            {
                field: 'deptDesc',
                title: '科室 / 病区(床号)',
                width: 150,
                align: 'left',
                sortable: true
            },
            {
                field: 'admType',
                title: '就诊类型',
                width: 80,
                align: 'left',
                sortable: true
            },
            {
                field: 'retDate',
                title: '退药日期',
                width: 95,
                align: 'left',
                sortable: true
            },
            {
                field: 'retTime',
                title: '退药时间',
                width: 95,
                align: 'left',
                sortable: true
            },
            {
                field: 'userName',
                title: '退药人',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'retSpAmt',
                title: '退药金额',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'cookType',
                title: '煎药方式',
                width: 90,
                align: 'left',
                sortable: true
            },
            {
                field: 'prescForm',
                title: '处方剂型',
                width: 90,
                align: 'left',
                sortable: true
            },
            {
                field: 'agreePrescFlag',
                title: '协定方',
                width: 80,
                align: 'left',
                sortable: true
            },
            {
                field: '退药申请单Id',
                title: 'phbrrId',
                width: 90,
                sortable: true,
                hidden: true
            },
            {
                field: 'cancelRetUser',
                title: '撤消退药人',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'cancelRetDate',
                title: '撤消时间',
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
                title: '代码',
                width: 100
            },
            {
                field: 'inciDesc',
                title: '名称',
                width: 300,
                sortable: true
            },
            {
                field: 'manfDesc',
                title: '生产企业',
                width: 200
            },
            {
                field: 'uomDesc',
                title: '单位',
                width: 100
            },
            {
                field: 'retQty',
                title: '退药数量',
                width: 100,
                align: 'right'
            },
            {
                field: 'sp',
                title: '售价',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'spAmt',
                title: '金额',
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
                title: '草药退药子表ID',
                width: 100,
                hidden: true
            },
            {
                field: 'docLocDesc',
                title: '开单科室',
                width: 150
            },
            {
                field: 'bedNo',
                title: '床号',
                width: 70
            },
            {
                field: 'patNo',
                title: '登记号',
                width: 100,
                formatter: function (value, row, index) {
                    var qOpts = "{AdmId:'" + row.adm + "'}";
                    return '<a class="pha-grid-a" onclick="PHA_UX.AdmDetail({},' + qOpts + ')">' + value + '</a>';
                }
            },
            {
                field: 'patName',
                title: '姓名',
                width: 100
            },
            {
                field: 'doseDateTime',
                title: '用药时间',
                width: 95
            },
            {
                field: 'inciCode',
                title: '代码',
                width: 100,
                sortable: true
            },
            {
                field: 'inciDesc',
                title: '名称',
                width: 300,
                sortable: true
            },
            {
                field: 'spec',
                title: '规格',
                width: 100,
                hidden: true
            },
            {
                field: 'manfDesc',
                title: '生产企业',
                width: 150
            },

            {
                field: 'uomDesc',
                title: '单位',
                width: 75
            },

            {
                field: 'retQty',
                title: '退药数量',
                width: 75,
                align: 'right'
            },
            {
                field: 'reqQty',
                title: '申请数量',
                width: 75,
                align: 'right'
            },
            {
                field: 'dispQty',
                title: '发药数量',
                width: 75,
                align: 'right'
            },
            {
                field: 'sp',
                title: '售价',
                width: 100,
                align: 'right'
            },
            {
                field: 'spAmt',
                title: '金额',
                width: 100,
                align: 'right'
            },
            {
                field: 'phbdicId',
                title: '发药孙表ID'
            },
            {
                field: 'oeore',
                title: '执行记录ID',
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
            msg: '请先选择退药药房',
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
            msg: '请先选中需要打印的退药单',
            type: 'alert'
        });
        return;
    }
    var phbrId = gridSel.phbrId
    HERB_PRINTCOM.ReturnDoc(phbrId, '补');
}

/* 撤消退药 */
function CancelReturn(){
    var gridSel = $('#gridRet').datagrid('getSelected') || '';
    if (gridSel == '') {
        PHA.Popover({
            msg: '请先选中需要撤消的退药单',
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
			$.messager.alert('提示', retArr[1], 'warning');
			return;
        }
        else {
	        $.messager.alert('提示', "撤消成功", 'success');
            Query();
			return; 
	    }
	});
	
}
