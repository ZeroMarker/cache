/**
 * Description: ����ʱ��ά��
 * FileName: dhcpe.prehome.time.js
 * Creator: wangguoying
 * Date: 2022-12-19
 */

var _GV = {
    PGADM: $("#H_PGADM").val(),
    ParRef: $("#H_ParRef").val(),
    DateStr: $("#H_DateStr").val(),
    LogicalDate: $("#H_LogicalDate").val(),
    EditTimeRow: -1, //ʱ�α༭�к�
    EditTeamRow: -1, //����༭�к�
    timeColumns: [{ field: 'TID', hidden: true },
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
        field: 'TNumMale', width: 60, align: 'center', title: '��������',
        editor: {
            type: "numberbox",
            options: {
                min: 0
            }
        }
    },
    {
        field: 'TNumFemale', width: 60, align: 'center', title: 'Ů������',
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
    /** ʱ����Ϣ */
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
            text: "����ʱ��",
            iconCls: "icon-add",
            handler: add_time
        }, {
            text: "ɾ��",
            iconCls: "icon-remove",
            handler: delete_time
        }, "-", {
            text: "����",
            iconCls: "icon-save",
            handler: save_time
        }]
    });


    /** �����б� */
    $HUI.datagrid("#TeamList", {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCPE.PreHomeTeam",
            QueryName: "QueryHomeTeam",
            ParRef: ""
        },
        columns: [[{ field: 'TTID', hidden: true },
        {
            field: 'TTeamDesc', width: 100, align: 'center', title: '����',
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
            field: 'TNumMale', width: 60, align: 'center', title: '��������',
            editor: {
                type: "numberbox",
                options: {
                    min: 0
                }
            }
        },
        {
            field: 'TNumFemale', width: 60, align: 'center', title: 'Ů������',
            editor: {
                type: "numberbox",
                options: {
                    min: 0
                }
            }
        }, {
            field: 'TTag', width: 60, align: 'center', title: '��־λ',
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
            text: "��������",
            disabled: true,
            iconCls: "icon-add",
            handler: add_team
        }, {
            id: "BtnDelTeam",
            text: "ɾ��",
            disabled: true,
            iconCls: "icon-remove",
            handler: delete_team
        }, "-", {
            id: "BtnSaveTeam",
            text: "����",
            disabled: true,
            iconCls: "icon-save",
            handler: save_team
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
        TID: "",
        TStartTime: "",
        TEndTime: ""
    });
    $("#TimeList").datagrid("beginEdit", newIndex);
    _GV.EditTimeRow = newIndex;
}


/**
 * [���ӷ���]  
 * @Author wangguoying
 * @Date 2022-03-23
 */
function add_team() {
    if (_GV.EditTeamRow != -1) {
        $.messager.popover({
            msg: "����δ�����VIP��¼���뱣����ٲ�����",
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
        $.messager.popover({ msg: "����ɹ�", type: "success" });
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
 * [�������]  
 * @Author wangguoying
 * @Date 2022-03-24
 */
function save_team() {
    var timeRow = $("#TimeList").datagrid("getSelected");
    if (timeRow == "" || timeRow == null || timeRow.TID == "") {
        $.messager.popover({
            msg: "��ѡ��ʱ��Σ�",
            type: "error"
        });
        return false;
    }
    if (_GV.EditTeamRow == -1) {
        $.messager.popover({
            msg: "û�����ڱ༭�����ݣ�����Ҫ���棡",
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
        $.messager.popover({ msg: "���鲻��Ϊ�գ�", type: "error" });
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
            msg: "����ɹ�",
            type: "success"
        });
        _GV.EditTeamRow = -1;
        $("#TeamList").datagrid("reload");
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
    var id = selectRow.TID;
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
            var ret = tkMakeServerCall("web.DHCPE.PreHomeTeam", "DeleteTime", id)
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
                clean_detail();
            }
        }
    });
}


/**
 * [ɾ������] 
 * @Author wangguoying
 * @Date 2022-03-24
 */
function delete_team() {
    var selectRow = $("#TeamList").datagrid("getSelected")
    if (selectRow == "" || selectRow == null) {
        $.messager.popover({
            msg: "��ѡ��Ҫɾ���ļ�¼��",
            type: "error"
        });
        return false;
    }
    var index = $("#TeamList").datagrid("getRowIndex", selectRow);
    var id = selectRow.TID;
    if (index == _GV.EditTeamRow && id == "") {
        $("#TeamList").datagrid("deleteRow", index); //ֱ���Ƴ�
        _GV.EditTeamRow = -1;
        return true;
    }
    if (_GV.EditTeamRow != -1 && _GV.EditTeamRow != index) {
        $.messager.popover({
            msg: "����δ����ļ�¼���뱣��������",
            type: "error"
        });
        return false;
    }
    $.messager.confirm("��ʾ", "ȷ��ɾ����" + selectRow.TTeamDesc + "����", function (r) {
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
                    msg: "��ɾ��",
                    type: "success"
                });
                _GV.EditTeamRow = -1;
                $("#TeamList").datagrid("reload");
            }
        }
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
    $("#BtnAddTeam").linkbutton(enable);
    $("#BtnDelTeam").linkbutton(enable);
    $("#BtnSaveTeam").linkbutton(enable);
}

/**
 * [�����ϸ��Ϣ]
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