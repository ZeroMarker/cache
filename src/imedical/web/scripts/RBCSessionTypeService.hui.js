var PageLogicObj = {
    m_SessionTypeListDataGrid: "",
    m_SessionServerListDataGrid: "",
    editRow2: "",
    dialog1: ""
};
$(function () {
    var hospComp = GenHospComp("DHC_RBCSessionTypeService");
    hospComp.jdata.options.onSelect = function (e, t) {
        SessionTypeListDataGridLoad();
        InitSessionServerListDataGrid();
    }
    hospComp.jdata.options.onLoadSuccess = function (data) {
        //页面数据初始化
        Init();
        //加载挂号职称
        SessionTypeListDataGridLoad();
        InitTip();
    }
});
function Init() {
    $("#tipContent").css('width', $("#tipContent").parent().width() - 32);
    PageLogicObj.m_SessionTypeListDataGrid = InitSessionTypeListDataGrid();
    PageLogicObj.m_SessionServerListDataGrid = InitSessionServerListDataGrid();
    $("#cmd_OK").click(SaveExcludeAdmReason);
}
function InitSessionTypeListDataGrid() {
    var Columns = [[
        { field: 'ID', hidden: true },
        { field: 'Desc', title: '挂号职称', width: 280, align: 'center' }
    ]];
    var SessionTypeListDataGrid = $("#SessionTypeList").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: false,
        autoRowHeight: false,
        rownumbers: true,
        pagination: true,
        rownumbers: true,
        pageSize: 20,
        pageList: [20, 100, 200],
        idField: 'ID',
        columns: Columns,
        onClickRow: function (rowIndex, rowData) {
            PageLogicObj.m_SessionServerListDataGrid.datagrid('unselectAll');
        }
    }).datagrid({
        loadFilter: SessionServerListDataGridLoad();
        DocToolsHUI.lib.pagerFilter
    });
    return SessionTypeListDataGrid;
}
function SessionTypeListDataGridLoad() {
    $.q({
        ClassName: "web.DHCBL.BaseReg.BaseDataQuery",
        QueryName: "RBCSessionTypeQuery",
        HospID: $HUI.combogrid('#_HospList').getValue(),
        Pagerows: PageLogicObj.m_SessionTypeListDataGrid.datagrid("options").pageSize, rows: 99999
    }, function (GridData) {
        PageLogicObj.m_SessionTypeListDataGrid.datagrid("unselectAll").datagrid('loadData', GridData);
    });
}
function InitSessionServerListDataGrid() {
    var RegServiceGroup = $m({
        ClassName: "web.DHCOPRegConfig",
        MethodName: "GetSpecConfigNode",
        NodeName: "RegServiceGroup",
        HospId: $HUI.combogrid('#_HospList').getValue(),
    }, false);
    ///SERRowId:%String,ARCIMDR:%String,ARCITMDesc:%String
    var SeviceQueryData = $cm({
        ClassName: "web.DHCBL.BaseReg.BaseDataQuery",
        QueryName: "SeviceQuery",
        RegServiceGroupRowId: RegServiceGroup,
        HospID: $HUI.combogrid('#_HospList').getValue(),
        Pagerows: 99999, rows: 99999
    }, false);
    var Columns = [[
        { field: 'SERRowId', hidden: true },
        { field: 'ARCIMDR', hidden: true },
        {
            field: 'ARCITMDesc', title: '医嘱项名称', width: 300, align: 'center',
            editor: {
                type: 'combogrid',
                options: {
                    required: true,
                    panelWidth: 450,
                    panelHeight: 350,
                    idField: 'ID',
                    textField: 'Desc',
                    value: '',//缺省值 
                    mode: 'remote',
                    pagination: false,//是否分页   
                    rownumbers: true,//序号   
                    collapsible: false,//是否可折叠的   
                    fit: true,//自动大小   
                    pageSize: 10,//每页显示的记录条数，默认为10   
                    pageList: [10],//可以设置每页记录条数的列表  
                    data: SeviceQueryData,
                    columns: [[
                        { field: 'Desc', title: '名称', width: 300, sortable: true },
                        { field: 'ID', title: 'ID', width: 120, sortable: true }
                    ]],
                    keyHandler: {
                        up: function () {
                            //取得选中行
                            var selected = $(this).combogrid('grid').datagrid('getSelected');
                            if (selected) {
                                //取得选中行的rowIndex
                                var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
                                //向上移动到第一行为止
                                if (index > 0) {
                                    $(this).combogrid('grid').datagrid('selectRow', index - 1);
                                }
                            } else {
                                var rows = $(this).combogrid('grid').datagrid('getRows');
                                $(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
                            }
                        },
                        down: function () {
                            //取得选中行
                            var selected = $(this).combogrid('grid').datagrid('getSelected');
                            if (selected) {
                                //取得选中行的rowIndex
                                var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
                                //向下移动到当页最后一行为止
                                if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
                                    $(this).combogrid('grid').datagrid('selectRow', index + 1);
                                }
                            } else {
                                $(this).combogrid('grid').datagrid('selectRow', 0);
                            }
                        },
                        left: function () {
                            return false;
                        },
                        right: function () {
                            return false;
                        },
                        enter: function () {
                            //选中后让下拉表格消失
                            $(this).combogrid('hidePanel');
                            $(this).focus();
                        }
                    },
                    onSelect: function (rowIndex, rowData) {
                        var ArcimSelRow = PageLogicObj.m_SessionServerListDataGrid.datagrid("selectRow", PageLogicObj.editRow2).datagrid("getSelected");
                        var oldInstrArcimId = ArcimSelRow.ARCIMDR;
                        ArcimSelRow.ARCIMDR = rowData.ID;
                    }
                }
            }
        }
    ]];
    var ToolBar = [{
        text: '添加',
        iconCls: 'icon-add',
        handler: function () { //添加列表的操作按钮添加,修改,删除等
            var rows = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelections");
            if (rows.length == 0) {
                $.messager.alert("提示", "请选择一个要维护的挂号职称", "error");
                return false;
            }
            PageLogicObj.editRow2 = "";
            PageLogicObj.m_SessionServerListDataGrid.datagrid("rejectChanges");
            PageLogicObj.m_SessionServerListDataGrid.datagrid("unselectAll");

            if (PageLogicObj.editRow2 != "") {
                PageLogicObj.m_SessionServerListDataGrid.datagrid("endEdit", PageLogicObj.editRow2);
                return;
            } else {
                //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                PageLogicObj.m_SessionServerListDataGrid.datagrid("insertRow", {
                    index: 0,
                    // index start with 0
                    row: {

                    }
                });
                //将新插入的那一行开户编辑状态
                PageLogicObj.m_SessionServerListDataGrid.datagrid("beginEdit", 0);
                //给当前编辑的行赋值
                PageLogicObj.editRow2 = 0;
            }
        }
    }, {
        text: '删除',
        iconCls: 'icon-remove',
        handler: function () {
            //删除时先获取选择行
            var rows = PageLogicObj.m_SessionServerListDataGrid.datagrid("getSelections");
            //选择要删除的行
            if (rows.length > 0) {
                $.messager.confirm("提示", "你确定要删除吗?",
                    function (r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                if (!rows[i].SERRowId) {
                                    PageLogicObj.m_SessionServerListDataGrid.datagrid("rejectChanges");
                                    PageLogicObj.m_SessionServerListDataGrid.datagrid("unselectAll");
                                    PageLogicObj.editRow2 = "";
                                    return;
                                }
                                ids.push(rows[i].SERRowId);
                                var entityInfo = ["ID=" + rows[i].SERRowId,
                                "SERParRef=" + rows[i].SERRowId,
                                "SERRBCServiceDR=" + rows[i].ARCIMDR
                                ];
                                var resource = Card_GetEntityClassInfoToXML(entityInfo);
                                $cm({
                                    ClassName: "web.DHCBL.DHCRBResource.DHCRBResourceBuilder",
                                    MethodName: "RBResourceServerDelete",
                                    Infostr: resource
                                }, function (value) {
                                    if (value == "0") {
                                        //PageLogicObj.m_SessionServerListDataGrid.datagrid('load');
                                        PageLogicObj.m_SessionServerListDataGrid.datagrid('unselectAll');
                                        SessionServerListDataGridLoad();

                                        $.messager.show({ title: "提示", msg: "删除成功" });
                                    } else {
                                        $.messager.alert('提示', "删除失败:" + value);
                                    }
                                    PageLogicObj.editRow2 = "";
                                });
                            }
                        }
                    });
            } else {
                $.messager.alert("提示", "请选择要删除的行", "error");
            }
        }
    }, {
        text: '保存',
        iconCls: 'icon-save',
        handler: function () {
            var rows = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelections");
            if (rows.length > 0) {
                var ids = [];
                for (var i = 0; i < rows.length; i++) {
                    ids.push(rows[i].ID);
                }
                var SessionTypeList = ids.join(',')
                if (PageLogicObj.editRow2 != undefined) {
                    if (SessionTypeList == "") return false;
                    var SaveSelRow = PageLogicObj.m_SessionServerListDataGrid.datagrid("selectRow", PageLogicObj.editRow2).datagrid("getSelected");
                    //var editors = PageLogicObj.m_SessionServerListDataGrid.datagrid('getEditors', PageLogicObj.editRow2); 
                    var ARCIMDR = SaveSelRow["ARCIMDR"];
                    var SERRowId = SaveSelRow["SERRowId"];
                    if (typeof SERRowId == "undefined") {
                        SERRowId = "";
                    }
                    if ((ARCIMDR == "") || (ARCIMDR == undefined)) {
                        $.messager.alert("提示", "请选择医嘱项!");
                        return false;
                    }

                    var select = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelected");
                    var SERParRef = select.ID;
                    var entityInfo = ["ID=" + SERRowId,
                    "SERParRef=" + SERParRef,
                    "SERRBCServiceDR=" + ARCIMDR,
                    "HospID=" + $HUI.combogrid('#_HospList').getValue()
                    ];
                    var resource = Card_GetEntityClassInfoToXML(entityInfo);
                    $cm({
                        ClassName: "web.DHCBL.DHCRBResource.DHCRBResourceBuilder",
                        MethodName: "RBResourceServerSave",
                        Infostr: resource
                    }, function (value) {
                        if (value == "0") {
                            PageLogicObj.m_SessionServerListDataGrid.datagrid("endEdit", PageLogicObj.editRow2);
                            PageLogicObj.m_SessionServerListDataGrid.datagrid("rejectChanges").datagrid('unselectAll');
                            PageLogicObj.m_SessionServerListDataGrid.datagrid('unselectAll');
                            var data = PageLogicObj.m_SessionServerListDataGrid.datagrid("getData");
                            for (var i = data["rows"].length - 1; i >= 0; i--) {
                                PageLogicObj.m_SessionServerListDataGrid.datagrid('deleteRow', i);
                            }
                            SessionServerListDataGridLoad();
                            $.messager.show({ title: "提示", msg: "添加成功" });
                        } else {
                            $.messager.alert('提示', "添加失败:" + value);
                        }
                        PageLogicObj.editRow2 = "";
                    });
                }

            } else {
                $.messager.alert("提示", "请选择一个要维护的挂号职称", "error");
            }
        }
    }, {
        text: '取消编辑',
        iconCls: 'icon-redo',
        handler: function () {
            //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
            PageLogicObj.m_SessionServerListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            PageLogicObj.editRow2 = "";
            SessionServerListDataGridLoad();
        }
    }, '-', {
        text: '例外的费别',
        iconCls: 'icon-edit',
        handler: function () {
            var select = PageLogicObj.m_SessionServerListDataGrid.datagrid("getSelected");
            if (!select) {
                $.messager.alert("提示", "请选择医嘱项!");
                return false;
            }
            var SERRowId = select["SERRowId"];
            if ((SERRowId == "") || (SERRowId == undefined)) {
                $.messager.alert("提示", "请保存后再维护!");
                return false;
            }
            ExcludeAdmReason(SERRowId);
        }
    }];

    var SessionServerListDataGrid = $("#SessionServerList").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: false,
        autoRowHeight: false,
        rownumbers: false,
        pagination: true,
        pageSize: 20,
        pageList: [20, 100, 200],
        idField: 'SERRowId',
        columns: Columns,
        toolbar: ToolBar,
        onDblClickRow: function (rowIndex, rowData) {
            if (PageLogicObj.editRow2 !== "") {
                $.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
                return false;
            }
            PageLogicObj.m_SessionServerListDataGrid.datagrid("beginEdit", rowIndex);
            PageLogicObj.editRow2 = rowIndex;
        },
        onLoadSuccess: function (data) {
            PageLogicObj.editRow2 = "";
            $(this).datagrid("unselectAll");
        }
    }).datagrid({ loadFilter: DocToolsHUI.lib.pagerFilter });
    SessionServerListDataGrid.datagrid("unselectAll").datagrid('loadData', { total: 0, rows: [] });
    return SessionServerListDataGrid;
}
function SessionServerListDataGridLoad() {
    var select = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelected");
    if (!select) return false;
    var ID = select.ID;
    $.q({
        ClassName: "web.DHCRBResource",
        QueryName: "QuerySessionServer",
        SerParRef: ID,
        HospID: $HUI.combogrid('#_HospList').getValue(),
        Pagerows: PageLogicObj.m_SessionServerListDataGrid.datagrid("options").pageSize, rows: 99999
    }, function (GridData) {
        PageLogicObj.m_SessionServerListDataGrid.datagrid("unselectAll").datagrid('loadData', GridData);
    });
}

function ExcludeAdmReason(SERRowId) {
    //IInstrAutoLinkOrdExcludePrior
    $("#excludeAdmReason").val(SERRowId);
    $("#dialog-AdmReasonSelect").css("display", "");
    PageLogicObj.dialog1 = $("#dialog-AdmReasonSelect").dialog({
        autoOpen: false,
        height: 400,
        width: 300,
        modal: true
    });
    PageLogicObj.dialog1.dialog("open");
    $("#List_AdmReason").html("");
    $.q({
        ClassName: "web.DHCRBResource",
        QueryName: "FindAdmReason",
        SERRowId: SERRowId,
        HospID: $HUI.combogrid('#_HospList').getValue(),
        rows: 99999
    }, function (Data) {
        var ListArr = new Array();
        jQuery.each(Data.rows, function (i, n) {
            if (n.SelFlag == 1) {
                ListArr[ListArr.length] = "<option value=" + n.AdmReason + " Selected=" + n.SelFlag + ">" + n.AdmReasonDesc + "</option>";
            } else {
                ListArr[ListArr.length] = "<option value=" + n.AdmReason + ">" + n.AdmReasonDesc + "</option>";
            }
        });
        $("#List_AdmReason").append(ListArr.join(""));
    });
}
function SaveExcludeAdmReason() {
    var SERRowId = $("#excludeAdmReason").val();
    var AdmReasonStr = "";
    var size = $("#List_AdmReason" + " option").size();
    if (size > 0) {
        $.each($("#List_AdmReason" + " option:selected"), function (i, own) {
            var svalue = $(own).val();
            if (AdmReasonStr == "") AdmReasonStr = svalue;
            else AdmReasonStr = AdmReasonStr + "^" + svalue;
        })
    }
    var ret = $cm({
        ClassName: "web.DHCRBResource",
        MethodName: "InsertSEREXCludeAdmReason",
        SERRowId: SERRowId,
        EXCludeAdmReasonStr: AdmReasonStr
    }, false);
    if (ret == 0) {
        $("#excludeAdmReason").val("");
        PageLogicObj.dialog1.dialog("close");
        $.messager.show({ title: "提示", msg: "添加成功" });
    }
}
function InitTip() {
    var _content = "<ul class='tip_class'><li style='font-weight:bold'>出诊级别页面使用说明</li>" +
        "<li>1、出诊级别维护是维护挂号职称相应的服务费用，挂号时根据所选排班的挂号职称插入相关挂号费用。</li>" +
        "<li>2、右侧医嘱项名称检索弹框是医嘱项维护-服务资源组配置<挂号服务组>的医嘱项列表。</li>" +
        "<li>3、<挂号服务组>配置在挂号设置界面维护。</li>" +
        "<li>4、若挂号服务组未配置,则页面医嘱项下拉框数据为空,且对急诊分诊时产生就诊记录的挂号费在缴费时将不能正常缴费。</li>" +
        "<li>5、挂号服务组设置后,如非特殊情况,不能修改,如需修改请咨询开发。</li>" +
        "<li>6、医嘱项不属于挂号相关费用的医嘱,不能配置医嘱项服务组为挂号服务组,否则急诊分诊时产生就诊记录的挂号费在缴费时将不能正常缴费。</li>"
    $("#tip").popover({
        trigger: 'hover',
        content: _content
    });
}
