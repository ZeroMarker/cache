/*
 * @Descripttion: ǩ���㼶����
 * @Author: yaojining
 * @Date: 2022-01-25 09:13:29
 */
var GLOBAL = {
    HospEnvironment: true,
    HospitalID: session['LOGON.HOSPID'],
    ConfigTableName: 'Nur_IP_SignRule',
    EditGrid: '#gridGrade',
    ClassName: 'NurMp.Service.Template.Authority'
};
var init = function () {
    initHosp(function () {
        setDefaultSign(reloadGridGrade);
    });
    setDefaultSign(initGridGrade);
    listenEvents();
}

$(init);

/**
* @description: ��ʼ�����ұ��
*/
function initGridGrade() {
    $cm({
        ClassName: "NurMp.Service.Patient.List",
        QueryName: "FindUserGroup",
        HospitalID: GLOBAL.HospitalID,
        TableName: GLOBAL.ConfigTableName,
        ResultSetType: 'array'
    }, function (jsonData) {
        var objData = {};
        $.each(jsonData, function (index, json) {
            objData[json.Id] = json.GroupDesc;
        });
        initData(jsonData, objData);
    });
}
/**
* @description: ��������
*/
function initData(jsonData, objData) {
    var toolbar = [{
        id: 'addGrade',
        iconCls: 'icon-add',
        text: '����',
        handler: function (e) {
            openDialog(e, '', '', '����^icon-w-add');
        }
    }, {
        id: 'modGrade',
        iconCls: 'icon-write-order',
        text: '�޸�',
        handler: function (e) {
            var rowData = $(GLOBAL.EditGrid).datagrid('getSelected');
            openDialog(e, '', rowData, '�޸�^icon-w-edit');
        }
    }, {
        id: 'delGrade',
        iconCls: 'icon-cancel',
        text: 'ɾ��',
        handler: delGrade
    }];
    $('#gridGrade').datagrid({
        url: $URL,
        queryParams: {
            ClassName: GLOBAL.ClassName,
            QueryName: 'FindSignRule',
            HospitalID: GLOBAL.HospitalID,
            Filter: ''
        },
        columns: [[
            { field: 'SRDesc', title: '����', align: 'left', width: 200 },
            { field: 'SRCharacter', title: '�����', width: 80, align: 'center' },
            { field: 'SRNum', title: '����', width: 80, align: 'center' },
            { field: 'SRRoleDesc', title: '��ɫ/�ӿ�', width: 600 },
            { field: 'SRStop', title: '״̬', width: 50, align: 'center', formatter: formatStatus },
            { field: 'SREditable', title: '�Ƿ�ɸ���', width: 80, hidden: true },
            { field: 'SRRole', title: '��ɫID', width: 300, hidden: true },
            { field: 'SRRolePoint', title: '��ɫָ��', width: 300, hidden: true },
            { field: 'RowID', title: 'RowID', width: 100, hidden: true }
        ]],
        rowStyler: function (rowIndex, rowData) {
            if (rowData.SREditable == 'N') {
                return 'color:gray';
            }
        },
        view: scrollview,
        toolbar: toolbar,
        nowrap: false,
        singleSelect: true,
        pagination: true,
        pageSize: 15,
        pageList: [15, 30, 50],
        detailFormatter: detailFormatter,
        onDblClickRow: function (rowIndex, rowData) {
            var event = { currentTarget: { id: 'dbclick' } };
            openDialog(event, rowIndex, rowData, '�޸�^icon-w-edit');
        }
    });
}
/**
* @description: ��ʽ��
*/
function formatStatus(value, row, index) {
    var iconCls = 'grid-cell-icon icon-accept';
    if (value == 'Y') {
        iconCls = 'grid-cell-icon icon-unuse';
    }
    return '<span class="' + iconCls + '">&nbsp&nbsp&nbsp&nbsp</span>'
}
/**
* @description: ������
*/
function detailFormatter(rowIndex, rowData) {
    var table = '<table>';
    var tr = '';
    var role = rowData.SRRole;
    if (rowData.SREditable == 'N') {
        tr += '<tr><td style="border:0;padding:0 20px;color:red;">Ĭ�Ϲ��򣬲����޸ġ�</td></tr>';
    } else {
        if (!!role) {
            if (rowData.SRDefType == 'R') {
                var num = rowData.SRNum;
                var roledescArr = rowData.SRRoleDesc.split(',');
                var rolePointArr = rowData.SRRolePoint.split('^');
                for (var i = 0; i < num; i++) {
                    if ((!!roledescArr[i]) && (!!rolePointArr[i])) {
                        var tdrole = roledescArr[i] + '��' + rolePointArr[i];
                    } else {
                        var tdrole = '<span style="color:red;">����"�Զ����ɫ����"���Ƿ�ɾ����ͣ��������ʹ�õĽ�ɫ!</span>';
                    }
                    tr += '<tr><td style="border:0;padding:0 20px;color:#1963aa;">' + tdrole + '</td></tr>';
                }
            } else {
                var tdrole = "�Զ���ӿڣ�" + rowData.SRRoleDesc;
                tr += '<tr><td style="border:0;padding:0 20px;color:#1963aa;">' + tdrole + '</td></tr>';
            }
        } else {
            tr += '<tr><td style="border:0;padding:0 20px;color:#1963aa;">��</td></tr>';
        }
    }
    table += tr + '</table>';
    return table;
}
/**
* @description: ��Dialog
*/
function openDialog(e, rowIndex, rowData, titleicon) {
    var status = $("#add-dialog").parent().is(":hidden");
    if (!status) {
        $("#add-dialog").dialog('close');
    }
    var tis = titleicon.split('^');
    var title = tis[0];
    var iconCls = tis[1];
    var formData = {
        SRCharacter: '=',
        SRNum: '1',
        SRDefType: 'R',
        SREditable: 'Y',
        SRStop: 'N'
    };
    if (e.currentTarget.id != 'addGrade') {
        if (!rowData) {
            $.messager.alert("��ʾ", "��ѡ��Ҫ�޸ĵ����ݣ�", "info");
            return;
        }
        if (rowData.SREditable == 'N') {
            $.messager.alert("��ʾ", "Ĭ�����ݣ��������޸ģ�", "info");
            return;
        }
        formData = rowData;
    }
    $('#add-form').form("clear");
    $("#add-dialog").dialog({
        title: title,
        iconCls: iconCls,
        resizable: true,
        height: resetDialogSize(formData),
        onOpen: function () {
            onDialogOpen(formData);
            setTimeout(function () {
                $('#SRDesc').focus();
                setRoleValue(formData);
            }, 200);
        }
    }).dialog('open');
}
/**
* @description: Dialog��
*/
function onDialogOpen(formData) {
    $('#add-form').form('load', formData);
    // $('.comborole').combogrid('clear');
    $(".trrole").hide();
    $(".trinter").hide();
    // radioԪ�ص�����ֵ
    $("[name='SRCharacter'][value='" + formData.SRCharacter + "']").radio('setValue', true);
    $("[name='SRNum'][value=" + formData.SRNum + "]").radio('setValue', true);
    if (formData.SRCharacter == '=') {
        if ($("#SRDefType").combobox('getValue') == 'R') {
            $(".trrole:lt(" + (formData.SRNum) + ")").show();
        } else {
            $(".trinter").show();
        }
    } else {
		$(".trinter").show();
	}
    if (formData.SRStop == 'Y') {
        $('#SRStop').checkbox('setValue', true);
    }
    buildComboRole();
}
/**
* @description: ��������dialog�ߴ�
*/
function resetDialogSize(formData) {
    var dialogHeight = 332;
    var trHeight = 42;
    var srNum = (formData.SRCharacter == '=') && (!!formData.SRNum) ? parseInt(formData.SRNum) : 0;
    if (srNum > 0) {
	    if (formData.SRDefType == 'R') {
			dialogHeight = dialogHeight + (trHeight * srNum);
		} else {
			dialogHeight = dialogHeight + trHeight;
		}
        
    }else {
		dialogHeight = dialogHeight + trHeight;
	}
    return dialogHeight;
}
/**
* @description: ��ɫ�������
*/
function buildComboRole(formData) {
    $('.comborole').combogrid({
        url: $URL,
        queryParams: {
            ClassName: "NurMp.Common.Base.User",
            QueryName: "FindRoles",
            rows: 1000,
            HospDr: GLOBAL.HospitalID,
            TableName: GLOBAL.ConfigTableName
        },
        columns: [[
            { field: 'RDName', title: '����', width: 150 },
            { field: 'RDTypeDesc', title: '���', width: 60 },
            { field: 'RDPointDesc', title: 'ָ��', width: 300, showTip: true, tipWidth: 450 },
            { field: 'RDRemark', title: '��ע', width: 120 },
            { field: 'RDDisable', title: '״̬', width: 50, hidden: true },
            { field: 'RowID', title: 'ID', width: 50, hidden: true },
        ]],
        mode: 'remote',
        idField: 'RowID',
        textField: 'RDName',
        pagination: false,
        panelWidth: 640,
        panelHeight: 300,
        delay: 500,
        enterNullValueClear: true,
        onBeforeLoad: function (param) {
            var desc = "";
            if (param['q']) {
                desc = param['q'];
            }
            param = $.extend(param, { HospDr: GLOBAL.HospitalID, TableName: GLOBAL.ConfigTableName, NameFilter: desc });
            return true;
        },
        loadFilter: function (data) {
            //��������
            var value = {
                total: data.total,
                rows: []
            };
            var x = 0;
            for (var i = 0; i < data.rows.length; i++) {
                if (data.rows[i].RDDisable != 'Y') {
                    value.rows[x++] = data.rows[i];
                }
            }
            return value;
        }
    });
}
/**
* @description: ��ɫ��ֵ
*/
function setRoleValue(formData) {
    if (!!formData.SRRole) {
        if (formData.SRDefType == 'R') {
            var arrRole = formData.SRRole.split(',');
            $.each(arrRole, function (index, role) {
                $('#SRRole_' + (index + 1)).combogrid('setValue', role);
            });
        } else {
            $('#SRInter').val(formData.SRRole);
        }
    }
}
/**
* @description: ɾ��
*/
function delGrade() {
    var grades = $(GLOBAL.EditGrid).datagrid('getSelections');
    if (grades.length < 1) {
        $.messager.alert("��ʾ", "��ѡ��Ҫɾ�������ݣ�", "info");
        return;
    }
    var edFlag = 'Y';
    var ids = null;
    $.each(grades, function (index, grade) {
        if (grade.SREditable == 'N') {
            edFlag = 'N';
            return true;
        }
        ids = !!ids ? ids + '^' + grade.RowID : grade.RowID;
    });
    if (edFlag == 'N') {
        $.messager.alert("��ʾ", "Ĭ�����ݲ������޸Ļ�ɾ����", "info");
        return;
    }
    $.messager.confirm("��ʾ", "ȷ��ɾ��ѡ�еļ�¼��?", function (r) {
        if (r) {
            $cm({
                ClassName: 'NurMp.Common.Logic.Handler',
                MethodName: "Delete",
                ClsName: 'CF.NUR.EMR.SignRule',
                Ids: ids
            }, function (result) {
                if (result.status >= 0) {
                    $.messager.popover({ msg: result.msg, type: "success" });
                    reloadGridGrade();
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
function saveGrade() {
    var arrItems = new Array();
    var objElement = serializeForm('add-form');
    var nullColumn = '';
    if ((!nullColumn) && (!objElement["SRDesc"])) {
        nullColumn = '��������';
    }
    if (!!nullColumn) {
        $.messager.alert("��ʾ", nullColumn + "����Ϊ�գ�", "info");
        return;
    }
    var existId = verifyRecord('SRDesc', objElement['SRDesc']);
    if ((!!existId) && (objElement['RowID'] != existId)) {
        $.messager.alert("��ʾ", "���������Ѿ����ڣ�", "info");
        return;
    }
    if (!objElement["SRRole"]) {
        objElement["SRRole"] = '';
    }
    if (!!objElement["SRInter"]) {
        objElement["SRRole"] = objElement["SRInter"];
    }
    objElement["SRHospDr"] = GLOBAL.HospitalID;
    objElement["SREditable"] = 'Y';
    arrItems.push(objElement);
    $cm({
        ClassName: 'NurMp.Common.Logic.Handler',
        MethodName: 'Save',
        ClsName: 'CF.NUR.EMR.SignRule',
        Param: JSON.stringify(arrItems)
    }, function (result) {
        if (result.status >= 0) {
            $.messager.popover({ msg: "����ɹ���", type: "success" });
            $("#add-dialog").dialog("close");
            $(GLOBAL.EditGrid).datagrid('reload');
        } else {
            $.messager.popover({ msg: result, type: "error" });
        }
    });
}
/**
* @description: ��֤�Ƿ��ظ�
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
 * @description: ����Ĭ��ֵ
 */
function setDefaultSign(func) {
    $m({
        ClassName: 'NurMp.Service.Template.Authority',
        MethodName: 'SetDefaultSign',
        HospitalId: GLOBAL.HospitalID
    }, function (result) {
        if (typeof func == 'function') {
            func();
        }
    });
}

/**
 * @description ��ȡָ��form�е����е�<input>����   
 */
function getElements(formId) {
    var form = document.getElementById(formId);
    var elements = [];
    var interFlag = 0
    var tagElements = form.getElementsByTagName('input');
    for (var j = 0; j < tagElements.length; j++) {
        if ((tagElements[j].type == 'radio') && (tagElements[j].checked == false)) {
            continue;
        }
        if (($(tagElements[j]).attr('class') == 'comborole combogrid-f combo-f') || ($(tagElements[j]).attr('class') == 'hisui-combobox cb combobox-f combo-f') || ($(tagElements[j]).attr('class') == 'combo-text validatebox-text')) {
            continue;
        }
        if ((tagElements[j].name.indexOf('SRRole') > -1) || (tagElements[j].name.indexOf('SRDefType') > -1) || (tagElements[j].name.indexOf('SRInter') > -1)) {
            var elementId = tagElements[j].name;
            var cssDisplay = $("#" + elementId).parent().parent().css('display');
            if (cssDisplay == 'none') {
                continue;
            }
            tagElements[j]['id'] = elementId;
        }
        elements.push(tagElements[j]);
    }

    return elements;
}
/**
 * @description ���л�formԪ�� 
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
            if (elements[i].id.indexOf('SRRole') > -1) {
                obj['SRRole'] = !!obj['SRRole'] ? obj['SRRole'] + ',' + elements[i].value : elements[i].value;
            } else {
                obj[elements[i].name] = elements[i].value;
            }
        }
    }
    return obj;
}
/**
 * @description: ˢ��
 */
function reloadGridGrade() {
    $('#gridGrade').datagrid('reload', {
        ClassName: GLOBAL.ClassName,
        QueryName: 'FindSignRule',
        HospitalID: GLOBAL.HospitalID,
        Filter: ''
    });
}
/**
 * @description: ���óߴ�
 */
function resizeDialog() {
    var dgrowData = serializeForm('add-form');
    var dgtitle = $('#add-dialog').panel('options').title;
    var dgevent = { currentTarget: { id: 'resize' } };
    var dgicon = dgtitle == '����' ? 'icon-w-add' : 'icon-w-edit';
    openDialog(dgevent, '', dgrowData, dgtitle + '^' + dgicon);
}
function listenEvents() {
    $("[name='SRCharacter']").radio({
        onChecked: function (e, value) {
            if (($(e.target).val() == '>=')) {
                $(".trrole").hide();
                $('.trinter').show();
                $("#SRDefType").combobox('select', 'I');
                $("#SRDefType").combobox('disable');
            } else {
                $("#SRDefType").combobox('enable');
                $("#SRDefType").combobox('select', 'R');
                if ($("#SRDefType").combobox('getValue') == 'R') {
                    var index = $("input[name='SRNum']:checked").val();
                    $(".trrole:lt(" + index + ")").show();
                } else {
                    $(".trrole:lt(1)").show();
                    $('#SRRole_1').combobox('clear');
                }
            }
            resizeDialog();
        }
    });
    $("[name='SRNum']").radio({
        onChecked: function (e, value) {
            if (($("input[name='SRCharacter']:checked").val() == '=') && ($("#SRDefType").combobox('getValue') == 'R')) {
                $(".trrole").hide();
                var index = $(e.target).val();
                $(".trrole:lt(" + index + ")").show();
                // dialog�ߴ�����
                resizeDialog();
            }
        }
    });
    $("#SRDefType").combobox({
        valueField: 'id',
        textField: 'text',
        panelHeight: "auto",
        data: [
            { id: 'R', text: '��ɫ' },
            { id: 'I', text: '�ӿ�' }
        ],
        onSelect: function (record) {
            if (record.id == 'R') {
                $('.trinter').hide();
                var index = $("input[name='SRNum']:checked").val();
                $(".trrole:lt(" + index + ")").show();
            } else {
                $(".trrole").hide();
                $('.trinter').show();
            }
            resizeDialog();
        }
    });
}
