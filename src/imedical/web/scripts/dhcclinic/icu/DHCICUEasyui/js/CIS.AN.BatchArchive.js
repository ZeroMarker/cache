

function initPage() {
    initArchiveForm();
    initArchiveBox();
}

function initArchiveBox() {
    var columns = [
        [
            { field: "CheckStatus", title: "选择", checkbox: true },
            { field: "OPSID", title: "OPSID", width: 100, hidden: true },
            {
                field: "StatusDesc",
                title: "状态",
                width: 50,
                styler: function(value, row, index) {
                    return "background-color:" + row.StatusColor + ";";
                }
            },
            {
                field: "SourceTypeDesc",
                title: "类型",
                width: 50,
                styler: function(value, row, index) {
                    switch (row.SourceType) {
                        case "B":
                            return "background-color:" + SourceTypeColors.Book + ";";
                        case "E":
                            return "background-color:" + SourceTypeColors.Emergency + ";";
                        default:
                            return "background-color:white;";
                    }
                }
            },
            { field: "OperDate", title: "手术日期", width: 100 },
            { field: "RoomDesc", title: "手术间", width: 80 },
            { field: "OperSeq", title: "台次", width: 40 },
            { field: "PatName", title: "患者姓名", width: 80 },
            { field: "PatGender", title: "性别", width: 40 },
            { field: "PatAge", title: "年龄", width: 50 },
            { field: "PatDeptDesc", title: "科室", width: 120 },
            { field: "OperDesc", title: "手术名称", width: 160 },
            { field: "SurgeonDesc", title: "手术医生", width: 80 },
            { field: "AnesthesiologistDesc", title: "麻醉医生", width: 80, hidden:true },
            { field: "AnaMethodDesc", title: "麻醉方法", width: 100, hidden:true },
            { field: "CircualNurseDesc", title: "巡回护士", width: 80, hidden:true },
            { field: "ScrubNurseDesc", title: "器械护士", width: 80, hidden:true },
            { field: "IfAllArchived", title: "是否全部归档", width: 80, hidden:true },
            { field: "ArchiveMsg", title: "归档总结", width: 200,
                styler: function(value, row, index) {
                    if(row.IfAllArchived == "N"){
                        return "background-color:pink;";
                    }else{
                        return "background-color:white;";
                    }
                }
            }
        ]
    ];

    $("#archiveBox").datagrid({
        headerCls: "panel-header-gray",
        fit: true,
        title: "手术麻醉归档查询",
        toolbar: "#archiveTools",
        selectOnCheck: false,
        singleSelect: true,
        columns: columns,
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = "CIS.AN.BL.Archive";
            param.QueryName = "FindArchiveInfoList";
            param.Arg1 = $("#startDate").datebox("getValue");
            param.Arg2 = $("#endDate").datebox("getValue");
            param.Arg3 = session.DeptID;
            param.Arg4 = $("#operRoom").combobox("getValue");
            param.ArgCnt = 4;
        },
        onLoadSuccess: function(data) {
            
        },
        onClickRow: function(rowIndex, rowData){
            $("#batchArchiveBox").datagrid("reload");
            $("#btnBatchArchive").linkbutton("enable");
        }
    });

    $("#batchArchiveBox").datagrid({
        headerCls: "panel-header-gray",
        fit: true,
        title: "批量归档",
        toolbar: "#batchArchiveTools",
        columns: [
            [
                { field: "RecordSheetId", title: "RecordSheetId", width: 100, hidden: true },
                { field: "DataModuleId", title: "DataModuleId", width: 100, hidden: true },
                { field: "ArchiveCode", title: "归档代码", width: 150 },
                { field: "DataModuleCode", title: "归档表单代码", width: 150, hidden: true },
                { field: "DataModuleDesc", title: "归档表单", width: 150 },
                { field: "FilePath", title: "归档URL", width: 100, hidden: true},
                { 
                    field: "ArchiveStatus", 
                    title: "归档状态", 
                    width: 100,
                    formatter: function(value, row, index){
                        if (row.FilePath === "") {
                            return "未归档";
                        } else {
                            var url = "../service/dhcanop/lib/pdfjs/web/viewer.html?file=" + encodeURIComponent(row.FilePath);
                            return "<a target='_blank' href='" + url + "' style='color:#FF3399'>查看归档</a>";
                        }
                    }
                },
                { field: "FileDate", title: "归档日期", width: 100 },
                { field: "FileTime", title: "归档时间", width: 80 }
            ]
        ],
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            var archiveRow = $("#archiveBox").datagrid("getSelected");
            var opsId = archiveRow ? archiveRow.OPSID : "";
            param.ClassName = "CIS.AN.BL.Archive";
            param.QueryName = "FindArchiveRecordSheets";
            param.Arg1 = opsId;
            param.ArgCnt = 1;
        },
        onLoadSuccess: function(data) {
            
        }
    });
}

function initArchiveForm() {
	dhccl.parseDateFormat();
	dhccl.parseDateTimeFormat();
    var today = (new Date()).format("yyyy-MM-dd");
    $("#startDate,#endDate").datebox("setValue", today);

    $("#operRoom").combobox({
        valueField: "RowId",
        textField: "Description",
        data: dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindOperRoom",
            Arg1: session.DeptID,
            Arg2: "R",
            ArgCnt: 2
        }, "json")
    });

    $("#btnQuery").linkbutton({
        onClick: function() {
            $("#archiveBox").datagrid("reload");
            $("#batchArchiveBox").datagrid("reload");
        }
    });

    $("#btnBatchArchive").linkbutton({
        onClick: function() {
            var archiveRow = $("#archiveBox").datagrid("getSelected");
            if(archiveRow){
                var archiveData = $("#batchArchiveBox").datagrid("getRows");
                if(archiveData.length === 0){
                    $.messager.alert("提示", "无可归档的表单!", "error");
                    return;
                }
                $.messager.progress({text: '正在归档中...'});
                var resultArray = [];
                for(var i = 0; i < archiveData.length; i++){
                    var singleArchiveData = archiveData[i];
                    var result = saveArchive(archiveRow.OPSID, singleArchiveData.RecordSheetId, session.UserID, singleArchiveData.ArchiveCode, singleArchiveData.DataModuleDesc+".pdf");
                    var msgArray = result.split("^");
                    resultArray.push({
                        patName: archiveRow.PatName,
                        dataModuleDesc: singleArchiveData.DataModuleDesc,
                        resultStatus: msgArray[0],
                        resultMsg: msgArray[1]
                    });
                }
                $.messager.progress('close'); 
                //$("#archiveBox").datagrid("reload");
                $("#batchArchiveBox").datagrid("reload");
                showArchiveResultDlg(resultArray);
            }else{
                $.messager.alert("提示", "请选中一行手术信息!", "error");
            }
        }
    });

    $("#btnBatchArchive").linkbutton("disable");

    $("#btnOneKeyArchive").linkbutton({
        onClick: function() {
            var resultArray = [];
            var checkRows = $("#archiveBox").datagrid("getChecked");
            if (checkRows && checkRows.length > 0) {
                $.messager.progress({text: '正在归档中...'});
                for (var i = 0; i < checkRows.length; i++) {
                    var checkRow = checkRows[i];
                    var opsId = checkRow.OPSID;
                    var patName = checkRow.PatName;
                    var ret = saveBatchArchive(opsId, session.UserID);
                    var msgArray = ret.split("||");
                    for(var j = 0; j < msgArray.length; j++){
                        console.dir(msgArray[j]);
                        var singleMsgArray = msgArray[j].split("^");
                        resultArray.push({
                            patName: patName,
                            dataModuleDesc: singleMsgArray[2] ? singleMsgArray[2]: "无可归档的表单",
                            resultStatus: singleMsgArray[0],
                            resultMsg: singleMsgArray[1] ? singleMsgArray[1] : "未维护相关打印模板或无文件可归档"
                        });
                    }
                }
                $.messager.progress('close'); 
                $("#archiveBox").datagrid("reload");
                $("#batchArchiveBox").datagrid("reload");
                showArchiveResultDlg(resultArray);
            } else {
                $.messager.alert("提示", "请勾选需要归档的手术记录，再进行操作。", "warning");
            }
        }
    });

    function saveArchive(opsId, recordSheetId, userId, archiveCode, filename){
        try {
            var result = dhccl.runServerMethodNormal("CIS.AN.BL.Archive", "Archive", opsId, recordSheetId, userId, archiveCode, filename);
            return result;
        } catch (error) {
            return "E^" + error;
        }
    }

    function saveBatchArchive(opsId, userId){
        try {
            var result = dhccl.runServerMethodNormal("CIS.AN.BL.Archive", "BatchArchive", opsId, userId);
            return result;
        } catch (error) {
            return "E^" + error;
        }
    }

    function showArchiveResultDlg(resultData){
        $("#archiveResultBox").datagrid({
            headerCls: "panel-header-gray",
            fit: true,
            title: "归档结果",
            url: ANCSP.DataQuery,
            columns: [
                [
                    { field: "patName", title: "患者姓名", width: 100 },
                    { field: "dataModuleDesc", title: "归档表单", width: 150 },
                    { field: "resultStatus", title: "归档状态", width: 100, hidden:true},
                    { field: "resultMsg", title: "归档结果", width: 300,
                        styler: function(value, row, index) {
                            if(row.resultStatus == "E"){
                                return "background-color:red;";
                            }else{
                                return "background-color:green;";
                            }
                        }
                    }
                ]
            ],
            data: resultData
        });
        $("#archiveResultDlg").dialog({
            title: "归档结果"
        }).dialog("open");
    }
}

$(document).ready(initPage);