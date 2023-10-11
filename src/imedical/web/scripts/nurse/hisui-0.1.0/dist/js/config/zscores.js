/*
 * @Descripttion: Z值分数对照
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
        pt.onload(pt); //页面内data取pt.content文件内容
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
* @description: 查询条件
*/
function initCondition() {
    $('#cbSex').combobox({
        valueField: 'id',
        textField: 'desc',
        data: [
            { id: 'A', desc: '全部' },
            { id: 'M', desc: '男' },
            { id: 'W', desc: '女' }
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
* @description: 初始化科室表格
*/
function initGrid() {
    var toolbar = [{
        id: 'add',
        iconCls: 'icon-add',
        text: '新增',
        handler: add
    }, {
        id: 'remove',
        iconCls: 'icon-remove',
        text: '删除',
        handler: remove
    }, {
        id: 'save',
        iconCls: 'icon-save',
        text: '保存',
        handler: save
    }, {
        id: 'reset',
        iconCls: 'icon-reset',
        text: '刷新',
        handler: reloadGrid
    }, {
        id: 'import',
        iconCls: 'icon-import',
        text: '导入',
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
                field: 'ZSSex', title: '性别', width: 80,
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        required: false,
                        blurValidValue: true,
                        data: [
                            { value: 'M', desc: '男' },
                            { value: 'W', desc: '女' }
                        ]
                    }
                },
                formatter: function (value, row, index) {
                    if (value == 'W') {
                        return '女';
                    } else {
                        return '男';
                    }
                }
            },
            { field: 'ZSAge', title: '年龄', align: 'center', width: 100, editor: 'text' },
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
* @description: 新增
*/
function add() {
    append({ ZSSex: 'M' });
}
/**
* @description: 删除
*/
function remove() {
    var rows = $(GLOBAL.EditGrid).datagrid('getSelections');
    if (rows.length < 1) {
        $.messager.alert("提示", "请选择要删除的数据！", "info");
        return;
    }
    var ids = null;
    $.each(rows, function (index, row) {
        ids = !!ids ? ids + '^' + row.RowID : row.RowID;
    });
    $.messager.confirm("提示", "确定删除选中的记录吗?", function (r) {
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
* @description: 保存
*/
function save() {
    var addItems = getChanges();
    if (addItems.length == 0) {
        $.messager.alert("提示", "没有需要保存的数据！", "info");
        return;
    }
    var nullColumn = '';
    $.each(addItems, function (index, item) {
        if (item.ZSSex == '') {
            nullColumn = '性别';
            return false;
        }
        if (item.ZSAge == '') {
            nullColumn = '年龄';
            return false;
        }
    });
    if (!!nullColumn) {
        $.messager.alert("提示", nullColumn + "不能为空！", "info");
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
* @description: 验证是否重复
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
 * @description: 刷新
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
 * @description: 导入
 */
function importexcel() {
    $('#dgImport').dialog({
        title: '导入文件',
        width: 400,
        height: 150,
        modal: true,
        buttons: [{
            text: '导入',
            handler: importHandler,
        }, {
            text: '取消',
            handler: function () {
                $('#dgImport').dialog("close");
            }
        }]
    }).dialog('open');
}
/**
     * @description 导入 --兼容Chrome
     */
function importHandler() {
    var file = $('#ipfile').filebox('files')[0];
    var type = file.name.split('.');
    if (type[type.length - 1] !== 'xlsx' && type[type.length - 1] !== 'xls') {
        $.messager.popover({ msg: '请选择.xls、.xlsx格式的文件！', type: 'error' });
        return;
    }
    $('#dgImport').dialog("close");
    $.messager.progress({
        title: "提示",
        msg: '正在导入数据',
        text: '导入中....'
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
                $.messager.popover({ msg: "导入成功!", type: "success" });
                reloadGrid();
            } else {
                $.messager.popover({ msg: "导入失败！", type: "error" });
                return;
            }
        });
    };
}
/**
 * @description: 转换
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
 * @description: 范围对照分数
 */
function contrast() {

}
/**
 * @description: 事件
 */
function listenEvent() {

}
