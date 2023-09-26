var PageLogicObj = {
    m_Grid: "",
    m_RowId: "",
    m_ClassName: "web.UDHCAccCredType"
}
$(function () {
    //初始化
    Init()
    //事件初始化
    InitEvent()
    //注册配置加载数据
    DataListLoad()
})

function Init() {
    //初始化界面上ComboBox
    InitComboBox()
    InitDataGrid()
}
function InitEvent() {
    //定义新增按钮事件
    $("#Add").bind("click", AddClick)
    $("#Update").bind("click", UpdateClick)
    $("#Delete").bind("click", DeleteClick)
}
function InitDataGrid() {
    //,:%String,DefualtProvince:%String,:%String,:%String,:%String,:%String
    var Columns = [[
        { field: 'TCredTypeID', title: '', width: 1, hidden: true },
        { field: 'TCredCode', title: '证件名称', width: 100, sortable: true, resizable: true },
        { field: 'TCredDesc', title: '证件描述', width: 200, sortable: true, resizable: true },
        {
            field: 'TSureFlag', title: '默认', width: 130, sortable: true, resizable: true,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>是</span>"
                } else {
                    return "<span class='c-no'>否</span>"
                }
            }
        },
        {
            field: 'TActive', title: '激活', width: 130, sortable: true, resizable: true,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>是</span>"
                } else {
                    return "<span class='c-no'>否</span>"
                }
            }
        },
        { field: 'TDateFrom', title: '开始日期', width: 200, sortable: true, resizable: true },
        { field: 'TDateTo', title: '结束日期', width: 200, sortable: true, resizable: true },
        {
            field: 'TCredNoRequired', title: '证件号不允许为空', width: 130, sortable: true, resizable: true,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>是</span>"
                } else {
                    return "<span class='c-no'>否</span>"
                }
            }
        }
    ]];
    /**
       * FIXED QP
       * 如果使用原生的，表头将会错乱，改为$HUI.datagrid
       */
    PageLogicObj.m_Grid = $HUI.datagrid("#DataList", {
        fit: true,
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: true,
        autoRowHeight: false,
        pagination: true,
        pageSize: 20,
        idField: 'RowID',
        columns: Columns,
        onSelect: function (index, rowData) {
            PageLogicObj.m_RowId = rowData["TCredTypeID"]
            DataGridSelect(rowData["TCredTypeID"])
        },
        onUnselect: function () {
            PageLogicObj.m_RowId = "";
            DataGridUnSelect();
        },
        onBeforeSelect: function (index, row) {
            var selrow = $("#DataList").datagrid('getSelected');
            if (selrow) {
                var oldIndex = $("#DataList").datagrid('getRowIndex', selrow);
                if (oldIndex == index) {
                    $("#DataList").datagrid('unselectRow', index);
                    return false;
                }
            }
        }

    });
    /*
    var dataGrid=$("#DataList").datagrid({
        fit : true,
        border : false,
        striped : true,
        singleSelect : true,
        fitColumns : true,
        autoRowHeight : false,
        pagination : true,  
        pageSize: 20,
        idField:'RowID',
        columns :Columns,
        onSelect:function(index,rowData){
            PageLogicObj.m_RowId=rowData["TCredTypeID"]
            DataGridSelect(rowData["TCredTypeID"])
        },
        onUnselect:function(){
            PageLogicObj.m_RowId="";
            DataGridUnSelect();
        },
        onBeforeSelect:function(index, row){
            var selrow=$("#DataList").datagrid('getSelected');
            if (selrow){
                var oldIndex=$("#DataList").datagrid('getRowIndex',selrow);
                if (oldIndex==index){
                    $("#DataList").datagrid('unselectRow',index);
                    return false;
                }
            }
        }
    });*/
    //dataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
    PageLogicObj.m_Grid.loadData({ 'total': '0', rows: [] });
    //return dataGrid;
}
function DataListLoad() {
    $.cm({
        ClassName: "web.UDHCAccCredType",
        QueryName: "FindCredType",
        rows: 99999
    }, function (GridData) {
        //$("#DataList").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
        //$("#DataList").datagrid("clearSelections")
        PageLogicObj.m_Grid.loadData(GridData);
        PageLogicObj.m_Grid.clearSelections();
    });
}
function InitComboBox() {
    ///初始化 设备类型 
    $.cm({
        ClassName: "web.DHCBL.UDHCCommFunLibary",
        QueryName: "InitListObjectValueNew",
        ClassName1: "User.DHCCardHardComGroup",
        PropertyName: "CCGType",
        rows: 99999
    }, function (GridData) {
        var cbox = $HUI.combobox("#Type", {
            valueField: 'ValueList',
            textField: 'DisplayValue',
            editable: true,
            data: GridData["rows"]
        });
    });
}
function SaveData(RowId) {
    if (!CheckData()) return
    var dataJson = {}
    $.each(FieldJson, function (name, value) {
        var val = getValue(value)
        val = '"' + val + '"'
        eval("dataJson." + name + "=" + val)
    });
    var jsonStr = JSON.stringify(dataJson)
    $m({
        ClassName: PageLogicObj.m_ClassName,
        MethodName: "SaveByJson",
        RowId: RowId,
        JsonStr: jsonStr
    }, function (txtData) {
        if (txtData == 0) {
            if (RowId == "") {
                $.messager.popover({ msg: '新增成功！', type: 'success', timeout: 1000 });
            } else {
                $.messager.popover({ msg: '更新成功！', type: 'success', timeout: 1000 });
                PageLogicObj.m_RowId = "";
            }
            DataListLoad()
            clear()
        } else {
            if (txtData == "DateErr") {
                $.messager.alert("提示", "开始日期不能大于结束日期.", 'info');
            } else if (txtData == "-316") {
                $.messager.alert("提示", "此证件类型已经存在,不能新增.", 'info');
            } else if (txtData == "DEF") {
                $.messager.alert("提示", "已经有默认类型不能再置默认.", 'info');
            }
        }
    });
}
function CheckData() {
    var Code = $("#Code").val()
    if (Code == "") {
        $.messager.alert("提示", "证件类型名称不能为空", 'info');
        return false
    }
    var Desc = $("#Desc").val()
    if (Desc == "") {
        $.messager.alert("提示", "证件类型描述不能为空", 'info');
        return false
    }
    return true
}
function AddClick() {
    SaveData("")
}
function UpdateClick() {
    if (PageLogicObj.m_RowId == "") {
        $.messager.alert("提示", "请选择证件类型数据", 'info');
        return
    }
    SaveData(PageLogicObj.m_RowId)
}
function DeleteClick() {
    if (PageLogicObj.m_RowId == "") {
        $.messager.alert("提示", "请选择要删除的设备类型", 'info');
        return
    }
    $m({
        ClassName: PageLogicObj.m_ClassName,
        MethodName: "Delete",
        rowid: PageLogicObj.m_RowId
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
            DataListLoad()
            clear()
            PageLogicObj.m_RowId = ""
        }
    });
}
function DataGridSelect(RowId) {
    $.cm({
        ClassName: PageLogicObj.m_ClassName,
        MethodName: "GetDataJson",
        RowId: RowId,
        jsonFiledStr: JSON.stringify(FieldJson)
    }, function (JsonData) {
        if (JsonData != "") {
            $.each(JsonData, function (name, value) {
                setValue(name, value)
            })
        }
    });
}
function DataGridUnSelect() {
    $("#Code,#Desc").val('');
    $("#DateFrom,#DateTo").datebox('setValue', '');
    $("#Default,#Active").switchbox('setValue', true);
}
///根据元素的classname获取元素值
function getValue(id) {
    var className = $("#" + id).attr("class")
    if (typeof className == "undefined") {
        return $("#" + id).val()
    }
    if (className.indexOf("hisui-switchbox") >= 0) {
        var val = $("#" + id).switchbox("getValue")
        return val = (val ? 'Y' : 'N')
    } else if (className.indexOf("hisui-lookup") >= 0) {
        var txt = $("#" + id).lookup("getText")
        //如果放大镜文本框的值为空,则返回空值
        if (txt != "") {
            var val = $("#" + id).val()
        } else {
            var val = ""
            $("#" + id + "Id").val("")
        }
        return val
    } else if (className.indexOf("hisui-combobox") >= 0) {
        return $("#" + id).combobox("getValue")
    } else if (className.indexOf("hisui-datebox") >= 0) {
        return $("#" + id).datebox("getValue")
    } else {
        return $("#" + id).val()
    }
    return ""
}
///给元素赋值
function setValue(id, val) {
    var className = $("#" + id).attr("class")
    if (typeof className == "undefined") {
        $("#" + id).val(val)
        return
    }
    if (className.indexOf("hisui-switchbox") >= 0) {
        val = (val == "Y" ? true : false)
        $("#" + id).switchbox("setValue", val)
    } else if (className.indexOf("hisui-combobox") >= 0) {
        $("#" + id).combobox("setValue", val)
    } else if (className.indexOf("hisui-datebox") >= 0) {
        $("#" + id).datebox("setValue", val)
    } else {
        $("#" + id).val(val)
    }
    return ""
}
///编辑窗口清屏
function clear() {
    $.each(FieldJson, function (name, value) {
        setValue(value, "")
    })
}
//界面元素和表里字段对照 
var FieldJson = {
    CRTCode: "Code",
    CRTDesc: "Desc",
    CRTdefault: "Default",
    CRTActive: "Active",
    CRTDateFrom: "DateFrom",
    CRTDateTo: "DateTo",
    CRTCredNoRequired: "CredNoRequired"
}
