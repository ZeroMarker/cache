/**
 * ģ��:     ����ҩ����
 * ��д����: 2018-06-22
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId= session['LOGON.HOSPID'];
var ReqUserId = SessionUser;
var ReqId = "";
var BddId = "1";
$(function() {
    InitDict();
    InitGridBddItm();
    SetDefaultData();
    $("#btnSave").on("click", Save)
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
                { "RowId": "1", "Description": "��������" },
                { "RowId": "2", "Description": "�����鲹��" },
                { "RowId": "3", "Description": "����Һ����" }
            ]
        }
    }, {
        mode: "local",
        editable: false,
        readonly: true
    });
    if (LoadReqType != "") {
        $("#cmbReqType").combobox("setValue", LoadReqType);
    }
}

/// ����Ĭ����Ϣ
function SetDefaultData() {
    var typeCode = "";
    if (LoadReqType == 2) {
        typeCode = "JSDM";
    } else if (LoadReqType == 1) {
        typeCode = "BASEDRUG";
    }
    var defaultData = tkMakeServerCall("web.DHCSTBASEDRUG", "GetBaseDrugDispDateScope", SessionLoc, typeCode);
    if (defaultData != "") {
        var defaultDataArr = defaultData.split("^");
        $("#dateStart").datebox("setValue", defaultDataArr[0]);
        $("#dateEnd").datebox("setValue", defaultDataArr[1]);
        $("#timeStart").timespinner("setValue", defaultDataArr[2]);
        $("#timeEnd").timespinner("setValue", defaultDataArr[3]);
    }
}

// ���뵥��ϸ�б�
function InitGridBddItm() {
    var columns = [
        [
            { field: 'bddItmId', title: 'bddItmId', width: 200, halign: 'center', hidden: true },
            { field: 'reqItmId', title: 'reqItmId', width: 200, halign: 'center', hidden: true },
            {
                field: 'incCode',
                title: 'ҩƷ����',
                width: 120,
                halign: 'center'
            },
            {
                field: 'incDesc',
                title: 'ҩƷ����',
                width: 400,
                halign: 'center'
            },
            {
                field: 'reqQty',
                title: '��������',
                width: 75,
                halign: 'center',
                align: 'right'
            },
            {
                field: 'consumeQty',
                title: '��������',
                width: 75,
                halign: 'center',
                align: 'right'
            },

            {
                field: 'reqUomDesc',
                title: '��λ',
                width: 100,
                halign: 'center'
            },
            {
                field: 'incRowId',
                title: 'ҩƷId',
                width: 400,
                halign: 'center',
                hidden: true
            },
            {
                field: 'reqUomId',
                title: '��λId',
                width: 100,
                halign: 'center',
                hidden: true
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
        onLoadSuccess: function() {

        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridBddItm", dataGridOption);
}

// ��ѯ��ϸ
function QueryDetail() {
    if (BddId != "") {
        $('#gridBddItm').datagrid({
            url: $URL,
            queryParams: {
                ClassName: "web.DHCINPHA.WardBaseDrug",
                QueryName: "QueryBaseDrugDispItm",
                inputStr: BddId
            }
        });
    }
    if (ReqId != "") {
        $("#txtReqNo").val(tkMakeServerCall("web.DHCSTBASEDRUG", "GetReqNo", ReqId))
    }
}

// ���油����
function Save() {
    var proLocId = $("#cmbProLoc").combobox("getValue") || "";
    if (proLocId == "") {
        $.messager.alert("��ʾ", "����ѡ�񹩸�����", "warning");
        return;
    }
    var reqLocId = $("#cmbReqLoc").combobox("getValue") || "";
    if (reqLocId == "") {
        $.messager.alert("��ʾ", "����ѡ���������", "warning");
        return;
    }
    var startDate = $("#dateStart").datebox("getValue");
    var startTime = $("#timeStart").timespinner("getValue");
    var endDate = $("#dateEnd").datebox("getValue");
    var endTime = $("#timeEnd").timespinner("getValue");
    var reqTypeId = $("#cmbReqType").combobox("getValue");
    var reqTypeCode = "";
    if (reqTypeId == 2) {
        reqTypeCode = "JSDM";
    } else if (reqTypeId == 1) {
        reqTypeCode = "BASEDRUG";
    }
    var saveRet = tkMakeServerCall("web.DHCSTBASEDRUG", "CreateBaseDrugDispData", reqLocId, proLocId, startDate, startTime, endDate, endTime, SessionUser, reqTypeCode);
    var saveRetArr = saveRet.split("^")
    if (saveRet == -9) {
        $.messager.alert("��ʾ", "���ȴ���δ��ɵĻ���ҩ���쵥", "warning");
        return;
    }
    if (saveRetArr[0] > 0) {
        $.messager.alert("��ʾ", "���ɳɹ�", "info ");
        // ˢ����ϸ
        ReqId = saveRetArr[0];
        BddId = saveRetArr[1];
        QueryDetail();

    } else if (saveRetArr[0] == "-1001") {
        $.messager.alert("��ʾ", "������Χ���޿��ñ�������", "warning");
    }else if (saveRetArr[0] == "-1002") {
	    if (saveRetArr[1]!=""){
        	$.messager.alert("��ʾ", saveRetArr[1], "warning");
	    }else{
			$.messager.alert("��ʾ", "������Χ���޿��ñ�������", "warning");
		}
    }else {
        $.messager.alert("��ʾ", "����ʧ��" + saveRet, "info");
    }
}