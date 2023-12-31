/**
 * 初始化页面
 * @author chenchangqing 20190107
 */
function initPages() {
    initCommonOptions();
    initArcimRule();
    initDrugArcim();
    initEventArcim();
    initAnaMethodArcim();
    initCatheterArcim();
}

/**
 * 初始化自动生成医嘱规则
 * @author chenchangqing 20190107
 */
function initArcimRule() {
    // 初始化规则表格
    var columns = [
        [
            { field: "Code", title: "代码", width: 80 },
            { field: "Description", title: "名称", width: 120 },
			{ field: "EndDate", title: "结束日期", width: 100 },
        ]
    ];

    $("#arcimRuleBox").datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = "";
            param.Arg2 = session.HospID;
            param.ArgCnt = 2;
        }
    })

    var arcimRuleDataForm = new DataForm({
        datagrid: $("#arcimRuleBox"),
        gridColumns: columns,
        gridTitle: "自动生成医嘱规则",
        gridTool: "#arcimRuleTools",
        pagination: false,
        form: $("#arcimRuleForm"),
        modelType: ANCLS.Config.ArcimRule,
        queryType: ANCLS.BLL.ArcimRule,
        queryName: "FindArcimRules",
        queryParams: {
            Arg1: "",
            ArgCnt: 1
        },
        dialog: $("#arcimRuleDialog"),
        addButton: $("#btnAddArcimRule"),
        editButton: $("#btnEditArcimRule"),
        delButton: $("#btnDelArcimRule"),
        addTitle: "新增-自动生成医嘱规则",
        editTitle: "修改-自动生成医嘱规则",
        queryButton: null,
        submitCallBack: null,
        onSubmitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    arcimRuleDataForm.initDataForm();
    arcimRuleDataForm.datagrid.datagrid({
        headerCls: 'panel-header-gray',
        iconCls: "icon-paper",
        onSelect: function(index, row) {
            $("[name='Rule']").val(row.RowId);
            $("#drugArcimBox").datagrid("reload");
            $("#eventArcimBox").datagrid("reload");
            $("#anaMethodArcimBox").datagrid("reload");
            $("#catheterArcimBox").datagrid("reload");
        }
    });
}

/**
 * 初始化药品关联医嘱项
 * @author chenchangqing 20190107
 */
function initDrugArcim() {
    // 初始化药品自动生成医嘱规则表格
    var columns = [
        [
            { field: "DrugItemDesc", title: "药品项", width: 120 },
            { field: "ArcimDesc", title: "医嘱项", width: 240 },
            { field: "DoseQty", title: "剂量", width: 60 },
            { field: "DoseUomDesc", title: "单位", width: 80 },
            { field: "AlertQty", title: "提醒数量", width: 60 },
            { field: "PackUomDesc", title: "单位", width: 80 },
            { field: "InstrDesc", title: "用药途径", width: 120 }
        ]
    ];

    var drugArcimDataForm = new DataForm({
        datagrid: $("#drugArcimBox"),
        gridColumns: columns,
        gridTitle: "",
        gridTool: "#drugArcimTools",
        pagination: false,
        form: $("#drugArcimForm"),
        modelType: ANCLS.Config.DrugArcim,
        queryType: ANCLS.BLL.ArcimRule,
        queryName: "FindDrugArcim",
        queryParams: {
            Arg1: "",
            ArgCnt: 2
        },
        dialog: null,
        addButton: $("#btnAddDrugArcim"),
        editButton: $("#btnEditDrugArcim"),
        delButton: $("#btnDelDrugArcim"),
        addTitle: "新增-药品项关联医嘱项",
        editTitle: "修改-药品项关联医嘱项",
        queryButton: null,
        submitCallBack: function() {
            var rules = $("#arcimRuleBox").datagrid("getSelections");
            if (rules.length > 0) {
                $("#DrugArcimRule").val(rules[0].RowId);
            }
        },
        onSubmitCallBack: null,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack: function(row) {
            $("#DrugArcimID").combogrid("setText", row.ArcimDesc);
            $("#DrugArcimRecvLoc").combobox("reload");
            $("#DrugArcimRecvLoc").combobox("setText", row.RecvLocDesc);
            $("#DrugArcimDoseUom").combobox("reload");
            $("#DrugArcimDoseUom").combobox("setText", row.PackUomDesc);
        }
    });
    drugArcimDataForm.initDataForm();
    drugArcimDataForm.datagrid.datagrid({
        bodyCls: 'panel-body-gray',
        border: false,
        onBeforeLoad: function(param) {
            var selectedRule = $("#arcimRuleBox").datagrid("getSelected");
            if (selectedRule) {
                param.Arg1 = selectedRule.RowId;
            }
            param.Arg2 = $("#DrugItem").combobox("getValue");
        }
    });

    // 初始化表单元素选择项、默认值等。
    $("#DrugItem").combobox({
        required: true,
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataItem";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = "D";
            param.ArgCnt = 2;
        },
        mode: "remote"
    });

    $("#btnQueryDrugArcim").linkbutton({
        onClick: function() {
            $("#drugArcimBox").datagrid("reload");
        }
    });
}

/**
 * 初始化事件关联医嘱项
 * @author chenchangqing 20190107
 */
function initEventArcim() {
    // 初始化事件自动生成医嘱规则表格
    var columns = [
        [
            { field: "EventItemDesc", title: "事件项", width: 120 },
            { field: "EventValueRule", title: "值规则", width: 120 },
            { field: "DetailItemDesc", title: "明细项", width: 120 },
            { field: "DetailValueRule", title: "值规则", width: 120 },
            { field: "ArcimDesc", title: "医嘱项", width: 200 },
            { field: "DoseQty", title: "剂量", width: 60 },
            { field: "DoseUomDesc", title: "剂量单位", width: 80 },
            { field: "PackQty", title: "数量", width: 60 },
            { field: "PackUomDesc", title: "数量单位", width: 80 },
            { field: "InstrDesc", title: "用药途径", width: 120 },
            { field: "OrderSetDesc", title: "医嘱套", width: 120 },
        ]
    ];

    var eventArcimDataForm = new DataForm({
        datagrid: $("#eventArcimBox"),
        gridColumns: columns,
        gridTitle: "",
        gridTool: "#eventArcimTools",
        pagination: false,
        form: $("#eventArcimForm"),
        modelType: ANCLS.Config.EventArcim,
        queryType: ANCLS.BLL.ArcimRule,
        queryName: "FindEventArcim",
        queryParams: {
            Arg1: "",
            ArgCnt: 2
        },
        dialog: null,
        addButton: $("#btnAddEventArcim"),
        editButton: $("#btnEditEventArcim"),
        delButton: $("#btnDelEventArcim"),
        addTitle: "新增-事件关联医嘱项",
        editTitle: "修改-事件关联医嘱项",
        queryButton: null,
        submitCallBack: function() {
            var rules = $("#arcimRuleBox").datagrid("getSelections");
            if (rules.length > 0) {
                $("#EventArcimRule").val(rules[0].RowId);
            }
        },
        onSubmitCallBack: null,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack: function(row) {
            $("#EventArcimID").combogrid("setText", row.ArcimDesc);
            $("#EventArcimRecvLoc").combobox("reload");
            $("#EventArcimRecvLoc").combobox("setText", row.RecvLocDesc);
            $("#EventArcimDoseUom").combobox("reload");
            $("#EventArcimDoseUom").combobox("setText", row.DoseUomDesc);
        }
    });
    eventArcimDataForm.initDataForm();
    eventArcimDataForm.datagrid.datagrid({
        bodyCls: 'panel-body-gray',
        onBeforeLoad: function(param) {
            var selectedRule = $("#arcimRuleBox").datagrid("getSelected");
            if (selectedRule) {
                param.Arg1 = selectedRule.RowId;
            }
            param.Arg2 = $("#EventItem").combobox("getValue");
        }
    });

    // 初始化表单元素选择项、默认值等。
    $("#EventItem").combobox({
        required: true,
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataItem";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = "E";
            param.ArgCnt = 2;
        },
        onSelect: function(record) {
            $("#DetailItem").combobox("reload");
        },
        mode: "remote"
    });
    $("#DetailItem").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindEventOptions";
            param.Arg1 = $("#EventItem").combobox("getValue");
            param.ArgCnt = 1;
        },
        mode: "remote"
    });

    $("#btnQueryEventArcim").linkbutton({
        onClick: function() {
            $("#eventArcimBox").datagrid("reload");
        }
    });
}

/**
 * 初始化麻醉方法关联医嘱项
 * @author chenchangqing 20190107
 */
function initAnaMethodArcim() {
    // 初始化麻醉方法自动生成医嘱规则表格
    var columns = [
        [
            { field: "AnaMethodDesc", title: "麻醉方法", width: 120 },
            { field: "MethodArcimDesc", title: "医嘱项", width: 120 },
            { field: "DoseQty", title: "剂量", width: 60 },
            { field: "DoseUomDesc", title: "剂量单位", width: 80 },
            { field: "PackQty", title: "数量", width: 60 },
            { field: "PackUomDesc", title: "数量单位", width: 80 },
            { field: "InstrDesc", title: "用药途径", width: 120 },
            { field: "TimeOutHours", title: "超时时长", width: 120 },
            { field: "TimeOutArcimDesc", title: "超时医嘱", width: 120 },
            { field: "OrderSetDesc", title: "医嘱套", width: 120 }
        ]
    ];

    var anaMethodArcimDataForm = new DataForm({
        datagrid: $("#anaMethodArcimBox"),
        gridColumns: columns,
        gridTitle: "",
        gridTool: "#anaMethodArcimTools",
        pagination: false,
        form: $("#anaMethodArcimForm"),
        modelType: ANCLS.Config.AnaMethodArcim,
        queryType: ANCLS.BLL.ArcimRule,
        queryName: "FindAnaMethodArcim",
        queryParams: {
            Arg1: "",
            ArgCnt: 2
        },
        dialog: null,
        addButton: $("#btnAddMethodArcim"),
        editButton: $("#btnEditMethodArcim"),
        delButton: $("#btnDelMethodArcim"),
        addTitle: "新增-麻醉方法关联医嘱项",
        editTitle: "修改-麻醉方法关联医嘱项",
        queryButton: null,
        submitCallBack: function() {
            var rules = $("#arcimRuleBox").datagrid("getSelections");
            if (rules.length > 0) {
                $("#AnaMethodArcimRule").val(rules[0].RowId);
            }
        },
        onSubmitCallBack: null,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack: function(row) {
            $("#AnaMethodArcimID").combogrid("setText", row.MethodArcimDesc);
            $("#TimeOutArcimID").combogrid("setText", row.TimeOutArcimDesc);
            $("#AnaMethodArcimRecvLoc").combobox("reload");
            $("#AnaMethodArcimRecvLoc").combobox("setText", row.RecvLocDesc);
            $("#AnaMethodArcimDoseUom").combobox("reload");
            $("#AnaMethodArcimDoseUom").combobox("setText", row.DoseUomDesc);
        }
    });
    anaMethodArcimDataForm.initDataForm();
    anaMethodArcimDataForm.datagrid.datagrid({
        bodyCls: 'panel-body-gray',
        onBeforeLoad: function(param) {
            var selectedRule = $("#arcimRuleBox").datagrid("getSelected");
            if (selectedRule) {
                param.Arg1 = selectedRule.RowId;
            }
            param.Arg2 = $("#AnaMethod").combobox("getValue");
        }
    });

    // 初始化表单元素选择项、默认值等。
    $("#AnaMethod").combobox({
        required: true,
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindAnaestMethod";
            param.Arg1 = param.q ? param.q : "";
            param.ArgCnt = 1;
        },
        mode: "remote"
    });

    $("#btnQueryAnaMethodArcim").linkbutton({
        onClick: function() {
            $("#anaMethodArcimBox").datagrid("reload");
        }
    });
}

/**
 * 初始化麻醉导管关联医嘱项
 * @author chenchangqing 20190107
 */
function initCatheterArcim() {
    // 初始化麻醉导管自动生成医嘱规则表格
    var columns = [
        [
            { field: "CatheterDesc", title: "麻醉导管", width: 120 },
            { field: "CatheterTypeDesc", title: "导管型号", width: 120 },
            { field: "PosMethodDesc", title: "定位方法", width: 120 },
            { field: "ArcimDesc", title: "医嘱项", width: 200 },
            { field: "DoseQty", title: "剂量", width: 60 },
            { field: "DoseUomDesc", title: "剂量单位", width: 80 },
            { field: "PackQty", title: "数量", width: 60 },
            { field: "PackUomDesc", title: "数量单位", width: 80 },
            { field: "InstrDesc", title: "用药途径", width: 120 },
            { field: "OrderSetDesc", title: "医嘱套", width: 120 },
        ]
    ];

    var catheterArcimDataForm = new DataForm({
        datagrid: $("#catheterArcimBox"),
        gridColumns: columns,
        gridTitle: "",
        gridTool: "#catheterArcimTools",
        pagination: false,
        form: $("#catheterArcimForm"),
        modelType: ANCLS.Config.CatheterArcim,
        queryType: ANCLS.BLL.ArcimRule,
        queryName: "FindCatheterArcim",
        queryParams: {
            Arg1: "",
            ArgCnt: 2
        },
        dialog: null,
        addButton: $("#btnAddCatheterArcim"),
        editButton: $("#btnEditCatheterArcim"),
        delButton: $("#btnDelCatheterArcim"),
        addTitle: "新增-麻醉导管关联医嘱项",
        editTitle: "修改-麻醉导管关联医嘱项",
        queryButton: null,
        submitCallBack: function() {
            var rules = $("#arcimRuleBox").datagrid("getSelections");
            if (rules.length > 0) {
                $("#CatheterArcimRule").val(rules[0].RowId);
            }
        },
        onSubmitCallBack: null,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack: function(row) {
            $("#CatheterArcimID").combogrid("setText", row.ArcimDesc);
            $("#CatheterArcimRecvLoc").combobox("reload");
            $("#CatheterArcimRecvLoc").combobox("setText", row.RecvLocDesc);
            $("#CatheterArcimDoseUom").combobox("reload");
            $("#CatheterArcimDoseUom").combobox("setText", row.DoseUomDesc);
        }
    });
    catheterArcimDataForm.initDataForm();
    catheterArcimDataForm.datagrid.datagrid({
        bodyCls: 'panel-body-gray',
        onBeforeLoad: function(param) {
            var selectedRule = $("#arcimRuleBox").datagrid("getSelected");
            if (selectedRule) {
                param.Arg1 = selectedRule.RowId;
            }
            param.Arg2 = $("#Catheter").combobox("getValue");
        }
    });

    // 初始化表单元素选择项、默认值等。
    $("#Catheter").combobox({
        required: true,
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindCatheter";
            param.Arg1 = "";
            param.Arg2 = "";
            param.ArgCnt = 2;
        },
        mode: "remote"
    });
    $("#CatheterType").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindCatheterType";
            param.Arg1 = $("#Catheter").combobox("getValue");
            param.ArgCnt = 1;
        },
        mode: "remote"
    });

    $("#PosMethod").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindPositionMethod";
            param.ArgCnt = 0;
        },
        mode: "remote"
    });

    $("#btnQueryCatheterArcim").linkbutton({
        onClick: function() {
            $("#catheterArcimBox").datagrid("reload");
        }
    });
}

/**
 * 初始化通用选项
 * @author chenchangqing 20190107
 */
function initCommonOptions() {
    $("#DrugArcimID,#EventArcimID,#AnaMethodArcimID,#TimeOutArcimID,#CatheterArcimID").combogrid({
        idField: "ArcimId",
        textField: "ArcimDesc",
        pagination: true,
        pageSize: 10,
        panelWidth: 450,
        panelHeight: 400,
        delay: 500,
        pageNumber: 1,
        url: ANCSP.MethodService,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.OEOrder;
            param.MethodName = "GetArcimJSON";
            param.Arg1 = param.page;
            param.Arg2 = param.rows;
            param.Arg3 = param.q ? param.q : "";
            param.Arg4 = session.ExtGroupID;
            param.Arg5 = session.ExtDeptID;
            param.Arg6 = "";
            param.Arg7 = session.UserID;
            param.ArgCnt = 7;
        },
        columns: [
            [
                { field: "ArcimId", title: "ID", hidden: true },
                { field: "ArcimDesc", title: "医嘱项目", width: 330 },
                { field: "BaseUomDesc", title: "单位", width: 40 },
                { field: "Price", title: "单价", width: 60 }
            ]
        ],
        mode: "remote",
        onSelect: function(rowIndex, row) {
            var id = $(this).attr("id");
            switch (id) {
                case "DrugArcimID":
                    selectDrugArcim(row);
                    break;
                case "EventArcimID":
                    selectEventArcim(row);
                    break;
                case "AnaMethodArcimID":
                    selectAnaMethodArcim(row);
                    break;
                case "TimeOutArcimID":
                    break;
                case "CatheterArcimID":
                    selectCatheterArcim(row);
                    break;
            }
        }
    });



    $("#DrugArcimInstr,#EventArcimInstr,#AnaMethodArcimInstr,#CatheterArcimInstr").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindInstruction";
            param.Arg1 = param.q ? param.q : "";
            param.ArgCnt = 1;
        },
        mode: "remote"
    });

    $("#DrugArcimPackUom,#EventArcimPackUom,#AnaMethodArcimPackUom,#CatheterArcimPackUom").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindUom";
            param.Arg1 = param.q ? param.q : "";
            param.ArgCnt = 1;
        },
        mode: "remote"
    });

    $("#DrugArcimDoseUom,#EventArcimDoseUom,#AnaMethodArcimDoseUom,#CatheterArcimDoseUom").combobox({
        valueField: "EquivUomId",
        textField: "EquivUomDesc",
        url: ANCSP.MethodService,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.OEOrder;
            param.MethodName = "GetDoseEquivJSON";
            param.Arg1 = "";
            var id = $(this).attr("id");
            switch (id) {
                case "DrugArcimDoseUom":
                    param.Arg1 = $("#DrugArcimID").combobox("getValue");
                    break;
                case "EventArcimDoseUom":
                    param.Arg1 = $("#EventArcimID").combobox("getValue");
                    break;
                case "AnaMethodArcimDoseUom":
                    param.Arg1 = $("#AnaMethodArcimID").combobox("getValue");
                    break;
                case "CatheterArcimDoseUom":
                    param.Arg1 = $("#CatheterArcimID").combobox("getValue");
                    break;
            }
            param.ArgCnt = 1;
        },
        mode: "remote"
    });

    $("#EventArcimOrderSet,#AnaMethodArcimOrderSet,#CatheterArcimOrderSet").combobox({
        valueField: "ARCOSRowid",
        textField: "ARCOSDesc",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = "web.DHCUserFavItems";
            param.QueryName = "FindUserOrderSet";
            param.Arg1 = session.UserID;
            param.Arg2 = "";
            param.Arg3 = "";
            param.Arg4 = "";
            param.Arg5 = "";
            param.Arg6 = "";
            param.Arg7 = "";
            param.Arg8 = "";
            param.Arg9 = "";
            param.Arg10 = "";
            param.Arg11 = "";
            param.Arg12 = "";
            param.ArgCnt = 12;
        },
        mode: "remote"
    });

    $("#DrugArcimRecvLoc,#EventArcimRecvLoc,#AnaMethodArcimRecvLoc,#CatheterArcimRecvLoc").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = "CIS.AN.BL.Admission",
                param.QueryName = "FindLocationOld"
            param.Arg1 = "";
            param.Arg2 = "ANRECLOC";
            /*
            var id=$(this).attr("id");
            switch(id){
                case "DrugArcimRecvLoc":
                    //param.Arg3=$("#DrugArcimID").combobox("getValue");
                    break;
                case "EventArcimRecvLoc":
                    //param.Arg3=$("#EventArcimID").combobox("getValue");
                    break;
                case "AnaMethodArcimRecvLoc":
                    //param.Arg3=$("#AnaMethodArcimID").combobox("getValue");
                    break;
                case "CatheterArcimRecvLoc":
                    //param.Arg3=$("#CatheterArcimID").combobox("getValue");
                    break;
            }*/
            param.ArgCnt = 2;
        },
        onLoadSuccess: function(data) {
            // if(data && data.length>0){
            //     $(this).combobox("setValue",data[0].Id);
            // }
        }
    });
}

/**
 * 药品关联医嘱项表单中的医嘱项选择后，执行的方法。
 * @param {object} row - 选择行的数据对象
 * @author chenchangqing 20190107
 */
function selectDrugArcim(row) {
    if (row.BaseUomId && row.BaseUomId !== "") {
        $("#DrugArcimPackUom").combobox("setValue", row.BaseUomId);
        // $("#DrugArcimDoseUom").combobox("setValue",row.BaseUomId);
    }

    if (row.InstrId && row.InstrId !== "") {
        $("#DrugArcimInstr").combobox("setValue", row.InstrId);
        // $("#DrugArcimInstr").combobox("setText",row.InstrDesc);
    }

    $("#DrugArcimDoseUom").combobox("reload");
    $("#DrugArcimRecvLoc").combobox("reload");
}

/**
 * 事件关联医嘱项表单中的医嘱项选择后，执行的方法。
 * @param {object} row - 选择行的数据对象
 * @author chenchangqing 20190107
 */
function selectEventArcim(row) {
    $("#EventArcimPackUom").combobox("setValue", row.BaseUomId);
    $("#EventArcimDoseUom").combobox("reload");
    $("#EventArcimRecvLoc").combobox("reload");
    $("#EventArcimInstr").combobox("setValue", row.InstrId);
}

/**
 * 麻醉方法关联医嘱项表单中的医嘱项选择后，执行的方法。
 * @param {object} row - 选择行的数据对象
 * @author chenchangqing 20190107
 */
function selectAnaMethodArcim(row) {
    $("#AnaMethodArcimPackUom").combobox("setValue", row.BaseUomId);
    $("#AnaMethodArcimDoseUom").combobox("reload");
    $("#AnaMethodArcimRecvLoc").combobox("reload");
    $("#AnaMethodArcimInstr").combobox("setValue", row.InstrId);
}

/**
 * 麻醉导管药品关联医嘱项表单中的医嘱项选择后，执行的方法。
 * @param {object} row - 选择行的数据对象
 * @author chenchangqing 20190107
 */
function selectCatheterArcim(row) {
    $("#CatheterArcimPackUom").combobox("setValue", row.BaseUomId);
    $("#CatheterArcimDoseUom").combobox("reload");
    $("#CatheterArcimRecvLoc").combobox("reload");
    //$("#CatheterArcimInstr").combobox("setValue",row.InstrId);
}

$(document).ready(function() {
    initPages();
});