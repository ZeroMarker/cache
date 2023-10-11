// scripts/pha/in/v3/DrugInfo/DrugQuery.js
///

/**
 * ģ��:     ҩƷ��Ϣ��ѯ
 * ��д����: 2021-01-05
 * ��д��:   yangsj
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
        //ҽԺ�任ʱ�ֵ�Ҳ��Ҫ����
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
            { field: 'InciId', title: '�����id', align: 'left', width: 80, hidden: true },

            { field: 'Spec', title: $g('���'), align: 'left', width: 80 },
            { field: 'Manf', title: $g('������ҵ'), align: 'left', width: 250 },
            { field: 'Sp', title: $g('�ۼ�(��ⵥλ)'), align: 'right', width: 100 },
            { field: 'Rp', title: $g('����(��ⵥλ)'), align: 'right', width: 100 },
            { field: 'BUomDesc', title: $g('������λ'), align: 'center', width: 80 },
            { field: 'PurUomDesc', title: $g('��ⵥλ'), align: 'center', width: 80 },
            { field: 'BillUomDesc', title: $g('�Ƽ۵�λ'), align: 'center', width: 80, hidden: true },
            { field: 'OutUomDesc', title: $g('���﷢ҩ��λ'), align: 'center', width: 100 },
            { field: 'InUomDesc', title: $g('סԺ��ҩ��λ'), align: 'center', width: 100 },
            { field: 'FormDesc', title: $g('����'), align: 'left', width: 80 },
            { field: 'LabelName', title: $g('��Ʒ��'), align: 'left', width: 120 },
            { field: 'GenericName', title: $g('����ͨ����'), align: 'left', width: 200 },
            { field: 'StkCatDesc', title: $g('������'), align: 'left', width: 120 },
            { field: 'PhaCatAllDesc', title: $g('ҩѧ����'), align: 'left', width: 400 },
            { field: 'ArcItemCat', title: $g('ҽ������'), align: 'left', width: 120 },
            { field: 'OrderCat', title: $g('ҽ������'), align: 'left', width: 120 },
            { field: 'InstrDesc', title: $g('�÷�'), align: 'left', width: 100 },
            { field: 'FreqDesc', title: $g('Ƶ��'), align: 'left', width: 100 },
            { field: 'PoisonDesc', title: $g('���Ʒ���'), align: 'left', width: 100 },
            { field: 'ItmRemark', title: $g('��׼�ĺ�'), align: 'left', width: 200 },
            { field: 'MaxSp', title: $g('����ۼ�'), align: 'right', width: 80 },
            { field: 'ImportFlag', title: $g('���ڱ�־'), align: 'left', width: 80 },
            { field: 'DrugUseInfo', title: $g('��ҩ˵��'), align: 'left', width: 100 },
            {
                field: 'CountryBasicFlag',
                title: $g('���һ���ҩ��'),
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
                title: $g('ʡ����ҩ��'),
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
                title: $g('����ҩ'),
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
                title: $g('��ԺҩƷĿ¼'),
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
                title: $g('�й�ҩ���־'),
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
                title: $g('������'),
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
            { field: 'InciCode', title: $g('����'), align: 'left', sortable: true, width: 100 },
            { field: 'InciDesc', title: $g('����'), align: 'left', sortable: true, width: 300 }
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
                Description: $g('ȫ��')
            },
            {
                RowId: 'ACTIVE',
                Description: $g('������')
            },
            {
                RowId: 'STOP',
                Description: $g('������')
            },
            {
                RowId: 'EDORD',
                Description: $g('ҽ����ֹ')
            },
            {
                RowId: 'NEW',
                Description: $g('����δʹ��')
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
    //ҩƷ����lookup
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
