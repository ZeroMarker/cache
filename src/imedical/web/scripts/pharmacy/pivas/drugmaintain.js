/**
 * ģ��:     ��ҺҩƷ��Ϣά��
 * ��д����: 2018-03-29
 * ��д��:   yunhaibao
 */
$.fn.datagrid.defaults.operators.nofilter.text = $g('��');
$.fn.datagrid.defaults.operators.contains.text = $g('����');
$.fn.datagrid.defaults.operators.equal.text = $g('����');
$.fn.datagrid.defaults.operators.notequal.text = $g('������');
$.fn.datagrid.defaults.operators.beginwith.text = $g('ǰƥ��');
$.fn.datagrid.defaults.operators.endwith.text = $g('��ƥ��');
$.fn.datagrid.defaults.operators.less.text = $g('С��');
$.fn.datagrid.defaults.operators.lessorequal.text = $g('С�ڵ���');
$.fn.datagrid.defaults.operators.greater.text = $g('����');
$.fn.datagrid.defaults.operators.greaterorequal.text = $g('���ڵ���');
// ���÷�ҳ��ʽ
//  $.fn.pagination.defaults.layout=['list','sep','first','prev','links','next','last','sep','refresh']
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var ModifyRow = '';
$(function () {
    InitDict();
    InitGridIncItm();
    $('#txtAlias').on('keypress', function (event) {
        if (event.keyCode == '13') {
            Query();
        }
    });
    $('#btnFind').on('click', Query);
    $('#btnSave').on('click', Save);
    $('[name="js-col-filter"]').on('click', function () {
        $('[name="js-col-filter"]').toggle();
        $('#gridIncItm').datagrid($(this).attr('handle'));
    });

    var tipInfoArr = [];
    tipInfoArr.push("<div style='line-height:25px;font-weight:bold'>" + $g('���ڼ�����Һ������ , ����ȡ��Ӧϵ��Ϊ��ʱ , ��Ĭ��ϵ��') + '</div>');
    tipInfoArr.push("<div style='line-height:25px'> [~1] : " + $g('��Һ����ϵ�� , ҩƷ��Һ��Ĭ���Ѷ�ϵ��') + '</div>');
    tipInfoArr.push("<div style='line-height:25px'> [~2] : " + $g(' ������Һ����ϵ�� , ����ҩƷ����һ������ҩƷ��ȫ��ͬʱ , ����ϵ��') + '</div>');
    tipInfoArr.push("<div style='line-height:25px'> [~3] : " + $g(' ͬ����ͬ����ϵ�� , ͬ��ҩƷ�ڳ�����ͬҩƷ������������1�Ĳ��� , ����ϵ��') + '</div>');
    $('[for=txtCoef]').tooltip({
        content: tipInfoArr.join(''),
        position: 'left',
        showDelay: 500
    });

    $('[for=txtOrdCode]').tooltip({
        content: "<div style='line-height:25px'> " + $g('ά����ʾ˳���, ���������ʾ˳��������ʾ˳�� > ��ҩ > ��ҩ > ��ý ��˳����ʾ') + '</div>',
        position: 'left',
        showDelay: 500
    });
    setTimeout(function () {
        // debugger
        var tableWidth = $('.js-pha-panel-fit .pha-con-table').width()
        // var scrollWidth = PIVAS.GetScrollBarWidth() ;
        $('.js-pha-layout-fit')
            .layout('panel', 'east')
            .panel('resize', { width: tableWidth + 12 + 32 }); // 10(split���) + 2(border��Ⱥ�) + 22(����padding)
        $('.js-pha-layout-fit').layout('resize');
        $('.js-pha-panel-fit').panel('resize');
        $('.dhcpha-win-mask').hide();
    }, 100);
});

function InitDict() {
    // ��Һ����
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaLoc', Type: 'PivaLoc' },
        {
            placeholder: '��Һ����...',
            editable: false,
            width: 200,
            onLoadSuccess: function () {
                var datas = $('#cmbPivaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPivaLoc').combobox('select', datas[i].RowId);
                        break;
                    }
                }
            },
            onSelect: function (data) {
                $('#cmbConTable').combobox('query', { inputStr: data.RowId });
                $('#cmbStkCat').combobox('query', { LocId: data.RowId });
                Query();
            }
        }
    );
    // ������
    PIVAS.ComboBox.Init({ Id: 'cmbStkCat', Type: 'StkCat' }, { placeholder: '������...' });
    // ������ҩ
    PIVAS.ComboBox.Init({ Id: 'cmbPhcDrugType', Type: 'MedicalType' }, {});
    // ��ҺС��
    PIVAS.ComboBox.Init({ Id: 'cmbPhcPivaCat', Type: 'PHCPivaCat' }, {});
    // ����̨
    PIVAS.ComboBox.Init({ Id: 'cmbConTable', Type: 'PIVAConfigTable' }, {});
}

function InitGridIncItm() {
    var columns = [
        [
            { field: 'incil', title: 'incil', hidden: true },
            { field: 'incId', title: 'incId', hidden: true },
            { field: 'incCode', title: 'ҩƷ����', width: 100 },
            { field: 'incDesc', title: 'ҩƷ����', width: 225 },
            { field: 'incSpec', title: '���', width: 100 },
            { field: 'manfDesc', title: '������ҵ', width: 170 },
            { field: 'phcDrugTypeDesc', title: '������ҩ', width: 75 },
            {
                field: 'menstruumFlag',
                title: '��ý',
                width: 50,
                halign: 'left',
                align: 'center',
                formatter: function (value, row, index) {
                    return value === 'Y' ? $g('��') : '';
                }
            },
            { field: 'conTblDesc', title: '����̨', width: 100 },
            { field: 'phcPivaCatDesc', title: '��ҺС��', width: 100 },
            { field: 'ivgttSpeed', title: '����', width: 50 },
            { field: 'labelSign', title: '��ǩ��ʶ', width: 75 },
            { field: 'useInfo', title: '��ҩ˵��', width: 100 },
            { field: 'storeInfo', title: '��������', width: 100 },
            { field: 'ordCode', title: '��ʾ˳��', width: 75 },
            { field: 'coef', title: 'Ĭ����Һ����ϵ��', width: 73 },
            { field: 'conCoef', title: '������Һ����ϵ��', width: 73 },
            { field: 'sameCoef', title: 'ͬ����ͬ����ϵ��', width: 73 },
            { field: 'phcDrugTypeCode', title: '(��/��)ҩ����', width: 75, hidden: true },
            { field: 'phcPivaCatId', title: '��ҺС��Id', width: 75, hidden: true },
            { field: 'conTblId', title: '����̨Id', width: 75, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: PIVAS.URL.COMMON + '?action=DrugMaintain.JsGetIncItm',
        toolbar: '#gridIncItmBar',
        columns: columns,
        pageList: [200, 500, 1000],
        pageSize: 200,
        fit: true,
        remoteFilter: true,
        clientPaging: false,
        filterDelay: 1000,
        defaultFilterOperator: 'contains',
        onSelect: function (rowIndex, rowData) {
            if (rowData) {
                $('#txtStoreInfo').val(rowData.storeInfo);
                $('#txtUseInfo').val(rowData.useInfo);
                $('#txtIvgttSpeed').val(rowData.ivgttSpeed);
                $('#txtLabelSign').val(rowData.labelSign);
                $('#chkMenstr').checkbox(rowData.menstruumFlag == 'Y' ? 'check' : 'uncheck');
                $('#cmbPhcDrugType').combobox('setValue', rowData.phcDrugTypeCode);
                $('#cmbPhcPivaCat').combobox('setValue', rowData.phcPivaCatId);
                $('#cmbConTable').combobox('setValue', rowData.conTblId);
                $('#txtCoef').numberbox('setValue', rowData.coef);
                $('#txtConCoef').numberbox('setValue', rowData.conCoef);
                $('#txtSameCoef').numberbox('setValue', rowData.sameCoef);
                $('#txtOrdCode').val(rowData.ordCode);
            }
        },
        onLoadSuccess: function (data) {
            $('#gridIncItm').datagrid('scrollTo', 0);
            if (ModifyRow != '') {
                $('#gridIncItm').datagrid('selectRow', ModifyRow);
            }
            ModifyRow = '';
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridIncItm', dataGridOption);
}
/// ��ѯ
function Query() {
    var locId = $('#cmbPivaLoc').combobox('getValue');
    if (locId == '') {
        $.messager.alert('��ʾ', '��ѡ����Һ����', 'warning');
        return '';
    }
    var stkCatId = $('#cmbStkCat').combobox('getValue');
    var incAlias = $('#txtAlias').val().trim();
    var chkMyLoc = $('#chkMyLoc').is(':checked') ? 'Y' : 'N';
    var params = locId + '^' + stkCatId + '^' + incAlias + '^' + chkMyLoc;
    $('#gridIncItm').datagrid('load', {
        params: params
    });
}

/// ����
function Save() {
    var locId = $('#cmbPivaLoc').combobox('getValue');
    if (locId == '') {
        $.messager.alert('��ʾ', '��ѡ����Һ����', 'warning');
        return '';
    }
    var gridSelect = $('#gridIncItm').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('��ʾ', '��ѡ��ҩƷ', 'warning');
        return '';
    }
    var incId = gridSelect.incId;
    var conTblId = $('#cmbConTable').combobox('getValue');
    var useInfo = $('#txtUseInfo').val();
    var storeInfo = $('#txtStoreInfo').val();
    var ivgttSpeed = $('#txtIvgttSpeed').val();
    var phcPivaCat = $('#cmbPhcPivaCat').combobox('getValue');
    var phcDrgType = $('#cmbPhcDrugType').combobox('getValue');
    var menstrFlag = $('#chkMenstr').is(':checked') ? 'Y' : 'N';
    var labelSign = $('#txtLabelSign').val();
    var coef = $('#txtCoef').val().trim();
    var conCoef = $('#txtConCoef').val().trim();
    var sameCoef = $('#txtSameCoef').val().trim();
    var ordCode = $('#txtOrdCode').val().trim();
    var chkInfo = '';
    chkInfo = CheckCoef(coef);
    if (chkInfo != '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: chkInfo,
            type: 'alert'
        });
        return;
    }
    chkInfo = CheckCoef(conCoef);
    if (chkInfo != '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: chkInfo,
            type: 'alert'
        });
        return;
    }
    chkInfo = CheckCoef(sameCoef);
    if (chkInfo != '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: chkInfo,
            type: 'alert'
        });
        return;
    }
    var paramsArr = [];
    paramsArr.push(locId);
    paramsArr.push(incId);
    paramsArr.push(conTblId);
    paramsArr.push(useInfo);
    paramsArr.push(storeInfo);
    paramsArr.push(ivgttSpeed);
    paramsArr.push(phcPivaCat);
    paramsArr.push(phcDrgType);
    paramsArr.push(menstrFlag);
    paramsArr.push(labelSign);
    paramsArr.push(coef);
    paramsArr.push(conCoef);
    paramsArr.push(sameCoef);
    paramsArr.push(ordCode);
    var params = paramsArr.join('^');
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.DrugMaintain', 'SaveData', params);
    var saveArr = saveRet.split('^');
    var saveValue = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveValue < 0) {
        $.messager.alert('��ʾ', saveInfo, saveValue == '-1' ? 'warning' : 'error');
        return;
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '����ɹ�',
            type: 'success'
        });
        ModifyRow = $('#gridIncItm').datagrid('getRowIndex', gridSelect);
        $('#gridIncItm').datagrid('reload');
    }
}
function CheckCoef(num) {
    if (num == '') {
        return '';
    }
    if (isNaN(num)) {
        return '����ϵ����Ϊ����';
    }
    if (parseFloat(num) < 0) {
        return '����ϵ��Ϊ����';
    }
    return '';
}
