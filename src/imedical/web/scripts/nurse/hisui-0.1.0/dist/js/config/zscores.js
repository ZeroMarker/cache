/*
 * @Descripttion: Zֵ��������
 * @Author: yaojining
 * @Date: 2022-05-15
 */
FileReader.prototype.readAsBinaryString = function (fileData) {
    var binary = "";
    var pt = this;
    var reader = new FileReader();
    reader.onload = function (e) {
        var bytes = new Uint8Array(reader.result);
        var length = bytes.byteLength;
        for (var i = 0; i < length; i++) {
            binary += String.fromCharCode(bytes[i]);
        }
        pt.content = binary;
        pt.onload(pt); //ҳ����dataȡpt.content�ļ�����
    }
    reader.readAsArrayBuffer(fileData);
};
var GLOBAL = {
    HospEnvironment: true,
    HospitalID: session['LOGON.HOSPID'],
    ConfigTableName: 'Nur_IP_Zscores',
    ClassName: 'NurMp.Service.Patient.Zscores',
    EditGrid: '#gridZscores'
};
var init = function () {
    initCondition();
    initGrid();
    listenEvent();
}

$(init);

/**
* @description: ��ѯ����
*/
function initCondition() {
    $('#cbSex').combobox({
        valueField: 'id',
        textField: 'desc',
        data: [
            { id: 'A', desc: 'ȫ��' },
            { id: 'M', desc: '��' },
            { id: 'W', desc: 'Ů' }
        ],
        value: 'A',
        defaultFilter: 4,
        onSelect: function (record) {
            reloadGrid();
        }
    });
    $("#cbAge").combobox({
        url: $URL + "?ClassName=" + GLOBAL.ClassName + "&QueryName=FindZscores&SexDr=A&ResultSetType=array",
        valueField: 'RowID',
        textField: 'ZSAge',
        defaultFilter: 4,
        onSelect: function (record) {
            reloadGrid();
        }
    });
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
        iconCls: 'icon-remove',
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
    }, {
        id: 'import',
        iconCls: 'icon-import',
        text: '����',
        handler: importexcel
    }];
    $(GLOBAL.EditGrid).datagrid({
        url: $URL,
        queryParams: {
            ClassName: GLOBAL.ClassName,
            QueryName: 'FindZscores',
            SexDr: $('#cbSex').combobox('getValue'),
            Age: $("#cbAge").combobox('getText')
        },
        columns: [[
            {
                field: 'ZSSex', title: '�Ա�', width: 80,
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        required: false,
                        blurValidValue: true,
                        data: [
                            { value: 'M', desc: '��' },
                            { value: 'W', desc: 'Ů' }
                        ]
                    }
                },
                formatter: function (value, row, index) {
                    if (value == 'W') {
                        return 'Ů';
                    } else {
                        return '��';
                    }
                }
            },
            { field: 'ZSAge', title: '����', align: 'center', width: 100, editor: 'text' },
            { field: 'ZSL', title: 'L', align: 'center', width: 100, editor: 'text' },
            { field: 'ZSM', title: 'M', align: 'center', width: 100, editor: 'text' },
            { field: 'ZSS', title: 'S', align: 'center', width: 100, editor: 'text' },
            { field: 'ZSN3SD', title: '-3SD', align: 'center', width: 100, editor: 'text' },
            { field: 'ZSN2SD', title: '-2SD', align: 'center', width: 100, editor: 'text' },
            { field: 'ZSN1SD', title: '-1SD', align: 'center', width: 100, editor: 'text' },
            { field: 'ZS0SD', title: '0SD', align: 'center', width: 100, editor: 'text' },
            { field: 'ZSP1SD', title: '1SD', align: 'center', width: 100, editor: 'text' },
            { field: 'ZSP2SD', title: '2SD', align: 'center', width: 100, editor: 'text' },
            { field: 'ZSP3SD', title: '3SD', align: 'center', width: 100, editor: 'text' },
            { field: 'RowID', title: 'RowID', width: 100, hidden: true }
        ]],
        toolbar: toolbar,
        nowrap: false,
        singleSelect: true,
        pagination: true,
        pageSize: 15,
        pageList: [15, 30, 50],
        onClickRow: clickRow,
    });
}
/**
* @description: ����
*/
function add() {
    append({ ZSSex: 'M' });
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
        ids = !!ids ? ids + '^' + row.RowID : row.RowID;
    });
    $.messager.confirm("��ʾ", "ȷ��ɾ��ѡ�еļ�¼��?", function (r) {
        if (r) {
            $cm({
                ClassName: 'NurMp.Common.Logic.Handler',
                MethodName: "Delete",
                ClsName: 'CT.NUR.EMR.Zscores',
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
    $.each(addItems, function (index, item) {
        if (item.ZSSex == '') {
            nullColumn = '�Ա�';
            return false;
        }
        if (item.ZSAge == '') {
            nullColumn = '����';
            return false;
        }
    });
    if (!!nullColumn) {
        $.messager.alert("��ʾ", nullColumn + "����Ϊ�գ�", "info");
        return;
    }
    $cm({
        ClassName: 'NurMp.Common.Logic.Handler',
        MethodName: 'Save',
        ClsName: 'CT.NUR.EMR.Zscores',
        Param: JSON.stringify(addItems)
    }, function (result) {
        if (result.status >= 0) {
            $.messager.popover({ msg: result.msg, type: "success" });
            reloadGrid();
            $('#cbAge').combobox('reload');
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
        QueryName: 'FindZscores',
        SexDr: $('#cbSex').combobox('getValue'),
        Age: $('#cbAge').combobox('getText')
    });
}
/**
 * @description: ����
 */
function importexcel() {
    $('#dgImport').dialog({
        title: '�����ļ�',
        width: 400,
        height: 150,
        modal: true,
        buttons: [{
            text: '����',
            handler: importHandler,
        }, {
            text: 'ȡ��',
            handler: function () {
                $('#dgImport').dialog("close");
            }
        }]
    }).dialog('open');
}
/**
     * @description ���� --����Chrome
     */
function importHandler() {
    var file = $('#ipfile').filebox('files')[0];
    var type = file.name.split('.');
    if (type[type.length - 1] !== 'xlsx' && type[type.length - 1] !== 'xls') {
        $.messager.popover({ msg: '��ѡ��.xls��.xlsx��ʽ���ļ���', type: 'error' });
        return;
    }
    $('#dgImport').dialog("close");
    $.messager.progress({
        title: "��ʾ",
        msg: '���ڵ�������',
        text: '������....'
    });
    var reader = new FileReader();
    reader.readAsBinaryString(file);
    reader.onload = function (e) {
        var rows = new Array();
        var data = e.content;
        var workbook = window.XLS.read(data, { type: 'binary', codepage: 936 });
        $.each(workbook.Sheets, function (index, sheet) {
            $.each(sheet, function (key, obj) {
                var word = key[0];
                var num = parseInt(key.substr(1));
                if (num > 1) {
                    var row = num - 2;
                    var typeVal = word + '|' + obj.v;
                    rows[row] = !rows[row] ? typeVal : rows[row] + ',' + typeVal;
                }
            });

        });
        var addItems = new Array();
        var arrItems = new Array();
        for (var i = 0; i < rows.length; i++) {
            var objRec = new Object();
            var record = rows[i];
            var recordArr = record.split(',');
            for (var j = 0; j < recordArr.length; j++) {
                var item = recordArr[j];
                var typ = item.split('|')[0];
                var val = item.split('|')[1];
                objRec[transToField(typ)] = val;
            }
            arrItems.push(objRec);
        }
        addItems.push(arrItems);
        console.log(addItems);
        $cm({
            ClassName: 'NurMp.Common.Logic.Handler',
            MethodName: 'Save',
            ClsName: 'CT.NUR.EMR.Zscores',
            Param: JSON.stringify(arrItems)
        }, function (result) {
            $.messager.progress("close");
            if (result.status >= 0) {
                $.messager.popover({ msg: "����ɹ�!", type: "success" });
                reloadGrid();
            } else {
                $.messager.popover({ msg: "����ʧ�ܣ�", type: "error" });
                return;
            }
        });
    };
}
/**
 * @description: ת��
 */
function transToField(word) {
    switch (word) {
        case 'A': return 'ZSSex'; break;
        case 'B': return 'ZSAge'; break;
        case 'C': return 'ZSL'; break;
        case 'D': return 'ZSM'; break;
        case 'E': return 'ZSS'; break;
        case 'F': return 'ZSN3SD'; break;
        case 'G': return 'ZSN2SD'; break;
        case 'H': return 'ZSN1SD'; break;
        case 'I': return 'ZS0SD'; break;
        case 'J': return 'ZSP1SD'; break;
        case 'K': return 'ZSP2SD'; break;
        default: return 'ZSP3SD'; break;
    }
}
/**
 * @description: ��Χ���շ���
 */
function contrast() {

}
/**
 * @description: �¼�
 */
function listenEvent() {

}
