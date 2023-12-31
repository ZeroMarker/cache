function initPage(){
    initEquipRecord();
}

function initEquipRecord() {
    $("#equipRecordBox").datagrid({
        fit: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        pageList: [10, 20, 30, 40, 50, 100, 200],
        pageSize: 200,
        url: ANCSP.DataQuery,
        toolbar: "#equipRecordTools",
        columns: [
            [{
                    field: "RowId",
                    title: "RowId",
                    width: 100,
                    hidden: true
                },
                {
                    field: "EquipCode",
                    title: "设备代码",
                    width: 120,
                    hidden: true
                },
                {
                    field: "EquipDesc",
                    title: "设备名称",
                    width: 120
                },
                {
                    field: "OperRoomDesc",
                    title: "手术间",
                    width: 100
                },
                {
                    field: "StartDT",
                    title: "扫描时间",
                    width: 160
                },
                {
                    field: "UpdateUserDesc",
                    title: "扫描用户",
                    width: 100
                },
                {
                    field: "Operators",
                    title: "操作",
                    width: 80,
                    formatter: function(value, row, index) {
                        var html = "<a href='#' id='" + row.EquipCode + "' class='hisui-linkbutton equiprecord-btn' data-options='plain:true' iconcls='icon-remove' data-rowid='" + row.RowId + "'></a>";
                        return html;
                    }
                }
            ]
        ],
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.EquipRecord;
            param.QueryName = "FindEquipRecords";
            param.Arg1 = session.RecordSheetID;
            param.ArgCnt = 1;
        },
        onLoadSuccess: function(data) {
            if (data && data.rows && data.rows.length > 0) {
                $(".equiprecord-btn").linkbutton({
                    onClick: function() {
                        var rowid = $(this).attr("data-rowid");
                        $.messager.confirm("确认", "是否删除该设备使用记录？", function(result) {
                            if (result) {
                                var msg = dhccl.removeData(ANCLS.Model.EquipRecord, rowid);
                                dhccl.showMessage(msg, "删除", null, null, function() {
                                    $("#equipRecordBox").datagrid("reload");
                                });
                            }
                        });
                    }
                });

                var equipArray = [];
                for (var i = 0; i < data.rows.length; i++) {
                    if (equipArray.length > 0) equipArray.push(splitchar.comma);
                    equipArray.push(data.rows[i].EquipDesc);
                }
                $("#EquipDesc").val(equipArray.join(splitchar.empty));
            }
        }
    });

    $("#ScanEquipCode").keypress(function(e) {
        if (e.keyCode == 13) {
            addEquipRecord($(this).val());
        }
    });

}

function addEquipRecord(equipRecordCode) {
    var equipCode = $.trim(equipRecordCode);
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.EquipRecord,
        MethodName: "SaveEquipRecord",
        Arg1: session.RecordSheetID,
        Arg2: equipCode,
        Arg3: session.UserID,
        ArgCnt: 3
    }, function(data) {
        $("#equipRecordBox").datagrid("reload");
        $("#ScanEquipCode").val("");
    });
}

$(document).ready(initPage);