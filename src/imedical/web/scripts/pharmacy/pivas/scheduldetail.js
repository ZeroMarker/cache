/**
 * 模块:     排班管理-排班详情
 * 编写日期: 2018-07-06
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function() {
    InitDict();
    InitGridSchedul();
    $('#btnSave').on("click", ConfirmSave);
    $('#menuDeleteItm').on('click', DeleteItm);
    $('#menuEditItm').on('click', function() {
        MainTainItm("U");
    });
    $('#menuAddItm').on('click', function() {
        MainTainItm("A");
    });
    $('.dhcpha-win-mask').remove();

    //setTimeout(Query, 100);
});

function InitDict() {
    var thisYear = (new Date()).getFullYear();
    var thisMonth = (new Date()).getMonth();
    var years = [
        { RowId: thisYear + 1, Description: thisYear - 1 + "年" },
        { RowId: thisYear, Description: thisYear + "年" },
        { RowId: thisYear + 1, Description: thisYear + 1 + "年" }
    ];
    PIVAS.ComboBox.Init({
        Id: "cmbYear",
        data: {
            data: years
        }
    }, {
        editable: false,
        multiple: false,
        mode: "local",
        placeholder: "年份...",
        onSelect: function() {
            InitGridSchedul();
        }
    });
    $("#cmbYear").combobox("setValue", thisYear);
    var months = [];
    for (var i = 1; i < 13; i++) {
        months.push({ RowId: i, Description: i + "月" });
    }
    PIVAS.ComboBox.Init({
        Id: "cmbMonth",
        data: {
            data: months
        }
    }, {
        editable: false,
        multiple: false,
        mode: "local",
        placeholder: "月份...",
        onSelect: function() {
            InitGridSchedul();
        }
    });
    $("#cmbMonth").combobox("setValue", (thisMonth + 1));
    PIVAS.ComboBox.Init({ Id: "cmbSchedul", Type: "PIVASchedul" }, {
        editable: false,
        onBeforeLoad: function(param) {
            param.inputStr = SessionLoc
            param.filterText = param.q;
        }
    });
    PIVAS.ComboBox.Init({ Id: "cmbUser", Type: "LocUser" }, {
        onBeforeLoad: function(param) {
            param.inputStr = SessionLoc+"^Y"
            param.filterText = param.q;
        }
    });
}

function InitGridSchedul() {
    var year = $("#cmbYear").combobox("getValue") || "";
    var month = $("#cmbMonth").combobox("getValue") || "";
    var colsStr = tkMakeServerCall("web.DHCSTPIVAS.SchedulDetail", "SchedulCols", year + "-" + month + "-" + "01")
    if (colsStr == "") {
        $.messager.alert("提示", "初始列失败", "warning");
        return;
    }
    var columnsArr = JSON.parse(colsStr);
    // 增加属性
    for (var colI = 0; colI < columnsArr.length; colI++) {
        var colIObj = columnsArr[colI];
        if ((colIObj.field).substring(0, 1) != "m") {
            continue;
        }
        colIObj.formatter = function(value, rowData, rowIndex) {
            return value.split("!!")[2];
        }
    }
    var columns = [columnsArr];
    var frozenColumns = [
        [{
            field: "dutyDesc",
            title: '岗位',
            hidden:true,
            width: 100
        },{
            field: "userName",
            title: '人员姓名',
            width: 100
        }]
    ]
    var dataGridOption = {
        url: null,
        frozenColumns: frozenColumns,
        columns: columns,
        toolbar: "#gridSchedulBar",
        border: false,
        pagination: false,
        gridSave:false,
        onClickRow: function(rowIndex, rowData) {
			
        },
        onLoadSuccess: function() {
            DHCPHA_HUI_COM.Grid.MergeCell({
                GridId: 'gridSchedul',
                Field: 'userName',
                MergeFields: ['userName']
            });
            $("#gridSchedul").datagrid("enableCellSelecting")
         
        },
        onRowContextMenu: function(e, rowIndex, rowData) {
            e.preventDefault(); //阻止向上冒泡
            var field = $(e.target).closest("td").attr("field")
            if (field.substring(0, 1) != "m") {
                return false;
            }
            $('#gridSchedul').datagrid('gotoCell', {
                index: rowIndex,
                field: field
            });
            $('#menuScheDetail').menu('show', {
                left: e.pageX,
                top: e.pageY
            });
        },
	 	rowStyler: function(index,row){
			if ((row.dutyDesc)%2==0) {
				return 'background-color:#f8f8f8;color:black;';
			}else{
				return '';
			}
		
		}

    };
    DHCPHA_HUI_COM.Grid.Init("gridSchedul", dataGridOption);
    setTimeout(Query, 100);
}

// 查询
function Query() {
    var year = $("#cmbYear").combobox("getValue") || "";
    var month = $("#cmbMonth").combobox("getValue") || "";
    if (year == "") {
        $.messager.alert("提示", "请先选择年份", "warning");
        return;
    }
    if (month == "") {
        $.messager.alert("提示", "请先选择月份", "warning");
        return;
    }
    var monthDate = year + "-" + month + "-01";
    var inputStr = SessionLoc + "^" + monthDate;
    $("#gridSchedul").datagrid({
        url: "DHCST.METHOD.BROKER.csp?ClassName=web.DHCSTPIVAS.SchedulDetail&MethodName=JsGetSchedulDetail",
        queryParams: {
            inputStr: inputStr
        },
    });
}

// 保存
function ConfirmSave() {
    var year = $("#cmbYear").combobox("getValue") || "";
    var month = $("#cmbMonth").combobox("getValue") || "";
    if (year == "") {
        $.messager.alert("提示", "请先选择年份", "warning");
        return;
    }
    if (month == "") {
        $.messager.alert("提示", "请先选择月份", "warning");
        return;
    }
    var monthDate = year + "-" + month + "-01";
    var inputStr = monthDate + "^" + SessionLoc + "^" + SessionUser;
    var chkRet = tkMakeServerCall("web.DHCSTPIVAS.AutoScheArrange", "CheckExistScheArr", SessionLoc, monthDate);
    if (chkRet.split("^")[0] < 0) {
        $.messager.confirm('确认对话框', chkRet.split("^")[1] + ',是否重新生成?', function(r) {
            if (r) {
                Save(inputStr);
            }
        })
    } else {
        Save(inputStr);
    }


}

// 生成排班
function Save(inputStr) {
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.AutoScheArrange", "AutoScheArrange", inputStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
    }
    Query();
}
// 增加修改班次
function MainTainItm(type) {
    var cellSelect = $("#gridSchedul").datagrid("getSelectedCells");
    if ((cellSelect == null) || (cellSelect == "")) {
        $.messager.alert("提示", "请先选中需要操作的单元格", "warning");
        return;
    }
    var fieldName = cellSelect[0].field;
    var rowIndex = cellSelect[0].index;
    if (dtseparator=='-'){
    	var selectDate = fieldName.substring(1, 5) + "-" + fieldName.substring(5, 7) + "-" + fieldName.substring(7, 9);
    }else{
		var selectDate = fieldName.substring(7, 9) + "/" + fieldName.substring(5, 7) + "/" + fieldName.substring(1, 5);
	}
    var rowData = $("#gridSchedul").datagrid("getRows")[rowIndex];
    var userId = rowData.userId;
    if (type == "A") {
	    
        $("#dateSchedul").datebox("setValue", selectDate);
        $("#cmbSchedul").combobox("clear");
        $("#cmbUser").combobox("setValue", userId);
    } else {

    }
    $('#gridSchedulWin').window({ 'title': "班次" + ((type == "A") ? "追加" : "编辑") })
    $('#gridSchedulWin').window('open');
}

// 保存人员排班
function SaveScheItm() {
    var cellSelect = $("#gridSchedul").datagrid("getSelectedCells");
    if ((cellSelect == null) || (cellSelect == "")) {
        $.messager.alert("提示", "请先选中需要修改的单元格", "warning");
        return;
    }
    var rowIndex = cellSelect[0].index;
    var field = cellSelect[0].field;
    var rowData = $("#gridSchedul").datagrid("getRows")[rowIndex];
    // 排班子表ID!!班次Id!!班次名称
    var psaId = rowData.psaId || "";
    var scheDate = $("#dateSchedul").datebox("getValue") || "";
    var shceId = $("#cmbSchedul").combobox("getValue") || "";
    var userId = $("#cmbUser").combobox("getValue") || "";
    if (psaId == "") {
        $.messager.alert("提示", "排班主表Id为空,请刷新重试", "warning");
        return;
    }
    if (scheDate == "") {
        $.messager.alert("提示", "请选择日期", "warning");
        return;
    }
    if (shceId == "") {
        $.messager.alert("提示", "请选择班次", "warning");
        return;
    }
    if (userId == "") {
        $.messager.alert("提示", "请选择人员", "warning");
        return;
    }
    var inputStr = psaId + "^" + scheDate + "^" + shceId + "^" + userId;
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.ScheArrange", "SaveScheArrItm", inputStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
        return;
    }
    $('#gridSchedulWin').window('close');
    Query();
}

// 删除排班
function DeleteItm() {
    var cellSelect = $("#gridSchedul").datagrid("getSelectedCells");
    if ((cellSelect == null) || (cellSelect == "")) {
        $.messager.alert("提示", "请先选中需要修改的单元格", "warning");
    }
    var rowIndex = cellSelect[0].index;
    var field = cellSelect[0].field;
    var rowData = $("#gridSchedul").datagrid("getRows")[rowIndex];
    // 排班子表ID!!班次Id!!班次名称
    var itmData = rowData[field];
    var delRet = tkMakeServerCall("web.DHCSTPIVAS.ScheArrange", "DeleteScheArrItm", itmData);
    var delArr = delRet.split("^");
    var delVal = delArr[0];
    var delInfo = delArr[1];
    if (delVal < 0) {
        $.messager.alert("提示", delInfo, "warning");
        return;
    }
    Query();
}
