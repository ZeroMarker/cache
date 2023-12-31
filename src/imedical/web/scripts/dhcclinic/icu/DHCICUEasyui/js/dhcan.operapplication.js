var opsId = dhccl.getQueryString("opsId");
var isNewApplication = Number(opsId) > 0 ? false : true;
var patientNo, EpisodeID = dhccl.getQueryString("EpisodeID");

$(document).ready(function() {
    // 页面最大化
    changePageSize();
    // 初始化所有组件
    initComponents();
    // 加载数据
    loadDatas();

});

/// 更改页面显示大小
function changePageSize() {
    //self.moveTo(0, 0);
    //self.resizeTo(screen.availWidth, screen.availHeight);
}

/// 初始化组件
function initComponents() {
    initPatientsList();
    initOperationGrid();
    initPrevDiagnosGrid();
    initDataFormControls();
    initOperationDialog();
    initDataForm();
    initCheckBox();
    initOperDelegates();
}
///初始化患者查询列表
function initPatientsList() {
    $("#patientNo").next("span").find("input").prop("placeholder", "请输入姓名、登记号、病案号");
    $("#patLoc").next("span").find("input").prop("placeholder", "科室");
    $("#patWard").next("span").find("input").prop("placeholder", "病区");
    //科室
    $("#patLoc").combobox({
        valueField: 'RowId',
        textField: 'Description',
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationOld";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = "INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.ArgCnt = 2;
        }
    });
    $("#patLoc").combobox('setValue', session.DeptID);
    //病区
    $("#patWard").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindWard";
            param.ArgCnt = 0;
        }
    });
    //患者列表
    var patientsList = $HUI.datagrid("#patientsList", {
        fit: true,
        title: "患者列表 (<span id='patCount'>0人</span>)",
        singleSelect: true,
        nowrap: false,
        pagination: true,
        pageSize:20,
        headerCls:'panel-header-gray',
        url: ANCSP.DataQuery,
        toolbar: "#searchList",
        fitColumns:true,
        showHeader: true,
        // rowStyler:function(index,row){
        //     if(index%2===1)
        //     {  
        //         return "background-color:#FFFFCC";
        //     }
        // },
        queryParams: {
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindLocDocCurrentAdm",
            ArgCnt: 13
        },
        onBeforeLoad: function(param) {
            var patientNo = $('#patientNo').searchbox('textbox').val();
            var isNum = true;
            var reg = /^[0-9]+.?[0-9]*$/;
            if (!reg.test(patientNo)) { isNum = false; }
            param.Arg1 = $("#patLoc").combobox("getValue");
            param.Arg2 = session['UserID'];
            param.Arg3 = "";
            param.Arg4 = "";
            (isNum == false) ? param.Arg5 = "": param.Arg5 = patientNo;
            (!isNum && (patientNo.length > 10)) ? param.Arg6 = "": param.Arg6 = patientNo; //$("#patName").val();
            param.Arg7 = "";
            param.Arg8 = "";
            ($("#patLoc").combobox("getValue") == "") ? param.Arg9 = "": param.Arg9 = "on";
            param.Arg10 = "";
            param.Arg11 = "on";
            param.Arg12 = $("#patWard").combobox("getValue");
            param.Arg13 = "";
        },
        columns: [
            [{
                field: 'PAPMINO',
                title: '患者列表',
                width: 250,
                formatter: function(value, row, index) {
                    var retArray = [];
                    retArray.push("<div class='patlist-item'><span>" + row.PAPMIName + "</span>");
                    retArray.push("<span>" + value + "</span></div>");
                    retArray.push("<div class='patlist-item'><span>" + row.PAPMISex + "/" + row.Age + "</span>");
                    retArray.push("<span>" + row.PAAdmWard + "</span></div>");
                    return retArray.join("");
                }
            },
            { field: 'PatientID', title: 'PatientID', width: 55, hidden: true },
            { field: 'EpisodeID', title: 'EpisodeID', width: 80, hidden: true },
            { field: 'PAAdmBed', title: '床位', width: 60, hidden: true },
            { field: 'PAPMIName', title: '姓名', width: 80, hidden: true },
            { field: 'PAPMISex', title: '性别', width: 40, hidden: true },
            { field: 'Age', title: '年龄', width: 60, hidden: true },
            { field: 'PAAdmDepCodeDR', title: '科室', width: 110, hidden: true },
            { field: 'PAAdmWard', title: '病区', width: 130, hidden: true }

            ]
        ],
        onSelect: function(rowIndex, rowData) {
            EpisodeID = rowData.EpisodeID;
            if (EpisodeID && (EpisodeID != "")) {
                loadDatas();
            }
        },
        onLoadSuccess: function(data) {
            $("#searchList").find(".searchListTitle").find("span").html(data.total);
        }
    });

    $("#patientsList").datagrid("getPager").pagination({
        showRefresh: false,
        showPageList: false,
        displayMsg: ""
    });

    //登记号回车
    var m_patientNoLength = dhccl.getDatas(ANCSP.MethodService, {
        ClassName: CLCLS.BLL.Admission,
        MethodName: "GetPatientNoLength",
        ArgCnt: 0
    });
    $("#patientNo").parent().find(".searchbox-text").keydown(function(e) {
        if (e.keyCode == 13) {
            patientNo = $(this).val();
            if (patientNo.length < m_patientNoLength) {
                for (var i = (m_patientNoLength - patientNo.length - 1); i >= 0; i--) {
                    patientNo = "0" + patientNo
                }
                $(this).val(patientNo);
            }
            patientsList.load();

        }
    })
}

/// 初始化手术列表组件
function initOperationGrid() {
    $("#operationBox").datagrid({
        width: 895,
        height: 130,
        singleSelect: true,
        rownumbers: true,
        toolbar: "#operationTool",
        title: "",
        url: ANCSP.DataQuery,
        columns: [
            [
                { field: "AnaOperID", title: "手术名称", width: 240, hidden: true },
                { field: "OperationDesc", title: "手术名称", width: 310 },
                { field: "OperClassDesc", title: "手术分级", width: 60, hidden: true },
                { field: "BladeTypeDesc", title: "切口类型", width: 60, hidden: true },
                { field: "BodySiteDesc", title: "手术部位", width: 60, hidden: true },
                { field: "OperPosDesc", title: "手术体位", width: 60, hidden: true },
                { field: "SurgeonDesc", title: "手术医生", width: 80 },
                { field: "AssistantDesc", title: "手术助手", width: 160 },
                { field: "SurgeonAss1", title: "一助", width: 160, hidden: true },
                { field: "SurgeonAss2", title: "二助", width: 160, hidden: true },
                { field: "SurgeonAss3", title: "三助", width: 160, hidden: true },
                { field: "SurgeonAss4", title: "四助", width: 160, hidden: true },
                { field: "SurgeonAss5", title: "五助", width: 160, hidden: true },
                { field: "SurgeonAss6", title: "六助", width: 160, hidden: true },
                { field: "Note", title: "手术说明", width: 120, hidden: true },
                { field: "OperNote", title: "名称备注", width: 240 }
            ]
        ],
        headerCls: 'panel-header-gray'
    });
}

/// 初始化术前诊断列表组件
function initPrevDiagnosGrid() {
    var preopDiagList = dhccl.getDatas(dhccl.csp.dataQuery, {
        ClassName: dhccl.bll.admission,
        QueryName: "FindMRCDiagnosis",
        Arg1: "QueryFilter",
        ArgCnt: 1
    }, "json")
    $("#preopDiagBox").datagrid({
        width: 895,
        height: 130,
        singleSelect: true,
        rownumbers: false,
        columns: [
            [{
                    field: "index",
                    title: "序号",
                    width: 50,
                    align: 'center',
                    formatter: function(val, row, index) {
                        var options = $("#preopDiagBox").datagrid('options');
                        var currentPage = options.pageNumber;
                        var pageSize = options.pageSize;
                        return (pageSize * (currentPage - 1)) + (index + 1);
                    }
                },
                { field: "DiagID", title: "ID", width: 80, hidden: true },
                {
                    field: "DiagDesc",
                    title: "诊断名称",
                    width: 500,
                    align: 'center',
                    editor: {
                        type: "combobox",
                        options: {
                            url: dhccl.csp.dataQuery,
                            onBeforeLoad: function(param) {
                                param.ClassName = dhccl.bll.admission;
                                param.QueryName = "FindMRCDiagnosis";
                                param.Arg1 = "QueryFilter";
                                param.ArgCnt = 1;
                            },
                            valueField: "RowId",
                            textField: "ICDDesc",
                            mode: "remote"
                        }
                    }
                },
                {
                    field: "Operate",
                    title: "操作",
                    width: 106,
                    align: 'center',
                    formatter: function(value, row, index) {
                        if (row.editing) {
                            var s = '<a href="#" onclick="saverow(this)"><img src="../service/dhcanop/css/images/save.png"></a> ';
                            var c = '<a href="#" onclick="cancelrow(this)"><img src="../service/dhcanop/css/images/cancel.png"></a>';
                            var html = s + '&nbsp;' + c;
                            return html;
                        } else {
                            var e = '<a href="#" onclick="editrow(this)"><img src="../service/dhcanop/css/images/pencil.png"></a> ';
                            var d = '<a href="#" onclick="deleterow(this)"><img src="../service/dhcanop/css/images/edit_remove.png"></a>';
                            var html = e + '&nbsp;' + d;
                            if ((row.DiagID == "") && (row.DiagDesc == "")) {
                                var i = '<a href="#" onclick="insertrow(this)"><img src="../service/dhcanop/css/images/edit_add.png"></a>';
                                html = html + '&nbsp;&nbsp;' + i;
                            }
                            return html;
                        }
                    }
                }
            ]
        ],
        headerCls: 'panel-header-gray',
        onBeforeEdit: function(index, row) {
            $(this).datagrid('updateRow', { index: index, row: { editing: true } })
        },
        onAfterEdit: function(index, row) {
            $(this).datagrid('updateRow', {
                index: index,
                row: {
                    DiagID: row.DiagDesc.RowId,
                    DiagDesc: row.DiagDesc.ICDDesc,
                    editing: false
                }
            })
        },
        onCancelEdit: function(index, row) {
            $(this).datagrid('updateRow', { index: index, row: { editing: false } })
        }
    });
}

function getRowIndex(target) {
    var tr = $(target).closest('tr.datagrid-row');
    return parseInt(tr.attr('datagrid-row-index'));
}

function editrow(target) {
    $('#preopDiagBox').datagrid('beginEdit', getRowIndex(target));
}

function deleterow(target) {
    $.messager.confirm('确认', '确认删除?', function(r) {
        if (r) {
            $('#preopDiagBox').datagrid('deleteRow', getRowIndex(target));
        }
    });
}

function saverow(target) {
    $('#preopDiagBox').datagrid('endEdit', getRowIndex(target));
    setPrevDiagnos();
}

function cancelrow(target) {
    $('#preopDiagBox').datagrid('cancelEdit', getRowIndex(target));
}

function insertrow(target) {
    var i = $('#preopDiagBox').datagrid("getRows").length;
    $("#preopDiagBox").datagrid('appendRow', {
        index: i,
        DiagID: "",
        DiagDesc: ""
    });
    $('#preopDiagBox').datagrid('beginEdit', i);
}

/// 初始化表单的控件
function initDataFormControls() {

    $("#OperDeptID").combobox({
        // url: dhcclinic.QueryService,
        // queryParams: {
        //     ClassName: dhcclinic.AdmissionServiceClass,
        //     QueryName: "FindLocation",
        //     Arg1: "",
        //     Arg2: "OP^EMOP^OUTOP",
        //     ArgCnt: 2
        // },
        valueField: "RowId",
        textField: "Description",
        required: true,
        onLoadSuccess: function() {
            if (isNewApplication) {
                // setDefaultOperDept(session.DeptID, session.Dept);
            }
        },
        onShowPanel: function() {
            var deptDatas = $(this).combobox("getData");
            if (!deptDatas || deptDatas.length <= 0) {
                deptDatas = getOperDepts();
                $(this).combobox("loadData", deptDatas);
            }
        }
    });

    $("#AppDeptID,#SurgeonDeptID").combobox({
        // url: dhcclinic.QueryService,
        // queryParams: {
        //     ClassName: "DHCClinic.Admission",
        //     QueryName: "FindLocation",
        //     Arg1: "QueryFilter",
        //     Arg2: "INOPDEPT^OUTOPDEPT^EMOPDEPT",
        //     ArgCnt: 2
        // },
        valueField: "RowId",
        textField: "Description",
        // mode: "remote"
        filter: function(q, row) {
            var upperQuery = q.toUpperCase();
            return row.Description.indexOf(upperQuery) >= 0;
        }
    });

    $("#SourceType").combobox({
        valueField: "code",
        textField: "desc",
        data: [{
            code: "B",
            desc: "择期"
        }, {
            code: "E",
            desc: "急诊"
        }],
        onChange: function(newValue, oldValue) {
            if (isNewApplication) {
                setDefaultOperDate();
                JudgeAppDeadline();
            }
        }
    });

    // $("#SourceType").combobox('onChange', function(newValue, oldValue) {
    //     if (isNewApplication) {
    //         setDefaultOperDate();
    //         JudgeAppDeadline();
    //     }
    // });

    $("#IsAnaest").combobox({
        valueField: "code",
        textField: "desc",
        data: [{
            code: "Y",
            desc: "是"
        }, {
            code: "N",
            desc: "否"
        }],
        onChange: function(newValue, oldValue) {
            if (newValue === "Y") {
                $("#PrevAnaMethod").combobox({
                    required: true
                });
            } else {
                $("#PrevAnaMethod").combobox({
                    required: false
                });
            }
        }
    });

    $("#PrevAnaMethod").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindAnaestMethod";
            param.Arg1 = "";
            param.ArgCnt = 1;
        },
        valueField: "RowId",
        textField: "Description",
        required: $("#IsAnaest").combobox("getValue") === "Y" ? true : false,
        // onShowPanel: function() {
        //     var datas = $(this).combobox("getData");
        //     if (!datas || datas.length <= 0) {
        //         datas = getAnaestMethods();
        //         $(this).combobox("loadData", datas);
        //     }
        // },
        multiple: true
    });

    $("#diagnosis").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindMRCDiagnosis";
            param.Arg1 = "QueryFilter";
            param.ArgCnt = 1;
        },
        valueField: "RowId",
        textField: "ICDDesc",
        mode: "remote"
    });

    $("#Surgeon,.SurgeonAss").combobox({
        valueField: "RowId",
        textField: "Description",
        onShowPanel: function() {
            var datas = $(this).combobox("getData"),
                opts = $("#Surgeon,.SurgeonAss").combobox("options"),
                surgeonDeptID = $("#SurgeonDeptID").combobox("getValue");
            if (!datas || datas.length <= 0) {
                datas = getSurgeonCareProvs(surgeonDeptID);
                $(this).combobox("loadData", datas);
            } else {
                if (opts.surgeonDeptID != surgeonDeptID) {
                    opts.surgeonDeptID = surgeonDeptID;
                    datas = getSurgeonCareProvs(surgeonDeptID);
                    $(this).combobox("loadData", datas);
                }
            }
        }
    });

    $(".SurgeonAss").combobox({
        onSelect: function(newValue, oldValue) {
            var assistantIdArray = new Array(),
                assistantArray = new Array();
            $(".SurgeonAss").each(function() {
                var assistantId = $(this).combobox("getValue"),
                    assistant = $(this).combobox("getText");
                if (assistantId != "") {
                    assistantIdArray.push(assistantId);
                    assistantArray.push(assistant);
                }
            });
            $("#Assistant").val(assistantIdArray.join(","));
            $("#AssistantDesc").val(assistantArray.join(","));
        }
    });

    $("#Operation").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.Operation;
            param.QueryName = "FindOperation";
            param.Arg1 = "QueryFilter";
            param.Arg2 = $("#Surgeon").combobox("getValue");
            param.Arg3 = $("#SurgeonDeptID").combobox("getValue");
            param.ArgCnt = 3;
        },
        valueField: "RowId",
        textField: "ICDDesc",
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
            if (record.OperPos) {
                $("#OperPos").combobox("setValue", record.OperPos);
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

    $("#OperPos").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperPosition";
            param.ArgCnt = 0;
        },
        valueField: "RowId",
        textField: "Description"
    });

    $(".operinfo").combobox({
        onSelect: function(newValue, oldValue) {
            var selector = "#" + $(this).attr("id") + "Desc",
                //text=this.options[this.options.selectedIndex].text;
                text = $(this).combobox("getText");
            //console.log($(this).combobox("options",this.selectedIndex));
            //console.log(selector+"^"+text);
            $(selector).val(text);
            if ($(this).attr("id") == "SurgeonDeptID") {
                //$("#Surgeon,.SurgeonAss").combobox("reload");
                loadSurgeonCareProvs();
            }
        }
    });



    // $("#OperDate").datebox("readonly");
}

/// 初始化手术对话框
function initOperationDialog() {
    $("#operDialog").dialog({
        width: 700,
        height: 540,
        buttons: [{
            text: "保存",
            iconCls: "icon-save",
            handler: function() {
                if ($("#operationForm").form("validate")) {
                    var operationData = $("#operationForm").serializeJson(),
                        operBox = $("#operationBox");
                    if ($("#EditOperation").val() == "Y") {
                        var selectRow = operBox.datagrid("getSelected"),
                            selectIndex = operBox.datagrid("getRowIndex");
                        operBox.datagrid("updateRow", {
                            index: selectIndex,
                            row: operationData
                        });

                    } else {
                        operBox.datagrid("appendRow", operationData);
                    }

                    $("#operDialog").dialog("close");
                }
            }
        }, {
            text: "取消",
            iconCls: "icon-cancel",
            handler: function() {
                $("#operDialog").dialog("close");
            }
        }],
        onClose: function() {
            $("#operationForm").form("clear");
        }
    });
}

/// 初始化选择框
function initCheckBox() {
    $(":checkbox").click(function() {
        var checked = $(this).prop("checked");
        if (checked) {
            $(this).val("Y");
        } else {
            $(this).val("N");
        }
    });
}

/// 初始化手术申请表单
function initDataForm() {
    $("#dataForm").form({
        url: dhccl.bll.dataService,
        onSubmit: function() {
            var isValid = $(this).form("validate");
            return isValid;
        },
        success: function(data) {
            dhccl.showMessage(data, "保存", null, null, function() {
                $("#dataForm").form("clear");
            });
        }
    });
}

/// 初始化操作事件
function initOperDelegates() {
    $("#btnAddDiag").linkbutton({
        onClick: addPrevDiagnos
    });

    $("#btnDelDiag").linkbutton({
        onClick: removePrevDiagnos
    });

    $("#btnAddOperation").linkbutton({
        onClick: addAnaestOperation
    });

    $("#btnEditOperation").linkbutton({
        onClick: editAnaestOperation
    });

    $("#btnDelOperation").linkbutton({
        onClick: removeAnaestOperation
    });

    $("#btnSave").linkbutton({
        onClick: saveOperApplication
    });

    $("#btnCancel").linkbutton({
        onClick: closeWindow
    });

    // $("#btnPrint").linkbutton({
    //     onClick: printApplication
    // });

    $("#btnSearch").linkbutton({
        onClick: findPatinetList
    })
}

/// 加载数据
function loadDatas() {
    loadDataForm(getPatInfo());
    loadAppDepts();
    if (isNewApplication) {
        //loadNewAppDatas();
        loadFormDefaultValue();
    } else {
        $("body").layout("remove", "west");
        $("#appFormPanel").panel({
            noheader: true,
            border: false
        });
        loadExistAppDatas();
    }
}

function loadAppDepts() {
    var appDepts = getAppDepts();
    if (appDepts && appDepts.length > 0) {
        $("#AppDeptID,#SurgeonDeptID").combobox("loadData", appDepts);
    }
}

/// 新增手术时，加载默认数据
function loadNewAppDatas() {
    $("#AppDeptID,#SurgeonDeptID").combobox("setValue", session.DeptID);
    setBookedOperDate();
    JudgeAppDeadline();
    setDefaultPrevDiagnosis();

}

/// 修改手术时，加载默认数据
function loadExistAppDatas() {
    var operAppData = getOperAppInfo();
    loadDataForm(operAppData);
    loadCheckBoxValue(operAppData);
    loadPrevDiagnos(operAppData.PrevDiagnosis, operAppData.PrevDiagnosisDesc);
    loadAnaestOperations();
    loadPrevAnaestMethod(operAppData);
}

/// 加载手术申请表单数据
function loadDataForm(data) {
    if (data) {
        $("#dataForm").form("load", data);
        $("#OperDeptID").combobox("setText", data.OperDeptDesc);
        // $("#PrevAnaMethod").combobox("setText", data.PrevAnaMethodDesc);
    }
}

/// 修改手术时，加载术前诊断
function loadPrevDiagnos(prevDiagnosId, prevDiagnosDesc) {
    if (prevDiagnosId && prevDiagnosId != "" && prevDiagnosDesc && prevDiagnosDesc != "") {
        var diagnosIdArray = prevDiagnosId.split(splitchar.comma),
            diagnosDescArray = prevDiagnosDesc.split(splitchar.comma),
            diagnosArray = new Array();
        if (diagnosIdArray.length == diagnosDescArray.length) {
            for (var i = 0; i < diagnosIdArray.length; i++) {
                diagnosArray.push({
                    DiagID: diagnosIdArray[i],
                    DiagDesc: diagnosDescArray[i]
                });
            }
            $("#preopDiagBox").datagrid("loadData", diagnosArray);
            setPrevDiagnos();
        }
    }
}

/// 修改手术时加载选择框的值
function loadCheckBoxValue(operAppData) {
    $(":checkbox").each(function() {
        var name = $(this).attr("name"),
            value = operAppData[name];
        $(this).val(value);
        if (value == "Y") {
            $(this).prop("checked", true);
        } else {
            $(this).prop("checked", false);
        }
    });
}

/// 修改手术申请时，加载手术列表的数据
function loadAnaestOperations() {
    $("#operationBox").datagrid("reload", {
        ClassName: ANCLS.BLL.OperationList,
        QueryName: "FindOperationList",
        Arg1: opsId,
        ArgCnt: 1
    });
}

function loadPrevAnaestMethod(appData) {
    if (appData && appData.PrevAnaMethod) {
        var methodArray = appData.PrevAnaMethod.split(splitchar.comma);
        $("#PrevAnaMethod").combobox("setValues", methodArray);
        $("#PrevAnaMethod").combobox("setText", appData.PrevAnaMethodDesc);
    }
}

/// 加载表单控件的默认值
function loadFormDefaultValue() {
    // 默认申请科室
    setDefaultAppDept();

    // 默认手术室
    //setDefaultOperDept();

    // 默认手术日期
    setDefaultOperDate();

    // 默认术前诊断
    setDefaultPrevDiagnos();

    // 隐藏元素的默认值
    setHiddenElementDefaultValue();

    // 默认检验信息
    setTestData();

    // 判断手术申请截止时间
    JudgeAppDeadline();
}

// 设置默认的手术申请科室
function setDefaultAppDept() {
    $("#AppDeptID").combobox("setValue", session.DeptID);
}

/// 设置默认的手术室
function setDefaultOperDept() {
    var appDeptID = $("#AppDeptID").combobox("getValue");
    //$.ajaxSettings.async = false;
    $.post(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.OperApplication,
        MethodName: "GetDefaultOperDept",
        Arg1: appDeptID,
        ArgCnt: 1
    }, function(data) {
        var defautDeptStr = $.trim(data),
            deptArray = defautDeptStr.split("^");
        $("#OperDeptID").combobox("setValue", deptArray[0]);
        $("#OperDeptID").combobox("setText", deptArray[1]);
    });
    //$.ajaxSettings.async = true;
}

/// 设置默认的手术日期
function setDefaultOperDate() {
    var currentDate = new Date(),
        sourceType = $("#SourceType").combobox("getValue"),
        today = currentDate.getFullYear() + "-" + (currentDate.getMonth() + 1) + "-" + currentDate.getDate();
    if (!sourceType || sourceType == "") {
        sourceType = "B";
    }
    if (sourceType != "B") {
        $("#OperDate").datebox("setValue", today);
    } else {
        //$.ajaxSettings.async = false;
        $.post(ANCSP.MethodService, {
            ClassName: ANCLS.BLL.OperApplication,
            MethodName: "GetNextWorkDay",
            Arg1: today,
            ArgCnt: 1
        }, function(data) {
            $("#OperDate").datebox("setValue", data);
        });
        // $.ajaxSettings.async = true;
    }

}

/// 设置默认的术前诊断
function setDefaultPrevDiagnos() {
    $('#preopDiagBox').datagrid('loadData', { total: 0, rows: [] });
    //$.ajaxSettings.async = false;
    $.post(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindAdmDiagnosis",
        Arg1: EpisodeID,
        Arg2: "C008",
        ArgCnt: 2
    }, function(data) {
        for (var i = 0; i < data.length; i++) {
            $("#preopDiagBox").datagrid("appendRow", {
                DiagID: data[i].ICDCode,
                DiagDesc: data[i].ICDCodeDesc
            });
            setPrevDiagnos();
        }
        $("#preopDiagBox").datagrid("appendRow", {
            DiagID: "",
            DiagDesc: ""
        });
    }, "json");
    //$.ajaxSettings.async = true;
}

/// 设置手术表单元素默认值
function setOperFormDefaultValue() {
    var appDeptID = $("#AppDeptID").combobox("getValue"),
        operList = $("#operationBox").datagrid("getRows"),
        surgeonDeptID = "";
    if (operList && operList.length > 0) {
        var lastOper = operList[operList.length - 1];
        surgeonDeptID = lastOper.SurgeonDeptID;
    } else if (appDeptID && (Number(appDeptID)) > 0) {
        surgeonDeptID = appDeptID;
    } else {
        surgeonDeptID = session.DeptID;
    }
    $("#SurgeonDeptID").combobox("setValue", surgeonDeptID);
    $("#EditOperation").val("N");
}

/// 设置隐藏元素的默认值
function setHiddenElementDefaultValue() {
    $("#AppUserID").val(session.UserID);
}

/// 设置最新检验数据
function setTestData() {
    //$.ajaxSettings.async = false;
    $.post(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Test,
        QueryName: "FindLastestTestResult",
        Arg1: EpisodeID,
        ArgCnt: 1
    }, function(data) {
        if (data && data.length > 0) {
            $.each(data, function(index, dataItem) {
                var selector = "#" + dataItem.DataField;
                if ($(selector).hasClass("easyui-combobox")) {
                    $(selector).combobox("setValue", dataItem.Result);
                } else if ($(selector).hasClass("easyui-textbox")) {
                    $(selector).textbox("setValue", dataItem.Result);
                } else if ($(selector).hasClass("easyui-numberspinner")) {
                    $(selector).numberspinner("setValue", dataItem.Result);
                } else {
                    $(selector).val(dataItem.Result);
                }
            });
        }
    }, "json");
    //$.ajaxSettings.async = true;
}

/// 添加一条诊断到术前诊断列表
function addPrevDiagnos() {
    var diagID = $("#diagnosis").combobox("getValue"),
        diagDesc = $("#diagnosis").combobox("getText");
    if (diagDesc && diagDesc != "") {
        $("#preopDiagBox").datagrid("appendRow", {
            DiagID: diagID,
            DiagDesc: diagDesc
        });
        $("#diagnosis").combobox("clear");
        setPrevDiagnos();
    }
}

/// 在术前诊断列表中，删除一条诊断
function removePrevDiagnos() {
    var preopDiagBox = $("#preopDiagBox");
    if (dhccl.hasRowSelected(preopDiagBox, true)) {
        var selectedRow = preopDiagBox.datagrid("getSelected"),
            selectedIndex = preopDiagBox.datagrid("getRowIndex", selectedRow);
        preopDiagBox.datagrid("deleteRow", selectedIndex);
        setPrevDiagnos();
    }
}

/// 添加一条手术到手术列表
function addAnaestOperation() {
    $("#operDialog").dialog({
        title: "新增手术",
        iconCls: "icon-add"
    });
    $("#operDialog").dialog("open");
    setOperFormDefaultValue();
}

/// 编辑手术列表中选中的手术
function editAnaestOperation() {
    var operBox = $("#operationBox");
    if (dhccl.hasRowSelected(operBox, true)) {
        $("#operDialog").dialog({
            title: "修改手术",
            iconCls: "icon-edit"
        });
        var selectRow = operBox.datagrid("getSelected");
        //console.log(selectRow);
        $("#operationForm").form("load", selectRow);
        $("#Operation").combobox("setText", selectRow.OperationDesc);
        $("#operDialog").dialog("open");
        $("#EditOperation").val("Y");
    }

}

/// 删除选中的手术
function removeAnaestOperation() {
    var operBox = $("#operationBox");
    if (dhccl.hasRowSelected(operBox, true)) {
        var selectRow = operBox.datagrid("getSelected"),
            rowIndex = operBox.datagrid("getRowIndex", selectRow);
        $.messager.confirm("提示", "是否删除该手术？", function(result) {
            if (result) {
                if (!(Number(selectRow.AnaOperID) > 0)) {
                    operBox.datagrid("deleteRow", rowIndex);
                } else {
                    var data = removeData("DHCAN.OperationList", selectRow.AnaOperID);
                    dhccl.showMessage(data, "删除", null, null,
                        function() {
                            operBox.datagrid("deleteRow", rowIndex);
                        });
                }
            }
        });
    }
}

/// 判断是否可以保存手术申请
function canSaveOperApplication() {
    var result = true,
        appData = $("#dataForm").serializeJson(),
        operList = $("#operationBox").datagrid("getRows"),
        appDeadline = JudgeAppDeadline();
    if (isNewApplication && appDeadline) {
        $.messager.alert("提示", $("#SourceTypeValidText").text(), "warning");
        result = false;
    }
    if (!appData.PrevDiagnosis || appData.PrevDiagnosis == "") {
        $.messager.alert("提示", "未选择术前诊断，请先选择再保存！", "warning");
        result = false;
    }
    if (!operList || operList.length < 1) {
        $.messager.alert("提示", "未选择拟施手术，请先选择再保存！", "warning");
        result = false;
    }
    return result;
}

/// 保存手术申请
function saveOperApplication() {
    if ($("#dataForm").form("validate") && canSaveOperApplication()) {
        var appData = generateAppData(),
            anesthesia = {
                ClassName: "User.ORAnaesthesia",
                RowId: appData.ExtAnaestID,
                ParentRowId: appData.EpisodeID,
                ANAPAADMParRef: appData.EpisodeID
            },
            operList = generateAnaestOperations(appData),
            jsonData = dhccl.formatObjects(appData) + splitchar.two + dhccl.formatObjects(anesthesia) + splitchar.two + dhccl.formatObjects(operList);
        var data = dhccl.saveDatas(ANCSP.DataListService, {
            jsonData: jsonData,
            MethodName: "SaveOperApplication",
            ClassName: dhcan.bll.operApplication
        });
        dhccl.showMessage(data, "保存", null, null, function() {
            window.location.reload();
        });


    }
}

/// 生成手术申请数据
function generateAppData() {
    var appData = $("#dataForm").serializeJson();
    if (!appData.Status || appData.Status == "") {
        appData.StatusCode = "Application";
    }
    appData.ClassName = ANCLS.Model.OperSchedule;

    var anaMethodArray = $("#PrevAnaMethod").combobox("getValues");
    if (anaMethodArray && anaMethodArray.length > 0) {
        appData.PrevAnaMethod = anaMethodArray.join(splitchar.comma);
    }
    return appData;
}

/// 生成手术列表数据
function generateAnaestOperations(appData) {
    var operList = $("#operationBox").datagrid("getRows");
    $.each(operList, function(index, operInfo) {
        operInfo.ClassName = ANCLS.Model.OperList;
        operInfo.OperSchedule = appData.RowId;
        operInfo.RowId = operInfo.AnaOperID;
        operInfo.PlanOperation = operInfo.Operation;
        operInfo.PlanOperClass = operInfo.OperClass;
        operInfo.PlanBladeType = operInfo.BladeType;
        operInfo.PlanBodySite = operInfo.BodySite;
        operInfo.PlanOperPos = operInfo.OperPos;
        operInfo.PlanOperNote = operInfo.OperNote;
    });
    return operList;
}

// 打印手术申请单
function printOperApplication() {

}

/// 根据术前诊断列表信息，设置术前诊断，多个术前诊断以“,”拼接
function setPrevDiagnos() {
    var rows = $("#preopDiagBox").datagrid("getRows"),
        result = "";
    if (rows && rows.length > 0) {
        $.each(rows, function(index, row) {
            if (result != "") {
                result += splitchar.five;
            }
            var diagID = row.DiagID ? row.DiagID : "";
            result += diagID + splitchar.four + row.DiagDesc;
        });
        $("#PrevDiagnosis").val(result);
    }
}

// 获取病人信息
function getPatInfo() {
    var datas = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindPatient",
            Arg1: EpisodeID,
            ArgCnt: 1
        }, "json"),
        result = null;
    if (datas && datas.length > 0) {
        result = datas[0];
    }
    if (result) {
        result.PatBaseInfo = ""; // 病人基本信息：病人姓名+病人性别+病人年龄
        result.PatWardBed = ""; // 病人病区床位：病人病区+病人床位
        if (result.PatName && result.PatGender && result.PatAge) {
            result.PatBaseInfo = result.PatName + "  " + result.PatGender + "  " + result.PatAge;
        }
        if (result.PatWard && result.PatBed) {
            result.PatWardBed = result.PatWard + "  " + result.PatBed;
        }
    }
    return result;
}

// 获取手术申请信息
function getOperAppInfo() {
    var datas = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.OperSchedule,
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

// 判断择期手术申请的截止时间
function JudgeAppDeadline() {
    var result = false;
    // 非择期手术，不判断截止时间
    if ($("#SourceType").combobox("getValue") != "B") {
        $("#SourceTypeValidText").text("");
        return result;
    }
    $.ajaxSettings.async = false;
    $.post(ANCSP.MethodService, {
        ClassName: dhcan.bll.operApplication,
        MethodName: "JudgeAppDeadline",
        ArgCnt: 0
    }, function(data) {
        var dataArray = $.trim(data).split("^");
        if (dataArray[0] == "Y") {
            $("#SourceTypeValidText").text("择期手术申请截止时间为：" + dataArray[1]);
            result = true;
        }
    });
    $.ajaxSettings.async = true;
    return result;
}

// 获取手术申请科室
function getAppDepts() {
    var result = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindLocationOld",
        Arg1: "",
        Arg2: "INOPDEPT^OUTOPDEPT^EMOPDEPT",
        ArgCnt: 2
    }, "json");
    return result;
}

// 获取手术室
function getOperDepts() {
    var result = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindLocationOld",
        Arg1: "",
        Arg2: "OP^EMOP^OUTOP",
        ArgCnt: 2
    }, "json");
    return result;
}

// 获取手术室
function getAnaestMethods() {
    var result = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: "FindAnaestMethod",
        Arg1: "",
        ArgCnt: 1
    }, "json");
    return result;
}

// 获取手术分级
function getOperClass() {
    var result = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: "FindOperClass",
        ArgCnt: 0
    }, "json");
    return result;
}

function getSurgeonCareProvs(surgeonDeptID) {
    var result = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindCareProvByLoc",
        Arg1: "",
        Arg2: surgeonDeptID,
        ArgCnt: 2
    }, "json");
    return result;
}

function loadSurgeonCareProvs() {


}

function closeWindow() {
    if (window.parent && window.parent.closeCurrentTab) {
        window.parent.closeCurrentTab();
    } else {
        top.window.opener = null;
        top.window.open("", "_self");
        top.window.close();
        // window.open("", "_self", "");
        // window.close();
    }
}

//查询患者
function findPatinetList() {
    $("#patientsList").datagrid("load");
}

function printApplication() {
    var lodop = getLodop();
    var appData = generateAppData();
    lodop.PRINT_INIT("打印术前访视记录单");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");

    lodop.ADD_PRINT_HTM(20, 0, "100%", 50, "<h2 style='text-align:center'>揭阳市人民医院手术通知单</h2>");
    lodop.ADD_PRINT_HTML(0, 0, "100%", "100%", html);

    var html = "<div style='padding:0 40px;font-size:14px'>";
    html += "<span>手术申请日期：" + appData.AppDateTime + "</span>";
    html += "<span>手术日期：" + appData.OperDate + "</span>";
    html += "<span style='font-size:36px'>" + appData.SourceTypeDesc + "</span>";
    html += "<span>住院号：" + appData.MedcareNo + "</span>";
    html += "</div>";
    lodop.ADD_PRINT_HTM(90, 0, "100%", 20, html);

    //打印表格
    html = "<style> table {margin:0 40px;font-size:14px;} table,td,th {border-width: 1px;border-style: solid;border-collapse: collapse}</style>";
    // 第1行
    html += "<table class='print-table'><tbody><tr>";
    html += "<td>登记号</td><td>" + appData.RegNo + "</td>";
    html += "<td>姓名</td><td>" + appData.PatName + "</td>";
    html += "<td>性别</td><td>" + appData.PatGender + "</td>";
    html += "<td>年龄</td><td>" + appData.PatAge + "</td></tr>";
    // 第2行
    html += "<tr><td>科室</td><td colspan='2'>" + appData.PatDeptDesc + "</td>";
    html += "<td>病区</td><td colspan='2'>" + appData.PatWardDesc + "</td>";
    html += "<td>床号</td><td>" + appData.PatBedNo + "</td></tr>";
    // 第3行
    html += "<tr><td>术前诊断</td><td colspan='7'>" + appData.PrevDiagnosisDesc + "</td></tr>";
    // 第4行
    html += "<tr><td>诊断备注</td><td colspan='7'></td></tr>";
    // 第5行
    html += "<tr><td>拟行手术名称</td><td colspan='7'>" + appData.OperationDesc + "</td></tr>";
    // 第6行
    html += "<tr><td>拟行手术名称</td><td colspan='7'>" + appData.OperInfo + "</td></tr>";
    // 第7行
    html += "<tr><td>手术医师</td><td>" + appData.SurgeonDesc + "</td>";
    html += "<td>手术助手</td><td colspan='3'>" + appData.AssistantDesc + "</td>";
    html += "<td>体位</td><td>" + appData.OperPosDesc + "</td></tr>";
    // 第8行
    html += "<tr><td>麻醉医生</td><td colspan='3'>" + appData.AnesthesiologistDesc + "</td>";
    html += "<td>麻醉方式</td><td colspan='3'>" + appData.PrevAnaMethodDesc + "</td></tr>";
    // 第9行
    html += "<tr><td>手术间</td><td>" + appData.OperRoomDesc + "</td>";
    html += "<td>手术台号</td><td>" + appData.OperSeq + "</td>";
    html += "<td>洗手护士</td><td>" + appData.ScrubNurseDesc + "</td>";
    html += "<td>巡回护士</td><td>" + appData.CircualNurseDesc + "</td></tr>";
    // 第10行
    html += "<tr><td>手术物品</td><td colspan='7'>" + appData.SurgicalMaterials + "</td></tr>";
    // 第11行
    html += "<tr><td>特殊情况</td><td colspan='7'>" + appData.SpecialConditions + "</td></tr>";
    // 第12行
    html += "<tr><td>医生签名</td><td colspan='3'></td>";
    html += "<td>科主任签名</td><td colspan='3'></td></tr>";
    html += "</tbody></table>"

    lodop.ADD_PRINT_TABLE(120, 0, "100%", "100%", html);
    lodop.PRINT();
}

$.extend($.fn.datagrid.defaults.editors, {
    combobox: {
        init: function(container, options) {
            var input = $('<select clas="hisui-combobox"></select>').appendTo(container);
            console.log(options);
            return input.combobox(options);
        },
        destroy: function(target) {
            $(target).combobox('destroy');
        },
        getValue: function(target) {
            var id = $(target).combobox('getValue')
            var desc = $(target).combobox('getText')
            var object = {
                RowId: id,
                ICDDesc: desc
            }
            return object; //$(target).combobox('getValue');
        },
        setValue: function(target, value) {
            $(target).combobox('setValue', value);
        },
        resize: function(target, width) {
            $(target).combobox('resize', width);
        }
    }
});