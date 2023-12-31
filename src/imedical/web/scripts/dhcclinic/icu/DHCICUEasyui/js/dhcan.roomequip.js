$(document).ready(function() {
    $("#dataBox").datagrid({
        headerCls: 'panel-header-gray'
    });
    var columns = [
        [
            { field: "RoomDesc", title: "手术间", width: 120 },
            { field: "EquipDesc", title: "设备", width: 160 },
            { field: "TcpipAddress", title: "IP地址", width: 200 },
            { field: "ComPort", title: "通讯端口", width: 100 },
            { field: "Program", title: "采集代码", width: 120 },
            { field: "PhysicalPort", title: "物理端口", width: 100 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "手术间设备",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: "DHCAN.RoomEquip",
        queryType: dhcan.bll.dataQuery,
        queryName: "FindRoomEquip",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        openCallBack: initDefaultValue,
        closeCallBack: null
    });
    dataForm.initDataForm();
    dataForm.datagrid.datagrid({
        view: groupview,
        groupField: "RoomDesc",
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterRoom").val();
            param.ArgCnt = 1;
        }
    });

    $("#filterRoom,#Room").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = dhcan.bll.dataQuery;
            param.QueryName = "FindOperRoom";
            param.Arg1 = session.UserID;
            param.ArgCnt = 1;
        }
    });

    $("#Equip").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = dhcan.bll.dataQuery;
            param.QueryName = "FindDevice";
            param.ArgCnt = 0;
        }
    });
});

function initDefaultValue(dataForm) {
    // if (dataForm.hasRowSelected(false) === false) {
    //     $("#Active").combobox("setValue", "Y");
    // }
}