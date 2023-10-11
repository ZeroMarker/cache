/**
 * Description: 主场时段维护
 * FileName: dhcpe.prehome.time.js
 * Creator: wangguoying
 * Date: 2022-12-19
 */

var _GV = {
    PGADM: $("#H_PGADM").val(),
    ParRef: $("#H_ParRef").val(),
    DateStr: $("#H_DateStr").val(),
    LogicalDate: $("#H_LogicalDate").val(),
    EditTimeRow: -1, //时段编辑行号
    EditTeamRow: -1, //分组编辑行号
    timeColumns: [{ field: 'TID', hidden: true },
    {
        field: 'TStartTime', width: 100, align: 'center', title: '开始时间',
        editor: {
            type: "timespinner",
            options: {
                showSeconds: true
            }
        }
    },
    {
        field: 'TEndTime', width: 100, align: 'center', title: '结束时间',
        editor: {
            type: "timespinner",
            options: {
                showSeconds: true
            }
        }
    },
    {
        field: 'TNumMale', width: 60, align: 'center', title: '男性数量',
        editor: {
            type: "numberbox",
            options: {
                min: 0
            }
        }
    },
    {
        field: 'TNumFemale', width: 60, align: 'center', title: '女性数量',
        editor: {
            type: "numberbox",
            options: {
                min: 0
            }
        }
    }
    ]
}



function init() {
    init_content();
}





function init_content() {
    /** 时段信息 */
    $HUI.datagrid("#TimeList", {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCPE.PreTemplate",
            QueryName: "SerchTimeInfo",
            Type: "H",
            ParRef: _GV.ParRef
        },
        columns: [_GV.timeColumns],
        onSelect: function (rowIndex, rowData) {
            set_detail_enable(true);
			_GV.EditTeamRow = -1;
            $("#TeamList").datagrid("load", {
                ClassName: "web.DHCPE.PreHomeTeam",
                QueryName: "QueryHomeTeam",
                ParRef: rowData.TID
            });
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (_GV.EditTimeRow != -1) return false;
            $(this).datagrid("beginEdit", rowIndex);
            _GV.EditTimeRow = rowIndex;
        },
        fit: true,
        border: false,
        fitColumns: true,
        pagination: true,
        pageSize: 20,
        pageList: [20, 100, 200],
        displayMsg: "",
        singleSelect: true,
        rownumbers: true,
        toolbar: [{
            text: "新增时段",
            iconCls: "icon-add",
            handler: add_time
        }, {
            text: "删除",
            iconCls: "icon-remove",
            handler: delete_time
        }, "-", {
            text: "保存",
            iconCls: "icon-save",
            handler: save_time
        }]
    });


    /** 分组列表 */
    $HUI.datagrid("#TeamList", {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCPE.PreHomeTeam",
            QueryName: "QueryHomeTeam",
            ParRef: ""
        },
        columns: [[{ field: 'TTID', hidden: true },
        {
            field: 'TTeamDesc', width: 100, align: 'center', title: '分组',
            editor: {
                type: 'combobox',
                options: {
                    required: true,
                    valueField: 'PGT_RowId',
                    textField: 'PGT_Desc',
                    method: 'get',
                    url: $URL + "?ClassName=web.DHCPE.PreGTeam&QueryName=SearchGTeam&ResultSetType=array&ParRef=" + _GV.PGADM,
                }
            }
        },
        {
            field: 'TNumMale', width: 60, align: 'center', title: '男性数量',
            editor: {
                type: "numberbox",
                options: {
                    min: 0
                }
            }
        },
        {
            field: 'TNumFemale', width: 60, align: 'center', title: '女性数量',
            editor: {
                type: "numberbox",
                options: {
                    min: 0
                }
            }
        }, {
            field: 'TTag', width: 60, align: 'center', title: '标志位',
            editor: {
                type: "text"
            }
        }]],
        onDblClickRow: function (rowIndex, rowData) {
            if (_GV.EditTeamRow != -1) return false;
            $(this).datagrid("beginEdit", rowIndex);
            _GV.EditTeamRow = rowIndex;
            var rows = $("#TeamList").datagrid("getRows");
            var id = rows[_GV.EditTeamRow].TID;
            if (id != "") {
                var ed = $('#TeamList').datagrid('getEditor', {
                    index: _GV.EditTeamRow,
                    field: 'TTeamDesc'
                });
                $(ed.target).combobox("disable");
            }
        },
        border: false,
        fit: true,
        bodyCls: "panel-header-gray",
        fitColumns: true,
        pagination: true,
        pageSize: 20,
        pageList: [20, 100, 200],
        displayMsg: "",
        singleSelect: true,
        rownumbers: true,
        toolbar: [{
            id: "BtnAddTeam",
            text: "新增分组",
            disabled: true,
            iconCls: "icon-add",
            handler: add_team
        }, {
            id: "BtnDelTeam",
            text: "删除",
            disabled: true,
            iconCls: "icon-remove",
            handler: delete_team
        }, "-", {
            id: "BtnSaveTeam",
            text: "保存",
            disabled: true,
            iconCls: "icon-save",
            handler: save_team
        }]
    });


}

/**
 * [增加时间段]  
 * @Author wangguoying
 * @Date 2022-03-23
 */
function add_time() {
    if (_GV.EditTimeRow != -1) {
        $.messager.popover({
            msg: "存在未保存的时间段记录，请保存后再操作！",
            type: "error"
        });
        return false;
    }
    var rows = $("#TimeList").datagrid("getRows");
    var newIndex = rows.length;
    $("#TimeList").datagrid("appendRow", {
        TID: "",
        TStartTime: "",
        TEndTime: ""
    });
    $("#TimeList").datagrid("beginEdit", newIndex);
    _GV.EditTimeRow = newIndex;
}


/**
 * [增加分组]  
 * @Author wangguoying
 * @Date 2022-03-23
 */
function add_team() {
    if (_GV.EditTeamRow != -1) {
        $.messager.popover({
            msg: "存在未保存的VIP记录，请保存后再操作！",
            type: "error"
        });
        return false;
    }
    var rows = $("#TeamList").datagrid("getRows");
    var newIndex = rows.length;
    $("#TeamList").datagrid("appendRow", {
        TID: "",
        TTeamID: "",
        TTeamDesc: "",
        TNumMale: "",
        TNumFemale: "",
        TTag: ""
    });
    $("#TeamList").datagrid("beginEdit", newIndex);
    _GV.EditTeamRow = newIndex;
}



/**
 * [保存时段]  
 * @Author wangguoying
 * @Date 2022-03-24
 */
function save_time() {
    if (_GV.EditTimeRow == -1) {
        $.messager.popover({
            msg: "没有正在编辑的数据，不需要保存！",
            type: "error"
        });
        return false;
    }
    clean_detail();
    var ed = $('#TimeList').datagrid('getEditor', {
        index: _GV.EditTimeRow,
        field: 'TStartTime'
    });
    var startTime = $(ed.target).timespinner("getValue");
    if (startTime == "") {
        $.messager.popover({ msg: "开始时间不能为空！", type: "error" });
        return false;
    }
    var ed = $('#TimeList').datagrid('getEditor', {
        index: _GV.EditTimeRow,
        field: 'TEndTime'
    });
    var endTime = $(ed.target).timespinner("getValue");
    if (endTime == "") {
        $.messager.popover({ msg: "结束时间不能为空！", type: "error" });
        return false;
    }
    var ed = $('#TimeList').datagrid('getEditor', { index: _GV.EditTimeRow, field: 'TNumMale' });
    var maleNum = $(ed.target).val();
    var ed = $('#TimeList').datagrid('getEditor', { index: _GV.EditTimeRow, field: 'TNumFemale' });
    var femaleNum = $(ed.target).val();

    var rows = $("#TimeList").datagrid("getRows"),
        id = rows[_GV.EditTimeRow].TID,
        InString = startTime + "^" + endTime + "^" + maleNum + "^" + femaleNum;
    var ret = tkMakeServerCall("web.DHCPE.PreHomeTeam", "UpdateTime", _GV.ParRef, id, InString, session["LOGON.USERID"], _GV.PGADM + "^" + _GV.DateStr + "^G");
    if (parseInt(ret) < 0) {
        $.messager.popover({ msg: ret.split("^")[1], type: "error" });
        return false;
    } else {
        $.messager.popover({ msg: "保存成功", type: "success" });
        if (_GV.ParRef == "") {
            ret = ret.split("||")[0];
            _GV.ParRef = ret;
            $("#H_ParRef").val(ret);
        }
        _GV.EditTimeRow = -1;
        $("#TimeList").datagrid("load", {
            ClassName: "web.DHCPE.PreTemplate",
            QueryName: "SerchTimeInfo",
            Type: "H",
            ParRef: _GV.ParRef
        });
        clean_detail()
    }
}


/**
 * [保存分组]  
 * @Author wangguoying
 * @Date 2022-03-24
 */
function save_team() {
    var timeRow = $("#TimeList").datagrid("getSelected");
    if (timeRow == "" || timeRow == null || timeRow.TID == "") {
        $.messager.popover({
            msg: "先选择时间段！",
            type: "error"
        });
        return false;
    }
    if (_GV.EditTeamRow == -1) {
        $.messager.popover({
            msg: "没有正在编辑的数据，不需要保存！",
            type: "error"
        });
        return false;
    }
    var rows = $("#TeamList").datagrid("getRows");
    var id = rows[_GV.EditTeamRow].TID;
    var ed = $('#TeamList').datagrid('getEditor', {
        index: _GV.EditTeamRow,
        field: 'TTeamDesc'
    });
    var teamId = $(ed.target).combobox("getValue");
    if (teamId == rows[_GV.EditTeamRow].TTeamDesc) teamId = rows[_GV.EditTeamRow].TTeamID;
    if (teamId == "") {
        $.messager.popover({ msg: "分组不能为空！", type: "error" });
        return false;
    }

    var ed = $('#TeamList').datagrid('getEditor', { index: _GV.EditTeamRow, field: 'TNumMale' }),
        maleNum = $(ed.target).val(),
        ed = $('#TeamList').datagrid('getEditor', { index: _GV.EditTeamRow, field: 'TNumFemale' }),
        femaelNum = $(ed.target).val(),
        ed = $('#TeamList').datagrid('getEditor', { index: _GV.EditTeamRow, field: 'TTag' }),
        tag = $(ed.target).val(),
        inString = teamId + "^" + maleNum + "^" + femaelNum + "^" + tag;
    var ret = tkMakeServerCall("web.DHCPE.PreHomeTeam", "UpdateTeam", timeRow.TID, id, inString, session["LOGON.USERID"]);
    if (parseInt(ret) < 0) {
        $.messager.popover({
            msg: ret.split("^")[1],
            type: "error"
        });
        return false;
    } else {
        $.messager.popover({
            msg: "保存成功",
            type: "success"
        });
        _GV.EditTeamRow = -1;
        $("#TeamList").datagrid("reload");
    }
}



/**
 * [删除时间段] 
 * @Author wangguoying
 * @Date 2022-03-24
 */
function delete_time() {
    var selectRow = $("#TimeList").datagrid("getSelected")
    if (selectRow == "" || selectRow == null) {
        $.messager.popover({
            msg: "请选择要删除的记录！",
            type: "error"
        });
        return false;
    }
    var index = $("#TimeList").datagrid("getRowIndex", selectRow);
    var id = selectRow.TID;
    if (index == _GV.EditTimeRow && id == "") {
        $("#TimeList").datagrid("deleteRow", index); //直接移除
        _GV.EditTimeRow = -1;
        return true;
    }
    if (_GV.EditTimeRow != -1 && _GV.EditTimeRow != index) {
        $.messager.popover({
            msg: "存在未保存的记录，请保存后操作！",
            type: "error"
        });
        return false;
    }
    $.messager.confirm("提示", "确认删除【" + selectRow.TStartTime + "】-【" + selectRow.TEndTime + "】的时段吗", function (r) {
        if (r) {
            var ret = tkMakeServerCall("web.DHCPE.PreHomeTeam", "DeleteTime", id)
            if (parseInt(ret) < 0) {
                $.messager.popover({
                    msg: ret.split("^")[1],
                    type: "error"
                });
                return false;
            } else {
                $.messager.popover({
                    msg: "已删除",
                    type: "success"
                });
                _GV.EditTimeRow = -1;
                $("#TimeList").datagrid("reload");
                clean_detail();
            }
        }
    });
}


/**
 * [删除分组] 
 * @Author wangguoying
 * @Date 2022-03-24
 */
function delete_team() {
    var selectRow = $("#TeamList").datagrid("getSelected")
    if (selectRow == "" || selectRow == null) {
        $.messager.popover({
            msg: "请选择要删除的记录！",
            type: "error"
        });
        return false;
    }
    var index = $("#TeamList").datagrid("getRowIndex", selectRow);
    var id = selectRow.TID;
    if (index == _GV.EditTeamRow && id == "") {
        $("#TeamList").datagrid("deleteRow", index); //直接移除
        _GV.EditTeamRow = -1;
        return true;
    }
    if (_GV.EditTeamRow != -1 && _GV.EditTeamRow != index) {
        $.messager.popover({
            msg: "存在未保存的记录，请保存后操作！",
            type: "error"
        });
        return false;
    }
    $.messager.confirm("提示", "确认删除【" + selectRow.TTeamDesc + "】吗", function (r) {
        if (r) {
            var ret = tkMakeServerCall("web.DHCPE.PreHomeTeam", "DeleteTeam", id)
            if (parseInt(ret) < 0) {
                $.messager.popover({
                    msg: ret.split("^")[1],
                    type: "error"
                });
                return false;
            } else {
                $.messager.popover({
                    msg: "已删除",
                    type: "success"
                });
                _GV.EditTeamRow = -1;
                $("#TeamList").datagrid("reload");
            }
        }
    });
}


/**
 * [设置右侧详细 是否编辑]
 * @param    {[boolean]}    flag    [true：可用 false：禁用]
 * @return   {[object]}    
 * @Author wangguoying
 * @Date 2022-03-24
 */
function set_detail_enable(flag) {
    var enable = flag ? "enable" : "disable";
    $("#BtnAddTeam").linkbutton(enable);
    $("#BtnDelTeam").linkbutton(enable);
    $("#BtnSaveTeam").linkbutton(enable);
}

/**
 * [清除详细信息]
 * @Author wangguoying
 * @Date 2022-03-24
 */
function clean_detail() {
    set_detail_enable(false);
    $("#TeamList").datagrid("load", {
        ClassName: "web.DHCPE.PreHomeTeam",
        QueryName: "QueryHomeTeam",
        ParRef: ""
    });
}


$(init);