/**
 * ģ��:     ��ҩ��ҩ���뵥��ѯ
 * ��д����: 2020-11-30
 * ��д��:   MaYuqiang
 */
var DefPhaLocInfo = tkMakeServerCall("web.DHCSTKUTIL", "GetDefaultPhaLoc", gLocId);
var DefPhaLocId = DefPhaLocInfo.split("^")[0] || "";
var DefPhaLocDesc = DefPhaLocInfo.split("^")[1] || "";
var AppPropData;	// ģ������
var ComPropData;	// ��������
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
var comWidth = 160 ;
DHCPHA_CONSTANT.VAR.SELECT = "";
DHCPHA_CONSTANT.VAR.UNSELECT = "";

$(function () {
    InitDict();
    InitSetDefVal();
    InitGridRequest();
    InitGridRequestDetail();
    $('#txtPatNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#txtPatNo").val());
            if (patNo != "") {
                var newPatNo = NumZeroPadding(patNo,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newPatNo);
                var patInfo = tkMakeServerCall("web.DHCSTPharmacyCommon", "GetPatInfoByNo", newPatNo);
                $("#txtPatName").val(patInfo.split("^")[0] || "");
                QueryRetRequest();
            } else {
                $("#txtPatName").val("");
            }
        }
    });
    $("#btnFind").on("click", QueryRetRequest);
    $("#btnPrint").on("click", Print);
    $("#btnDefaultLoc").on("click", SetDefaultLoc);
    $("#btnDelReqItm").on("click", DeleteReqItm);
    if (LoadAdmId != "") {
        var patInfo = tkMakeServerCall("web.DHCINPHA.Request", "PatInfo", LoadAdmId);
        $("#txtPatNo").val(patInfo.split("^")[0] || "");
        $("#txtPatName").val(patInfo.split("^")[1] || "");
    }
    $("#txtPatName").validatebox("setDisabled",true);
    //window.resizeTo(screen.availWidth - 6, (screen.availHeight - 100));
    //window.moveTo(3, 90);
});

function InitDict() {
    if (session['LOGON.WARDID'] == ""){
        var disableState = false
    }
    else {
        var disableState = true
    }
    /// �����б�
    PHA.ComboBox("cmbWard", {
        url: PHA_STORE.WardLoc().url,
        width: comWidth,
        disabled: disableState,
        onLoadSuccess: function(){
            if (gWardID!==""){
                $("#cmbWard").combobox("setValue", gLocId);
            }
        }       
    });
    /// ҩ���б�
    PHA.ComboBox("cmbPhaLoc", {
        url: PHA_STORE.Pharmacy().url,
        width: comWidth,
        onLoadSuccess: function(){
            
        },
        onSelect: function (selData) {
            //QueryData();
        }
    });
    /// ��������
    PHA.ComboBox("cmbAdmType", {
        data: [{
            RowId: "O",
            Description: $g("�ż���")
        }, {
            RowId: "I",
            Description: $g("סԺ")
        }],
        panelHeight: "auto",
        width:comWidth
    });
    
}

/**
 * �����б�, ��ѡ����ȡ����ѡʱ
 */
function patientTreeCheckChangeHandle() {
    LoadAdmId = EpisodeIDStr;
    QueryRetRequest();
}

/**
 * ���ؼ�����ʼֵ
 * @method InitSetDefVal
 */
function InitSetDefVal() {
	// ��������
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
		}, false)

    $("#dateColStart").datebox("setValue", ComPropData.QueryStartDate);
    $("#dateColEnd").datebox("setValue", ComPropData.QueryEndDate);
    $('#timeColStart').timespinner('setValue', ComPropData.QueryStartTime);
    $('#timeColEnd').timespinner('setValue', ComPropData.QueryEndTime);
    $("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultLoc4Req);

}
// ���뵥�б�
function InitGridRequest() {
    var columns = [
        [{
                field: 'reqSelect',
                checkbox: true
            },{
                field: 'phbrrId',
                title: '��ҩ��ҩ���뵥Id',
                width: 50,
                hidden:true 
            },{
                field: 'status',
                title: '״̬',
                width: 80,
                styler: function (value, row, index) {
                    var status = row.retStatus;
                    if (status == $g("��ҩ���")) {
                        return 'background-color:#47CE27;color:#FFFFFF;';
                    } else if (status == $g("��δ��ҩ")) {
                        return 'background-color:#F68300;color:#FFFFFF;';
                    }
                },
                formatter: function (value, row, index) {
                    var status = row.retStatus;
                    return status;
                }
            },{
                field: 'reqNo',
                title: '������',
                width: 130
            },{
                field: 'reqDate',
                title: '��������',
                width: 100
            },{
                field: 'wardDesc',
                title: '�������/����(����)',
                width: 140
            },{
                field: 'reqUserName',
                title: '������',
                width: 75
            },{
                field: 'patNo',
                title: '���ߵǼǺ�',
                width: 120
            },{
                field: 'patName',
                title: '��������',
                width: 80
            },{
                field: 'reqTime',
                title: '����ʱ��',
                width: 100
            },{
                field: 'retStatus',
                title: '��ҩ״̬',
                width: 100,
                hidden: true
            }
            /*,
            {
                field: 'refundStatus',
                title: '�˷�״̬',
                width: 100,
                hidden: true
            }
            */
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        toolbar: [],
        onUncheck: function (rowIndex, rowData) {
            if (rowData) {
                QueryRetReqDetail();
            }
        },
        onCheck: function (rowIndex, rowData) {
            if (rowData) {
                QueryRetReqDetail();
            }
        },
        onUncheckAll: function () {
            QueryRetReqDetail();
        },
        onCheckAll: function () {
            QueryRetReqDetail();
        },
        onLoadSuccess: function () {
            $('#gridRequestDetail').datagrid('clear');
            $('#gridRequest').datagrid('uncheckAll');
        }
    }
    PHA.Grid("gridRequest", dataGridOption);
}

// ��ȡ����
function GetQueryParamsJson(){
    var admIdStr = EpisodeIDStr.split('^').join(',');
    var patNo = $('#txtPatNo').val()
    if (patNo !== '') {
        admIdStr = '';
    }
    return {
        startDate: $("#dateColStart").datebox('getValue'),
        endDate: $("#dateColEnd").datebox('getValue'),
        startTime: $('#timeColStart').timespinner('getValue'),
        endTime: $('#timeColEnd').timespinner('getValue'),
        loc: $('#cmbPhaLoc').combobox("getValue"),
        patNo: patNo,
        wardLocId: $('#cmbWard').combobox("getValue"),
        admType: $('#cmbAdmType').combobox("getValue"),
        refundFlag: ($('#advrefundflag').checkbox('getValue')==true?'Y':'N'), 
        admIdStr: admIdStr    
    };
    

}
// ��ѯ
function QueryRetRequest() {
    var pJson = GetQueryParamsJson();
    if (pJson == "") {
        return;
    }
    $('#gridRequest').datagrid({
        url: $URL,
        queryParams: {
            ClassName: "PHA.HERB.Request.Query",
            QueryName: "GetRetRequestList",
            pJsonStr: JSON.stringify(pJson)
        }
    });
}

// ���뵥��ϸ�б�
function InitGridRequestDetail() {
    var columns = [
        [{
                field: 'detailCheck',
                checkbox: true
            },{
                field: 'reqItmRowId',
                title: 'reqItmRowId',
                width: 80,
                halign: 'center',
                hidden: true
            },{
                field: 'status',
                title: '״̬',
                width: 80,
                styler: function (value, row, index) {
                    var status = row.retiStatus;
                    if (status == $g("��ҩ���")) {
                        return 'background-color:#47CE27;color:#FFFFFF;';
                    } else if (status == $g("��δ��ҩ")) {
                        return 'background-color:#F68300;color:#FFFFFF;';
                    }
                },
                formatter: function (value, row, index) {
                    var status = row.retiStatus;
                    return status;
                }
            },{
                field: 'inciDesc',
                title: 'ҩƷ����',
                width: 180
            },{
                field: 'bUomDesc',
                title: '��λ',
                width: 50
            },{
                field: 'reqQty',
                title: '��������',
                width: 70,
                halign: 'left',
                align: 'right',
                hidden: false
            },{
                field: 'reasonDesc',
                title: '��ҩԭ��',
                width: 140
            },{
                field: 'retiStatus',
                title: '��ҩ״̬',
                width: 80,
                hidden: true
            },{
                field: 'batNo',
                title: '��ҩ����',
                width: 80,
                hidden: true
            },{
                field: 'expDate',
                title: 'Ч��',
                width: 80,
                hidden: true
            },{
                field: 'retQty',
                title: '��������',
                width: 70,
                halign: 'left',
                align: 'right'
            },{
                field: 'surQty',
                title: 'δ������',
                width: 70,
                halign: 'left',
                align: 'right'
            },{
                field: 'sp',
                title: '�ۼ�',
                width: 70,
                halign: 'left',
                align: 'right'
            },{
                field: 'spAmt',
                title: '�ۼ۽��',
                width: 70,
                halign: 'left',
                align: 'right'
            },{
                field: 'manfDesc',
                title: '������ҵ',
                width: 200,
                align: 'left'
            },{
                field: 'reqDate',
                title: '��������',
                width: 100,
                align: 'center'
            },{
                field: 'reqTime',
                title: '����ʱ��',
                width: 100
            },{
                field: 'prescNo',
                title: '������',
                width: 120,
                hidden: false
            },{
                field: 'encryptLevel',
                title: '�����ܼ�',
                width: 80,
                align: 'left',
                hidden: true
            },{
                field: 'patLevel',
                title: '���˼���',
                width: 80,
                align: 'left',
                hidden: true
            },{
                field: 'dspBatch',
                title: 'dspBatch',
                width: 80,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 999,
        pageList: [999],
        pagination: false,
        toolbar: "#gridRequestDetailBar",
        onSelect: function (rowIndex, rowData) {

        },
        onUnselect: function (rowIndex, rowData) {

        },
        onLoadSuccess: function () {
            $('#gridRequestDetail').datagrid('uncheckAll');
        },
        onCheck: function (rowIndex, rowData) {
            if (DHCPHA_CONSTANT.VAR.UNSELECT != "") {
                return;
            }
            DHCPHA_CONSTANT.VAR.UNSELECT = 1;
            SelectLinkOrder(rowIndex);
            DHCPHA_CONSTANT.VAR.UNSELECT = "";
        },
        onUncheck: function (rowIndex, rowData) {
            if (DHCPHA_CONSTANT.VAR.UNSELECT != "") {
                return;
            }
            DHCPHA_CONSTANT.VAR.UNSELECT = 1;
            UnSelectLinkOrder(rowIndex);
            DHCPHA_CONSTANT.VAR.UNSELECT = "";
        }
    }
    PHA.Grid("gridRequestDetail", dataGridOption);
}
// ��ѯ��ϸ
function QueryRetReqDetail() {
    var reqIdStr = GetCheckedReqId();
    if ((reqIdStr == null) || (reqIdStr == "")) {
        //$.messager.alert("��ʾ", "����ѡ���¼", "warning");
        //return;
    }
    $('#gridRequestDetail').datagrid({
        url: $URL,
        queryParams: {
            ClassName: "PHA.HERB.Request.Query",
            QueryName: "GetRetRequestDetail",
            params: reqIdStr
        }
    });
}

// ��ȡѡ�м�¼�����뵥Id
function GetCheckedReqId() {
    var reqIdArr = [];
    var gridRequestChecked = $('#gridRequest').datagrid('getChecked');
    for (var i = 0; i < gridRequestChecked.length; i++) {
        var checkedData = gridRequestChecked[i];
        var reqId = checkedData.phbrrId;
        if (reqIdArr.indexOf(reqId) < 0) {
            reqIdArr.push(reqId);
        }
    }
    return reqIdArr.join(",");
}
// ��ȡѡ�м�¼��������ϸ��id
function GetCheckedReqItmArr() {
    var reqItmArr = [];
    var gridReqDetailChecked = $('#gridRequestDetail').datagrid('getChecked');
    for (var i = 0; i < gridReqDetailChecked.length; i++) {
        var checkedData = gridReqDetailChecked[i];
        var reqItmRowId = checkedData.reqItmRowId;
        if (reqItmArr.indexOf(reqItmRowId) < 0) {
            reqItmArr.push(reqItmRowId);
        }
    }
    return reqItmArr.join("^");
}

function DeleteReqItm() {
    var reqItmIdStr = GetCheckedReqItmArr();
    if (reqItmIdStr == "") {
        $.messager.alert("��ʾ", "���ȹ�ѡ��Ҫɾ���ļ�¼", "warning");
        return;
    }
    $.messager.confirm("ɾ����ʾ", "��ȷ��ɾ����ϸ��?", function (r) {
        if (r) {
            var delRet = tkMakeServerCall("PHA.HERB.Request.Save","DelReqDetailData", reqItmIdStr);
            var delRetArr = delRet.split("^");
            var delVal = delRetArr[0];
            var delInfo = delRetArr[1];
            if (delVal < 0) {
                $.messager.alert("��ʾ", delInfo, "warning");
                //return;
            }
            QueryRetRequest();
            QueryRetReqDetail();
        }
    });


}

function SetDefaultLoc() {
    $.messager.alert("��ʾ", "��δ����", "info");
    /*
    var PhaLoc = $('#cmbPhaLoc').combobox("getValue") || "";
    var PhaLocDesc = $('#cmbPhaLoc').combobox("getText") || "";
    if (PhaLoc == "") {
        //$.messager.alert("��ʾ", "����ѡ��ҩ����", "warning");
        //return;
    }
    if (SessionLoc == "") {
        return;
    }
    var confirmText = "ȷ�Ͻ� " + PhaLocDesc + " ���ó�Ĭ�Ͽ�����?";
    if (PhaLoc == "") {
        confirmText = "ȷ��Ĭ�Ͽ�������Ϊ����?";
    }
    $.messager.confirm("ȷ����ʾ", confirmText, function (r) {
        if (r) {
            var saveRet = tkMakeServerCall("web.DHCSTRETREQUEST", "SetDefaultPhaLoc", PhaLoc, SessionLoc);
            var saveArr = saveRet.split("^");
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal == 0) {
                $.messager.alert("��ʾ", "���óɹ�", "info");
                return;
            }
        }
    });
    */
}

/// ��ӡ���뵥
function Print() {
    var gridRequestChecked = $('#gridRequest').datagrid('getChecked');
    if (gridRequestChecked.length == 0){
        $.messager.alert("��ʾ", "����ѡ����Ҫ��ӡ�����뵥", "info");
         return;
    }
    for (var i = 0; i < gridRequestChecked.length; i++) {
        var checkedData = gridRequestChecked[i];
        var reqId = checkedData.phbrrId;
        HERB_PRINTCOM.RequestDoc(reqId, '��');
    }
    
    
}



//����ҽ��ѡ��
function SelectLinkOrder(id) {
    var rows = $("#gridRequestDetail").datagrid("getRows");
    if (rows.length == 0) {
        return;
    }
    var prescNo = rows[id].prescNo;
    for (var i = 0; i < rows.length; i++) {
        if (id == i) {
            continue;
        }
        var tmpPrescNo = rows[i].prescNo;
        if (tmpPrescNo == prescNo) {
            $("#gridRequestDetail").datagrid("selectRow", i);
        }
    }
    DHCPHA_CONSTANT.VAR.SELECT = "";
}

//����ҽ��ȡ��ѡ��
function UnSelectLinkOrder(sRowIndex) {
    var rows = $("#gridRequestDetail").datagrid("getRows");
    if (rows.length == 0) {
        return;
    }
    var prescNo = rows[sRowIndex].prescNo;
    for (var num = 0; num < rows.length; num++) {
        if (sRowIndex === num) {
            continue;
        }
        var tmpPrescNo = rows[num].prescNo;
        if (tmpPrescNo == prescNo) {
        	$("#gridRequestDetail").datagrid("unselectRow", num);
        }
    }
    DHCPHA_CONSTANT.VAR.UNSELECT = "";
    
}
