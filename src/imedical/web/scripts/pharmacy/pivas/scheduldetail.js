/**
 * ģ��:     �Ű����-�Ű�����
 * ��д����: 2018-07-06
 * ��д��:   yunhaibao
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
        { RowId: thisYear + 1, Description: thisYear - 1 + "��" },
        { RowId: thisYear, Description: thisYear + "��" },
        { RowId: thisYear + 1, Description: thisYear + 1 + "��" }
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
        placeholder: "���...",
        onSelect: function() {
            InitGridSchedul();
        }
    });
    $("#cmbYear").combobox("setValue", thisYear);
    var months = [];
    for (var i = 1; i < 13; i++) {
        months.push({ RowId: i, Description: i + "��" });
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
        placeholder: "�·�...",
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
        $.messager.alert("��ʾ", "��ʼ��ʧ��", "warning");
        return;
    }
    var columnsArr = JSON.parse(colsStr);
    // ��������
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
            title: '��λ',
            hidden:true,
            width: 100
        },{
            field: "userName",
            title: '��Ա����',
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
            e.preventDefault(); //��ֹ����ð��
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

// ��ѯ
function Query() {
    var year = $("#cmbYear").combobox("getValue") || "";
    var month = $("#cmbMonth").combobox("getValue") || "";
    if (year == "") {
        $.messager.alert("��ʾ", "����ѡ�����", "warning");
        return;
    }
    if (month == "") {
        $.messager.alert("��ʾ", "����ѡ���·�", "warning");
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

// ����
function ConfirmSave() {
    var year = $("#cmbYear").combobox("getValue") || "";
    var month = $("#cmbMonth").combobox("getValue") || "";
    if (year == "") {
        $.messager.alert("��ʾ", "����ѡ�����", "warning");
        return;
    }
    if (month == "") {
        $.messager.alert("��ʾ", "����ѡ���·�", "warning");
        return;
    }
    var monthDate = year + "-" + month + "-01";
    var inputStr = monthDate + "^" + SessionLoc + "^" + SessionUser;
    var chkRet = tkMakeServerCall("web.DHCSTPIVAS.AutoScheArrange", "CheckExistScheArr", SessionLoc, monthDate);
    if (chkRet.split("^")[0] < 0) {
        $.messager.confirm('ȷ�϶Ի���', chkRet.split("^")[1] + ',�Ƿ���������?', function(r) {
            if (r) {
                Save(inputStr);
            }
        })
    } else {
        Save(inputStr);
    }


}

// �����Ű�
function Save(inputStr) {
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.AutoScheArrange", "AutoScheArrange", inputStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    Query();
}
// �����޸İ��
function MainTainItm(type) {
    var cellSelect = $("#gridSchedul").datagrid("getSelectedCells");
    if ((cellSelect == null) || (cellSelect == "")) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ�����ĵ�Ԫ��", "warning");
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
    $('#gridSchedulWin').window({ 'title': "���" + ((type == "A") ? "׷��" : "�༭") })
    $('#gridSchedulWin').window('open');
}

// ������Ա�Ű�
function SaveScheItm() {
    var cellSelect = $("#gridSchedul").datagrid("getSelectedCells");
    if ((cellSelect == null) || (cellSelect == "")) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ�޸ĵĵ�Ԫ��", "warning");
        return;
    }
    var rowIndex = cellSelect[0].index;
    var field = cellSelect[0].field;
    var rowData = $("#gridSchedul").datagrid("getRows")[rowIndex];
    // �Ű��ӱ�ID!!���Id!!�������
    var psaId = rowData.psaId || "";
    var scheDate = $("#dateSchedul").datebox("getValue") || "";
    var shceId = $("#cmbSchedul").combobox("getValue") || "";
    var userId = $("#cmbUser").combobox("getValue") || "";
    if (psaId == "") {
        $.messager.alert("��ʾ", "�Ű�����IdΪ��,��ˢ������", "warning");
        return;
    }
    if (scheDate == "") {
        $.messager.alert("��ʾ", "��ѡ������", "warning");
        return;
    }
    if (shceId == "") {
        $.messager.alert("��ʾ", "��ѡ����", "warning");
        return;
    }
    if (userId == "") {
        $.messager.alert("��ʾ", "��ѡ����Ա", "warning");
        return;
    }
    var inputStr = psaId + "^" + scheDate + "^" + shceId + "^" + userId;
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.ScheArrange", "SaveScheArrItm", inputStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
        return;
    }
    $('#gridSchedulWin').window('close');
    Query();
}

// ɾ���Ű�
function DeleteItm() {
    var cellSelect = $("#gridSchedul").datagrid("getSelectedCells");
    if ((cellSelect == null) || (cellSelect == "")) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ�޸ĵĵ�Ԫ��", "warning");
    }
    var rowIndex = cellSelect[0].index;
    var field = cellSelect[0].field;
    var rowData = $("#gridSchedul").datagrid("getRows")[rowIndex];
    // �Ű��ӱ�ID!!���Id!!�������
    var itmData = rowData[field];
    var delRet = tkMakeServerCall("web.DHCSTPIVAS.ScheArrange", "DeleteScheArrItm", itmData);
    var delArr = delRet.split("^");
    var delVal = delArr[0];
    var delInfo = delArr[1];
    if (delVal < 0) {
        $.messager.alert("��ʾ", delInfo, "warning");
        return;
    }
    Query();
}
