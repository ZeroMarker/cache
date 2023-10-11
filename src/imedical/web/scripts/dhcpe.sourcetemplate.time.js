/**
 * Description: 号源模板时段维护
 * FileName: dhcpe.sourcetemplate.time.js
 * Creator: wangguoying
 * Date: 2022-10-10
 */

var _GV = {
    Type: $("#H_Type").val(),
    Class: $("#H_Class").val(),
    className: "web.DHCPE.SourceManager",
    ParRef: $("#H_ParRef").val(),
    LocID: $("#H_LocID").val(),
    WeekNum: $("#H_WeekNum").val(),
    DateStr: $("#H_DateStr").val(),
    LogicalDate: $("#H_LogicalDate").val(),
    EditTimeRow: -1, //时段编辑行号
    EditVIPRow: -1, //VIP编辑行号
    VIPColumns: [{
        field: 'TRowID', hidden: true
    },
    {
        field: 'TVIPID', hidden: true
    },
    {
        field: 'TVIPDesc', width: 160, title: 'VIP等级', align: 'center',
        editor: {
            type: 'combobox',
            options: {
                required: true,
                valueField: 'id',
                textField: 'desc',
                method: 'get',
                url: $URL + "?ClassName=web.DHCPE.SourceManager&QueryName=FindVIPPreType&LocID="+session["LOGON.CTLOCID"]+"&ResultSetType=array",
            }
        }
    },
    {
        field: 'TNum', width: 80, align: 'center', title: '数量',
        editor: {
            type: "numberbox",
            options: {
                min: 0
            }
        }
    },
    {
        field: 'TMaleNum', width: 80, align: 'center', title: '男性数量',
        editor: {
            type: "numberbox",
            options: {
                min: 0
            }
        }
    },
    {
        field: 'TFemaleNum', width: 80, align: 'center', title: '女性数量',
        editor: {
            type: "numberbox",
            options: {
                min: 0
            }
        }
    }
    ],
    timeColumns: [{ field: 'TRowID', hidden: true },
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
        field: 'TNum', width: 60, align: 'center', title: '数量',
        editor: {
            type: "numberbox",
            options: {
                min: 0
            }
        }
    },
    {
        field: 'TMaleNum', width: 60, align: 'center', title: '男性数量',
        editor: {
            type: "numberbox",
            options: {
                min: 0
            }
        }
    },
    {
        field: 'TFemaleNum', width: 60, align: 'center', title: '女性数量',
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
    setGVProperty();
    init_content();
    init_event();
}

/**
 * [根据Type设置本界面使用的类方法]  
 * @Author wangguoying
 * @Date 2022-03-29
 */
function setGVProperty() {
    if (_GV.Type == "M") { //限额管理
        _GV["SumTreeName"] = "GetManagerTree";
        _GV["TimeQueryName"] = "QueryManagerTime";
        _GV["VIPQueryName"] = "QueryManagerTimeVip";
        _GV["TimeRecordName"] = "GetManagerTimeRecord";
        _GV["UpdateTimeName"] = "UpdateManagerTime";
        _GV["UpdateVIPName"] = "UpdateManagerVIP";
        _GV["TimeClassName"] = "User.DHCPESourceTimeManager";
        _GV["VIPClassName"] = "User.DHCPESourceTimeVIPManager";
        var preNumColumn = { field: 'TPreNum', width: 80, align: 'center', title: '已预约数量' };
        _GV.VIPColumns.push(preNumColumn);
        _GV.timeColumns.push(preNumColumn);
    } else { //模板
        _GV["SumTreeName"] = "GetTemplateWeekTree";
        _GV["TimeQueryName"] = "QueryTemplateTime";
        _GV["VIPQueryName"] = "QueryTimeVip";
        _GV["TimeRecordName"] = "GetTemplateTimeRecord";
        _GV["UpdateTimeName"] = "UpdateTemplateTime";
        _GV["UpdateVIPName"] = "UpdateTemplateVIP";
        _GV["TimeClassName"] = "User.DHCPESourceTimeTemplate";
        _GV["VIPClassName"] = "User.DHCPESourceTimeVIPTemplate";
    }
}

function init_event() {
    // 数量保存按钮
    $("#BtnSaveNum").click(function (e) {
        save_num();
    });
}

/**
 * [格式化汇总树]
 * @Author wangguoying
 * @Date 2022-03-23
 */
function init_sumTree() {
    $cm({
        ClassName: _GV.className,
        MethodName: _GV.SumTreeName,
        ResultSetType: "array",
        LocID: _GV.LocID,
        WeekNum: _GV.WeekNum,
        DateStr: _GV.DateStr
    }, function (data) {
        $("#SumTree").tree({
            animate: true,
            lines: true,
            data: data
        });
    });
}

function init_content() {
    init_sumTree();
    /** 时段信息 */
    $HUI.datagrid("#TimeList", {
        url: $URL,
        queryParams: {
            ClassName: _GV.className,
            QueryName: _GV.TimeQueryName,
            ParRef: _GV.ParRef
        },
        columns: [_GV.timeColumns],
        onSelect: function (rowIndex, rowData) {
	        _GV.EditVIPRow = -1;
            set_detail();
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
            text: "新增",
            iconCls: "icon-add",
            handler: add_time
        }, {
            text: "删除",
            iconCls: "icon-cancel",
            handler: delete_time
        }, "-", {
            text: "保存",
            iconCls: "icon-save",
            handler: save_time
        }]
    });


    /** VIP列表 */
    $HUI.datagrid("#VIPList", {
        url: $URL,
        queryParams: {
            ClassName: _GV.className,
            QueryName: _GV.VIPQueryName,
            ParRef: ""
        },
        columns: [_GV.VIPColumns],
        onDblClickRow: function (rowIndex, rowData) {
            if (_GV.EditVIPRow != -1) return false;
            $(this).datagrid("beginEdit", rowIndex);
            _GV.EditVIPRow = rowIndex;
            var rows = $("#VIPList").datagrid("getRows");
            var id = rows[_GV.EditVIPRow].TRowID;
            if (id != "") {
                var ed = $('#VIPList').datagrid('getEditor', {
                    index: _GV.EditVIPRow,
                    field: 'TVIPDesc'
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
            id: "BtnAddVIP",
            text: "新增",
            disabled: true,
            iconCls: "icon-add",
            handler: add_vip
        }, {
            id: "BtnDelVIP",
            text: "删除",
            disabled: true,
            iconCls: "icon-cancel",
            handler: delete_vip
        }, "-", {
            id: "BtnSaveVIP",
            text: "保存",
            disabled: true,
            iconCls: "icon-save",
            handler: save_vip
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
        TRowID: "",
        TStartTime: "",
        TEndTime: ""
    });
    $("#TimeList").datagrid("beginEdit", newIndex);
    _GV.EditTimeRow = newIndex;
}


/**
 * [增加VIP等级]  
 * @Author wangguoying
 * @Date 2022-03-23
 */
function add_vip() {
    if (_GV.EditVIPRow != -1) {
        $.messager.popover({
            msg: "存在未保存的VIP记录，请保存后再操作！",
            type: "error"
        });
        return false;
    }
    var rows = $("#VIPList").datagrid("getRows");
    var newIndex = rows.length;
    $("#VIPList").datagrid("appendRow", {
        TRowID: "",
        TVIPID: "",
        TVIPDesc: "",
        TNum: ""
    });
    $("#VIPList").datagrid("beginEdit", newIndex);
    _GV.EditVIPRow = newIndex;
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
    var ed = $('#TimeList').datagrid('getEditor', { index: _GV.EditTimeRow, field: 'TNum' });
    var num = $(ed.target).val();
    var ed = $('#TimeList').datagrid('getEditor', { index: _GV.EditTimeRow, field: 'TMaleNum' });
    var maleNum = $(ed.target).val();
    var ed = $('#TimeList').datagrid('getEditor', { index: _GV.EditTimeRow, field: 'TFemaleNum' });
    var femaleNum = $(ed.target).val();

    var rows = $("#TimeList").datagrid("getRows");
    var id = rows[_GV.EditTimeRow].TRowID;
    var param = {};
    if (_GV.Type == "M") {
        param = {
            STMStartTime: startTime,
            STMEndTime: endTime,
            STMNum: num,
            STMMaleNum: maleNum,
            STMFemaleNum: femaleNum
        }
    } else {
        param = {
            STTStartTime: startTime,
            STTEndTime: endTime,
            STTNum: num,
            STTMaleNum: maleNum,
            STTFemaleNum: femaleNum
        }
    }
    var extParam = _GV.Type == "M" ? _GV.DateStr : _GV.WeekNum;
    var ret = tkMakeServerCall(_GV.className, _GV.UpdateTimeName, _GV.ParRef, id, JSON.stringify(param), _GV.LocID, session["LOGON.USERID"], extParam, _GV.Class);
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
            ClassName: _GV.className,
            QueryName: _GV.TimeQueryName,
            ParRef: _GV.ParRef
        });
        init_sumTree();
        //清除右侧信息
        clean_detail()
    }
}


/**
 * [保存VIP]  
 * @Author wangguoying
 * @Date 2022-03-24
 */
function save_vip() {
    var timeRow = $("#TimeList").datagrid("getSelected");
    if (timeRow == "" || timeRow == null || timeRow.TRowID == "") {
        $.messager.popover({
            msg: "先选择时间段！",
            type: "error"
        });
        return false;
    }
    if (_GV.EditVIPRow == -1) {
        $.messager.popover({
            msg: "没有正在编辑的数据，不需要保存！",
            type: "error"
        });
        return false;
    }
    var rows = $("#VIPList").datagrid("getRows");
    var id = rows[_GV.EditVIPRow].TRowID;
    var ed = $('#VIPList').datagrid('getEditor', {
        index: _GV.EditVIPRow,
        field: 'TVIPDesc'
    });
    var vip = $(ed.target).combobox("getValue");
    if (vip == rows[_GV.EditVIPRow].TVIPDesc) vip = rows[_GV.EditVIPRow].TVIPID;
    if (vip == "") {
        $.messager.popover({ msg: "VIP等级不能为空！", type: "error" });
        return false;
    }
    var ed = $('#VIPList').datagrid('getEditor', { index: _GV.EditVIPRow, field: 'TNum' });
    var num = $(ed.target).val();
    if (num == "") {
        $.messager.popover({ msg: "总数量不能为空！", type: "error" });
        return false;
    }
    var preNum = parseInt(rows[_GV.EditVIPRow].TPreNum);
    if (parseInt(num) < preNum) {
        $.messager.popover({ msg: "限额数量不能小于预约数量！", type: "error" });
        return false;
    }
    var ed = $('#VIPList').datagrid('getEditor', { index: _GV.EditVIPRow, field: 'TMaleNum' });
    var maleNum = $(ed.target).val();
    var ed = $('#VIPList').datagrid('getEditor', { index: _GV.EditVIPRow, field: 'TFemaleNum' });
    var femaelNum = $(ed.target).val();
    var ret = tkMakeServerCall(_GV.className, _GV.UpdateVIPName, timeRow.TRowID, id, vip, num + "^" + maleNum + "^" + femaelNum, session["LOGON.USERID"]);
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
        _GV.EditVIPRow = -1;
        $("#VIPList").datagrid("reload");
        init_sumTree();
    }
}

/**
 * [保存站点]  
 * @Author wangguoying
 * @Date 2022-03-24
 */
function save_station() {
    var timeRow = $("#TimeList").datagrid("getSelected");
    if (timeRow == "" || timeRow == null || timeRow.TRowID == "") {
        $.messager.popover({
            msg: "先选择时间段！",
            type: "error"
        });
        return false;
    }
    if (_GV.EditStationRow == -1) {
        $.messager.popover({
            msg: "没有正在编辑的数据，不需要保存！",
            type: "error"
        });
        return false;
    }
    var rows = $("#StationList").datagrid("getRows");
    var id = rows[_GV.EditStationRow].TRowID;
    var ed = $('#StationList').datagrid('getEditor', {
        index: _GV.EditStationRow,
        field: 'TStationDesc'
    });
    var station = $(ed.target).combobox("getValue");
    if (station == rows[_GV.EditStationRow].TStationDesc) station = rows[_GV.EditStationRow].TStationID;
    if (station == "") {
        $.messager.popover({
            msg: "站点不能为空！",
            type: "error"
        });
        return false;
    }
    var ed = $('#StationList').datagrid('getEditor', {
        index: _GV.EditStationRow,
        field: 'TNum'
    });
    var num = $(ed.target).val();
    if (num == "") {
        $.messager.popover({
            msg: "数量不能为空！",
            type: "error"
        });
        return false;
    }
    var preNum = parseInt(rows[_GV.EditStationRow].TPreNum);
    if (parseInt(num) < preNum) {
        $.messager.popover({
            msg: "限额数量不能小于预约数量！",
            type: "error"
        });
        return false;
    }

    var ret = tkMakeServerCall(_GV.className, _GV.UpdateStationName, timeRow.TRowID, id, station, num, session["LOGON.USERID"]);
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
        _GV.EditStationRow = -1;
        $("#StationList").datagrid("reload");
        init_sumTree();
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
    var id = selectRow.TRowID;
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
            var ret = tkMakeServerCall(_GV.TimeClassName, "Delete", id)
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
                //清除右侧信息
                clean_detail();
                init_sumTree();
            }
        }
    });
}


/**
 * [删除VIP] 
 * @Author wangguoying
 * @Date 2022-03-24
 */
function delete_vip() {
    var selectRow = $("#VIPList").datagrid("getSelected")
    if (selectRow == "" || selectRow == null) {
        $.messager.popover({
            msg: "请选择要删除的记录！",
            type: "error"
        });
        return false;
    }
    var index = $("#VIPList").datagrid("getRowIndex", selectRow);
    var id = selectRow.TRowID;
    if (index == _GV.EditVIPRow && id == "") {
        $("#VIPList").datagrid("deleteRow", index); //直接移除
        _GV.EditVIPRow = -1;
        return true;
    }
    if (_GV.EditVIPRow != -1 && _GV.EditVIPRow != index) {
        $.messager.popover({
            msg: "存在未保存的记录，请保存后操作！",
            type: "error"
        });
        return false;
    }
    $.messager.confirm("提示", "确认删除【" + selectRow.TVIPDesc + "】吗", function (r) {
        if (r) {
            var ret = tkMakeServerCall(_GV.VIPClassName, "Delete", id)
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
                _GV.EditVIPRow = -1;
                $("#VIPList").datagrid("reload");
                init_sumTree();
            }
        }
    });
}

/**
 * [删除站点] 
 * @Author wangguoying
 * @Date 2022-03-24
 */
function delete_station() {
    var selectRow = $("#StationList").datagrid("getSelected")
    if (selectRow == "" || selectRow == null) {
        $.messager.popover({
            msg: "请选择要删除的记录！",
            type: "error"
        });
        return false;
    }
    var index = $("#StationList").datagrid("getRowIndex", selectRow);
    var id = selectRow.TRowID;
    if (index == _GV.EditStationRow && id == "") {
        $("#StationList").datagrid("deleteRow", index); //直接移除
        _GV.EditStationRow = -1;
        return true;
    }
    if (_GV.EditStationRow != -1 && _GV.EditStationRow != index) {
        $.messager.popover({
            msg: "存在未保存的记录，请保存后操作！",
            type: "error"
        });
        return false;
    }
    $.messager.confirm("提示", "确认删除【" + selectRow.TStationDesc + "】吗", function (r) {
        if (r) {
            var ret = tkMakeServerCall(_GV.StationClassName, "Delete", id)
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
                _GV.EditStationRow = -1;
                $("#StationList").datagrid("reload");
                init_sumTree();
            }
        }
    });
}



/**
 * [设置详细信息的值]
 * @Author wangguoying
 * @Date 2022-03-24
 */
function set_detail() {
    var selectRow = $("#TimeList").datagrid("getSelected");
    if (selectRow == "" || selectRow == null || selectRow.TRowID == "") {
        clean_detail();
        return false;
    }
    set_detail_enable(true);
    var info = tkMakeServerCall(_GV.className, _GV.TimeRecordName, selectRow.TRowID);
    var resultArr = info.split("^");
    $("#TotalNum").val(resultArr[3]);
    $("#SexNum").val(resultArr[4] + "-" + resultArr[5]);
    $("#EmptyNum").val(resultArr[6]);
    $("#RealNum").val(resultArr[7]);
    $("#VIPList").datagrid("load", {
        ClassName: _GV.className,
        QueryName: _GV.VIPQueryName,
        ParRef: selectRow.TRowID
    });
    $("#StationList").datagrid("load", {
        ClassName: _GV.className,
        QueryName: _GV.StationQueryName,
        ParRef: selectRow.TRowID
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
    $("#BtnSaveNum").linkbutton(enable);
    $("#BtnAddVIP").linkbutton(enable);
    $("#BtnDelVIP").linkbutton(enable);
    $("#BtnSaveVIP").linkbutton(enable);
}

/**
 * [清除详细信息]
 * @Author wangguoying
 * @Date 2022-03-24
 */
function clean_detail() {
    set_detail_enable(false);
    $("#VIPList").datagrid("load", {
        ClassName: _GV.className,
        QueryName: _GV.VIPQueryName,
        ParRef: ""
    });
}

/**
 * [保存数量]
 * @param    {[String]}    param    []
 * @return   {[object]}    
 * @Author wangguoying
 * @Date 2022-03-24
 */
function save_num() {
    var selectRow = $("#TimeList").datagrid("getSelected");
    if (selectRow == "" || selectRow == null || selectRow.TRowID == "") {
        $.messager.popover({
            msg: "请选择时间段！",
            type: "error"
        });
        return false;
    }
    var TotalNum = $("#TotalNum").val();
    var SexNum = $("#SexNum").val();
    if (SexNum == "") SexNum = "-";
    var maleNum = SexNum.split("-")[0];
    var femaelNum = SexNum.split("-")[1];
    var emptyNum = $("#EmptyNum").val();
    var realNum = $("#RealNum").val();
    if (TotalNum == "" || emptyNum == "" || realNum == "") {
        $.messager.popover({
            msg: "总数量、空预约、实预约数量均不能为空！",
            type: "error"
        });
        return false;
    }
    if (parseInt(TotalNum) != (parseInt(emptyNum) + parseInt(realNum))) {
        $.messager.popover({
            msg: "总数量不等于空预约+实预约，不允许保存！",
            type: "error"
        });
        return false;
    }
    var param = {}
    if (_GV.Type == "M") {
        param = {
            PTMNum: TotalNum,
            PTMMaleNum: maleNum,
            PTMFemaleNum: femaelNum,
            PTMEmptyNum: emptyNum,
            PTMRealNum: realNum
        }
    } else {
        param = {
            PTTNum: TotalNum,
            PTTMaleNum: maleNum,
            PTTFemaleNum: femaelNum,
            PTTEmptyNum: emptyNum,
            PTTRealNum: realNum
        }
    }
    var ret = tkMakeServerCall(_GV.className, _GV.UpdateTimeName, _GV.ParRef, selectRow.TRowID, JSON.stringify(param), _GV.LocID, session["LOGON.USERID"], _GV.WeekNum);
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
        init_sumTree();
    }
}

$(init);