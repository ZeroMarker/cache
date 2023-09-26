/**
 * 模块:     基数药请求制单
 * 编写日期: 2018-06-20
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'] || "";
var ReqUserId = SessionUser;
var ReqId = "";
var GridCmgInc;
var GridCmbIncUom;
$(function() {
    InitDict();
    InitGridDict();
    InitGridTransReqItm();
    SetTransReqData();
    $("#btnGridAdd").on("click", function() {
        AddNewRow();
    });
    $("#btnGridDelete").on("click", DeleteRow);
    $("#btnDelete").on("click", Delete);
    $("#btnSave").on("click", Save);
    $("#btnFinish").on("click", function() {
        Finish("Y");
    });
    $("#btnCancel").on("click", function() {
        Finish("N");
    });
    return
    $("#btnFind").on("click", Query);
    //window.resizeTo(screen.availWidth, (screen.availHeight));
});

function InitDict() {
    DHCPHA_HUI_COM.ComboBox.Init({ Id: 'cmbReqLoc', Type: 'CtLoc' }, {
        onLoadSuccess: function() {
            $("#cmbReqLoc").combobox("setValue", SessionLoc);
            $("#cmbReqLoc").combobox("readonly")
        },
        width: 200
    });
    DHCPHA_HUI_COM.ComboBox.Init({ Id: 'cmbProLoc', Type: 'CtLoc' }, {
        width: 200,
        onBeforeLoad: function(param) {
            param.inputStr = "D";
            param.filterText = param.q;
			param.hosp = HospId;
        }
    });
    DHCPHA_HUI_COM.ComboBox.Init({
        Id: 'cmbReqType',
        data: {
            data: [
                { "RowId": "1", "Description": "基数补货" },
                { "RowId": "2", "Description": "精神毒麻补货" },
                { "RowId": "3", "Description": "大输液补货" }
            ]
        }
    }, {
        mode: "local",
        editable: false,
        readonly: true
    });
    $("#dateReq").datebox("setValue", DHCPHA_TOOLS.Today());
    $("#txtReqUserName").val(session['LOGON.USERNAME']);
    if (LoadReqType != "") {
        $("#cmbReqType").combobox("setValue", LoadReqType);
    }

}

function InitGridDict() {
	// 基数药query单写
    GridCmgInc = DHCPHA_HUI_COM.GridComboGrid.Init({ Type: "IncItm" }, {
      	queryParams: {
            ClassName: "web.DHCINPHA.WardBaseDrug",
            QueryName: "IncItm",
            inputStr: ""
        },
        pageNumber: 0,
        panelWidth: 750,
        columns: [
            [
                { field: 'incRowId', title: 'incItmRowId', width: 100, sortable: true, hidden: true },
                { field: 'incCode', title: '药品代码', width: 100, sortable: true },
                { field: 'incDesc', title: '药品名称', width: 400, sortable: true },
                { field: 'incSpec', title: '规格', width: 100, sortable: true }
            ]
        ],
        required: true,
        idField: 'incRowId',
        textField: 'incDesc',
        checkOnSelect: false,
        selectOnCheck: false,
        hasDownArrow: false,
        pageSize: 10,
        pageList: [10, 30, 50],
        pagination: true,
        delay: 100, // 注意此delay
        /*
        onSelect: function() {

            var editIndex = $("#gridTransReqItm").datagrid('options').editIndex;
            if (editIndex == undefined) {
                return;
            }
            var incEd = $("#gridTransReqItm").datagrid('getEditor', { index: editIndex, field: 'incRowId' });
            $(incEd.target).combogrid('hidePanel');
            alert(1)
            setTimeout(function() {
                $("#gridTransReqItm").datagrid("refreshRow", editIndex)
            }, 1000)
        },*/
        onHidePanel: function() {
            var editIndex = $("#gridTransReqItm").datagrid('options').editIndex;
            if (editIndex == undefined) {
                return;
            }
            var incEd = $("#gridTransReqItm").datagrid('getEditor', { index: editIndex, field: 'incRowId' });
            var rowData = $(incEd.target).combogrid("grid").datagrid("getSelected");
            if ((rowData == "") || (rowData == null)) {
                return;
            }
            var gridSelect = $('#gridTransReqItm').datagrid("getSelected");
            var reqUomEd = $("#gridTransReqItm").datagrid('getEditor', { index: editIndex, field: 'reqUomId' });
            var chkExist = CheckExistInc(rowData.incRowId);
            if (chkExist == true) {
                $.messager.alert("提示", "已存在该记录:" + rowData.incDesc, "warning", function() {
                    $(incEd.target).combobox('textbox').focus();
                });
                $(incEd.target).combogrid("clear");
                $(incEd.target).combogrid("textbox").val("");
                gridSelect.incCode = "";
                gridSelect.incDesc = "";
                gridSelect.incRowId = "";
                $(reqUomEd.target).combobox("clear")
                $(reqUomEd.target).combobox("reload");
                $('#gridTransReqItm').datagrid("cancelEdit", editIndex);
                return;
            }
            gridSelect.incCode = rowData.incCode;
            gridSelect.incRowId = rowData.incRowId;
            gridSelect.incDesc = rowData.incDesc;
            $(reqUomEd.target).combobox("reload");
            setTimeout(function() {
                // 刷新并保持编辑
                $("#gridTransReqItm").datagrid("refreshRow", editIndex).datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
                var reqQtyEd = $("#gridTransReqItm").datagrid('getEditor', { index: editIndex, field: 'reqQty' });
                $(reqQtyEd.target).focus();
                GridEditorEvents();
            }, 300);
        },
        onBeforeLoad: function(param) {
	        var inputStrArr=[];
            if (param.q == undefined) {
                inputStrArr[0] = $('#gridTransReqItm').datagrid("getSelected").incRowId;
            }
            inputStrArr[1]=$("#cmbProLoc").combobox("getValue")||"";
            inputStrArr[2]=$("#cmbReqType").combobox("getValue")||"";
            param.inputStr=inputStrArr.join("^");
            param.filterText = param.q;
        }
    });
    GridCmbIncUom = DHCPHA_HUI_COM.GridComboBox.Init({ Type: "IncUom" }, {
        required: true,
        editable: false,
        onBeforeLoad: function(param) {
            param.inputStr = $('#gridTransReqItm').datagrid("getSelected").incRowId;
            param.filterText = param.q;
        },
        onLoadSuccess: function(data) {
	        var len=data.length;
            if (len > 0) {
                var selectUom = $('#gridTransReqItm').datagrid("getSelected").reqUomId || "";
                var finalUom=""
                // 默认单位
                for(var i=0;i<len;i++){
	                var iUom=data[i].RowId;
	                if (iUom==selectUom){
		            	finalUom=iUom;
		            	break;
		            }
                }
                if (finalUom==""){
	            	finalUom=data[0].RowId; 
	            }
	            $(this).combobox('select', finalUom);
            }else{
	        	$(this).combobox('clear');
	        }
        }
    });
}
/// 根据reqid设置主信息值
function SetTransReqData() {
    var queryReqId = LoadReqId;
    if (ReqId != "") {
        queryReqId = ReqId;
    }
    if (queryReqId != "") {
        var reqData = tkMakeServerCall("web.DHCINPHA.WardBaseDrug", "GetReqData", queryReqId);
        if (reqData != "") {
            var reqDataArr = reqData.split("^");
            ReqUserId = reqDataArr[5];
            $("#txtReqUserName").val(reqDataArr[6]);
            $("#dateReq").datebox("setValue", reqDataArr[4]);
            $("#cmbReqLoc").combobox("setValue", reqDataArr[2]);
            $("#cmbProLoc").combobox("setValue", reqDataArr[3]);
            $("#txtReqNo").val(reqDataArr[1]);
            ReqId = reqDataArr[0];
            $("#cmbReqLoc").combobox("readonly");
            $("#cmbReqType").combobox("setValue", reqDataArr[8]);
            $("#chkFinish").checkbox("setValue", reqDataArr[7] == "Y" ? true : false);
            setTimeout(function() { QueryDetail(ReqId); }, 100);
        }
    }
}

// 申请单明细列表
function InitGridTransReqItm() {
    var columns = [
        [
            { field: 'reqItmId', title: 'reqItmId', width: 200, halign: 'center', hidden: true },
            {
                field: 'incCode',
                title: '药品代码',
                width: 120,
                halign: 'center',
                formatter: function(value, row, index) {
                    return value;
                }
            },
            { field: 'incDesc', title: '药品名称描述', width: 400, halign: 'center', hidden: true },
            { field: 'reqUomDesc', title: '单位描述', width: 400, halign: 'center', hidden: true },
            {
                field: 'incRowId',
                title: '药品名称',
                width: 400,
                halign: 'center',
                editor: GridCmgInc,
                descField: 'incDesc',
                formatter: function(value, row, index) {
                    return row.incDesc;
                }
            },
            {
                field: 'reqQty',
                title: '数量',
                width: 75,
                halign: 'center',
                align: 'right',
                editor: {
                    type: 'validatebox', //validatebox 好用
                    options: {
                        required: true,
                        validType: 'PosNumber'
                            //precision: 1
                    }
                }
            },
            {
                field: 'reqUomId',
                title: '单位',
                width: 100,
                halign: 'center',
                editor: GridCmbIncUom,
                descField: 'reqUomDesc',
                formatter: function(value, row, index) {
                    return row.reqUomDesc;
                }
            }
        ]
    ];
    var dataGridOption = {
        fit: true,
        border: false,
        singleSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 1000,
        pageList: [1000, 100, 300, 500],
        pagination: false,
        toolbar: "#gridTransReqItmBar",
        onSelect: function(rowIndex, rowData) {

        },
        onClickRow: function(rowIndex, rowData) {
            var incDesc = rowData.incDesc;
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'incRowId'
            });
            GridEditorEvents();
        },
        onBeforeEdit: function(rowIndex, rowData) {

        },
        onUnselect: function(rowIndex, rowData) {

        },
        onLoadSuccess: function() {

        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridTransReqItm", dataGridOption);
}

// 查询明细
function QueryDetail(reqId) {
    $('#gridTransReqItm').datagrid({
        url: $URL,
        queryParams: {
            ClassName: "web.DHCINPHA.WardBaseDrug",
            QueryName: "QueryTransReqItm",
            inputStr: reqId
        }
    });
}

// 增加
function AddNewRow() {
    var proLocId = $("#cmbProLoc").combobox("getValue") || "";
    if (proLocId == "") {
        $.messager.alert("提示", "请先选择供给科室", "warning");
        return;
    }
    $("#gridTransReqItm").datagrid('addNewRow', {
        editField: 'incRowId'
    });
    GridEditorEvents();
}

// 删除一行
function DeleteRow() {
    var gridSelect = $('#gridTransReqItm').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请选择需要删除的记录!", "warning");
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function(r) {
        if (r) {
            var reqItmId = gridSelect.reqItmId || "";
            var rowIndex = $('#gridTransReqItm').datagrid('getRowIndex', gridSelect);
            if (reqItmId == "") {
                $('#gridTransReqItm').datagrid("deleteRow", rowIndex);
            } else {
                var delRet = tkMakeServerCall("web.DHCINPHA.WardBaseDrug", "DeleteReqItm", reqItmId);
                if (delRet.split("^")[0] < 0) {
                    $.messager.alert("提示", delRet.split("^")[1], "warning");
                    return;
                } else {
                    $('#gridTransReqItm').datagrid("deleteRow", rowIndex);
                }
            }
        }
    })
}

// 删除请求单
function Delete() {
    var reqNo = $("#txtReqNo").val() || "";
    if (reqNo == "") {
        $.messager.alert("提示", "尚未建单", "warning");
        return;
    }
    if (ReqId == "") {
        $.messager.alert("提示", "获取不到请求单Id", "warning");
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function(r) {
        if (r) {
            var delRet = tkMakeServerCall("web.DHCINPHA.WardBaseDrug", "DeleteReq", ReqId);
            if (delRet.split("^")[0] < 0) {
                $.messager.alert("提示", delRet.split("^")[1], "warning");
                return;
            } else {
                Clear();
            }
        }
    })
}
// 保存请求单
function Save() {
    var reqId = ReqId;
    var reqTypeId = $("#cmbReqType").combobox("getValue");
    var reqMainData = ReqMainParams();
    if (reqMainData == "") {
        return;
    }
    var reqItmData = ReqItmParams();
    if (reqItmData == "") {
        return;
    }
    var saveRet = tkMakeServerCall("web.DHCINPHA.WardBaseDrug", "SaveReq", reqId, reqMainData, reqItmData, reqTypeId);
    var saveRetArr = saveRet.split("^");
    if (saveRetArr[0] < 0) {
        $.messager.alert("提示", saveRetArr[1], "warning");
        return;
    } else {
        ReqId = saveRetArr[1];
        SetTransReqData();
    }
}

function ReqMainParams() {
    var reqLocId = $("#cmbReqLoc").combobox("getValue") || "";
    var proLocId = $("#cmbProLoc").combobox("getValue") || "";
    if (proLocId == "") {
        $.messager.alert("提示", "请先选择供给科室", "warning");
        return "";
    }
    var userId = SessionUser;
    var stkGrpId = "";
    var remarks = "";
    return proLocId + "^" + reqLocId + "^" + userId + "^" + stkGrpId + "^" + "O" + "^" + remarks;
}

function ReqItmParams() {
    var delim = String.fromCharCode(1);
    $('#gridTransReqItm').datagrid('endEditing');
    var gridChanges = $('#gridTransReqItm').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("提示", "没有需要保存的数据", "warning");
        return "";
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var reqItmId = (iData.reqItmId || "");
        var incRowId = (iData.incRowId || "");
        var reqUomId = (iData.reqUomId || "");
        var reqQty = (iData.reqQty || "");
        if (incRowId == "") {
            continue;
        }
        if (reqUomId == "") {
            continue;
        }
        if (reqQty == "") {
            continue;
        }
        var params = reqItmId + "^" + incRowId + "^" + reqUomId + "^" + reqQty;
        paramsStr = (paramsStr == "") ? params : paramsStr + delim + params;
    }
    return paramsStr;
}
// 完成\取消完成
function Finish(type) {
    if (ReqId == "") {
        $.messager.alert("提示", "尚未建单", "warning");
    }
    var finRet = tkMakeServerCall("web.DHCINPHA.WardBaseDrug", "Finish", ReqId, type);
    var finRetArr = finRet.split("^");
    if (finRetArr[0] < 0) {
        $.messager.alert("提示", finRetArr[1], "warning");
        return;
    } else {
        SetTransReqData();
    }
}
// 验证是否重复
function CheckExistInc(incRowId) {
    var rows = $("#gridTransReqItm").datagrid("getRows");
    var rowsLen = rows.length;
    for (var rowI = 0; rowI < rowsLen; rowI++) {
        var rowincRowId = rows[rowI].incRowId || "";
        if (rowincRowId == incRowId) {
            return true;
        }
    }
    return false;
}

// editor事件,后期需封装
function GridEditorEvents() {
    var editIndex = $("#gridTransReqItm").datagrid('options').editIndex;
    if (editIndex == undefined) {
        return;
    }
    // 绑定事件
    var reqQtyEd = $("#gridTransReqItm").datagrid('getEditor', { index: editIndex, field: 'reqQty' });
    $(reqQtyEd.target).on("keypress", function(event) {
        if (event.keyCode == "13") {
            AddNewRow();
        }
    });
}
// 清屏
function Clear() {
    $("#gridTransReqItm").datagrid("clear");
    $("#txtReqNo").val("");
    ReqId = "";
    LoadReqId = "";
}