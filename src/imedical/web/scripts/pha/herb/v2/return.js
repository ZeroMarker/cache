/**
 * ģ��:     ��ҩֱ����ҩ
 * ��д����: 2022-09-26
 * ��д��:   MaYuqiang
 */
PHA_COM.Val.CAModelCode = "PHAHERBRETURN"; 
var DefPhaLocInfo = tkMakeServerCall("web.DHCSTKUTIL", "GetDefaultPhaLoc", gLocId);
var DefPhaLocId = DefPhaLocInfo.split("^")[0] || "";
var DefPhaLocDesc = DefPhaLocInfo.split("^")[1] || "";
var ComPropData		// ��������
var AppPropData		// ģ������
var SelAdmType
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	PHA_COM.SetPanel('#pha_herb_v2_return', $('#pha_herb_v2_return').panel('options').title);
    InitDict();
	InitSetDefVal();
    InitGridDisp();
	ResizePanel();
    $('#txtPatNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#txtPatNo").val());
            if (patNo != "") {
				var newPatNo = NumZeroPadding(patNo,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newPatNo);
                var patInfo = tkMakeServerCall("web.DHCSTPharmacyCommon", "GetPatInfoByNo", newPatNo);
                $("#txtPatName").val(patInfo.split("^")[0] || "");
                QueryDispPresc();
            } else {
                $("#txtPatName").val("");
            }
        }
    });
    $("#btnFind").on("click", QueryDispPresc);
    $("#btnPrint").on("click", Print);
    $("#btnReturn").on("click", ClickReturnBtn);
	$("#txtPatName").validatebox("setDisabled",true);
});

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
	/// ҩ���б�
	PHA.ComboBox("cmbPhaLoc", {
		url: PHA_STORE.Pharmacy().url,
		onLoadSuccess: function(){
			//$("#cmbPhaLoc").combobox("setValue", gLocId);
		},
		onSelect: function (selData) {
            //QueryDispPresc();
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
		panelHeight: "auto"
	});
}

// �ѷ������б�
function InitGridDisp() {
    var columns = [
        [	
        	{
                field: 'TPhbdId',
                title: '��ҩ����Id',
                width: 50,
				hidden:true 
            },{
                field: 'TPmiNo',
				title: '�ǼǺ�',
				align: 'left',
				width: 100,
				formatter: function (value, row, index) {
                    var qOpts = "{AdmId:'" + row.TAdm + "'}";
                    return '<a class="pha-grid-a" onclick="PHA_UX.AdmDetail({},' + qOpts + ')">' + value + '</a>';
                }
            },{
                field: 'TPatName',
                title: '��������',
                width: 120
            },{
                field: 'TPrescNo',
				title: '������',
				align: 'left',
				width: 130
            },{
				field: 'TState',
				title: '��ǰ״̬',
				align: 'left',
				width: 90
			},{
                field: 'TPatLoc',
                title: '�������/����(����)',
                width: 160
            },{
				field: 'TPrescAmt',
				title: '�������',
				align: 'left',
				width: 80
			},{
				field: 'TPrescForm',
				title: '��������',
				align: 'left',
				width: 80
			},{
				field: 'TPreDur',
				title: '�Ƴ�(����)',
				align: 'left',
				width: 100
			},{
				field: 'TCookType',
				title: '��ҩ��ʽ',
				align: 'left',
				width: 80
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
        toolbar: '#gridDispBar',
        onClickRow: function (rowIndex, rowData) {
			var prescNo = rowData.TPrescNo;
			if (prescNo.indexOf("I")>-1){	
				SelAdmType = "I"	
			}
			else {
				SelAdmType = "O"	
			}
			PrescView(prescNo);
			
		},
        onLoadSuccess: function () {
            var rows = $("#gridDispPresc").datagrid("getRows");
		    if (rows.length > 0) {
				$('#gridDispPresc').datagrid('selectRow', 0);
				var gridSelectRows = $("#gridDispPresc").datagrid("getSelections") ;
				var gridSelect = gridSelectRows[0] ;
				var prescNo = gridSelect.TPrescNo;
				if (prescNo.indexOf("I")>-1){	
					SelAdmType = "I"	
				}
				else {
					SelAdmType = "O"	
				}
				PrescView(prescNo);
			}
        }
    }
	PHA.Grid("gridDispPresc", dataGridOption);
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
	var dispFlag = "OK"
	if (dispFlag !== "OK"){
        var useFlag = "3"       // δ��ҩ
    }
    else {
        var useFlag = "4"       // �ѷ�ҩ
    }

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
	var prescNo = $('#txtPrescNo').val(); 
	if ((patNo == "")&&(prescNo == "")){
		$.messager.alert("��ʾ", "�밴�յǼǺŻ��ߴ����Ų�ѯ��", "info");
		return
	}
	if (patNo == ""){
		$("#txtPatName").val("");
	}
	var dispDictId = tkMakeServerCall("PHA.HERB.Com.Method", "GetDictId", "Dispen")
	return {
		startDate: $("#dateColStart").datebox('getValue'),
        endDate: $("#dateColEnd").datebox('getValue'),
        startTime: $('#timeColStart').timespinner('getValue'),
        endTime: $('#timeColEnd').timespinner('getValue'),
        phaLocId: $('#cmbPhaLoc').combobox("getValue"),
        patNo: $('#txtPatNo').val(),
        //patName: $('#txtPatName').val(),
        prescNo: $('#txtPrescNo').val() ,
        curState: dispDictId,
		queryMenu: "return"  
    };
	

}
// ��ѯ
function QueryDispPresc() {
	PrescView("") ;
    var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
    $('#gridDispPresc').datagrid({
        url: $URL,
        queryParams: {
            ClassName: "PHA.HERB.Query.Dispen",
            QueryName: "GetPrescList",
            pJsonStr: JSON.stringify(pJson)
        }
    });
}


/// ��ӡ��ҩ��
function Print() {
	$.messager.alert("��ʾ", "�ش���ҩ���뵽��ҩ����ѯ�����ӡ", "info");
	
}

/// �����ҩ��ť
function ClickReturnBtn(){
	var gridSelect = $("#gridDispPresc").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��ҩ�Ĵ���!","info");
		return;
	}
	var prescNo = gridSelect.TPrescNo ;
	// ���ﴦ��ֱ����ҩ�����жϼƷ��˷�����
	if (prescNo.indexOf("I")<0) {
		var refAppMode = tkMakeServerCall("PHA.FACE.IN.Com","IGetOPRefAppMode",session['LOGON.HOSPID'])
		if (refAppMode != 0){
			$.messager.alert('��ʾ',"�Ʒ��������˷����뷽���˷ѣ�ҩ������ֱ����ҩ�������޸ļƷ����ú�����!","info");
			return;
		}
	}
	PHA_COM.CACert("PHAHERBRETURN", HandleReturn);	
}

function HandleReturn(){
	var gridSelect = $("#gridDispPresc").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ�����˵Ĵ���!","info");
		return;
	}
	var prescNo = gridSelect.TPrescNo ;
	var chkRet = tkMakeServerCall("PHA.HERB.Return.Biz", "CheckReturnState", "", prescNo)
	var chkRetArr = chkRet.split("^")
	if (chkRetArr[0] < 0) {
		$.messager.alert('��ʾ', chkRetArr[1], 'warning');
		return;
	}
	SelRetReason("retReasonWin", ExecuteReturn);
}


function ExecuteReturn(ReasonJson){
	var gridSelect = $("#gridDispPresc").datagrid("getSelected");
	var phbdId = gridSelect.TPhbdId ;
	var prescNo = gridSelect.TPrescNo ;
	var userId = gUserID ;
	var reasonId = ReasonJson.reasonId ;
	if (reasonId == null){
		$.messager.alert('��ʾ',"����ѡ����ҩԭ��!","info");
		return;
	}

    $.m({
		ClassName: "PHA.HERB.Return.Biz",
		MethodName: "ReturnPresc",
        phbrrId: "" ,
        prescNo: prescNo ,
        userId: userId,
        reasonId: reasonId
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
        }
		if (prescNo.indexOf("I") > -1){
			var intrType = "YH"
		}
		else {
			var intrType = "HH"
		}
		PHA_COM.SaveCACert({
			signVal: phbdId,
			type: intrType
		})
        QueryDispPresc() ;
	});

}

function SelRetReason(winId, _fn){
    var $widow = $('#' + winId);
	var marLeft = 10;
	var idText = $g("��ҩԭ��")
	var id = "retReasonId"
	var storeUrl = PHA_HERB_STORE.RetReasonStore(SelAdmType, gHospID).url; 
    if ($widow.length === 0){
        var $widow = $('<div id="'+ winId +'"></div>').appendTo('body');
        $widow.empty();
    }else{
        $('#'+ winId).dialog('open');
        return
    }

    var htmlStr = '<div class = "pha-row" style="margin-top:10px;text-align:center" >'
            +           '<div class="pha-col" style="margin-left:0px;padding-left:0px;">'+idText+'</div>'     
            +           '<div class="pha-col" style="margin-left:0px"><input id = "'+id+'" class = "hisui-combobox" ></div>'
            + '</div>'

    var $toolbar = $(htmlStr).prependTo('#'+ winId);
    PHA_COM.Window.Proportion = 1;
    $widow.dialog({
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        closed: true,               
        modal: true,
        title:  "��ѡ��"+idText,
        width: 300, 
        height: 150,                
        top: (PHA_COM.Window.Height()-250)/2 ,
        left:(PHA_COM.Window.Width()-400)/2 ,
        iconCls:'icon-w-paper',
        buttons:[{
            text:'ȷ��',
            handler:function(){
                var reasonId = $("#"+id).combobox("getValue")||""
                if(reasonId == ""){
					$.messager.alert('��ʾ', "��ѡ��"+idText, 'warning');
                    return
                }
                var retJson = {reasonId:reasonId,reasonDesc:$("#"+id).combobox("getText")||""}
                $('#'+ winId ).dialog('close');
                _fn(retJson);
                
            }
        },{
            text:'�ر�',
            handler:function(){$('#'+ winId ).dialog('close');}
        }],
		onOpen: function(){
            // ��ҩԭ��
            PHA.ComboBox(id,{
                editable:false, 
                url: PHA_HERB_STORE.RetReasonStore(SelAdmType, gHospID).url
            });
        }
    }); 
    $('#'+ winId ).dialog('open');
}

function RefuseReturn(){
    $.messager.alert("��ʾ", "��δ����", "info");

}
