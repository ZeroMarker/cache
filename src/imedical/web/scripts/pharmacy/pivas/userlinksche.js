/**
 * 模块:     排班管理-人员班次对照
 * 编写日期: 2019-01-14
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
$(function() {
    InitDict();
    InitGridUser();
    InitGridSche();
    InitGridUserSche();
    InitGridUserScheFix();
    InitGridUserScheDate();
    InitKalendae();
    $('.dhcpha-win-mask').remove();
    
    $('#btnAdd').on("click", function() {
        var gridSelect = $("#gridUser").datagrid("getSelected");
        if (gridSelect == null) {
            $.messager.alert("提示", "请先选择需要增加班次的人员", "warning");
            return;
        }
        var locId=$("#cmbPivaLoc").combobox("getValue");
        var userId=gridSelect.userId||"";
        $('#gridScheWin').window({ 'title': "选择班次"  })
    	$('#gridScheWin').window('open');
		$('#gridSche').datagrid("query", { inputStr: locId+"^"+userId}); 

    });
    $('#btnDelete').on("click", function() {
        Delete("gridUserSche");
    });
    
	$('#txtAlias').on('keypress', function(event) {
        if (event.keyCode == "13") {
            QueryUser();
        }
    });
    
    $("#btnAddFix").on("click", function() {
        MainTainFix("A");
    });
    $("#btnEditFix").on("click", function() {
        MainTainFix("U");
    });
    $("#btnDeleteFix").on("click", function() {
        Delete("gridUserScheFix");
    });
    
    
    $('#btnAddDate').on("click", function() {
        var gridSelect = $("#gridUser").datagrid("getSelected");
        if (gridSelect == null) {
            $.messager.alert("提示", "请先选择需要增加班次的人员", "warning");
            return;
        }
        $("#gridUserScheDate").datagrid('addNewRow', {
            editField: 'userStDate'
        });
    });
    $('#btnSaveDate').on("click", SaveUserDate);
    $('#btnDeleteDate').on("click", DeleteUserDate);
    
});

function InitDict() {
    PIVAS.ComboBox.Init({ Id: "cmbPivaLoc", Type: "PivaLoc" }, {
        onLoadSuccess: function() {
            var datas = $("#cmbPivaLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPivaLoc").combobox("select", datas[i].RowId);
                }
            }
        },
        onSelect: function(selData) {
            $('#gridUser').datagrid("query", { inputStr: selData.RowId });
        },
        editable: false,
        placeholder: "配液中心...",
        width: 200
    });
    var thisYear = (new Date()).getFullYear();
    var weekDays = [];
    for (var i = 1; i < 8; i++) {
        weekDays.push({ RowId: i, Description: i });
    }
    var monthDays = [];
    for (var i = 1; i < 32; i++) {
        monthDays.push({ RowId: i, Description: i });
    }
    var monthEndDays = [];
    for (var i = 1; i < 5; i++) {
        monthEndDays.push({ RowId: i, Description: i });
    }

    PIVAS.ComboBox.Init({
        Id: "cmbWeekDays",
        data: {
            data: weekDays
        }
    }, {
        editable: false,
        multiple: true,
        mode: "local",
        width: 200
    });
    PIVAS.ComboBox.Init({
        Id: "cmbMonthDays",
        data: {
            data: monthDays
        }
    }, {
        editable: false,
        multiple: true,
        mode: "local",
        width: 200
    });
    PIVAS.ComboBox.Init({
        Id: "cmbMonthEndDays",
        data: {
            data: monthEndDays
        }
    }, {
        editable: false,
        multiple: true,
        mode: "local",
        width: 200
    });
    PIVAS.ComboBox.Init({ Id: "cmbSchedul", Type: "PIVASchedul" }, {
        editable: false,
        placeholder: "班次...",
        width: 200,
        onBeforeLoad: function(param) {
            param.inputStr = $("#cmbPivaLoc").combobox("getValue") || "";
            param.filterText = param.q;
        }
    });
}


function InitGridUser() {
    var columns = [
        [
            { field: "userId", title: 'userId', hidden: true, width: 100 },
            {
                field: "userCode",
                title: '工号',
                width: 100
            },
            {
                field: "userName",
                title: '姓名',
                width: 150
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.UserLinkSche',
            QueryName: 'PIVAUser',
            inputStr:SessionLoc
        },
        columns: columns,
        pagination: false,
        toolbar: "#gridUserBar",
        fitColumns: true,
        onClickRow: function(rowIndex, rowData) {
            var userId = rowData.userId || "";
			var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
			if (pivaLocId == "") {
				$.messager.alert("提示", "请先选择配液中心", "warning");
				return;
			}          
            if (userId != "") {
               QueryUserSche();
               QueryUserScheFix();
               QueryUserScheDate();
            }
        },
        onLoadSuccess: function() {
            $("#gridUserSche").datagrid("clear");
            $("#gridUserScheFix").datagrid("clear");
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridUser", dataGridOption);
}
function InitGridSche() {
    var columns = [
        [
            { field: "psId", title: 'psId', hidden: true, width: 100 },
            { field: "gridScheChk",  checkbox:true},
            {
                field: "psCode",
                title: '班次代码',
                width: 100
            },
            {
                field: "psDesc",
                title: '班次名称',
                width: 150
            },
            {
                field: "psCheck",
                title: '关联',
                width: 50,
                hidden:true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.UserLinkSche',
            QueryName: 'Schedul',
            inputStr:""
        },
        columns: columns,
        pagination: false,
        singleSelect:false,
        fitColumns: true,
        onClickRow: function(rowIndex, rowData) {

        },
        onLoadSuccess: function() {
			$("#gridSche").datagrid("uncheckAll");
			var rowsData=$("#gridSche").datagrid("getRows");
			var rowsLen=rowsData.length;
			for (var i=0;i<rowsLen;i++){
				var rowData=rowsData[i];
				var psCheck=rowData.psCheck||"";
				if (psCheck=="Y"){
					$("#gridSche").datagrid("checkRow",i);
				}else{
					$("#gridSche").datagrid("uncheckRow",i);
				}
			}
			
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridSche", dataGridOption);
}

function InitGridUserSche() {
    var columns = [
        [
            { field: "pusId", title: '人员班次对照Id', hidden: true, width: 100 },
            {
                field: "psCode",
                title: '班次代码',
                width: 100
            },
            {
                field: "psDesc",
                title: '班次名称',
                width: 150
            },
            {
                field: "psDuration",
                title: '工作时长(小时)',
                width: 110
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.UserLinkSche',
            QueryName: 'UserSchedul'
        },
        fitColumns: true,
        toolbar: "#gridUserScheBar",
        columns: columns,
        pagination: false,
        onClickRow: function(rowIndex, rowData) {

        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridUserSche", dataGridOption);
}

// 固定班次
function InitGridUserScheFix() {
    var columns = [
        [{
                field: "pusId",
                title: 'pusId',
                halign: 'center',
                width: 110,
                hidden: true
            }, {
                field: "userId",
                title: 'userId',
                halign: 'center',
                width: 110,
                hidden: true
            }, {
                field: "psDesc",
                title: '班次名称',
                width: 110,
                hidden: false
            },
            {
                field: "pusTypeDesc",
                title: '固定方式',
                width: 110
            },
            {
                field: "pusDaysHtml",
                title: '固定规则',
                width: 500
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.UserLinkSche',
            QueryName: 'UserSchedul'
        },
        //fitColumns: true,
        toolbar: "#gridUserScheFixBar",
        columns: columns,
        pagination: false,
        nowrap: false,
        onClickRow: function(rowIndex, rowData) {},
        onLoadSuccess: function() {
            DHCPHA_HUI_COM.Grid.MergeCell({
                GridId: "gridUserScheFix",
                MergeFields: ["psDesc"],
                Field: "psDesc"
            });
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridUserScheFix", dataGridOption);
}
// 查询
function QueryUser() {
	var locId=$("#cmbPivaLoc").combobox("getValue");
	var alias=$("#txtAlias").val();
	$("#txtAlias").val("");
    $("#gridUser").datagrid('query', {
        inputStr: locId + "^" + alias
    });	
}
// 查询明细
function QueryUserSche() {
    var gridSelect = $("#gridUser").datagrid("getSelected");
    var userId = gridSelect.userId;
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("提示", "请先选择配液中心", "warning");
        return;
    }
    $("#gridUserSche").datagrid('query', {
        inputStr: userId+"^"+"N"
    });
}

// 查询明细固定班次
function QueryUserScheFix() {
    var gridSelect = $("#gridUser").datagrid("getSelected");
    var userId = gridSelect.userId;
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("提示", "请先选择配液中心", "warning");
        return;
    }
    $("#gridUserScheFix").datagrid('query', {
        inputStr: userId + "^" + "M,ME,W,D"
    });
}
// 查询休息班次
function QueryUserScheDate() {
    var gridSelect = $("#gridUser").datagrid("getSelected");
    var userId = gridSelect.userId;
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("提示", "请先选择配液中心", "warning");
        return;
    }
    $("#gridUserScheDate").datagrid('query', {
        inputStr: pivaLocId + "^" + userId
    });
}
function SaveUserSche() {
    var gridSelect = $("#gridUser").datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请先选择需要增加班次的人员", "warning");
        return;
    }
    var userId = gridSelect.userId || "";
    if (userId == "") {
        $.messager.alert("提示", "获取不到人员Id", "warning");
        return;
    }
    var gridScheSelect = $('#gridSche').datagrid('getChecked');
	var psIdArr=[];
	if (gridScheSelect){
		for (var i=0;i<gridScheSelect.length;i++){
			var iData=gridScheSelect[i];
			var psId=iData.psId||"";
			if (psId==""){
				continue;
			}
			psIdArr.push(psId);
		}
	}
	var psIdStr=psIdArr.join("^");
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.UserLinkSche", "Save", userId,psIdStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
    }
    $('#gridUserSche').datagrid("reload");
    $('#gridScheWin').window('close');
}

// 删除岗位班次
function Delete(gridId) {
    var $_grid = $('#' + gridId);
    var gridSelect = $_grid.datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请选择需要删除的记录!", "warning");
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function(r) {
        if (r) {
            var pusId = gridSelect.pusId || "";
            var rowIndex = $_grid.datagrid('getRowIndex', gridSelect);
            if (pusId != "") {
                var delRet = tkMakeServerCall("web.DHCSTPIVAS.UserLinkSche", "Delete", pusId);
                var delRetArr = delRet.split("^");
                var delValue = delRetArr[0];
                if (delValue < 0) {
                    $.messager.alert("提示", delRetArr[1], "warning");
                    return;
                }
            }
            $_grid.datagrid("deleteRow", rowIndex);
            QueryUserScheFix();
            QueryUserSche();
        }
    })
}

/// 维护固定规则
function MainTainFix(type) {
    var gridSelect = $('#gridUser').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert("提示", "请先选择需要增加固定班次的人员", "warning");
        return;
    }
    var gridFixSelect = $('#gridUserScheFix').datagrid('getSelected');
    if ((type == "U") && (gridFixSelect == null)) {
        $.messager.alert("提示", "请先选择需要编辑固定班次", "warning");
        return;
    }
    ClearMainTain();
    if (type == "A") {

    } else {
        var inputStr = gridSelect.userId + "^" + "M,ME,W,D" + "^" + gridFixSelect.psId;
        AddScheFixFixData(inputStr);
        $("#cmbSchedul").combobox("setValue", gridFixSelect.psId);
    }
    $('#gridUserScheFixWin').window({ 'title': "固定班次" + ((type == "A") ? "新增" : "编辑") })
    $('#gridUserScheFixWin').window('open');
}

function ClearMainTain() {
    $("#idMonthDays").val("");
    $("#idMonthEndDays").val("");
    $("#idWeekDays").val("");
    $("#idDays").val("");
    $("#cmbMonthDays").combobox("clear");
    $("#cmbMonthEndDays").combobox("clear");
    $("#cmbWeekDays").combobox("clear");
    $("#cmbSchedul").combobox("clear");
    $("#kalSelect").val("");
    $("#cmbSchedul").combobox("reload");
}
/// 填充编辑信息
function AddScheFixFixData(inputStr) {
    var pusRetData = $.cm({
        ClassName: "web.DHCSTPIVAS.UserLinkSche",
        QueryName: "UserSchedul",
        inputStr: inputStr,
        ResultSetType: "array"
    }, false);
    var pusLen = pusRetData.length;
    for (var i = 0; i < pusLen; i++) {
        var iJson = pusRetData[i];
        var pusId = iJson.pusId;
        if (iJson.pusType == "M") {
            $("#cmbMonthDays").combobox("setValues", (iJson.pusDays).split(","));
            $("#idMonthDays").val(pusId);
        } else if (iJson.pusType == "ME") {
            $("#cmbMonthEndDays").combobox("setValues", (iJson.pusDays).split(","));
            $("#idMonthEndDays").val(pusId);
        } else if (iJson.pusType == "W") {
            $("#cmbWeekDays").combobox("setValues", (iJson.pusDays).split(","));
            $("#idWeekDays").val(pusId);
        } else if (iJson.pusType == "D") {
            $("#kalSelect").val(iJson.pusDaysHtml);
            $("#idDays").val(pusId);
        }
    }
}
// 保存固定班次
function SaveUserScheFix() {
    var gridSelect = $('#gridUser').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请先选择需要对照的人员", "warning");
        return;
    }
    var winTitle = $("#gridUserScheFixWin").panel('options').title;
    var pusId = "";
    if (winTitle.indexOf("增") >= 0) {
        pusId = "";
    } else {
        var gridFixSelect = $('#gridUserScheFix').datagrid("getSelected");
        if (gridFixSelect == null) {
            $.messager.alert("提示", "请先选择需要编辑的固定班次", "warning");
            return;
        }
        pusId = gridFixSelect.pusId;
    }
    var userId = gridSelect.userId;
    var psId = $("#cmbSchedul").combobox("getValue") || "";
    if (psId == "") {
        $.messager.alert("提示", "请先选择班次", "warning");
        return;
    }
    var monthDays = $("#cmbMonthDays").combobox("getValues") || "";
    monthDays = monthDays.join(",");
    var monthEndDays = $("#cmbMonthEndDays").combobox("getValues") || "";
    monthEndDays = monthEndDays.join(",");
    var weekDays = $("#cmbWeekDays").combobox("getValues") || "";
    weekDays = weekDays.join(",");
    var days = $("#kalSelect").val();
    if ((monthDays == "") && (monthEndDays == "") && (weekDays == "") && (days == "")) {
        $.messager.alert("提示", "固定班次条件全部为空", "warning");
        return;
    };
    var mParams = ($("#idMonthDays").val() || "") + "^" + userId + "^" + psId + "^" + "M" + "^" + monthDays;
    var meParams = ($("#idMonthEndDays").val() || "") + "^" + userId + "^" + psId + "^" + "ME" + "^" + monthEndDays;
    var wParams = ($("#idWeekDays").val() || "") + "^" + userId + "^" + psId + "^" + "W" + "^" + weekDays;
    var dParams = ($("#idDays").val() || "") + "^" + userId + "^" + psId + "^" + "D" + "^" + days;
    var paramsStr = mParams + "!!" + meParams + "!!" + wParams + "!!" + dParams;
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.UserLinkSche", "SaveMultiFix", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
    }
    $('#gridUserScheFixWin').window('close');
    $('#gridUserScheFix').datagrid("reload");
}
function InitKalendae() {
    //Kalendae.prototype.
    //Language.prototype._month = "一月1_二1月_三1月_四1月_五1月_六1月_七1_八月_九月_十月_十一月_十二月".split("_")
    $("#kalSelect").kalendae({
        months: 1,
        mode: 'multiple',
        dayHeaderClickable: true,
        disabled:true,
        dayAttributeFormat: (dtseparator.indexOf("-")>=0)?"YYYY-MM-DD":"DD/MM/YYYY",
        format: (dtseparator.indexOf("-")>=0)?"YYYY-MM-DD":"DD/MM/YYYY",

    })
}


//休息班次
function InitGridUserScheDate() {
    var columns = [
        [
            { field: "pusRowId", title: 'pusRowId', width: 100,hidden:true },
            
            {
                field: "userStDate",
                title: '开始日期',
                width: 200,
                editor: {
                    type: 'datebox',
                    options: {
                        required: true,
                        showSeconds: true,
                        validType:'validDate[\'yyyy-MM-dd\']'
                    }
                }
            },
             {
                field: "Days",
                title: '间隔天数',
                width: 200,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            }
            
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.UserLinkSche',
            QueryName: 'UserScheDate'
        },
        columns: columns,
        toolbar: "#gridUserScheDateBar",
        fitColumns:true,
        onDblClickRow: function(rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'userStDate'
                });
            }
        },
        onClickRow: function(rowIndex, rowData) {
			$(this).datagrid('endEditing');	        
        }
        
    };
    DHCPHA_HUI_COM.Grid.Init("gridUserScheDate", dataGridOption);
}
//保存人员休息
function SaveUserDate(){
	var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("提示", "请先选择配液中心", "warning");
        return;
    }
	var gridSelect = $('#gridUser').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请先选择需要对照的人员", "warning");
        return;
    }
    var userId = gridSelect.userId;
    $('#gridUserScheDate').datagrid('endEditing');
    
    var gridChanges = $('#gridUserScheDate').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("提示", "没有需要保存的数据", "warning");
        return;
    }
     if (gridChangeLen > 1) {
        $.messager.alert("提示", "请保存一行", "warning");
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        if ($('#gridUserScheDate').datagrid('getRowIndex', iData) < 0) {
            continue;
        }
        var userStDate = (iData.userStDate || "")
        var days = (iData.Days || "") 
        var paramsStr =  pivaLocId + "^" +userId + "^" + userStDate + "^" + days;
        if (userStDate === '' || days === '') {
	    	$.messager.alert("提示", "请将必填项信息录入完整", "warning");
        	return;
	    }
    }
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.UserLinkSche", "SaveUserDate", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
    }
    $('#gridUserScheDate').datagrid("reload");
}
//删除人员休息
function DeleteUserDate() {
    var gridSelect = $('#gridUserScheDate').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请选择需要删除的记录!", "warning");
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function(r) {
        if (r) {
            var pusRowId = gridSelect.pusRowId || "";
            var rowIndex = $('#gridUserScheDate').datagrid('getRowIndex', gridSelect);
            if (pusRowId != "") {
                var delRet = tkMakeServerCall("web.DHCSTPIVAS.UserLinkSche", "DeleteUserDate", pusRowId);
                var delRetArr = delRet.split("^");
                var delValue = delRetArr[0];
                if (delValue < 0) {
                    $.messager.alert("提示", delRetArr[1], "warning");
                    return;
                }
            }
            $('#gridUserScheDate').datagrid("deleteRow", rowIndex);
        }
    })
}
