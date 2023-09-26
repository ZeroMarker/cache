/** 
 * ģ��: 	 ҽ����ҩ״̬��ѯ
 * ��д����: 2019-01-28
 * ��д��:   pushuangcai
 */
$(function () {
    InitDict();
    InitGridOrdItem();
    $('#btnFind').bind("click", Query);
    $('#btnClear').bind("click", Clear);
    $('#txtPatno').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            var patNo = $('#txtPatno').val();
            if (patNo == "") {
                return;
            }
            var patNoLen = tkMakeServerCall("web.DHCSTPIVAS.Common", "PatRegNoLen"); // û������д10,����10
            var newpatno = NumZeroPadding(patNo, patNoLen);
            $(this).val(newpatno);
        }
    });
})
//���ؿؼ�
function InitDict() {
    // ҩƷ
    var IncItmOpts = {
        QueryParams: {
            ClassName: "web.DHCSTPIVAS.Dictionary",
            QueryName: "IncItm",
            inputParams: ""
        },
        panelWidth: 750,
        columns: [
            [{
                    field: 'incRowId',
                    title: 'incItmRowId',
                    width: 100,
                    sortable: true,
                    hidden: true
                },
                {
                    field: 'incCode',
                    title: 'ҩƷ����',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'incDesc',
                    title: 'ҩƷ����',
                    width: 400,
                    sortable: true
                },
                {
                    field: 'incSpec',
                    title: '���',
                    width: 100,
                    sortable: true
                }
            ]
        ],
        idField: 'incRowId',
        textField: 'incDesc'
    }
    DHCPHA_HUI_COM.ComboGrid.Init({
        Id: 'cmgIncItm'
    }, IncItmOpts);
}
//��ʼ��ҽ����ϸ�б�
function InitGridOrdItem() {
    var columns = [
        [{
                field: 'OrdItem',
                title: 'ҽ��ID',
                align: 'left'
            },
            {
                field: "OrdExec",
                title: 'ִ�м�¼ID',
                align: 'left'
            }, {
                field: 'ArcItmDesc',
                title: 'ҽ������',
                align: 'left'
            },
            {
                field: 'InciDesc',
                title: 'ҩƷ����',
                align: 'left'
            },
            {
                field: 'ExStDate',
                title: '�ƻ�ִ��ʱ��',
                align: 'left'
            },
            {
                field: "PhaLoc",
                title: 'ҩ��',
                align: 'left'
            },
            {
                field: "Ward",
                title: '����',
                align: 'left'
            },
            {
                field: "BillPoint",
                title: '�Ʒѵ�',
                align: 'left'
            },
            {
                field: "BillStatus",
                title: '�Ʒ�״̬',
                align: 'center'
            },
            {
                field: "ArrearsFlag",
                title: '�Ƿ�Ƿ��',
                align: 'center',
                styler: function (val, row, index) {
                    var warnStr = row.WarnFlagStr;
                    if (warnStr.split("#")[3] == "Y") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "NurseDealOrd",
                title: '��ʿҽ������',
                align: 'left',
                styler: function (val, row, index) {
                    var warnStr = row.WarnFlagStr;
                    if (warnStr.split("#")[1] == "Y") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "NurseAudit",
                title: '��ҩ���',
                align: 'left',
                styler: function (val, row, index) {
                    var warnStr = row.WarnFlagStr;
                    if (warnStr.split("#")[0] == "Y") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "PhAudit",
                title: 'ҩʦ���',
                align: 'left',
                styler: function (val, row, index) {
                    var warnStr = row.WarnFlagStr;
                    if (warnStr.split("#")[2] == "Y") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            }, {
                field: "DispRefuse",
                title: '�ܾ���ҩ',
                align: 'left',
                styler: function (val, row, index) {
                    if (val != "") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "ExecStatus",
                title: 'ִ��״̬',
                align: 'center',
                styler: function (val, row, index) {
                    if ((val.indexOf("ֹͣ") > -1) || ((val.indexOf("����") > -1)&&(val.indexOf("����ִ��") < 0)) || (val.indexOf("�ܾ�") > -1)) {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "SkinTestFlag",
                title: '�Ƿ���Ƥ��',
                align: 'center'
            },
            {
                field: "SkinTest",
                title: 'Ƥ�Խ��',
                align: 'center',
                styler: function (val, row, index) {
                    var warnStr = row.WarnFlagStr;
                    if (warnStr.split("#")[6] == "Y") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "DispStatus",
                title: '�����ҩ״̬',
                align: 'center',
                styler: function (val, row, index) {
                    if (val.indexOf("�ѷ�") > -1) {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "Priority",
                title: 'ҽ�����ȼ�',
                align: 'center',
                styler: function (val, row, index) {
                    if ((val.indexOf("�Ա�") >= 0) || (val.indexOf("����") >= 0)) {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "DeptLoc",
                title: '��������',
                align: 'center'
            },
            {
                field: "SpeLocFlag",
                title: '�Ƿ��������',
                align: 'center'
            },
            {
                field: "InHospFlag",
                title: '��ǰ��Ժ״̬',
                align: 'center'
            },
            {
                field: "OrdPreXDateTime",
                title: 'Ԥͣʱ��',
                align: 'center',
                styler: function (val, row, index) {
	                if (val.split(" ")[0] == row.ExStDate.split(" ")[0]){
                    	return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "DispType",
                title: '��ҩ���',
                align: 'center'
            },
            {
                field: "DispNo",
                title: '��ҩ����',
                align: 'center'
            },
            {
                field: "DispDate",
                title: '��ҩʱ��',
                align: 'center'
            },
            {
                field: "OrdQty",
                title: '��ҩ����',
                align: 'left'
            },
            {
                field: "AvailQty",
                title: '���ÿ��',
                align: 'left',
                styler: function (val, row, index) {
                    var warnStr = row.WarnFlagStr;
                    if (warnStr.split("#")[4] == "Y") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            }, {
                field: "ArcMastEdDate",
                title: 'ҽ�����ֹ����',
                align: 'center',
                styler: function (val, row, index) {
                    if (val.indexOf("��ֹ") > -1) {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "PriceRule",
                title: '��ǰ�۸����',
                align: 'center'
            },
            {
                field: "HasDspChl",
                title: '����ӱ�',
                align: 'left',
                styler: function (val, row, index) {
                    var warnStr = row.WarnFlagStr;
                    if (warnStr.split("#")[5] == "Y") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "WarnFlagStr",
                title: '�辯ʾ�ı�־��', // #1:��ҩ���,#2:ҽ������,#3:ҩʦ���,#4:Ƿ��,#5:��治��,#6:����ӱ�û����,#7:Ƥ��
                align: 'center',
                hidden:true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCINPHA.DispOrdItmStatus",
            QueryName: "CheckOrdDispStatus",
        },
        pagination: true,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        toolbar: [],
        onClickRow: function (rowIndex, rowData) {},
        singleSelect: true,
        onLoadSuccess: function () {}
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrdItem", dataGridOption);
}
//��ѯ����
function Query() {
    var params = getQueryParams();
    $('#gridOrdItem').datagrid('query', {
        InputStr: params
    });
}
//���
function Clear() {
    InitDict();
    $('#txtPatno').val("");
    $('#cmgIncItm').combo("clear");
    $('#txtOeori').val("");
    $('#dateStart').datebox("setValue", "");
    $('#txtOrdExe').val("");
    $('#gridOrdItem').datagrid('clear');
}
// ��ȡ����
function getQueryParams() {
    var ordExDate = $('#dateStart').datebox('getValue');
    var patNo = $('#txtPatno').val();
    var oeori = $('#txtOeori').val();
    var ordExeDr = $('#txtOrdExe').val();
    var incId = $("#cmgIncItm").combobox("getValue") || ""; //�����
    return patNo + "^" + incId + "^" + oeori + "^" + ordExDate + "^" + ordExeDr;
}

//@description ���ֲ�0
//@input: no,length
function NumZeroPadding(inputNum, numLength) {
    if (inputNum == "") {
        return inputNum;
    }
    var inputNumLen = inputNum.length;
    if ((inputNum<=0)||(inputNumLen > numLength)) {
        $.messager.alert('��ʾ', "�������");
        return;
    }
    for (var i = 1; i <= numLength - inputNumLen; i++) {
        inputNum = "0" + inputNum;
    }
    return inputNum;
}