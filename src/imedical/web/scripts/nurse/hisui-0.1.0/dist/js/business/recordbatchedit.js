/*
 * @Descripttion: 批量录入
 * @Author: yaojining
 * @Date: 2021-12-21 11:44:38
 */

var GV = {
    BaseFlag: true,
    SwitchInfo: new Object(),
    ArrSort: new Object(),
    PatNode: new Object(),
    TempNodeState: new Object(),
    HospitalID: session['LOGON.HOSPID'],
    LocID: session['LOGON.CTLOCID'],
    ClassName: 'NurMp.Service.Template.BathEdit',
    ConfigTableName: 'Nur_IP_BathEdit',
    EditModel: null,
    ModelInfo: new Object(),
    TransPage: 'nur.emr.business.recordbatchedit.csp',
    Steps: ['patlist']
}

/**
 * @description: 处理进度提示
 */
var MaskUtil = (function () {
    var $mask, $maskMsg;
    var defMsg = $g('正在处理，请稍后...');
    function init() {
        if (!$mask) {
            $mask = $("<div class=\"datagrid-mask mymask\"></div>").appendTo("body");
        }
        if (!$maskMsg) {
            $maskMsg = $("<div class=\"datagrid-mask-msg mymask\">" + defMsg + "</div>")
                .appendTo("body").css({ 'font-size': '12px' });
        }
        $mask.css({ width: "100%", height: $(document).height() });
        var scrollTop = $(document.body).scrollTop();
        $maskMsg.css({
            left: ($(document.body).outerWidth(true) - 190) / 2
            , top: (($(window).height() - 45) / 2) + scrollTop
        });
    }
    return {
        mask: function (msg) {
            init();
            $mask.show();
            $maskMsg.html(msg || defMsg).show();
        }
        , unmask: function () {
            $mask.hide();
            $maskMsg.hide();
        }
    }
}());

$(function () {
	if (typeof updateStyle == 'function') {
		updateStyle();
	}
    requestSwitch();
});

/**
 * @description: 获取开关配置数据
 */
function requestSwitch() {
    $cm({
        ClassName: 'NurMp.Service.Switch.Config',
        MethodName: 'GetSwitchValues',
        HospitalID: session['LOGON.HOSPID'],
        LocID: session['LOGON.CTLOCID'],
        GroupID: session['LOGON.GROUPID']
    }, function (switchInfo) {
        GV.SwitchInfo = switchInfo.Main;
        InnerNetDebug();
        initCondition();
        if (typeof requestPatient == 'function') {
			requestPatient();
		} else {
			if (typeof updateStep == 'function') {
				updateStep('patlist');
			}
		}
        loadModelTree();
        listenEvents();
    });
}

/**
* @description: 条件
*/
function initCondition() {
    var serverDateTime = getServerDateTime('Y-M-D');
    $('#batStartDate').dateboxq('setValue', serverDateTime.date);
    $('#batStartTime').timespinner('setValue', '07:00');
}

/**
 * @description: 初始化模板树
 */
function loadModelTree() {
    var cbtreeModel = $HUI.combotree('#cbtreeModel', {
        lines: true,
        panelWidth: 400,
        panelHeight: 500,
        delay: 500,
        onSelect: getModelInfo
    });
    $cm({
        ClassName: "NurMp.Service.Template.List",
        MethodName: "getTemplates",
        HospitalID: GV.HospitalID,
        LocID: GV.LocID,
        EpisodeID: EpisodeID,
        RangeFlag: "S",
        SearchInfo: '',
        SimpleFlag: 'true',
        Page: 'BatchEdit'
    }, function (data) {
        cbtreeModel.loadData(data);
        // 默认打开的表单
        //$('#cbtreeModel').combobox('select', 0);
    });
}
/**
 * @description: 获取model数据
 * @param {String} record
 */
function getModelInfo(record) {
    GV.ModelInfo = {};
    if (record.type != 'leaf') {
        $.messager.alert($g('提示'), $g('请选择表单!'), 'info');
        return;
    }
    if (!!record.linkModel.childRefId) {
        GV.EditModel = record.linkModel.childGuid;
    } else {
        GV.EditModel = record.guid;
    }
    $cm({
        ClassName: GV.ClassName,
        MethodName: 'ParseModelXml',
        LocId: GV.LocID,
        Guid: record.guid
    }, function (structModel) {
        GV.ModelInfo = structModel;
        createTable();
    });
}
/**
 * @description: 创建动态表格
 */
function createTable() {
    $('#tbContent').empty();
    var toolbar = [{
        id: 'editAccept',
        iconCls: 'icon-ok',
        text: '提交',
        handler: update
    }, {
        id: 'editCancel',
        iconCls: 'icon-reset',
        text: '撤销',
        handler: cancel
    }, {
        id: 'editVoid',
        iconCls: 'icon-cancel',
        text: '作废',
        handler: abot
    }];
    $('#tbContent').append('<table id="' + GV.ModelInfo.TableId + '" class="hisui-datagrid"></table>');
    var updateVerifyRelatedSignField = !!GV.ModelInfo.updateVerifyRelatedSignField ? GV.ModelInfo.updateVerifyRelatedSignField : '';
    $('#' + GV.ModelInfo.TableId).datagrid({
        url: $URL,
        queryParams: {
            ClassName: "NurMp.Service.Template.BathEdit",
            MethodName: "GetGridData",
            DataArr: JSON.stringify(packData())
        },
        fit: true,
        idField: 'ID',
        cellEdit: true,
        toolbar: toolbar,
        headerCls: 'panel-header-gray',
        nowrap: false,
        singleSelect: true,
        columns: GV.ModelInfo.Columns,
        resizable: true,
        updateVerifyRelatedSignField: updateVerifyRelatedSignField,
        clickToEdit: true,
        onLoadSuccess: function (data) {
            OnHisUITableLoadSuccess(data);
            setDefaultVal();
        },
        onSelect: OnHisUITableRowSelect,
        onUnselect: OnHisUITableRowUnSelect,
        onRowContextMenu: OnHisUITableRowContextMenu,
        onBeforeCellEdit: beforeCellEdit,
        onCellEdit: cellEdit,
        onCellEnterHandler: cellEnterHandler,
        onBeginEdit: beginEdit,
        onCellDirectHandler: cellDirectHandler
    }).datagrid('enableCellEditing');
    columnFormatter();
}
/**
 * @description: 列格式化
 */
function columnFormatter() {
    if (typeof GV.ModelInfo.TableId == 'undefined') {
        return;
    }
    AddHisuiEditors(GV.ModelInfo.TableId);
    $.each(GV.ModelInfo.Columns[0], function (index, column) {
        $('#' + GV.ModelInfo.TableId).datagrid('getColumnOption', column.field).formatter = function (value, row, index) {
            return OnHisuiColumnFormatter(value, this, row, GV.ModelInfo.TableId);
        }
        if (!!column.editor) {
            if (!!column.editor.options) {
                if (!!column.editor.options.ID) {
                    var eventField = column.editor.options.ID;
                    if (!!column.editor.options.DefaultValue) {
                        AddCellEditDefault(eventField, column.editor.options.DefaultValue);
                    }
                    if ((!!column.editor.options.Signature) || (!!column.editor.options.FoundationJS)) {
                        window[eventField] = function () {
                            if (!!column.editor.options.Signature) {
                                $('#' + eventField).on('blur', function () {
                                    ElementUtility.TextElement.banding(eventField, $(this).attr('SignatureFullVal'));
                                });
                                $('#' + eventField).on('focus', function () {
                                    $(this).val('');
                                });
                                $('#' + eventField).on('input', function () {
                                    RestrictNumerical($(this));
                                });
                                $('#' + eventField).keydown(function (event) {
                                    if (event.keyCode == 13) {
                                        JobNumEnterToName($(this), false);
                                    }
                                    if (event.keyCode == 46) {
                                        ClearSign($(this));
                                    }
                                });
                            }
                            if (!!column.editor.options.FoundationJS) {
                                RefHandler(eventField, true, true, true);
                            }
                            if (!!column.editor.options.DefaultValue) {
                                SetOneValue(eventField, column.editor.options.DefaultValue);
                            }
                        }
                    }
                }
            }
        }
    });
}

/**
 * @description: 多选病人方法
 * @param {object} node
 */
function customCheckPatient(node) {
    reloadModelGrid();
}

/**
 * @description: 重新加载模板表格
 */
function reloadModelGrid() {
    $('#' + GV.ModelInfo.TableId).datagrid('reload', {
        ClassName: "NurMp.Service.Template.BathEdit",
        MethodName: "GetGridData",
        DataArr: JSON.stringify(packData())
    });
    columnFormatter();
}
/**
 * @description: 设置默认值
 */
function setDefaultVal() {
    var newRowData = {};
    $.each(window.HisuiEditors[GV.ModelInfo.TableId].DefaultExpr, function (k, v) {
        var t = "";
        if (/^Func/.test(v)) {
            t = v.slice(5);
            if (t == "GetTableEditDataSourceRefDefaultValue") {
                var identity = "edit" + tableID + "_" + k;
                newRowData[k] = GetTableEditDataSourceRefDefaultValue(identity);
            }
            else
                newRowData[k] = window[t]();
        }
        else if (/^Text/.test(v)) {
            t = v.slice(5);
            newRowData[k] = t;
        }
        else {
            if ($.isPlainObject(v)) {
                newRowData[k] = v.values;
            } else {
                newRowData[k] = v;
            }
        }
    });
    var rows = $('#' + GV.ModelInfo.TableId).datagrid('getRows');
    $.each(rows, function (index, row) {
        if (!row.ID) {
            $('#' + GV.ModelInfo.TableId).datagrid('updateRow', { index: index, row: newRowData });
        }
    });
}
/**
 * @description: 转化节点
 * @param {object} obj
 * @return {string} adms
 */
function formatNode(obj) {
    var adms = "";
    $.each(obj, function (index, node) {
        if (!!node.episodeID) {
            adms = !!adms ? adms + '^' + node.episodeID : node.episodeID;
        }
    });
    return adms;
}
/**
 * @description: 封装入参
 * @return {object} dataPost
 */
function packData() {
    var dataPost = {};
    var specifyFields = new Array();
    if (!!GV.ModelInfo.CareDate) {
        specifyFields.push(GV.ModelInfo.TableId);
        var queryInfo = GV.ModelInfo.CareDate + '=' + $('#batStartDate').dateboxq('getValue');
        queryInfo += '^' + GV.ModelInfo.CareTime + '=' + $('#batStartTime').timespinner('getValue');
        queryInfo += '^' + queryInfo;
        queryInfo += '^RecCancel=';
        dataPost["pageInfo"] = '1^20';
        dataPost["NurMPDataID"] = '';
        dataPost["queryInfo"] = queryInfo;
    }
    dataPost["specifyFields"] = specifyFields;
    dataPost["admIds"] = formatNode($("#patientTree").tree("getChecked"));
    var modelInfo = $cm({
        ClassName: 'NurMp.Service.Template.Model',
        MethodName: 'GetModelInfoByID',
        ModelID: $('#cbtreeModel').combobox('getValue')
    }, false);
    dataPost["templateVersionGuid"] = modelInfo.Guid;
    dataPost["locId"] = GV.LocID;
    dataPost["hospId"] = GV.HospitalID;
    return dataPost;
}
/**
 * @description: 提交更新
 * @param {*} index
 * @param {*} field
 * @param {*} value
 */
function cellEdit(index, field, value) {
    var FormElement = "edit" + this.id + "_" + field;
    var helper = GetElementHelper(FormElement);
    helper.focus(FormElement);
    window.HisuiEditors[this.id].editField = field;
    window.HisuiEditors[this.id].editIndex = index;
    CellEditByOpenWindow(this.id, field);
}
/**
 * @description: 开始编辑
 * @param {*} i
 * @param {*} d
 */
function beginEdit(i, d) {
    $('.datagrid-row-editting').removeClass('datagrid-row-editting');
    $("tr[datagrid-row-index = '" + i + "']").addClass('row-selected');
    InitAutoSignature();
}
/**
 * @description: 单元格回车事件
 * @param {*} i
 * @param {*} f
 */
function cellEnterHandler(i, f) {
    OnHisuiCellEditEnterHandler(this.id, i, f);
}
/**
 * @description: 单元格上下左右事件
 * @param {*} i
 * @param {*} f
 */
function cellDirectHandler(i, f, dir) {
    OnHisuiCellEditDirectHandler(this.id, i, f, dir);
}
/**
 * @description: beforeCellEdit
 * @param {*} i
 * @param {*} f
 */
function beforeCellEdit(i, f) {
	var rows = $('#' + GV.ModelInfo.TableId).datagrid('getSelected');
	if (rows.length == 0) {
		return false;
	}
	if (!!rows[0].DisableCode) {
		$.messager.alert('提示', $g(rows[0].DisableCode));
        return false;
	}
    return OnHisuiBeforeCellEdit(this.id, i, f);
}
/**
 * @description: 提交更新
 */
function update() {
    Throttle(save, null, [GV.ModelInfo.TableId]);
}
/**
 * @description: 撤销编辑
 */
function cancel() {
	var rows = $('#' + GV.ModelInfo.TableId).datagrid('getSelected');
	if (rows.length == 0) {
		$.messager.alert('提示', $g('请选择需要撤销的记录！'));
        return;
	}
    OnHisuiEditCancel(GV.ModelInfo.TableId);
}
/**
 * @description: 作废记录
 */
function abot() {
    removeRec();
}
/**
 * @description: 保存
 */
function save(tableId) {
    if (OnHisuiEndEditing(tableId)) {
        if (IsTableCellEdit(tableId)) {
            if (!CellEditBeforeSaveRequiredVerify(tableId)) {
                return false;
            }
        }
        var changeRows = $('#' + tableId).datagrid('getChanges');
        if (changeRows.length == 0) {
            $.messager.popover({ msg: $g('没有需要保存的内容！'), type: 'error', timeout: 1000 });
            return;
        }
        var columns = GetTableColumnFields(tableId);

        var dataArr = [];
        $.each(changeRows, function (index, row) {
            var dataPost = {};
            dataPost["templateVersionGuid"] = GV.EditModel;
            dataPost["EpisodeID"] = row.EpisodeId;
            dataPost["LOGON.CTLOCID"] = GV.LocID;
            dataPost["LOGON.WARDID"] = session['LOGON.WARDID'];
            dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
            dataPost["LOGON.USERID"] = session['LOGON.USERID'];
            dataPost["TemporarySave"] = 1;
            if (!!row["ID"]) {
                dataPost["NurMPDataID"] = row["ID"];
            }
            dataPost["logAuxiliaryInfo"] = getLogAuxiliaryInfo();

            var ifSaveFlag = false;
            $.each(columns, function (index, columnField) {
                if ((columnField != 'PatName') && (columnField != 'BedCode') && (columnField != 'DisableCode')) {
                    dataPost[columnField] = row[columnField];
                }
                if ((columnField != 'PatName') && (columnField != 'BedCode') && (columnField != 'EpisodeID')&& (columnField != 'DisableCode') && (columnField != GV.ModelInfo.CareDate) && (columnField != GV.ModelInfo.CareTime) && (columnField != GV.ModelInfo.RecUserId)) {
                    if ((typeof row[columnField] != "undefined") && (row[columnField] != "")) {
                        ifSaveFlag = true;
                    }
                }
            });
            if (ifSaveFlag) dataArr.push(dataPost);

        });
        if (dataArr.length < 1) {
            $.messager.popover({ msg: $g('没有需要保存的内容！'), type: 'error', timeout: 1000 });
            return;
        }
        MaskUtil.mask();

        //超长问题
        var chunks = splitChunk([], 5, dataArr);
        var errorInfos = [];
        chunks.map(function (chunk, index) {
            var result = $cm({
                ClassName: 'NurMp.Service.Template.BathEdit',
                MethodName: 'BatchUpdate',
                DataArr: JSON.stringify(chunk),
                dataType: "text"
            }, false);
            // if (result != '0' && errorInfos.indexOf(result) == -1) {
            // 	errorInfos.push(result);
            // }
            var reMsg = JSON.parse(result)
            if (MsgIsOK(reMsg)) {
                if (/^\d+$/.test(reMsg.data)) { //正常应返回流水号
                    console.log(reMsg);
                } else {
                    errorInfos.push(reMsg.data);
                }
            } else {
                errorInfos.push(reMsg.msg);
            }
        });
        MaskUtil.unmask();
        if (errorInfos.length > 0) {
            console.log(errorInfos);
            $.messager.alert($g('提交失败！'), $g('错误原因：') + errorInfos[0], 'error');
        } else {
            $.messager.popover({
                msg: $g('提交成功！'),
                type: 'success',
                style: {
                    bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
                    right: 10
                }
            });
        }
        $('#searchBtn').click();

        /*$cm({
            ClassName: 'NurMp.Service.Template.BathEdit',
            MethodName: 'BatchUpdate',
            DataArr: JSON.stringify(dataArr)
        }, function (result) {
            if (result == '0') {
                MaskUtil.unmask();
                $('#searchBtn').click();
                $.messager.popover({
                    msg: $g('提交成功！'),
                    type: 'success',
                    style: {
                        bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
                        right: 10
                    }
                });
            }
        });*/
    }
}
/**
 * @description: 分割数组
 */
function splitChunk(chunks, size, argus) {
    if (argus.length !== 0) {
        chunks.push(argus.splice(0, size));
        return this.splitChunk(chunks, size, argus);
    }
    return chunks;
}
function removeRec() {
    var checkedIds = '';
    var selectedRow = $('#' + GV.ModelInfo.TableId).datagrid("getSelected");
    if (selectedRow.length == 0) {
        $.messager.alert('提示', $g('请选择需要作废的记录！'), 'info');
        return;
    }
    var ID = selectedRow[0].ID;
    if (!!ID) {
        checkedIds = ID;
    }
    if (checkedIds == "") {
        $.messager.alert('提示', $g('未提交的记录不允许作废！'), 'info');
        return;
    }
    $.messager.confirm($g("提示"), $g("你确定要作废记录吗?"), function (r) {
        if (r) {
            var dataPost = {};
            dataPost["RecIds"] = checkedIds;
            dataPost["LOGON.USERID"] = session['LOGON.USERID'];
            dataPost["LOGON.LOCID"] = GV.LocID;
            dataPost["LOGON.WARDID"] = session['LOGON.WARDID'];
            dataPost["LOGON.HOSPID"] = session['LOGON.HOSPID'];
            dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
            dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
            MaskUtil.mask();
            $cm({
                ClassName: 'NurMp.Service.Template.BathEdit',
                MethodName: 'BatchCancel',
                DataPost: JSON.stringify(dataPost)
            }, function (result) {
                MaskUtil.unmask();
                if (MsgIsOK(result)) {
                    if (/^\d+$/.test(result.data)) {
                        $('#searchBtn').click();
                        $.messager.popover({
                            msg: $g('作废成功！'),
                            type: 'success',
                            style: {
                                bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
                                right: 10
                            }
                        });
                    }
                    else {
                        $.messager.popover({
                            msg: result.data,
                            type: 'error',
                            style: {
                                bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
                                right: 10
                            }
                        });
                    }

                }
                else {
                    $.messager.alert(" ", $g("操作失败\n错误原因：") + result.msg, "error");
                }
            });
        } else {
            return;
        }
    });
}
/**
 * @description: 单元格方向键事件
 * @param {*} i
 * @param {*} f
 */
function OnHisuiCellEditDirectHandler(tableID, i, f, dir) {
    var currentIndex = window.HisuiEditors[tableID].editElements.indexOf("edit" + tableID + "_" + f);
    var rows = $('#' + tableID).datagrid('getRows').length;
    if (currentIndex == -1)
        return;
    if ((dir == "right") && (currentIndex == window.HisuiEditors[tableID].editElements.length - 1))
        currentIndex = -1;
    if ((dir == "left") && (currentIndex == 0))
        currentIndex = window.HisuiEditors[tableID].editElements.length;
    if ((dir == "down") && (i == rows - 1))
        i = -1;
    if ((dir == "up") && (i == 0))
        i = rows;
    do {
        if (dir == "right")
            currentIndex = currentIndex + 1;
        if (dir == "left")
            currentIndex = currentIndex - 1;
        if (dir == "down")
            i = i + 1;
        if (dir == "up")
            i = i - 1;
        var nextField = GetTableFieldByIndentity(window.HisuiEditors[tableID].editElements[currentIndex]);
        var key = i + nextField;
        var findNoEditIndex = window.HisuiEditors[tableID].NoEdit.indexOf(key);
        if (findNoEditIndex == -1) {
            var target = $("#" + tableID);
            var panel = $(target).datagrid('getPanel');
            panel.find('td.datagrid-row-selected').removeClass('datagrid-row-selected');
            setTimeout(function () {
                $('#' + tableID).datagrid('gotoCell', {
                    index: i,
                    field: nextField
                });
                $('#' + tableID).datagrid('editCell', {
                    index: i,
                    field: nextField
                });
            }, 0);
            break;
        }
    } while (currentIndex < window.HisuiEditors[tableID].editElements.length - 1);
}

function OnCollapse() {
    createTable();
}

/**
 * @description: 事件绑定
 */
function listenEvents() {
    $('#searchBtn').on('click', reloadModelGrid);
}
