/**
 * 模块:     草药处方剂型配置
 * 编写日期: 2018-11-20
 * 编写人:   DingHongying
 * Modifier: hulihua(2019-01-14)
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function() {
	InitDict();
    InitGridConfig();
    $('#btnAdd').on("click", function() {
        MainTain("A");
    });
    $('#btnUpdate').on("click", function() {
        MainTain("U");
    });
    $('#btnDelete').on("click", DeleteHandler);
});
function InitDict() {
    $HUI.checkbox("#chkPresChk", {
        checked: true
    });
    $HUI.checkbox("#chkPatRep", {
        checked: false
    });
    $HUI.checkbox("#chkPrintDispSheet", {
        checked: false
    });
    $HUI.checkbox("#chkPrintPres", {
        checked: false
    });
    $HUI.checkbox("#chkCall", {
        checked: false
    });
    $HUI.checkbox("#chkScreen", {
        checked: false
    });
    $HUI.checkbox("#chkAllSend", {
        checked: false
    });
    $HUI.checkbox("#chkAgreeRet", {
        checked: false
    });
    DHCPHA.ComboBox.Init({ Id: "cmbCTLoc", Type: "DHCPhaLoc" }, {
        onSelect: function(selData) {
            $('#gridConfigtable').datagrid('query', { inputStr: selData.RowId });
        },
        editable: false,
        width: 150 ,
        placeholder: '药房科室...',
        onLoadSuccess: function() {
            var datas = $("#cmbCTLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbCTLoc").combobox("select", datas[i].RowId);
                    break;
                }
            }
        }
    });
    DHCPHA.ComboBox.Init({ Id: "cmbPresForm", Type: "PresForm" }, { editable: false, width: 150});
    DHCPHA.ComboBox.Init({ Id: "cmbPresChkSel", Type: "PresChkSel" }, { editable: false, width: 150});
    $("#cmbPresChkSel").combobox("clear")
    DHCPHA.ComboBox.Init({ Id: "cmbPrintLabSelect", Type: "PrintLabSelect" }, { editable: false, width: 150 });
    $("#cmbPrintLabSelect").combobox("clear")
}
function InitGridConfig() {
    var columns = [
        [
            { field: "rowId", title: 'rowId', hidden: true },
            { field: "ctlocDr", title: '药房Id', hidden: true },
            { field: 'ctloc', title: '药房科室', width: 120, sortable: 'true'},
            { field: "presFormDr", title: '处方剂型Id', hidden: true },
            { field: 'presForm', title: '处方剂型', width: 80 , sortable: 'true'},
            { field: 'presChkSelDr', title: '审方节点Id',hidden: true },
            { field: 'presChkSel', title: '审方节点', width: 120, sortable: 'true'},
            { field: 'printLabSelectDr', title: '打印用法标签Id',hidden: true },
            { field: 'printLabSelect', title: '打印用法标签', width: 100, sortable: 'true'},
            {
                field: 'presChkFlag',
                title: '审核处方',
                width: 90,
                sortable: 'true',
                align: 'center',
                formatter: FormatterYes
            },
            {
                field: 'patRepFlag',
                title: '患者报到',
                width: 90,
                align: 'center',
                formatter: FormatterYes
            },
            {
                field: 'printDispSheet',
                title: '打印调剂单',
                width: 90,
                sortable: 'true',
                align: 'center',
                formatter: FormatterYes
            },
            {
                field: 'printPresFlag',
                title: '打印处方',
                width: 90,
                sortable: 'true',
                align: 'center',
                formatter: FormatterYes
            },
            {
                field: 'callFlag',
                title: '叫号',
                align: 'center',
                width: 90,
                formatter: FormatterYes
            },
            {
                field: 'screenFlag',
                title: '上屏',
                align: 'center',
                width: 90,
                sortable: 'true',
                formatter: FormatterYes
            },
            {
                field: 'allSendFlag',
                title: '全送',
                align: 'center',
                width: 90,
                sortable: 'true',
                formatter: FormatterYes
            },
            {
                field: 'agreeRetFlag',
                title: '允许退药',
                align: 'center',
                width: 90,
                sortable: 'true',
                formatter: FormatterYes
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCPHACOM.ComConfig.HMPrescConfig',
            QueryName: 'Config'
        },
        columns: columns,
        toolbar: "#gridConfigtableBar",
        onDblClickRow: function(rowIndex) {
            MainTain("U");
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridConfigtable", dataGridOption);
}


function FormatterYes(value, row, index) {
    if (value == "Y") {
        return DHCPHA.Grid.CSS.Yes;
    }
}

function SaveConfig() {
    var winTitle = $("#gridConfigWin").panel('options').title;
    var Id = "";
    var presChkFlag = ($('#chkPresChk').is(':checked') == true) ? "Y" : "N";
    if(presChkFlag=="N"){
	    $("#cmbPresChkSel").combobox('setValue', "");
        $("#cmbPresChkSel").combobox('setText', "");
	}
    var patRepFlag = ($('#chkPatRep').is(':checked') == true) ? "Y" : "N";
    var printDispSheetFlag = ($('#chkPrintDispSheet ').is(':checked') == true) ? "Y" : "N"; 
    var printPresFlag = ($('#chkPrintPres ').is(':checked') == true) ? "Y" : "N";
    var callFlag = ($('#chkCall').is(':checked') == true) ? "Y" : "N";
    var screenFlag = ($('#chkScreen').is(':checked') == true) ? "Y" : "N";
    var locId = $("#cmbCTLoc").combobox("getValue");
    var presForm = $("#cmbPresForm").combobox("getValue");
    var presChkSel = $("#cmbPresChkSel").combobox("getValue");
    var printLabSelect = $("#cmbPrintLabSelect").combobox("getValue");
    if((presChkFlag=="Y")&&(presChkSel=="")){
	    $.messager.alert("提示", "请选择审方时刻!", "warning");
        return;
    }
    if (winTitle.indexOf("新增") >= 0) {} else {
	    var gridSelect = $('#gridConfigtable').datagrid('getSelected');
        Id = gridSelect.rowId;
    }
    var allSendFlag = ($('#chkAllSend').is(':checked') == true) ? "Y" : "N";
    var agreeRetFlag = ($('#chkAgreeRet').is(':checked') == true) ? "Y" : "N";
    
    var paramsData1=Id+"^"+locId+"^"+presForm+"^"+presChkFlag+"^"+presChkSel;						//5
    var paramsData2=patRepFlag+"^"+printPresFlag+"^"+printLabSelect+"^"+callFlag+"^"+ screenFlag;	//10
    var paramsData3=allSendFlag+"^"+agreeRetFlag+"^"+printDispSheetFlag;
    var params = paramsData1+"^"+paramsData2+"^"+paramsData3;
    var saveRet = tkMakeServerCall("web.DHCPHACOM.ComConfig.HMPrescConfig", "SaveConfig", params);
    var saveArr = saveRet.split("^");
    var saveValue = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveValue < 0) {
        $.messager.alert("提示", saveInfo, (saveValue == "-1") ? "warning" : "error");
        return;
    }
    $('#gridConfigWin').window('close');
    $('#gridConfigtable').datagrid("reload");

}

function MainTain(type) {
    var gridSelect = $('#gridConfigtable').datagrid('getSelected');
    if (type == "U") {
        if (gridSelect == null) {
            $.messager.alert("提示", "请先选中需要修改的记录!", "warning");
            return;
        }
        $("#cmbCTLoc").combobox('setValue', gridSelect.ctlocDr);
        $("#cmbCTLoc").combobox('setText', gridSelect.ctloc);
        $("#cmbPresForm").combobox('setValue', gridSelect.presFormDr);        
        $("#cmbPresForm").combobox('setText', gridSelect.presForm);
        $("#cmbPresChkSel").combobox('setValue', gridSelect.presChkSelDr);
        $("#cmbPresChkSel").combobox('setText', gridSelect.presChkSel);
        $("#cmbPrintLabSelect").combobox('setValue', gridSelect.printLabSelectDr);
        $("#cmbPrintLabSelect").combobox('setText', gridSelect.printLabSelect);
        $HUI.checkbox("#chkPresChk", { "checked": gridSelect.presChkFlag == "Y" ? true : false });
        $HUI.checkbox("#chkPatRep", { "checked": gridSelect.patRepFlag == "Y" ? true : false });
        $HUI.checkbox("#chkPrintDispSheet", { "checked": gridSelect.printDispSheet == "Y" ? true : false });
        $HUI.checkbox("#chkPrintPres", { "checked": gridSelect.printPresFlag == "Y" ? true : false });
        $HUI.checkbox("#chkCall", { "checked": gridSelect.callFlag == "Y" ? true : false });
        $HUI.checkbox("#chkScreen", { "checked": gridSelect.screenFlag == "Y" ? true : false });
        $HUI.checkbox("#chkAllSend", { "checked": gridSelect.allSendFlag == "Y" ? true : false });
        $HUI.checkbox("#chkAgreeRet", { "checked": gridSelect.agreeRetFlag == "Y" ? true : false });
    } else if (type = "A") {
	    $("#cmbCTLoc").combobox('clear');
        $("#cmbPresForm").combobox('clear');
        $("#cmbPresChkSel").combobox('clear');
        $("#cmbPrintLabSelect").combobox('clear');
        $HUI.checkbox("#chkPresChk", { "checked": false });
        $HUI.checkbox("#chkPatRep", { "checked": false });
        $HUI.checkbox("#chkPrintDispSheet", { "checked": false });
        $HUI.checkbox("#chkPrintPres", { "checked": false });
        $HUI.checkbox("#chkCall", { "checked": false });
        $HUI.checkbox("#chkScreen", { "checked": false });
        $HUI.checkbox("#chkAllSend", { "checked": false });
        $HUI.checkbox("#chkAgreeRet", { "checked": false });
    }
    $("#cmbCTLoc").combogrid((type == "A") ? 'enable' : 'disable', true)
    $("#cmbPresForm").combogrid((type == "A") ? 'enable' : 'disable', true)
    $('#gridConfigWin').window({ 'title': "移动药房配置" + ((type == "A") ? "新增" : "修改") })
    $('#gridConfigWin').window('open');
    
}

function DeleteHandler() {
    var gridSelect = $('#gridConfigtable').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请选择需要删除的记录!", "warning");
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function(r) {
        if (r) {
            var rowId = gridSelect.rowId || "";
            if (rowId == "") {
                var rowIndex = $('#gridConfigtable').datagrid('getRowIndex', gridSelect);
                $('#gridConfigtable').datagrid("deleteRow", rowIndex);
            } else {
                var delRet = tkMakeServerCall("web.DHCPHACOM.ComConfig.HMPrescConfig", "DeleteConfig", rowId);
                $('#gridConfigtable').datagrid("reload");
            }
        }
    })
}