/**
 * Description: ��Դģ��ʱ��ά��
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
    EditTimeRow: -1, //ʱ�α༭�к�
    EditVIPRow: -1, //VIP�༭�к�
    VIPColumns: [{
        field: 'TRowID', hidden: true
    },
    {
        field: 'TVIPID', hidden: true
    },
    {
        field: 'TVIPDesc', width: 160, title: 'VIP�ȼ�', align: 'center',
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
        field: 'TNum', width: 80, align: 'center', title: '����',
        editor: {
            type: "numberbox",
            options: {
                min: 0
            }
        }
    },
    {
        field: 'TMaleNum', width: 80, align: 'center', title: '��������',
        editor: {
            type: "numberbox",
            options: {
                min: 0
            }
        }
    },
    {
        field: 'TFemaleNum', width: 80, align: 'center', title: 'Ů������',
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
        field: 'TStartTime', width: 100, align: 'center', title: '��ʼʱ��',
        editor: {
            type: "timespinner",
            options: {
                showSeconds: true
            }
        }
    },
    {
        field: 'TEndTime', width: 100, align: 'center', title: '����ʱ��',
        editor: {
            type: "timespinner",
            options: {
                showSeconds: true
            }
        }
    },
    {
        field: 'TNum', width: 60, align: 'center', title: '����',
        editor: {
            type: "numberbox",
            options: {
                min: 0
            }
        }
    },
    {
        field: 'TMaleNum', width: 60, align: 'center', title: '��������',
        editor: {
            type: "numberbox",
            options: {
                min: 0
            }
        }
    },
    {
        field: 'TFemaleNum', width: 60, align: 'center', title: 'Ů������',
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
 * [����Type���ñ�����ʹ�õ��෽��]  
 * @Author wangguoying
 * @Date 2022-03-29
 */
function setGVProperty() {
    if (_GV.Type == "M") { //�޶����
        _GV["SumTreeName"] = "GetManagerTree";
        _GV["TimeQueryName"] = "QueryManagerTime";
        _GV["VIPQueryName"] = "QueryManagerTimeVip";
        _GV["TimeRecordName"] = "GetManagerTimeRecord";
        _GV["UpdateTimeName"] = "UpdateManagerTime";
        _GV["UpdateVIPName"] = "UpdateManagerVIP";
        _GV["TimeClassName"] = "User.DHCPESourceTimeManager";
        _GV["VIPClassName"] = "User.DHCPESourceTimeVIPManager";
        var preNumColumn = { field: 'TPreNum', width: 80, align: 'center', title: '��ԤԼ����' };
        _GV.VIPColumns.push(preNumColumn);
        _GV.timeColumns.push(preNumColumn);
    } else { //ģ��
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
    // �������水ť
    $("#BtnSaveNum").click(function (e) {
        save_num();
    });
}

/**
 * [��ʽ��������]
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
    /** ʱ����Ϣ */
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
            text: "����",
            iconCls: "icon-add",
            handler: add_time
        }, {
            text: "ɾ��",
            iconCls: "icon-cancel",
            handler: delete_time
        }, "-", {
            text: "����",
            iconCls: "icon-save",
            handler: save_time
        }]
    });


    /** VIP�б� */
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
            text: "����",
            disabled: true,
            iconCls: "icon-add",
            handler: add_vip
        }, {
            id: "BtnDelVIP",
            text: "ɾ��",
            disabled: true,
            iconCls: "icon-cancel",
            handler: delete_vip
        }, "-", {
            id: "BtnSaveVIP",
            text: "����",
            disabled: true,
            iconCls: "icon-save",
            handler: save_vip
        }]
    });


}

/**
 * [����ʱ���]  
 * @Author wangguoying
 * @Date 2022-03-23
 */
function add_time() {
    if (_GV.EditTimeRow != -1) {
        $.messager.popover({
            msg: "����δ�����ʱ��μ�¼���뱣����ٲ�����",
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
 * [����VIP�ȼ�]  
 * @Author wangguoying
 * @Date 2022-03-23
 */
function add_vip() {
    if (_GV.EditVIPRow != -1) {
        $.messager.popover({
            msg: "����δ�����VIP��¼���뱣����ٲ�����",
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
 * [����ʱ��]  
 * @Author wangguoying
 * @Date 2022-03-24
 */
function save_time() {
    if (_GV.EditTimeRow == -1) {
        $.messager.popover({
            msg: "û�����ڱ༭�����ݣ�����Ҫ���棡",
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
        $.messager.popover({ msg: "��ʼʱ�䲻��Ϊ�գ�", type: "error" });
        return false;
    }
    var ed = $('#TimeList').datagrid('getEditor', {
        index: _GV.EditTimeRow,
        field: 'TEndTime'
    });
    var endTime = $(ed.target).timespinner("getValue");
    if (endTime == "") {
        $.messager.popover({ msg: "����ʱ�䲻��Ϊ�գ�", type: "error" });
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
        $.messager.popover({ msg: "����ɹ�", type: "success" });
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
        //����Ҳ���Ϣ
        clean_detail()
    }
}


/**
 * [����VIP]  
 * @Author wangguoying
 * @Date 2022-03-24
 */
function save_vip() {
    var timeRow = $("#TimeList").datagrid("getSelected");
    if (timeRow == "" || timeRow == null || timeRow.TRowID == "") {
        $.messager.popover({
            msg: "��ѡ��ʱ��Σ�",
            type: "error"
        });
        return false;
    }
    if (_GV.EditVIPRow == -1) {
        $.messager.popover({
            msg: "û�����ڱ༭�����ݣ�����Ҫ���棡",
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
        $.messager.popover({ msg: "VIP�ȼ�����Ϊ�գ�", type: "error" });
        return false;
    }
    var ed = $('#VIPList').datagrid('getEditor', { index: _GV.EditVIPRow, field: 'TNum' });
    var num = $(ed.target).val();
    if (num == "") {
        $.messager.popover({ msg: "����������Ϊ�գ�", type: "error" });
        return false;
    }
    var preNum = parseInt(rows[_GV.EditVIPRow].TPreNum);
    if (parseInt(num) < preNum) {
        $.messager.popover({ msg: "�޶���������С��ԤԼ������", type: "error" });
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
            msg: "����ɹ�",
            type: "success"
        });
        _GV.EditVIPRow = -1;
        $("#VIPList").datagrid("reload");
        init_sumTree();
    }
}

/**
 * [����վ��]  
 * @Author wangguoying
 * @Date 2022-03-24
 */
function save_station() {
    var timeRow = $("#TimeList").datagrid("getSelected");
    if (timeRow == "" || timeRow == null || timeRow.TRowID == "") {
        $.messager.popover({
            msg: "��ѡ��ʱ��Σ�",
            type: "error"
        });
        return false;
    }
    if (_GV.EditStationRow == -1) {
        $.messager.popover({
            msg: "û�����ڱ༭�����ݣ�����Ҫ���棡",
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
            msg: "վ�㲻��Ϊ�գ�",
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
            msg: "��������Ϊ�գ�",
            type: "error"
        });
        return false;
    }
    var preNum = parseInt(rows[_GV.EditStationRow].TPreNum);
    if (parseInt(num) < preNum) {
        $.messager.popover({
            msg: "�޶���������С��ԤԼ������",
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
            msg: "����ɹ�",
            type: "success"
        });
        _GV.EditStationRow = -1;
        $("#StationList").datagrid("reload");
        init_sumTree();
    }
}



/**
 * [ɾ��ʱ���] 
 * @Author wangguoying
 * @Date 2022-03-24
 */
function delete_time() {
    var selectRow = $("#TimeList").datagrid("getSelected")
    if (selectRow == "" || selectRow == null) {
        $.messager.popover({
            msg: "��ѡ��Ҫɾ���ļ�¼��",
            type: "error"
        });
        return false;
    }
    var index = $("#TimeList").datagrid("getRowIndex", selectRow);
    var id = selectRow.TRowID;
    if (index == _GV.EditTimeRow && id == "") {
        $("#TimeList").datagrid("deleteRow", index); //ֱ���Ƴ�
        _GV.EditTimeRow = -1;
        return true;
    }
    if (_GV.EditTimeRow != -1 && _GV.EditTimeRow != index) {
        $.messager.popover({
            msg: "����δ����ļ�¼���뱣��������",
            type: "error"
        });
        return false;
    }
    $.messager.confirm("��ʾ", "ȷ��ɾ����" + selectRow.TStartTime + "��-��" + selectRow.TEndTime + "����ʱ����", function (r) {
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
                    msg: "��ɾ��",
                    type: "success"
                });
                _GV.EditTimeRow = -1;
                $("#TimeList").datagrid("reload");
                //����Ҳ���Ϣ
                clean_detail();
                init_sumTree();
            }
        }
    });
}


/**
 * [ɾ��VIP] 
 * @Author wangguoying
 * @Date 2022-03-24
 */
function delete_vip() {
    var selectRow = $("#VIPList").datagrid("getSelected")
    if (selectRow == "" || selectRow == null) {
        $.messager.popover({
            msg: "��ѡ��Ҫɾ���ļ�¼��",
            type: "error"
        });
        return false;
    }
    var index = $("#VIPList").datagrid("getRowIndex", selectRow);
    var id = selectRow.TRowID;
    if (index == _GV.EditVIPRow && id == "") {
        $("#VIPList").datagrid("deleteRow", index); //ֱ���Ƴ�
        _GV.EditVIPRow = -1;
        return true;
    }
    if (_GV.EditVIPRow != -1 && _GV.EditVIPRow != index) {
        $.messager.popover({
            msg: "����δ����ļ�¼���뱣��������",
            type: "error"
        });
        return false;
    }
    $.messager.confirm("��ʾ", "ȷ��ɾ����" + selectRow.TVIPDesc + "����", function (r) {
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
                    msg: "��ɾ��",
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
 * [ɾ��վ��] 
 * @Author wangguoying
 * @Date 2022-03-24
 */
function delete_station() {
    var selectRow = $("#StationList").datagrid("getSelected")
    if (selectRow == "" || selectRow == null) {
        $.messager.popover({
            msg: "��ѡ��Ҫɾ���ļ�¼��",
            type: "error"
        });
        return false;
    }
    var index = $("#StationList").datagrid("getRowIndex", selectRow);
    var id = selectRow.TRowID;
    if (index == _GV.EditStationRow && id == "") {
        $("#StationList").datagrid("deleteRow", index); //ֱ���Ƴ�
        _GV.EditStationRow = -1;
        return true;
    }
    if (_GV.EditStationRow != -1 && _GV.EditStationRow != index) {
        $.messager.popover({
            msg: "����δ����ļ�¼���뱣��������",
            type: "error"
        });
        return false;
    }
    $.messager.confirm("��ʾ", "ȷ��ɾ����" + selectRow.TStationDesc + "����", function (r) {
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
                    msg: "��ɾ��",
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
 * [������ϸ��Ϣ��ֵ]
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
 * [�����Ҳ���ϸ �Ƿ�༭]
 * @param    {[boolean]}    flag    [true������ false������]
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
 * [�����ϸ��Ϣ]
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
 * [��������]
 * @param    {[String]}    param    []
 * @return   {[object]}    
 * @Author wangguoying
 * @Date 2022-03-24
 */
function save_num() {
    var selectRow = $("#TimeList").datagrid("getSelected");
    if (selectRow == "" || selectRow == null || selectRow.TRowID == "") {
        $.messager.popover({
            msg: "��ѡ��ʱ��Σ�",
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
            msg: "����������ԤԼ��ʵԤԼ����������Ϊ�գ�",
            type: "error"
        });
        return false;
    }
    if (parseInt(TotalNum) != (parseInt(emptyNum) + parseInt(realNum))) {
        $.messager.popover({
            msg: "�����������ڿ�ԤԼ+ʵԤԼ���������棡",
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
            msg: "����ɹ�",
            type: "success"
        });
        init_sumTree();
    }
}

$(init);