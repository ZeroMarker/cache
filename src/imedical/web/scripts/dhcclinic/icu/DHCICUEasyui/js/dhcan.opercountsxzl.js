var opsId = dhccl.getQueryString("opsId");
var selectInstrumentDevice,
    editIndex;
var objtest;

$(function() {
    operDataManager.initFormData(loadPatInfo);
    initPage();
    operDataManager.setCheckChange();
    signCommon.loadSignature();
    operDataManager.disableSelectedControls("#EquipDesc,#SpecialItemsDesc,#RealOperationDesc");
    if (patInfo.TheatreInDT && patInfo.Anesthesiologist) {
        $("#AnaestMethod").combobox('disable');
    }
});

function initPage() {
    initNursingRecord();
    initSurgicalInventory();
    initEquipRecord();
    initCharge();
    initSurgicalSupply();
    initSterilityPack();
    initBloodTransfusion();
    initDHCCLCommon();
}

var dhcclcomm;
var scanCode;

function initDHCCLCommon() {
    dhcclcomm = document.getElementById("dhcclcomm");
    window.parent.closeComm(closeComm);
}

function closeComm() {
    dhcclcomm.CloseComm();
}

function initNursingRecord() {
    // $("#TheatreInTime").next("span").find("input").attr("readonly","readonly");
    //打印
    $("#btnPrint").linkbutton({
        onClick: printOperCount
    });

    //打印
    $("#btnPrintBack").linkbutton({
        onClick: printOperCountBack
    });

    //保存护理信息
    $("#btnNursingSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
            var anaMethod = $('#AnaestMethod').combobox('getValue');
            if (!anaMethod) {
                anaMethod = "";
            }
            dhccl.saveDatas(ANCSP.MethodService, {
                ClassName: ANCLS.BLL.OperArrange,
                MethodName: 'SaveAnaestMethod',
                Arg1: session.OPSID,
                Arg2: anaMethod,
                ArgCnt: 2
            }, function(data) {
                if (data.indexOf('S') > -1) {

                } else {

                }
            })
        }
    });

    $("#btnRefresh").linkbutton({
        onClick: function() {
            window.location.reload();
        }
    });

    $("#btnPreScNurseSign,#btnPreCirNurseSign,#btnPreScNurseSign2,#btnPreCirNurseSign2,#btnPreScNurseSign3,#btnPreCirNurseSign3").linkbutton({
        onClick: function() {
            var dataIntegrity = operDataManager.isDataIntegrity(".operdata");
            if (dataIntegrity === false) {
                $.messager.alert("提示", "数据不完整，不能签名。", "warning");
                return;
            }
            var signCode = $(this).attr("data-signcode");
            var originalData = JSON.stringify(operDataManager.getOperDatas());
            var signView = new SignView({
                container: "#signContainer",
                originalData: originalData,
                signCode: signCode,
                printCallBack: printOperCountPDF
            });
            signView.initView();
            signView.open();
        }
    });

    $("#btnSpecimenSurgeonSign").linkbutton({
        onClick: function() {
            var specimenChecked = $("#SpecimenCHK2").checkbox("getValue");
            var freezes = $("#Freezes").checkbox("getValue");
            var pathology = $("#Pathology").checkbox("getValue");
            var unPathology = $("#UnPathology").checkbox("getValue");
            if (specimenChecked === false) {
                $.messager.alert("提示", "没有标本，不能签名。", "warning");
                return;
            } else {
                if (freezes === false && pathology === false && unPathology === false) {
                    $.messager.alert("提示", "未选择标本送检类型，不能签名。", "warning");
                    return;
                } else {
                    var originalData = freezes ? "送冰冻," : "";
                    originalData += pathology ? "送病理," : "";
                    originalData += unPathology ? "未送检" : "";
                    var signCode = $(this).attr("data-signcode");
                    var signView = new SignView({
                        container: "#signContainer",
                        originalData: originalData,
                        signCode: signCode
                    });
                    signView.initView();
                    signView.open();
                }
            }
        }
    });

    $("#btnConditionSurgeonSign").linkbutton({
        onClick: function() {
            var condition = $("#OperSpecicalCondition").val();
            if (condition === "") {
                $.messager.alert("提示", "没有手术中特殊问题/处理，不能签名。", "warning");
                return;
            } else {
                var signCode = $(this).attr("data-signcode");
                var signView = new SignView({
                    container: "#signContainer",
                    originalData: condition,
                    signCode: signCode
                });
                signView.initView();
                signView.open();
            }
        }
    });

    var columns = [
        [{
                field: "OperInfo",
                title: "手术名称",
                width: 240
            },
            {
                field: "SurgeonInfo",
                title: "手术医生",
                width: 200,
                formatter: function(value, row, index) {
                    if (row.SurgeonDesc === "") {
                        row.SurgeonDesc = row.Surgeon;
                    }
                    var ret = row.SurgeonDesc;
                    if (row.AssistantDesc && row.AssistantDesc !== "") {
                        ret += "," + row.AssistantDesc;
                    }
                    return ret;
                }
            },
            {
                field: "BodySiteDesc",
                title: "手术部位",
                width: 80
            },
            {
                field: "OperClassDesc",
                title: "手术分级",
                width: 80
            },

            {
                field: "BladeTypeDesc",
                title: "切口类型",
                width: 80
            }

        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#operationBox"),
        gridColumns: columns,
        gridTool: "#operationTool",
        form: $("#operationForm"),
        modelType: ANCLS.Model.OperList,
        queryType: ANCLS.BLL.OperationList,
        queryName: "FindOperationList",
        queryParams: {
            Arg1: session.OPSID,
            ArgCnt: 1
        },
        dialog: null,
        addButton: $("#btnAddOperation"),
        editButton: null,
        delButton: $("#btnDelOperation"),
        queryButton: $("#btnQuery"),
        saveButton: $("#btnEditOperation"),
        onSubmitCallBack: changeParam,
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack: selectOperation
    });
    dataForm.initDataForm();

    dataForm.datagrid.datagrid({
        headerCls: "panel-header-gray",
        onSelect: function(index, record) {
            $("#operationForm").form("clear");
            $("#operationForm").form("load", record);
            $("#RealOperation").combobox("setText", record.OperNote);
            selectOperation(record);
            //$("#BodySite").combobox("setText",record.BodySiteDesc);    
        },
        onLoadSuccess: function(data) {
            if (data && data.rows && data.rows.length > 0) {
                $(this).datagrid("selectRow", 0);
            }
        }
    });

    $("#OperClass").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperClass";
            param.ArgCnt = 0;
        },
        valueField: "RowId",
        textField: "Description"
    });

    $("#SurgeonDeptID").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = "DHCCL.BLL.Admission";
            param.QueryName = "FindLocation";
            param.Arg1 = "";
            param.Arg2 = "E^O";
            param.ArgCnt = 2;
        },
        valueField: "RowId",
        textField: "Description",
        filter: function(q, row) {
            q = q.toUpperCase();
            var opts = $(this).combobox('options');
            return (row[opts.valueField] === q) || (row[opts.textField].indexOf(q) > -1) || ((row['Alias'] || '').indexOf(q) > -1);
        }
    });

    $("#AnaestMethod").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindAnaestMethod";
            param.ArgCnt = 0;
        },
        valueField: "RowId",
        textField: "Description",
        onLoadSuccess: function(data) {
            $("#AnaestMethod").combobox('setText', patInfo.AnaestMethodInfo || patInfo.PrevAnaMethodDesc);
        }
    });

    $("#BladeType").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindBladeType";
            param.ArgCnt = 0;
        },
        valueField: "RowId",
        textField: "Description"
    });

    $("#RealOperation").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.Operation;
            param.QueryName = "FindOperation";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = "";
            param.Arg3 = "";
            param.ArgCnt = 3;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        onSelect: function(record) {
            $("#OperationDesc").val(record.ICDDesc);
            if (record.OperClass) {
                $("#OperClass").combobox("setValue", record.OperClass);
            }
            if (record.BladeType) {
                $("#BladeType").combobox("setValue", record.BladeType);
            }
            if (record.BodySite) {
                $("#BodySite").combobox("setValue", record.BodySite);
            }
        }
    });

    $("#BodySite").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindBodySite";
            param.ArgCnt = 0;
        },
        valueField: "RowId",
        textField: "Description"
    });

    $("#Surgeon,#Assistant1,#Assistant2,#Assistant3,#Assistant4,#Assistant5").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = param.q ? param.q : "";
            var surgeonDeptID="";//$("#SurgeonDeptID").combobox("getValue");
            param.Arg2 = surgeonDeptID || patInfo.AppDeptID;
            param.ArgCnt = 2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    });

    $("#btnOperation").linkbutton({
        onClick: function() {
            $("#operationDialog").dialog("open");
            $("#operationBox").datagrid("reload");
        }
    });

    $("#operationDialog").dialog({
        onClose: function() {
            operDataManager.reloadPatInfo(loadPatInfo);
        }
    });

    $("#btnExitOperation").linkbutton({
        onClick: function() {
            // var operRows=$("#operationBox").datagrid("getRows");
            // if(operRows && operRows.length>0){
            //     var operInfo="";
            //     for(var i=0;i<operRows.length;i++){
            //         if(operInfo!=="") operInfo+=",";
            //         var operRow=operRows[i];
            //         operInfo+=operRow.OperNote;
            //     }
            //     $("#RealOperationDesc").val(operInfo);
            //     $("#OperationDesc").text(operInfo);
            // }

            $("#operationDialog").dialog("close");
        }
    });

    $("#operationDialog").dialog({
        onClose: function() {
            var operRows = $("#operationBox").datagrid("getRows");
            if (operRows && operRows.length > 0) {
                var operInfo = "";
                for (var i = 0; i < operRows.length; i++) {
                    if (operInfo !== "") operInfo += "+";
                    var operRow = operRows[i];
                    operInfo += operRow.OperNote;
                }
                $("#RealOperationDesc").val(operInfo);
                $("#OperationDesc").text(operInfo);
            }
            operDataManager.reloadPatInfo(loadPatInfo);
        }
    });

    $("#TheatreInTime").focus(function() {
        try {
            dhcclcomm.OpenCom("COM1", "115200");
            scanCode = "TheatreInTime";
            // window.parent.CLCom.receiveData("test");
            // window.parent.CLCom.receiveData(window.addEquipRecord);
        } catch (ex) {
            console.log(ex.message);
        }
    });

    $("#TheatreInTime").keypress(function(e) {
        if ($("#TheatreInTime").val() !== "") return;
        var keyCode = e.which || e.keyCode;
        if (keyCode == 13) {
            $.messager.confirm("提示", "是否要确认入室时间,确认后入室时间将不能再修改?", function(r) {
                if (r) {
                    var serverNow = dhccl.runServerMethod("DHCCL.BLL.DateTime", "GetServerNow");
                    if (serverNow.result) {
                        $("#TheatreInTime").val(serverNow.result);
                        operDataManager.saveOperDatas();
                    }
                }
            });
        }
    });

    $("#TheatreOutTime").keypress(function(e) {
        if ($("#TheatreOutTime").val() !== "") return;
        var keyCode = e.which || e.keyCode;
        if (keyCode == 13) {
            $.messager.confirm("提示", "是否要确认离室时间,确认后离室时间将不能再修改?", function(r) {
                if (r) {
                    var serverNow = dhccl.runServerMethod("DHCCL.BLL.DateTime", "GetServerNow");
                    if (serverNow.result) {
                        $("#TheatreOutTime").val(serverNow.result);
                        operDataManager.saveOperDatas();
                    }
                }
            });
        }
    });

    $("#TheatreOutTime").focus(function() {

        try {
            dhcclcomm.OpenCom("COM1", "115200");
            scanCode = "TheatreOutTime";
            // window.parent.CLCom.receiveData("test");
            // window.parent.CLCom.receiveData(window.addEquipRecord);
        } catch (ex) {
            console.log(ex.message);
        }
    });


}

function selectOperation(rowData) {
    if (rowData.Assistant && rowData.Assistant !== "") {
        var assArr = rowData.Assistant.split(",");
        var assDescArr = rowData.AssistantDesc.split(",");
        for (var i = 0; i < assArr.length; i++) {
            $("#Assistant" + (i + 1)).combobox("setValue", assArr[i]);
            $("#Assistant" + (i + 1)).combobox("setText", assDescArr[i]);
        }
    }
}

function changeParam(param) {
    $("#OperScheduleId").val(session.OPSID);
    param.OperNote = $("#RealOperation").combobox("getText");
    param.Operation = $("#RealOperation").combobox("getValue");
    var surgeon = $("#Surgeon").combobox("getValue");
    var surgeonDesc = $("#Surgeon").combobox("getText");
    param.Surgeon = (surgeon && surgeon !== "") ? surgeon : surgeonDesc;
    var ass1 = ($("#Assistant1").combobox("getValue") !== "" ? $("#Assistant1").combobox("getValue") : $("#Assistant1").combobox("getText"));
    var ass2 = ($("#Assistant2").combobox("getValue") !== "" ? $("#Assistant2").combobox("getValue") : $("#Assistant2").combobox("getText"));
    var ass3 = ($("#Assistant3").combobox("getValue") !== "" ? $("#Assistant3").combobox("getValue") : $("#Assistant3").combobox("getText"));
    var ass4 = ($("#Assistant4").combobox("getValue") !== "" ? $("#Assistant4").combobox("getValue") : $("#Assistant4").combobox("getText"));
    var ass5 = ($("#Assistant5").combobox("getValue") !== "" ? $("#Assistant5").combobox("getValue") : $("#Assistant5").combobox("getText"));
    var assistant = "";
    if (ass1 !== "") {
        if (assistant !== "") assistant += ",";
        assistant += ass1;
    }
    if (ass2 !== "") {
        if (assistant !== "") assistant += ",";
        assistant += ass2;
    }
    if (ass3 !== "") {
        if (assistant !== "") assistant += ",";
        assistant += ass3;
    }
    if (ass4 !== "") {
        if (assistant !== "") assistant += ",";
        assistant += ass4;
    }
    if (ass5 !== "") {
        if (assistant !== "") assistant += ",";
        assistant += ass5;
    }
    param.Assistant = assistant;
}

function initSurgicalInventory() {
    //保存清点记录
    $("#btnSaveInventory").linkbutton({
        onClick: SaveInventory
    });

    $("#btnDelInventory").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected($("#dataBox"), true)) {
                var selectedRows = $("#dataBox").datagrid("getSelections");
                if (selectedRows && selectedRows.length) {
                    $.messager.confirm("确认", "您确认要删除选中纪录？", function(r) {
                        if (r) {
                            var dataList = [],
                                dataIndexList = [],
                                delList = [];
                            for (var i = 0; i < selectedRows.length; i++) {
                                var selectedRow = selectedRows[i];
                                if (selectedRow.RowId && selectedRow.RowId !== "") {
                                    dataList.push({
                                        ClassName: ANCLS.Model.SurInventory,
                                        RowId: selectedRow.RowId
                                    });
                                }

                                var selectedRowIndex = $("#dataBox").datagrid("getRowIndex", selectedRow);
                                dataIndexList.push(selectedRowIndex);
                                delList.push(selectedRow);
                            }
                            if (dataList.length > 0) {
                                var dataListStr = dhccl.formatObjects(dataList);
                                var ret = dhccl.runServerMethod(CLCLS.BLL.DataService, "DelDatas", dataListStr);
                                if (ret.success) {
                                    $("#dataForm").form("clear");
                                    // $("#dataBox").datagrid("reload");
                                } else {
                                    $.messager.alert("提示", "删除清点纪录失败，原因：" + ret.result, "error");
                                }
                            }
                            if (delList.length > 0) {
                                for (var i = 0; i < delList.length; i++) {
                                    var rowIndex = $("#dataBox").datagrid("getRowIndex", delList[i]);
                                    $("#dataBox").datagrid("deleteRow", rowIndex);
                                }
                            }

                            // $("#dataBox").datagrid("deleteRow", selectRowIndex);
                            // var msg = dhccl.removeData(ANCLS.Model.SurInventory, selectRow.RowId)
                            // dhccl.showMessage(msg, "删除", null, null, function () {
                            //     $("#dataForm").form("clear");
                            //     $("#dataBox").datagrid("reload");
                            // });
                        }
                    });

                }
                // var selectRow = $("#dataBox").datagrid("getSelected");
                // var selectRowIndex = $("#dataBox").datagrid("getRowIndex", selectRow);
                // if ((selectRow.RowId) && (selectRow.RowId != "")) {
                //     $.messager.confirm("确认", "您确认要删除" + selectRow.SurgicalMaterialsDesc + "?", function (r) {
                //         if (r) {
                //             $("#dataBox").datagrid("deleteRow", selectRowIndex);
                //             var msg = dhccl.removeData(ANCLS.Model.SurInventory, selectRow.RowId)
                //             dhccl.showMessage(msg, "删除", null, null, function () {
                //                 $("#dataForm").form("clear");
                //                 $("#dataBox").datagrid("reload");
                //             });
                //         }
                //     });
                // }else{
                //     var selectRow = $("#dataBox").datagrid("getSelected");
                //     var selectRowIndex = $("#dataBox").datagrid("getRowIndex", selectRow);
                //     $.messager.confirm("确认", "您确认要删除" + selectRow.SurgicalMaterialsDesc + "?", function (r) {
                //         if (r) {
                //             $("#dataBox").datagrid("deleteRow",selectRowIndex);
                //         }
                //     });

                // }
            }
        }
    });

    //同步消毒包
    $("#btnAddMaterials").linkbutton({
        onClick: function() {
            var surMaterialsId = $("#SurgicalMaterials").val();
        }
    });
    //手术包
    $("#SurgicalKits").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSurgicalKits";
            param.Arg1 = "N";
            param.Arg2 = "Y";
            param.ArgCnt = 2;
        },
        mode: "remote",
        onSelect: function(record) {
            $("#surInventoryDialog").dialog("open");
            $("#surInventoryBox").datagrid("reload");
            var surKitDesc = $("#SurgicalKits").combobox("getText");
            $("#surInventoryDialog").dialog("setTitle", "器械套餐-" + surKitDesc);
            return;
            $.messager.confirm("确认", "是否添加该手术包清点物品？", function(r) {
                if (r) {
                    var dataList = dhccl.getDatas(ANCSP.DataQuery, {
                        ClassName: ANCLS.BLL.CodeQueries,
                        QueryName: "FindSurKitMaterial",
                        Arg1: record.RowId,
                        ArgCnt: 1
                    }, "json");
                    if (dataList.length > 0) {
                        for (var i = 0; i < dataList.length; i++) {
                            $("#dataBox").datagrid("appendRow", {
                                SurgicalMaterials: dataList[i].SurgicalMaterials,
                                SurgicalMaterialsDesc: dataList[i].SurgicalMaterialsDesc,
                                MaterialNote: dataList[i].SurgicalMaterialsDesc,
                                PreopCount: (dataList[i].DefaultQty) ? dataList[i].DefaultQty : 1,
                                BarCode: ""
                            });
                        }
                    }
                }
            });
        }
    });
    //手术物品
    $("#SurgicalMaterials").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSurgicalMaterials";
            param.Arg1 = param.q ? param.q : "";
            param.ArgCnt = 1;
        },
        mode: "remote",
        onSelect: function(record) {

            addInventory(record);
        }
    });

    $("#btnAddInventory").linkbutton({
        onClick: function() {
            var matDesc = $("#SurgicalMaterials").combobox("getText");
            if (matDesc === "") {
                $.messager.alert("提示", "手术物品名称不能为空。", "warning");
                return;
            }
            var record = {
                RowId: "",
                Description: $("#SurgicalMaterials").combobox("getText")
            };
            addInventory(record);
            initInventoryDelBtns();
        }
    });

    //手术清点列表
    $("#dataBox").datagrid({
        fit: true,
        singleSelect: false,
        rownumbers: true,
        pagination: true,
        pageList: [10, 20, 30, 40, 50, 100, 200],
        pageSize: 200,
        url: ANCSP.DataQuery,
        toolbar: "#dataTools",
        columns: [
            [{
                    field: "CheckStatus",
                    title: "选择",
                    width: 60,
                    checkbox: true
                },
                {
                    field: "RowId",
                    title: "RowId",
                    width: 100,
                    hidden: true
                },
                {
                    field: "SurgicalMaterials",
                    title: "手术物品",
                    width: 100,
                    hidden: true
                },
                {
                    field: "SurgicalMaterialsDesc",
                    title: "手术物品",
                    width: 120,
                    hidden: true
                },
                {
                    field: "MaterialNote",
                    title: "手术物品",
                    width: 120
                },
                {
                    field: "PreopCount",
                    title: "术前清点",
                    width: 100,
                    editor: {
                        type: 'numberbox'
                    }
                },
                {
                    field: "OperAddCount",
                    title: "术中加数",
                    width: 100,
                    hidden: true
                },
                {
                    field: "AddCountDesc",
                    title: "术中加数",
                    width: 160,
                    editor: {
                        type: 'validatebox'
                    }
                },
                {
                    field: "PreCloseCount",
                    title: "关腔前清点",
                    width: 100,
                    editor: {
                        type: 'numberbox'
                    }
                },
                {
                    field: "PostCloseCount",
                    title: "关腔后清点",
                    width: 100,
                    editor: {
                        type: 'numberbox'
                    }
                },
                {
                    field: "PostSewCount",
                    title: "缝皮后清点",
                    width: 100,
                    editor: {
                        type: 'numberbox'
                    }
                },
                {
                    field: "BarCode",
                    title: "无菌包条号",
                    width: 100,
                    hidden: true
                }
                // {
                //     field: "Operators",
                //     title: "操作",
                //     width: 80,
                //     formatter: function (value, row, index) {
                //         var html = "<a href='#'  class='hisui-linkbutton inventoryrecord-btn' data-options='plain:true' iconcls='icon-remove' data-rowid='" + (row.RowId?row.RowId:"") + "' data-index='"+index+"'></a>";
                //         return html;
                //     }
                // }
            ]
        ],
        queryParams: {
            ClassName: ANCLS.BLL.DataQueries,
            QueryName: "FindSurInventory",
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        },
        onClickCell: function(index, field, value) {
            // if ((editIndex == undefined) && (field != "operators")) {
            //     if (field == "PreopCount" || field == "OperAddCount") {
            //         $('#dataBox').datagrid('beginEdit', index);
            //         var ed = $("#dataBox").datagrid('getEditors', index, field);
            //         $(ed.target).focus();
            //         editIndex = index;
            //     }
            // } else if ((editIndex != undefined) && (field != "operators")) {
            //     //$('#dataBox').datagrid('endEdit', editIndex);
            //     editIndex = undefined;
            // }
            if (index < 0) return;
            var countDatas = $("#dataBox").datagrid("getRows");
            var validField = "AddCountDesc",
                editValidFields = null;
            switch (field) {
                case "PreopCount":
                    editValidFields = ["PreCloseCount", "PostCloseCount", "PostSewCount"];
                    break;
                case "AddCountDesc":
                    editValidFields = ["PreCloseCount", "PostCloseCount", "PostSewCount"];
                    break;
                case "PreCloseCount":
                    editValidFields = ["PostCloseCount", "PostSewCount"];
                    break;
                case "PostCloseCount":
                    validField = "PreCloseCount";
                    editValidFields = ["PostSewCount"];
                    break;
                case "PostSewCount":
                    validField = "PostCloseCount"
                    break;
            }
            if (field === "PreCloseCount" || field === "PostCloseCount" || field === "PostSewCount") {
                var validation = checkColDataIntegrity(validField);
                if (validation.integrity === false) {
                    $.messager.alert("提示", validation.message, "warning");
                    $("#dataBox").datagrid("cancelEdit", index);
                    return;
                }
                for (var i = 0; i < countDatas.length; i++) {
                    var countData = countDatas[i];
                    var countNum = parseFloat(countData[field]);
                    if (!isNaN(countNum) && countNum >= 0) continue; // 如果该单元格已有清点数据，则不进行自动计算。
                    var preopNum = parseFloat(countData.PreopCount);
                    var addNum = parseFloat(countData.OperAddCount);
                    countData[field] = (!isNaN(preopNum) ? preopNum : 0) + (!isNaN(addNum) ? addNum : 0);
                    $("#dataBox").datagrid("updateRow", {
                        index: i,
                        row: countData
                    });
                }
            } else if (field === "AddCountDesc") {
                for (var i = 0; i < countDatas.length; i++) {
                    var countData = countDatas[i];
                    var countNum = countData[field];
                    if (countNum && countNum !== "") continue; // 如果该单元格已有清点数据，则不进行自动计算。
                    countData[field] = "0";
                    countData["OperAddCount"] = 0;
                    $("#dataBox").datagrid("updateRow", {
                        index: i,
                        row: countData
                    });
                }
            }
            if (editValidFields && editValidFields.length > 0) {
                var validation = checkEditValid(countDatas[index], field, editValidFields);
                if (validation.integrity === false) {
                    $.messager.alert("提示", validation.message, "warning");
                    $("#dataBox").datagrid("cancelEdit", index);
                    return;
                }
            }
        },
        onBeginEdit: function(rowIndex, rowData) {
            var editor = $(this).datagrid("getEditor", {
                index: rowIndex,
                field: "AddCountDesc"
            });
            if (editor && editor.target) {
                $(editor.target).change(function(e) {
                    var addCountStr = $(this).val();
                    var operAddCount = 0;
                    if (addCountStr) {
                        var addCountArr = addCountStr.split("+");
                        for (var index = 0; index < addCountArr.length; index++) {
                            var element = addCountArr[index];
                            if (!isNaN(element)) {
                                operAddCount += Number(element);
                            }
                        }
                        rowData.OperAddCount = operAddCount;
                    }
                });
                // $(editor.target).numberbox({
                //     onChange:function(newValue,oldValue){
                //         var operAddCount=Number(rowData.OperAddCount);
                //         if(isNaN(operAddCount)){
                //             operAddCount=0;
                //         }
                //         var addCount=Number(newValue);
                //         if(!isNaN(addCount)){
                //             operAddCount+=addCount;
                //             rowData.OperAddCount=operAddCount;

                //             $(this).numberbox("setValue","");
                //         }
                //     }
                // });
            }
        },
        onAfterEdit: function(rowIndex, rowData, changes) {},
        onLoadSuccess: function(data) {
            if (data && data.rows && data.rows.length > 0) {
                initInventoryDelBtns();
            }
        }
    });

    $("#dataBox").datagrid("enableCellEditing", function(index, field) {});

    $("#surInventoryBox").datagrid({
        fit: true,
        singleSelect: false,
        rownumbers: true,
        url: ANCSP.DataQuery,
        toolbar: "",
        columns: [
            [{
                    field: "CheckStatus",
                    title: "选择",
                    width: 60,
                    checkbox: true
                },
                {
                    field: "SurgicalMaterials",
                    title: "SurgicalMaterials",
                    width: 100,
                    hidden: true
                },
                {
                    field: "SurgicalMaterialsDesc",
                    title: "项目名称",
                    width: 120
                },
                {
                    field: "DefaultQty",
                    title: "数量",
                    width: 80
                }
            ]
        ],
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSurKitMaterial";
            var surKitId = $("#SurgicalKits").combobox("getValue");
            param.Arg1 = surKitId;
            param.ArgCnt = 1;
        }
    });

    $("#btnConfirmInventory").linkbutton({
        onClick: function() {
            var dataList = $("#surInventoryBox").datagrid("getSelections");
            if (dataList && dataList.length > 0) {
                for (var i = 0; i < dataList.length; i++) {
                    $("#dataBox").datagrid("appendRow", {
                        SurgicalMaterials: dataList[i].SurgicalMaterials,
                        SurgicalMaterialsDesc: dataList[i].SurgicalMaterialsDesc,
                        MaterialNote: dataList[i].SurgicalMaterialsDesc,
                        PreopCount: (dataList[i].DefaultQty) ? dataList[i].DefaultQty : 1,
                        BarCode: ""
                    });
                }
                $("#surInventoryDialog").dialog("close");
                $("#SurgicalKits").combobox("clear");
                initInventoryDelBtns();
            }
        }
    });

    $("#btnExitInventory").linkbutton({
        onClick: function() {
            //$("#chargeSetBox").datagrid("clear");
            $("#surInventoryDialog").dialog("close");
            $("#SurgicalKits").combobox("clear");

        }
    });

    $("#surInventoryDialog").dialog({
        onClose: function() {
            $("#SurgicalKits").combobox("clear");
        }
    });

    $("#btnConfirmInvtItem").linkbutton({
        onClick: function() {
            var record = {
                RowId: "",
                Description: $("#SIIMaterialNote").val(),
                PreopCount: $("#SIIPreopCount").numberbox("getValue"),
                AddCountDesc: $("#SIIOperAddCount").val(),
                PreCloseCount: $("#SIIPreCloseCount").numberbox("getValue"),
                PostCloseCount: $("#SIIPostCloseCount").numberbox("getValue"),
                PostSewCount: $("#SIIPostSewCount").numberbox("getValue"),
                BarCode: ""
            };
            addInventory(record);
            initInventoryDelBtns();
        }
    });

    $("#btnExitInvtItem").linkbutton({
        onClick: function() {
            //$("#chargeSetBox").datagrid("clear");
            $("#surInvtItemDialog").dialog("close");
            $("#SurgicalMaterials").combobox("clear");

        }
    });

}

function initInventoryDelBtns() {
    $(".inventoryrecord-btn").linkbutton({
        onClick: function() {
            var rowid = $(this).attr("data-rowid");
            $.messager.confirm("确认", "是否删除该清点记录？", function(result) {
                if (result) {
                    var dataIndex = $(this).attr("data-index");
                    if (rowid && rowid !== "") {
                        var msg = dhccl.removeData(ANCLS.Model.SurInventory, rowid);
                        // dhccl.showMessage(msg, "删除", null, null, function () {
                        //     // $("#dataBox").datagrid("reload");
                        // });
                    } else {


                    }
                    $("#dataBox").datagrid("deleteRow", dataIndex);

                }
            });
        }
    });
}

function addInventory(record) {
    // if (IsExist(record.RowId)) {
    //     $.messager.alert("提示", "该手术物品已存在！", "warning");
    //     return;
    // } else {
    //     $.messager.confirm("提示", "是否添加“" + record.Description + "”到清点列表？", function (r) {
    //         if (r) {
    //             $("#dataBox").datagrid("appendRow", {
    //                 SurgicalMaterials: record.RowId,
    //                 SurgicalMaterialsDesc: record.Description,
    //                 MaterialNote:record.Description,
    //                 PreopCount: (record.PreopCount?record.PreopCount:1),
    //                 AddCountDesc:(record.AddCountDesc?record.AddCountDesc:""),
    //                 PreCloseCount:(record.PreCloseCount?record.PreCloseCount:""),
    //                 PostCloseCount:(record.PostCloseCount?record.PostCloseCount:""),
    //                 PostSewCount:(record.PostSewCount?record.PostSewCount:""),
    //                 BarCode: ""
    //             });
    //             $("#SurgicalMaterials").combobox("clear");
    //         }
    //     });
    // }
    $.messager.confirm("提示", "是否添加“" + record.Description + "”到清点列表？", function(r) {
        if (r) {
            $("#dataBox").datagrid("appendRow", {
                SurgicalMaterials: record.RowId,
                SurgicalMaterialsDesc: record.Description,
                MaterialNote: record.Description,
                PreopCount: (record.PreopCount ? record.PreopCount : 1),
                AddCountDesc: (record.AddCountDesc ? record.AddCountDesc : ""),
                PreCloseCount: (record.PreCloseCount ? record.PreCloseCount : ""),
                PostCloseCount: (record.PostCloseCount ? record.PostCloseCount : ""),
                PostSewCount: (record.PostSewCount ? record.PostSewCount : ""),
                BarCode: ""
            });
            $("#SurgicalMaterials").combobox("clear");
        }
    });
}

function checkColDataIntegrity(colField) {
    var integrity = false;
    var message = "";
    var countDatas = $("#dataBox").datagrid("getRows");
    var colOpts = $("#dataBox").datagrid("getColumnOption", colField);
    if (!colOpts) {
        return integrity;
    }
    integrity = true;
    for (var i = 0; i < countDatas.length; i++) {
        var countData = countDatas[i];
        var countNum = parseFloat(countData[colField]);
        if (isNaN(countNum)) {
            integrity = false;
            message = colOpts.title + "的数据不完整！";
        }
    }
    return { integrity: integrity, message: message };
}

function checkEditValid(countData, colField, editValidFields) {
    var integrity = false;
    var message = "";
    var colOpts = $("#dataBox").datagrid("getColumnOption", colField);
    if (!colOpts) {
        return integrity;
    }
    integrity = true;
    for (var i = 0; i < editValidFields.length; i++) {
        var validField = editValidFields[i];
        var fieldOpts = $("#dataBox").datagrid("getColumnOption", validField);
        if (!fieldOpts) continue;
        var countNum = parseFloat(countData[validField]);
        if (!isNaN(countNum)) {
            integrity = false;
            message = fieldOpts.title + "已存在数据。";
            break;
        }
    }
    return { integrity: integrity, message: message };
}

function initEquipRecord() {
    //仪器设备
    $("#InstrumentDevice").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindBladeType";
            param.ArgCnt = 0;
        },
        mode: "remote",
        onSelect: function(record) {
            selectInstrumentDevice = record;
        }
    });


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

    $("#ScanEquipCode").focus(function() {
        try {
            dhcclcomm.OpenCom("COM1", "115200");
            scanCode = "Equip";
            // window.parent.CLCom.receiveData("test");
            // window.parent.CLCom.receiveData(window.addEquipRecord);
        } catch (ex) {
            console.log(ex.message);
        }

    });
    // $("#ScanEquipCode").bind("input onpropertychange",function(e){
    //     alert("test");
    // });
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

function initCharge() {
    var columns = [
        [{
                field: "CheckStatus",
                title: "选择",
                width: 60,
                checkbox: true
            },
            {
                field: "ChargeItemDesc",
                title: "名称",
                width: 240
            },
            {
                field: "Spec",
                title: "规格",
                width: 120
            },
            {
                field: "Qty",
                title: "数量",
                width: 60
            },
            {
                field: "Price",
                title: "单价",
                width: 80
            },
            {
                field: "UnitDesc",
                title: "单位",
                width: 80
            },
            {
                field: "BarCode",
                title: "条码",
                width: 180
            },
            {
                field: "Operators",
                title: "操作",
                width: 80,
                formatter: function(value, row, index) {
                    var html = "<a href='#' id='ChargeRecord" + row.RowId + "' class='hisui-linkbutton chargerecord-btn' data-options='plain:true' iconcls='icon-remove' data-rowid='" + row.RowId + "'></a>";
                    return html;
                }
            }
        ]
    ];

    var dataForm = new DataForm({
        datagrid: $("#chargeBox"),
        gridColumns: columns,
        gridTitle: "",
        gridTool: "#chargeTools",
        form: $("#chargeForm"),
        modelType: ANCLS.Model.ChargeRecordDetail,
        queryType: ANCLS.BLL.ChargeRecord,
        queryName: "FindChargeRecordDetails",
        queryParams: {
            Arg1: session.DeptID,
            Arg2: session.OPSID,
            ArgCnt: 2
        },
        dialog: null,
        addButton: $("#btnAddCharge"),
        editButton: $("#btnEditCharge"),
        delButton: $("#btnDelCharge"),
        queryButton: null,
        submitCallBack: null,
        onSubmitCallBack: setChargeParam,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack: setChargeRecord,
        submitAction: saveChargeRecord,
        singleSelect: false,
        delAction: delChargeRecord
    });
    dataForm.initDataForm();
    dataForm.datagrid.datagrid({
        // onBeforeLoad: function (param) {
        //     param.Arg1 = session.DeptID;
        //     param.Arg2=session.OPSID;
        //     param.ArgCnt = 2;
        // },
        onLoadSuccess: function(data) {
            if (data && data.rows && data.rows.length > 0) {
                var materialDescArr = [];
                var materials = [];
                var materialsArr = [];
                for (var i = 0; i < data.rows.length; i++) {
                    var materialData = data.rows[i];
                    if (materialData.ChargeCategoryDesc !== "高值耗材" && materialData.ChargeItem !== "") {
                        continue;
                    }
                    var desc = materialData.ChargeItemDesc + materialData.Price; //+(materialData.Spec?"("+materialData.Spec+")":"");
                    var index = materialDescArr.indexOf(desc);
                    if (index > -1) {
                        materials[index].Qty = Number(materials[index].Qty) + Number(materialData.Qty);
                    } else {
                        materialDescArr.push(desc);
                        materials.push({
                            Desc: materialData.ChargeItemDesc,
                            Qty: materialData.Qty,
                            Unit: materialData.UnitDesc
                        });
                    }
                    //materialsArr.push(materialData.ChargeItemDesc+" "+materialData.Qty+materialData.UnitDesc);
                }

                for (var index in materials) {
                    materialsArr.push(materials[index].Desc + " " + materials[index].Qty + materials[index].Unit);
                }

                $("#SpecialItemsDesc").val(materialsArr.join(splitchar.comma));
            }

            if (data && data.rows && data.rows.length > 0) {
                $(".chargerecord-btn").linkbutton({
                    onClick: function() {
                        var rowid = $(this).attr("data-rowid");
                        $.messager.confirm("确认", "是否删除该收费记录？", function(result) {
                            if (result) {
                                var dataList = [];
                                dataList.push({
                                    ClassName: ANCLS.Model.ChargeRecordDetail,
                                    RowId: rowid
                                });
                                var dataListStr = dhccl.formatObjects(dataList);
                                var ret = dhccl.runServerMethod(ANCLS.BLL.ChargeRecord, "RemoveChargeRecordDetails", dataListStr);
                                if (ret.success) {
                                    $("#chargeForm").form("clear");
                                    $("#chargeBox").datagrid("reload");
                                } else {
                                    $.messager.alert("提示", "删除清点纪录失败，原因：" + ret.result, "error");
                                }
                                // var msg = dhccl.removeData(ANCLS.Model.ChargeRecordDetail, rowid);
                                // dhccl.showMessage(msg, "删除", null, null, function () {
                                //     $("#chargeBox").datagrid("reload");
                                // });
                            }
                        });
                    }
                });
            }
        }
    });

    $("#ChargeItem").combogrid({
        panelWidth: 400,
        idField: 'RowId',
        textField: 'Description',
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindChargeItemByCondition";
            param.Arg1 = session.DeptID;
            param.Arg2 = param.q ? param.q : "";
            param.ArgCnt = 2;
        },
        columns: [
            [
                { field: 'Description', title: '项目名称', width: 200 },
                { field: 'Price', title: '单价', width: 80 },
                { field: 'UnitDesc', title: '单位', width: 60 }
                // {field:'Spec',title:'规格',width:80},
                // {field:'Manufacturer',title:'制造商',width:60},
                // {field:'Vendor',title:'供应商',width:60}
            ]
        ],
        mode: "remote",
        onSelect: function(rowIndex, rowData) {
            $("#ChargeUom").combobox("setValue", rowData.Unit);
            $("#ChargeQty").numberbox("setValue", 1);
            chargeParam = rowData;
        }
    });

    // $("#StockItem").next("span").find("input").focus(function(){
    //     try{
    //         window.parent.CLCom.receiveData(AddMatRecord);
    //     }catch(ex){
    //         console.log(ex.message);
    //     }
    // });

    $("#ChargeUom").combobox({
        valueField: "RowId",
        textField: "LocalDesc",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.StockManager;
            param.QueryName = "FindUom";
            param.ArgCnt = 0;
        }
    });

    $("#ChargeSet").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ChargeRecord;
            param.QueryName = "FindChargeSets";
            param.Arg1 = session.DeptID;
            param.ArgCnt = 1;
        },
        onSelect: function(record) {
            $("#chargeSetDialog").dialog("open");
            $("#chargeSetBox").datagrid("reload");
            var chargeSetDesc = $("#ChargeSet").combobox("getText");
            $("#chargeSetDialog").dialog("setTitle", "收费套餐-" + chargeSetDesc);
            return;
            $.messager.confirm("确认", "是否添加该收费套餐的收费项目？", function(r) {
                if (r) {
                    var dataList = dhccl.getDatas(ANCSP.DataQuery, {
                        ClassName: ANCLS.BLL.ChargeRecord,
                        QueryName: "FindChargeSetItems",
                        Arg1: record.RowId,
                        ArgCnt: 1
                    }, "json");
                    if (dataList.length > 0) {
                        var chargeList = [];
                        for (var i = 0; i < dataList.length; i++) {
                            var chargeData = dataList[i];
                            chargeList.push({
                                RowId: "",
                                ChargeItem: chargeData.ChargeItem,
                                BillDept: session.DeptID,
                                ExecDept: session.DeptID,
                                UserDept: session.DeptID,
                                Unit: chargeData.Uom,
                                Qty: (chargeData.DefaultQty) ? chargeData.DefaultQty : 1,
                                OperSchedule: session.OPSID,
                                UpdateUser: session.UserID,
                                ChargeClassName: ANCLS.Model.ChargeRecordDetail,
                                ChargeItemDesc: chargeData.SetItemDesc,
                                Price: chargeData.Price,
                                Type: "N"
                            });
                        }
                        dhccl.saveDatas(ANCSP.DataListService, {
                            jsonData: dhccl.formatObjects(chargeList),
                            ClassName: ANCLS.BLL.ChargeRecord,
                            MethodName: "SaveChargeRecordDetails"
                        }, function(data) {
                            var result = dhccl.resultToJson(data);
                            if (result.success) {
                                $("#chargeBox").datagrid("reload");
                            } else {
                                $.messager.alert("提示", "添加套餐项目失败，原因：" + result.result, "error");
                            }
                        });
                        // for (var i = 0; i < dataList.length; i++) {
                        //     $("#surSupplyBox").datagrid("appendRow", {
                        //         StockItemDr:dataList[i].StockItem,
                        //         StockTransferDr:"",
                        //         LocationDr:session.DeptID,
                        //         StockItemDesc: dataList[i].StockItemDesc,
                        //         StockItemSpec: dataList[i].StockItemSpec,
                        //         Qty:(dataList[i].DefaultQty) ? dataList[i].DefaultQty : 1,
                        //         UomDr:dataList[i].Uom,
                        //         UomDesc: dataList[i].UomDesc,
                        //         StockCatDesc: dataList[i].StockCatDesc
                        //     });
                        // }
                    }
                }
            });
        }
    });

    $("#ScanMatBarCode").keypress(function(e) {
        if (e.keyCode == 13) {
            // dhccl.saveDatas(ANCSP.MethodService, {
            //     ClassName: ANCLS.BLL.ANMobileScanInfo,
            //     MethodName: "AddStockConsume",
            //     Arg1: $(this).val(),
            //     Arg2: session.OPSID,
            //     Arg3: session.ModuleCode,
            //     Arg4: session.UserID,
            //     Arg5: session.DeptID,
            //     ArgCnt: 5
            // }, function (data) {
            //     if(data.indexOf("^S")==0){
            //         $("#surSupplyBox").datagrid("reload");
            //     }else{
            //         $.messager.alert("提示","扫码失败，原因："+data,"error");
            //     }

            // });
            addMatRecord($(this).val());
        }
    });

    $("#ScanMatBarCode").focus(function() {
        try {
            dhcclcomm.OpenCom("COM1", "115200");
            scanCode = "Material";
        } catch (ex) {
            console.log(ex.message);
        }

    });

    $("#chargeSetBox").datagrid({
        fit: true,
        singleSelect: false,
        rownumbers: true,
        url: ANCSP.DataQuery,
        toolbar: "",
        columns: [
            [{
                    field: "CheckStatus",
                    title: "选择",
                    width: 60,
                    checkbox: true
                },
                {
                    field: "RowId",
                    title: "RowId",
                    width: 100,
                    hidden: true
                },
                {
                    field: "ChargeItemDesc",
                    title: "项目名称",
                    width: 120
                },
                {
                    field: "DefQty",
                    title: "数量",
                    width: 80,
                    editor: {
                        type: 'numberbox'
                    }
                },
                {
                    field: "UomDesc",
                    title: "单位",
                    width: 100
                }
            ]
        ],
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ChargeRecord;
            param.QueryName = "FindChargeSetItems";
            var chargeSetId = $("#ChargeSet").combobox("getValue");
            param.Arg1 = chargeSetId;
            param.ArgCnt = 1;
        }
    });

    $("#btnConfirmChargeSet").linkbutton({
        onClick: function() {
            var selectedSetItems = $("#chargeSetBox").datagrid("getSelections");
            var chargeList = [];
            if (selectedSetItems && selectedSetItems.length > 0) {
                for (var i = 0; i < selectedSetItems.length; i++) {
                    var chargeSetItem = selectedSetItems[i];
                    chargeList.push({
                        RowId: "",
                        ChargeItem: chargeSetItem.ChargeItem,
                        BillDept: session.DeptID,
                        ExecDept: session.DeptID,
                        UserDept: session.DeptID,
                        Unit: chargeSetItem.Uom,
                        Qty: (chargeSetItem.DefQty) ? chargeSetItem.DefQty : 1,
                        OperSchedule: session.OPSID,
                        UpdateUser: session.UserID,
                        ChargeClassName: ANCLS.Model.ChargeRecordDetail,
                        ChargeItemDesc: chargeSetItem.ChargeItemDesc,
                        Price: chargeSetItem.Price,
                        Status: "N"
                    });
                }
                dhccl.saveDatas(ANCSP.DataListService, {
                    jsonData: dhccl.formatObjects(chargeList),
                    ClassName: ANCLS.BLL.ChargeRecord,
                    MethodName: "SaveChargeRecordDetails"
                }, function(data) {
                    var result = dhccl.resultToJson(data);
                    if (result.success) {
                        $("#chargeBox").datagrid("reload");
                        $("#chargeSetDialog").dialog("close");
                        $("#ChargeSet").combobox("clear");
                    } else {
                        $.messager.alert("提示", "添加套餐项目失败，原因：" + result.result, "error");
                    }
                });
            }
        }
    });

    $("#btnExitChargeSet").linkbutton({
        onClick: function() {
            //$("#chargeSetBox").datagrid("clear");
            $("#chargeSetDialog").dialog("close");
            $("#ChargeSet").combobox("clear");

        }
    });

    $("#btnPrintChargeRecord").linkbutton({
        onClick: function() {
            printChargeRecord();
        }
    });

    $("#chargeSetBox").datagrid("enableCellEditing");

    //initChargeRecord();
}

function delChargeRecord() {
    var selectedRows = $("#chargeBox").datagrid("getSelections");
    if (selectedRows && selectedRows.length) {
        var dataList = [];
        for (var i = 0; i < selectedRows.length; i++) {
            var selectedRow = selectedRows[i];
            dataList.push({
                ClassName: ANCLS.Model.ChargeRecordDetail,
                RowId: selectedRow.RowId
            });
            if (selectedRow.StockConsume && selectedRow.StockConsume !== "") {
                dataList.push({
                    ClassName: CLCLS.Model.StockConsume,
                    RowId: selectedRow.StockConsume
                });
            }
        }
        if (dataList.length > 0) {
            var dataListStr = dhccl.formatObjects(dataList);
            var ret = dhccl.runServerMethod(CLCLS.BLL.DataService, "DelDatas", dataListStr);
            if (ret.success) {
                $("#chargeForm").form("clear");
                $("#chargeBox").datagrid("reload");
            } else {
                $.messager.alert("提示", "删除清点纪录失败，原因：" + ret.result, "error");
            }
        }

    }
}

function saveChargeRecord(param) {
    var ret = dhccl.saveDatas(ANCSP.DataListService, {
        ClassName: ANCLS.BLL.ChargeRecord,
        MethodName: "SaveChargeRecordDetails",
        jsonData: dhccl.formatObjects(param)
    }, function(data) {
        if (data.indexOf("S^") === 0) {
            $("#chargeBox").datagrid("reload");
            $("#chargeForm").form("clear");
        } else {
            $.messager.alert("提示", "收费项目保存失败，原因：" + data, "error");
        }
    })
}

function initChargeRecord() {
    var ret = dhccl.runServerMethod(ANCLS.BLL.ChargeRecord, "GetChargeRecord", session.OPSID, session.UserID);
    if (ret && ret.result) {
        $("#ChargeRecord").val(ret.result);
    }
}

function initSurgicalSupply() {
    var columns = [
        [

            {
                field: "StockItemDesc",
                title: "耗材名称",
                width: 240
            },
            {
                field: "StockItemSpec",
                title: "规格",
                width: 80
            },
            {
                field: "Qty",
                title: "数量",
                width: 60
            },
            {
                field: "UomDesc",
                title: "单位",
                width: 80
            },
            {
                field: "BatchNo",
                title: "批号",
                width: 120
            },
            {
                field: "Manufacturer",
                title: "制造商",
                width: 160
            },
            {
                field: "Vendor",
                title: "供应商",
                width: 160
            },
            {
                field: "StockCatDesc",
                title: "耗材类型",
                width: 100
            }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#surSupplyBox"),
        gridColumns: columns,
        gridTitle: "",
        gridTool: "#surSupplyTools",
        form: $("#surSupplyForm"),
        modelType: CLCLS.Model.StockConsume,
        queryType: CLCLS.BLL.StockManager,
        queryName: "FindStockConsume",
        queryParams: {
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        },
        dialog: null,
        addButton: $("#btnAddStockConsume"),
        editButton: $("#btnEditStockConsume"),
        delButton: $("#btnDelStockConsume"),
        queryButton: null,
        submitCallBack: null,
        onSubmitCallBack: setSurSupplyParam,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack: setStockConsume
    });
    dataForm.initDataForm();

    $("#StockItem").combogrid({
        panelWidth: 540,
        idField: 'RowId',
        textField: 'GeneralDesc',
        required: true,
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.StockManager;
            param.QueryName = "FindStockItemNew";
            param.Arg1 = param.q ? param.q : "";
            param.ArgCnt = 1;
        },
        columns: [
            [
                { field: 'GeneralDesc', title: '通用名', width: 160 },
                { field: 'Description', title: '耗材名称', width: 240 },
                { field: 'Spec', title: '规格', width: 80 },
                { field: 'UomDesc', title: '单位', width: 60 },
                { field: 'Manufacturer', title: '制造商', width: 60 },
                { field: 'Vendor', title: '供应商', width: 60 }
            ]
        ],
        mode: "remote",
        onSelect: function(rowIndex, rowData) {
            $("#StockUom").combobox("setValue", rowData.UomDr);
            $("#StockQty").numberbox("setValue", 1);
        }
    });

    $("#StockUom").combobox({
        valueField: "RowId",
        textField: "LocalDesc",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.StockManager;
            param.QueryName = "FindUom";
            param.ArgCnt = 0;
        }
    });
}

function addMatRecord(matBarCode) {
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.ChargeRecord,
        MethodName: "AddHVMConsume",
        Arg1: matBarCode,
        Arg2: session.RecordSheetID,
        Arg3: session.DeptID,
        Arg4: session.UserID,
        ArgCnt: 4
    }, function(data) {
        if (data.indexOf("S^") == 0) {
            $("#chargeBox").datagrid("reload");
            //$("#surSupplyBox").datagrid("reload");
            $("#ScanMatBarCode").val("");
        } else {
            $.messager.alert("提示", "扫码失败，原因：" + data, "error");
        }

    });
}

function setStockConsume(record) {
    $("#StockItem").combogrid("setText", record.StockItemDesc);
}

function setChargeRecord(record) {
    $("#ChargeItem").combogrid("setText", record.ChargeItemDesc);
}

function initSterilityPack() {
    var cardImage = getSterilityPackImage();
    if (cardImage && cardImage.success && cardImage.result) {
        var imgArr = cardImage.result.split("&&&");
        var imgWidth = 300,
            imgHeight = 300;
        for (var i = 0; i < imgArr.length; i++) {
            var imgStr = imgArr[i];
            if (imgStr === splitchar.empty) continue;
            imgSrc = "<img class='sterilitypack-img' style='margin:10px;' src='data:image/png;base64," + imgStr + "' width='" + imgWidth + "' height='" + imgHeight + "'>";
            $("#sterilityPack").append(imgSrc);
        }
    }
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
                field: "BloodType",
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

function saveSignedData(signData) {
    signData.RecordSheet = session.RecordSheetID;
    var selectedRow = $("#bloodTransBox").datagrid("getSelected");
    var transRecord = {
        RowId: selectedRow.RowId,
        ClassName: ANCLS.Model.BloodTransRecord
    };
    if (signData.SignCode === "ExecSign") {
        transRecord.ExecProvCertID = signData.UserCertID;
        transRecord.ExecTimeStamp = signData.SignTimeStamp;
        transRecord.ExecSignData = signData.SignData ? signData.SignData : "";
        transRecord.ExecProv = signData.SignUser;
    } else if (signData.SignCode === "CheckSign") {
        transRecord.CheckProvCertID = signData.UserCertID;
        transRecord.CheckTimeStamp = signData.SignTimeStamp;
        transRecord.CheckSignData = signData.SignData ? signData.SignData : "";
        transRecord.CheckProv = signData.SignUser;
    }
    var transRecords = [];
    transRecords.push(transRecord);
    transRecords.push(signData);
    dhccl.saveDatas(ANCSP.DataListService, {
        jsonData: dhccl.formatObjects(transRecords)
    }, function(data) {
        if (data.indexOf("S^") === 0) {
            reloadBloodTrans();
        } else {
            $.messager.alert("提示", "签名失败，原因：" + data, "error");
        }
    });
}

function addBloodTransfusion(barCode) {
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

function setSurSupplyParam(param) {
    param.LocationDr = session.DeptID;
    param.UpdateUser = session.UserID;
    param.RecordSheet = session.RecordSheetID;
    param.StockItemDesc = $("#StockItem").combogrid("getText");
}

var chargeParam = null;

function setChargeParam(param) {
    var selectedRow = $("#chargeBox").datagrid("getSelected");
    param.BillDept = session.DeptID;
    param.UserDept = session.DeptID;
    param.ExecDept = session.DeptID;
    param.ChargeItem = $("#ChargeItem").combogrid("getValue");
    param.ChargeItemDesc = $("#ChargeItem").combogrid("getText");
    param.OperSchedule = session.OPSID;
    param.UpdateUser = session.UserID;
    if (!selectedRow) {
        param.StockItemDr = chargeParam.StockItemID ? chargeParam.StockItemID : "";
        param.UomDr = chargeParam.Unit;
        param.Price = chargeParam.Price;
        param.StockItemDesc = chargeParam.StockItemDesc;
        param.Unit = $("#ChargeUom").combobox("getValue");
    } else {
        param.RowId = selectedRow.RowId;
        param.StockItemDr = selectedRow.StockItemDr;
        param.UomDr = selectedRow.UomDr;
        param.Price = selectedRow.Price;
        param.StockItemDesc = selectedRow.StockItemDesc;
        param.Unit = $("#ChargeUom").combobox("getValue");
    }
    // param.StockItemDr=chargeParam.StockItemID?chargeParam.StockItemID:"";
    param.LocationDr = session.DeptID;
    // param.UomDr=chargeParam.Unit;
    param.RecordSheet = session.RecordSheetID;
    param.StockConsume = "";
    // param.Price=chargeParam.Price;
    param.Type = "N";
    // param.StockItemDesc=chargeParam.StockItemDesc;
    // param.Unit=chargeParam.Unit;
    param.Qty = $("#ChargeQty").numberbox("getValue");
}

function SaveInventory() {
    endEditDataBox($("#dataBox"));
    var dataModuleList = $("#dataBox").datagrid("getRows");
    var surgicalInventoryList = [],
        surInventoryDetailList = [],
        inventoryList = [];
    var currentDate = new Date();
    var today = currentDate.getFullYear() + "-" + (currentDate.getMonth() + 1) + "-" + currentDate.getDate();
    var currentTime = currentDate.toLocaleTimeString();
    if (session.RecordSheetID) {
        for (var i = 0; i < dataModuleList.length; i++) {
            var countData = dataModuleList[i];
            var preopNum = parseFloat(countData.PreopCount);
            var preCloseNum = parseFloat(countData.PreCloseCount);
            var postCloseNum = parseFloat(countData.PostCloseCount);
            var postSewNum = parseFloat(countData.PostSewCount);
            var addNum = parseFloat(countData.OperAddCount);
            var surInventory = {};
            surInventory.RowId = countData.RowId;
            surInventory.RecordSheet = session.RecordSheetID;
            surInventory.SurgicalMaterials = countData.SurgicalMaterials;
            surInventory.MaterialNote = countData.MaterialNote;
            surInventory.AddCountDesc = countData.AddCountDesc ? countData.AddCountDesc : "";
            if (!isNaN(preopNum)) {
                surInventory.PreopCount = preopNum;
            }
            if (!isNaN(preCloseNum)) {
                surInventory.PreCloseCount = preCloseNum;
            }
            if (!isNaN(postCloseNum)) {
                surInventory.PostCloseCount = postCloseNum;
            }
            if (!isNaN(postSewNum)) {
                surInventory.PostSewCount = postSewNum;
            }
            if (!isNaN(addNum)) {
                surInventory.OperAddCount = addNum;
            }
            surInventory.BarCode = countData.BarCode ? countData.BarCode : "";
            surInventory.ClassName = ANCLS.Model.SurInventory;
            surInventoryDetailList.push(surInventory);
        }

        var jsonData = dhccl.formatObjects(surInventoryDetailList);
        var data = dhccl.saveDatas(ANCSP.DataListService, {
            jsonData: jsonData
        }, function(result) {
            dhccl.showMessage(result, "保存", null, null, function() {
                $("#dataBox").datagrid("reload");
            });
        });


    }
}

function endEditDataBox(dataBox) {
    var dataRows = dataBox.datagrid("getRows");
    if (dataRows && dataRows.length > 0) {
        for (var i = 0; i < dataRows.length; i++) {
            var rowIndex = dataBox.datagrid("getRowIndex", dataRows[i]);
            dataBox.datagrid("endEdit", rowIndex);
        }
    }
}

//判断是否已添加该手术物品
function IsExist(RowId) {
    var dataBoxList = $("#dataBox").datagrid("getData");
    for (var i = 0; i < dataBoxList.total; i++) {
        var surMeterials = dataBoxList.rows[i].SurgicalMaterials;
        var materialNote = dataBoxList.rows[i].MaterialNote;
        if (surMeterials === RowId || materialNote === RowId) {
            return true;
        }
    }
    return false;
}

// 获取病人信息
var patInfo;

function loadPatInfo(result) {
    if (result) {
        $("#PatName").text(result.PatName);
        $("#PatGender").text(result.PatGender);
        $("#PatAge").text(result.PatAge);
        $("#PatDept").text(result.PatDeptDesc);
        $("#PatWardBed").text(result.PatBedCode);
        $("#PatMedCareNo").text(result.MedcareNo);
        $("#OperDate").text(result.OperDate);
        $("#AreaInTime").text(result.AreaInDT);
        $("#OperRoom").text(result.RoomDesc);
        $("#OperationDesc").text(result.OperInfo);
        var surgenDesc = result.SurgeonDesc;
        if (result.AssistantDesc && result.AssistantDesc != "") {
            surgenDesc += "," + result.AssistantDesc;
        }
        $("#SurgeonDesc").text(surgenDesc);
        $("#SurgeonInfo").val(surgenDesc);
        var anaDoctor = result.AnesthesiologistDesc;
        if (!anaDoctor || anaDoctor === "") {
            anaDoctor = $("#AnaestDoctor").val();
        }
        $("#AnesthetistDesc").text(anaDoctor);
        $("#ABO").text(result.ABO);
        $("#RH").text(result.RH);
        $("#RealOperationDesc").val(result.OperationDesc);
        patInfo = result;

        //if(result.AreaInDT && $("#TheatreInTime").val()==='') $("#TheatreInTime").val(result.AreaInDT);
        //if(result.AreaInDT && $("#TheatreOutTime").val()==='') $("#TheatreOutTime").val(result.TheatreOutDT);

        $("#AnaestMethod").combobox('setText', result.AnaestMethodInfo || result.PrevAnaMethodDesc);
        if (patInfo.TheatreInDT != "") {
            $("#AnaestMethod").combobox('disable');
        }
    }
}

function getSterilityPackImage() {
    var ret = dhccl.runServerMethod(ANCLS.BLL.SterilityPack, "GetSterilityPackImage", session.RecordSheetID);
    return ret;
}

function getMatCertImages() {
    var ret = dhccl.runServerMethod(CLCLS.BLL.StockManager, "GetMatCertImage", session.RecordSheetID);
    return ret;
}

function printOperCount() {
    operDataManager.reloadPatInfo(loadPatInfo);
    lodop = getLodop();
    lodop.PRINT_INIT("OperCount" + session.OPSID);
    lodop.SET_PRINT_MODE("PRINT_DUPLEX", 2);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    if (lodop.SET_PRINTER_INDEXA(PrintSetting.PrintPaper.Printer)) {
        createPrintOnePage(lodop);
        lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
        lodop.PREVIEW();

    } else {
        createPrintOnePage(lodop);
        lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
        lodop.PREVIEW();
    }

    // createPrintOnePage(lodop);
    // lodop.PREVIEW();
}

function printOperCountBack() {
    operDataManager.reloadPatInfo(loadPatInfo);
    lodop = getLodop();
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, PrintSetting.Common.Paper);
    if (lodop.SET_PRINTER_INDEXA(PrintSetting.PrintPaper.Printer)) {
        createBackPage(lodop);
        lodop.PREVIEW();
    } else {
        createBackPage(lodop);
        lodop.PREVIEW();
    }

}

var jobID = "",
    waitTime = 0,
    timeOut, lodop;

function printOperCountPDF() {
    // operDataManager.reloadPatInfo(loadPatInfo);
    // lodop = getLodop();
    // lodop.SET_PRINT_PAGESIZE(1,0,0,PrintSetting.AuditSign.Paper);
    // createPrintOnePage(lodop);
    // if(lodop.SET_PRINTER_INDEXA(PrintSetting.AuditSign.Printer)){
    //     lodop.SET_PRINT_MODE("CATCH_PRINT_STATUS",true);
    //     var jobID=lodop.PRINT();
    //     WaitFor();
    //     if(lodop.GET_VALUE("PRINT_STATUS_EXIST",jobID)){
    //         var operDate=new Date($("#OperDate").text());
    //         var ftpPath=operDate.format("yyyy")+"\\"+operDate.format("MM")+"\\"+operDate.format("dd")+"\\"+session.OPSID;
    //         var uploadRet=dhcclcomm.UploadFiles("111.111.116.29",ftpPath,"D:\\DHCClinic","OperCount"+session.OPSID,"Y");
    //         if(uploadRet==="S^"){
    //             console.log("success");
    //         }
    //     }

    // }
}

function WaitFor() {
    waitTime = waitTime + 1;
    //document.getElementById('T12B').value="正等待(JOB代码是"+jobID+")打印结果："+c+"秒";
    timeOut = setTimeout("WaitFor()", 1000);
    if (lodop.GET_VALUE("PRINT_STATUS_OK", jobID)) {
        clearTimeout(timeOut);
        //document.getElementById('T12B').value="打印成功！";
        waitTime = 0;
        //alert("打印成功！");
    }
    if ((!lodop.GET_VALUE("PRINT_STATUS_EXIST", jobID)) && (waitTime > 0)) {
        clearTimeout(timeOut);
        //document.getElementById('T12B').value="打印任务被删除！";
        waitTime = 0;
        //alert("打印任务被删除！");
    } else if (waitTime > 30) {
        clearTimeout(timeOut);
        //document.getElementById('T12B').value="打印超时(30秒)！";
        waitTime = 0;
        //alert("打印超过30秒没捕获到成功状态！");		
    };
};

function createBackPage(lodop) {

    var contentLineHeight = 30,
        titleLineHeight = 40,
        contentLineMargin = 15;
    var startPos = {
        x: 10,
        y: 10
    };
    var linePos = {
        x: startPos.x,
        y: startPos.y + contentLineMargin
    };

    lodop.ADD_PRINT_TEXT(10, 300, "100%", 60, "山西省肿瘤医院手术清点记录II");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);
    // lodop.ADD_PRINT_HTM(10, 600, "100%", 28, "<span tdata='pageNO'>第##页</span><span tdata='pageCount'>共##页</span>");
    // lodop.SET_PRINT_STYLEA(0, "ItemType", 1);

    startPos.y += titleLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "姓名：");
    lodop.ADD_PRINT_LINE(linePos.y, 60, linePos.y, 200, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 60, 200, 15, $("#PatName").text());

    lodop.ADD_PRINT_TEXT(startPos.y, 210, 200, 15, "性别：");
    lodop.ADD_PRINT_LINE(linePos.y, 250, linePos.y, 280, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 250, 200, 15, $("#PatGender").text());

    lodop.ADD_PRINT_TEXT(startPos.y, 290, 200, 15, "年龄：");
    lodop.ADD_PRINT_LINE(linePos.y, 330, linePos.y, 370, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 330, 200, 15, $("#PatAge").text());

    lodop.ADD_PRINT_TEXT(startPos.y, 380, 200, 15, "科别：");
    lodop.ADD_PRINT_LINE(linePos.y, 420, linePos.y, 580, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 420, 200, 15, $("#PatDept").text());

    lodop.ADD_PRINT_TEXT(startPos.y, 590, 200, 15, "床号：");
    lodop.ADD_PRINT_LINE(linePos.y, 630, linePos.y, 710, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 630, 200, 15, $("#PatWardBed").text());

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "手术日期：");
    lodop.ADD_PRINT_LINE(linePos.y, 100, linePos.y, 200, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 100, 200, 15, $("#OperDate").text());

    lodop.ADD_PRINT_TEXT(startPos.y, 210, 200, 15, "手术间：");
    lodop.ADD_PRINT_LINE(linePos.y, 270, linePos.y, 330, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 270, 200, 15, $("#OperRoom").text());

    lodop.ADD_PRINT_TEXT(startPos.y, 380, 200, 15, "住院号：");
    lodop.ADD_PRINT_LINE(linePos.y, 440, linePos.y, 590, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 440, 200, 15, $("#PatMedCareNo").text());

    // startPos.y+=contentLineHeight;
    // linePos.y=startPos.y+contentLineMargin;
    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "回房交接：");
    // lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
    // lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");

    // startPos.y+=contentLineHeight;
    // linePos.y=startPos.y+contentLineMargin;
    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "意识：");
    // lodop.ADD_PRINT_LINE(linePos.y,65,linePos.y,145,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 155, 200, 30, "血压：");
    // lodop.ADD_PRINT_LINE(linePos.y,200,linePos.y,280,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 280, 200, 30, "mmHg");
    // lodop.ADD_PRINT_TEXT(startPos.y, 320, 200, 30, "脉搏：");
    // lodop.ADD_PRINT_LINE(linePos.y,365,linePos.y,445,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 445, 200, 30, "次/分");
    // lodop.ADD_PRINT_TEXT(startPos.y, 495, 200, 30, "呼吸：");
    // lodop.ADD_PRINT_LINE(linePos.y,540,linePos.y,620,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 620, 200, 30, "次/分");

    // startPos.y+=contentLineHeight;
    // linePos.y=startPos.y+contentLineMargin;
    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "静脉穿刺部位：");
    // lodop.ADD_PRINT_LINE(linePos.y,120,linePos.y,220,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 230, 200, 30, "其他：");
    // lodop.ADD_PRINT_LINE(linePos.y,275,linePos.y,355,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 365, 200, 30, "影像资料：");
    // lodop.ADD_PRINT_RECT(startPos.y,440,12,12,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 455, 200, 30, "有");
    // lodop.ADD_PRINT_RECT(startPos.y,475,12,12,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 490, 200, 30, "无");
    // lodop.ADD_PRINT_TEXT(startPos.y, 510, 200, 30, "引流：");
    // lodop.ADD_PRINT_RECT(startPos.y,555,12,12,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 575, 200, 30, "无");
    // lodop.ADD_PRINT_RECT(startPos.y,595,12,12,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 610, 200, 30, "有");
    // lodop.ADD_PRINT_LINE(linePos.y,625,linePos.y,705,0,1);

    // startPos.y+=contentLineHeight;
    // linePos.y=startPos.y+contentLineMargin;
    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "皮肤完整：");
    // lodop.ADD_PRINT_RECT(startPos.y,85,12,12,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 100, 200, 30, "是");
    // lodop.ADD_PRINT_RECT(startPos.y,120,12,12,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 135, 200, 30, "否");
    // lodop.ADD_PRINT_TEXT(startPos.y, 155, 200, 30, "(部位");
    // lodop.ADD_PRINT_LINE(linePos.y,180,linePos.y,340,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 340, 200, 30, ")");
    // lodop.ADD_PRINT_TEXT(startPos.y, 360, 200, 30, "其他：");
    // lodop.ADD_PRINT_LINE(linePos.y,405,linePos.y,485,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 505, 200, 30, "交接时间：");
    // lodop.ADD_PRINT_LINE(linePos.y,580,linePos.y,680,0,1);

    // startPos.y+=contentLineHeight;
    // linePos.y=startPos.y+contentLineMargin;
    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "备注：");
    // lodop.ADD_PRINT_LINE(linePos.y,65,linePos.y,680,0,1);

    // startPos.y+=40;
    // linePos.y=startPos.y+contentLineMargin;
    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "手术护士签名：");
    // // lodop.ADD_PRINT_LINE(linePos.y,120,linePos.y,260,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 270, 200, 30, "PACU护士签名：");
    // // lodop.ADD_PRINT_LINE(linePos.y,370,linePos.y,510,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 520, 200, 30, "病房护士签名：");
    // // lodop.ADD_PRINT_LINE(linePos.y,620,linePos.y,760,0,1);

    startPos.y += titleLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "灭菌指示卡粘贴片");
    lodop.ADD_PRINT_LINE(linePos.y, 20, linePos.y, 710, 0, 2);

    startPos.y = 620;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "植入物标识粘贴处");
    lodop.ADD_PRINT_LINE(linePos.y, 20, linePos.y, 710, 0, 2);
}

function createPrintOnePage(lodop) {
    // lodop.PRINT_INIT("OperCount" + session.OPSID);
    // lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    //lodop.SET_PRINT_MODE("PRINT_DEFAULTSOURCE",1);
    // lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    // lodop.SET_PRINT_STYLE("FontName", "宋体");
    var startPos = {
        x: 10,
        y: 10
    };
    var linePos = {
        x: startPos.x,
        y: startPos.y
    };
    var contentLineHeight = 30,
        titleLineHeight = 40,
        contentLineMargin = 20;
    lodop.SET_PRINT_STYLE("FontSize", 11);
    lodop.ADD_PRINT_TEXT(10, 300, "100%", 60, "山西省肿瘤医院手术清点记录单");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);
    lodop.ADD_PRINT_HTM(10, 600, "100%", 28, "<span tdata='pageNO'>第1页</span><span tdata='pageCount'>共3页</span>");
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);

    startPos.y += titleLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "姓名：");
    lodop.ADD_PRINT_LINE(linePos.y, 60, linePos.y, 200, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 60, 200, 15, $("#PatName").text());

    lodop.ADD_PRINT_TEXT(startPos.y, 210, 200, 15, "性别：");
    lodop.ADD_PRINT_LINE(linePos.y, 250, linePos.y, 280, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 250, 200, 15, $("#PatGender").text());

    lodop.ADD_PRINT_TEXT(startPos.y, 290, 200, 15, "年龄：");
    lodop.ADD_PRINT_LINE(linePos.y, 330, linePos.y, 370, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 330, 200, 15, $("#PatAge").text());

    lodop.ADD_PRINT_TEXT(startPos.y, 380, 200, 15, "科别：");
    lodop.ADD_PRINT_LINE(linePos.y, 420, linePos.y, 580, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 420, 200, 15, $("#PatDept").text());

    lodop.ADD_PRINT_TEXT(startPos.y, 590, 200, 15, "床号：");
    lodop.ADD_PRINT_LINE(linePos.y, 630, linePos.y, 710, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 630, 200, 15, $("#PatWardBed").text());


    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "手术日期：");
    lodop.ADD_PRINT_LINE(linePos.y, 100, linePos.y, 200, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 100, 200, 15, $("#OperDate").text());

    lodop.ADD_PRINT_TEXT(startPos.y, 210, 200, 15, "入室时间：");
    lodop.ADD_PRINT_LINE(linePos.y, 290, linePos.y, 450, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 290, 200, 15, $("#TheatreInTime").val());

    lodop.ADD_PRINT_TEXT(startPos.y, 460, 200, 15, "手术间：");
    lodop.ADD_PRINT_LINE(linePos.y, 520, linePos.y, 580, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 520, 200, 15, $("#OperRoom").text());

    lodop.ADD_PRINT_TEXT(startPos.y, 590, 200, 15, "住院号：");
    lodop.ADD_PRINT_LINE(linePos.y, 640, linePos.y, 710, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 640, 200, 15, $("#PatMedCareNo").text());

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "手术名称：");
    lodop.ADD_PRINT_LINE(linePos.y, 100, linePos.y, 710, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 100, 650, 40, $("#RealOperationDesc").val());

    startPos.y += titleLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "手术医师：");
    lodop.ADD_PRINT_LINE(linePos.y, 100, linePos.y, 260, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 100, 170, 30, $("#SurgeonDesc").text());

    lodop.ADD_PRINT_TEXT(startPos.y, 270, 200, 15, "麻醉医师：");
    lodop.ADD_PRINT_LINE(linePos.y, 350, linePos.y, 450, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 350, 200, 15, ($("#AnesthetistDesc").text() === "" ? $("#AnaestDoctor").val() : $("#AnesthetistDesc").text()));

    lodop.ADD_PRINT_TEXT(startPos.y, 460, 200, 15, "血型：");
    lodop.ADD_PRINT_LINE(linePos.y, 500, linePos.y, 580, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 500, 100, 15, $("#ABO").text() || "/");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);

    lodop.ADD_PRINT_TEXT(startPos.y, 590, 200, 15, "RH(D)：");
    lodop.ADD_PRINT_LINE(linePos.y, 640, linePos.y, 730, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 640, 100, 15, $("#RH").text() || "/");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "护理情况：");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");

    contentLineMargin = 15;
    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "穿刺部位：");
    lodop.ADD_PRINT_RECT(startPos.y, 95, 12, 12, 0, 1);
    if (!$("#VenipunctureSiteCHK1").checkbox("getValue")) {
        lodop.ADD_PRINT_TEXT(startPos.y, 96, 12, 12, "/");
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 92, 12, 12, $("#VenipunctureSiteCHK1").checkbox("getValue") ? "√" : "");
    }
    lodop.ADD_PRINT_TEXT(startPos.y, 110, 240, 20, "右上肢");
    lodop.ADD_PRINT_RECT(startPos.y, 165, 12, 12, 0, 1);
    if (!$("#VenipunctureSiteCHK2").checkbox("getValue")) {
        lodop.ADD_PRINT_TEXT(startPos.y, 166, 12, 12, "/");
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 162, 12, 12, $("#VenipunctureSiteCHK2").checkbox("getValue") ? "√" : "/");
    }

    lodop.ADD_PRINT_TEXT(startPos.y, 180, 240, 20, "左上肢");
    lodop.ADD_PRINT_RECT(startPos.y, 235, 12, 12, 0, 1);
    if (!$("#VenipunctureSiteCHK3").checkbox("getValue")) {
        lodop.ADD_PRINT_TEXT(startPos.y, 236, 12, 12, "/");
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 232, 12, 12, $("#VenipunctureSiteCHK3").checkbox("getValue") ? "√" : "");
    }

    lodop.ADD_PRINT_TEXT(startPos.y, 250, 240, 20, "右下肢");
    lodop.ADD_PRINT_RECT(startPos.y, 305, 12, 12, 0, 1);
    if (!$("#VenipunctureSiteCHK4").checkbox("getValue")) {
        lodop.ADD_PRINT_TEXT(startPos.y, 306, 12, 12, "/");
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 302, 12, 12, $("#VenipunctureSiteCHK4").checkbox("getValue") ? "√" : "");
    }

    lodop.ADD_PRINT_TEXT(startPos.y, 320, 240, 20, "左下肢");
    var text = $("#VenipunctureSiteElse").val();
    text = (text && text !== splitchar.empty ? text : "/");
    lodop.ADD_PRINT_TEXT(startPos.y, 375, 240, 20, "其他：");
    lodop.ADD_PRINT_LINE(linePos.y, 420, linePos.y, 580, 0, 1);
    if (text === splitchar.emptyContent) {
        lodop.ADD_PRINT_TEXT(startPos.y, 490, 240, 20, text);
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 420, 240, 20, text);
    }


    lodop.ADD_PRINT_TEXT(startPos.y, 590, 240, 20, "导尿：");
    lodop.ADD_PRINT_RECT(startPos.y, 635, 12, 12, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 632, 12, 12, $("#CatheterizationCHK1").checkbox("getValue") ? "√" : "");
    lodop.ADD_PRINT_TEXT(startPos.y, 650, 240, 20, "有");
    lodop.ADD_PRINT_RECT(startPos.y, 680, 12, 12, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 677, 12, 12, $("#CatheterizationCHK2").checkbox("getValue") ? "√" : "");
    lodop.ADD_PRINT_TEXT(startPos.y, 695, 240, 20, "无");

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "体    位：");
    lodop.ADD_PRINT_RECT(startPos.y, 95, 12, 12, 0, 1);
    if (!$("#PositionCHK1").checkbox("getValue")) {
        lodop.ADD_PRINT_TEXT(startPos.y, 96, 12, 12, "/");
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 92, 12, 12, $("#PositionCHK1").checkbox("getValue") ? "√" : "");
    }
    lodop.ADD_PRINT_TEXT(startPos.y, 110, 240, 20, "仰卧位");

    lodop.ADD_PRINT_RECT(startPos.y, 165, 12, 12, 0, 1);
    if (!$("#PositionCHK2").checkbox("getValue")) {
        lodop.ADD_PRINT_TEXT(startPos.y, 166, 12, 12, "/");
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 162, 12, 12, $("#PositionCHK2").checkbox("getValue") ? "√" : "");
    }
    lodop.ADD_PRINT_TEXT(startPos.y, 180, 240, 20, "左侧卧位");

    lodop.ADD_PRINT_RECT(startPos.y, 250, 12, 12, 0, 1);
    if (!$("#PositionCHK3").checkbox("getValue")) {
        lodop.ADD_PRINT_TEXT(startPos.y, 251, 12, 12, "/");
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 247, 12, 12, $("#PositionCHK3").checkbox("getValue") ? "√" : "");
    }
    lodop.ADD_PRINT_TEXT(startPos.y, 265, 240, 20, "右侧卧位");

    lodop.ADD_PRINT_RECT(startPos.y, 335, 12, 12, 0, 1);
    if (!$("#PositionCHK4").checkbox("getValue")) {
        lodop.ADD_PRINT_TEXT(startPos.y, 336, 12, 12, "/");
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 332, 12, 12, $("#PositionCHK4").checkbox("getValue") ? "√" : "");
    }
    lodop.ADD_PRINT_TEXT(startPos.y, 350, 240, 20, "俯卧位");

    lodop.ADD_PRINT_RECT(startPos.y, 405, 12, 12, 0, 1);
    if (!$("#PositionCHK5").checkbox("getValue")) {
        lodop.ADD_PRINT_TEXT(startPos.y, 406, 12, 12, "/");
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 402, 12, 12, $("#PositionCHK5").checkbox("getValue") ? "√" : "");
    }
    lodop.ADD_PRINT_TEXT(startPos.y, 420, 240, 20, "截石位");
    text = $("#PositionElse").val();
    text = (text && text !== splitchar.empty ? text : "/");
    lodop.ADD_PRINT_TEXT(startPos.y, 475, 240, 20, "其他：");
    lodop.ADD_PRINT_LINE(linePos.y, 520, linePos.y, 710, 0, 1);
    if (text === splitchar.emptyContent) {
        lodop.ADD_PRINT_TEXT(startPos.y, 605, 240, 20, text);
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 520, 240, 20, text);
    }

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "输    血：");
    lodop.ADD_PRINT_LINE(linePos.y, 95, linePos.y, 710, 0, 1);
    text = $("#BloodTransfusion").val();
    text = (text && text !== splitchar.empty ? text : splitchar.emptyContent);
    if (text === splitchar.emptyContent) {
        lodop.ADD_PRINT_TEXT(startPos.y, 380, 440, 20, text);
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 95, 440, 20, text);
    }

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "负极板粘贴位置：");

    lodop.ADD_PRINT_RECT(startPos.y, 165, 12, 12, 0, 1);
    if (!$("#PastingPositionCHK1").checkbox("getValue")) {
        lodop.ADD_PRINT_TEXT(startPos.y, 166, 12, 12, "/");
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 162, 12, 12, $("#PastingPositionCHK1").checkbox("getValue") ? "√" : "");
    }
    lodop.ADD_PRINT_TEXT(startPos.y, 180, 240, 20, "右上肢");

    lodop.ADD_PRINT_RECT(startPos.y, 235, 12, 12, 0, 1);
    if (!$("#PastingPositionCHK2").checkbox("getValue")) {
        lodop.ADD_PRINT_TEXT(startPos.y, 236, 12, 12, "/");
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 232, 12, 12, $("#PastingPositionCHK2").checkbox("getValue") ? "√" : "");
    }
    lodop.ADD_PRINT_TEXT(startPos.y, 250, 240, 20, "左上肢");

    lodop.ADD_PRINT_RECT(startPos.y, 305, 12, 12, 0, 1);
    if (!$("#PastingPositionCHK3").checkbox("getValue")) {
        lodop.ADD_PRINT_TEXT(startPos.y, 306, 12, 12, "/");
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 302, 12, 12, $("#PastingPositionCHK3").checkbox("getValue") ? "√" : "");
    }
    lodop.ADD_PRINT_TEXT(startPos.y, 320, 240, 20, "右下肢");

    lodop.ADD_PRINT_RECT(startPos.y, 375, 12, 12, 0, 1);
    if (!$("#PastingPositionCHK4").checkbox("getValue")) {
        lodop.ADD_PRINT_TEXT(startPos.y, 376, 12, 12, "/");
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 372, 12, 12, $("#PastingPositionCHK4").checkbox("getValue") ? "√" : "");
    }

    lodop.ADD_PRINT_TEXT(startPos.y, 390, 240, 20, "左下肢");
    var text = $("#PastingPositionElse").val();
    text = (text && text !== splitchar.empty ? text : "/");
    lodop.ADD_PRINT_TEXT(startPos.y, 445, 240, 20, "其他：");
    lodop.ADD_PRINT_LINE(linePos.y, 490, linePos.y, 710, 0, 1);
    if (text === splitchar.emptyContent) {
        lodop.ADD_PRINT_TEXT(startPos.y, 590, 240, 20, text);
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 490, 240, 20, text);
    }

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "仪器设备：");
    lodop.ADD_PRINT_LINE(linePos.y, 95, linePos.y, 710, 0, 1);
    text = $("#EquipDesc").val();
    text = (text && text !== splitchar.empty ? text : splitchar.emptyContent);
    if (text === splitchar.emptyContent) {
        lodop.ADD_PRINT_TEXT(startPos.y, 380, "100%", 20, text);
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 95, "100%", 20, text);
    }

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "特殊物品：");
    lodop.ADD_PRINT_RECT(startPos.y, 95, 12, 12, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 95, 12, 12, $("#SpecialItemsCHK2").checkbox("getValue") ? "√" : "");
    lodop.ADD_PRINT_TEXT(startPos.y, 110, 240, 20, "无");
    lodop.ADD_PRINT_RECT(startPos.y, 140, 12, 12, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 140, 12, 12, $("#SpecialItemsCHK1").checkbox("getValue") ? "√" : "");
    lodop.ADD_PRINT_TEXT(startPos.y, 155, 240, 20, "有");
    lodop.ADD_PRINT_LINE(linePos.y, 185, linePos.y, 710, 0, 1);
    text = "";
    var specialItem = $("#SpecialItemsDesc").val();
    var alphabetReg = /\w|\s|\d|[\-,\+]/g;
    if (specialItem !== splitchar.empty) {
        var specialItemLen = specialItem.length;
        var charWidth = 14,
            charCount = Math.round((710 - 185) / charWidth),
            curSpecialItem = specialItem.substr(0, charCount);
        var match = curSpecialItem.match(alphabetReg);
        if (match && match.length > 0) {
            charCount = charCount + match.length / 2;
            charCount = Math.round(charCount);
            curSpecialItem = specialItem.substr(0, charCount);
        }

        text = curSpecialItem;
        specialItem = specialItem.substr(charCount, specialItemLen - charCount);
        if (specialItemLen <= charCount) {
            specialItem = "";
        }
    }
    text = (text && text !== splitchar.empty ? text : splitchar.emptyContent);
    if (text === splitchar.emptyContent) {
        lodop.ADD_PRINT_TEXT(startPos.y, 440, "100%", 20, text);
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 185, "100%", 20, text);
    }

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_LINE(linePos.y, 20, linePos.y, 710, 0, 1);
    text = "";
    if (specialItem !== splitchar.empty) {
        var specialItemLen = specialItem.length;
        var charWidth = 14,
            charCount = Math.round((710 - 20) / charWidth),
            curSpecialItem = specialItem.substr(0, charCount);
        var match = curSpecialItem.match(alphabetReg);
        if (match && match.length > 0) {
            charCount = charCount + match.length / 2;
            charCount = Math.round(charCount);
            curSpecialItem = specialItem.substr(0, charCount);
        }
        text = curSpecialItem;
        specialItem = specialItem.substr(charCount, (specialItemLen > charCount ? (specialItemLen - charCount) : specialItemLen));
        if (specialItemLen <= charCount) {
            specialItem = "";
        }
    }
    text = (text && text !== splitchar.empty ? text : splitchar.emptyContent);
    if (text === splitchar.emptyContent) {
        lodop.ADD_PRINT_TEXT(startPos.y, 385, "100%", 20, text);
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 20, "100%", 20, text);
    }

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_LINE(linePos.y, 20, linePos.y, 710, 0, 1);
    text = "";
    if (specialItem !== splitchar.empty) {
        var specialItemLen = specialItem.length;
        var charWidth = 14,
            charCount = Math.round((710 - 20) / charWidth),
            curSpecialItem = specialItem.substr(0, charCount);
        var match = curSpecialItem.match(alphabetReg);
        if (match && match.length > 0) {
            charCount = charCount + match.length / 2;
            charCount = Math.round(charCount);
            curSpecialItem = specialItem.substr(0, charCount);
        }
        text = curSpecialItem;
        specialItem = specialItem.substr(charCount, specialItemLen - charCount);
    }
    text = (text && text !== splitchar.empty ? text : splitchar.emptyContent);
    if (text === splitchar.emptyContent) {
        lodop.ADD_PRINT_TEXT(startPos.y, 385, "100%", 20, text);
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 20, "100%", 20, text);
    }

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_LINE(linePos.y, 20, linePos.y, 710, 0, 1);
    text = "";
    if (specialItem !== splitchar.empty) {
        var specialItemLen = specialItem.length;
        var charWidth = 14,
            charCount = Math.round((710 - 20) / charWidth),
            curSpecialItem = specialItem.substr(0, charCount);
        var match = curSpecialItem.match(alphabetReg);
        if (match && match.length > 0) {
            charCount = charCount + match.length / 2;
            charCount = Math.round(charCount);
            curSpecialItem = specialItem.substr(0, charCount);
        }
        text = curSpecialItem;
        specialItem = specialItem.substr(charCount, specialItemLen - charCount);
    }
    text = (text && text !== splitchar.empty ? text : splitchar.emptyContent);
    if (text === splitchar.emptyContent) {
        lodop.ADD_PRINT_TEXT(startPos.y, 385, "100%", 20, text);
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 20, "100%", 20, text);
    }

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_LINE(linePos.y, 20, linePos.y, 710, 0, 1);
    text = "";
    if (specialItem !== splitchar.empty) {
        var specialItemLen = specialItem.length;
        var charWidth = 14,
            charCount = Math.round((710 - 20) / charWidth),
            curSpecialItem = specialItem.substr(0, charCount);
        var match = curSpecialItem.match(alphabetReg);
        if (match && match.length > 0) {
            charCount = charCount + match.length / 2;
            charCount = Math.round(charCount);
            curSpecialItem = specialItem.substr(0, charCount);
        }
        text = curSpecialItem;
        specialItem = specialItem.substr(charCount, specialItemLen - charCount);
    }
    text = (text && text !== splitchar.empty ? text : splitchar.emptyContent);
    if (text === splitchar.emptyContent) {
        lodop.ADD_PRINT_TEXT(startPos.y, 385, "100%", 20, text);
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 20, "100%", 20, text);
    }

    // startPos.y+=contentLineHeight;
    // linePos.y=startPos.y+contentLineMargin;
    // lodop.ADD_PRINT_LINE(linePos.y,20,linePos.y,710,0,1);
    // text="";
    // if(specialItem!==splitchar.empty){
    //     var specialItemLen=specialItem.length;
    //     var charWidth=14,charCount=Math.round((710-20)/charWidth),curSpecialItem=specialItem.substr(0,charCount);
    //     var match = curSpecialItem.match(alphabetReg);
    //     if (match && match.length>0) {
    //         charCount = charCount+match.length/2;
    //         charCount=Math.round(charCount);
    //         curSpecialItem=specialItem.substr(0,charCount);
    //     }
    //     text=curSpecialItem;
    //     specialItem=specialItem.substr(charCount,specialItemLen-charCount);
    // }
    // text=(text && text!==splitchar.empty?text:splitchar.emptyContent);
    // if(text===splitchar.emptyContent){
    //     lodop.ADD_PRINT_TEXT(startPos.y,385,"100%",20, text);
    // }else{
    //     lodop.ADD_PRINT_TEXT(startPos.y,20,"100%",20, text);
    // }

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    htmlArr = [
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;}",
        "th {font-size:14px;font-weight:bold;text-align:center}",
        "tr>td {text-align:center;font-size:12px} tr {height:20px;}",
        ".opercount {width:30px;} .itemtitle {width:60px;} </style>",
        "<table style='table-layout:fixed;'><thead><tr><th class='itemtitle'>项目</th><th class='opercount'>术前清点</th><th class='opercount'>术中加数</th><th class='opercount'>关体腔前</th><th class='opercount'>关体腔后</th><th class='opercount'>缝皮肤后</th>",
        "<th class='itemtitle'>项目</th><th class='opercount'>术前清点</th><th class='opercount'>术中加数</th><th class='opercount'>关体腔前</th><th class='opercount'>关体腔后</th><th class='opercount'>缝皮肤后</th>",
        "<th class='itemtitle'>项目</th><th class='opercount'>术前清点</th><th class='opercount'>术中加数</th><th class='opercount'>关体腔前</th><th class='opercount'>关体腔后</th><th class='opercount'>缝皮肤后</th></tr></thead><tbody>",
    ];
    var operCountRows = $("#dataBox").datagrid("getRows");
    var maxCount = 20;
    var operCountRow;
    var secCountRow, thirdCountRow;
    var operCount = {
        MaterialNote: splitchar.emptyContent,
        PreopCount: splitchar.emptyContent,
        OperAddCount: splitchar.emptyContent,
        PreCloseCount: splitchar.emptyContent,
        PostCloseCount: splitchar.emptyContent,
        PostSewCount: splitchar.emptyContent
    }
    for (var i = 0; i < maxCount; i++) {
        if (i >= operCountRows.length) {
            operCountRow = operCount;
            secCountRow = operCount;
            thirdCountRow = operCount;
        } else {
            operCountRow = operCountRows[i];
            secCountRow = operCountRows.length > (i + maxCount) ? operCountRows[i + maxCount] : operCount;
            thirdCountRow = operCountRows.length > (i + 2 * maxCount) ? operCountRows[(i + 2 * maxCount)] : operCount;
        }

        htmlArr.push("<tr><td>" + (operCountRow.MaterialNote ? operCountRow.MaterialNote : "/") + "</td>");
        htmlArr.push("<td>" + operCountRow.PreopCount + "</td>");
        htmlArr.push("<td>" + operCountRow.OperAddCount + "</td>");
        htmlArr.push("<td>" + operCountRow.PreCloseCount + "</td>");
        htmlArr.push("<td>" + operCountRow.PostCloseCount + "</td>");
        htmlArr.push("<td>" + operCountRow.PostSewCount + "</td>");
        htmlArr.push("<td>" + (secCountRow.MaterialNote ? secCountRow.MaterialNote : "/") + "</td>");
        htmlArr.push("<td>" + secCountRow.PreopCount + "</td>");
        htmlArr.push("<td>" + secCountRow.OperAddCount + "</td>");
        htmlArr.push("<td>" + secCountRow.PreCloseCount + "</td>");
        htmlArr.push("<td>" + secCountRow.PostCloseCount + "</td>");
        htmlArr.push("<td>" + secCountRow.PostSewCount + "</td>");
        htmlArr.push("<td>" + (thirdCountRow.MaterialNote ? thirdCountRow.MaterialNote : "/") + "</td>");
        htmlArr.push("<td>" + thirdCountRow.PreopCount + "</td>");
        htmlArr.push("<td>" + thirdCountRow.OperAddCount + "</td>");
        htmlArr.push("<td>" + thirdCountRow.PreCloseCount + "</td>");
        htmlArr.push("<td>" + thirdCountRow.PostCloseCount + "</td>");
        htmlArr.push("<td>" + thirdCountRow.PostSewCount + "</td></tr>");
    }
    htmlArr.push("</tbody></table>");
    lodop.ADD_PRINT_TABLE(startPos.y, 20, 720, "100%", htmlArr.join(""));

    startPos.y += 460;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "标本：");
    lodop.ADD_PRINT_RECT(startPos.y, 65, 12, 12, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 65, 12, 12, $("#SpecimenCHK1").checkbox("getValue") ? "√" : "");
    lodop.ADD_PRINT_TEXT(startPos.y, 80, 240, 20, "无");
    lodop.ADD_PRINT_RECT(startPos.y, 110, 12, 12, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 110, 12, 12, $("#SpecimenCHK2").checkbox("getValue") ? "√" : "");
    lodop.ADD_PRINT_TEXT(startPos.y, 125, 240, 20, "有");
    lodop.ADD_PRINT_TEXT(startPos.y, 145, 240, 20, "(");
    lodop.ADD_PRINT_RECT(startPos.y, 160, 12, 12, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 160, 12, 12, $("#Freezes").checkbox("getValue") ? "√" : "");
    lodop.ADD_PRINT_TEXT(startPos.y, 175, 240, 20, "送冰冻");
    lodop.ADD_PRINT_RECT(startPos.y, 230, 12, 12, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 230, 12, 12, $("#Pathology").checkbox("getValue") ? "√" : "");
    lodop.ADD_PRINT_TEXT(startPos.y, 245, 240, 20, "送病理");
    lodop.ADD_PRINT_RECT(startPos.y, 300, 12, 12, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 300, 12, 12, $("#UnPathology").checkbox("getValue") ? "√" : "");
    lodop.ADD_PRINT_TEXT(startPos.y, 315, 240, 20, "未送检");
    lodop.ADD_PRINT_TEXT(startPos.y, 360, 240, 20, ")");
    // lodop.ADD_PRINT_TEXT(startPos.y,380,240,20, "手术医生：");
    // var imgSrc=$("#SpecimenSurgeonSign").attr("src");
    // imgSrc=(imgSrc && imgSrc!==splitchar.empty)?imgSrc:splitchar.empty;
    // img=(imgSrc!==splitchar.empty)?("<img src='"+imgSrc+"' width='70' height='35'>"):"<img>";
    // lodop.ADD_PRINT_IMAGE(startPos.y-20,450,"100%","100%",img);

    // startPos.y+=contentLineHeight;
    // linePos.y=startPos.y+contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 390, 200, 30, "术后送回：");
    lodop.ADD_PRINT_RECT(startPos.y, 465, 12, 12, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 465, 12, 12, $("#PostOperationCHK1").checkbox("getValue") ? "√" : "");
    lodop.ADD_PRINT_TEXT(startPos.y, 480, 240, 20, "病房");
    lodop.ADD_PRINT_RECT(startPos.y, 520, 12, 12, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 520, 12, 12, $("#PostOperationCHK2").checkbox("getValue") ? "√" : "");
    lodop.ADD_PRINT_TEXT(startPos.y, 535, 240, 20, "ICU");
    lodop.ADD_PRINT_RECT(startPos.y, 575, 12, 12, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 575, 12, 12, $("#PostOperationCHK3").checkbox("getValue") ? "√" : "");
    lodop.ADD_PRINT_TEXT(startPos.y, 590, 240, 20, "PACU");
    lodop.ADD_PRINT_RECT(startPos.y, 630, 12, 12, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 630, 12, 12, $("#PostOperationCHK4").checkbox("getValue") ? "√" : "");
    lodop.ADD_PRINT_TEXT(startPos.y, 645, 240, 20, "返家");
    lodop.ADD_PRINT_RECT(startPos.y, 685, 12, 12, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 685, 12, 12, $("#PostOperationCHK4").checkbox("getValue") ? "√" : "");
    lodop.ADD_PRINT_TEXT(startPos.y, 700, 240, 20, "未离室");

    startPos.y += 40;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "手术中特殊问题及处理：");
    var imgSrc = $("#ConditionSurgeonSign").attr("src");
    imgSrc = (imgSrc && imgSrc !== splitchar.empty) ? imgSrc : splitchar.empty;
    var conditionLineX = 710;
    if (imgSrc !== "") {
        conditionLineX = 610;
    }
    var contentWidth = conditionLineX - 185;
    lodop.ADD_PRINT_LINE(linePos.y, 185, linePos.y, conditionLineX, 0, 1);
    text = $("#OperSpecicalCondition").val();
    text = (text && text !== splitchar.empty ? text : splitchar.emptyContent);
    if (text === splitchar.emptyContent) {
        lodop.ADD_PRINT_TEXT(startPos.y, 435, 240, 20, text);
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 185, contentWidth, "100%", text);
    }

    if (imgSrc !== "") {
        lodop.ADD_PRINT_TEXT(startPos.y, 615, 240, 20, "手术医生：");
        img = (imgSrc !== splitchar.empty) ? ("<img src='" + imgSrc + "' width='70' height='35'>") : "<img>";
        lodop.ADD_PRINT_IMAGE(startPos.y - 20, 680, "100%", "100%", img);
    }


    startPos.y += 60;
    linePos.y = startPos.y + contentLineMargin;
    var imgX = 85;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "器械护士：");
    imgSrc = $("#ScNurseSign").attr("src");
    imgSrc = (imgSrc && imgSrc !== splitchar.empty) ? imgSrc : splitchar.empty;
    if (imgSrc === "") {
        lodop.ADD_PRINT_TEXT(startPos.y, 95, 200, 30, "/");
    } else {
        img = (imgSrc !== splitchar.empty) ? ("<img src='" + imgSrc + "' width='70' height='35'>") : "<img>";
        lodop.ADD_PRINT_IMAGE(startPos.y - 20, imgX, "100%", "100%", img);
    }


    imgSrc = $("#ScNurseSign2").attr("src");
    if (imgSrc && imgSrc !== "") {
        imgX += 70;
        imgSrc = (imgSrc && imgSrc !== splitchar.empty) ? imgSrc : splitchar.empty;
        img = (imgSrc !== splitchar.empty) ? ("<img src='" + imgSrc + "' width='70' height='35'>") : "<img>";
        lodop.ADD_PRINT_IMAGE(startPos.y - 20, imgX, "100%", "100%", img);
    }

    imgSrc = $("#ScNurseSign3").attr("src");
    if (imgSrc && imgSrc !== "") {
        imgX += 70;
        imgSrc = (imgSrc && imgSrc !== splitchar.empty) ? imgSrc : splitchar.empty;
        img = (imgSrc !== splitchar.empty) ? ("<img src='" + imgSrc + "' width='70' height='35'>") : "<img>";
        lodop.ADD_PRINT_IMAGE(startPos.y - 20, imgX, "100%", "100%", img);
    }

    imgX += 80;
    lodop.ADD_PRINT_TEXT(startPos.y, imgX, 200, 30, "巡回护士：");
    imgX += 65;
    imgSrc = $("#CirNurseSign").attr("src");
    imgSrc = (imgSrc && imgSrc !== splitchar.empty) ? imgSrc : splitchar.empty;
    img = (imgSrc !== splitchar.empty) ? ("<img src='" + imgSrc + "' width='70' height='35'>") : "<img>";
    lodop.ADD_PRINT_IMAGE(startPos.y - 20, imgX, "100%", "100%", img);

    imgSrc = $("#CirNurseSign2").attr("src");
    if (imgSrc && imgSrc !== "") {
        imgX += 70;
        imgSrc = (imgSrc && imgSrc !== splitchar.empty) ? imgSrc : splitchar.empty;
        img = (imgSrc !== splitchar.empty) ? ("<img src='" + imgSrc + "' width='70' height='35'>") : "<img>";
        lodop.ADD_PRINT_IMAGE(startPos.y - 20, imgX, "100%", "100%", img);
    }

    lodop.ADD_PRINT_TEXT(startPos.y, 520, 200, 30, "出室时间：");
    lodop.ADD_PRINT_LINE(linePos.y, 585, linePos.y, 730, 0, 1);

    text = $("#TheatreOutTime").val();
    text = (text && text !== splitchar.empty ? text : splitchar.emptyContent);
    if (text === splitchar.emptyContent) {
        // lodop.ADD_PRINT_TEXT(startPos.y,635,240,20, text);
    } else {
        lodop.ADD_PRINT_TEXT(startPos.y, 585, 240, 20, text);
    }

    // startPos.y+=40;
    // linePos.y=startPos.y+contentLineMargin;
    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "回房交接：");
    // lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
    // lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");

    // startPos.y+=contentLineHeight;
    // linePos.y=startPos.y+contentLineMargin;
    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "意识：");
    // lodop.ADD_PRINT_LINE(linePos.y,65,linePos.y,145,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 155, 200, 30, "血压：");
    // lodop.ADD_PRINT_LINE(linePos.y,200,linePos.y,280,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 280, 200, 30, "mmHg");
    // lodop.ADD_PRINT_TEXT(startPos.y, 320, 200, 30, "脉搏：");
    // lodop.ADD_PRINT_LINE(linePos.y,365,linePos.y,445,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 445, 200, 30, "次/分");
    // lodop.ADD_PRINT_TEXT(startPos.y, 495, 200, 30, "呼吸：");
    // lodop.ADD_PRINT_LINE(linePos.y,540,linePos.y,620,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 620, 200, 30, "次/分");

    // startPos.y+=contentLineHeight;
    // linePos.y=startPos.y+contentLineMargin;
    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "静脉穿刺部位：");
    // lodop.ADD_PRINT_LINE(linePos.y,120,linePos.y,220,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 230, 200, 30, "其他：");
    // lodop.ADD_PRINT_LINE(linePos.y,275,linePos.y,355,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 365, 200, 30, "影像资料：");
    // lodop.ADD_PRINT_RECT(startPos.y,440,12,12,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 455, 200, 30, "有");
    // lodop.ADD_PRINT_RECT(startPos.y,475,12,12,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 490, 200, 30, "无");
    // lodop.ADD_PRINT_TEXT(startPos.y, 510, 200, 30, "引流：");
    // lodop.ADD_PRINT_RECT(startPos.y,555,12,12,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 575, 200, 30, "无");
    // lodop.ADD_PRINT_RECT(startPos.y,595,12,12,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 610, 200, 30, "有");
    // lodop.ADD_PRINT_LINE(linePos.y,625,linePos.y,705,0,1);

    // startPos.y+=contentLineHeight;
    // linePos.y=startPos.y+contentLineMargin;
    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "皮肤完整：");
    // lodop.ADD_PRINT_RECT(startPos.y,85,12,12,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 100, 200, 30, "是");
    // lodop.ADD_PRINT_RECT(startPos.y,120,12,12,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 135, 200, 30, "否");
    // lodop.ADD_PRINT_TEXT(startPos.y, 155, 200, 30, "(部位");
    // lodop.ADD_PRINT_LINE(linePos.y,180,linePos.y,340,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 340, 200, 30, ")");
    // lodop.ADD_PRINT_TEXT(startPos.y, 360, 200, 30, "其他：");
    // lodop.ADD_PRINT_LINE(linePos.y,405,linePos.y,485,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 505, 200, 30, "交接时间：");
    // lodop.ADD_PRINT_LINE(linePos.y,580,linePos.y,680,0,1);

    // startPos.y+=contentLineHeight;
    // linePos.y=startPos.y+contentLineMargin;
    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "备注：");
    // lodop.ADD_PRINT_LINE(linePos.y,65,linePos.y,680,0,1);

    // startPos.y+=40;
    // linePos.y=startPos.y+contentLineMargin;
    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 30, "手术护士签名：");
    // // lodop.ADD_PRINT_LINE(linePos.y,120,linePos.y,260,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 270, 200, 30, "PACU护士签名：");
    // // lodop.ADD_PRINT_LINE(linePos.y,370,linePos.y,510,0,1);
    // lodop.ADD_PRINT_TEXT(startPos.y, 520, 200, 30, "病房护士签名：");
    // lodop.ADD_PRINT_LINE(linePos.y,620,linePos.y,760,0,1);


    // 如果手术物品数量超过40，则将剩余手术清点信息另起一页打印。
    if (operCountRows && operCountRows.length > 0 && operCountRows.length > 3 * maxCount) {
        lodop.NEWPAGE();
        htmlArr = [
            "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;}",
            "th {font-size:14px;font-weight:bold;text-align:center}",
            "tr>td {text-align:center;font-size:12px;}",
            ".opercount {width:30px;}</style>",
            "<table><thead><tr><th style='width:60px'>项目</th><th class='opercount'>术前清点</th><th class='opercount'>术中加数</th><th class='opercount'>关体腔前</th><th class='opercount'>关体腔后</th><th class='opercount'>缝皮肤后</th>",
            "<th style='width:60px'>项目</th><th class='opercount'>术前清点</th><th class='opercount'>术中加数</th><th class='opercount'>关体腔前</th><th class='opercount'>关体腔后</th><th class='opercount'>缝皮肤后</th>",
            "<th class='width:60px'>项目</th><th class='opercount'>术前清点</th><th class='opercount'>术中加数</th><th class='opercount'>关体腔前</th><th class='opercount'>关体腔后</th><th class='opercount'>缝皮肤后</th></tr></thead><tbody>"
        ];
        for (var i = 3 * maxCount; i < 6 * maxCount; i++) {
            if (i >= operCountRows.length) {
                operCountRow = operCount;
                secCountRow = operCount;
                thirdCountRow = operCount;
            } else {
                operCountRow = operCountRows[i];
                secCountRow = operCountRows.length > (i + 4 * maxCount) ? operCountRows[i + 4 * maxCount] : operCount;
                thirdCountRow = operCountRows.length > (i + 5 * maxCount) ? operCountRows[i + 5 * maxCount] : operCount;
            }
            htmlArr.push("<tr><td>" + (operCountRow.SurgicalMaterialsDesc ? operCountRow.SurgicalMaterialsDesc : "/") + "</td>");
            htmlArr.push("<td>" + operCountRow.PreopCount + "</td>");
            htmlArr.push("<td>" + operCountRow.OperAddCount + "</td>");
            htmlArr.push("<td>" + operCountRow.PreCloseCount + "</td>");
            htmlArr.push("<td>" + operCountRow.PostCloseCount + "</td>");
            htmlArr.push("<td>" + operCountRow.PostSewCount + "</td>");
            htmlArr.push("<td>" + (secCountRow.SurgicalMaterialsDesc ? secCountRow.SurgicalMaterialsDesc : "/") + "</td>");
            htmlArr.push("<td>" + secCountRow.PreopCount + "</td>");
            htmlArr.push("<td>" + secCountRow.OperAddCount + "</td>");
            htmlArr.push("<td>" + secCountRow.PreCloseCount + "</td>");
            htmlArr.push("<td>" + secCountRow.PostCloseCount + "</td>");
            htmlArr.push("<td>" + secCountRow.PostSewCount + "</td>");
            htmlArr.push("<td>" + (thirdCountRow.SurgicalMaterialsDesc ? thirdCountRow.SurgicalMaterialsDesc : "/") + "</td>");
            htmlArr.push("<td>" + thirdCountRow.PreopCount + "</td>");
            htmlArr.push("<td>" + thirdCountRow.OperAddCount + "</td>");
            htmlArr.push("<td>" + thirdCountRow.PreCloseCount + "</td>");
            htmlArr.push("<td>" + thirdCountRow.PostCloseCount + "</td>");
            htmlArr.push("<td>" + thirdCountRow.PostSewCount + "</td></tr>");
        }
        htmlArr.push("</tbody></table>");
        lodop.ADD_PRINT_HTM(90, 60, "100%", "100%", htmlArr.join(""));
    }

    // 打印手术清点或手术护理记录单背面高值耗材条码和无菌包条码

    // lodop.ADD_PRINT_HTM(115,20,"100%","100%","<img src='../service/dhcanop/img/test2.jpg' width=200 height=200>");
    // var cardImage=getSterilityPackImage();
    // lodop.NEWPAGE();
    // startPos.y=60;
    // linePos.y=startPos.y+15;
    // var imgLoc={x:10,y:linePos.y};
    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "灭菌指示卡粘贴片");
    // lodop.ADD_PRINT_LINE(linePos.y,20,linePos.y,710,0,2);
    // var pageBottom=1100,imgTotalCount=0;
    // if(cardImage && cardImage.success && cardImage.result){
    //     var imgArr=cardImage.result.split("&&&");
    //     imgTotalCount=imgArr.length;
    //     var imgCount=0;
    //     var imgWidth=320,imgHeight=320,imgMargin=10;
    //     var imgSrc="",curImgLoc={x:10,y:linePos.y};
    //     for(var i=0;i<imgArr.length;i++){
    //         var imgStr=imgArr[i];
    //         if(imgStr===splitchar.empty) continue;
    //         imgSrc="<img src='data:image/png;base64,"+imgStr+"' width='"+imgWidth+"' height='"+imgHeight+"'>";
    //         // 超过一页高度，则另起一页。
    //         if(imgLoc.y+imgHeight+2*imgMargin>pageBottom){
    //             lodop.NEWPAGE();
    //             lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "灭菌指示卡粘贴片");
    //             lodop.ADD_PRINT_LINE(linePos.y,20,linePos.y,710,0,2);
    //             imgLoc={x:10,y:linePos.y};
    //             curImgLoc={x:10,y:linePos.y};
    //         }
    //         curImgLoc.x=(imgLoc.x+imgCount*imgWidth+(imgCount+1)*imgMargin);
    //         curImgLoc.y=(imgLoc.y+imgMargin);
    //         lodop.ADD_PRINT_IMAGE(curImgLoc.y,curImgLoc.x,"100%","100%",imgSrc);
    //         imgCount++;
    //         if(imgCount%2===0){
    //             imgLoc.y=imgLoc.y+imgHeight+imgMargin;
    //             imgCount=0;
    //         }
    //     }
    // }

    // var cardWidth=240,cardHeight=130,cardMargin=10,cardLoc={x:10,y:420},cardCount=0;
    // // 如果无菌包图片超过2张，那么植入性耗材的起始位置根据最后一张图片的位置和大小确定。如果不超过，那么默认固定为620
    // if((imgTotalCount-1)>2){
    //     startPos.y=imgLoc.y+3*imgMargin+imgHeight;
    // }else{
    //     startPos.y=cardLoc.y;
    // }

    // var materialTitleHeight=15;
    // var cardStartLocY=startPos.y+materialTitleHeight+cardMargin;

    // // 如果页面剩余空白处无法打印一个高值耗材标签，那么另起一页。
    // if(cardStartLocY+cardHeight+cardMargin>pageBottom){
    //     lodop.NEWPAGE();
    //    startPos.y=60;
    // }
    // linePos.y=startPos.y+15;
    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "植入物标识粘贴处");
    // lodop.ADD_PRINT_LINE(linePos.y,20,linePos.y,710,0,2);
    // cardLoc.y=linePos.y;

    // var materials=$("#surSupplyBox").datagrid("getRows");
    // if(materials && materials.length>0){
    //     var curCardLoc={x:10,y:linePos.y}
    //     for(var i=0;i<materials.length;i++){
    //         var material=materials[i];
    //         if(!material.BarCode || material.BarCode===splitchar.empty) continue;
    //         // 超过页面高度，则另起一页。
    //         if(cardLoc.y+cardHeight+2*cardMargin>pageBottom){
    //             lodop.NEWPAGE();
    //             startPos.y=60;
    //             linePos.y=startPos.y+15;
    //             lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "植入物标识粘贴处");
    //             lodop.ADD_PRINT_LINE(linePos.y,20,linePos.y,710,0,2);
    //             cardLoc.y=linePos.y;
    //         }
    //         curCardLoc.x=(cardLoc.x+cardCount*cardWidth+(cardCount+1)*cardMargin);
    //         curCardLoc.y=(cardLoc.y+cardMargin);

    //         lodop.ADD_PRINT_RECT(curCardLoc.y,curCardLoc.x,cardWidth,cardHeight,0,1);
    //         lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
    //         lodop.ADD_PRINT_TEXT(curCardLoc.y+2,curCardLoc.x+5,200,15,material.BarCode);
    //         lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
    //         lodop.ADD_PRINT_TEXT(curCardLoc.y+2,curCardLoc.x+140,200,15,"单位:"+material.UomDesc);
    //         lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
    //         lodop.ADD_PRINT_TEXT(curCardLoc.y+14,curCardLoc.x+5,220,15,"规格:"+material.StockItemSpec);
    //         lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
    //         lodop.ADD_PRINT_TEXT(curCardLoc.y+28,curCardLoc.x+5,220,15,material.StockItemDesc);
    //         lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
    //         lodop.ADD_PRINT_BARCODE(curCardLoc.y+42,curCardLoc.x+5,64,64,"QRCode",material.BarCode);
    //         lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
    //         lodop.ADD_PRINT_TEXT(curCardLoc.y+42,curCardLoc.x+59,200,15,"批    号:"+material.BatchNo);
    //         lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
    //         lodop.ADD_PRINT_TEXT(curCardLoc.y+56,curCardLoc.x+59,200,15,"失 效 期:"+material.ExpDate);
    //         lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
    //         lodop.ADD_PRINT_TEXT(curCardLoc.y+70,curCardLoc.x+59,200,15,"灭菌批号:"+material.SterilizationNo);
    //         lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
    //         lodop.ADD_PRINT_TEXT(curCardLoc.y+84,curCardLoc.x+59,200,15,"商   标:");
    //         lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
    //         lodop.ADD_PRINT_TEXT(curCardLoc.y+98,curCardLoc.x+5,"100%",15,"生产厂家:"+material.Manufacturer);
    //         lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
    //         lodop.ADD_PRINT_TEXT(curCardLoc.y+112,curCardLoc.x+5,"100%",15,"供 货 商:"+material.Vendor);
    //         lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
    //         cardCount++;
    //         if(cardCount%3===0){
    //             cardLoc.y=cardLoc.y+cardHeight+cardMargin;
    //             cardCount=0;
    //         }
    //     }

    //     var matCertImage=getMatCertImages();
    //     if (matCertImage.success && matCertImage.result && matCertImage.result!==""){
    //         var certImages=matCertImage.result.split("&&&");
    //         cardCount=0;
    //         for(var i=0;i<certImages.length;i++){
    //             var certImage=certImages[i];
    //             if (certImage===""){
    //                 continue;
    //             }
    //             if(cardLoc.y+cardHeight+2*cardMargin>pageBottom){
    //                 lodop.NEWPAGE();
    //                 startPos.y=60;
    //                 linePos.y=startPos.y+15;
    //                 lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "植入物标识粘贴处");
    //                 lodop.ADD_PRINT_LINE(linePos.y,20,linePos.y,710,0,2);
    //                 cardLoc.y=linePos.y;
    //             }
    //             curCardLoc.x=(cardLoc.x+cardCount*cardWidth+(cardCount+1)*cardMargin);
    //             curCardLoc.y=(cardLoc.y+cardMargin);

    //             var imgtag="<img src='data:image/png;base64,"+certImage+"' width='"+cardWidth+"' height='"+cardHeight+"'>";
    //             lodop.ADD_PRINT_IMAGE(curCardLoc.y,curCardLoc.x,"100%","100%",imgtag);
    //             cardCount++;
    //             if(cardCount%2===0){
    //                 cardLoc.y=cardLoc.y+cardHeight+cardMargin;
    //                 cardCount=0;
    //             }
    //         }
    //     }
    // }
}

function printBloodTransfusion() {
    lodop = getLodop();
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, PrintSetting.Common.Paper);
    if (lodop.SET_PRINTER_INDEX(PrintSetting.Common.Printer)) {
        createBloodTransPage(lodop);
        lodop.PREVIEW();
    }
}

function createBloodTransPage(lodop) {
    var dataRows = $("#bloodTransBox").datagrid("getRows");
    if (!dataRows || dataRows.length <= 0) {
        $.messager.alert("提示", "没有输血纪录。", "error");
        return;
    }
    var bloodTransfusions = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.BloodTransfusion,
        QueryName: "FindBloodTransfusion",
        Arg1: session.OPSID,
        ArgCnt: 1
    }, "json");
    if (!bloodTransfusions || bloodTransfusions.length <= 0) {
        $.messager.alert("提示", "未获取到输血申请纪录数据。", "error");
        return;
    }
    var bloodCmptList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.BloodTransfusion,
        QueryName: "FindBloodTransCmpt",
        Arg1: session.OPSID,
        ArgCnt: 1
    }, "json");
    if (!bloodCmptList || bloodCmptList.length <= 0) {
        $.messager.alert("提示", "未获取到输血成分数据。", "error");
        return;
    }
    var bloodTrans = bloodTransfusions[0];

    lodop.PRINT_INIT("BloodTransRecord" + session.OPSID);
    var startPos = { x: 10, y: 10 };
    var linePos = { x: startPos.x, y: startPos.y };
    var contentLineHeight = 30,
        titleLineHeight = 40,
        contentLineMargin = 15;
    lodop.SET_PRINT_STYLE("FontSize", 11);
    lodop.ADD_PRINT_TEXT(10, 300, "100%", 60, "山西省肿瘤医院临床输血申请单");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);
    // lodop.SET_PRINT_STYLEA(0,"ItemType",1);

    startPos.y += titleLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "费用类别：" + patInfo.AdmReason);

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "受血者姓名：" + patInfo.PatName);
    lodop.ADD_PRINT_TEXT(startPos.y, 300, 200, 15, "性别：" + patInfo.PatGender);
    lodop.ADD_PRINT_TEXT(startPos.y, 580, 200, 15, "年龄：" + patInfo.PatAge);

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "科室：" + patInfo.PatDeptDesc);
    lodop.ADD_PRINT_TEXT(startPos.y, 300, 200, 15, "住院号：" + patInfo.MedcareNo);
    lodop.ADD_PRINT_TEXT(startPos.y, 580, 200, 15, "床号：" + patInfo.PatBedCode);

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "病区：" + patInfo.PatWardDesc);
    lodop.ADD_PRINT_TEXT(startPos.y, 300, 200, 15, "血型：" + bloodTrans.ABO);
    lodop.ADD_PRINT_TEXT(startPos.y, 580, 200, 15, "Rh(D)：" + bloodTrans.RH);

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "输血史：" + bloodTrans.TransHistory);
    lodop.ADD_PRINT_TEXT(startPos.y, 300, 200, 15, "输血目的：" + bloodTrans.Purpose);

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, "100%", 15, "临床诊断：" + bloodTrans.Diagnosis);

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, "100%", 15, "输血成分及输血量：");
    for (var i = 0; i < bloodCmptList.length; i++) {
        var bloodCmpt = bloodCmptList[i];
        lodop.ADD_PRINT_TEXT(startPos.y, 160, "100%", 15, ("【" + bloodCmpt.Component + "】【" + bloodCmpt.Volume + bloodCmpt.Unit + "】"));
        if (i < bloodCmptList.length - 1) {
            startPos.y += contentLineHeight;
        }

    }

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "预定输血时间：" + bloodTrans.PlanTransDT);
    lodop.ADD_PRINT_TEXT(startPos.y, 300, 200, 15, "输血性质：" + bloodTrans.Nature);

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "输血前检查：");
    lodop.ADD_PRINT_TEXT(startPos.y, 120, 200, 15, "HGB");
    lodop.ADD_PRINT_LINE(linePos.y, 142, linePos.y, 180, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 150, 40, 15, bloodTrans.HGB);
    lodop.ADD_PRINT_TEXT(startPos.y, 180, 200, 15, "g/L");

    lodop.ADD_PRINT_TEXT(startPos.y, 240, 200, 15, "HCT");
    lodop.ADD_PRINT_LINE(linePos.y, 262, linePos.y, 300, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 270, 40, 15, bloodTrans.HCT);
    lodop.ADD_PRINT_TEXT(startPos.y, 300, 200, 15, "L/L");

    lodop.ADD_PRINT_TEXT(startPos.y, 360, 200, 15, "PLT");
    lodop.ADD_PRINT_LINE(linePos.y, 382, linePos.y, 420, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 390, 40, 15, bloodTrans.PLT);
    lodop.ADD_PRINT_TEXT(startPos.y, 420, 200, 15, "x10^9/L");

    lodop.ADD_PRINT_TEXT(startPos.y, 520, 200, 15, "ALT");
    lodop.ADD_PRINT_LINE(linePos.y, 542, linePos.y, 580, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 550, 40, 15, bloodTrans.ALT);
    lodop.ADD_PRINT_TEXT(startPos.y, 580, 200, 15, "u/L");

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 120, 200, 15, "HBsAg");
    lodop.ADD_PRINT_LINE(linePos.y, 160, linePos.y, 200, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 170, 40, 15, bloodTrans.HBsAg);

    lodop.ADD_PRINT_TEXT(startPos.y, 240, 200, 15, "Anti-HBS");
    lodop.ADD_PRINT_LINE(linePos.y, 300, linePos.y, 340, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 310, 40, 15, bloodTrans.HBsAb);

    lodop.ADD_PRINT_TEXT(startPos.y, 360, 200, 15, "HBeAg");
    lodop.ADD_PRINT_LINE(linePos.y, 400, linePos.y, 440, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 410, 40, 15, bloodTrans.HBeAg);

    lodop.ADD_PRINT_TEXT(startPos.y, 520, 200, 15, "Anti-HBe");
    lodop.ADD_PRINT_LINE(linePos.y, 580, linePos.y, 620, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 590, 40, 15, bloodTrans.HBeAb);

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 120, 200, 15, "Anti-HCV");
    lodop.ADD_PRINT_LINE(linePos.y, 180, linePos.y, 220, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 190, 40, 15, bloodTrans.HCVAb);

    lodop.ADD_PRINT_TEXT(startPos.y, 280, 200, 15, "Anti-HIV1/2");
    lodop.ADD_PRINT_LINE(linePos.y, 380, linePos.y, 420, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 390, 40, 15, bloodTrans.HIVAb);

    lodop.ADD_PRINT_TEXT(startPos.y, 520, 200, 15, "梅毒");
    lodop.ADD_PRINT_LINE(linePos.y, 550, linePos.y, 590, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 560, 40, 15, bloodTrans.Syphilis);

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 50, 200, 15, "标本采集者：");
    lodop.ADD_PRINT_TEXT(startPos.y, 300, 200, 15, "申请医师签字：");
    lodop.ADD_PRINT_TEXT(startPos.y, 550, 200, 15, "上级医师签字：");

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 50, 200, 15, "科主任签字：");
    lodop.ADD_PRINT_TEXT(startPos.y, 300, 200, 15, "医务科签字：");
    lodop.ADD_PRINT_TEXT(startPos.y, 550, 200, 15, "输血科签字：");

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 300, "100%", 60, "山西省肿瘤医院临床输血记录单");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);

    startPos.y += titleLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    var firstTransRecord = dataRows[0];
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "受血者血样血型复检结果");

    lodop.ADD_PRINT_TEXT(startPos.y, 220, 200, 15, "血型");
    lodop.ADD_PRINT_LINE(linePos.y, 250, linePos.y, 300, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 260, 40, 15, firstTransRecord.ABO);
    lodop.ADD_PRINT_TEXT(startPos.y, 300, 200, 15, "型");

    lodop.ADD_PRINT_TEXT(startPos.y, 360, 200, 15, "Rh(D)");
    lodop.ADD_PRINT_LINE(linePos.y, 400, linePos.y, 450, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 410, 40, 15, firstTransRecord.RH);

    lodop.ADD_PRINT_TEXT(startPos.y, 500, 200, 15, "复检者签名");
    lodop.ADD_PRINT_LINE(linePos.y, 580, linePos.y, 650, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 590, 40, 15, firstTransRecord.TestProvDesc);



    var dataHeader = "<thead><tr><th>储血编码</th><th>血液种类</th><th>血型</th><th>用量</th><th>交叉配血<br>盐水+凝聚胺+镜检</th><th>配血者</th>";
    dataHeader += "<th>发血者</th><th>配血时间</th><th>取血者</th><th>取血时间</th></tr></thead>";
    var tableStyle = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:14px;}";
    tableStyle += "th {font-size:16px;font-weight:bold;text-align:center} tr>td {text-align:center} tr {height:24px;} </style>";
    if (dataRows && dataRows.length > 0) {
        for (var i = 0; i < dataRows.length; i++) {
            startPos.y += contentLineHeight;
            linePos.y = startPos.y + contentLineMargin;
            var dataRow = dataRows[i];
            var html = tableStyle + "<table>" + dataHeader + "<tbody><tr>";
            html += "<td>" + dataRow.BarCode + "<br>" + dataRow.ComponentCode + " <strong>" + dataRow.BloodABO + " RhD(" + (dataRow.BloodRH === "阳性" ? "+" : "-") + ")</strong>" + "</td>";
            html += "<td>" + dataRow.BloodCategory + "</td>";
            html += "<td style='width:30px;'>" + dataRow.BloodType + "</td>";
            html += "<td>" + dataRow.Volume + dataRow.Unit + "</td>";
            html += "<td>" + dataRow.CrossMatching + "</td>";
            html += "<td>" + dataRow.MatchingProvDesc + "</td>";
            html += "<td>" + dataRow.GrantProvDesc + "</td>";
            html += "<td style='width:80px;'>" + dataRow.MatchingDT + "</td>";
            html += "<td>" + dataRow.FetchProvDesc + "</td>";
            html += "<td style='width:80px;'>" + dataRow.FetchDT + "</td><tr></tbody></table>";
            lodop.ADD_PRINT_TABLE(startPos.y, 10, "100%", "100%", html);
            startPos.y += 90;
            lodop.ADD_PRINT_TEXT(startPos.y, 10, 200, 15, "输血执行者:");
            lodop.ADD_PRINT_TEXT(startPos.y, 190, 200, 15, "核对者:");
            var transStartDTStr = "",
                transEndDTStr = "";
            if (dataRow.TransStartDT !== "") {
                var transStartDT = (new Date()).tryParse(dataRow.TransStartDT, "yyyy-MM-dd HH:mm:ss");
                transStartDTStr = transStartDT.format("yyyy-MM-dd HH:mm");
            }
            if (dataRow.TransEndDT !== "") {
                var transEndDT = (new Date()).tryParse(dataRow.TransEndDT, "yyyy-MM-dd HH:mm:ss");
                transEndDTStr = transEndDT.format("yyyy-MM-dd HH:mm");
            }
            lodop.ADD_PRINT_TEXT(startPos.y, 350, "100%", 15, "输血开始时间:" + transStartDTStr);
            lodop.ADD_PRINT_TEXT(startPos.y, 570, "100%", 15, "输血结束时间:" + transEndDTStr);
        }
    }
}

function printChargeRecord() {
    lodop = getLodop();
    lodop.PRINT_INIT("ChargeRecord" + session.OPSID);
    lodop.SET_PRINT_MODE("PRINT_DUPLEX", 2);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, PrintSetting.Common.Paper);
    if (lodop.SET_PRINTER_INDEX(PrintSetting.PrintPaper.Printer)) {
        createChargeRecordPage(lodop);
        lodop.PREVIEW();
    } else {
        createChargeRecordPage(lodop);
        lodop.PREVIEW();
    }
}

function createChargeRecordPage(lodop) {
    var dataRows = $("#chargeBox").datagrid("getRows");
    if (!dataRows || dataRows.length <= 0) {
        $.messager.alert("提示", "没有收费纪录。", "error");
        return;
    }


    var startPos = { x: 10, y: 10 };
    var linePos = { x: startPos.x, y: startPos.y };
    var contentLineHeight = 30,
        titleLineHeight = 40,
        contentLineMargin = 15;
    lodop.SET_PRINT_STYLE("FontSize", 11);
    lodop.ADD_PRINT_TEXT(10, 300, "100%", 60, "山西省肿瘤医院手术收费记录单");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);
    // lodop.SET_PRINT_STYLEA(0,"ItemType",1);

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "患者姓名：" + patInfo.PatName + "(" + patInfo.PatGender + "," + patInfo.PatAge + ")");
    lodop.ADD_PRINT_TEXT(startPos.y, 200, 200, 15, "科室：" + patInfo.PatDeptDesc);
    lodop.ADD_PRINT_TEXT(startPos.y, 360, 200, 15, "床号：" + patInfo.PatBedCode);
    lodop.ADD_PRINT_TEXT(startPos.y, 460, 200, 15, "住院号：" + patInfo.MedcareNo);
    lodop.ADD_PRINT_TEXT(startPos.y, 580, 200, 15, "手术日期：" + patInfo.OperDate);

    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "费用类别：" + patInfo.AdmReason);
    lodop.ADD_PRINT_TEXT(startPos.y, 260, 200, 15, "器械护士：" + patInfo.ScrubNurseDesc);
    lodop.ADD_PRINT_TEXT(startPos.y, 460, 200, 15, "巡回护士：" + patInfo.CircualNurseDesc);


    startPos.y += contentLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 120, 15, "手术名称：");
    lodop.ADD_PRINT_TEXT(startPos.y, 90, 370, 30, patInfo.OperationDesc);
    var surgeonDesc = patInfo.SurgeonDesc;
    if (patInfo.AssistantDesc && patInfo.AssistantDesc != "") {
        surgeonDesc += "," + patInfo.AssistantDesc;
    }
    lodop.ADD_PRINT_TEXT(startPos.y, 460, "100%", 15, "手术医生：" + surgeonDesc);


    startPos.y += contentLineHeight + 10;
    linePos.y = startPos.y + contentLineMargin;
    var htmlArr = [
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:14px;}",
        "th {font-size:16px;font-weight:bold;text-align:center} tr>td {text-align:center} tr {height:24px;} ",
        ".item {width:200px;} .count {width:40px;} table {table-layout:fixed;} .item-desc {width:200px;overflow:hidden;}</style>",
        "<table><thead><tr><th style='width:80px;'>收费码</th><th style='width:300px;'>收费项目</th><th style='width:40px;'>数量</th>",
        "<th style='width:40px;'>单位</th><th style='width:60px;'>单价</th><th style='width:100px;'>费用</th>",
        "<th style='width:60px;'>收费人</th></tr></thead><tbody>"
    ];
    // htmlArr.push("<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:14px;}");
    // htmlArr.push("th {font-size:16px;font-weight:bold;text-align:center} tr>td {text-align:center} tr {height:24px;} ");
    // htmlArr.push(".item {width:200px;} .count {width:40px;} table {table-layout:fixed;} .item-desc {width:200px;overflow:hidden;}</style>");
    // htmlArr.push("<table><thead><tr><th style='width:160px;'>收费项目</th><th style='width:60px;'>数量</th><th>单位</th><th>单价</th><th>费用</th><th>收费人</th>");
    // htmlArr.push("<th>收费时间</th></tr></thead><tbody>");
    if (dataRows && dataRows.length > 0) {
        var sum = 0;
        for (var i = 0; i < dataRows.length; i++) {
            var dataRow = dataRows[i];
            htmlArr.push("<tr>");
            htmlArr.push("<td>" + dataRow.ChargeItemCode + "</td>");
            htmlArr.push("<td>" + dataRow.ChargeItemDesc + "</td>");
            htmlArr.push("<td>" + dataRow.Qty + "</td>");
            htmlArr.push("<td>" + dataRow.UnitDesc + "</td>");
            htmlArr.push("<td>" + dataRow.Price + "</td>");
            var totalPrice = (Number(dataRow.Qty) * Number(dataRow.Price)).toFixed(3);
            sum += Number(totalPrice);
            htmlArr.push("<td>" + totalPrice + "</td>");
            htmlArr.push("<td>" + dataRow.ChargeUserDesc + "</td>");
            htmlArr.push("</tr>");
            if (i === dataRows.length - 1) {
                var sumStr = sum.toFixed(3);
                htmlArr.push("<tr><td></td><td></td><td></td><td>合计</td><td colspan='2'>" + sumStr + "</td><td></td></tr>");
            }
        }
        htmlArr.push("</tbody></table>");
        lodop.ADD_PRINT_TABLE(startPos.y, 20, 760, "100%", htmlArr.join(""));

        var tableHeight = (dataRows.length + 2) * 24;
        startPos.y += tableHeight;
        linePos.y = startPos.y + contentLineMargin;

        startPos.y += 10;

        lodop.ADD_PRINT_TEXT(startPos.y, 20, 280, 15, "入室时间：" + patInfo.AreaInDT);
        lodop.ADD_PRINT_TEXT(startPos.y, 300, 280, 15, "出室时间：" + patInfo.AreaOutDT);
        lodop.ADD_PRINT_TEXT(startPos.y, 560, 200, 15, "护士长签字：");

        startPos.y += 20;

        var materials = $("#chargeBox").datagrid("getRows");
        if (materials && materials.length > 0) {
            var pageBottom = 1100,
                cardWidth = 240,
                cardHeight = 130,
                cardMargin = 10,
                cardLoc = { x: 10, y: startPos.y },
                cardCount = 0;
            var curCardLoc = { x: 10, y: startPos.y }
            for (var i = 0; i < materials.length; i++) {
                var material = materials[i];
                if (!material.BarCode || material.BarCode === splitchar.empty) continue;
                // 超过页面高度，则另起一页。
                if (cardLoc.y + cardHeight + 2 * cardMargin > pageBottom) {
                    lodop.NEWPAGE();
                    startPos.y = 60;
                    linePos.y = startPos.y + 15;
                    // lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "植入物标识粘贴处");
                    // lodop.ADD_PRINT_LINE(linePos.y,20,linePos.y,710,0,2);
                    cardLoc.y = startPos.y;
                }
                curCardLoc.x = (cardLoc.x + cardCount * cardWidth + (cardCount + 1) * cardMargin);
                curCardLoc.y = (cardLoc.y + cardMargin);

                lodop.ADD_PRINT_RECT(curCardLoc.y, curCardLoc.x, cardWidth, cardHeight, 0, 1);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
                lodop.ADD_PRINT_TEXT(curCardLoc.y + 2, curCardLoc.x + 5, 200, 15, material.BarCode);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
                lodop.ADD_PRINT_TEXT(curCardLoc.y + 2, curCardLoc.x + 140, 200, 15, "单位:" + material.UnitDesc);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
                lodop.ADD_PRINT_TEXT(curCardLoc.y + 14, curCardLoc.x + 5, 220, 15, "规格:" + material.Spec);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
                lodop.ADD_PRINT_TEXT(curCardLoc.y + 28, curCardLoc.x + 5, 220, 15, material.ChargeItemDesc);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
                lodop.ADD_PRINT_BARCODE(curCardLoc.y + 42, curCardLoc.x + 5, 64, 64, "QRCode", material.BarCode);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
                lodop.ADD_PRINT_TEXT(curCardLoc.y + 42, curCardLoc.x + 59, 200, 15, "批    号:" + material.BatchNo);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
                lodop.ADD_PRINT_TEXT(curCardLoc.y + 56, curCardLoc.x + 59, 200, 15, "失 效 期:" + material.ExpireDate);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
                lodop.ADD_PRINT_TEXT(curCardLoc.y + 70, curCardLoc.x + 59, 200, 15, "灭菌批号:" + material.SterilizationNo);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
                lodop.ADD_PRINT_TEXT(curCardLoc.y + 84, curCardLoc.x + 59, 200, 15, "商   标:");
                lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
                lodop.ADD_PRINT_TEXT(curCardLoc.y + 98, curCardLoc.x + 5, "100%", 15, "生产厂家:" + material.Manufacturer);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
                lodop.ADD_PRINT_TEXT(curCardLoc.y + 112, curCardLoc.x + 5, "100%", 15, "供 货 商:" + material.Vendor);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 9);
                cardCount++;
                if (cardCount % 3 === 0) {
                    cardLoc.y = cardLoc.y + cardHeight + cardMargin;
                    cardCount = 0;
                }
            }
        }
    }
}