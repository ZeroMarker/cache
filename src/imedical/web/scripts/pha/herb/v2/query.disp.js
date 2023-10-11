/**
 * @ģ��:     ��ҩ������ҩ��ѯ
 * @��д����: 2021-01-07
 * @��д��:   MaYuqiang
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var ComPropData		// ��������
var AppPropData		// ģ������
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	InitDict();
	InitGridPrescList();
	InitSetDefVal();
	InitEvent();            //  ��ť�¼�
	ResizePanel();          //  ���ֵ���
	InitConditionFold();
});

//�����۵�
function InitConditionFold()
{
	PHA.ToggleButton("moreorless", {
        buttonTextArr: [$g('����'), $g('����')],
        selectedText: $g('����'),
        onClick: function(oldText, newText){
        }	
    });	

    $("#moreorless").popover({
        trigger: 'click',	
        placement: 'auto',
        content: 'content',
        dismissible: false,
        width: 1050,
        padding: false,
        url: '#js-pha-moreorless'
    });
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

    $("#conStartDate").datebox("setValue", ComPropData.QueryStartDate);
    $("#conEndDate").datebox("setValue", ComPropData.QueryEndDate);
	$('#conStartTime').timespinner('setValue', ComPropData.QueryStartTime);
	$('#conEndTime').timespinner('setValue', ComPropData.QueryEndTime);
	
}

function InitDict() {
    var combWidth = 160;
    // ��ҩ����
    PHA.ComboBox('conPhaLoc', {
        url: PHA_HERB_STORE.UserLoc('D').url,
		panelHeight: 'auto',
		width: combWidth,
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', gLocId);
        }
    });
    // ��������
    PHA.ComboBox('conAdmType', {
        width: combWidth,
        data: [
            { RowId: 'O,E', Description: $g('�ż���') },
            { RowId: 'I', Description: $g('סԺ') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
	});
	// ��������
    PHA.ComboBox('conDocLoc', {
        url: PHA_STORE.DocLoc().url,
        width: combWidth
    });
	// ��ǰִ��״̬
	PHA.ComboBox("conState", {
		url: PHA_HERB_STORE.Process(gLocId,'All',gHospId,'').url,
		width: combWidth,
		onLoadSuccess: function(){
			//$("#cmbPhaLoc").combobox("setValue", gLocId);
		}
	});
	// ��ҩ��ʽ
    PHA.ComboBox('conCookType', {
        width: combWidth,
        url: PHA_HERB_STORE.CookType('', gLocId).url,
        panelHeight: 'auto'
	});
	// ��ҩ��������
    PHA.ComboBox('conForm', {
        width: combWidth,
        url: PHA_HERB_STORE.HMPreForm(gLocId).url
	});
	// ҩƷ��Ϣ
	var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
        width: 238
    });
    PHA.LookUp('conInci', opts);
	// ��Ժ��ҩ
	PHA.ComboBox('conOut', {
        data: [
            { RowId: 'equal', Description: $g('����') },
            { RowId: 'not', Description: $g('����') }
        ],
        width: combWidth,
        panelHeight: 'auto',
        onSelect: function () {}
    });
	// Э����
    PHA.ComboBox('conAgreePre', {
        width: combWidth,
        data: [
            { RowId: 'equal', Description: $g('����') },
            { RowId: 'not', Description: $g('����') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
    });
	// �����ѱ�
    PHA.ComboBox('conBillType', {
        width: combWidth,
        url: PHA_STORE.PACAdmReason(gHospId).url
    });
    // ��ҩ����
    PHA.ComboBox('conWardLoc', {
        url: PHA_STORE.WardLoc().url,
        width: combWidth
	});
    // �����Ƴ�
    PHA.ComboBox('conDuration', {
        url: PHA_STORE.PHCDuration().url,
        width: combWidth
	});
    
	
	PrescView("");
}

/* ��ť�¼� */
function InitEvent(){
	$('#btnFind').on('click', QueryHandler);
	$('#btnClean').on('click', Clear);
	// ��Ϊ����
	$('#btnSaveAgreeRet').on('click', SaveAgreeRet);
	// ��ӡ��ҩ��
	$('#btnPrintPYD').on('click', PrintPYD);
	// ��ӡ����
	$('#btnPrintPresc').on('click', PrintPresc);
	//�ǼǺŻس��¼�
	$('#conPatNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#conPatNo").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryHandler();
			}	
		}
	});
	
	//���Żس��¼�
	$('#txtCardNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardno=$.trim($("#txtCardNo").val());
			if (cardno!=""){
				BtnReadCardHandler();
			}
			SetFocus();	
		}
	});
	
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	});

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

/**
 * ��ʼ�������б�
 * @method InitGridPrescList
 */
function InitGridPrescList() {
	var columns = [
		[	 {
				field: 'TPrescNo',
				title: '������',
				align: 'left',
				width: 130,
				formatter: function (value, row, index) {
					return '<a class="pha-grid-a js-grid-oeore">' + value + '</a>';
					//var qOpts = "{prescNo:'" + row.TPrescNo + "'}";
					//return '<a class="pha-grid-a" onclick="PHAHERB_COM.TimeLine({},' + qOpts + ')">' + value + '</a>';
                }
			},{
				field: 'TState',
				title: '��ǰ״̬',
				align: 'left',
				width: 90
			}, {
				field: 'TPatName',
				title: '����',
				align: 'left',
				showTip: true,
				tipWidth: 100,
				width: 70
			}, {
				field: 'TPmiNo',
				title: '�ǼǺ�',
				align: 'left',
				width: 100,
				formatter: function (value, row, index) {
                    var qOpts = "{AdmId:'" + row.TAdm + "'}";
                    return '<a class="pha-grid-a" onclick="PHA_UX.AdmDetail({},' + qOpts + ')">' + value + '</a>';
                }
			}, {
				field: 'TPatLoc',
				title: '��������/����(����)',
				align: 'left',
				showTip: true,
				tipWidth: 200,
				width: 150
			}, {
				field: 'TPrescForm',
				title: '��������',
				align: 'left',
				showTip: true,
				width: 80
			}, {
				field: 'TPreDur',
				title: '�Ƴ�(����)',
				align: 'left',
				width: 80
			}, {
				field: 'TCookType',
				title: '��ҩ��ʽ',
				align: 'left',
				showTip: true,
				width: 80
			}, {
				field: 'TDispWin',
				title: '��ҩ����',
				align: 'left',
				showTip: true,
				width: 80
			},  {
				field: 'TPrescAmt',
				title: '�������',
				align: 'left',
				width: 80
			},{
				field: 'TCookCost',
				title: '��ҩ��/����״̬',
				align: 'left',
				showTip: true,
				width: 180
			}, {
				field: 'TBillType',
				title: '�ѱ�',
				align: 'left',
				width: 80
			}, {
				field: 'TMBDiagnos',
				title: '�������',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TDiag',
				title: '���',
				align: 'left',
				showTip: true,
				width: 150
			}, {
				field: 'TAgreeFlag',
				title: '�Ƿ����',
				align: 'left',
				width: 80,
				formatter: function (value, row, index) {
                    var qOpts = "{phbdId:'" + row.TPhbdId + "'}";
                    return '<a class="pha-grid-a" onclick="PHAHERB_COM.AgreeRetReason({},' + qOpts + ')">' + value + '</a>';
					
                }
			}, {
				field: 'TPatSex',
				title: '�Ա�',
				align: 'left',
				width: 50
			}, {
				field: 'TPatAge',
				title: '����',
				align: 'left',
				width: 50
			}, {
				field: 'TEmergFlag',
				title: '�Ƿ�Ӽ�',
				align: 'left',
				width: 70
			}, {
				field: 'TAdm',
				title: 'TAdm',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TPapmi',
				title: 'TPapmi',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TOeori',
				title: 'TOeori',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TEncryptLevel',
				title: '�����ܼ�',
				align: 'left',
				width: 80,				
				hidden: true
			}, {
				field: 'TPatLevel',
				title: '���˼���',
				align: 'left',
				width: 80,				
				hidden: true
			}, {
				field: 'TPhbdId',
				title: 'TPhbdId',
				align: 'left',
				width: 80,				
				hidden: true
			}, {
				field: 'TOeore',
				title: 'TOeore',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TPrescFormula',
				title: 'Э����',
				align: 'left',
				showTip: true,
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: '',
		fit: true,
		rownumbers: true,
		columns: columns,
		nowrap: true,
		pagination: true,
		singleSelect: true,
        pageNumber: 1,
        pageSize: 100,
		toolbar: "#gridHerbPrescListBar",
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Query.Dispen",
			QueryName: "GetPrescList",
		},
		onClickRow: function (rowIndex, rowData) {
			var prescNo = rowData.TPrescNo;
			PrescView(prescNo);
		}
	};
	PHA.Grid("gridHerbPrescList", dataGridOption);

	PHA.GridEvent('gridHerbPrescList', 'click', ['pha-grid-a js-grid-oeore', 'pha-grid-a js-grid-patNo'], function (rowIndex, rowData, className) {
        var winWidth = $('body').width()*0.8;
        if (className === 'pha-grid-a js-grid-oeore') {
            PHA_UX.TimeLine(
                {
                    modal: true,
                    modalable:true,
                    width: winWidth - 20,
                    top: null,
                    left: null
                },
                { oeore: rowData.TOeori }
            );
        }
    });
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

/**
 * ��ѯ����
 * @method QueryHandler
 */
function QueryHandler() {
	$('#gridHerbPrescList').datagrid('clear');
	PrescView("") ;
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridHerbPrescList').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});	 
}

/**
 * ��ѯ������JSON
 * @method GetQueryParamsJson
 */
function GetQueryParamsJson() {
    return {
        startDate: $("#conStartDate").datebox('getValue'),
        endDate: $("#conEndDate").datebox('getValue'),
        startTime: $('#conStartTime').timespinner('getValue'),
        endTime: $('#conEndTime').timespinner('getValue'),
		phaLocId: $('#conPhaLoc').combobox('getValue') || '',
		admType: $('#conAdmType').combobox('getValue') || '',
		patNo: $('#conPatNo').val(),
		prescNo: $('#conPrescNo').val(),
		docLocId: $('#conDocLoc').combobox('getValue') || '',
		curState: $('#conState').combobox('getValue') || '',
		cookType: $('#conCookType').combobox('getValue') || '',
		preFormCode: $('#conForm').combobox('getValue') || '',
		inci: $('#conInci').lookup('getValue') || '',
		outFlag: $('#conOut').combobox('getValue') || '',
		agreePre: $('#conAgreePre').combobox('getValue') || '',
		billType: $('#conBillType').combobox('getValue') || '' ,
		wardLocId: "",	//$('#conWardLoc').combobox('getValue') || '',
		durationId: $('#conDuration').combobox('getValue') || '',
		queryMenu: "queryDisp"     
    };
}


/*
 * ����
 * @method Clear
 */
function Clear() {
	$('#gridHerbPrescList').datagrid('clear');
	PrescView("");
	InitSetDefVal();
	$('#conPhaLoc').combobox('selectDefault', gLocId);
	$('#conAdmType').combobox('clear');
	$('#conPatNo').val("");
	$('#conPrescNo').val("");
	$('#conDocLoc').combobox('clear');
	$('#conState').combobox('clear');
	$('#conCookType').combobox('clear');
	$('#conForm').combobox('clear');
	$('#conInci').lookup('clear');
	$('#conOut').combobox('clear');
	$('#conAgreePre').combobox('clear');
	$('#conBillType').combobox('clear');
	$('#conDuration').combobox('clear');	
}

/*
 * ��Ϊ����
 * @method SaveAgreeRet
 */
function SaveAgreeRet(){
	var gridSelect = $("#gridHerbPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��Ϊ���˵Ĵ���!","info");
		return;
	}
	var phbdId = gridSelect.TPhbdId ;
	var chkRet = tkMakeServerCall("PHA.HERB.Dispen.Save", "ChkAgreeReturnState", phbdId)
	if (chkRet != 0){
		var errMsg = chkRet.split("^")[1];
		$.messager.alert('��ʾ', errMsg , "info");
		return;
	}
	/*
	var dspStatus = gridSelect.TDspStatus ;		//��ҩ״̬
	if (dspStatus.indexOf("��ҩ")<0){
		$.messager.alert('��ʾ',"�ô���δ��ҩ��������Ϊ����!","info");
		return;
	}
	*/
	var htmlStr = '<div class="input-group">'
		htmlStr += 		'<div class="pha-col">' 
		htmlStr +=			'<textarea id="agrretremark" style="width:220px;"> </textarea>'
        htmlStr += 		'</div>'
	    htmlStr += '</div>';
	$.messager.confirm("����ԭ��ע",htmlStr,function(result){
		if(!result) {return};
		var remark = $.trim($("#agrretremark").val()) ;
		var agrRetUserId = gUserID ;	// ��ǰ��¼��
		var params = phbdId + tmpSplit + agrRetUserId + tmpSplit + remark ;
		$.m({
			ClassName: "PHA.HERB.Dispen.Save",
			MethodName: "SaveAgreeRet",
			params: params 
		}, function (retData) {
			var retArr = retData.split("^")
			if (retArr[0] < 0) {
				$.messager.alert('��ʾ', retArr[1], 'warning');
				return;
			}
			else {
				$.messager.alert('��ʾ', "��Ϊ���˳ɹ�", 'success');
			}
			QueryHandler();
		});
		
	});
	
}

/*
 * ��ӡ��ҩ��
 * @method PrintPYD
 */
function PrintPYD(){
	var gridSelect = $("#gridHerbPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert($g('��ʾ'), $g("����ѡ����Ҫ��ӡ��ҩ���Ĵ���"), "info");
		return;
	}
	var phbdId = gridSelect.TPhbdId;
	HERB_PRINTCOM.PYD(phbdId,"");
}

/*
 * ��ӡ����
 * @method PrintPYD
 */
function PrintPresc(){
	var gridSelect = $("#gridHerbPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert($g('��ʾ'), $g("����ѡ����Ҫ��ӡ�Ĵ���"), "info");
		return;
	}

	var prescNo = gridSelect.TPrescNo;
	HERB_PRINTCOM.Presc(prescNo,"");
}

//��������
window.onload=function(){
	setTimeout("QueryHandler()",500);
}
