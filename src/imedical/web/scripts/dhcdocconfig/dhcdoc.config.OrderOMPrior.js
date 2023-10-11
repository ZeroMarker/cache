var ItemPriorDataGrid;
var node = "";
var FindLocNo = "";
var SearchLocCFflag = "";
nodeId = "" //标识例外列点击行
var IsCellCheckFlag = false; //标示例外科室是否点击
$(function() {
    InitHospList();

    $('#SaveutOMOrderNotPoison').click(SaveutOMOrderNotPoison);
    $('#SaveutOMOrderNotItemCat').click(SaveutOMOrderNotItemCat);
    $('#BSaveLessLoc').click(BSaveLessLoc);
})

function InitHospList() {
    var hospComp = GenHospComp("Doc_BaseConfig_ItemPrior");
    hospComp.jdata.options.onSelect = function(e, t) {
        Init();
    }
    hospComp.jdata.options.onLoadSuccess = function(data) {
        Init();
    }
}

function Init() {

    InittabItemPrior();
    InitPoisonListTab();
    InitItemCatListTab();
    //InitFreqListTab();
}

function InittabItemPrior() {
    var ItemPriorToolBar = [{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() { //添加列表的操作按钮添加,修改,删除等
            if (editRow != undefined) {
                //ItemPriorDataGrid.datagrid("endEdit", editRow);
                return;
            } else {
                //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                ItemPriorDataGrid.datagrid("insertRow", {
                    index: 0,
                    // index start with 0
                    row: {

                    }
                });
                //将新插入的那一行开户编辑状态
                ItemPriorDataGrid.datagrid("beginEdit", 0);
                //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                //给当前编辑的行赋值
                editRow = 0;
            }

        }
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {
            //删除时先获取选择行
            var rows = ItemPriorDataGrid.datagrid("getSelections");
            //选择要删除的行
            if (rows.length > 0) {
                $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].Index);
                            }
                            var IndexS = ids.join(',');
                            if (IndexS == "") {
                                editRow = undefined;
                                ItemPriorDataGrid.datagrid("rejectChanges");
                                ItemPriorDataGrid.datagrid("unselectAll");
                                return;
                            }
                            var value = $.m({
                                ClassName: "DHCDoc.DHCDocConfig.OrderOMPrior",
                                MethodName: "DelOMOrdLimit",
                                Value: "OMLimitOrder",
                                IndexS: IndexS,
                                HospId: $HUI.combogrid('#_HospList').getValue()
                            }, false);
                            if (value == "0") {
                                ItemPriorDataGrid.datagrid('load');
                                ItemPriorDataGrid.datagrid('unselectAll');
                                $.messager.show({ title: "提示", msg: "删除成功" });
                            } else {
                                $.messager.alert('提示', "删除失败:" + value);
                                return false;
                            }
                            editRow = undefined;
                        }
                    });
            } else {
                $.messager.alert("提示", "请选择要删除的行", "error");
            }
        }
    }, {
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {
            //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
            var rows = ItemPriorDataGrid.datagrid("getSelections");
            if (editRow != undefined) {
                var rows = ItemPriorDataGrid.datagrid("selectRow", editRow).datagrid("getSelected");
                if (rows.Index) {
                    var rowid = rows.Index
                } else {
                    var rowid = ""
                }
                var editors = ItemPriorDataGrid.datagrid('getEditors', editRow);
                var arcrowid = editors[0].target.combobox('getValue');


                if (arcrowid == "") {
                    $.messager.alert('提示', "请选择医嘱项目！");
                    return false;
                }
                if (rows.ArcimDesc == arcrowid) {
                    $.messager.alert('提示', "请先修改再保存！");
                    return false;
                }
                var value = $.m({
                    ClassName: "DHCDoc.DHCDocConfig.OrderOMPrior",
                    MethodName: "SaveOMOrdLimit",
                    Value: "OMLimitOrder",
                    Info: arcrowid,
                    rowid: rowid,
                    HospId: $HUI.combogrid('#_HospList').getValue()
                }, false);
                if (value == 0) {
                    ItemPriorDataGrid.datagrid("endEdit", editRow);
                    editRow = undefined;
                    ItemPriorDataGrid.datagrid('load').datagrid('unselectAll');
                } else if (value == "-1") {
                    $.messager.alert('提示', "该记录已存在！");
                    return false;
                } else if (value == "-2") {
                    $.messager.alert('提示', "请在下拉框中选择有效的医嘱项！");
                    return false;
                } else {
                    $.messager.alert('提示', "保存失败:" + value);
                    return false;
                }
                editRow = undefined;
            }
        }
    }, {
        text: '取消编辑',
        iconCls: 'icon-redo',
        handler: function() {
            //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
            editRow = undefined;
            ItemPriorDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
        }
    }];
    var ItemPriorColumns = [
        [{
                field: 'ArcimDr',
                title: 'ID',
                width: 1,
                hidden: true
            },
            {
                field: 'Index',
                title: 'ID',
                width: 1,
                hidden: true
            },
            {
                field: 'ArcimDesc',
                title: '名称',
                width: 80,
                editor: {
                    type: 'combogrid',
                    options: {
                        required: true,
                        panelWidth: 450,
                        panelHeight: 350,
                        idField: 'ArcimRowID',
                        textField: 'ArcimDesc',
                        value: '', //缺省值 
                        mode: 'remote',
                        pagination: true, //是否分页   
                        rownumbers: true, //序号   
                        collapsible: false, //是否可折叠的   
                        fit: true, //自动大小   
                        pageSize: 10, //每页显示的记录条数，默认为10   
                        pageList: [10], //可以设置每页记录条数的列表  
                        delay: 500,
                        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
                        columns: [
                            [
                                { field: 'ArcimDesc', title: '名称', width: 400, sortable: true },
                                { field: 'ArcimRowID', title: 'ID', width: 120, sortable: true },
                                { field: 'selected', title: 'ID', width: 120, sortable: true, hidden: true }
                            ]
                        ],
                        onBeforeLoad: function(param) {
                            var desc = param['q'];
                            param = $.extend(param, { Alias: param["q"], HospId: $HUI.combogrid('#_HospList').getValue() });
                        }
                    }
                }
            }
        ]
    ];
    ItemPriorDataGrid = $("#tabItemPrior").datagrid({
        fit: true,
        width: 'auto',
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: true,
        autoRowHeight: false,
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.OrderOMPrior&QueryName=Find&HospId=" + $HUI.combogrid('#_HospList').getValue(),
        loadMsg: '加载中..',
        pagination: true, //
        rownumbers: true, //
        idField: "rowid",
        pageSize: 15,
        pageList: [15, 50, 100, 200],
        columns: ItemPriorColumns,
        toolbar: ItemPriorToolBar,
        onLoadSuccess: function(data) {
            editRow = undefined;
        },
        onDblClickRow: function(rowIndex, rowData) {
            if (editRow !== undefined) {
                $.messager.alert("提示", "有正在编辑的行,请选保存或取消编辑!");
                return false;
            }
            editRow = rowIndex;
            $("#tabItemPrior").datagrid("beginEdit", rowIndex);
        },
        onBeforeLoad: function(param) {
            $("#tabItemPrior").datagrid('unselectAll');
        }
    });
}

function SaveutOMOrderNotPoison() {
    var PoisonStr = ""
    var rows = $("#PoisonListTab").datagrid('getSelections');
    for (var i = 0; i < rows.length; i++) {
        var PHCPORowId = rows[i].PHCPORowId;
        if (PoisonStr == "") PoisonStr = PHCPORowId;
        else PoisonStr = PoisonStr + "^" + PHCPORowId;
    }
    $.m({
        ClassName: "DHCDoc.DHCDocConfig.OrderOMPrior",
        MethodName: "SaveConfig",
        node: "OMOrderNotPoison",
        value: PoisonStr,
        HospId: $HUI.combogrid('#_HospList').getValue()
    }, function(rtn) {
        $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
    });
}

function SaveutOMOrderNotItemCat() {
    var CatStr = "";
    var rows = $("#ItemCatListTab").datagrid('getSelections');
    for (var i = 0; i < rows.length; i++) {
        var ARCICRowId = rows[i].ARCICRowId;
        if (CatStr == "") CatStr = ARCICRowId;
        else CatStr = CatStr + "^" + ARCICRowId;
    }
    $.m({
        ClassName: "DHCDoc.DHCDocConfig.OrderOMPrior",
        MethodName: "SaveConfig",
        node: "OMOrderNotItemCat",
        value: CatStr,
        HospId: $HUI.combogrid('#_HospList').getValue()
    }, function() {
        $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
    });
}

function InitPoisonListTab() {
    var Columns = [
        [
            { field: 'PHCPORowId', checkbox: true },
            { field: 'PHCPODesc', title: '管制分类', width: 100 },
            {
                field: 'id',
                title: '列操作',
                width: 50,
                formatter: function(v, rec) {
                    return '<a href="#this" class="editcls1" onclick="OMOrderNotPoisonLessLoc(' + (rec.PHCPORowId) + ')">例外科室</a>';
                }
            }
        ]
    ];
    PoisonListTabDataGrid = $("#PoisonListTab").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: false,
        fitColumns: true,
        autoRowHeight: false,
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.OrderOMPrior&QueryName=FindPoison&value=OMOrderNotPoison&HospId=" + $HUI.combogrid('#_HospList').getValue() + "&rows=99999",
        loadMsg: '加载中..',
        pagination: false, //
        rownumbers: false, //
        idField: "PHCPORowId",
        columns: Columns,
        onLoadSuccess: function(data) {
            for (var i = 0; i < data.total; i++) {
                if (data.rows[i].selected) {
                    $("#PoisonListTab").datagrid('selectRow', i);
                }
            }
        },
        onBeforeSelect: function(index, row) {
            if (IsCellCheckFlag == true) return false;
        },
        onBeforeUnselect: function(index, row) {
            if (IsCellCheckFlag == true) return false;
        },
        onBeforeLoad: function(param) {
            $("#PoisonListTab").datagrid('unselectAll');
        }
    });
}

function OMOrderNotPoisonLessLoc(PHCPORowId) {
    node = "OMOrderNotPoison";
    nodeId = PHCPORowId;
    ShowHolidaysRecSetWin();
    IsCellCheckFlag = true;
    setTimeout(function() {
        IsCellCheckFlag = false;
    })
}

function InitItemCatListTab() {
    var Columns = [
        [
            { field: 'ARCICRowId', checkbox: true },
            { field: 'ARCICDesc', title: '子类名称', width: 100 },
            {
                field: 'id',
                title: '列操作',
                width: 50,
                formatter: function(v, rec) {
                    return '<a href="#this" class="editcls1" onclick="OMOrderNotItemCatLessLoc(' + (rec.ARCICRowId) + ')">例外科室</a>';
                }
            }
        ]
    ];
    PoisonListTabDataGrid = $("#ItemCatListTab").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: false,
        fitColumns: true,
        autoRowHeight: false,
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.OrderOMPrior&QueryName=FindCatList&value=OMOrderNotItemCat&HospId=" + $HUI.combogrid('#_HospList').getValue() + "&rows=99999",
        loadMsg: '加载中..',
        pagination: false, //
        rownumbers: false, //
        idField: "ARCICRowId",
        columns: Columns,
        onLoadSuccess: function(data) {
            for (var i = 0; i < data.total; i++) {
                if (data.rows[i].selected) {
                    $("#ItemCatListTab").datagrid('selectRow', i);
                }
            }
        },
        onBeforeSelect: function(index, row) {
            if (IsCellCheckFlag == true) return false;
        },
        onBeforeUnselect: function(index, row) {
            if (IsCellCheckFlag == true) return false;
        },
        onBeforeLoad: function(param) {
            $("#ItemCatListTab").datagrid('unselectAll');
        }
    });
}

function OMOrderNotItemCatLessLoc(ARCICRowId) {
    node = "OMOrderNotItemCat";
    nodeId = ARCICRowId;
    ShowHolidaysRecSetWin();
    IsCellCheckFlag = true;
    setTimeout(function() {
        IsCellCheckFlag = false;
    })
}

function ShowHolidaysRecSetWin() {
    if ($("#LocWin").hasClass('window-body')) {
        $('#LocWin').window('open');
    } else {
        $('#LocWin').window({
            title: '例外科室',
            zIndex: 9999,
            iconCls: 'icon-w-edit',
            inline: false,
            minimizable: false,
            maximizable: false,
            collapsible: false,
            closable: true
        });
    }
    LoadLoc();
}

function BSaveLessLoc() {
    var LocStr = "";
    var recobj = $("#List_Dept").find("option:selected");
    for (var j = 0; j < recobj.length; j++) {
        if (LocStr == "") LocStr = recobj[j].value;
        else LocStr = LocStr + "^" + recobj[j].value;
    }
    var rtn = $.cm({
        ClassName: "DHCDoc.DHCDocConfig.OrderOMPrior",
        MethodName: "SaveLessLocConfig",
        node: node,
        nodeId: nodeId,
        value: LocStr,
        HospId: $HUI.combogrid('#_HospList').getValue(),
        dataType: "text"
    }, false);
    $("#LocWin").window('close');
}

function LoadLoc() {
    $("#List_Dept").find("option").remove();
    $('#SearchLoc').searchbox('setValue', "")
    $.cm({
        ClassName: "DHCDoc.DHCDocConfig.OrderOMPrior",
        QueryName: "GetLocList",
        HospId: $HUI.combogrid('#_HospList').getValue(),
        rows: "99999",
    }, function(objScope) {
        var vlist = "";
        var selectlist = "";
        jQuery.each(objScope.rows, function(i, n) {
            selectlist = selectlist + "^" + n.selected
            vlist += "<option title=" + n.PYFristStr + " value=" + n.LocRowID + ">" + n.LocDesc + "</option>";
        });
        if ($("#List_Dept option").length == 0) {
            $("#List_Dept").append(vlist);
        }
        $.cm({
            ClassName: "DHCDoc.DHCDocConfig.OrderOMPrior",
            MethodName: "GetLessLocConfig",
            node: node,
            nodeId: nodeId,
            HospId: $HUI.combogrid('#_HospList').getValue(),
            dataType: "text"
        }, function(locStr) {
            for (var i = 0; i < locStr.split("^").length; i++) {
                var locId = locStr.split("^")[i];
                $("#List_Dept").find("option[value='" + locId + "']").attr("selected", true);
            }
        });
    });
}



function SearchLessLoc() {
    var SearchLoc = $('#SearchLoc').searchbox('getValue')
    if ((FindLocNo != "") && (typeof(FindLocNo) != "undefined")) {
        $("#List_Dept").find("option")[FindLocNo].className = ""
    }
    if (SearchLoc == "") return "";
    var ListDeplen = $("#List_Dept").find("option").length
    var startNo = 0
    if (SearchLocCFflag == SearchLoc) {
        startNo = FindLocNo + 1
    }
    FindLocNo = ""
    var SearchLocPY = GetLocPY(SearchLoc)
    for (var i = startNo; i < ListDeplen; i++) {
        var locname = $("#List_Dept").find("option")[i].innerHTML
        var locnamePY = $("#List_Dept").find("option")[i].title
        if ((locname.indexOf(SearchLoc) != -1) && (SearchLocPY > 0)) {
            FindLocNo = i
            break
        } else if (locnamePY.indexOf(SearchLocPY) != -1) {
            FindLocNo = i
            break
        }
    }
    if (FindLocNo == "") return "";
    $("#List_Dept").find("option")[FindLocNo].className = "optioncolor"
    $("#List_Dept").animate({ scrollTop: 20 * parseFloat(FindLocNo) }, "slow");
    SearchLocCFflag = SearchLoc
}

function GetLocPY(locname) {
    if (chkstrlen(locname) > 0) {
        return 10;
    }
    var value = $.m({
        ClassName: "web.DHCINSUPort",
        MethodName: "GetCNCODE",
        HANZIS: locname,
        FLAG: "4",
        HospId: $HUI.combogrid('#_HospList').getValue()
    }, false);
    return value

}

function chkstrlen(str) {
    var strlen = 0;
    for (var i = 0; i < str.length; i++) {
        if (str.charCodeAt(i) > 255) //如果是汉字
            strlen += 1;
    }
    return strlen;
}