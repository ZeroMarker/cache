/*
 * @Descripttion: 自定义角色配置
 * @Author: yaojining
 * @Date: 2022-05-23 09:13:29
 */
var GLOBAL = {
    HospEnvironment: true,
    HospitalID: session['LOGON.HOSPID'],
    TableClass: 'CF.NUR.EMR.RoleDef',
    ConfigTableName: 'Nur_IP_RoleDef',
    ClassName: 'NurMp.Common.Base.User',
    EditGrid: '#gridRole'
};
var init = function () {
    initHosp(reload);
    initConditon();
    initDataGrid();
    listenEvents();
}

$(init);
/**
* @description: 查询条件
*/
function initConditon() {
    $('#cbType').combobox({
        url: $URL + "?ClassName=NurMp.Common.Tools.Utils&QueryName=FindListItems&ClsName=CF.NUR.EMR.RoleDef&PropertyName=RDType&ExpStr=A&ResultSetType=array",
        valueField: 'Id',
        textField: 'Desc',
        value: 'A',
        panelHeight: 160,
        editable: false,
        defaultFilter: 4,
        onSelect: reload
    });
    $('#sbName').searchbox({
        searcher: reload
    });
}

/**
* @description: 初始化表格
*/
function initDataGrid() {
    var toolbar = [{
        id: 'add',
        iconCls: 'icon-add',
        text: '新增',
        handler: function (e) {
            openDialog(e, '', '');
        }
    }, {
        id: 'modify',
        iconCls: 'icon-write-order',
        text: '修改',
        handler: function (e) {
            var rowData = $(GLOBAL.EditGrid).datagrid('getSelected');
            openDialog(e, '', rowData);
        }
    }, {
        id: 'delete',
        iconCls: 'icon-cancel',
        text: '删除',
        handler: remove
    }];
    $(GLOBAL.EditGrid).datagrid({
        url: $URL,
        queryParams: {
            ClassName: GLOBAL.ClassName,
            QueryName: 'FindRoles',
            HospDr: GLOBAL.HospitalID,
            TableName: GLOBAL.TableName,
            Type: $('#cbType').combobox('getValue'),
            NameFilter: $('#sbName').searchbox('getValue')
        },
        columns: [[
            { field: 'RDName', title: '名称', align: 'left', width: 200 },
            { field: 'RDTypeDesc', title: '类别', width: 100, align: 'center' },
            { field: 'RDPointDesc', title: '指向', width: 600, align: 'left' },
            { field: 'RDRemark', title: '备注', width: 350 },
            { field: 'RDDisable', title: '状态', width: 50, formatter: formatStatus },
            { field: 'RDType', title: '类别代码', width: 100, hidden: true },
            { field: 'RDPoint', title: '指向', width: 200, hidden: true },
            { field: 'RowID', title: 'RowID', width: 100, hidden: true }
        ]],
        rowStyler: function (rowIndex, rowData) {
            if (rowData.RDDisable == 'Y') {
                return 'color:gray';
            }
        },
        toolbar: toolbar,
        nowrap: false,
        singleSelect: true,
        pagination: true,
        pageSize: 15,
        pageList: [15, 30, 50],
        onDblClickRow: function (rowIndex, rowData) {
            var event = { currentTarget: { id: 'dbclick' } };
            openDialog(event, rowIndex, rowData);
        }
    });
}
/**
* @description: 格式化
*/
function formatStatus(value, row, index) {
    var iconCls = 'grid-cell-icon icon-accept';
    if (value == 'Y') {
        iconCls = 'grid-cell-icon icon-unuse';
    }
    return '<span class="' + iconCls + '">&nbsp&nbsp&nbsp&nbsp</span>'
}
/**
* @description: 打开Dialog
*/
function openDialog(e, rowIndex, rowData) {
    var title = "修改";
    var iconCls = "icon-w-edit";
    var formData = {
        RDName: '',
        RDType: 'G',
        RDPoint: [],
        RDRemark: '',
        RDDisalbe: 'N',

    };
    if (e.currentTarget.id == 'add') {
        title = '新增';
        iconCls = "icon-w-add";
    } else {
        if (!rowData) {
            $.messager.alert("提示", "请选择要修改的数据！", "info");
            return;
        }
        var copyrowdata = copy(rowData);
        copyrowdata.RDPoint = rowData.RDPoint.split(',');
        formData = copyrowdata;
    }
    $('#add-form').form("clear");
    $("#add-dialog").dialog({
        title: title,
        iconCls: iconCls,
        resizable: true,
        onOpen: function () {
            onDialogOpen(formData);
        }
    }).dialog('open');
}
/**
* @description: 对象拷贝
*/
function copy(obj) {
    var objcopy = {};
    for (key in obj) {
        objcopy[key] = obj[key];
    }
    return objcopy;
}
/**
* @description: Dialog打开
*/
function onDialogOpen(formData) {
    buildType(formData);
    buildPoint(formData.RDType, formData.RDPoint);
    $('#add-form').form('load', formData);
    if (formData.RDDisable == 'Y') {
        $('#RDDisable').checkbox('setValue', true);
    }
    $('#RDName').focus();
}
/**
* @description: 类别
*/
function buildType() {
    $('#RDType').combobox({
        url: $URL + "?ClassName=NurMp.Common.Tools.Utils&QueryName=FindListItems&ClsName=CF.NUR.EMR.RoleDef&PropertyName=RDType&ResultSetType=array",
        valueField: 'Id',
        textField: 'Desc',
        panelHeight: 150,
        defaultFilter: 4,
        onSelect: function (record) {
            buildPoint(record.Id, '');
        }
    });
}
/**
* @description: 指向
*/
function buildPoint(rdtype, rdpoint) {
    $('#RDPoint').combobox('clear');
    var url = '';
    if (rdtype == 'G') {
        url = $URL + "?ClassName=" + GLOBAL.ClassName + "&QueryName=FindUserGroup&HospDr=" + GLOBAL.HospitalID + "&TableName=" + GLOBAL.ConfigTableName + "&ResultSetType=array";
    } else if (rdtype == 'L') {
        url = $URL + "?ClassName=NurMp.Common.Base.Loc&MethodName=GetLocs&HospitalID=" + GLOBAL.HospitalID + "&KeyWords=Id^Desc&ConfigTableName=" + GLOBAL.ConfigTableName;
    } else if (rdtype == 'P') {
        url = $URL + "?ClassName=NurMp.Common.Base.User&QueryName=FindUsers&HospDr=" + GLOBAL.HospitalID + "&TableName=" + GLOBAL.ConfigTableName + "&ResultSetType=array";
    } else {
        url = '';
    }
    if (!!url) {
        $('#RDPoint').combobox({
            url: url,
            valueField: 'Id',
            textField: 'Desc',
            multiple: true,
            hasDownArrow: true,
            panelHeight: 300,
            defaultFilter: 4,
            formatter: function (row) {
                var rhtml;
                var pId = String(row.Id);
                if ((rdpoint.length > 0) && ($.inArray(pId, rdpoint) > -1)) {
                    rhtml = row.Desc + "<span id='i" + pId + "' class='icon icon-ok'></span>";
                } else {
                    rhtml = row.Desc + "<span id='i" + pId + "' class='icon'></span>";
                }
                return rhtml;
            },
            onChange: function (newval, oldval) {
                $(this).combobox("panel").find('.icon').removeClass('icon-ok');
                for (var i = 0; i < newval.length; i++) {
                    $(this).combobox("panel").find('#i' + newval[i]).addClass('icon-ok');
                }
            }
        });
    } else {
        $('#RDPoint').combobox({
            hasDownArrow: false,
            panelHeight: 0,
        });
    }
}
/**
* @description: 删除
*/
function remove() {
    var rows = $(GLOBAL.EditGrid).datagrid('getSelections');
    if (rows.length < 1) {
        $.messager.alert("提示", "请选择要删除的角色！", "info");
        return;
    }
    var ids = '';
    $.each(rows, function (index, row) {
        ids = !!ids ? ids + '^' + row.RowID : row.RowID;
    });
    $.messager.confirm("提示", "请确保此角色没有被其它地方引用！确定要删除选中的角色吗?", function (r) {
        if (r) {
            $cm({
                ClassName: 'NurMp.Common.Logic.Handler',
                MethodName: "Delete",
                ClsName: GLOBAL.TableClass,
                Ids: ids
            }, function (result) {
                if (result.status >= 0) {
                    $.messager.popover({ msg: result.msg, type: "success" });
                    reload();
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
    var arrItems = new Array();
    var objElement = serializeForm('add-form');
    var nullColumn = '';
    if ((!nullColumn) && (!objElement["RDName"])) {
        nullColumn = '名称';
    }
    if ((!nullColumn) && (((objElement['RDType']!='I') && (!objElement["RDPoint"])) || ((objElement['RDType']=='I') && ($('#RDPoint').combobox('getText') == '')))) {
        nullColumn = '指向';
    }
    if (!!nullColumn) {
        $.messager.alert("提示", nullColumn + "不能为空！", "info");
        return;
    }
    var existId = verifyRecord('RDName', objElement['RDName']);
    if ((!!existId) && (objElement['RowID'] != existId)) {
        $.messager.alert("提示", "名称已经存在！", "info");
        return;
    }
    if (objElement['RDType']=='I') {
        objElement["RDPoint"] = $('#RDPoint').combobox('getText');
    }
    objElement["RDHospDr"] = GLOBAL.HospitalID;
    arrItems.push(objElement);
    $cm({
        ClassName: 'NurMp.Common.Logic.Handler',
        MethodName: 'Save',
        ClsName: GLOBAL.TableClass,
        Param: JSON.stringify(arrItems)
    }, function (result) {
        if (result.status >= 0) {
            $.messager.popover({ msg: "保存成功！", type: "success" });
            $("#add-dialog").dialog("close");
            $(GLOBAL.EditGrid).datagrid('reload');
        } else {
            $.messager.popover({ msg: result, type: "error" });
        }
    });
}
/**
* @description: 验证是否重复
*/
function verifyRecord(prop, value) {
    var id = '';
    var rows = $(GLOBAL.EditGrid).datagrid('getRows');
    $.each(rows, function (index, row) {
        var desc = row[prop];
        if (desc == value) {
            id = row.RowID;
            return false;
        }
    });
    return id;
}

/**
 * @description 获取指定form中的所有的<input>对象   
 */
function getElements(formId) {
    var form = document.getElementById(formId);
    var elements = [];
    var tagElements = form;   //  .getElementsByTagName('input');
    for (var j = 0; j < tagElements.length; j++) {
        if ((tagElements[j].type == 'radio') && (tagElements[j].checked == false)) {
            continue;
        }
        elements.push(tagElements[j]);
    }
    return elements;
}
/**
 * @description 序列化form元素 
 */
function serializeForm(formId) {
    var obj = {};
    var elements = getElements(formId);
    for (var i = 0; i < elements.length; i++) {
        if (elements[i].name == '') {
            continue;
        }
        if (elements[i].type == "checkbox") {
            var ckVal = elements[i].checked ? "Y" : "N";
            obj[elements[i].name] = ckVal;
        } else {
            if (elements[i].name == 'RDPoint') {
                obj[elements[i].name] = !!obj[elements[i].name] ? obj[elements[i].name] + ',' + elements[i].value : elements[i].value;
            } else {
                obj[elements[i].name] = elements[i].value;
            }
        }
    }
    return obj;
}
/**
 * @description: 刷新
 */
function reload() {
    $(GLOBAL.EditGrid).datagrid('reload', {
        ClassName: GLOBAL.ClassName,
        QueryName: 'FindRoles',
        HospDr: GLOBAL.HospitalID,
        TableName: GLOBAL.TableName,
        Type: $('#cbType').combobox('getValue'),
        NameFilter: $('#sbName').searchbox('getValue')
    });
}
function listenEvents() {

}
