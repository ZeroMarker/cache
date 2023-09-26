/**
 * ģ��:     ��Һ���̵��ݴ�ӡ��¼
 * ��д����: 2018-04-20
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
    InitDict();
    InitGridOrdExe();
    InitGridPrint();
    $('#btnFind').bind("click", Query);
    $('#btnPrint').bind("click", PrintSelect);
    $('#btnPrintAll').bind("click", PrintAll);
    $('#btnPrintArrange').bind("click", PrintArrange);
    $('#btnPrintWardBat').bind("click", PrintWardBat);
    $('#btnClear').bind("click", Clear);
    $('#txtPatNo').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            var patNo = $('#txtPatNo').val();
            if (patNo == "") {
                return;
            }
            var patNo = PIVAS.PadZero(patNo, PIVAS.PatNoLength());
            $('#txtPatNo').val(patNo);
			Query();
        }
    });
    setTimeout(function(){
        getLodop();
    }, 2000);
    $(".dhcpha-win-mask").remove();
});

function InitDict() {
    // ����
    PIVAS.Date.Init({
        Id: 'datePrtStart',
        LocId: "",
        Type: 'Start',
        QueryType: 'Query'
    });
    PIVAS.Date.Init({
        Id: 'datePrtEnd',
        LocId: "",
        Type: 'End',
        QueryType: 'Query'
    });
    PIVAS.ComboBox.Init({
        Id: 'cmbPivasLoc',
        Type: 'PivaLoc'
    }, {
        editable: false,
        onLoadSuccess: function () {
            var datas = $("#cmbPivasLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPivasLoc").combobox("setValue", datas[i].RowId);
                    break;
                }
            }
        },
        onSelect: function (data) {
            var locId = data.RowId;
            PIVAS.ComboBox.Init({
                Id: 'cmbWorkType',
                Type: 'PIVAWorkType',
                StrParams: locId
            }, {
                "placeholder": "��Һ״̬..."
            });
            PIVAS.ComboBox.Init({
                Id: 'cmbPivaStat',
                Type: 'PIVAState'
            }, {
                editable: false
            });
        }
    });
    // ����
    PIVAS.ComboBox.Init({
        Id: 'cmbWard',
        Type: 'Ward'
    }, {
        placeholder: "����..."
    });
    PIVAS.ComboBox.Init({
        Id: 'cmbWorkType',
        Type: 'PIVAWorkType'
    }, {
        "placeholder": "������..."
    });
    PIVAS.ComboBox.Init({
        Id: 'cmbPivaStat',
        Type: 'PIVAState'
    }, {
        editable: false,
        "placeholder": "��Һ״̬..."
    });
}

// ֹͣǩҽ����ϸ�б�
function InitGridOrdExe() {
    var columns = [
        [{
                field: 'gridOrdExeChk',
                checkbox: true
            },
            {
                field: 'pNo',
                title: '���',
                width: 40
            },
            {
                field: "doseDateTime",
                title: '��ҩʱ��',
                width: 100
            },
            {
                field: "patInfo",
                title: '������Ϣ',
                width: 200
            },
            {
                field: "batNo",
                title: '����',
                width: 50
            },
            {
                field: 'incDescStr',
                title: 'ҩƷ��Ϣ',
                width: 300
            },
            {
                field: 'freqDesc',
                title: 'Ƶ��',
                width: 75
            },
            {
                field: 'instrDesc',
                title: '�÷�',
                width: 75
            },
            {
                field: 'priDesc',
                title: 'ҽ�����ȼ�',
                width: 80
            },
            {
                field: 'pogId',
                title: 'pogId',
                width: 80,
                hidden: true
            },
            {
                field: 'pid',
                title: 'pid',
                width: 40,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.PrintRecord",
            QueryName: "PrintDetail"
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        pageSize: 100,
        pageList: [100, 300, 500],
        toolbar:[],
        pagination: true,
        onLoadSuccess: function () {},
        onClickRow: function (rowIndex, rowData) {},
        onBeforeLoad: function (param) {
            ClearTmpGlobal();
        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
}
// ǩ��ϸ�б�
function InitGridPrint() {
    var columns = [
        [{
                field: 'psName',
                title: '��Һ״̬',
                width: 75,
                align:'center',
                styler: PIVAS.Grid.Styler.PivaState
            },
            {
                field: 'pogsNo',
                title: '���̵���',
                width: 170
            },
            {
                field: 'pogsUserName',
                title: '������',
                width: 90
            },
            {
                field: 'pogsDateTime',
                title: '����ʱ��',
                width: 155,
                align:'center'
            },
            {
                field: 'doseDateRange',
                title: '��ҩ���ڷ�Χ',
                width: 200,
                align:'center'
            }
        ]
    ];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.PrintRecord",
            QueryName: "PogsNoList"
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        toolbar:[],
        onLoadSuccess: function () {
            ClearTmpGlobal();
            $("#gridOrdExe").datagrid("clear").datagrid("unselectAll");
        },
        onClickRow: function (rowIndex, rowData) {
            var params = QueryParams();
            var pogsNo = rowData.pogsNo;
            $('#gridOrdExe').datagrid('query', {
                pogsNo: pogsNo,
                inputStr: params
            }).datagrid("unselectAll");
            
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridPrint", dataGridOption);
}
//��ѯ
function Query() {
    var params = QueryParams();
    $('#gridPrint').datagrid('query', {
        inputStr: params,
        rows:99999
    });
}

function QueryParams() {
    var prtStDate = $('#datePrtStart').datebox('getValue'); //��ʼ����
    var prtEdDate = $('#datePrtEnd').datebox('getValue'); //��ֹ����
    var prtStTime = $('#timePrtStart').timespinner('getValue');
    var prtEdTime = $('#timePrtEnd').timespinner('getValue');
    var locId = $('#cmbPivasLoc').combobox('getValue');
    var wardId = $('#cmbWard').combobox('getValue');
    var patNo = $("#txtPatNo").val().trim();
    var pNo = $("#txtPNo").val().trim();
    var workTypeId = $("#cmbWorkType").combobox("getValue");
    var psNumber = $("#cmbPivaStat").combobox("getValue");
    var params = locId + "^" + wardId + "^" + prtStDate + "^" + prtEdDate + "^" + prtStTime + "^" +
        prtEdTime + "^" + patNo + "^" + pNo + "^" + workTypeId + "^" + psNumber;
    return params;
}


function GetCheckedPogArr() {
    var pogArr = [];
    var gridChecked = $('#gridOrdExe').datagrid('getChecked');
    if (gridChecked == "") {
        $.messager.alert("��ʾ", "����ѡ���¼", "warning");
        return pogArr;
    }
    var cLen = gridChecked.length;
    for (var cI = 0; cI < cLen; cI++) {
        var pogId = gridChecked[cI].pogId;
        if (pogId == "") {
            continue;
        }
        if (pogArr.indexOf(pogId) < 0) {
            pogArr.push(pogId);
        }
    }
    return pogArr;
}

/// ��ӡ��ѡ
function PrintSelect() {
    var pogArr = GetCheckedPogArr();
    var pogLen = pogArr.length;
    if (pogLen == 0) {
        return;
    }
    PIVASPRINT.LabelsJsonByPogStr({
        pogStr: pogArr.join("^")
    });
}
/// ��ӡ����
function PrintAll() {
    var gridRows = $("#gridOrdExe").datagrid("getRows");
    if (gridRows.length == 0) {
        $.messager.alert("��ʾ", "���Ȳ�ѯ����ǩ��ϸ", "warning");
        return;
    }
    var pid = gridRows[0].pid;
    $.cm({
        ClassName: "web.DHCSTPIVAS.PrintRecord",
        MethodName: "JsonLabels",
        pid: pid
    }, function (retJson) {
        var retLen = retJson.length;
        if (retLen > 0) {
			PIVASLABEL.Print(retJson, '��');
//            PIVASPRINT.RePrint = "";
//            PIVASLODOP = getLodop();
//            // ����һ�����ٸ���ӡ����
//            var taskCnt = retLen / (PIVASPRINT.PrintNum);
//            taskCnt = Math.ceil(taskCnt);
//            PIVASPRINT.TaskCnt = taskCnt;
//            PIVASPRINT.LabelsJsonPrint(retLen, 0);

        }
    })

}
/// ����
function Clear() {
    ClearTmpGlobal();
    //window.location.reload();
    $("#cmbPivasLoc").combobox("select",SessionLoc);
    $("#cmbPivaStat").combobox("clear");
    $("#cmbWorkType").combobox("clear");
    $("#cmbWard").combobox("clear");
    PIVAS.Date.Init({
        Id: 'datePrtStart',
        LocId: "",
        Type: 'Start',
        QueryType: 'Query'
    });
    PIVAS.Date.Init({
        Id: 'datePrtEnd',
        LocId: "",
        Type: 'End',
        QueryType: 'Query'
    });
    $("#timePrtStart") .timespinner("setValue",""); 
    $("#timePrtEnd") .timespinner("setValue","");
    $("#txtPatNo").val("");
    $("#txtPNo").val("");
    $("#gridPrint").datagrid("clear");
    $("#gridOrdExe").datagrid("clear");
    
}
/// �����ʱglobal
function ClearTmpGlobal() {
    var gridRows = $("#gridOrdExe").datagrid("getRows");
    if (gridRows.length == 0) {
        return;
    }
    var pid = gridRows[0].pid;
    tkMakeServerCall("web.DHCSTPIVAS.PrintRecord", "KillPrintData", pid);
}
window.onbeforeunload = function () {
    ClearTmpGlobal();
}
function PrintArrange(){
	var gridSelect=$("#gridPrint").datagrid("getSelected");
	if(gridSelect==null){
        DHCPHA_HUI_COM.Msg.popover({
            msg: "����ѡ����Ҫ����ĵ��ݼ�¼",
            type: 'alert'
        });
		return;
	}
	var geneNo=gridSelect.pogsNo;
	if (geneNo==""){
        DHCPHA_HUI_COM.Msg.popover({
            msg: "û�е���,���ܽ��в���",
            type: 'alert'
        });
		return;	
	}
	PIVASPRINT.Arrange(geneNo,"","");
}
function PrintWardBat(){
	var gridSelect=$("#gridPrint").datagrid("getSelected");
	if(gridSelect==null){
        DHCPHA_HUI_COM.Msg.popover({
            msg: "����ѡ����Ҫ����ĵ��ݼ�¼",
            type: 'alert'
        });
		return;
	}
	var geneNo=gridSelect.pogsNo;
	var doseDateRange=gridSelect.doseDateRange;
	var doseDateRangeArr=doseDateRange.split(" �� ")
    var paramsArr = PIVASPRINT.DefaultParams.WardBat();
    paramsArr[0] = $("#cmbPivasLoc").combobox("getValue");
    paramsArr[20] = geneNo;
    var raqObj = {
        raqName: "DHCST_PIVAS_�������ӵ�.raq",
        raqParams: {
            startDate: doseDateRangeArr[0],
            endDate: doseDateRangeArr[1],
            userName: session['LOGON.USERNAME'],
            pivaLoc: $("#cmbPivasLoc").combobox("getValue"),
            hospDesc: PIVAS.Session.HOSPDESC,
            locDesc: $("#cmbPivasLoc").combobox("getText"),
            pogsNo: geneNo,
            inputStr: paramsArr.join("^"),
            pid: ""
        },
        isPreview: 1
    }
    PIVASPRINT.RaqPrint(raqObj);
}
