/**
 * ģ��:     �Ű����-��Ա��ζ���
 * ��д����: 2019-01-14
 * ��д��:   yunhaibao
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
            $.messager.alert("��ʾ", "����ѡ����Ҫ���Ӱ�ε���Ա", "warning");
            return;
        }
        var locId=$("#cmbPivaLoc").combobox("getValue");
        var userId=gridSelect.userId||"";
        $('#gridScheWin').window({ 'title': "ѡ����"  })
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
            $.messager.alert("��ʾ", "����ѡ����Ҫ���Ӱ�ε���Ա", "warning");
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
        placeholder: "��Һ����...",
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
        placeholder: "���...",
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
                title: '����',
                width: 100
            },
            {
                field: "userName",
                title: '����',
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
				$.messager.alert("��ʾ", "����ѡ����Һ����", "warning");
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
                title: '��δ���',
                width: 100
            },
            {
                field: "psDesc",
                title: '�������',
                width: 150
            },
            {
                field: "psCheck",
                title: '����',
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
            { field: "pusId", title: '��Ա��ζ���Id', hidden: true, width: 100 },
            {
                field: "psCode",
                title: '��δ���',
                width: 100
            },
            {
                field: "psDesc",
                title: '�������',
                width: 150
            },
            {
                field: "psDuration",
                title: '����ʱ��(Сʱ)',
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

// �̶����
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
                title: '�������',
                width: 110,
                hidden: false
            },
            {
                field: "pusTypeDesc",
                title: '�̶���ʽ',
                width: 110
            },
            {
                field: "pusDaysHtml",
                title: '�̶�����',
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
// ��ѯ
function QueryUser() {
	var locId=$("#cmbPivaLoc").combobox("getValue");
	var alias=$("#txtAlias").val();
	$("#txtAlias").val("");
    $("#gridUser").datagrid('query', {
        inputStr: locId + "^" + alias
    });	
}
// ��ѯ��ϸ
function QueryUserSche() {
    var gridSelect = $("#gridUser").datagrid("getSelected");
    var userId = gridSelect.userId;
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("��ʾ", "����ѡ����Һ����", "warning");
        return;
    }
    $("#gridUserSche").datagrid('query', {
        inputStr: userId+"^"+"N"
    });
}

// ��ѯ��ϸ�̶����
function QueryUserScheFix() {
    var gridSelect = $("#gridUser").datagrid("getSelected");
    var userId = gridSelect.userId;
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("��ʾ", "����ѡ����Һ����", "warning");
        return;
    }
    $("#gridUserScheFix").datagrid('query', {
        inputStr: userId + "^" + "M,ME,W,D"
    });
}
// ��ѯ��Ϣ���
function QueryUserScheDate() {
    var gridSelect = $("#gridUser").datagrid("getSelected");
    var userId = gridSelect.userId;
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("��ʾ", "����ѡ����Һ����", "warning");
        return;
    }
    $("#gridUserScheDate").datagrid('query', {
        inputStr: pivaLocId + "^" + userId
    });
}
function SaveUserSche() {
    var gridSelect = $("#gridUser").datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ���Ӱ�ε���Ա", "warning");
        return;
    }
    var userId = gridSelect.userId || "";
    if (userId == "") {
        $.messager.alert("��ʾ", "��ȡ������ԱId", "warning");
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
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $('#gridUserSche').datagrid("reload");
    $('#gridScheWin').window('close');
}

// ɾ����λ���
function Delete(gridId) {
    var $_grid = $('#' + gridId);
    var gridSelect = $_grid.datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "��ѡ����Ҫɾ���ļ�¼!", "warning");
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function(r) {
        if (r) {
            var pusId = gridSelect.pusId || "";
            var rowIndex = $_grid.datagrid('getRowIndex', gridSelect);
            if (pusId != "") {
                var delRet = tkMakeServerCall("web.DHCSTPIVAS.UserLinkSche", "Delete", pusId);
                var delRetArr = delRet.split("^");
                var delValue = delRetArr[0];
                if (delValue < 0) {
                    $.messager.alert("��ʾ", delRetArr[1], "warning");
                    return;
                }
            }
            $_grid.datagrid("deleteRow", rowIndex);
            QueryUserScheFix();
            QueryUserSche();
        }
    })
}

/// ά���̶�����
function MainTainFix(type) {
    var gridSelect = $('#gridUser').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ���ӹ̶���ε���Ա", "warning");
        return;
    }
    var gridFixSelect = $('#gridUserScheFix').datagrid('getSelected');
    if ((type == "U") && (gridFixSelect == null)) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ�༭�̶����", "warning");
        return;
    }
    ClearMainTain();
    if (type == "A") {

    } else {
        var inputStr = gridSelect.userId + "^" + "M,ME,W,D" + "^" + gridFixSelect.psId;
        AddScheFixFixData(inputStr);
        $("#cmbSchedul").combobox("setValue", gridFixSelect.psId);
    }
    $('#gridUserScheFixWin').window({ 'title': "�̶����" + ((type == "A") ? "����" : "�༭") })
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
/// ���༭��Ϣ
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
// ����̶����
function SaveUserScheFix() {
    var gridSelect = $('#gridUser').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ���յ���Ա", "warning");
        return;
    }
    var winTitle = $("#gridUserScheFixWin").panel('options').title;
    var pusId = "";
    if (winTitle.indexOf("��") >= 0) {
        pusId = "";
    } else {
        var gridFixSelect = $('#gridUserScheFix').datagrid("getSelected");
        if (gridFixSelect == null) {
            $.messager.alert("��ʾ", "����ѡ����Ҫ�༭�Ĺ̶����", "warning");
            return;
        }
        pusId = gridFixSelect.pusId;
    }
    var userId = gridSelect.userId;
    var psId = $("#cmbSchedul").combobox("getValue") || "";
    if (psId == "") {
        $.messager.alert("��ʾ", "����ѡ����", "warning");
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
        $.messager.alert("��ʾ", "�̶��������ȫ��Ϊ��", "warning");
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
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $('#gridUserScheFixWin').window('close');
    $('#gridUserScheFix').datagrid("reload");
}
function InitKalendae() {
    //Kalendae.prototype.
    //Language.prototype._month = "һ��1_��1��_��1��_��1��_��1��_��1��_��1_����_����_ʮ��_ʮһ��_ʮ����".split("_")
    $("#kalSelect").kalendae({
        months: 1,
        mode: 'multiple',
        dayHeaderClickable: true,
        disabled:true,
        dayAttributeFormat: (dtseparator.indexOf("-")>=0)?"YYYY-MM-DD":"DD/MM/YYYY",
        format: (dtseparator.indexOf("-")>=0)?"YYYY-MM-DD":"DD/MM/YYYY",

    })
}


//��Ϣ���
function InitGridUserScheDate() {
    var columns = [
        [
            { field: "pusRowId", title: 'pusRowId', width: 100,hidden:true },
            
            {
                field: "userStDate",
                title: '��ʼ����',
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
                title: '�������',
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
//������Ա��Ϣ
function SaveUserDate(){
	var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("��ʾ", "����ѡ����Һ����", "warning");
        return;
    }
	var gridSelect = $('#gridUser').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ���յ���Ա", "warning");
        return;
    }
    var userId = gridSelect.userId;
    $('#gridUserScheDate').datagrid('endEditing');
    
    var gridChanges = $('#gridUserScheDate').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("��ʾ", "û����Ҫ���������", "warning");
        return;
    }
     if (gridChangeLen > 1) {
        $.messager.alert("��ʾ", "�뱣��һ��", "warning");
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
	    	$.messager.alert("��ʾ", "�뽫��������Ϣ¼������", "warning");
        	return;
	    }
    }
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.UserLinkSche", "SaveUserDate", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $('#gridUserScheDate').datagrid("reload");
}
//ɾ����Ա��Ϣ
function DeleteUserDate() {
    var gridSelect = $('#gridUserScheDate').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "��ѡ����Ҫɾ���ļ�¼!", "warning");
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function(r) {
        if (r) {
            var pusRowId = gridSelect.pusRowId || "";
            var rowIndex = $('#gridUserScheDate').datagrid('getRowIndex', gridSelect);
            if (pusRowId != "") {
                var delRet = tkMakeServerCall("web.DHCSTPIVAS.UserLinkSche", "DeleteUserDate", pusRowId);
                var delRetArr = delRet.split("^");
                var delValue = delRetArr[0];
                if (delValue < 0) {
                    $.messager.alert("��ʾ", delRetArr[1], "warning");
                    return;
                }
            }
            $('#gridUserScheDate').datagrid("deleteRow", rowIndex);
        }
    })
}
