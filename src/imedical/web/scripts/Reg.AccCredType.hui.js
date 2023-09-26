var PageLogicObj = {
    m_Grid: "",
    m_RowId: "",
    m_ClassName: "web.UDHCAccCredType"
}
$(function () {
    //��ʼ��
    Init()
    //�¼���ʼ��
    InitEvent()
    //ע�����ü�������
    DataListLoad()
})

function Init() {
    //��ʼ��������ComboBox
    InitComboBox()
    InitDataGrid()
}
function InitEvent() {
    //����������ť�¼�
    $("#Add").bind("click", AddClick)
    $("#Update").bind("click", UpdateClick)
    $("#Delete").bind("click", DeleteClick)
}
function InitDataGrid() {
    //,:%String,DefualtProvince:%String,:%String,:%String,:%String,:%String
    var Columns = [[
        { field: 'TCredTypeID', title: '', width: 1, hidden: true },
        { field: 'TCredCode', title: '֤������', width: 100, sortable: true, resizable: true },
        { field: 'TCredDesc', title: '֤������', width: 200, sortable: true, resizable: true },
        {
            field: 'TSureFlag', title: 'Ĭ��', width: 130, sortable: true, resizable: true,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>��</span>"
                } else {
                    return "<span class='c-no'>��</span>"
                }
            }
        },
        {
            field: 'TActive', title: '����', width: 130, sortable: true, resizable: true,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>��</span>"
                } else {
                    return "<span class='c-no'>��</span>"
                }
            }
        },
        { field: 'TDateFrom', title: '��ʼ����', width: 200, sortable: true, resizable: true },
        { field: 'TDateTo', title: '��������', width: 200, sortable: true, resizable: true },
        {
            field: 'TCredNoRequired', title: '֤���Ų�����Ϊ��', width: 130, sortable: true, resizable: true,
            formatter: function (value, row, index) {
                if (value == "Y") {
                    return "<span class='c-ok'>��</span>"
                } else {
                    return "<span class='c-no'>��</span>"
                }
            }
        }
    ]];
    /**
       * FIXED QP
       * ���ʹ��ԭ���ģ���ͷ������ң���Ϊ$HUI.datagrid
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
    ///��ʼ�� �豸���� 
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
                $.messager.popover({ msg: '�����ɹ���', type: 'success', timeout: 1000 });
            } else {
                $.messager.popover({ msg: '���³ɹ���', type: 'success', timeout: 1000 });
                PageLogicObj.m_RowId = "";
            }
            DataListLoad()
            clear()
        } else {
            if (txtData == "DateErr") {
                $.messager.alert("��ʾ", "��ʼ���ڲ��ܴ��ڽ�������.", 'info');
            } else if (txtData == "-316") {
                $.messager.alert("��ʾ", "��֤�������Ѿ�����,��������.", 'info');
            } else if (txtData == "DEF") {
                $.messager.alert("��ʾ", "�Ѿ���Ĭ�����Ͳ�������Ĭ��.", 'info');
            }
        }
    });
}
function CheckData() {
    var Code = $("#Code").val()
    if (Code == "") {
        $.messager.alert("��ʾ", "֤���������Ʋ���Ϊ��", 'info');
        return false
    }
    var Desc = $("#Desc").val()
    if (Desc == "") {
        $.messager.alert("��ʾ", "֤��������������Ϊ��", 'info');
        return false
    }
    return true
}
function AddClick() {
    SaveData("")
}
function UpdateClick() {
    if (PageLogicObj.m_RowId == "") {
        $.messager.alert("��ʾ", "��ѡ��֤����������", 'info');
        return
    }
    SaveData(PageLogicObj.m_RowId)
}
function DeleteClick() {
    if (PageLogicObj.m_RowId == "") {
        $.messager.alert("��ʾ", "��ѡ��Ҫɾ�����豸����", 'info');
        return
    }
    $m({
        ClassName: PageLogicObj.m_ClassName,
        MethodName: "Delete",
        rowid: PageLogicObj.m_RowId
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 1000 });
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
///����Ԫ�ص�classname��ȡԪ��ֵ
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
        //����Ŵ��ı����ֵΪ��,�򷵻ؿ�ֵ
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
///��Ԫ�ظ�ֵ
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
///�༭��������
function clear() {
    $.each(FieldJson, function (name, value) {
        setValue(value, "")
    })
}
//����Ԫ�غͱ����ֶζ��� 
var FieldJson = {
    CRTCode: "Code",
    CRTDesc: "Desc",
    CRTdefault: "Default",
    CRTActive: "Active",
    CRTDateFrom: "DateFrom",
    CRTDateTo: "DateTo",
    CRTCredNoRequired: "CredNoRequired"
}
