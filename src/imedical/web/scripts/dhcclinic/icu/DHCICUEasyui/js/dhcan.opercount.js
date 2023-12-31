var opsId = dhccl.getQueryString("opsId");
var selectOperBlade,
    editIndex;
var objtest;

$(function() {
    loadOperDatas();
    //同步消毒包
    $("#btnAddMaterials").linkbutton({
            onClick: function() {
                var surMaterialsId = $("#SurgicalMaterials").val();
            }
        })
        //保存清点记录
    $("#btnSaveInventory").linkbutton({
        onClick: function() {
            var dataModuleList = $("#dataBox").datagrid("getData");
            var surgicalInventoryList = [],
                surInventoryDetailList = [],
                inventoryList = [];
            var currentDate = new Date();
            var today = currentDate.getFullYear() + "-" + (currentDate.getMonth() + 1) + "-" + currentDate.getDate();
            var currentTime = currentDate.toLocaleTimeString();
            if (opsId) {
                surgicalInventoryList.push({
                    OperSchedule: opsId,
                    OperBlade: (selectOperBlade) ? selectOperBlade.RowId : "",
                    CreateUserID: session.UserID,
                    ClassName: "DHCAN.SurgicalInventory"
                });

                if (dataModuleList.total > 0) {
                    for (var i = 0; i < dataModuleList.total; i++) {
                        surInventoryDetailList.push({
                            RowId: dataModuleList.rows[i].RowId,
                            SurgicalInventory: "",
                            SurgicalMaterials: dataModuleList.rows[i].SurgicalMaterials,
                            PreopCount: dataModuleList.rows[i].PreopCount,
                            PreCloseCount: dataModuleList.rows[i].PreCloseCount,
                            PostCloseCount: dataModuleList.rows[i].PostCloseCount,
                            PostSewCount: dataModuleList.rows[i].PostSewCount,
                            OperAddCount: dataModuleList.rows[i].OperAddCount,
                            BarCode: dataModuleList.rows[i].BarCode,
                            ClassName: "DHCAN.SurInventoryDetail"
                        })
                    }
                }

                var jsonData = dhccl.formatObjects(surgicalInventoryList) + splitchar.two + dhccl.formatObjects(surInventoryDetailList);
                var data = dhccl.saveDatas(dhccl.csp.dataListService, {
                    jsonData: jsonData,
                    MethodName: "SaveSurInventoryDetail",
                    ClassName: "DHCAN.BLL.SurInventoryDetail"
                });
                dhccl.showMessage(data, "保存", null, null, function() {
                    closeWindow();
                });
                $("#dataBox").datagrid("reload");

            }

        }
    });

    $("#btnAdd").linkbutton({
        onClick: function() {
            var surgicalInventoryList = [],
                sterilityPackList = [];
            if (opsId) {
                surgicalInventoryList.push({
                    OperSchedule: opsId,
                    OperBlade: (selectOperBlade) ? selectOperBlade.RowId : "",
                    CreateUserID: session.UserID,
                    ClassName: "DHCAN.SurgicalInventory"
                });
                sterilityPackList.push({
                    Description: $("#Description").val(),
                    BarCode: $("#BarCode").val(),
                    ActiveDate: $("#ActiveDT").datetimebox("getValue").split(" ")[0],
                    ActiveTime: $("#ActiveDT").datetimebox("getValue").split(" ")[1],
                    ExpireDate: $("#ExpireDT").datetimebox("getValue").split(" ")[0],
                    ExpireTime: $("#ExpireDT").datetimebox("getValue").split(" ")[1],
                    CheckUserID: session.UserID,
                    ClassName: "DHCAN.SterilityPack"
                })
                var jsonData = dhccl.formatObjects(surgicalInventoryList) + splitchar.two + dhccl.formatObjects(sterilityPackList);
                var data = dhccl.saveDatas(dhccl.csp.dataListService, {
                    jsonData: jsonData,
                    MethodName: "saveSterilityPack",
                    ClassName: "DHCAN.BLL.SurInventoryDetail"
                })
                dhccl.showMessage(data, "保存", null, null, function() {
                    closeWindow();
                });
                $("#packBox").datagrid("reload");
            }
        }
    });
    $("#btnEdit").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected($("#packBox"), true)) {
                var sterilityPackList = [];
                var selectRow = $("#packBox").datagrid("getSelected");
                if (selectRow) {
                    sterilityPackList.push({
                        RowId: selectRow.RowId,
                        SurgicalInventory: selectRow.SurgicalInventory,
                        Description: $("#Description").val(),
                        BarCode: $("#BarCode").val(),
                        ActiveDate: $("#ActiveDT").datetimebox("getValue").split(" ")[0],
                        ActiveTime: $("#ActiveDT").datetimebox("getValue").split(" ")[1],
                        ExpireDate: $("#ExpireDT").datetimebox("getValue").split(" ")[0],
                        ExpireTime: $("#ExpireDT").datetimebox("getValue").split(" ")[1],
                        CheckUserID: session.UserID,
                        ClassName: "DHCAN.SterilityPack"
                    })
                }
                if (sterilityPackList.length > 0) {
                    var jsonData = dhccl.formatObjects(sterilityPackList);
                    $.ajax({
                        url: dhccl.csp.dataListService,
                        data: {
                            jsonData: jsonData,
                        },
                        type: "post",
                        async: false,
                        success: function(data) {
                            dhccl.showMessage(data, "保存", null, null, function() {});
                        }
                    })
                }
                $("#packForm").form("clear");
                $("#packBox").datagrid("reload");
            }
        }
    });
    $("#btnDel").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected($("#packBox"), true)) {
                var selectRow = $("#packBox").datagrid("getSelected");
                if (selectRow) {
                    var selectRowIndex = $("#packBox").datagrid("getRowIndex", selectRow)
                    $("#packBox").datagrid("deleteRow", selectRowIndex);
                    if ((selectRow.RowId) && (selectRow.RowId != "")) {
                        $.messager.confirm("确认", "您确认要删除" + selectRow.Description + "?", function(r) {
                            if (r) {
                                var msg = dhccl.removeData("DHCAN.SterilityPack", selectRow.RowId)
                                dhccl.showMessage(msg, "删除", null, null, function() {
                                    $("#packForm").form("clear");
                                    $("#packBox").datagrid("reload");
                                });
                            }
                        })
                    }
                }
            }
        }
    })

    $("#btnSave").linkbutton({
        onClick: function() {
            var operDatas = getOperDatas();
            if (operDatas && operDatas.length > 0) {
                var jsonData = dhccl.formatObjects(operDatas);
                $.ajax({
                    url: dhccl.csp.dataListService,
                    data: {
                        jsonData: jsonData
                    },
                    type: "post",
                    async: false,
                    success: function(data) {
                        dhccl.showMessage(data, "保存", null, null, function() {
                            window.location.reload();
                        });
                    }
                });
            }
        }
    })
    $("#btnPrint").linkbutton({
        onClick: function() {
            var recordDatas = $("#dataBox").datagrid("getRows");
            var packDatas = $("#packBox").datagrid("getRows");
            var lodop = getLodop();
            if (recordDatas && recordDatas.length > 0) {
                CreatPrintOperRecord(recordDatas, "opercount", lodop);
            }
            if (packDatas && packDatas.length > 0) {
                lodop.NewPage();
                CreatPrintPack(packDatas, "operpack", lodop);
            }
            if ((recordDatas.length == 0) && (packDatas.length > 0)) {
                $.messager.alert("提示", "列表无数据可打印", "warning");
                return;
            }
            lodop.PREVIEW();
        }
    })
});

//手术包
$("#SurgicalKits").combobox({
    valueField: "RowId",
    textField: "Description",
    url: ANCSP.DataQuery,
    queryParams: {
        ClassName: dhcan.bll.dataQuery,
        QueryName: "FindSurgicalKits",
        ArgCnt: 0
    },
    mode: "remote",
    onSelect: function(record) {
        $.messager.confirm("确认", "是否添加该手术包清点物品？", function(r) {
            if (r) {
                var dataList = dhccl.getDatas(ANCSP.DataQuery, {
                    ClassName: dhcan.bll.dataQuery,
                    QueryName: "FindSurKitMaterial",
                    Arg1: record.RowId,
                    ArgCnt: 1
                }, "json")
                if (dataList.length > 0) {
                    for (var i = 0; i < dataList.length; i++) {
                        $("#dataBox").datagrid("appendRow", {
                            SurgicalMaterials: dataList[i].SurgicalMaterials,
                            SurgicalMaterialsDesc: dataList[i].SurgicalMaterialsDesc,
                            PreopCount: (dataList[i].DefaultQty) ? dataList[i].DefaultQty : 0,
                            PreCloseCount: 0,
                            PostCloseCount: 0,
                            PostSewCount: 0,
                            OperAddCount: 0,
                            BarCode: ""
                        })
                    }
                }

            }
        })
    }
});
//手术物品
$("#SurgicalMaterials").combobox({
    valueField: "RowId",
    textField: "Description",
    url: ANCSP.DataQuery,
    queryParams: {
        ClassName: dhcan.bll.dataQuery,
        QueryName: "FindSurgicalMaterials",
        ArgCnt: 0
    },
    mode: "remote",
    onSelect: function(record) {
        if (IsExist(record.RowId)) {
            $.messager.alert("提示", "该手术物品已存在！", "warning");
            return;
        } else {
            $.messager.confirm("提示", "是否添加“" + record.Description + "”到清点列表？", function(r) {
                if (r) {
                    $("#dataBox").datagrid("appendRow", {
                        SurgicalMaterials: record.RowId,
                        SurgicalMaterialsDesc: record.Description,
                        PreopCount: 0,
                        PreCloseCount: 0,
                        PostCloseCount: 0,
                        PostSewCount: 0,
                        OperAddCount: 0,
                        BarCode: ""
                    })
                    $("#SurgicalMaterials").combobox("clear");
                }
            })
        }
    }
});
//手术切口
$("#OperBlade").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: dhcan.bll.dataQuery,
            QueryName: "FindBladeType",
            ArgCnt: 0
        },
        mode: "remote",
        onSelect: function(record) {
            selectOperBlade = record;
        }
    })
    //手术清点列表
$("#dataBox").datagrid({
    fit: true,
    singleSelect: true,
    rownumbers: true,
    pagination: true,
    pageList: [10, 20, 30, 40, 50, 100, 200],
    pageSize: 200,
    url: dhccl.csp.dataQuery,
    columns: [
        [
            { field: "RowId", title: "RowId", width: 100, hidden: true },
            { field: "SurgicalMaterials", title: "手术物品", width: 100, hidden: true },
            { field: "SurgicalMaterialsDesc", title: "手术物品", width: 100 },
            { field: "PreopCount", title: "术前清点", width: 60, editor: { type: 'numberbox' } },
            { field: "OperAddCount", title: "术中加数", width: 60, editor: { type: 'numberbox' } },
            { field: "PreCloseCount", title: "关腔前清点", width: 60, editor: { type: 'numberbox' } },
            { field: "PostCloseCount", title: "关腔后清点", width: 60, editor: { type: 'numberbox' } },
            { field: "PostSewCount", title: "缝皮后清点", width: 60, editor: { type: 'numberbox' } },
            { field: "BarCode", title: "无菌包条号", width: 100, hidden: true },
            {
                field: "operators",
                title: "",
                width: 50,
                formatter: function(value, row, index) {
                    return '<a href="#" id="Delete" title="删除此行" class="delete_instrument easyui-linkbutton" iconcls="icon-remove">删除</a>'
                }
            }
        ]
    ],
    queryParams: {
        ClassName: dhcan.bll.dataQuery,
        QueryName: "FindSurInventoryDetail",
        Arg1: opsId,
        ArgCnt: 1
    },
    onClickCell: onClickCell
});
//无菌包
$("#packBox").datagrid({
    fit: true,
    singleSelect: true,
    rownumbers: true,
    pagination: true,
    pageList: [10, 20, 30, 40, 50, 100, 200],
    pageSize: 200,
    url: ANCSP.DataQuery,
    columns: [
        [
            { field: "RowId", title: "RowId", width: 100, hidden: true },
            { field: "SurgicalInventory", title: "SurgicalInventory", width: 100, hidden: true },
            { field: "Description", title: "无菌包名称", width: 120 },
            { field: "BarCode", title: "条号", width: 160 },
            { field: "ActiveDT", title: "灭菌时间", width: 200 },
            { field: "ExpireDT", title: "失效时间", width: 200 },
        ]
    ],
    queryParams: {
        ClassName: dhcan.bll.dataQuery,
        QueryName: "FindSterilityPack",
        Arg1: opsId,
        ArgCnt: 1
    },
    onSelect: function(rowIndex, rowData) {
        $("#packForm").form("load", rowData);
    }
})

function onClickCell(rowindex, rowfield) {
    if (endEditing()) {
        $("#dataBox").datagrid('selectRow', rowindex).datagrid('editCell', { index: rowindex, field: rowfield });
        editIndex = rowindex;
    }
}

function endEditing() {
    if (editIndex == undefined) { return true; }
    if ($("#dataBox").datagrid("validateRow", editIndex)) {
        $("#dataBox").datagrid('endEdit', editIndex);
        editIndex = undefined;
        return true;
    } else {
        return false;
    }
}

//判断是否已添加该手术物品
function IsExist(RowId) {
    var dataBoxList = $("#dataBox").datagrid("getData");
    for (var i = 0; i < dataBoxList.total; i++) {
        var surMeterials = dataBoxList.rows[i].SurgicalMaterials;
        if (surMeterials == RowId) {
            return true;
        }
    }
    return false;
}

//datagrid 删除数据操作
$(document).delegate("a.delete_instrument", "click", function() {
    if (dhccl.hasRowSelected($("#dataBox"), true)) {
        var selectRow = $("#dataBox").datagrid("getSelected");
        if (selectRow) {
            var selectRowIndex = $("#dataBox").datagrid("getRowIndex", selectRow)
            $("#dataBox").datagrid("deleteRow", selectRowIndex);
            if ((selectRow.RowId) && (selectRow.RowId != "")) {
                $.messager.confirm("确认", "您确认要删除" + selectRow.SurgicalMaterialsDesc + "?", function(r) {
                    if (r) {
                        var msg = dhccl.removeData("DHCAN.SurInventoryDetail", selectRow.RowId)
                        dhccl.showMessage(msg, "删除", null, null, function() {
                            $("#dataForm").form("clear");
                            $("#dataBox").datagrid("reload");
                        });
                    }
                })
            }
        }
    }
})

$(".sign").each(function(i, obj) {
    $(this).keypress(function(e) {
        var code = e.keyCode || e.which;
        if (code == 13) {
            $.post(dhccl.csp.methodService, {
                ClassName: "DHCCL.BLL.Admission",
                MethodName: "GetUserInfoByInitials",
                Arg1: $(this).val(),
                ArgCnt: 1
            }, function(data) {
                var datalist = data.split("^")
                var type = $.trim(datalist[0]);
                $("#" + obj.id).val(datalist[4]);
            })
        }
    })
})

function getOperCountRecordConfig() {
    var result = null;
    $.ajaxSettings.async = false;
    $.getJSON("../service/dhcanop/data/opercountrecord.json", function(data) {
        result = data;
    }).error(function(message) {
        alert(message);
    })
    $.ajaxSettings.async = true;
    return result;
}

function getPrintConfig(arrangeConfig, configCode) {
    var result = null;
    if (arrangeConfig && arrangeConfig.print && arrangeConfig.print.length > 0) {
        for (var i = 0; i < arrangeConfig.print.length; i++) {
            var element = arrangeConfig.print[i];
            if (element.code == configCode) {
                result = element;
            }
        }
    }
    return result;
}

// 获取手术申请信息
function getOperAppInfo() {
    var datas = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: dhcan.bll.operSchedule,
            QueryName: "FindOperScheduleList",
            Arg1: "",
            Arg2: "",
            Arg3: session.DeptID,
            Arg4: opsId,
            ArgCnt: 4
        }, "json"),
        result = null;
    if (datas && datas.length > 0) {
        result = datas[0];
    }
    return result;
}

function CreatPrintOperRecord(printDatas, configCode, lodop) {
    var recordConfig = getOperCountRecordConfig();
    var printConfig = getPrintConfig(recordConfig, configCode);

    lodop.PRINT_INIT("打印手术清点项");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.ADD_PRINT_HTM(20, 0, "100%", 50, "<h2 style='text-align:center'>XXX人民医院<br>手&nbsp;&nbsp;&nbsp;&nbsp;术&nbsp;&nbsp;&nbsp;&nbsp;清&nbsp;&nbsp;&nbsp;&nbsp;点&nbsp;&nbsp;&nbsp;&nbsp;单</h2>");

    var printStyleCSS = '<link rel="stylesheet" type="text/css" href="../service/dhcanop/css/opercountrecordprint.css" />';
    var operAppInfo = getOperAppInfo(); //获取手术申请信息
    //console.log(operAppInfo);
    var titleInfo = {
        "OperationDate": operAppInfo.OperDate,
        "PatDeptDesc": operAppInfo.PatDeptDesc,
        "PatBedCode": operAppInfo.PatBedCode,
        "PatName": operAppInfo.PatName,
        "PatGender": operAppInfo.PatGender,
        "PatAge": operAppInfo.PatAge,
        "RegNo": operAppInfo.RegNo,
        "OperationDesc": operAppInfo.OperationDesc,
        "OPC_TransBlood_BloodType": $("#OPC_TransBlood_BloodType").val(),
        "OPC_TransBlood_BloodDesc": $("#OPC_TransBlood_BloodDesc").val(),
        "OPC_TransBlood_BloodVolume": $("#OPC_TransBlood_BloodVolume").val()
    }
    var signInfo = {
        "OPC_PreOPScrubNurseSign": $("#OPC_PreOPScrubNurseSign").val(),
        "OPC_PreOPCirculNurseSign": $("#OPC_PreOPCirculNurseSign").val(),
        "OPC_PreCloseScrubNurseSign": $("#OPC_PreCloseScrubNurseSign").val(),
        "OPC_PreCloseCirculNurseSign": $("#OPC_PreCloseCirculNurseSign").val(),
        "OPC_PostCloseScrubNurseSign": $("#OPC_PostCloseScrubNurseSign").val(),
        "OPC_PostCloseCirculNurseSign": $("#OPC_PostCloseCirculNurseSign").val()
    }
    var html = printStyleCSS + '<div class="titles"><div>'
    html += '<span><label>手术日期:</label><input id="OperationDate" name="OperationDate" type="text" class="line-textbox patinfo-item" value=' + titleInfo.OperationDate + '></span>'
    html += '<span><label>科室:</label><input id="PatDeptDesc" name="PatDeptDesc" type="text" class="line-textbox patinfo-item" value=' + titleInfo.PatDeptDesc + '></span>'
    html += '<span><label>床号:</label><input id="PatBedCode" name="PatBedCode" type="text" class="line-textbox patinfo-item" value=' + titleInfo.PatBedCode + '></span>'
    html += '</div><div>'
    html += '<span><label>姓名:</label><input id="PatName" name="PatName" type="text" class="line-textbox patinfo-item" value=' + titleInfo.PatName + '></span>'
    html += '<span><label>性别:</label><input id="PatGender" name="PatGender" type="text" class="line-textbox patinfo-item" value=' + titleInfo.PatGender + '></span>'
    html += '<span><label>年龄:</label><input id="PatAge" name="PatAge" type="text" class="line-textbox patinfo-item" value=' + titleInfo.PatAge + '></span>'
    html += '<span><label>登记号:</label><input id="RegNo" name="RegNo" type="text" class="line-textbox patinfo-item" value=' + titleInfo.RegNo + '></span>'
    html += '</div><div>'
    html += '<span><label>手术名称:</label><input id="OperationDesc" name="OperationDesc" type="text" class="line-textbox patinfo-item" value=' + titleInfo.OperationDesc + '></span>'
    html += '<span><label>血型:</label><input id="OPC_TransBlood_BloodType" name="OPC_TransBlood_BloodType" type="text" class="line-textbox patinfo-item" value=' + titleInfo.OPC_TransBlood_BloodType + '></span>'
    html += '<span><label>成分:</label><input id="OPC_TransBlood_BloodDesc" name="OPC_TransBlood_BloodDesc" type="text" class="line-textbox patinfo-item" value=' + titleInfo.OPC_TransBlood_BloodDesc + '></span>'
    html += '<span><label>血量:</label><input id="OPC_TransBlood_BloodVolume" name="OPC_TransBlood_BloodVolume" type="text" class="line-textbox patinfo-item" value=' + titleInfo.OPC_TransBlood_BloodVolume + '></span>'
    html += '</div></div>'
    lodop.ADD_PRINT_HTM(90, 0, "100%", 200, html);
    //打印表格
    html = printStyleCSS + "<table class='print-table'><thead><tr>"
    console.log(printConfig);
    for (var i = 0; i < printConfig.columns.length; i++) {
        var column = printConfig.columns[i];
        html += "<th>" + column.title + "</th>";
    }
    html += "</tr></thead><tbody>";
    for (var i = 0; i < printDatas.length; i++) {
        var printData = printDatas[i];
        html += "<tr>";
        for (var j = 0; j < printConfig.columns.length; j++) {
            var column = printConfig.columns[j];
            html += "<td>" + printData[column.field] + "</td>";
        }
        html += "</tr>";
    }
    html += "</tbody></table>"

    html += '<div class="signs">'
    html += '<span><label>术前清点：护士(医师)签名:</label><input id="OPC_PreOPScrubNurseSign" name="OPC_PreOPScrubNurseSign" type="text" class="line-textbox sign" value=' + signInfo.OPC_PreOPScrubNurseSign + '></span>'
    html += '<span><label>术前清点：巡回护士签名:</label><input id="OPC_PreOPCirculNurseSign" name="OPC_PreOPCirculNurseSign" type="text" class="line-textbox sign" value=' + signInfo.OPC_PreOPCirculNurseSign + '></span>'
    html += '<span><label>关前清点：护士(医师)签名:</label><input id="OPC_PreCloseScrubNurseSign" name="OPC_PreCloseScrubNurseSign" type="text" class="line-textbox sign" value=' + signInfo.OPC_PreCloseScrubNurseSign + '></span>'
    html += '<span><label>关前清点：巡回护士签名:</label><input id="OPC_PreCloseCirculNurseSign" name="OPC_PreCloseCirculNurseSign" type="text" class="line-textbox sign" value=' + signInfo.OPC_PreCloseCirculNurseSign + '></span>'
    html += '<span><label>关后清点：护士(医师)签名:</label><input id="OPC_PostCloseScrubNurseSign" name="OPC_PostCloseScrubNurseSign" type="text" class="line-textbox sign" value=' + signInfo.OPC_PostCloseScrubNurseSign + '></span>'
    html += '<span><label>关后清点：巡回护士签名:</label><input id="OPC_PostCloseCirculNurseSign" name="OPC_PostCloseCirculNurseSign" type="text" class="line-textbox sign" value=' + signInfo.OPC_PostCloseCirculNurseSign + '></span>'
    html += '</div>'
    lodop.ADD_PRINT_HTM(290, 0, "100%", "100%", html);

}

function CreatPrintPack(printDatas, configCode, lodop) {
    var packConfig = getOperCountRecordConfig();
    var printConfig = getPrintConfig(packConfig, configCode);

    var operAppInfo = getOperAppInfo(); //获取手术申请信息
    var titleInfo = {
        "OperationDate": operAppInfo.OperDate,
        "PatDeptDesc": operAppInfo.PatDeptDesc,
        "PatBedCode": operAppInfo.PatBedCode,
        "PatName": operAppInfo.PatName,
        "PatGender": operAppInfo.PatGender,
        "PatAge": operAppInfo.PatAge,
        "RegNo": operAppInfo.RegNo,
        "OperationDesc": operAppInfo.OperationDesc
    }
    lodop.ADD_PRINT_HTM(30, 0, "100%", 50, "<h2 style='text-align:center'>XXX人民医院<br>手&nbsp;&nbsp;&nbsp;&nbsp;术&nbsp;&nbsp;&nbsp;&nbsp;无&nbsp;&nbsp;&nbsp;&nbsp;菌&nbsp;&nbsp;&nbsp;&nbsp;包</h2>");
    var printStyleCSS = '<link rel="stylesheet" type="text/css" href="../service/dhcanop/css/opercountrecordprint.css" />';
    var html = printStyleCSS + '<div class="titles"><div>'
    html += '<span><label>手术日期:</label><input id="OperationDate" name="OperationDate" type="text" class="line-textbox patinfo-item" value=' + titleInfo.OperationDate + '></span>'
    html += '<span><label>科室:</label><input id="PatDeptDesc" name="PatDeptDesc" type="text" class="line-textbox patinfo-item" value=' + titleInfo.PatDeptDesc + '></span>'
    html += '<span><label>床号:</label><input id="PatBedCode" name="PatBedCode" type="text" class="line-textbox patinfo-item" value=' + titleInfo.PatBedCode + '></span>'
    html += '</div><div>'
    html += '<span><label>姓名:</label><input id="PatName" name="PatName" type="text" class="line-textbox patinfo-item" value=' + titleInfo.PatName + '></span>'
    html += '<span><label>性别:</label><input id="PatGender" name="PatGender" type="text" class="line-textbox patinfo-item" value=' + titleInfo.PatGender + '></span>'
    html += '<span><label>年龄:</label><input id="PatAge" name="PatAge" type="text" class="line-textbox patinfo-item" value=' + titleInfo.PatAge + '></span>'
    html += '<span><label>登记号:</label><input id="RegNo" name="RegNo" type="text" class="line-textbox patinfo-item" value=' + titleInfo.RegNo + '></span>'
    html += '</div><div>'
    html += '<span><label>手术名称:</label><input id="OperationDesc" name="OperationDesc" type="text" class="line-textbox patinfo-item" value=' + titleInfo.OperationDesc + '></span>'
    html += '</div></div>'
    lodop.ADD_PRINT_HTM(110, 0, "100%", 100, html);
    //打印表格
    html = printStyleCSS + "<table class='print-table'><thead><tr>"
    console.log(printConfig);
    for (var i = 0; i < printConfig.columns.length; i++) {
        var column = printConfig.columns[i];
        html += "<th>" + column.title + "</th>";
    }
    html += "</tr></thead><tbody>";
    for (var i = 0; i < printDatas.length; i++) {
        var printData = printDatas[i];
        html += "<tr>";
        for (var j = 0; j < printConfig.columns.length; j++) {
            var column = printConfig.columns[j];
            html += "<td>" + printData[column.field] + "</td>";
        }
        html += "</tr>";
    }
    html += "</tbody></table>"
    lodop.ADD_PRINT_HTM(220, 0, "100%", "100%", html);
}