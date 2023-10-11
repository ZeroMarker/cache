/*
 * @Descripttion: ��λ����ת������
 * @Author: yaojining
 * @Date: 2022-05-10
 */
var GLOBAL = {
    HospEnvironment: true,
    HospitalID: session['LOGON.HOSPID'],
    ConfigTableName: 'Nur_IP_UnitConversion',
    ClassName: 'NurMp.Service.InOut.Conversion',
    EditGrid: '#gridConversion'
};
var init = function () {
    initHosp(initGrid);
    initCondition();
    initGrid();
    listenEvent();
}

$(init);

/**
* @description: ��ѯ����
*/
function initCondition() {
    $('#cbName').combobox({
        url: $URL + '?ClassName=NurMp.Service.InOut.Conversion&QueryName=FindUnitConversion&ResultSetType=array&HospitalID=' + GLOBAL.HospitalID + '&Type=IO',
        valueField: 'Id',
        textField: 'UCDesc',
        defaultFilter: 4,
        onSelect: function (record) {
            $('#btnSearch').click();
        }
    });

}
/**
* @description: ��ȡ����
*/
function ckTypes() {
    var types = '';
    $("input[name='ckType']").each(function (index, obj) {
        if ($(obj).checkbox('getValue')) {
            types = !!types ? types + '^' + $(obj).val() : $(obj).val();
        }
    });
    return types;
}
/**
* @description: ��ʼ�����ұ��
*/
function initGrid() {
    var toolbar = [{
        id: 'add',
        iconCls: 'icon-add',
        text: '����',
        handler: add
    }, {
        id: 'remove',
        iconCls: 'icon-cancel',
        text: 'ɾ��',
        handler: remove
    }, {
        id: 'save',
        iconCls: 'icon-save',
        text: '����',
        handler: save
    }, {
        id: 'reset',
        iconCls: 'icon-reset',
        text: 'ˢ��',
        handler: reloadGrid
    }];
    $(GLOBAL.EditGrid).datagrid({
        url: $URL,
        queryParams: {
            ClassName: GLOBAL.ClassName,
            QueryName: 'FindUnitConversion',
            HospitalID: GLOBAL.HospitalID,
            Type: ckTypes(),
            Filter: $('#cbName').combobox('getText')
        },
        columns: [[
            { field: 'UCDesc', title: '����', align: 'left', width: 200, editor: 'text' },
            { field: 'UCCountFrom', title: '��������', width: 120, editor: { type: 'numberbox', options: { precision: 2 } } },
            {
                field: 'UCUnitFrom', title: '������λ', width: 100,
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        required: false,
                        blurValidValue: true,
                        data: [
                            { value: "mg", desc: "mg" },
                            { value: "g", desc: "g" },
                            { value: "kg", desc: "kg" },
                            { value: "ml", desc: "ml" },
                            { value: "l", desc: "l" }
                        ]
                    }
                }
            },
            { field: 'UCCountTo', title: '��λ��ˮ��', width: 120, editor: { type: 'numberbox', options: { precision: 2 } } },
            {
                field: 'UCUnitTo', title: '������ˮ����λ', width: 120,
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        required: false,
                        blurValidValue: true,
                        data: [
                            { value: "ml", desc: "ml" },
                            { value: "l", desc: "l" }
                        ]
                    }
                }
            },
            {
                field: 'UCType', title: '����', width: 100,
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        required: false,
                        blurValidValue: true,
                        data: [
                            { value: "I", desc: "����" },
                            { value: "O", desc: "����" }
                        ]
                    }
                },
                formatter: function (value, row, index) {
                    if (value == 'I') {
                        return '����';
                    } else {
                        return '����';
                    }
                }
            },
            { field: 'UCNote', title: '��ע', width: 250, editor: 'text' },
            { field: 'Id', title: 'ID', width: 100, hidden: true }
        ]],
        toolbar: toolbar,
        nowrap: false,
        singleSelect: true,
        pagination: true,
        pageSize: 15,
        pageList: [15, 30, 50],
        onLoadSuccess: function(data) {
            initCondition();
        },
        onClickRow: singleClickRow,
        onDblClickRow: clickRow
    });
}
/**
* @description: ����
*/
function singleClickRow(rowIndex, rowData) {
    $('#oriNum').val(rowData.UCCountFrom);
    $('#countNum').val('1');
    $('#unitName').html(rowData.UCDesc);
    var unitCount = parseFloat(rowData.UCCountTo) / parseFloat(rowData.UCCountFrom);
    $('#unitCount').html(parseFloat(unitCount));
    count();
}
/**
* @description: ����
*/
function add() {
    append({ UCCountFrom: '100', UCUnitFrom: 'g', UCUnitTo: 'ml', UCType: 'I' });
}
/**
* @description: ɾ��
*/
function remove() {
    var rows = $(GLOBAL.EditGrid).datagrid('getSelections');
    if (rows.length < 1) {
        $.messager.alert("��ʾ", "��ѡ��Ҫɾ�������ݣ�", "info");
        return;
    }
    var ids = null;
    $.each(rows, function (index, row) {
        ids = !!ids ? ids + '^' + row.Id : row.Id;
    });
    $.messager.confirm("��ʾ", "ȷ��ɾ��ѡ�еļ�¼��?", function (r) {
        if (r) {
            $cm({
                ClassName: 'NurMp.Common.Logic.Handler',
                MethodName: "Delete",
                ClsName: 'CF.NUR.EMR.UnitConversion',
                Ids: ids
            }, function (result) {
                if (result.status >= 0) {
                    $.messager.popover({ msg: result.msg, type: "success" });
                    reloadGrid();
                } else {
                    $.messager.popover({ msg: result.msg, type: "error" });
                    return;
                }
            });
        } else {
            return;
        }
    });
}
/**
* @description: ����
*/
function save() {
    var addItems = getChanges();
    if (addItems.length == 0) {
        $.messager.alert("��ʾ", "û����Ҫ��������ݣ�", "info");
        return;
    }
    var nullColumn = '';
    var arrItems = new Array();
    $.each(addItems, function (index, item) {
        var objItem = new Object();
        objItem['RowID'] = item.Id;
        if (item.UCDesc == '') {
            nullColumn = '����';
            return false;
        }
        objItem['UCDesc'] = item.UCDesc;
        if (item.UCCountFrom == '') {
            nullColumn = '��������';
            return false;
        }
        objItem['UCCountFrom'] = item.UCCountFrom;
        if (item.UCUnitFrom == '') {
            nullColumn = '������λ';
            return false;
        }
        objItem['UCUnitFrom'] = item.UCUnitFrom;
        if (item.UCCountTo == '') {
            nullColumn = '��λ��ˮ��';
            return false;
        }
        objItem['UCCountTo'] = item.UCCountTo;
        if (item.UCUnitTo == '') {
            nullColumn = '������ˮ����λ';
            return false;
        }
        objItem['UCUnitTo'] = item.UCUnitTo;
        if (item.UCType == '') {
            nullColumn = '����';
            return false;
        }
        objItem['UCType'] = item.UCType;
        objItem['UCNote'] = item.UCNote;
        objItem['UCHospDr'] = GLOBAL.HospitalID;
        arrItems.push(objItem);
    });
    if (!!nullColumn) {
        $.messager.alert("��ʾ", nullColumn + "����Ϊ�գ�", "info");
        return;
    }
    if (!verifyRecord('UCDesc')) {
        $.messager.alert("��ʾ", "�����Ѿ����ڣ�", "info");
        return;
    }
    $cm({
        ClassName: 'NurMp.Common.Logic.Handler',
        MethodName: 'Save',
        ClsName: 'CF.NUR.EMR.UnitConversion',
        Param: JSON.stringify(arrItems)
    }, function (result) {
        if (result.status >= 0) {
            $.messager.popover({ msg: result.msg, type: "success" });
            reloadGrid();
        } else {
            $.messager.popover({ msg: result.msg, type: "error" });
            return;
        }
    });
    accept();
}
/**
* @description: ��֤�Ƿ��ظ�
*/
function verifyRecord(prop) {
    var objRows = [];
    var rows = $(GLOBAL.EditGrid).datagrid('getRows');
    $.each(rows, function (index, row) {
        var identity = row[prop];
        objRows[identity] = '';
    });
    if (rows.length != Object.keys(objRows).length) {
        return false;
    }
    return true;
}
/**
 * @description: ˢ��
 */
function reloadGrid() {
    $(GLOBAL.EditGrid).datagrid('reload', {
        ClassName: GLOBAL.ClassName,
        QueryName: 'FindUnitConversion',
        HospitalID: GLOBAL.HospitalID,
        Type: ckTypes(),
        Filter: $('#cbName').combobox('getText')
    });
    $('#cbName').combobox('reload');
    clearCount();
}
/**
 * @description: ������
 */
function compute() {
    var rows = $(GLOBAL.EditGrid).datagrid('getSelections');
    if (rows.length != 1) {
        $.messager.alert("��ʾ", "��ѡ��һ�����ݣ�", "info");
        return;
    }
}
/**
 * @description: ����
 */
function count() {
    var oriNum = parseFloat($('#oriNum').val());
    var countNum = parseFloat($('#countNum').val());
    var unitCount = parseFloat($('#unitCount').html());
    if ($.isNumeric(oriNum) && $.isNumeric(countNum) && $.isNumeric(unitCount)) {
        var total = oriNum * countNum * unitCount;
        $('#total').val(total);
    }
}
/**
 * @description: ��ռ�����
 */
 function clearCount() {
    $('#unitName').html('������');
    $('#oriNum').val('');
    $('#countNum').val('');
    $('#unitCount').html('��λ��ˮ��');
    $('#total').val('');
}
/**
 * @description: �¼�
 */
function listenEvent() {
    $('#btnSearch').bind('click', reloadGrid);
    $('#oriNum').bind('blur', count);
    $('#countNum').bind('blur', count);
    $('#total').bind('blur', count);
    $("input[name='ckType']").checkbox({
        onCheckChange: function (e, value) {
            reloadGrid();
        }
    });
}
