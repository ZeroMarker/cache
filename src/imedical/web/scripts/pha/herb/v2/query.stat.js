/**
 * 名称:	 住院药房 - 发药统计
 * 编写人:	 yunhaibao
 * 编写日期: 2020-11-12
 */
var PHA_HERB_QUERY_STAT = {
    WardFlag: session['LOGON.WARDID'] != '' ? 'Y' : 'N',
    Pid: tkMakeServerCall('PHA.COM.Base', 'NewPid')
};
PHAHERB_COM.KillTmpOnUnLoad('PHA.HERB.Query.Stat', PHA_HERB_QUERY_STAT.Pid);
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var ComPropData		// 公共配置
var AppPropData		// 模块配置
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
        width: 1000,
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
    // 发药科室
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('IP').url,
        panelHeight: 'auto',
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', gLocId);
        }
    });
    // 汇总方式
    PHA.ComboBox('conWay', {
        data: [
            { RowId: 'WARD', Description: $g('病区汇总') },
            { RowId: 'DOCLOC', Description: $g('科室汇总') },
            { RowId: 'PREFORM', Description: $g('处方剂型') }
        ],
        panelHeight: 'auto',
        editable: false,
        width: combWidth,
        onSelect: function () {
            QueryHandler();
        }
    });
    $('#conWay').combobox('setValue', 'WARD');
    // 就诊类型
    PHA.ComboBox('conAdmType', {
        width: combWidth,
        data: [
            { RowId: 'O', Description: $g('门急诊') },
            { RowId: 'I', Description: $g('住院') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
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
        url: PHA_HERB_STORE.CookType('', gLocId).url,
        panelHeight: 'auto'
    });
    // 剂型
    PHA.ComboBox('conForm', {
        width: combWidth,
        url: PHA_HERB_STORE.HMPreForm(gLocId).url
    });
    // 处方费别
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
            { RowId: 'PH', Description: $g('住院发药') },
            { RowId: 'YH', Description: $g('住院退药') },
            { RowId: 'FH', Description: $g('门诊发药') },
            { RowId: 'HH', Description: $g('门诊退药') }
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
                title: '名称',
                width: 165,
                sortable: true
            },

            {
                field: 'dispAmt',
                title: '发药金额',
                width: 90,
                align: 'right',
                sortable: true
            },
            {
                field: 'retAmt',
                title: '退药金额',
                width: 90,
                align: 'right',
                sortable: true
            },
            {
                field: 'amt',
                title: '合计金额',
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
                title: '药品代码',
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
                title: '药品名称',
                width: 200,
                sortable: true,
                align: 'left'
            },
            {
                field: 'manfDesc',
                title: '生产企业',
                width: 150,
                align: 'left'
            },
            {
                field: 'uomDesc',
                title: '单位',
                width: 50,
                align: 'left'
            },
            {
                field: 'dispQty',
                title: '发药数量',
                width: 70,
                align: 'right'
            },
            {
                field: 'retQty',
                title: '退药数量',
                width: 70,
                align: 'right'
            },
            {
                field: 'qty',
                title: '合计数量',
                width: 70,
                align: 'right',
                sortable: true
            },
            {
                field: 'dispAmt',
                title: '发药金额',
                width: 70,
                align: 'right',
                sortable: true
            },
            {
                field: 'retAmt',
                title: '退药金额',
                width: 70,
                align: 'right',
                sortable: true
            },
            {
                field: 'amt',
                title: '合计金额',
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
                title: '开单科室',
                width: 150
            },
            {
                field: 'locDesc',
                title: '领药科室',
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
                field: 'dosage',
                title: '剂量',
                width: 100
            },
            {
                field: 'freqDesc',
                title: '频次',
                width: 100
            },
            {
                field: 'instrucDesc',
                title: '用法',
                width: 100
            },
            {
                field: 'busiType',
                title: '类型',
                width: 50,
                styler: function (value, row, index) {
                    if (value === 'PH' || value === 'FH') {
                        return 'background-color:#e3f7ff;color:#1278b8;';
                    } else if (value === 'YH' || value === 'HH') {
                        return 'background-color:#ffe3e3;color:#ff3d2c;';
                    }
                },
                formatter: function (value, row, index) {
                    return value === 'PH' || value === 'FH' ? '发药' : '退药';
                }
            },
            {
                field: 'qtyUom',
                title: '数量',
                width: 75
            },
            {
                field: 'spAmt',
                title: '金额',
                width: 75,
                align: 'right'
            },
            {
                field: 'oeore',
                title: '执行记录ID',
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
                title: '处方号',
                width: 120,
                align: 'center'
            },
            {
                field: 'oeoriDateTime',
                title: '开单时间',
                width: 155,
                align: 'center'
            },
            {
                field: 'nurSeeInfo',
                title: '护士处理医嘱信息',
                width: 250,
                tipWidth: 'auto'
            },
            {
                field: 'nurAuditInfo',
                title: '领药审核信息',
                width: 210
            },
            {
                field: 'phaInfo',
                title: '发、退药信息',
                width: 250
            },
            {
                field: 'phaNo',
                title: '业务单号',
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
