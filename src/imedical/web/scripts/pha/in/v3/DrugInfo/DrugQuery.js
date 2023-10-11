// scripts/pha/in/v3/DrugInfo/DrugQuery.js
///

/**
 * 模块:     药品信息查询
 * 编写日期: 2021-01-05
 * 编写人:   yangsj
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
$(function () {
    InitHospCombo();
    InitGrid();
    InitBtnEvent();
    InitDict();
    InitEvent();
});

function InitHospCombo() {
	var hospComp = GenHospComp('ARC_ItmMast','', { width: 250 });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        //医院变换时字典也需要更新
        InitDict();
        cleanWithOutHosp();
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'ARC_ItmMast',
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
}

function InitGrid() {
    var columns = [
        [
            { field: 'InciId', title: '库存项id', align: 'left', width: 80, hidden: true },

            { field: 'Spec', title: $g('规格'), align: 'left', width: 80 },
            { field: 'Manf', title: $g('生产企业'), align: 'left', width: 250 },
            { field: 'Sp', title: $g('售价(入库单位)'), align: 'right', width: 100 },
            { field: 'Rp', title: $g('进价(入库单位)'), align: 'right', width: 100 },
            { field: 'BUomDesc', title: $g('基本单位'), align: 'center', width: 80 },
            { field: 'PurUomDesc', title: $g('入库单位'), align: 'center', width: 80 },
            { field: 'BillUomDesc', title: $g('计价单位'), align: 'center', width: 80, hidden: true },
            { field: 'OutUomDesc', title: $g('门诊发药单位'), align: 'center', width: 100 },
            { field: 'InUomDesc', title: $g('住院发药单位'), align: 'center', width: 100 },
            { field: 'FormDesc', title: $g('剂型'), align: 'left', width: 80 },
            { field: 'LabelName', title: $g('商品名'), align: 'left', width: 120 },
            { field: 'GenericName', title: $g('处方通用名'), align: 'left', width: 200 },
            { field: 'StkCatDesc', title: $g('库存分类'), align: 'left', width: 120 },
            { field: 'PhaCatAllDesc', title: $g('药学分类'), align: 'left', width: 400 },
            { field: 'ArcItemCat', title: $g('医嘱子类'), align: 'left', width: 120 },
            { field: 'OrderCat', title: $g('医嘱大类'), align: 'left', width: 120 },
            { field: 'InstrDesc', title: $g('用法'), align: 'left', width: 100 },
            { field: 'FreqDesc', title: $g('频次'), align: 'left', width: 100 },
            { field: 'PoisonDesc', title: $g('管制分类'), align: 'left', width: 100 },
            { field: 'ItmRemark', title: $g('批准文号'), align: 'left', width: 200 },
            { field: 'MaxSp', title: $g('最高售价'), align: 'right', width: 80 },
            { field: 'ImportFlag', title: $g('进口标志'), align: 'left', width: 80 },
            { field: 'DrugUseInfo', title: $g('用药说明'), align: 'left', width: 100 },
            {
                field: 'CountryBasicFlag',
                title: $g('国家基本药物'),
                align: 'center',
                width: 100,
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                }
            },
            {
                field: 'ProvinceBasicFlag',
                title: $g('省基本药物'),
                align: 'center',
                width: 80,
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                }
            },
            {
                field: 'AntiFlag',
                title: $g('抗菌药'),
                align: 'center',
                width: 60,
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                }
            },
            {
                field: 'InHosFlag',
                title: $g('本院药品目录'),
                align: 'center',
                width: 100,
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                }
            },
            {
                field: 'CodexFlag',
                title: $g('中国药典标志'),
                align: 'center',
                width: 100,
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                }
            },
            {
                field: 'NotUseFlag',
                title: $g('不可用'),
                align: 'center',
                width: 60,
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                }
            }
        ]
    ];
    var frozenColumns = [
        [
            { field: 'InciCode', title: $g('代码'), align: 'left', sortable: true, width: 100 },
            { field: 'InciDesc', title: $g('名称'), align: 'left', sortable: true, width: 300 }
        ]
    ];

    var dataGridOption = {
        fit: true,
        toolbar: '', // '#TextPropBar',
        rownumbers: true,
        gridSave:false,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        nowrap: false,
        idField: 'InciId',
        toolbar: '#DrugInfoBar',
        columns: columns,
        frozenColumns: frozenColumns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.DrugInfo.Query',
            QueryName: 'QueryDrugList'
        },
        onLoadSuccess: function (data) {},
        onSelect: function (rowIndex, rowData) {}
    };
    PHA.Grid('gridDrugInfo', dataGridOption);
}
function InitBtnEvent() {}
function InitDict() {
    PHA.ComboBox('ComStkGroup', {
        panelHeight: 'auto',
        url: PHA_STORE.DHCStkCatGroup().url,
        onSelect: function (data) {
            $('#ComStkCat').combobox('reload', PHA_STORE.INCStkCat().url + '&CatGrpId=' + data.RowId || '');
            $('#ComStkCat').combobox('clear');
        },
        onChange:function (newVal,oldVal) {
	        if(newVal==""||newVal==undefined)
	        {
	        	$('#ComStkCat').combobox('reload', PHA_STORE.INCStkCat().url + '&CatGrpId=""' );
            	$('#ComStkCat').combobox('clear');
	        }
        }
    });
    PHA.ComboBox('ComStkCat', {
        // url: PHA_STORE.INCStkCat().url
    });
    PHA.ComboBox('ComInciStatus', {
        panelHeight: 'auto',
        editable: false,
        width: 250,
        data: [
            {
                RowId: 'ALL',
                Description: $g('全部')
            },
            {
                RowId: 'ACTIVE',
                Description: $g('仅可用')
            },
            {
                RowId: 'STOP',
                Description: $g('不可用')
            },
            {
                RowId: 'EDORD',
                Description: $g('医嘱截止')
            },
            {
                RowId: 'NEW',
                Description: $g('新增未使用')
            }
        ]
    });
    $('#ComInciStatus').combobox('setValue', 'ALL');

    PHA.TriggerBox('genePHCCat', {
        width: 250,
        handler: function (data) {
            PHA_UX.DHCPHCCat('genePHCCat', {}, function (data) {
                $('#genePHCCat').triggerbox('setValue', data.phcCatDescAll);
                $('#genePHCCat').triggerbox('setValueId', data.phcCatId);
            });
        }
    });
    //药品名称lookup
    var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
        width: 250
    });
    PHA.LookUp('cmbgridInci', opts);
}
function InitEvent() {
    $('#TextInciALian').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var inciAlian = $('#TextInciALian').val() || '';
            if (inciAlian != '') {
                $('#TextInciCode').val('');
                queryList();
            }
        }
    });
    $('#TextInciCode').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var inciCode = $('#TextInciCode').val() || '';
            if (inciCode != '') {
                $('#TextInciALian').val('');
                queryList();
            }
        }
    });
}

function queryList() {
    var ParamsJson = GetParamsJson();
    var SortName = $('#gridDrugInfo').datagrid('options').sortName || '';
    var SortOrder = $('#gridDrugInfo').datagrid('options').sortOrder || '';

    $('#gridDrugInfo').datagrid('query', {
        HospId: PHA_COM.Session.HOSPID,
        ParamsJson: JSON.stringify(ParamsJson),
        sortName: SortName,
        sortOrder: SortOrder
    });
}

function GetParamsJson() {
    return {
        InciCode: $('#TextInciCode').val() || '',
        Inci: $('#cmbgridInci').lookup('getValue') || '',
        StkGroup: $('#ComStkGroup').combobox('getValue') || '',
        InciStatus: $('#ComInciStatus').combobox('getValue') || '',
        InciALian: $('#TextInciALian').val() || '',
        PHCCat: $('#genePHCCat').triggerbox('getValueId') || '',
        StkCat: $('#ComStkCat').combobox('getValue') || ''
    };
}

function clean() {
    $('#_HospList').combogrid('setValue',SessionHosp);
	cleanWithOutHosp();
}

function cleanWithOutHosp()
{
	$('#TextInciCode').val('');
    $('#TextInciALian').val('');
    $('#cmbgridInci').lookup('setValue', '');
    $('#cmbgridInci').lookup('clear');
    $('#ComStkGroup').combobox('setValue', '');
    $('#ComInciStatus').combobox('setValue', 'ALL');
    $('#ComStkCat').combobox('setValue', '');
    $('#genePHCCat').triggerbox('setValueId', '');
    $('#genePHCCat').triggerbox('setValue', '');
    $('#ComStkCat').combobox('reload', PHA_STORE.INCStkCat().url + '&CatGrpId=""' );
    $('#gridDrugInfo').datagrid('clear');
    $('#gridDrugInfo').datagrid('clearSelections');
}
