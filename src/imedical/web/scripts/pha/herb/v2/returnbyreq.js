/**
 * ģ��:     ��ҩ���뵥��ҩ
 * ��д����: 2020-12-17
 * ��д��:   MaYuqiang
 */
PHA_COM.Val.CAModelCode = "PHAHERBRETURN"; 
var DefPhaLocInfo = tkMakeServerCall("web.DHCSTKUTIL", "GetDefaultPhaLoc", gLocId);
var DefPhaLocId = DefPhaLocInfo.split("^")[0] || "";
var DefPhaLocDesc = DefPhaLocInfo.split("^")[1] || "";
var ComPropData		// ��������
var AppPropData		// ģ������
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
    PHA_COM.SetPanel('#pha_herb_v2_retbyreq', $('#pha_herb_v2_retbyreq').panel('options').title);
    InitDict();
    InitSetDefVal();
    InitGridRequest();
    InitGridReturnDetail();
    
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
    //$("#btnPrint").on("click", Print);
    $("#btnReturn").on("click", ClickReturnBtn); 
    $("#btnRefReturn").on("click", RefuseReturn);
    $("#txtPatName").validatebox("setDisabled",true);
});

/**
 * ���ؼ�����ʼֵ
 * @method InitSetDefVal
 */
 function InitSetDefVal() {
	//��������
	// ��������
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
		}, false)

    $("#dateColStart").datebox("setValue", ComPropData.ReturnStartDate);
    $("#dateColEnd").datebox("setValue", ComPropData.ReturnEndDate);
	$('#timeColStart').timespinner('setValue', "00:00:00");
	$('#timeColEnd').timespinner('setValue', "23:59:59");
	$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultLoc4Req);
}

function InitDict() {
	/// �����б�
	PHA.ComboBox("cmbWard", {
		url: PHA_STORE.WardLoc().url,
		width: 160,
		onLoadSuccess: function(){
			if (gWardID!==""){
				$("#cmbWard").combobox("setValue", gWardID);
			}
		}		
	});
	/// ҩ���б�
	PHA.ComboBox("cmbPhaLoc", {
		url: PHA_STORE.Pharmacy().url,
		onLoadSuccess: function(){
			//$("#cmbPhaLoc").combobox("setValue", gLocId);
		},
		onSelect: function (selData) {
            QueryRetRequest();
		}
	});
	/// ��������
	PHA.ComboBox("cmbAdmType", {
		data: [{
			RowId: "O^E",
			Description: $g("�ż���")
		}, {
			RowId: "I",
			Description: $g("סԺ")
		}],
		panelHeight: "auto"
	});
	
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
                field: 'prescNo',
                title: '������',
                width: 130
            },{
                field: 'reqDate',
                title: '��������',
                width: 100
            },{
                field: 'wardDesc',
                title: '�������/����(����)',
                width: 160
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
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        border: false,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        toolbar: '#gridReturnBar',
        onUncheck: function (rowIndex, rowData) {
            if (rowData) {
                QueryReturnDetail();
            }
        },
        onCheck: function (rowIndex, rowData) {
            if (rowData) {
                QueryReturnDetail();
            }
        },
        onUncheckAll: function () {
            QueryReturnDetail();
        },
        onCheckAll: function () {
            QueryReturnDetail();
        },
        onLoadSuccess: function () {
            $('#gridReturnDetail').datagrid('clear');
            $('#gridReturnDetail').datagrid('uncheckAll');
            $('#gridRequest').datagrid('uncheckAll');
        }
    }
	PHA.Grid("gridRequest", dataGridOption);
}

// ��ȡ����
function GetQueryParamsJson(){
    var patNo = $('#txtPatNo').val();
    if (patNo == ""){
        $("#txtPatName").val("");
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
        refundFlag: ($('#advrefundflag').checkbox('getValue')==true?'Y':'N')     
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
            ClassName: "PHA.HERB.Return.Query",
            QueryName: "GetRetRequestList",
            pJsonStr: JSON.stringify(pJson)
        }
    });
}

// ���뵥��ϸ�б�
function InitGridReturnDetail() {
    var columns = [
        [	/*{
                field: 'detailCheck',
                checkbox: true
            },
            */{
                field: 'reqItmRowId',
                title: 'reqItmRowId',
                width: 80,
                halign: 'center',
                hidden: true
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
                field: 'reasonDesc',
                title: '��ҩԭ��',
                width: 140
            },{
                field: 'reasonId',
                title: '��ҩԭ��',
                width: 140,
                hidden: true
            },{
                field: 'batNo',
                title: '��ҩ����',
                width: 100
            },{
                field: 'expDate',
                title: 'Ч��',
                width: 100
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
                align: 'center',
                hidden: true
            },{
                field: 'reqTime',
                title: '����ʱ��',
                width: 100,
                hidden: true
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
            },{
                field: 'phbdicId',
                title: '��ҩҵ�����',
                width: 80,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        border: false,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 999,
        pageList: [999],
        pagination: true,
        toolbar: '', 	//'#gridReturnDetailBar',
        onLoadSuccess: function () {
	        var rows = $("#gridReturnDetail").datagrid("getRows");
	        if (rows.length>0){
            	$('#gridReturnDetail').datagrid('checkAll');
	        }
        }
    }
	PHA.Grid("gridReturnDetail", dataGridOption);
}
// ��ѯ��ϸ
function QueryReturnDetail() {
    var reqIdStr = GetCheckedReqId();
    if ((reqIdStr == null) || (reqIdStr == "")) {
        //$.messager.alert("��ʾ", "����ѡ���¼", "warning");
        //return;
    }
    $('#gridReturnDetail').datagrid({
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
function GetCheckedReturnItmArr() {
    var retItmArr = [];
    //var gridReqDetailChecked = $('#gridReturnDetail').datagrid('getChecked');
    var gridReqDetailRows = $("#gridReturnDetail").datagrid("getRows");
    for (var i = 0; i < gridReqDetailRows.length; i++) {
        var checkedData = gridReqDetailRows[i] ;
        var reqItmRowId = checkedData.reqItmRowId ;
        var dspBatchId = checkedData.dspBatch ;
        var retQty = checkedData.reqQty ;
        var retReasonId = checkedData.reasonId ;
        var phbdicId = checkedData.phbdicId ;
        var sp = checkedData.sp ;
        var spAmt = checkedData.spAmt ;
        var prescNo = checkedData.prescNo ;
        var detail = reqItmRowId +"^"+ dspBatchId +"^"+ retQty +"^"+ retReasonId +"^"+ phbdicId +"^"+ sp +"^"+ spAmt +"^"+ prescNo
        if (retItmArr.indexOf(detail) < 0) {
            retItmArr.push(detail);
        }
    }
    return retItmArr.join(",");
}

/// �����ҩ��ť
function ClickReturnBtn(){
	PHA_COM.CACert("PHAHERBRETURN", DoReturn);	
}

function DoReturn(){
    var returnItmArr = GetCheckedReturnItmArr()
    if ((returnItmArr == null) || (returnItmArr == "")) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ��ҩ�ļ�¼", "warning");
        return;
    }
    var phaLocId = $('#cmbPhaLoc').combobox("getValue") ;
    var userId = gUserID ;

    $.m({
		ClassName: "PHA.HERB.Return.Save",
		MethodName: "SaveMulti",
        paramsStr: returnItmArr ,
        phaLocId: phaLocId ,
        userId: userId
	}, function (retData) {
		var retArr = retData.split("^")
        var retVal = retArr[0];
		if (retVal < 0) {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
        }
        else {
            var intrType = "YH"
            PHA_COM.SaveCACert({
                signVal: retVal,
                type: intrType
            })
            HERB_PRINTCOM.ReturnDoc(retVal, '');
        }
        QueryRetRequest() ;
		QueryReturnDetail() ;
	});

}

function RefuseReturn(){
    $.messager.alert("��ʾ", "��δ����", "info");

}
