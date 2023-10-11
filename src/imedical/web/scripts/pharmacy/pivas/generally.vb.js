/**
 * ģ��:     ��Һ�����ۺϲ�ѯ
 * ��д����: 2018-03-28
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var hisPatNoLen = PIVAS.PatNoLength();
var linkOrderCheck = "";
var GridCmbBatNo;
$(function() {
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridGenerally();
    $('#btnFind').on("click", Query);
    $('#btnPrtLabel').on("click", PrintLabelLodop) //PrintLabel);
    $('#btnPrtStopLabel').on("click", PrintStopLabel);
    // �ǼǺŻس��¼�
    $('#txtPatNo').on('keypress', function(event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#txtPatNo").val());
            if (patNo != "") {
                var patNo = PIVAS.PadZero(patNo, hisPatNoLen);
                $("#txtPatNo").val(patNo);
                Query();
            }
        }
    });
    // ����Żس��¼�
    $('#txtBarCode').on('keypress', function(event) {
        if (window.event.keyCode == "13") {
            var barCode = $.trim($("#txtBarCode").val());
            if (barCode != "") {
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
            var psNumber = $('#cmbPivaStat').combobox("getValue");
            PIVAS.PogsNoWindow({
                TargetId: 'txtPrtNo',
                PivaLocId: pivaLocId,
                PsNumber: psNumber
            });
        }
    });
    $("#txtPrtNo").next().find("input:first").attr("placeholder", " ���̵���...")
    InitPivasSettings();
})

function InitDict() {
    // ��Һ����
    PIVAS.ComboBox.Init({
        Id: 'cmbPivaLoc',
        Type: 'PivaLoc'
    }, {
        placeholder: "��Һ����...",
        editable: false,
        onLoadSuccess: function() {
            var datas = $("#cmbPivaLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPivaLoc").combobox("setValue", datas[i].RowId);
                    break;
                }
            }
        },
        onSelect: function(data) {
            var locId = data.RowId;
            $("#DivBatNo").html("");
            PIVAS.BatchNoCheckList({ Id: "DivBatNo", LocId: locId, Check: true, Pack: false });
        }
    });
    // ҽ�����ȼ�
    PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, { placeholder: "ҽ�����ȼ�..." });
    // ����
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, { placeholder: "����..." });
    // ������
    PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, { placeholder: "������..." });
    // �������
    PIVAS.ComboBox.Init({ Id: 'cmbPassResult', Type: 'PassResult' }, { placeholder: "�������..." });
    // ִ�м�¼״̬
    PIVAS.ComboBox.Init({ Id: 'cmbOeoreStat', Type: 'OrdStatus' }, { placeholder: "ִ�м�¼״̬..." });
    // �÷�
    PIVAS.ComboBox.Init({ Id: 'cmbInstruc', Type: 'Instruc' }, { "placeholder": "�÷�..." });
    // Ƶ��
    PIVAS.ComboBox.Init({ Id: 'cmbFreq', Type: 'Freq' }, { "placeholder": "Ƶ��..." });
    // ��Һ״̬
    PIVAS.ComboBox.Init({ Id: 'cmbPivaStat', Type: 'PIVAState' }, { "placeholder": "��Һ״̬..." });
    // �Ƿ��Ѵ�ӡֹͣǩ
    PIVAS.ComboBox.Init({
        Id: 'cmbPrintStop',
        Type: 'YesOrNo',
        data: {
            data: [{ "RowId": "Y", "Description": "�Ѵ�ӡֹͣǩ" }, { "RowId": "N", "Description": "δ��ӡֹͣǩ" }]
        }
    }, {
        "placeholder": "ֹͣǩ��ӡ..."
    });
    // ҩƷ
    PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { placeholder: "ҩƷ..." }); // width: 315
    // ����
    PIVAS.ComboBox.Init({ Id: 'cmbBatNo', Type: 'Batch' }, { multiple: true });
    // �Ƿ�ܾ���Һ
    PIVAS.ComboBox.Init({
        Id: 'cmbPivaRefuse',
        Type: 'YesOrNo',
        data: {
            data: [{ "RowId": "Y", "Description": "����Һ�ܾ�" }, { "RowId": "N", "Description": "δ��Һ�ܾ�" }]
        }
    }, {
        "placeholder": "��Һ�ܾ�..."
    });
    PIVAS.BatchNoCheckList({ Id: "DivBatNo", LocId: SessionLoc, Check: true, Pack: false });
    // ������
    PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, { "placeholder": "������..." });
    PIVAS.ComboBox.Init({ Id: 'cmbPack', Type: 'PackType' }, { "placeholder": "�������..." });
    GridCmbBatNo = PIVAS.UpdateBatNoCombo({
        LocId: SessionLoc,
        GridId: "gridGenerally",
        Field: "batNo",
        BatUp: "batUp",
        MDspField: "mDsp"
    });

}

function InitGridGenerally() {
    var columns = [
        [
            { field: 'gridGenerallySelect', checkbox: true },
            {
                field: "warnInfo",
                title: '����',
                width: 75,
                styler: function(value, row, index) {
                    if (value == "ֹͣ") {
                        return "color:white;background-color:#ffba42;"
                    } else if (value.indexOf("��Һ�ܾ�") >= 0) {
                        return "color:white;background-color:#F4868E;"
                    } else if (value.indexOf("��˾ܾ�") >= 0) {
                        return "color:white;background-color:#C33A30;"
                    }
                    return "";
                }
            },
            { field: "doseDateTime", title: '��ҩʱ��', width: 100 },
            { field: "wardDesc", title: '����', width: 125 },
            { field: 'bedNo', title: '����', width: 75 },
            { field: "patNo", title: '�ǼǺ�', width: 100 },
            { field: "patName", title: '����', width: 70 },
            {
                field: "batNo",
                title: '����',
                width: 75,
                editor: GridCmbBatNo,
                styler: function(value, row, index) {
                    var colorStyle = 'text-decoration:underline;';
                    if (row.packFlag != "") {
                        colorStyle += PIVAS.Grid.CSS.BatchPack;
                    }
                    return colorStyle;
                }
            },
            {
                field: "oeoriSign",
                title: '��',
                width: 30,
                halign: 'left',
                align: 'center',
                styler: function(value, row, index) {
                    var colColor = row.colColor;
                    var colColorArr = colColor.split("-");
                    var colorStyle = "";
                    if ((colColorArr[0] % 2) == 0) { // ż���б�ɫ,�����˵ı���ɫ
                        colorStyle = PIVAS.Grid.CSS.PersonEven;
                    }
                    colorStyle = colorStyle + PIVAS.Grid.CSS.OeoriSign;
                    return colorStyle;
                },
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            { field: "incDesc", title: 'ҩƷ����', width: 250 },
            { field: "dosage", title: '����', width: 75 },
            { field: "freqDesc", title: 'Ƶ��', width: 75 },
            { field: "instrucDesc", title: '�÷�', width: 100 },
            { field: "priDesc", title: 'ҽ�����ȼ�', width: 90 },
            { field: "oeoreStat", title: 'ҽ��״̬', width: 70, hidden: true },
            { field: "qty", title: '����', width: 50, halign: 'left', align: 'right' },
            { field: "bUomDesc", title: '��λ', width: 60 },
            { field: "xDateTime", title: 'ֹͣʱ��', width: 100 },
            { field: "pivaStat", title: '��Һ״̬', width: 80 },
            { field: "passResult", title: '��˽��', width: 70 },
            { field: "incSpec", title: '���', width: 70 },
            { field: "barCode", title: '����', width: 125 },
            { field: "pNo", title: '��ӡ���', width: 70, hidden: true },
            { field: "printUser", title: '��ǩ��', width: 90 },
            { field: "printDateTime", title: '��ǩʱ��', width: 120 },
            { field: "refUser", title: '�ܾ���', width: 90 },
            { field: "refDateTime", title: '�ܾ�ʱ��', width: 120 },
            { field: "cPrtDateTime", title: 'ֹͣǩ��ӡʱ��', width: 120,
            	formatter:function(value, row, index){
	            	if (value=="U"){
		            	var cPrtDt=tkMakeServerCall("web.DHCSTPIVAS.StopPrint","GetCPrtTimeByPog",row.pogId)
		            	return cPrtDt;
		            }else{
			        	return value;
			        }

	            }
            },
            { field: "pogId", title: 'pogId', width: 70, hidden: false },
            { field: "colColor", title: 'colColor', width: 75, hidden: true },
            { field: "durationDesc", title: '�Ƴ�', width: 50, hidden: true },
            { field: "packFlag", title: '���', width: 50, hidden: true },
            { field: "mDsp", title: 'mDsp', width: 50, hidden: true }
        ]
    ];
    var dataGridOption = {
	    exportXls:true,
        url: '',
        toolbar: '#gridGenerallyBar',
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageSize: 50,
        pageList: [50, 100, 200],
        onLoadSuccess: function() {
            PIVAS.Grid.CellTip({ TipArr: ['ordRemark', 'incDesc', 'wardDesc'] });
            // $(".datagrid-btable td[field=oeoriSign]>div").css(PIVAS.Grid.CSS.OeoriSign);
        },
        rowStyler: function(index, row) {
            var colColorArr = (row.colColor).split("-");
            var colorStyle = "";
            if ((colColorArr[1] % 2) == 0) { // ������ı���ɫ
                colorStyle = PIVAS.Grid.CSS.SignRowEven;
            }
            return colorStyle;
        },
        onClickRow: function(rowIndex, rowData) {},
        onClickCell: function(rowIndex, field, value) {
            if (field == "oeoriSign") {
                var barCode = $(this).datagrid("getRows")[rowIndex].barCode;
                PIVASTIMELINE.Init({
                    Params: barCode,
                    Field: 'oeoriSign',
                    ClickField: field
                });
            }
            if ((field == "batNo") && (value != "")) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'batNo'
                });
            } else {
                $(this).datagrid('endEditing');
            }
        },
        onCheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridGenerally',
                Field: 'barCode',
                Check: true,
                Value: rowData.barCode
            });
        },
        onUncheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridGenerally',
                Field: 'barCode',
                Check: false,
                Value: rowData.barCode
            });
        },
        onSelect: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridGenerally',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId,
                Type: 'Select'
            });
        },
        onUnselect: function(rowIndex, rowData) {
            $('#gridGenerally').datagrid("unselectAll");
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridGenerally", dataGridOption);
}

///��ѯ
function Query() {
    var params = GetParams();
    $('#gridGenerally').datagrid({
        url: PIVAS.URL.COMMON + '?action=JsGenerallyQuery',
        queryParams: {
            params: params
        }
    });
}

///��ȡ���
function GetParams() {
    var paramsArr = [];
    var pivaLocId = $('#cmbPivaLoc').combobox("getValue") || ''; // ��Һ����		
    var dateOrdStart = $('#dateOrdStart').datebox('getValue'); // ��ʼ����
    var dateOrdEnd = $('#dateOrdEnd').datebox('getValue'); // ��ֹ����
    var locGrpId = $('#cmbLocGrp').combobox("getValue") || ''; // ������
    var wardId = $('#cmbWard').combobox("getValue") || ''; // ����
    var priority = $('#cmbPriority').combobox("getValue") || ''; // ҽ�����ȼ�
    var passResult = $('#cmbPassResult').combobox("getValue") || ''; // ҽ�����״̬
    var pivaStat = $('#cmbPivaStat').combobox("getValue") || ''; // ��Һ״̬
    var oeoreStat = $('#cmbOeoreStat').combobox("getValue") || ''; // ҽ��״̬
    var patNo = $.trim($("#txtPatNo").val()); // �ǼǺ�
    var prtNo = $('#txtPrtNo').searchbox('getValue'); // ��ǩ����
    var prtPNo = $('#txtPrtPNo').val().trim(); // ��ǩ���	
    var batNoStr = ""; // ����
    $("input[type=checkbox][name=batbox]").each(function() {
        if ($('#' + this.id).is(':checked')) {
            if (batNoStr == "") {
                batNoStr = this.value;
            } else {
                batNoStr = batNoStr + "," + this.value;
            }
        }
    });
    var printStop = $('#cmbPrintStop').combobox("getValue") || ''; // �Ƿ��Ѵ�ӡֹͣ��ǩ
    var barCode = $.trim($("#txtBarCode").val()); // �����
    var instruc = $('#cmbInstruc').combobox("getValue") || ''; // �÷�
    var freq = $('#cmbFreq').combobox("getValue") || ''; // Ƶ��
    var datePrtStart = $('#datePrtStart').datebox('getValue'); // ��ǩ��ʼ����
    var datePrtEnd = $('#datePrtEnd').datebox('getValue'); // ��ǩ��ֹ����
    var incId = $("#cmgIncItm").combobox("getValue") || ''; // ҩƷ
    var pivaCat = "" //$("#cmbPivaCat").combobox("getValue"); 	// ��Һ����-yunhaibao20180328�ݲ���
    var timePrtStart = $('#timePrtStart').timespinner('getValue'); // ��ǩ��ʼʱ��
    var timePrtEnd = $('#timePrtEnd').timespinner('getValue'); // ��ǩ����ʱ��						
    var pivaRefuse = $("#cmbPivaRefuse").combobox("getValue") || ''; // ��Һ�ܾ�
    var timeOrdStart = $('#timeOrdStart').timespinner('getValue'); // ��ҩ��ʼʱ��
    var timeOrdEnd = $('#timeOrdEnd').timespinner('getValue'); // ��ҩ����ʱ��
    var workTypeId = $('#cmbWorkType').combobox('getValue') || ''; // ������
    var packFlag = $('#cmbPack').combobox('getValues') || ''; // �������
    paramsArr[0] = pivaLocId;
    paramsArr[1] = dateOrdStart;
    paramsArr[2] = dateOrdEnd;
    paramsArr[3] = wardId;
    paramsArr[4] = locGrpId;
    paramsArr[5] = priority;
    paramsArr[6] = passResult;
    paramsArr[7] = pivaStat;
    paramsArr[8] = oeoreStat;
    paramsArr[9] = batNoStr;
    paramsArr[10] = printStop;
    paramsArr[11] = barCode;
    paramsArr[12] = instruc;
    paramsArr[13] = freq;
    paramsArr[14] = incId;
    paramsArr[15] = datePrtStart;
    paramsArr[16] = datePrtEnd;
    paramsArr[17] = pivaCat;
    paramsArr[18] = timePrtStart;
    paramsArr[19] = timePrtEnd;
    paramsArr[20] = prtNo;
    paramsArr[21] = pivaRefuse;
    paramsArr[22] = patNo;
    paramsArr[23] = prtPNo;
    paramsArr[24] = timeOrdStart;
    paramsArr[25] = timeOrdEnd;
    paramsArr[26] = workTypeId;
    paramsArr[27] = packFlag
    return paramsArr.join("^");
}

// ��ӡ��ǩ
function PrintLabel() {
    if (PIVASPRINT.CheckActiveX("DHCSTPrint.PIVALabel") == false) {
        return;
    }
    var pogArr = GetCheckedPogArr(1);
    var pogLen = pogArr.length;
    if (pogLen == 0) {
        return;
    }
    $.messager.progress({
        title: "�����ĵȴ�",
        text: '<i class="fa fa-print" style="color:#019BC1"></i>  ��ӡ������  <i class="fa fa-print" style="color:#019BC1"></i>',
        interval: 1000000
    })
    setTimeout(function() {
        var printNum = PIVASPRINT.PrintNum;
        for (var pogI = 0; pogI < pogLen; pogI++) {
            var pogId = pogArr[pogI];
            var printTask = "0";
            var count = pogI + 1;
            if (count % (printNum) == 0) {
                printTask = "1";
            }
            if (count == pogLen) {
                printTask = "1";
            }
            PIVASPRINT.Label({
                pogId: pogId,
                printTask: printTask,
                pageNumbers: pogLen,
                pageNo: count,
                rePrint: "(��)"
            })
        }
        $.messager.progress('close');
    }, 100)

}

// ��ӡֹͣǩ
function PrintStopLabel() {
    $.messager.confirm('ѡ����ʾ', '��ȷ�ϴ�ӡֹͣǩ��?', function(r) {
        if (r) {
            if (PIVASPRINT.CheckActiveX("DHCSTPrint.PIVALabel") == false) {
                return;
            }
            var pogArr = GetCheckedPogArr(2);

            var pogLen = pogArr.length;
            if (pogLen == 0) {
                return;
            }
            // ����ֹͣǩ��¼��
            var pCPRet = tkMakeServerCall("web.DHCSTPIVAS.StopPrint", "SaveCPrint", pogArr.join("^"), SessionUser);
            var pCPRetArr = pCPRet.split("^");
            var pCPId = pCPRetArr[0];
            if (pCPId < 0) {
                $.messager.alert('��ʾ', pCPRetArr[1], "warning");
                return;
            }
            var count = 0;
            var printNum = PIVASPRINT.PrintNum;
            for (var pogI = 0; pogI < pogLen; pogI++) {
                var pogId = pogArr[pogI];
                var printTask = "0";
                var count = pogI + 1;
                if (count % (printNum) == 0) {
                    printTask = "1";
                }
                if (count == pogLen) {
                    printTask = "1";
                }
                PIVASPRINT.Label({ pogId: pogId, printTask: printTask });
				var pogRowIndex=
				$("td[field='pogId']").children().filter(":contains("+pogId+")").closest("tr").attr("datagrid-row-index")||"";
				if (pogRowIndex!=""){
					$("#gridGenerally").datagrid("updateRow",{
						index:pogRowIndex, 
						row:{
							cPrtDateTime:"U"
						}
					}).datagrid("checkRow",pogRowIndex);	
							
				}

            }

        }
    });
}

// ��ȡѡ�м�¼��pog 
// pFlag:1-��ȡ����,2-��ȡֹͣ
function GetCheckedPogArr(pFlag) {
    var pogArr = [];
    var gridChecked = $('#gridGenerally').datagrid('getChecked');
    
    if (gridChecked == "") {
        $.messager.alert("��ʾ", "����ѡ���¼", "warning");
        return pogArr;
    }
    var cLen = gridChecked.length
    for (var cI = 0; cI < cLen; cI++) {
        var pogId = gridChecked[cI].pogId;
        if (pogId == "") {
            continue;
        }
        var oeoreStat = gridChecked[cI].oeoreStat;
        var oeoreStatIndex = oeoreStat.indexOf("ֹͣ");
        var passResult = gridChecked[cI].passResult;
        var passResultIndex = passResult.indexOf("���");
        if (pFlag == 2) {
            // ��ȡֹͣ��
            if (oeoreStatIndex < 0) {
                continue;
            }
            if (passResultIndex < 0) {
                //continue;
            }
        } else if (pFlag == 1) {
            // ��ȡ������
            if (oeoreStatIndex >= 0) {
                continue;
            }
        }
        if (pogArr.indexOf(pogId) < 0) {
            pogArr.push(pogId);
        }
    }
    return pogArr;
}

// ��ʼ��Ĭ������
function InitPivasSettings() {
    $.cm({
        ClassName: "web.DHCSTPIVAS.Settings",
        MethodName: "GetAppProp",
        userId: session['LOGON.USERID'],
        locId: session['LOGON.CTLOCID'],
        appCode: "Generally"
    }, function(jsonData) {
        $("#dateOrdStart").datebox("setValue", jsonData.OrdStDate);
        $("#dateOrdEnd").datebox("setValue", jsonData.OrdEdDate);
        $("#datePrtStart").datebox("setValue", jsonData.PrtStDate);
        $("#datePrtEnd").datebox("setValue", jsonData.PrtEdDate);
    });
}

function PrintLabelLodop(){
	// lodop�༭ģ��ʹ���Դ����򿽱����뼴��ѽ
	// �������lodop��ƽ̨,���������д���
	var LODOP=getLodop();
	LODOP.PRINT_INIT("PHA_PIVAS");
	LODOP.ADD_PRINT_BARCODE(10,10,50,50,"QRCode","123-4-333");
	//LODOP.PRINT_INITA(29,85,267,335,"��ӡ�ؼ�������ʾ_Lodop����_�հ���ϰ");
	LODOP.ADD_PRINT_TEXTA("hospName",6,68,175,22,"�������ֻ���׼ҽԺ��Һ��(��)");
	LODOP.ADD_PRINT_TEXTA("wardDesc",28,67,100,15,"���ڿ�һ����");
	LODOP.SET_PRINT_STYLEA(0,"Bold",1);
	LODOP.ADD_PRINT_TEXTA("batNo",28,204,40,20,"1(P)-S");
	LODOP.ADD_PRINT_TEXTA("patInfo",50,66,195,16,"18�� ���� 52�� Ů 0009998887");
	LODOP.SET_PRINT_STYLEA(0,"Bold",1);
	LODOP.ADD_PRINT_TEXTA("instruc",69,67,52,20,"������ע");
	LODOP.ADD_PRINT_RECT(90,9,248,1,0,1);
	LODOP.ADD_PRINT_RECT(111,11,248,1,0,1);
	LODOP.ADD_PRINT_TEXT(93,13,246,16,"ҩƷ      ������ҵ      ���     ����   ����...(ʡ��)");
	LODOP.ADD_PRINT_SHAPE(4,237,1,"100%",1,0,1,"#000000");
	LODOP.ADD_PRINT_SHAPE(4,278,0,"100%",1,0,1,"#000000");
	LODOP.ADD_PRINT_TEXT(240,7,227,20,"ҽ��:300��/�� ����   �͵���");
	LODOP.ADD_PRINT_TEXT(257,7,235,20,"��ҩ:2019-01-01 11:11:22 Tid ��� ...(ʡ��)");
	LODOP.ADD_PRINT_TEXT(285,4,262,20,"��:�����ַ�   ��ҩ: �����ַ�  �˶�:���ַ�");
	LODOP.ADD_PRINT_TEXT(305,8,"96.255%",20,"��Һ:�����ַ�   ����:�����ַ�   ҽ��:���ַ�");
	LODOP.PRINT()
}