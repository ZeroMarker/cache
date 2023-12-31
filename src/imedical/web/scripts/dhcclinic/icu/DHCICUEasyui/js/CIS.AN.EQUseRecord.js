function initPage(){
    initEquipRecord();
}

function initEquipRecord() {
    $("#equipRecordBox").datagrid({
        fit: true,
        // title:"手术间设备使用记录",
        headerCls:"panel-header-gray",
        bodyCls:"panel-header-gray",
        // iconCls:"icon-paper",
        border:false,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        pageList: [10, 20, 30, 40, 50, 100, 200],
        pageSize: 200,
        url: ANCSP.DataQuery,
		dblclickToEdit:true,
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
                    width: 200
                },
                {
                    field: "UpdateUserDesc",
                    title: "扫描用户",
                    width: 100
                },
				{
                    field: "Duration",
                    title: "使用时长",
                    width: 100,
					editor: { type: "numberbox" },
                },
                {
                    field: "Operators",
                    title: "操作",
                    width: 80,
                    align:"center",
					
                    // halign:"left",
                    formatter: function(value, row, index) {
                        var html = "<a href='#' id='" + row.EquipCode + "' class='hisui-linkbutton equiprecord-btn' data-options='plain:true' iconcls='icon-cancel' data-rowid='" + row.RowId + "'></a>";
                        return html;
                    }
                }
            ]
        ],
		onEndEdit: function(rowIndex, rowData) {
           dhccl.saveDatas(ANCSP.MethodService, {
			ClassName: ANCLS.BLL.EquipRecord,
			MethodName: "SaveDuration",
			Arg1: rowData.RowId,
			Arg2: rowData.Duration,
			ArgCnt: 2
		}, function(data) {
			if(data.indexOf("S^")===0){
				$("#equipRecordBox").datagrid("reload");
			}else{
				$.messager.alert("提示","保存失败，原因："+data,"error");
			}
			
		});
        },
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
    $("#equipRecordBox").datagrid("enableCellEditing");
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
		Arg4: "",
        ArgCnt: 4
    }, function(data) {
        if(data.indexOf("S^")===0){
            $("#equipRecordBox").datagrid("reload");
            $("#ScanEquipCode").val("");
        }else{
            $.messager.alert("提示","保存失败，原因："+data,"error");
        }
        
    });
}

$(document).ready(initPage);