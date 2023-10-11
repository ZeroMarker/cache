/**
 * ģ��:     ��ҩ���뵥��ҩ������Ԥ��ģʽ��
 * ��д����: 2022-09-26
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
    PHA_COM.SetPanel('#pha_herb_v2_retbyreqprescmode', $('#pha_herb_v2_retbyreqprescmode').panel('options').title);
    InitDict();
    InitGridRequest();
    InitSetDefVal();
    InitEvent();
    ResizePanel();
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

/* ��ť�¼� */
function InitEvent(){
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
    $("#btnReturn").on("click", ClickReturnBtn);
    $("#txtPatName").validatebox("setDisabled",true);
}

// ���ֵ���
function ResizePanel(){
    setTimeout(function () {    
        var flag = 0.4;
        if(PHA_COM.Window.Width()<1500 ){flag = 0.5}         
        PHA_COM.ResizePanel({
            layoutId: 'layout-herb��grid',
            region: 'west',
            width: flag
        });
        PHA_COM.ResizePanel({
            layoutId: 'layout-herb��grid-list',
            region: 'south',
            height: 0.6 
        });
    }, 0);
}

// ���뵥�б�
function InitGridRequest() {
    var columns = [
        [	{
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
        onClickRow: function (rowIndex, rowData) {
			var prescNo = rowData.prescNo;
			PrescView(prescNo);
		},
        onLoadSuccess: function () {
            var rows = $("#gridRequest").datagrid("getRows");
		    if (rows.length > 0) {
				$('#gridRequest').datagrid('selectRow', 0);
				var gridSelectRows = $("#gridRequest").datagrid("getSelections") ;
				var gridSelect = gridSelectRows[0] ;
				var prescNo = gridSelect.prescNo;
				PrescView(prescNo);
			}
        }
    }
	PHA.Grid("gridRequest", dataGridOption);
}

/**
 * ����Ԥ��
 * @method PrescView
 */
function PrescView(prescNo){
	if (prescNo == ""){
		$("#ifrm-PreViewPresc").attr("src", "");
		return;
	}

	var phbdType = "OP";
	if(prescNo.indexOf("I")>-1){
		phbdType = "IP";
	}
	var cyFlag = "Y";
	var zfFlag = "�׷�"
	var useFlag = "4"       // �ѷ�ҩ
    
	PHA_HERB.PREVIEW({
        prescNo: prescNo,           
        preAdmType: phbdType,
        zfFlag: zfFlag,
        prtType: 'DISPPREVIEW',
        useFlag: useFlag,
        iframeID: 'ifrm-PreViewPresc',
        cyFlag: cyFlag
    });
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
    PrescView("");
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


/// ��ӡ��ҩ��
function Print() {
	$.messager.alert("��ʾ", "��δ����", "info");
	
}

/// �����ҩ��ť
function ClickReturnBtn(){
	PHA_COM.CACert("PHAHERBRETURN", DoReturn);	
}

function DoReturn(){
	var gridSelect = $("#gridRequest").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ������ҩ�Ĵ���!","info");
		return;
	}
	var phbrrId = gridSelect.phbrrId ;
	var prescNo = gridSelect.prescNo ;
	var userId = gUserID ;
	var reasonId = ""

    $.m({
		ClassName: "PHA.HERB.Return.Biz",
		MethodName: "ReturnPresc",
        phbrrId: phbrrId ,
        prescNo: prescNo ,
        userId: userId,
        reasonId: ''
	}, function (retData) {
		var retArr = retData.split("^")
        var retVal = retArr[0];
		if (retVal < 0) {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
        }
        else {
            if (prescNo.indexOf("I") > -1){
                var intrType = "YH"
            }
            else {
                var intrType = "HH"
            }
            PHA_COM.SaveCACert({
                signVal: retVal,
                type: intrType
            })
            HERB_PRINTCOM.ReturnDoc(retVal, '');
        }
        QueryRetRequest() ;
        PrescView();
	});

}

