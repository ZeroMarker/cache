if (!Array.prototype.includes) {
    Array.prototype.includes = function(elem) {
        if (this.indexOf(elem) < 0) {
            return false;
        } else {
            return true;
        }
    }
}
if (!String.prototype.includes) {
    String.prototype.includes = function(elem) {
        if (this.indexOf(elem) < 0) {
            return false;
        } else {
            return true;
        }
    }
}
$.extend($.fn.datagrid.methods, {
    getEditingRowIndexs: function(jq) {
        var rows = $.data(jq[0], "datagrid").panel.find('.datagrid-row-editing');
        var indexs = [];
        rows.each(function(i, row) {
            var index = row.sectionRowIndex;
            if (indexs.indexOf(index) == -1) {
                indexs.push(index);
            }
        });
        return indexs;
    }
});
$.extend($.fn.datagrid.defaults, {
    onBeforeDrag: function(row) {}, // return false to deny drag
    onStartDrag: function(row) {},
    onStopDrag: function(row) {},
    onDragEnter: function(targetRow, sourceRow) {}, // return false to deny drop
    onDragOver: function(targetRow, sourceRow) {}, // return false to deny drop
    onDragLeave: function(targetRow, sourceRow) {},
    onBeforeDrop: function(targetRow, sourceRow, point) {},
    onDrop: function(targetRow, sourceRow, point) {}, // point:'append','top','bottom'
});
$.extend($.fn.datagrid.methods, {
    enableDnd: function(jq, index) {
        return jq.each(function() {
            var target = this;
            var state = $.data(this, 'datagrid');
            state.disabledRows = [];
            var dg = $(this);
            var opts = state.options;
            if (index != undefined) {
                var trs = opts.finder.getTr(this, index);
            } else {
                var trs = opts.finder.getTr(this, 0, 'allbody');
            }
            trs.draggable({
                disabled: false,
                revert: true,
                cursor: 'pointer',
                proxy: function(source) {
                    var index = $(source).attr('datagrid-row-index');
                    var tr1 = opts.finder.getTr(target, index, 'body', 1);
                    var tr2 = opts.finder.getTr(target, index, 'body', 2);
                    var p = $('<div style="z-index:9999999999999"></div>').appendTo('body');
                    tr2.clone().removeAttr('id').removeClass('droppable').appendTo(p);
                    tr1.clone().removeAttr('id').removeClass('droppable').find('td').insertBefore(p.find('td:first'));
                    $('<td><span class="tree-dnd-icon tree-dnd-no" style="position:static">&nbsp;</span></td>').insertBefore(p.find('td:first'));
                    p.find('td').css('vertical-align', 'middle');
                    p.hide();
                    return p;
                },
                deltaX: 15,
                deltaY: 15,
                onBeforeDrag: function(e) {
                    if (opts.onBeforeDrag.call(target, getRow(this)) == false) { return false; }
                    if ($(e.target).parent().hasClass('datagrid-cell-check')) { return false; }
                    if (e.which != 1) { return false; }
                    opts.finder.getTr(target, $(this).attr('datagrid-row-index')).droppable({ accept: 'no-accept' });
                },
                onStartDrag: function() {
                    $(this).draggable('proxy').css({
                        left: -10000,
                        top: -10000
                    });
                    var row = getRow(this);
                    opts.onStartDrag.call(target, row);
                    state.draggingRow = row;
                },
                onDrag: function(e) {
                    var x1 = e.pageX,
                        y1 = e.pageY,
                        x2 = e.data.startX,
                        y2 = e.data.startY;
                    var d = Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
                    if (d > 3) { // when drag a little distance, show the proxy object
                        $(this).draggable('proxy').show();
                        var tr = opts.finder.getTr(target, parseInt($(this).attr('datagrid-row-index')), 'body');
                        $.extend(e.data, {
                            startX: tr.offset().left,
                            startY: tr.offset().top,
                            offsetWidth: 0,
                            offsetHeight: 0
                        });
                    }
                    this.pageY = e.pageY;
                },
                onStopDrag: function() {
                    for (var i = 0; i < state.disabledRows.length; i++) {
                        var index = dg.datagrid('getRowIndex', state.disabledRows[i]);
                        if (index >= 0) {
                            opts.finder.getTr(target, index).droppable('enable');
                        }
                    }
                    state.disabledRows = [];
                    var index = dg.datagrid('getRowIndex', state.draggingRow);
                    dg.datagrid('enableDnd', index);
                    opts.onStopDrag.call(target, state.draggingRow);
                }
            }).droppable({
                accept: 'tr.datagrid-row',
                onDragEnter: function(e, source) {
                    if (opts.onDragEnter.call(target, getRow(this), getRow(source)) == false) {
                        allowDrop(source, false);
                        var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
                        tr.find('td').css('border', '');
                        tr.droppable('disable');
                        state.disabledRows.push(getRow(this));
                    }
                },
                onDragOver: function(e, source) {
                    var targetRow = getRow(this);
                    if ($.inArray(targetRow, state.disabledRows) >= 0) { return; }
                    var pageY = source.pageY;
                    var top = $(this).offset().top;
                    var bottom = top + $(this).outerHeight();

                    allowDrop(source, true);
                    var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
                    tr.children('td').css('border', '');
                    if (pageY > top + (bottom - top) / 2) {
                        tr.children('td').css('border-bottom', '1px solid red');
                    } else {
                        tr.children('td').css('border-top', '1px solid red');
                    }

                    if (opts.onDragOver.call(target, targetRow, getRow(source)) == false) {
                        allowDrop(source, false);
                        tr.find('td').css('border', '');
                        tr.droppable('disable');
                        state.disabledRows.push(targetRow);
                    }
                },
                onDragLeave: function(e, source) {
                    allowDrop(source, false);
                    var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
                    tr.children('td').css('border', '');
                    opts.onDragLeave.call(target, getRow(this), getRow(source));
                },
                onDrop: function(e, source) {
                    var sourceIndex = parseInt($(source).attr('datagrid-row-index'));
                    var destIndex = parseInt($(this).attr('datagrid-row-index'));

                    var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
                    var td = tr.children('td');
                    var point = parseFloat(td.css('border-top-width')) ? 'top' : 'bottom';
                    td.css('border', '');

                    var rows = dg.datagrid('getRows');
                    var dRow = rows[destIndex];
                    var sRow = rows[sourceIndex];
                    if (opts.onBeforeDrop.call(target, dRow, sRow, point) == false) {
                        return;
                    }
                    insert();
                    opts.onDrop.call(target, dRow, sRow, point);

                    function insert() {
                        var row = $(target).datagrid('getRows')[sourceIndex];
                        var index = 0;
                        if (point == 'top') {
                            index = destIndex;
                        } else {
                            index = destIndex + 1;
                        }
                        if (index < sourceIndex) {
                            dg.datagrid('deleteRow', sourceIndex).datagrid('insertRow', {
                                index: index,
                                row: row
                            });
                            dg.datagrid('enableDnd', index);
                        } else {
                            dg.datagrid('insertRow', {
                                index: index,
                                row: row
                            }).datagrid('deleteRow', sourceIndex);
                            dg.datagrid('enableDnd', index - 1);
                        }
                    }
                }
            });

            function allowDrop(source, allowed) {
                var icon = $(source).draggable('proxy').find('span.tree-dnd-icon');
                icon.removeClass('tree-dnd-yes tree-dnd-no').addClass(allowed ? 'tree-dnd-yes' : 'tree-dnd-no');
            }

            function getRow(tr) {
                return opts.finder.getRow(target, $(tr));
            }
        });
    }
});
// -----------------------------------------------------

var hospID, wardsData = [],
    wardDescObj = {},
    contextRow = {};
var selectESIndex, editESIndex, esTableData = { "total": 0, "rows": [] };
var selectADIndex, editADIndex, adTableData = { "total": 0, "rows": [] };
var selectGTIndex, editGTIndex, gtTableData = { "total": 0, "rows": [] };

$(function() {
    hospComp = GenHospComp("Nur_IP_CTCEvaluate", session["LOGON.USERID"] + '^' + session["LOGON.GROUPID"] + '^' + session["LOGON.CTLOCID"] + '^' + session["LOGON.HOSPID"]);
    hospID = hospComp.getValue();
    hospComp.options().onSelect = function(i, d) {
        hospID = d.HOSPRowId;
        init();
    } ///选中事件
    init();
})

function init() {
    getallWardNew();
    $('#tplType,#type').combobox({
        valueField: 'value',
        textField: 'text',
        mode: "local",
        editable: false,
        onSelect: function(record) {
            console.log(record);
            switch (record.value) {
                case "1":
                    $(".validLoc").hide();
                    $(".invalidLoc").hide();
                    $('#validLoc').combobox('clear');
                    $('#invalidLoc').combobox('clear');
                    break;
                case "2":
                    $(".validLoc").show();
                    $(".invalidLoc").hide();
                    $('#validLoc').combobox({ multiple: false }).combobox('clear');
                    $('#invalidLoc').combobox('clear');
                    break;
                case "3":
                    $(".validLoc").show();
                    $(".invalidLoc").show();
                    $('#validLoc').combobox({ multiple: true }).combobox('clear');
                    $('#invalidLoc').combobox({ multiple: true }).combobox('clear');
                    break;
                default:
                    break;
            }
        },
        data: [
            { "value": "1", "text": $g('个人模板') },
            { "value": "2", "text": $g('科室模板') },
            { "value": "3", "text": $g('全院模板') }
        ]
    });
}

function getallWardNew() {
    // 获取病区
    $cm({
        ClassName: 'Nur.NIS.Service.Base.Loc',
        QueryName: 'FindLocItem',
        HospID: hospID,
        LocType: '',
        LocDesc: '',
        CongfigName: 'Nur_IP_CTCEvaluate',
        rows: 10000
    }, function(data) {
        wardList = data.rows;
        wardList.map(function(elem, index) {
            wardDescObj[elem.rowid] = elem.desc;
        });
        $HUI.combobox(".locs", {
            multiple: true,
            valueField: 'rowid',
            textField: 'desc',
            data: wardList,
            defaultFilter: 4
        });
        getESTableData();
    });
}

function getWardsDesc(wardIDString) {
    if ('' == wardIDString) return "";
    var ids = wardIDString.toString().split(','),
        str = "";
    ids.map(function(elem, index) {
        str += wardDescObj[elem] + ",";
    });
    return str.slice(0, -1);
}

function clearSearchCond() {
    $("#tplType").combobox('clear');
    $("#evaluateInput").val('');
    getESTableData();
}

function getESTableData() {
    // 获取放化疗评价系统数据
    $cm({
        ClassName: 'Nur.NIS.Service.CTC.Config',
        QueryName: 'GetCTCEvalTemplate',
        rows: 999999999999999,
        hospDR: hospID
    }, function(data) {
        console.log(data);
        var tableHeight = window.innerHeight - 158;
        var columns = [
            { field: 'tplDesc', title: '模板描述', width: '160' },
            { field: 'code', title: '模板代码', width: '100' },
            { field: 'person', title: '使用用户', width: '110' },
            {
                field: 'validLoc',
                title: '使用科室',
                width: '160',
                formatter: function(value, row) {
                    if (3 == row.type) {
                        console.log(value);
                        return getWardsDesc(value.join()) || '全院';
                    }
                    if (row.type > 1) return getWardsDesc(value) || '全院';
                }
            },
            { field: 'createUser', title: '创建人', width: '110' },
            { field: 'createDateTime', title: '创建时间', width: '140' },
        ];
        var treegridObj = $HUI.treegrid("#evalTemplate", {
            onClickRow: function(id, row) {
                console.log(arguments);
                $('#mm').hide();
                if (id < 0) {
                    $("#evalTemplate").treegrid("unselect", id);
                } else {
                    getTemplateADRs();
                }
            },
            onContextMenu: function(e, row) {
                console.log(row);
                e.stopPropagation();
                e.preventDefault();
                var n = 1;
                if (row._parentId) {
                    $('#mm>div').show();
                    $('#mm1').hide();
                    n = 4;
                } else {
                    $('#mm>div').hide();
                    $('#mm1').show();
                }
                $('#mm').css({
                    left: e.pageX,
                    top: Math.min(e.clientY, window.innerHeight - 31 * n) + "px"
                    // top: e.pageY
                }).show();
                contextRow = row;
            },
            autoSizeColumn: false,
            // checkbox:true,
            columns: [columns],
            idField: 'id',
            treeField: 'tplDesc',
            headerCls: 'panel-header-gray',
            height: tableHeight,
            onLoadSuccess: function(row, data) {
                // $("#evalTemplate").treegrid("collapseAll");
            }
        });
        var rows = data.rows;
        var tplData = [
            { "id": -1, "tplDesc": "个人模板", "code": "", "person": "", "validLoc": "", "createUser": "", "createDateTime": "" },
            { "id": -2, "tplDesc": "科室模板", "code": "", "person": "", "validLoc": "", "createUser": "", "createDateTime": "" },
            { "id": -3, "tplDesc": "全院模板", "code": "", "person": "", "validLoc": "", "createUser": "", "createDateTime": "" },
        ]
        var keyword = $("#evaluateInput").val();
        var type = $("#tplType").combobox('getValue');
        rows.map(function(e) {
            if (type && (type != e.type)) return;
            if (keyword && (e.tplDesc.toString().indexOf(keyword) < 0) && ($.hisui.toChineseSpell(e.tplDesc).indexOf(keyword.toUpperCase()) < 0)) return;
            e._parentId = 0 - parseInt(e.type);
            if (3 == e.type) {
                e.validLoc = JSON.parse(e.validLoc);
                e.invalidLoc = JSON.parse(e.invalidLoc);
            }
            tplData.push(e);
        })
        console.log(JSON.stringify(tplData));
        treegridObj.loadData({ "total": tplData.length, "rows": tplData });
    });
}
// 更新模态框位置
function updateModalPos(id) {
    var offsetLeft = (window.innerWidth - $('#' + id).parent().width()) / 2;
    var offsetTop = (window.innerHeight - $('#' + id).parent().height()) / 2;
    $('#' + id).dialog({
        left: offsetLeft,
        top: offsetTop
    }).dialog("open");
}

function menuHandler(flag) {
    $('#mm').hide();
    if (4 == flag) { // 删除
        $.messager.confirm("删除", "确定要删除改评价模板?", function(r) {
            if (r) {
                $cm({
                    ClassName: 'Nur.NIS.Service.CTC.Config',
                    MethodName: 'DeleteCTCEvalTemplate',
                    ID: contextRow.id
                }, function(res) {
                    console.log(res);
                    if (0 == res) {
                        $.messager.popover({ msg: '删除成功！', type: 'success' });
                        getESTableData();
                    } else {
                        $.messager.popover({ msg: res, type: 'alert' });
                        return false
                    }
                });
            }
        });
        return;
    }
    $('#ssForm').form('disableValidation')
    var type, title = $g('新增评价模板'),iconCls="icon-w-add";
    if (1 == flag) {
        type = 0 - contextRow.id;
        $('#type').combobox('setValue', type);
        $("#id").val('');
        $("#code").val('');
        $("#tplDesc").val('');
    } else {
        type = contextRow.type;
        $('#type').combobox('setValue', type);
    }
    if (flag < 3) {
        $("#id").val('');
        $("#code").val('');
        $("#tplDesc").val('');
    }
    if (3 == flag) {
        title = $g('修改评价模板');
        iconCls="icon-w-edit";
        $("#id").val(contextRow.id);
    }
    if (5 == flag) {
        title = $g('复制评价模板');
        iconCls="icon-w-copy";
        $("#id").val('');
        $("#copyid").val(contextRow.id); //复制id
    } else {
        $("#copyid").val('');
    }
    if (flag > 2) {
        $("#code").val(contextRow.code);
        $("#tplDesc").val(contextRow.tplDesc);
    }
    if (1 == type) {
        $(".validLoc").hide();
        $(".invalidLoc").hide();
        $('#validLoc').combobox('clear');
        $('#invalidLoc').combobox('clear');
    } else if (2 == type) {
        $(".validLoc").show();
        $(".invalidLoc").hide();
        $('#validLoc').combobox({ multiple: false }).combobox('clear');
        $('#invalidLoc').combobox('clear');
        if (flag > 2) {
            $('#validLoc').combobox('setValue', contextRow.validLoc);
        }
    } else {
        $(".validLoc").show();
        $(".invalidLoc").show();
        $('#validLoc').combobox({ multiple: true }).combobox('clear');
        $('#invalidLoc').combobox({ multiple: true }).combobox('clear');
        if (flag > 2) {
            $('#validLoc').combobox('setValues', contextRow.validLoc);
            $('#invalidLoc').combobox('setValues', contextRow.invalidLoc);
        }
    }
    updateModalPos('statisticsModal');
    // $HUI.dialog('#statisticsModal').setTitle(title);
    $('#statisticsModal').dialog({
        iconCls : iconCls,
        title : title,
    }).dialog("open");
}

function saveEvalTemplate() {
    $('#ssForm').form('enableValidation')
    if ($('#ssForm').form('validate')) {
        var type = $('#type').combobox('getValue');
        var code = $("#code").val();
        var tplDesc = $("#tplDesc").val();
        var id = $("#id").val();
        var copyid = $("#copyid").val();
        if (3 == type) {
            var validLoc = $('#validLoc').combobox('getValues');
            var invalidLoc = $('#invalidLoc').combobox('getValues');
            var obj = {};
            for (var i = validLoc.length - 1; i >= 0; i--) {
                obj[validLoc[i]] = 1;
            }
            for (var i = invalidLoc.length - 1; i >= 0; i--) {
                if (obj[invalidLoc[i]]) return $.messager.popover({ msg: "使用科室和禁用科室中不能有相同选项！", type: 'alert' });
            }
            validLoc = JSON.stringify(validLoc);
            invalidLoc = JSON.stringify(invalidLoc);
        } else {
            var validLoc = $('#validLoc').combobox('getValue');
            var invalidLoc = $('#invalidLoc').combobox('getValue');
        }
        if ((2 == type) && !validLoc) {
            return $.messager.popover({ msg: "请选择科室！", type: 'alert' });
        }
        var data = {
            id: id,
            copyid: copyid,
            type: type,
            code: code,
            tplDesc: tplDesc,
            validLoc: validLoc,
            invalidLoc: invalidLoc,
            hospDR: hospID
        }
        if (1 == type) {
            data.person = session["LOGON.USERID"];
        }
        var updateRow = editESIndex;
        $cm({
            ClassName: 'Nur.NIS.Service.CTC.Config',
            MethodName: 'AddOrUpdateCTCEvalTemplate',
            dataType: "text",
            data: JSON.stringify(data)
        }, function(res) {
            if (res >= 0) {
                $.messager.popover({ msg: '保存成功！', type: 'success' });
                $HUI.dialog('#statisticsModal').close();
                getESTableData();
            } else {
                $.messager.popover({ msg: res, type: 'alert' });
            }
        });
    }
}

function getTemplateADRs() {
    var pRow = $('#evalTemplate').treegrid('getSelected');
    if (pRow && pRow.id) {
        $cm({
            ClassName: 'Nur.NIS.Service.CTC.Config',
            QueryName: 'GetCTCEvalTplADRs',
            rows: 999999999999999,
            tplId: pRow.id
        }, function(res) {
            console.log(res);
            $('#ADRsTable').datagrid({ data: res.rows, total: res.rows.length })
        });
    } else {
        $('#ADRsTable').datagrid({ data: [] })
    }
}

function addADRsRow() {
    var index = $('#ADRsTable').datagrid('getEditingRowIndexs')[0];
    if (undefined !== index) {
        return $.messager.popover({ msg: '已存在正在编辑的行！', type: 'alert' });
    }
    var pRow = $('#evalTemplate').treegrid('getSelected');
    console.log(pRow);
    if (!pRow) return $.messager.popover({ msg: '请先选中评价系统中的行！', type: 'alert' });
    if (!pRow.id) return $.messager.popover({ msg: '请先保存评价系统中的行！', type: 'alert' });
    var len = $('#ADRsTable').datagrid('getRows').length;
    var row = {
        sortNo: len + 1,
        sysDesc: "",
        adrsCode: "",
        adrsDesc: "",
        id: ""
    }
    $('#ADRsTable').datagrid("insertRow", {
        row: row
    }).datagrid("selectRow", len);
    editADRsRow(len, row)
}

function editADRsRow(curInd, row) {
    console.log(arguments);
    // 当双击另一行时，先保存正在编辑的行
    var index = $('#ADRsTable').datagrid('getEditingRowIndexs')[0];
    if (undefined !== index) {
        return $.messager.popover({ msg: '已存在正在编辑的行！', type: 'alert' });
    }
    $('#ADRsTable').datagrid('beginEdit', curInd);
    var rowEditors = $('#ADRsTable').datagrid('getEditors', curInd);
    var pRow = $('#evalTemplate').treegrid('getSelected');
    $(rowEditors[0].target).lookup({
        // url:'getGroup',
        url: $URL + "?ClassName=Nur.NIS.Service.CTC.Config&QueryName=GetCTCEvalADRsFilterByTplId&hospDR=" + hospID + "&tplId=" + pRow.id,
        mode: 'remote',
        idField: 'id',
        textField: 'adrsDesc',
        columns: [
            [
                { field: 'sysDesc', title: '系统描述', width: 150 },
                { field: 'adrsDesc', title: '不良反应描述', width: 150 }
            ]
        ],
        pagination: true,
        onSelect: function(index, row) {
            console.log(index, row);
            var ind = $('#ADRsTable').datagrid('getEditingRowIndexs')[0];
            var curRow = $('#ADRsTable').datagrid('getRows')[ind];
            var data = {
                id: curRow.id,
                pId: pRow.id,
                adrsDR: row.id
            }
            var res = $cm({
                ClassName: 'Nur.NIS.Service.CTC.Config',
                MethodName: 'AddOrUpdateCTCEvalTplADRs',
                dataType: "text",
                data: JSON.stringify(data)
            }, false);
            console.log(res);
            if ((0 == res) || res.includes(pId + "||")) {
                $.messager.popover({ msg: '保存成功！', type: 'success' });
                getTemplateADRs();
                return true;
            } else {
                $.messager.popover({ msg: res, type: 'alert' });
                return false;
            }
        }
    });
}

function beforeDragADRsRow() {
    var index = $('#ADRsTable').datagrid('getEditingRowIndexs')[0];
    if (undefined !== index) return false;
}
// 拖动数据引入表格
function dropADRsRow(target, source, point) {
    console.log(arguments);
    var newSort = target.sortNo,
        oldSort = source.sortNo;
    if (newSort == oldSort) return;
    if ((newSort > oldSort) && ('top' == point)) {
        newSort--;
    }
    if ((newSort < oldSort) && ('bottom' == point)) {
        newSort++;
    }
    if (newSort == oldSort) return;
    $cm({
        ClassName: 'Nur.NIS.Service.CTC.Config',
        MethodName: 'UpdateCTCEvalTplADRsSort',
        newSort: newSort,
        ID: source.id
    }, function(data) {
        console.log(data);
        if (0 == data) {
            getTemplateADRs();
        } else {
            $.messager.popover({ msg: JSON.stringify(data), type: 'alert' });
        }
    });
}

function deleteADRsRow() {
    var adObj = $('#ADRsTable');
    var row = adObj.datagrid('getSelected');
    if (row) {
        $.messager.confirm("删除", "确定要删除选中的数据?", function(r) {
            if (r) {
                if (row.id) {
                    var res = $cm({
                        ClassName: 'Nur.NIS.Service.CTC.Config',
                        MethodName: 'DeleteCTCEvalTplADRs',
                        ID: row.id
                    }, false);
                    console.log(res);
                    if (0 == res) {
                        $.messager.popover({ msg: '删除成功！', type: 'success' });
                        getTemplateADRs();
                    } else {
                        $.messager.popover({ msg: JSON.stringify(res), type: 'alert' });
                        return false
                    }
                } else {
                    var curInd = adObj.datagrid('getRowIndex', row);
                    adObj.datagrid('deleteRow', curInd);
                }
                // updateTableHeight()
                selectADIndex = undefined;
                editADIndex = undefined;
            }
        });
    } else {
        $.messager.popover({ msg: '请先选择要删除的行！', type: 'alert' });
    }
}
document.addEventListener('click', function() {
    $('#mm').hide();
});

function resizeTableHeight() {
    var innerHeight = window.innerHeight;
    console.log(innerHeight);
    $('#evalTemplate').treegrid('resize', {
        height: innerHeight - 158
    });
    $('#ADRsTable').datagrid('resize', {
        height: innerHeight - 73
    });
}
setTimeout(resizeTableHeight, 100);
window.addEventListener("resize", resizeTableHeight);