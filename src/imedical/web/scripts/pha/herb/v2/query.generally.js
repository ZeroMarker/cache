/**
 * 名称:	 草药房-发退药综合查询
 * 编写人:	 MaYuqiang
 * 编写日期: 2020-12-28
 */
var PHA_HERB_QUERY_GENERALLY = {
    WardFlag: session['LOGON.WARDID'] != '' ? 'Y' : 'N',
    Pid: tkMakeServerCall('PHA.COM.Base', 'NewPid')
};
PHAHERB_COM.KillTmpOnUnLoad('PHA.HERB.Query.Generally', PHA_HERB_QUERY_GENERALLY.Pid);
var ComPropData		// 公共配置
var AppPropData		// 模块配置
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
            { RowId: 'equal', Description: $g('仅有') },
            { RowId: 'not', Description: $g('不含') }
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
            { RowId: 'FH', Description: $g('门诊发药') },
            { RowId: 'HH', Description: $g('门诊退药') },
            { RowId: 'PH', Description: $g('住院发药') },
            { RowId: 'YH', Description: $g('住院退药') }
        ],
        panelHeight: 'auto',        
        onSelect: function () {}
    });
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
    
    PHA.ComboBox('conUomType', {
        width: combWidth,
        data: [
            { RowId: 'bUom', Description: $g('基本单位数量') },
            { RowId: 'pUom', Description: $g('入库单位数量') },
            { RowId: 'pbUomDesc', Description: $g('数量带单位') }
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
                title: '药品代码',
                width: 80
            },
            {
                field: 'inciDesc',
                title: '药品名称',
                width: 150,
                sortable: true
            },
            {
                field: 'spec',
                title: '规格',
                width: 80
            },
            {
                field: 'manfDesc',
                title: '生产企业',
                width: 150
            },
            {
                field: 'goodName',
                title: '商品名',
                width: 100,
                hidden: true
            },
            {
                field: 'uomDesc',
                title: '单位',
                width: 50
            },
            {
                field: 'qty',
                title: '合计数量',
                width: 60,
                align: 'right',
                sortable: true
            },
            {
                field: 'amt',
                title: '合计金额',
                width: 70,
                align: 'right'
            },
            {
                field: 'opDispQty',
                title: '门诊发药数量',
                width: 80,
                align: 'right'
            },
            {
                field: 'opDispAmt',
                title: '门诊发药金额',
                width: 80,
                align: 'right'
            },{
                field: 'ipDispQty',
                title: '住院发药数量',
                width: 80,
                align: 'right'
            },{
                field: 'ipDispAmt',
                title: '住院发药金额',
                width: 80,
                align: 'right'
            },
            {
                field: 'opRetQty',
                title: '门诊退药数量',
                width: 80,
                align: 'right'
            },
            {
                field: 'opRetAmt',
                title: '门诊退药金额',
                width: 80,
                align: 'right'
            },{
                field: 'ipRetQty',
                title: '住院退药数量',
                width: 80,
                align: 'right'
            },
            {
                field: 'ipRetAmt',
                title: '住院退药金额',
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
                field: 'doseDateTime',
                title: '用药时间',
                width: 95,
                align: 'center'
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
                                return '住院发药'
                            case 'YH' : 
                                return '住院退药'
                            case 'FH' : 
                                return '门诊发药'
                            case 'HH' : 
                                return '门诊退药'
                        }
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
                align: 'right',
                width: 75
            },
            {
                field: 'oeore',
                title: '执行记录ID',
                formatter: function (value, row, index) {
                    var qOpts = "{oeore:'" + row.oeore + "'}";
                    //return '<a class="pha-grid-a" onclick="PHA_UX.TimeLine({},' + qOpts + ')">' + value + '</a>';
                },
                hidden: true
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
                title: '护士处理医嘱信息'
            },
            {
                field: 'nurAuditInfo',
                title: '领药审核信息'
            },
            {
                field: 'phaInfo',
                title: '发、退药信息'
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
            msg: '请先查询数据， 再进行打印',
            type: 'alert'
        });
        return;
    }
    //获取界面数据

    var para = {
        title: session['LOGON.HOSPDESC'] + '发药综合查询统计',
        countDate: $('#conStartDate').datebox('getValue') + '至' + $('#conEndDate').datebox('getValue'),
        printDate: PHA_UTIL.GetTime('', 'Y'),
        phLocDesc: $('#conPhaLoc').combobox('getText'),
        wardDesc: $('#conWardLoc').combobox('getText')
    };

    var list = JSON.parse(JSON.stringify($('#gridInci').datagrid('getData').originalRows));
    // 增加合计
    var footer = JSON.parse(JSON.stringify($('#gridInci').datagrid('getData').footer[0]));
    footer.inciDesc = '合计';
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
            fontname: '黑体',
            fontbold: 'true',
            fontsize: '12',
            format: '页码：{1}/{2}'
        }
    });
    
}

 /*  */
