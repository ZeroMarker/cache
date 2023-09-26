/**
 * ģ��:     ��Һ�ܾ�
 * ��д����: 2018-03-23
 * ��д��:   dinghongying
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var hisPatNoLen = PIVAS.PatNoLength();
$(function() {
    InitDict();
    InitGridOrdExe();
    $('#btnFind').bind("click", Query);
    $('#btnRefuse').bind("click", Refuse);
    $('#btnCancel').bind("click", CancelRefuse);
    $('#txtPatNo').on('keypress', function(event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#txtPatNo").val());
            if (patNo != "") {
                patNo=PIVAS.FmtPatNo(patNo);
                $("#txtPatNo").val(patNo);
                Query();
            }
        }
    });
    // ���̵���
    $('#txtPrtNo').searchbox({
        searcher: function(value, name) {
            if (event.keyCode == 13) {
	            Query();
                return;
            };
            var pivaLocId = $('#cmbPivaLoc').combobox("getValue");
            var psNumber = ""; //$('#cmbPivaStat').combobox("getValue");
            PIVAS.PogsNoWindow({
                TargetId: 'txtPrtNo',
                PivaLocId: pivaLocId,
                PsNumber: psNumber
            });
        }
    });
    $(".dhcpha-win-mask").remove();
});

function InitDict() {
    //����
    PIVAS.Date.Init({ Id: 'datePrtStart', LocId: "", Type: 'Start', QueryType: 'Query' });
    PIVAS.Date.Init({ Id: 'datePrtEnd', LocId: "", Type: 'End', QueryType: 'Query' });
    PIVAS.Date.Init({ Id: 'dateOrdStart', LocId: "", Type: 'Start', QueryType: 'Query' });
    PIVAS.Date.Init({ Id: 'dateOrdEnd', LocId: "", Type: 'End', QueryType: 'Query' });
    //��Һ����
    PIVAS.ComboBox.Init({ Id: 'cmbPivaLoc', Type: 'PivaLoc' }, {
        editable: false,
        onLoadSuccess: function() {
            var datas = $("#cmbPivaLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPivaLoc").combobox("setValue", datas[i].RowId);
                    break;
                }
            }
        }
    });
    // ����
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
    // ҩƷ����
    PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { width: 254 });
    // ҽ�����ȼ�
    PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, {});
    // ����
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
    // ������
    PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, {});
    // �������
    PIVAS.ComboBox.Init({ Id: 'cmbPassResult', Type: 'PassResult' }, {});
    $('#cmbPassResult').combobox("setValue", "");
    // ����
    PIVAS.BatchNoCheckList({ Id: "DivBatNo", LocId: SessionLoc, Check: true, Pack: false });
    // ��������
    PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, {});
    // ��Һ�ܾ�
    PIVAS.ComboBox.Init({
        Id: 'cmbPivaRefuse',
        Type: 'YesOrNo',
        data: {
            data: [{ "RowId": "Y", "Description": "����Һ�ܾ�" }, { "RowId": "N", "Description": "δ��Һ�ܾ�" }]
        }
    }, {});
}

// ҽ����ϸ�б�
function InitGridOrdExe() {
    var columns = [
        [
            { field: 'ordExeSelect', checkbox: true },
            {
                field: 'warnInfo',
                title: '����',
                width: 75,
                styler: function(value, row, index) {
                    var colorStyle = "";
                    if (value.indexOf("��Һ�ܾ�") >= 0) {
                        colorStyle = "background:#F4868E;color:white;"
                    }
                    return colorStyle;
                }
            },
            { field: 'pid', title: 'pid', width: 50, hidden: true },
            { field: 'wardDesc', title: '����', width: 150, hidden: false },
            { field: 'doseDateTime', title: '��ҩʱ��', width: 100,align:'center' },
            { field: 'bedNo', title: '����', width: 75 },
            { field: 'patNo', title: '�ǼǺ�', width: 100 },
            { field: 'patName', title: '����', width: 100 },
            {
                field: 'batNo',
                title: '����',
                width: 50,
                styler: function(value, row, index) {
                    var colorStyle = '';
                    if (row.packFlag != "") {
                        colorStyle = PIVAS.Grid.CSS.BatchPack;
                    }
                    return colorStyle;
                }
            },
            {
                field: 'oeoriSign',
                title: '��',
                align:'center' ,
                width: 35,
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            { field: 'incDesc', title: 'ҩƷ', width: 250, styler: PIVAS.Grid.Styler.IncDesc },
            { field: 'incSpec', title: '���', width: 100 },
            { field: 'dosage', title: '����', width: 75 },
            { field: 'qty', title: '����', width: 50 },
            { field: 'freqDesc', title: 'Ƶ��', width: 75 },
            { field: 'instrucDesc', title: '�÷�', width: 80 },
            { field: 'bUomDesc', title: '��λ', width: 50 },
            { field: 'docName', title: 'ҽ��', width: 75, hidden:true },
            { field: "passResultDesc", title: '��˽��', width: 85 },
            { field: 'priDesc', title: '���ȼ�', width: 75 },
            { field: "packFlag", title: '���', width: 85, hidden: true },
            { field: 'ordRemark', title: '��ע', width: 75 },
            { field: "mDsp", title: 'mDsp', width: 70, hidden: true },
            { field: 'colColor', title: 'colColor', width: 50, hidden: true },
            { field: "pogId", title: 'pogId', width: 70, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: "",
        fitColumns: false,
        columns: columns,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageSize: 50,
        pageList: [50, 100, 300],
        toolbar: "#gridOrdExeBar",
        onLoadSuccess: function() {
            PIVAS.Grid.CellTip({
                TipArr: ['warnInfo'],
                ClassName: 'web.DHCSTPIVAS.Refuse',
                MethodName: 'RefuseInfo',
                TdField: 'pogId'
            });
        },
        rowStyler: function(index, rowData) {
			return PIVAS.Grid.RowStyler.Person(index, rowData, "patNo");
        },
        onCheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId
            });
        },
        onUncheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: false,
                Value: rowData.pogId
            });
        },
        onSelect: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId,
                Type: 'Select'
            });
        },
        onUnselect: function(rowIndex, rowData) {
            PIVAS.Grid.ClearSelections(this.id);
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
}

/// ��ѯ
function Query() {
    var params = QueryParams();
    $('#gridOrdExe').datagrid({
        url: PIVAS.URL.COMMON + '?action=JsGetRefuseDetail&params=' + params,
    });

}
/// �ܾ�
function Refuse() {
    $.messager.confirm('��ʾ', "��ȷ�Ͼܾ���Һ��?", function(r) {
        if (r) {
            var pogIdStr = GetPogIdStr("R");
            if (pogIdStr == "") {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: "�빴ѡ��Ҫ��Һ�ܾ���ҽ������",
                    type: 'alert'
                });
                return;
            }
            PIVAS.RefuseReasonWindow({ pogIdStr: pogIdStr, userId: SessionUser }, Query)
        }
    })
}
/// ȡ���ܾ�
function CancelRefuse() {
    $.messager.confirm('��ʾ', "��ȷ��ȡ���ܾ���?", function(r) {
        if (r) {
            var pogIdStr = GetPogIdStr("C");
            if (pogIdStr == "") {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: "�빴ѡ��Ҫȡ����Һ�ܾ���ҽ������",
                    type: 'alert'
                });
                return;
            }
            $.m({
                ClassName: "web.DHCSTPIVAS.Refuse",
                MethodName: "SaveData",
                pogIdStr: pogIdStr,
                userId: SessionUser,
                reasonId: "",
                exeType: "C"
            }, function(retData) {
                var retArr = retData.split("^");
                if (retArr[0] == -1) {
                    $.messager.alert('��ʾ', retArr[1], 'warning');
                } else if (retArr[0] < -1) {
                    $.messager.alert('��ʾ', retArr[1], 'error');
                }
                Query();
            });
        }
    })
}

// ��ȡѡ�е�ҽ����ϸPog��
function GetPogIdStr(ActionType) {
    var pogIdArr = [];
    var pogIdValidArr=[];
    var gridOrdExeChecked = $('#gridOrdExe').datagrid('getChecked');
    for (var i = 0; i < gridOrdExeChecked.length; i++) {
        var checkedData = gridOrdExeChecked[i];
        var pogId = checkedData.pogId;
        if (pogIdValidArr.indexOf(pogId) >=0) {
            continue;
        }
        if ((ActionType=="R")&&(checkedData.warnInfo=="��Һ�ܾ�")){
	        pogIdValidArr.push(pogId);
	    	continue;
	    }
        if ((ActionType=="C")&&(checkedData.warnInfo=="")){
	        pogIdValidArr.push(pogId);
	    	continue;
	    }
        if (pogIdArr.indexOf(pogId) < 0) {
            pogIdArr.push(pogId);
        }
    }
    return pogIdArr.join("^");
}
/// ��ȡ���
function QueryParams() {
    var paramsArr = [];
    var locId = $('#cmbPivaLoc').combobox('getValue') || ''; //  1-��������
    var dateOrdStart = $('#dateOrdStart').datebox('getValue'); //  2-��ҩ��ʼ����
    var dateOrdEnd = $('#dateOrdEnd').datebox('getValue'); //  3-��ҩ��������
    var datePrtStart = $('#datePrtStart').datebox('getValue'); //  4-��ǩ��ʼ����
    var datePrtEnd = $('#datePrtEnd').datebox('getValue'); //  5-��ǩ��������
    var locGrpId = $('#cmbLocGrp').combobox('getValue') || ''; //  6-������
    var wardId = $('#cmbWard').combobox('getValue') || ''; //  7-����
    var priority = $('#cmbPriority').combobox('getValue') || ''; //  8-ҽ�����ȼ�
    var passResult = $('#cmbPassResult').combobox('getValue') || ''; //  9-�������
    var patNo = $('#txtPatNo').val().trim(); // 10-�ǼǺ�
    var incId = $('#cmgIncItm').combobox('getValue') || ''; // 11-ҩƷ
    var workType = $('#cmbWorkType').combobox('getValue') || ''; // 12-������
    var prtNo = $('#txtPrtNo').searchbox('getValue'); // 13-���̵��ݺ�
    var batNoStr = "" // 14-����
    $("input[type=checkbox][name=batbox]").each(function() {
        if ($('#' + this.id).is(':checked')) {
            if (batNoStr == "") {
                batNoStr = this.value;
            } else {
                batNoStr = batNoStr + "," + this.value;
            }
        }
    });
    var pivaRefuse = $('#cmbPivaRefuse').combobox('getValue') || ''; // 15-��Һ�ܾ�
    var oeoreState = ""; // 16-ִ�м�¼״̬
    paramsArr[0] = locId;
    paramsArr[1] = dateOrdStart;
    paramsArr[2] = dateOrdEnd;
    paramsArr[3] = datePrtStart;
    paramsArr[4] = datePrtEnd;
    paramsArr[5] = locGrpId;
    paramsArr[6] = wardId;
    paramsArr[7] = priority;
    paramsArr[8] = passResult;
    paramsArr[9] = patNo;
    paramsArr[10] = incId;
    paramsArr[11] = workType;
    paramsArr[12] = prtNo;
    paramsArr[13] = batNoStr;
    paramsArr[14] = pivaRefuse;
    paramsArr[15] = oeoreState;
    return paramsArr.join("^");
}