/**
 * 模块:     配液药品信息维护
 * 编写日期: 2018-03-29
 * 编写人:   yunhaibao
 */
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
    var tipInfoArr = [];
    tipInfoArr.push("<div style='line-height:25px;font-weight:bold'>用于计算配液工作量 , 当获取对应系数为空时 , 按默认系数</div>");
    tipInfoArr.push("<div style='line-height:25px'> [~1] : 配液配置系数 , 药品配液的默认难度系数</div>");
    tipInfoArr.push("<div style='line-height:25px'> [~2] : 连续配液配置系数 , 成组药品与上一组配置药品完全相同时 , 按此系数</div>");
    tipInfoArr.push("<div style='line-height:25px'> [~3] : 同组相同配置系数 , 同组药品内出现相同药品或者数量大于1的部分 , 按此系数</div>");
    $('[for=txtCoef]').tooltip({
        content: tipInfoArr.join(''),
        position: 'left',
        showDelay: 500
    });
});

function InitDict() {
    // 配液中心
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaLoc', Type: 'PivaLoc' },
        {
            placeholder: '配液中心...',
            editable: false,
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
    // 库存分类
    PIVAS.ComboBox.Init({ Id: 'cmbStkCat', Type: 'StkCat' }, { placeholder: '库存分类...' });
    // 主辅用药
    PIVAS.ComboBox.Init({ Id: 'cmbPhcDrugType', Type: 'MedicalType' }, {});
    // 配液小类
    PIVAS.ComboBox.Init({ Id: 'cmbPhcPivaCat', Type: 'PHCPivaCat' }, {});
    // 配置台
    PIVAS.ComboBox.Init({ Id: 'cmbConTable', Type: 'PIVAConfigTable' }, {});
}

function InitGridIncItm() {
    var columns = [
        [
            { field: 'incil', title: 'incil', hidden: true },
            { field: 'incId', title: 'incId', hidden: true },
            { field: 'incCode', title: '药品代码', width: 100 },
            { field: 'incDesc', title: '药品名称', width: 225 },
            { field: 'incSpec', title: '规格', width: 100 },
            { field: 'manfDesc', title: '生产企业', width: 150 },
            { field: 'phcDrugTypeDesc', title: '主辅用药', width: 75 },
            {
                field: 'menstruumFlag',
                title: '溶媒',
                width: 50,
                halign: 'left',
                align: 'center',
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return PIVAS.Grid.CSS.Yes;
                    }
                }
            },
            { field: 'conTblDesc', title: '配置台', width: 75 },
            { field: 'phcPivaCatDesc', title: '配液小类', width: 75 },
            { field: 'ivgttSpeed', title: '滴速', width: 50 },
            { field: 'labelSign', title: '标签标识', width: 75 },
            { field: 'useInfo', title: '用药说明', width: 100 },
            { field: 'storeInfo', title: '储藏条件', width: 100 },
            { field: 'coef', title: '默认配液</br>配置系数', width: 73 },
            { field: 'conCoef', title: '连续配液</br>配置系数', width: 73 },
            { field: 'sameCoef', title: '同组相同</br>配置系数', width: 73 },
            { field: 'phcDrugTypeCode', title: '(主/辅)药代码', width: 75, hidden: true },
            { field: 'phcPivaCatId', title: '配液小类Id', width: 75, hidden: true },
            { field: 'conTblId', title: '配置台Id', width: 75, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: PIVAS.URL.COMMON + '?action=DrugMaintain.JsGetIncItm',
        toolbar: '#gridIncItmBar',
        columns: columns,
        fit: true,
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
/// 查询
function Query() {
    var locId = $('#cmbPivaLoc').combobox('getValue');
    if (locId == '') {
        $.messager.alert('提示', '请选择配液中心', 'warning');
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

/// 保存
function Save() {
    var locId = $('#cmbPivaLoc').combobox('getValue');
    if (locId == '') {
        $.messager.alert('提示', '请选择配液中心', 'warning');
        return '';
    }
    var gridSelect = $('#gridIncItm').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('提示', '请选择药品', 'warning');
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
    var params =
        locId +
        '^' +
        incId +
        '^' +
        conTblId +
        '^' +
        useInfo +
        '^' +
        storeInfo +
        '^' +
        ivgttSpeed +
        '^' +
        phcPivaCat +
        '^' +
        phcDrgType +
        '^' +
        menstrFlag +
        '^' +
        labelSign +
        '^' +
        coef +
        '^' +
        conCoef +
        '^' +
        sameCoef;
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.DrugMaintain', 'SaveData', params);
    var saveArr = saveRet.split('^');
    var saveValue = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveValue < 0) {
        $.messager.alert('提示', saveInfo, saveValue == '-1' ? 'warning' : 'error');
        return;
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '保存成功',
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
        return '配置系数不为数字';
    }
    if (parseFloat(num) < 0) {
        return '配置系数为负数';
    }
    return '';
}
