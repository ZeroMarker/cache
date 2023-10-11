/**
 * FileName: scripts/dhcinsu/revstrnsLog.js
 * hznzh
 * Date: 2021-09-14
 * Description: ��������
 */
var GV = {

	HospId: session['LOGON.HOSPID'],
	UserCode: session['LOGON.USERCODE'],
	UserId: session['LOGON.USERID'],
	HiType: ""
}

$(document).ready(function () {

	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	var HospIdTdWidth = $("#HospIdTd").width()    //��ʼ��Ժ�����  2023/2/8 jins1010
	var opt = { width: HospIdTdWidth }
	var hospComp = GenUserHospComp(opt);
	$.extend(hospComp.jdata.options, {
		onSelect: function (index, row) {
			Clean();
			LoadTrnsList();
		},
		onLoadSuccess: function (data) {
			Clean();
			initMenu();
		}
	});
});
function initMenu() {
	//��ʼ����ѯ����
	init_SearchPanel();

	//�س��¼�
	init_Keyup();

	//��ť�¼�
	init_Btn();

	//InvList
	init_dg();

	//���ڳ�ʼ��
	init_Date();

	//��ʼ�������¼
	InitAdmLst();
}
function init_Date() {
	InsuDateDefault('StartDate', -1);
	InsuDateDefault('EndDate');
}
function init_SearchPanel() {
	InitInsuTypeCmb();
	$('#RevsStas').combobox({
		panelHeight: 100,
		valueField: 'Code',
		textField: 'Desc',
		data: [{
			Code: '',
			Desc: 'ȫ��',
			selected: true
		}, {
			Code: '0',
			Desc: 'δ����'
		}, {
			Code: '1',
			Desc: '�ѳ���'
		}]

	});
	$('#IsRevs').combobox({
		panelHeight: 100,
		valueField: 'Code',
		textField: 'Desc',
		limitToList: true,
		data: [{
			Code: '',
			Desc: 'ȫ��',
			selected: true
		}, {
			Code: '0',
			Desc: '��'
		}, {
			Code: '1',
			Desc: '��'
		}],
		onLoadSuccess: function () {
			$('#IsRevs').combobox('select', 1);
		}
	});
	$('#Infno').combobox({
		panelHeight: 100,
		valueField: 'Code',
		textField: 'Desc',
		data: [{
			Code: '',
			Desc: 'ȫ��',
			selected: true
		}, {
			Code: '2401',
			Desc: '2401-��Ժ����'
		}, {
			Code: '2304',
			Desc: '2304-סԺ����'
		},
		{
			Code: '2207',
			Desc: '2207-�������'
		}, {
			Code: '2208',
			Desc: '2208-������㳷��'
		}, {
			Code: '2305',
			Desc: '2305-סԺ���㳷��'
		}, {
			Code: '2102',
			Desc: '2102-ҩ�����'
		}, {
			Code: '2103',
			Desc: '2103-ҩ����㳷��'
		}]
	});
	if (GV.UserCode != "") {
		setValueById('UserCode', GV.UserCode);

		//$("#UserCode").attr("readOnly",true);
		$("#UserCode").attr("onfocus", "this.blur()");
		$("#UserCode").css("background", "#F7F7F7");
	}
	$("#info").select();
	$('#InfoWin').dialog({

		buttons: [{
			text: '�ر�',
			handler: function () {
				$('#InfoWin').dialog('close');
			}
		},
		{
			text: '����',
			handler: function () {
				//copyText($("#copyInfo").text());
				//var text = document.getElementById("copyInfo").innerText;
				//var input = document.getElementById("input");
				//input.value = text; // �޸��ı��������
				//input.select(); // ѡ���ı�
				//document.execCommand("copy"); // ִ���������������
				//$.messager.alert("��ʾ", "���Ƴɹ�!", 'info');

				//upt HanZH 20220930
				var pre = document.getElementById("copyInfo")
				var text = pre.innerText;
				var input = $("<textarea></textarea>");
				input.text(text); // �޸��ı��������
				input.appendTo(pre);
				input.select(); // ѡ���ı�
				document.execCommand("copy"); // ִ���������������
				input.remove();
				//$.messager.alert("��ʾ", "���Ƴɹ�!", 'info');
				$.messager.popover({
					msg: '���Ƴɹ���',
					type: 'info',
					timeout: 1000, 		//0���Զ��رա�3000s
					showType: 'slide'
				});
			}
		}]
	})
}

// TrnsList
function LoadTrnsList() {

	if (GV.HiType == "") { $.messager.alert("��ʾ", "��ѡ��ҽ������", 'info'); return; }

	ClearGrid('dg');
	var queryParams = { // StDate, EnDate, HospId, RevsStas, IsRevs, UserCode, Infno, PsnNo, SenderTrnsSn, AdmDr, PrtDr, BillDr
		ClassName: 'INSU.MI.BL.RevsTrnsLogCtl',
		QueryName: 'QueryRevsTrnsLog',
		StDate: getValueById('StartDate'),
		EndDate: getValueById('EndDate'),
		HiType: GV.HiType,
		HospId: GV.HospId,
		RevsStas: $('#RevsStas').combobox('getValue'),
		IsRevs: $('#IsRevs').combobox('getValue'),
		UserCode: getValueById('UserCode'),
		Infno: $('#Infno').combobox('getValue'),
		PsnNo: getValueById('PsnNo'),
		SenderTrnsSn: getValueById('SenderTrnsSn'),
		AdmDr: getValueById('AdmDr'),
		PrtDr: getValueById('PrtDr'),
		BillDr: getValueById('BillDr')
	}
	loadDataGridStore('dg', queryParams);
}


/**
 * Creator: hanzh
 * CreatDate: 2021-09-16
 * Description: ��ѯ���س��¼�
 */
function init_Keyup() {
	$('#UserCode').keyup(function () {

		if (event.keyCode == 13) {

			Clean();
			LoadTrnsList();
		}
	});
	//�ǼǺŻس��¼�
	$("#RegNo").keyup(function () {
		if (event.keyCode == 13) {
			Clean(1);
			var tmpRegNo = $('#RegNo').val();
			if (tmpRegNo == "") {
				$.messager.alert("��ʾ", "�ǼǺŲ���Ϊ��!", 'info');
				return;
			}
			var RegNoLength = 10 - tmpRegNo.length;     //�ǼǺŲ���   	
			for (var i = 0; i < RegNoLength; i++) {
				tmpRegNo = "0" + tmpRegNo;
			}
			RegNo = tmpRegNo;
			setValueById('RegNo', RegNo)              //�ǼǺŲ�ȫ���д
			AdmDr = "";
			var rtn = ""
			rtn = tkMakeServerCall("INSU.MI.BL.RevsTrnsLogCtl", "GetPatInfoByPatNo", "", "", RegNo, GV.HospId);
			if (typeof rtn != "string") {
				return;
			}
			if (rtn.split("!")[0] != "1") {
				setTimeout(function () { $.messager.alert('��ʾ', '��������ȷ�ĵǼǺ�!', 'error') }, 200);
				return;
			}
			else {
				var PatAry = (rtn.split("!")[1]).split("^");
				setValueById("PapmiDr", PatAry[0]);        //DingSH 2021-09-17
				QryAdmLst();
			}
		}

	});
	$('#PsnNo').keyup(function () {
		if (event.keyCode == 13) {
			Clean();
			LoadTrnsList();
		}
	});
	$('#SenderTrnsSn').keyup(function () {
		if (event.keyCode == 13) {
			Clean();
			LoadTrnsList();
		}
	});

	$('#AdmDr').keyup(function () {
		if (event.keyCode == 13) {
			LoadTrnsList();
		}
	});
	$('#PrtDr').keyup(function () {
		if (event.keyCode == 13) {
			LoadTrnsList();
		}
	});
	$('#BillDr').keyup(function () {
		if (event.keyCode == 13) {
			LoadTrnsList();
		}
	});
}
function ClearPaadmInfo(AFlag) {
	AdmDr = "";
	//setValueById('AdmDate',"");
	$HUI.combogrid("#AdmLst").clear();
	$('#AdmLst').combogrid('grid').datagrid("loadData", { total: -1, rows: [] });
}

//��ʼ�������¼����
function InitAdmLst() {
	$('#AdmLst').combogrid({
		panelWidth: 380,
		method: 'GET',
		idField: 'AdmDr',
		textField: 'AdmNo',
		columns: [[
			{ field: 'AdmDr', title: 'AdmDr', width: 60 },
			{ field: 'DepDesc', title: '�������', width: 160 },
			{ field: 'AdmDate', title: '��������', width: 100 },
			{ field: 'AdmTime', title: '����ʱ��', width: 100 }
		]],
		onClickRow: function (rowIndex, rowData) {
			var AdmLstVal = rowData.DepDesc + "-" + rowData.AdmDate;  //+" "+rowData.AdmTime
			$('#AdmLst').combogrid("setValue", AdmLstVal);
			setValueById('AdmDr', rowData.AdmDr);
		},

		onLoadSuccess: function (data) {
			if (data.total < 0) {
				return;
			}
			if (data.total == 0) {
				$.messager.alert("��ʾ", "û�в�ѯ�����˾����¼!", 'info');
				return;
			}
			else {
				var rowData = data.rows[0];
				$('#AdmLst').combogrid("setValue", rowData.DepDesc + "-" + rowData.AdmDate); //+" "+rowData.AdmTime
				setValueById('AdmDr', rowData.AdmDr)

			}

		}
	});

}

//��ѯ�����¼����
function QryAdmLst() {
	var tURL = $URL + "?ClassName=" + 'INSU.MI.BL.RevsTrnsLogCtl' + "&MethodName=" + "GetPaAdmListByPatNo" + "&PapmiNo=" + getValueById('RegNo') + "&itmjs=" + "HUIToJson" + "&itmjsex=" + "" + "&HospDr=" + GV.HospId
	$('#AdmLst').combogrid({ url: tURL });
	//s AdmDr=
	//setValueById('AdmDr',rowData.AdmDr);
}
/**
 *��ťClick�¼�
*/
function init_Btn() {
	//��ѯ��ť�¼�
	$("#btnFind").click(function () {
		LoadTrnsList();
	});

	//������ť�¼�
	$("#btnTrns").click(function () {
		RevsTrns();
	});
	//������ť�¼�
	$("#btnClear").click(function () {
		Clean();
	});

}
//grid
function init_dg() {
	grid = $('#dg').datagrid({
		autoSizeColumn: false,
		fit: true,
		striped: false,
		singleSelect: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		border: false,
		cache: true,
		pagination: true,
		frozenColumns: [[
			{ field: 'Ind', title: '���', width: 60 },
			{ field: 'Rowid', title: '�������ױ�Id', width: 60, hidden: true },
			{ field: 'PapmiNo', title: '�ǼǺ�', width: 100 },
			{ field: 'Name', title: '����', width: 80 },
			{ field: 'Poolarea', title: 'ͳ����', width: 100 },
			{ field: 'InfnoDesc', title: '��������', width: 80 },
			{ field: 'HiType', title: 'ҽ������', width: 80, hidden: true },
			{ field: 'HiTypeDesc', title: 'ҽ������', width: 80 },
			{ field: 'tPsnNo', title: '���˱��', width: 220 },
			{ field: 'tSenderTrnsSn', title: '���ͷ�������ˮ��', width: 255 },
			{ field: 'RevsStas', title: '����״̬', width: 80, styler: setRevsStasStyle, align: 'center' },
			{ field: 'IsRevs', title: '�Ƿ�ɳ���', width: 80, styler: setIsRevsStyle, align: 'center' },
			{ field: 'TrnsInptPara', title: '���', width: 50, formatter: setInputInfoFormatter },
			{ field: 'TrnsOutPara', title: '����', width: 50, formatter: setResponseInfoFormatter },
			{ field: 'PoolareaNo', title: 'ͳ�������', width: 80 },
			{ field: 'Infno', title: '���״���', width: 80 }
		]],
		columns: [[ // PrtRowID:%String,PrtInv:%String,PatName:%String,PatIPNo:%String,PrtAcount:%String,PrtPayMode:%String,TMyRealAmt:%String,TPrtDate,TPrtTime
			{ field: 'RevsOpterName', title: '��������Ա', width: 100 },
			{ field: 'RevsOptDate', title: '��������', width: 100 },
			{ field: 'RevsOptTime', title: '����ʱ��', width: 100 },
			{ field: 'UserName', title: '������', width: 100 },
			{ field: 'CrteDate', title: '��������', width: 100 },
			{ field: 'CrteTime', title: '����ʱ��', width: 80 },
			{ field: 'PapmiDr', title: '������Ϣ��Dr', width: 100 },
			{ field: 'tAdmDr', title: '�����Dr', width: 70 },
			{ field: 'tPrtDr', title: '��Ʊ��Dr', width: 70 },
			{ field: 'tBillDr', title: '�˵���Dr', width: 70 },
			{ field: 'TrnsLogDr', title: '������־ָ��', width: 80, hidden: true },
			{ field: 'RevsTrnsMsgId', title: '�������ױ���ID', width: 120, hidden: true },
			{ field: 'RecerTrnsSn', title: '���շ�������ˮ��', width: 120, hidden: true }

		]],
		onSelect: function (rowIndex, rowData) {
			//setValueById('PsnNo',rowData.tPsnNo);		WangXQ 20221024
			//setValueById('SenderTrnsSn',rowData.tSenderTrnsSn);
			SetBtnIsDisabled(rowData.RevsStas, rowData.IsRevs);  //20210916 DingSH
		},
		onUnselect: function (rowIndex, rowData) {
		},
		onBeforeLoad: function (param) {
		},
		onLoadSuccess: function (data) {

		}
	});
}
function ClearGrid(gridid) {
	$('#' + gridid).datagrid('loadData', { total: 0, rows: [] });
}

function setInputInfoFormatter(value, row, index) {
	if (row.TrnsInptPara == "") {
		return;
	}
	return "<span class='linkinfo' style='color:#339EFF' onclick='showInputJson(" + row.TrnsLogDr + "," + row.Infno + ")'>����</span>";
}

function setResponseInfoFormatter(value, row, index) {
	if (row.TrnsOutPara == "") {
		return;
	}
	return "<span class='linkinfo' style='color:#339EFF' onclick='showResponseJson(" + row.TrnsLogDr + "," + row.Infno + ")'>����</span>";
}
function showInputJson(RowID, Infno) {
	$("#info").html("");
	var ret = $m({
		ClassName: "INSU.MI.BL.TrnsLogCtl",
		MethodName: "GetTrnsParaById",
		RId: RowID,
		KeyCode: "INPUT"
	}, false);
	try {
		ret = JSON.stringify(JSON.parse(ret), null, 4);
	} catch (ex) { }
	//$("#info").html("<input id='input'>"+"<pre id='copyInfo'>"+ret+"</pre>"+"</input>");
	$("#info").html("<pre id='copyInfo'>" + ret + "</pre>");	 //upt 20220930 HanZH
	$('#InfoWin').dialog({ position: 'center' });               //upt 20220930 JInS1010 
	$('#InfoWin').dialog("setTitle", Infno + "-�������");       //upt 20220930 JInS1010
	$('#InfoWin').dialog("open");

}
function showResponseJson(RowID, Infno) {
	$("#info").html("");
	var ret = $m({
		ClassName: "INSU.MI.BL.TrnsLogCtl",
		MethodName: "GetTrnsParaById",
		RId: RowID,
		KeyCode: "OUTPUT"
	}, false);
	try {
		ret = JSON.stringify(JSON.parse(ret), null, 4);
	} catch (ex) { }
	//$("#info").html("<input id='input'>"+"<pre id='copyInfo'>"+ret+"</pre>"+"</input>");
	$("#info").html("<pre id='copyInfo'>" + ret + "</pre>");	 //upt 20220930 HanZH
	$('#InfoWin').dialog({ position: 'center' });               //upt 20220930 JInS1010       
	$('#InfoWin').dialog("setTitle", Infno + "-���׳���");       //upt 20220930 JInS1010
	$('#InfoWin').dialog("open");

}

function setRevsStasStyle(value, row, index) {
	if (value == "�ѳ���") return "color:red;";
	if (value == "δ����") return "color:green;";
}
function setIsRevsStyle(value, row, index) {
	if (value == "��") return "color:red;";
	if (value == "��") return "color:green;";
}
function Clean() {

	setValueById('PsnNo', ''); NotClearRegFlag = arguments[0]; //DingSH 2021-09-17
	setValueById('RevsStas', '');
	setValueById('Infno', '');
	setValueById('SenderTrnsSn', '');
	setValueById('UserCode', GV.UserCode); //
	if (!NotClearRegFlag) { setValueById('RegNo', ''); }
	setValueById('AdmLst', '');
	setValueById('AdmDr', '');
	setValueById('PrtDr', '');
	setValueById('BillDr', '');
	setValueById('PapmiDr', ''); //DingSH 2021-09-17
	//setValueById('StartDate',getDefStDate(0));
	//setValueById('EndDate',getDefStDate(0));
	ClearGrid('dg');
	setValueById('StartDate', "");	//����������Ҳ�� WangXQ 20221024
	setValueById('EndDate', "");
}
function RevsTrns() {
	var selectedRow = $('#dg').datagrid('getSelected');
	if (!selectedRow) {
		$.messager.alert('��ʾ', '��ѡ��һ����¼��');
		return;
	}

	var RevsStas = selectedRow.RevsStas;
	if (RevsStas == "�ѳ���") {
		$.messager.alert('��ʾ', '�ѳ�����¼�������������');
		return;
	}
	var IsRevs = selectedRow.IsRevs;
	if (IsRevs == "��") {
		$.messager.alert('��ʾ', '���ɳ�����¼�������������');
		return;
	}
	//var PsnNo=getValueById('PsnNo');
	var PsnNo = selectedRow.tPsnNo;	//��ѡ���л�ȡ	WangXQ 20221024
	var oinfno = selectedRow.Infno;
	//var omsgid=getValueById('SenderTrnsSn');
	var omsgid = selectedRow.tSenderTrnsSn;	//��ѡ���л�ȡ	WangXQ 20221024
	//var ExpStr=getValueById('HiType')+"^"+selectedRow.Rowid;
	var ExpStr = selectedRow.HiType + "^" + selectedRow.Rowid;	//��ѡ���л�ȡ	WangXQ 20221024
	var rtn = InsuReverse(0, GV.UserId, PsnNo, oinfno, omsgid, ExpStr); //DHCInsuPort.js
	if (rtn == "0") {
		$.messager.alert('��ʾ', '�����ɹ�', 'info');
		LoadTrnsList();
		return;
	} else {
		$.messager.alert('��ʾ', '����ʧ��', 'error');
		return;
	}
}
/*
 * ҽ������combogrid
 */
function InitInsuTypeCmb() {
	var options = {
		hospDr: GV.HospId,
		defaultFlag: "N"
	}
	INSULoadDicData("HiType", "DLLType", options); // dhcinsu/common/dhcinsu.common.js
	$HUI.combobox("#HiType", {
		onSelect: function (rec) {
			GV.HiType = rec.cCode;
		},
		onLoadSuccess: function () {
			$('#HiType').combobox('select', "00A");
		}
	});
}
//���ð�ť�Ƿ����
function SetBtnIsDisabled(RevsStasDesc, IsRevsDesc) {
	if (IsRevsDesc == "��") { disableById("btnTrns"); return;/*����*/ }

	switch (RevsStasDesc) {
		case "δ����":
			enableById("btnTrns");    /*����*/
			break;
		case "�ѳ���":
			disableById("btnTrns");   /*����*/
			break;
		default:
			enableById("btnTrns");    /*����*/
			break;
	}
}
