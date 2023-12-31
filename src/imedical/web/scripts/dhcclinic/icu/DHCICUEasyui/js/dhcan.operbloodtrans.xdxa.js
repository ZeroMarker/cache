function initPage(){
    initBloodTransfusion();
}

function initBloodTransfusion() {
    var columns = [
        [{
                field: "Checked",
                title: "选择",
                width: 60,
                checkbox: true
            }, {
                field: "BloodBarCode",
                title: "储血编码",
                width: 160,
                formatter: function(value, row, index) {
                    if (row.BarCode && row.BarCode !== "") {
                        return row.BarCode + "<br>" + row.ComponentCode + " <strong>" + row.BloodABO + " RhD(" + (row.BloodRH === "阳性" ? "+" : "-") + ")</strong>";
                    }
                    return "";
                }
            },
            {
                field: "BloodCategory",
                title: "血液种类",
                width: 160
            },
            {
                field: "TransABO",
                title: "血型",
                width: 60
            },
            {
                field: "BloodVolUnit",
                title: "用量",
                width: 80,
                formatter: function(value, row, index) {
                    return row.Volume + row.Unit;
                }
            },
            {
                field: "ExecProvDesc",
                title: "输血执行者",
                width: 100
            },
            {
                field: "CheckProvDesc",
                title: "核对者",
                width: 80
            },
            {
                field: "TransStartDT",
                title: "输血开始时间",
                width: 160,
                editor: {
                    type: "datetimebox"
                }
            },
            {
                field: "TransEndDT",
                title: "输血结束时间",
                width: 160,
                editor: {
                    type: "datetimebox"
                }
            },
            {
                field: "CrossMatching",
                title: "交叉配血",
                width: 100
            },
            {
                field: "MatchingProvDesc",
                title: "配血者",
                width: 80
            },
            {
                field: "GrantProvDesc",
                title: "发血者",
                width: 80
            },
            {
                field: "MatchingDT",
                title: "配血时间",
                width: 160
            },
            {
                field: "FetchProvDesc",
                title: "取血者",
                width: 80
            },
            {
                field: "FetchDT",
                title: "取血时间",
                width: 80
            }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#bloodTransBox"),
        gridColumns: columns,
        gridTitle: "",
        gridTool: "#bloodTransTools",
        form: $("#bloodTransForm"),
        modelType: ANCLS.Model.BloodTransRecord,
        queryType: ANCLS.BLL.BloodTransfusion,
        queryName: "FindBloodTransRecord",
        queryParams: {
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        },
        dialog: null,
        addButton: $("#btnAddBloodTrans"),
        editButton: $("#btnEditBloodTrans"),
        delButton: $("#btnDelBloodTrans"),
        queryButton: null,
        submitCallBack: null,
        onSubmitCallBack: setBloodTransParam,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack: null
    });
    dataForm.initDataForm();
    //手术清点列表
    $("#bloodTransBox").datagrid({
        onLoadError: function() {},
        onLoadSuccess: function(data) {
            if (data && data.rows && data.rows.length > 0) {
                var bloodTransDescArr = [];
                var bloodTransInfos = [];
                var bloodTransInfoArr = [];
                for (var i = 0; i < data.rows.length; i++) {
                    var dataRow = data.rows[i];
                    var index = bloodTransDescArr.indexOf(dataRow.BloodCategory);
                    if (index > -1) {
                        bloodTransInfos[index].Volume = Number(bloodTransInfos[index].Volume) + Number(dataRow.Volume);
                    } else {
                        bloodTransDescArr.push(dataRow.BloodCategory);
                        bloodTransInfos.push({
                            Desc: dataRow.BloodCategory,
                            Volume: dataRow.Volume,
                            Unit: dataRow.Unit
                        });
                    }
                }

                for (var index in bloodTransInfos) {
                    bloodTransInfoArr.push(bloodTransInfos[index].Desc + " " + bloodTransInfos[index].Volume + bloodTransInfos[index].Unit);
                }

                $("#BloodTransfusion").val(bloodTransInfoArr.join(','));
            }
        },
        onAfterEdit: function(rowIndex, rowData, changes) {
            if (rowData) {
                var transData = {};
                transData.ClassName = ANCLS.Model.BloodTransRecord;
                transData.UpdateUser = session.UserID;
                transData.RowId = rowData.RowId;
                if (rowData.TransStartDT !== "") {
                    var transStartDT = (new Date()).tryParse(rowData.TransStartDT, "yyyy-MM-dd HH:mm:ss");
                    transData.TransStartDate = transStartDT.format("yyyy-MM-dd");
                    transData.TransStartTime = transStartDT.format("HH:mm");
                }
                if (rowData.TransEndDT !== "") {
                    var transEndDT = (new Date()).tryParse(rowData.TransEndDT, "yyyy-MM-dd HH:mm:ss");
                    transData.TransEndDate = transEndDT.format("yyyy-MM-dd");
                    transData.TransEndTime = transEndDT.format("HH:mm");
                }
                dhccl.saveDatas(ANCSP.DataListService, {
                    jsonData: dhccl.formatObjects(transData)
                }, function(data) {
                    if (data.indexOf("S^") === 0) {
                        //$.messager.alert("提示","输血纪录保存成功！","info");
                    } else {
                        //$.messager.alert("提示","输血纪录保存成功！","info");
                    }
                });
            }
        }
    });

    $("#ScanBloodBarCode").keypress(function(e) {
        if (e.keyCode == 13) {
            // addBloodTransfusion($(this).val())
            var barCode = $("#ScanBloodBarCode").val();
            addBloodTransfusionNewNew(barCode);
        }
    });

    $("#ScanBloodBarCode").focus(function() {
        try {
            dhcclcomm.OpenCom("COM1", "115200");
            scanCode = "Blood";
            // window.parent.CLCom.receiveData("test");
            // window.parent.CLCom.receiveData(window.addEquipRecord);
        } catch (ex) {
            console.log(ex.message);
        }

    });

    // $("#bloodTransBox").datagrid("enableCellEditing");

    $("#btnCheckSign,#btnTransSign").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected($("#bloodTransBox"), true)) {
                var selectedRow = $("#bloodTransBox").datagrid("getSelected");
                var signCode = $(this).attr("data-signcode");
                var originalData = JSON.stringify(selectedRow);
                var signView = new SignView({
                    container: "#signContainer",
                    originalData: originalData,
                    signCode: signCode,
                    saveCallBack: saveSignedData,
                    afterSignCallBack: reloadBloodTrans
                });
                signView.initView();
                signView.open();
            }
        }
    });

    $("#btnPrintBloodTrans").linkbutton({
        onClick: function() {
            printBloodTransfusion();
        }
    });
}

function addBloodTransfusionNewNew(barCode) {
    barCode = barCode.replace("=", "");
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.BloodTransfusion,
        MethodName: "AddBloodTransRecord",
        Arg1: session.RecordSheetID,
        Arg2: barCode,
        Arg3: session.UserID,
        ArgCnt: 3
    }, function(data) {
        if (data.indexOf("S^") == 0) {
            $("#bloodTransBox").datagrid("reload");
            $("#ScanBloodBarCode").val("");
        } else {
            //$.messager.alert("提示","扫码失败，原因："+data,"error");
            alert("扫码失败，原因：" + data);
        }
    });

    return "test";
}

function setBloodTransParam(param) {
    var transStartDTStr = $("#TransStartDT").datetimebox("getValue"),
        transStartDate = "",
        transStartTime = "";
    if (transStartDTStr && transStartDTStr !== "") {
        var transStartDT = (new Date()).tryParse(transStartDTStr);
        transStartDate = transStartDT.format("yyyy-MM-dd");
        transStartTime = transStartDT.format("HH:mm:ss");
    }

    var transEndDTStr = $("#TransEndDT").datetimebox("getValue"),
        transEndDate = "",
        transEndTime = "";
    if (transEndDTStr && transEndDTStr !== "") {
        var transEndDT = (new Date()).tryParse(transEndDTStr);
        transEndDate = transEndDT.format("yyyy-MM-dd");
        transEndTime = transEndDT.format("HH:mm:ss");
    }
    param.TransStartDate = transStartDate;
    param.TransStartTime = transStartTime;
    param.TransEndDate = transEndDate;
    param.TransEndTime = transEndTime;
    param.RecordSheet = session.RecordSheetID;
    param.UpdateUser = session.UserID;
}

function reloadBloodTrans() {
    $("#bloodTransBox").datagrid("reload");
}

$(document).ready(initPage);