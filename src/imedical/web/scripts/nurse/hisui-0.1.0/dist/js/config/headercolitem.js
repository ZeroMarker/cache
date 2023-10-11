/*
 * @Descripttion: �ɱ༭���̬��ͷ��Ĭ��ѡ��ά��
 * @Author: yaojining
 */
var GLOBAL = {
    HospEnvironment: true,
    HospitalID: session['LOGON.HOSPID'],
    UserID: session['LOGON.USERID'],
    ConfigTableName: 'Nur_IP_HeaderColItem',
    ClassName: 'NurMp.Service.Template.Header',
    EditGrid: '#item_table',
    Locs: new Array(),
    Models: new Array(),
    ArrModels: new Array()
};

$(function () {
    initHosp(function () {
        if (typeof reject == 'function') {
            reject();
        }
        requestComboData();
    });
    listenEvent();
});

/**
* @description: ��ȡ����
*/
function requestComboData() {
    $cm({
        ClassName: 'NurMp.Common.Base.Hosp',
        QueryName: 'FindHospLocs',
        HospitalID: GLOBAL.HospitalID,
        rows: 1000,
        ConfigTableName: GLOBAL.ConfigTableName
    }, function (locs) {
        GLOBAL.Locs = locs;
        $cm({
            ClassName: "NurMp.Service.Template.Directory",
            MethodName: "getTemplates",
            HospitalID: GLOBAL.HospitalID,
            TypeCode: 'L',
        }, function (models) {
            GLOBAL.Models = models;
            convertToArray(models);
            initGrid();
        });
    });
}

function convertToArray(obj) {
    $.each(obj, function(i, root) {
        $.each(root.children, function(j, leaf) {
            GLOBAL.ArrModels.push(leaf);
        });
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
    }];
    $(GLOBAL.EditGrid).datagrid({
        url: $URL,
        queryParams: {
            ClassName: GLOBAL.ClassName,
            QueryName: 'FindHearderColItems',
            HospitalID: GLOBAL.HospitalID,
        },
        columns: [[
            { field: 'CIDesc', title: '��ͷ����', width: 150, editor: 'text' },
            { field: 'CIItems', title: 'ѡ��', width: 500, editor: 'text' },
            {
                field: 'CILocID', title: '���ÿ���', width: 400,
                editor: {
                    type: 'combogrid',
                    options: {
                        //data: GLOBAL.Locs,
                        url: $URL,
						queryParams:{
					        ClassName: 'NurMp.Common.Base.Hosp',
					        QueryName: 'FindHospLocs',
					        HospitalID: GLOBAL.HospitalID,
					        rows: 1000,
					        ConfigTableName: GLOBAL.ConfigTableName
						},
                        mode: 'remote',
                        idField: 'LocId',
                        textField: 'LocDesc',
                        columns: [[
                            { field: 'Checkbox', title: 'sel', checkbox: true },
                            { field: 'LocDesc', title: '����', width: 250 },
                            { field: 'LocId', title: 'ID', width: 40 }
                        ]],
                        multiple: true,
                        fitColumns: true,
                        panelWidth: 400,
                        panelHeight: 420,
                        delay: 500,
                        enterNullValueClear: true,
                        blurValidValue: true,
                        onBeforeLoad:function(param){
							param = $.extend(param,{SearchDesc: param['q']});
							return true;
						},
						onSelect: function (rowIndex, rowData) {
//							var row = $(GLOBAL.EditGrid).datagrid('getSelected');
//	                        var rowIndex = $(GLOBAL.EditGrid).datagrid('getRowIndex', row);
//							var ed=$(GLOBAL.EditGrid).datagrid("getEditor",{index:rowIndex,field:'CIModelID'});
//							$(ed.target).combotree('tree').tree('clear');
						}
                    }
                },
                formatter: function (value, row, index) {
                    var result = '';
                    if ((!String(value)) || (typeof value == 'undefined')) {
                        return 'ȫԺ';
                    }
                    var arr = value.split(',');
                    $.each(arr, function (i, v) {
                        var t = $.hisui.getArrayItem(GLOBAL.Locs.rows, 'LocId', v);
                        if (!!t) {
                            result = !!result ? result + ',' + t.LocDesc : t.LocDesc;
                        }
                    });
                    return result;
                }
            },
            {
                field: 'CIModelID', title: '����ģ��', width: 400,
                editor: {
                    type: 'combotree',
                    options: {
                        data: GLOBAL.Models,
//                        loader: function (param, success, error) {
//	                        var row = $(GLOBAL.EditGrid).datagrid('getSelected');
//	                        var rowIndex = $(GLOBAL.EditGrid).datagrid('getRowIndex', row);
//	                        var ed=$(GLOBAL.EditGrid).datagrid("getEditor",{index:rowIndex,field:'CILocID'});
//	                        var oldHtml = ed.oldHtml;
//	                        var locIds = '';
//	                        var arr = oldHtml.split(',');
//	                        $.each(arr, function (i, d) {
//		                        var t = $.hisui.getArrayItem(GLOBAL.Locs.rows, 'LocDesc', d);
//		                        if (!!t) {
//		                        	locIds = !!locIds ? locIds + '^' + t.LocId : t.LocId;
//		                        }
//		                    });
//				            $cm({
//								ClassName: "NurMp.Service.Template.Directory",
//								MethodName: "getTemplates",
//								HospitalID: GLOBAL.HospitalID,
//								TypeCode: 'L',
//								LocID: locIds
//				            }, function (data) {
//				                success(data);
//				            });
//				        },
				        lines: true,
				       	panelHeight: 500,
                        delay: 500,
                        multiple: true,
                        editable: true,
//				        onBeforeLoad:function(node,param){
//							param = $.extend(param,{TemplateName: param['q']});
//							return true;
//						}
                    }
                },
                formatter: function (value, row, index) {
                    var result = '';
                    if ((!String(value)) || (typeof value == 'undefined')) {
                        return 'ȫ��';
                    }
                    var arr = value.split(',');
                    $.each(arr, function (i, v) {
                        var t = $.hisui.getArrayItem(GLOBAL.ArrModels, 'id', v);
                        if (!!t) {
                        	result = !!result ? result + ',' + t.text : t.text;
                        }
                    });
                    return result;
                }
            },
            { field: 'CIRemark', title: '��ע', width: 200, editor: 'text' },
            {
                field: 'CIStatusDR', title: '�Ƿ�����', width: 80,
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        required: false,
                        blurValidValue: true,
                        data: [
                            { value: 1, desc: '��' },
                            { value: 2, desc: '��' }
                        ]
                    }
                },
                formatter: function (value, row, index) {
                    if (value == '1') {
                        return '��';
                    } else {
                        return '��';
                    }
                }
            },
            { field: 'RowID', title: 'RowID', width: 100, hidden: false }
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
    append({ CIStatusDR: 1 });
}
/**
* @description: ɾ��
*/
function remove() {
    var rows = $(GLOBAL.EditGrid).datagrid('getSelections');
    if (rows.length < 1) {
        $.messager.alert('��ʾ', '��ѡ��Ҫɾ�������ݣ�', 'info');
        return;
    }
    var ids = null;
    $.each(rows, function (index, row) {
        ids = !!ids ? ids + '^' + row.RowID : row.RowID;
    });
    $.messager.confirm('��ʾ', 'ȷ��ɾ��ѡ�еļ�¼��?', function (r) {
        if (r) {
            $cm({
                ClassName: 'NurMp.Common.Logic.Handler',
                MethodName: 'Delete',
                ClsName: 'CF.NUR.EMR.HeaderColItem',
                Ids: ids
            }, function (result) {
                if (result.status >= 0) {
                    $.messager.popover({ msg: result.msg, type: 'success' });
                    reloadGrid();
                } else {
                    $.messager.popover({ msg: result.msg, type: 'error' });
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
        $.messager.alert('��ʾ', 'û����Ҫ��������ݣ�', 'info');
        return;
    }
    var nullColumn = '';
    var arrItems = new Array();
    $.each(addItems, function (index, item) {
        var objItem = new Object();
        objItem['RowID'] = item.RowID;
        if (!item.CIDesc) {
            nullColumn = '��ͷ����';
            return false;
        }
        objItem['CIDesc'] = item.CIDesc;
        if (!item.CIItems) {
            nullColumn = 'ѡ��';
            return false;
        }
        objItem['CIItems'] = item.CIItems;
        if (!item.CIStatusDR) {
            nullColumn = '״̬';
            return false;
        }
        objItem['CILocID'] = item.CILocID;
        objItem['CIModelID'] = item.CIModelID;
        objItem['CIStatusDR'] = item.CIStatusDR;
        objItem['CIRemark'] = item.CIRemark;
        objItem['CIHospDR'] = GLOBAL.HospitalID;
        objItem['CIUpdateUserDR'] = GLOBAL.UserID;
        arrItems.push(objItem);
    });
    if (!!nullColumn) {
        $.messager.alert('��ʾ', nullColumn + '����Ϊ�գ�', 'info');
        return;
    }
    if (!verifyRecord('CIDesc')) {
        $.messager.alert('��ʾ', '�����Ѿ����ڣ�', 'info');
        return;
    }
    $cm({
        ClassName: 'NurMp.Common.Logic.Handler',
        MethodName: 'Save',
        ClsName: 'CF.NUR.EMR.HeaderColItem',
        Param: JSON.stringify(arrItems)
    }, function (result) {
        if (result.status >= 0) {
            $.messager.popover({ msg: result.msg, type: 'success' });
            reloadGrid();
        } else {
            $.messager.popover({ msg: result.msg, type: 'error' });
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
    if (endEditing()) {
        $(GLOBAL.EditGrid).datagrid('reload', {
            ClassName: GLOBAL.ClassName,
            QueryName: 'FindHearderColItems',
            HospitalID: GLOBAL.HospitalID,
        });
    }
}

/**
 * @description: �¼�
 */
function listenEvent() {

}