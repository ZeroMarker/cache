/**
 * ���嵼��  dhcpe.importoldginfo.js
 * @Author   ln
 * @DateTime 2022-09-29
 */
var actionListObj = ""
var interval_num = 9; //������ˢ��Ƶ�� ÿinterval_num����¼ˢ��һ��
var aCity = {
	11: "����",
	12: "���",
	13: "�ӱ�",
	14: "ɽ��",
	15: "���ɹ�",
	21: "����",
	22: "����",
	23: "������",
	31: "�Ϻ�",
	32: "����",
	33: "�㽭",
	34: "����",
	35: "����",
	36: "����",
	37: "ɽ��",
	41: "����",
	42: "����",
	43: "����",
	44: "�㶫",
	45: "����",
	46: "����",
	50: "����",
	51: "�Ĵ�",
	52: "����",
	53: "����",
	54: "����",
	61: "����",
	62: "����",
	63: "�ຣ",
	64: "����",
	65: "�½�",
	71: "̨��",
	81: "���",
	82: "����",
	91: "����"
}
var editRows = new Array(); //�༭����������¼
/**��������ɾ������**/
Array.prototype.remove = function(val) {
	var index = this.indexOf(val);
	if (index > -1) {
		this.splice(index, 1);
	}
};

$(init);
function init(){
	$(".datagrid-wrap.panel-body.panel-body-noheader.panel-header-gray").css("border-radius","0 0 4px 4px");
	$(".datagrid-wrap.panel-body.panel-body-noheader.panel-header-gray").css("border-top","0");
	InitCombobox();
	
	InitactionList();  
}

/*var actionListObj = $HUI.datagrid("#actionList", {

	onSelect: function(rowIndex, rowData) {
		if (rowIndex > -1) {
			var p = actionListObj.getPanel();
			p.find("#editIcon").linkbutton("enable", false);
			p.find("#delIcon").linkbutton("enable", false);
		}
	},
	frozenColumns: [
		[{
			field: 'TOperate',
			title: '����',
			width: 60,
			formatter: function(value, row, index) {
				return "<a href='#' onclick='edit_row(\"" + index + "\",this)'>\
					<img style='padding-top:4px;' title='�޸ļ�¼' alt='�޸ļ�¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' border=0/>\
					</a>\
					<a href='#' onclick='delete_row(\"" + index + "\",\"\")'>\
					<img style='margin-left:8px; padding-top:4px;' title='ɾ����¼' alt='ɾ����¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
					</a>";
			}
		}, {
			field: 'TStatus',
			title: '״̬',
			width: 60,
			sortable: 'true',
			align: "center",
			formatter: function(value, row, index) {
				var content = "";
				switch (row.TStatus) {
					case 0:
						content = "δ��֤";
						break;
					case 1:
						content = "��֤ͨ��";
						break;
					case 2:
						content = "����ɹ�";
						break;
					case -1:
						content = "��֤ʧ��";
						break;
					case -2:
						content = "����ʧ��";
						break;
				}
				return "<div style='color:#ffffff;'>" + content + "</div>";
			},
			styler: function(value, row, index) {
				var color = "#ffffff";
				switch (row.TStatus) {
					case 0:
						color = "#40A2DE";
						break;
					case 1:
						color = "#40A2DE";
						break;
					case 2:
						color= "rgb(101, 222, 101)";
						break;
					case -1:
						color = "red";
						break;
					case -2:
						color = "red";
						break;
				}
				return "background-color:" + color + ";";
			},
		}, {
			field: 'TTeam',
			width: 80,
			title: '��������',
			editor: 'text'
		}, {
			field: 'TRegNo',
			width: 100,
			title: '�ǼǺ�',
			editor: 'text'
		}, {
			field: 'TName',
			width: 100,
			title: '����',
			editor: 'text'
		}, {
			field: 'TIDCard',
			width: 180,
			title: '���֤��',
			editor: 'text'
		}, {
			field: 'TTipMsg',
			title: '����ʾ��Ϣ',
			hidden: 'true'
		}]
	],
	columns: [
		[{
			field: 'TSex',
			width: 40,
			align: "center",
			title: '�Ա�',
			editor: 'text'
		}, {
			field: 'TAge',
			width: 40,
			title: '����',
			editor: {
				type: 'numberbox',
				options: {
					min: 1
				}
			}
		}, {
			field: 'TDob',
			width: 80,
			title: '��������',
			editor: 'text'
		}, {
			field: 'TMarital',
			width: 60,
			title: '����״��',
			editor: 'text'
		}, {
			field: 'TTel',
			width: 100,
			title: '�ƶ��绰',
			editor: 'text'
		}, {
			field: 'TTel1',
			width: 100,
			title: '��ϵ�绰',
			editor: 'text'
		}, {
			field: 'TDepartment',
			width: 80,
			title: '����',
			editor: 'text'
		}, {
			field: 'TBeginDate',
			width: 80,
			title: '��ʼ����',
			editor: 'text'
		}, {
			field: 'TEndDate',
			width: 80,
			title: '��������',
			editor: 'text'
		}, {
			field: 'TAsCharged',
			width: 60,
			title: '��ͬ�շ�',
			editor: 'text'
		}, {
			field: 'TRecReport',
			width: 60,
			title: '���˱�����ȡ',
			editor: 'text'
		}, {
			field: 'TCashierType',
			width: 60,
			title: '���㷽ʽ',
			editor: 'text'
		}, {
			field: 'TGAdd',
			width: 60,
			title: '���Ѽ���',
			editor: 'text'
		}, {
			field: 'TAddLimit',
			width: 60,
			title: '����������',
			editor: 'text'
		}, {
			field: 'TAddAmt',
			width: 60,
			title: '������',
			editor: 'text'
		}, {
			field: 'TGMedical',
			width: 60,
			title: '����ҩ',
			editor: 'text'
		}, {
			field: 'TMedicalLimit',
			hidden: true,
			title: '��ҩ�������',
			editor: 'text'
		}, {
			field: 'TMedicalAmt',
			hidden: true,
			title: '��ҩ���',
			editor: 'text'
		}, {
			field: 'TCompany',
			width: 80,
			title: '������λ',
			editor: 'text'
		}, {
			field: 'TNation',
			width: 60,
			title: '����',
			editor: 'text'
		}, {
			field: 'TNewCard',
			width: 60,
			title: '�·���',
			editor: 'text'
		}, {
			field: 'TAddress',
			width: 120,
			title: '��ϵ��ַ',
			editor: 'text'
		}, {
			field: 'TPatType',
			width: 60,
			title: '��������',
			editor: 'text'
		}, {
			field: 'THealthArea',
			width: 100,
			title: '��������',
			editor: 'text'
		}, {
			field: 'TCardNo',
			width: 100,
			title: '���￨��',
			editor: 'text'
		}, {
			field: 'TVIPLevel',
			width: 60,
			title: 'VIP�ȼ�',
			editor: 'text'
		}, {
			field: 'TEmployeeNo',
			width: 80,
			title: '����',
			editor: 'text'
		}, {
			field: 'TFileNo',
			width: 80,
			title: '������',
			editor: 'text'
		}, {
			field: 'TPost',
			width: 80,
			title: 'ְ��',
			editor: 'text'
		}, {
			field: 'TProduct',
			width: 80,
			title: '����',
			editor: 'text'
		}, {
			field: 'TServLength',
			width: 80,
			title: '�Ӻ�����',
			editor: 'text'
		}]
	],
	data: {
		"total": 0,
		"rows": []
	},
	fit: true,
	rownumbers: true,
	fitColumns: true,
	onSortColumn: function(sort, order) {
		sortTStatus(order);
	},
	rowTooltip: function(index, row) { //datagrid��չ����  ��������ʾ��Ϣ
		return row.TTipMsg;
	},
	rowStyler: function(index, row) {
		var rowStyle = "";
		switch (row.TStatus) {
			case 0: //δ��֤
				break;
			case 1: //��֤ͨ��
				break;
			case 2: //����ɹ�
				rowStyle = 'background-color:#65de65;';
				break;
			case -1: //��֤δͨ��
				rowStyle = 'background-color:rgb(251, 136, 226);';
				break;
			case -2: //����δͨ��
				break;
		}
		return rowStyle;
	},
	toolbar: [{
		iconCls: 'icon-add',
		text: '������',
		handler: function() {
			add_row();
		}
	}, {
		iconCls: 'icon-close',
		text: 'ɾ������֤ʧ�ܡ���¼',
		handler: function() {
			delete_row("", -1);
		}
	}, {
		iconCls: 'icon-close',
		text: 'ɾ��������ɹ�����¼',
		handler: function() {
			delete_row("", 2);
		}
	}, {
		iconCls: 'icon-reset',
		text: '�������',
		handler: function() {
			delete_row("", 9);
		}
	}, {
		iconCls: 'icon-reload',
		text: 'ˢ������',
		handler: function() {
			refresh_datagrid();
		}
	}, {
		iconCls: 'icon-export',
		text: '������������',
		handler: function() {
			export_errData();
		}
	}, {
		iconCls: 'icon-key-switch',
		text: '����֤�ɹ�',
		handler: function() {
			update_status(1);
		}
	}]
});
*/
/**
 * [������״̬]
 * @param   {[int]}   status [״̬����]
 * @Author   wangguoying
 * @DateTime 2020-12-02
 */
function update_status(status) {
	var selectObj = $("#actionList").datagrid("getSelected");
	var selectIndex = $("#actionList").datagrid("getRowIndex", selectObj);
	if (selectObj == null) {
		$.messager.alert("��ʾ", "��ѡ�����޸ĵ��м�¼", "info");
		return false;
	}
	selectObj.TStatus = status;
	$('#actionList').datagrid('updateRow', {
		index: selectIndex,
		row: selectObj
	});
}


/**
 * [������������]
 * @Author   wangguoying
 * @DateTime 2020-11-12
 */
function export_errData() {
    var exportData = [];
    var title = ["������Ϣ", "������", "�ǼǺ�", "����", "֤����", "�Ա�", "����", "��������", "����״��", "�ƶ��绰", "��ϵ�绰", "����", "��ʼ����", "��������", "��ͬ�շ�", "���˱�����ȡ", "���㷽ʽ", "���Ѽ���", "����������", "������"];
    exportData.push(title);
    var data = actionListObj.getRows();
    var len = data.length;
    for (var i = 0; i < len; i++) {
        if (data[i].TStatus < 0) {
            var row = [];
            row.push(data[i].TTipMsg);
            row.push(data[i].TTeam);
            row.push(data[i].TRegNo);
            row.push(data[i].TName);
            row.push(data[i].TIDCard);
            row.push(data[i].TSex);
            row.push(data[i].TAge);
            row.push(data[i].TDob);
            row.push(data[i].TMarital);
            row.push(data[i].TTel);
            row.push(data[i].TTel1);
            row.push(data[i].TDepartment);
            row.push(data[i].TBeginDate);
            row.push(data[i].TEndDate);
            row.push(data[i].TAsCharged);
            row.push(data[i].TRecReport);
            row.push(data[i].TCashierType);
            row.push(data[i].TGAdd);
            row.push(data[i].TAddLimit);
            row.push(data[i].TAddAmt);
            exportData.push(row);
        }
    }
    var sheet = XLSX.utils.aoa_to_sheet(exportData);
    download_excel(sheet2blob(sheet), $("#GDesc").val() + '_��������.xlsx');
}


/**
 * [�в���]
 * @param    {[int]}    index [������]
 * @param    {[object]}    t     [��ť����]
 * @Author   wangguoying
 * @DateTime 2020-05-15
 */
function edit_row(index, t) {
	if (editRows.indexOf(index) > -1) {
		t.children[0].alt = "�޸ļ�¼";
		t.children[0].title = "�޸ļ�¼";
		t.children[0].src = "../scripts_lib/hisui-0.1.0/dist/css/icons/pencil.png";
		actionListObj.endEdit(index);
		editRows.remove(index);
		var data = actionListObj.getRows();
		data[index].TStatus = 0;
		data[index].TTipMsg = "";
		actionListObj.loadData(data);
		$("#DisplayMsg").html("�༭ 1 ��¼����ǰ�� " + data.length + " ��¼");
	} else {
		if (editRows.length > 0) {
			$.messager.alert("��ʾ", "����δ��������ݣ��뱣������", "info");
			return false;
		}
		t.children[0].alt = "�����¼";
		t.children[0].title = "�����¼";
		t.children[0].src = "../scripts_lib/hisui-0.1.0/dist/css/icons/save.png";
		actionListObj.beginEdit(index);
		var tr = actionListObj.getRowDom(index);
		tr.tooltip("destroy").children("td[field]").each(function() {
			$(this).tooltip("destroy");
		});
		editRows.push(index);
	}
}



/**
 * [״̬��ð������]
 * @param    {[string]}    order [asc:����  desc:����]
 * @Author   wangguoying
 * @DateTime 2020-05-11
 */
function sortTStatus(order) {
	var data = actionListObj.getRows();
	for (var i = 0; i < data.length; i++) {
		for (var j = 0; j < data.length - i - 1; j++) {
			var preObj = data[j];
			var sufObj = data[j + 1];
			if ((preObj.TStatus > sufObj.TStatus && order == "asc") || (preObj.TStatus < sufObj.TStatus && order == "desc")) {
				data[j] = sufObj;
				data[j + 1] = preObj;
			}
		}
	}
	actionListObj.loadData(data);
}


/**
 * [����Excel����]
 * @Author   wangguoying
 * @DateTime 2020-04-28
 */
function load_excel() {
	var fileList = $("#TemplateFile").filebox("files");
	if (fileList.length == 0) {
		$.messager.alert("��ʾ", "��ѡ��ģ�壡", "info");
		return false;
	}
	$('#Loading').css('display', "block");
	console.log("��ʼ��ȡ " + new Date());
	getExcelJsonArr(fileList[0], 0, function(excelArr) {
		console.log("��ȡ��ɣ���" + excelArr.length + "��¼ " + new Date());
		fillExcelData(excelArr);
	});
}

/**
 * [���Excel����]
 * @param    {JsonArray}    excelArr [Excel����]
 * @Author   wangguoying
 * @DateTime 2020-04-28
 */
function fillExcelData(excelArr) {
	if (excelArr == "" || excelArr == "undefind" || excelArr.length == 0) {
		$.messager.alert("��ʾ", "δ��ȡ��ģ�����ݣ����飡", "info");
		$('#Loading').fadeOut('fast');
		return false;
	}
	console.log("��ʼ�����棺" + new Date());
	setData(excelArr, 0, actionListObj.getData());
}
/**
 * [׷��DataGrid ���ݰ�]
 * @param    {[JSONArray]}    excelArr [Excel����]
 * @param    {[int]}    i        [description]
 * @param    {[Object]}    OldData  [DataGrid ���ݰ�]
 * @Author   wangguoying
 * @DateTime 2020-04-30
 */
function setData(excelArr, i, OldData) {
	var obj = excelArr[i];
	var jsonObj = new Object();
	jsonObj.TStatus = 0;
	var TeamName = "";
	if (obj.��������) TeamName = StringIsNull(obj.��������);
	jsonObj.TTeam = TeamName; //TName1
	var RegNo = "";
	if (obj.�ǼǺ�) RegNo = StringIsNull(obj.�ǼǺ�);
	jsonObj.TRegNo = RegNo; //RegNo2
	var Name = "";
	if (obj.����) Name = StringIsNull(obj.����);
	jsonObj.TName = Name; //Name3

	var IDCard = "";
	if (obj.���֤��) IDCard = StringIsNull(obj.���֤��);
	IDCard = ReplaceStr(IDCard, "'", "");
	IDCard = ReplaceStr(IDCard, String.fromCharCode(10), "");
	IDCard = ReplaceStr(IDCard, String.fromCharCode(13), "")

	jsonObj.TIDCard = IDCard; //IDCard4

	if (IDCard != "") {
		var curRegNo = tkMakeServerCall("web.DHCPE.ImportGInfo", "CheckRegNoByCardId", IDCard, "");
		if (jsonObj.TRegNo == "" && curRegNo.length > 1) {
			jsonObj.TRegNo = curRegNo.split("^")[curRegNo.split("^").length - 1];
		}
	}

	var Birth = GetBirthByIDCard(IDCard);
	var Sex = "";
	var Arr = Birth.split("^");
	Birth = Arr[0];
	if (Birth != "") {
		Sex = Arr[1];
	}
	var ExcelDesc = "";
	if (obj.�Ա�) ExcelDesc = StringIsNull(obj.�Ա�);

	if (Sex != "") ExcelDesc = Sex;
	jsonObj.TSex = ExcelDesc; //Sex5

	var Age = "";
	if (obj.����) Age = StringIsNull(obj.����);
	jsonObj.TAge = Age; //Age6
	var ExcelBirth = "";
	if (Birth != "") {
		ExcelBirth = Birth;
	} else {
		if (obj.����) ExcelBirth = StringIsNull(obj.����);
	}

	jsonObj.TDob = ExcelBirth; //Birth7

	var StrValue = "";
	if (obj.����״��) StrValue = StringIsNull(obj.����״��);
	if (StrValue == "") StrValue = "";
	jsonObj.TMarital = StrValue; //Married8
	StrValue = "";
	if (obj.�ƶ��绰) StrValue = StringIsNull(obj.�ƶ��绰);
	jsonObj.TTel = StrValue; //MoveTel9
	StrValue = "";
	if (obj.��ϵ�绰) StrValue = StringIsNull(obj.��ϵ�绰);
	jsonObj.TTel1 = StrValue; //Tel10
	StrValue = "";
	if (obj.����) StrValue = StringIsNull(obj.����);
	jsonObj.TDepartment = StrValue; //Address11
	StrValue = "";
	if (obj.��ʼ����) StrValue = StringIsNull(obj.��ʼ����);
	jsonObj.TBeginDate = StrValue; //StartDate12		
	StrValue = "";
	if (obj.��������) StrValue = StringIsNull(obj.��������);
	jsonObj.TEndDate = StrValue; //EndDate13
	StrValue = "";
	if (obj.��ͬ�շ�) StrValue = StringIsNull(obj.��ͬ�շ�);
	jsonObj.TAsCharged = StrValue; //AsCharged14
	StrValue = "";
	if (obj.���˱�����ȡ) StrValue = StringIsNull(obj.���˱�����ȡ);
	jsonObj.TRecReport = StrValue; //IReportSend15
	StrValue = "";
	if (obj.���㷽ʽ) StrValue = StringIsNull(obj.���㷽ʽ);
	jsonObj.TCashierType = StrValue; //ChargedMode16
	StrValue = "";
	if (obj.���Ѽ���) StrValue = StringIsNull(obj.���Ѽ���);
	jsonObj.TGAdd = StrValue; //AddItem17
	StrValue = "";
	if (obj.����������) StrValue = StringIsNull(obj.����������);
	jsonObj.TAddLimit = StrValue; //AddItemLimit18
	StrValue = "";
	if (obj.������) StrValue = StringIsNull(obj.������);
	jsonObj.TAddAmt = StrValue; //AddItemAmount19
	StrValue = "";
	if (obj.����ҩ) StrValue = StringIsNull(obj.����ҩ);
	jsonObj.TGMedical = StrValue; //AddMedical20
	StrValue = "";
	// if(obj.��ҩ�������) StrValue = StringIsNull(obj.��ҩ�������);
	// jsonObj.TMedicalLimit= StrValue; 			//AddMedicalLimit21
	// StrValue="";
	// if(obj.��ҩ���) StrValue = StringIsNull(obj.��ҩ���);
	// jsonObj.TMedicalAmt= StrValue; 			//AddMedicalAmount22
	// StrValue="";
	if (obj.������λ) StrValue = StringIsNull(obj.������λ);
	jsonObj.TCompany = StrValue; //������λ23
	StrValue = "";
	if (obj.����) StrValue = StringIsNull(obj.����);
	StrValue = tkMakeServerCall("web.DHCPE.PreCommon", "GetNationDR", StrValue)
	jsonObj.TNation = StrValue; //����24
	StrValue = "";
	if (obj.�·���) StrValue = StringIsNull(obj.�·���);
	jsonObj.TNewCard = StrValue; //�·���25
	StrValue = "";
	if (obj.��ϵ��ַ) StrValue = StringIsNull(obj.��ϵ��ַ);
	jsonObj.TAddress = StrValue; //����ϵ��ַ26
	StrValue = "";
	if (obj.��������) StrValue = StringIsNull(obj.��������);
	jsonObj.TPatType = StrValue; //��������27
	StrValue = "";
	if (obj.��������) StrValue = StringIsNull(obj.��������);
	jsonObj.THealthArea = StrValue; //��������28
	StrValue = "";
	if (obj.���￨��) StrValue = StringIsNull(obj.���￨��);
	jsonObj.TCardNo = StrValue; //���￨��29
	StrValue = "";
	if (obj.VIP�ȼ�) StrValue = StringIsNull(obj.VIP�ȼ�);
	jsonObj.TVIPLevel = StrValue; //VIP�ȼ�30
	StrValue = "";
	if (obj.����) StrValue = StringIsNull(obj.����);
	jsonObj.TEmployeeNo = StrValue; //����31
	StrValue = "";
	if (obj.������) StrValue = StringIsNull(obj.������);
	jsonObj.TFileNo = StrValue; //������32
	StrValue = "";
	if (obj.ְ��) StrValue = StringIsNull(obj.ְ��);
	jsonObj.TPost = StrValue; //ְ��33
	StrValue = "";

	if (obj.����) StrValue = StringIsNull(obj.����);
	jsonObj.TProduct = StrValue; //���� 34 
	StrValue = "";
	if (obj.�Ӻ�����) StrValue = StringIsNull(obj.�Ӻ�����);
	jsonObj.TServLength = StrValue; //�Ӻ�����35
	OldData.rows.push(jsonObj);

	if (i == (excelArr.length - 1)) {
		actionListObj.loadData(OldData);
		afterFill(excelArr.length);
	} else {
		if (i % interval_num == 0) {
			$("#LoadMsg").html("������ݣ�<font color='red'> " + (i + 1) + "</font>/" + excelArr.length);
			// onsole.log($("#LoadMsg").html());
		}
		setTimeout(function() {
			setData(excelArr, i + 1, OldData);
		}, 0);
	}
}


/**
 * [�����������¼�]
 * @param    {[int]}    length [��ȡ�ܼ�¼��]
 * @Author   wangguoying
 * @DateTime 2020-05-08
 */
function afterFill(length) {
	console.log("�����ɣ�" + new Date());
	$("#TemplateFile").filebox("clear");
	$("#DisplayMsg").html("���μ���<font color='red'> " + length + "</font> ��¼����ǰ��<font color='red'> " + actionListObj.getRows().length + "</font> ��¼");
	$('#Loading').fadeOut('fast');
	$("#LoadMsg").html("�����С���");
}



function operate_data(type) {
	var job = session['LOGON.USERID'];
	var jobObj = document.getElementById("Job");
	if (jobObj) job = jobObj.value;
	KillImportGlobal(job);
	var rows = actionListObj.getRows();
	if (rows.length == 0) {
		$.messager.alert("��ʾ", "δ�����κ�����", "info");
		return false;
	}
	if (editRows.length > 0) {
		$.messager.alert("��ʾ", "����δ��������ݣ��뱣������", "info");
		return false;
	}
	$('#Loading').css('display', "block");
	if (type == "Check") {
		valid_rowData(job, rows, 0, 0);
	}
	if (type == "Import") {
		var needNum = getNumByStatus(1);
		import_rowData(job, rows, 0, 0, 0, needNum);

		//���嵼����־
		if(needNum!="0"){
				tkMakeServerCall("web.DHCPE.GAdmRecordManager","Insert",$("#GID").val(),"P","Import","","");
		  }


	}
}
/**
 * [��������ָ֤������]
 * @param    {[int]}    job [���̺�]
 * @param    {[array]}    rowData [������ݰ�]
 * @param    {[int]}    index   [��������]
 * @param    {[int]}    failNum   [��֤ʧ�ܼ�¼��]
 * @Author   wangguoying
 * @DateTime 2020-05-08
 */
function valid_rowData(job, rowData, index, failNum) {
	var data = rowData[index];
	if (data.TStatus != 2) { //����ɹ��Ĳ�����֤
		var instring = valid_obj(job, data, index);
		if (instring == "") {
			failNum++;
			data.TStatus = -1;
		} else {
			data.TStatus = 1;
		}
	}

	if (index == (rowData.length - 1)) {
		KillImportGlobal(job);
		actionListObj.loadData(rowData);
		afterValid(failNum);
	} else {
		if (index % interval_num == 0) {
			$("#LoadMsg").html("��֤���ݣ�<font color='red'> " + (index + 1) + "</font>/" + rowData.length);
		}
		setTimeout(function() {
			valid_rowData(job, rowData, index + 1, failNum);
		}, 0);
	}

}

/**
 * [��֤������]
 * @param    {[int]}    job [���̺�]
 * @param    {[object]}    obj   [������]
 * @param    {[int]}    index [������]
 * @Author   wangguoying
 * @DateTime 2020-05-12
 */
function valid_obj(job, obj, index) {
	var IInString = "";
	var TeamName = "";
	if (obj.TTeam) TeamName = StringIsNull(obj.TTeam);
	IInString = TeamName; //TName1
	var RegNo = "";
	if (obj.TRegNo) RegNo = StringIsNull(obj.TRegNo);
	IInString = IInString + "^" + RegNo; //RegNo2
	var Name = "";
	if (obj.TName) Name = StringIsNull(obj.TName);
	IInString = IInString + "^" + Name; //Name3
	if (Name == "") {
		obj.TTipMsg = "����Ϊ��";
		return "";
	}
	var IDCard = "";
	if (obj.TIDCard) IDCard = StringIsNull(obj.TIDCard);
	IDCard = ReplaceStr(IDCard, "'", "");
	IDCard = ReplaceStr(IDCard, String.fromCharCode(10), "");
	IDCard = ReplaceStr(IDCard, String.fromCharCode(13), "")
	/*var IsvalidIDCard = isCardID(IDCard);
	if (IsvalidIDCard != true) {
		obj.TTipMsg = IsvalidIDCard;
		return "";
	}*/
	IInString = IInString + "^" + IDCard; //IDCard4
	var Birth = GetBirthByIDCard(IDCard);
	var Sex = "";
	var Arr = Birth.split("^");
	Birth = Arr[0];
	/*if (Birth != "") {
		if (!IsDate(Birth)) {
			obj.TTipMsg = "���֤¼������ղ���";
			return "";
		}
		Sex = Arr[1];
	}*/
	var ExcelDesc = "";
	if (obj.TSex) ExcelDesc = StringIsNull(obj.TSex);
	/*if ((Sex != "") && (ExcelDesc != "") && (ExcelDesc != Sex)) {
		obj.TTipMsg = "���֤�е��Ա��ģ��¼����Ա�һ��";
		return "";
	}*/
	if (Sex != "") ExcelDesc = Sex;
	IInString = IInString + "^" + ExcelDesc; //Sex5

	var Age = "";
	if (obj.TAge) Age = StringIsNull(obj.TAge);
   
   if(Birth!="") {
		var CardAge=tkMakeServerCall("web.DHCDocCommon","GetAgeDescNew",Birth,"");
		var CardAge=CardAge.split("��")[0];
	}else{
		var CardAge=""
	}
	
	/*if ((CardAge != "") && (Age != "") && (CardAge != Age)) {
		obj.TTipMsg = "���֤�е������ģ��¼������䲻һ��";
		return "";
	}*/


	IInString = IInString + "^" + Age; //Age6
	var ExcelBirth = "";
	if (Birth != "") {
		ExcelBirth = Birth;
	} else {
		if (obj.TDob) ExcelBirth = StringIsNull(obj.TDob);
	}
	/*if (ExcelBirth != "") {
		if (!IsDate(ExcelBirth)) {
			obj.TTipMsg = "���ղ���ȷ";
			return "";
		}
	}*/
	IInString = IInString + "^" + ExcelBirth; //Birth7
	var StrValue = "";
	if (obj.TMarital) StrValue = StringIsNull(obj.TMarital);
	if (StrValue == "") StrValue = "";
	IInString = IInString + "^" + StrValue; //Married8
	/*StrValue = "";
	if (obj.TTel) StrValue = StringIsNull(obj.TTel);
	IInString = IInString + "^" + StrValue; //MoveTel9
	StrValue = "";
	if (obj.TTel1) StrValue = StringIsNull(obj.TTel1);
	IInString = IInString + "^" + StrValue; //Tel10
	*/
	var Tel = "";
	if (obj.TTel) Tel = StringIsNull(obj.TTel);
	var IsvalidTel="";
	if(Tel!=""){
	var IsvalidTel = CheckTelOrMobile(Tel);
		if (IsvalidTel != true) {
			obj.TTipMsg = IsvalidTel;
			return "";
		}
	}
	IInString = IInString + "^" + Tel; //MoveTel9

	var Tel1=""
	if (obj.TTel1) Tel1 = StringIsNull(obj.TTel1);
	var IsvalidTel1="";
	if(Tel1!=""){
	var IsvalidTel1 = CheckTelOrMobile(Tel1);
		if (IsvalidTel1 != true) {
			obj.TTipMsg = IsvalidTel1;
			return "";
		}
	}
	IInString = IInString + "^" + Tel1; //Tel10

	StrValue = "";
	if (obj.TDepartment) StrValue = StringIsNull(obj.TDepartment);
	IInString = IInString + "^" + StrValue; //Address11
	StrValue = "";
	if (obj.TBeginDate) StrValue = StringIsNull(obj.TBeginDate);
	IInString = IInString + "^" + StrValue; //StartDate12		
	StrValue = "";
	if (obj.TEndDate) StrValue = StringIsNull(obj.TEndDate);
	IInString = IInString + "^" + StrValue; //EndDate13
	StrValue = "";
	if (obj.TAsCharged) StrValue = StringIsNull(obj.TAsCharged);
	IInString = IInString + "^" + StrValue; //AsCharged14
	StrValue = "";
	if (obj.TRecReport) StrValue = StringIsNull(obj.TRecReport);
	IInString = IInString + "^" + StrValue; //IReportSend15
	StrValue = "";
	if (obj.TCashierType) StrValue = StringIsNull(obj.TCashierType);
	IInString = IInString + "^" + StrValue; //ChargedMode16
	StrValue = "";
	if (obj.TGAdd) StrValue = StringIsNull(obj.TGAdd);
	IInString = IInString + "^" + StrValue; //AddItem17
	StrValue = "";
	if (obj.TAddLimit) StrValue = StringIsNull(obj.TAddLimit);
	IInString = IInString + "^" + StrValue; //AddItemLimit18
	StrValue = "";
	if (obj.TAddAmt) StrValue = StringIsNull(obj.TAddAmt);
	IInString = IInString + "^" + StrValue; //AddItemAmount19
	StrValue = "";
	if (obj.TGMedical) StrValue = StringIsNull(obj.TGMedical);
	IInString = IInString + "^" + StrValue; //AddMedical20
	StrValue = "";
	if (obj.TMedicalLimit) StrValue = StringIsNull(obj.TMedicalLimit);
	IInString = IInString + "^" + StrValue; //AddMedicalLimit21
	StrValue = "";
	if (obj.TMedicalAmt) StrValue = StringIsNull(obj.TMedicalAmt);
	IInString = IInString + "^" + StrValue; //AddMedicalAmount22
	StrValue = "";
	if (obj.TCompany) StrValue = StringIsNull(obj.TCompany);
	IInString = IInString + "^" + StrValue; //������λ23
	StrValue = "";
	if (obj.TNation) StrValue = StringIsNull(obj.TNation);
	StrValue = tkMakeServerCall("web.DHCPE.PreCommon", "GetNationDR", StrValue)
	IInString = IInString + "^" + StrValue; //����24
	StrValue = "";
	if (obj.TNewCard) StrValue = StringIsNull(obj.TNewCard);
	IInString = IInString + "^" + StrValue; //�·���25
	StrValue = "";
	if (obj.TAddress) StrValue = StringIsNull(obj.TAddress);
	IInString = IInString + "^" + StrValue; //����ϵ��ַ26
	StrValue = "";
	if (obj.TPatType) StrValue = StringIsNull(obj.TPatType);
	IInString = IInString + "^" + StrValue; //��������27
	StrValue = "";
	if (obj.THealthArea) StrValue = StringIsNull(obj.THealthArea);
	IInString = IInString + "^" + StrValue; //��������28
	StrValue = "";
	if (obj.TCardNo) StrValue = StringIsNull(obj.TCardNo);
	IInString = IInString + "^" + StrValue; //���￨��29
	StrValue = "";
	if (obj.TVIPLevel) StrValue = StringIsNull(obj.TVIPLevel);
	IInString = IInString + "^" + StrValue; //VIP�ȼ�30
	StrValue = "";
	if (obj.TEmployeeNo) StrValue = StringIsNull(obj.TEmployeeNo);
	IInString = IInString + "^" + StrValue; //����31
	StrValue = "";
	if (obj.TFileNo) StrValue = StringIsNull(obj.TFileNo);
	IInString = IInString + "^" + StrValue; //������32
	StrValue = "";
	if (obj.TPost) StrValue = StringIsNull(obj.TPost);
	IInString = IInString + "^" + StrValue; //ְ��33
	StrValue = "";

	if (obj.TProduct) StrValue = StringIsNull(obj.TProduct);
	IInString = IInString + "^" + StrValue; //���� 34 
	StrValue = "";
	if (obj.TServLength) StrValue = StringIsNull(obj.�Ӻ�����);
	IInString = IInString + "^" + StrValue; //�Ӻ�����35

	IInString = IInString + "^" + (index + 1); //�кŷŵ����

	var ReturnValue = tkMakeServerCall("web.DHCPE.ImportGInfo", "GetGPersonInfo", $("#GID").val(), IInString, "Check", job, $("#GDesc").val(), $("#AllowCF").val());
	if (ReturnValue != 0) {
		var RetArr = ReturnValue.split("&");
		if (RetArr.length > 1) {
			obj.TTipMsg = RetArr[0] + ":" + RetArr[1];
		} else {
			obj.TTipMsg = RetArr[0];
		}
		return "";
	}

	return IInString;
}

/**
 * [��֤����¼�]
 * @param    {[int]}    failNum   [��֤ʧ�ܼ�¼��]
 * @Author   wangguoying
 * @DateTime 2020-05-08
 */
function afterValid(failNum) {
	sortTStatus("asc"); //��֤��ɺ����򣬽��������Ϣ��ʾ������
	$("#DisplayMsg").html("����֤ " + actionListObj.getRows().length + " ��¼��ʧ��<font color='red'> " + failNum + "</font> ��¼");
	$('#Loading').fadeOut('fast');
	$("#LoadMsg").html("�����С���");
}


/**
 * [��ȡָ��״̬�ļ�¼����]
 * @param    {[int]}    Status [0:δ��֤  1:��֤�ɹ�  2:����ɹ�  -1:��֤ʧ��  -2:����ʧ��]
 * @return   {[int]}           [��¼����]
 * @Author   wangguoying
 * @DateTime 2020-05-12
 */
function getNumByStatus(Status) {
	var data = actionListObj.getData();
	var tatal = data.total;
	if (Status == "") return total;
	var num = 0;
	for (var row in data.rows) {
		if (data.rows[row].TStatus == Status) num++;
	}
	return num;
}

/**
 * [����������]
 * @param    {[int]}    job        [���̺�]
 * @param    {[object]}    rowData    [������ݰ�]
 * @param    {[index]}    index      [������]
 * @param    {[int]}    failNum    [ʧ�ܼ�¼��]
 * @param    {[int]}    successNum [�ɹ���¼��]
 * @param    {[int]}    needNum    [Ӧ��������]
 * @Author   wangguoying
 * @DateTime 2020-05-12
 */
function import_rowData(job, rowData, index, failNum, successNum, needNum) {
	var CTLocID=session['LOGON.CTLOCID']
	var data = rowData[index];
	if (data.TStatus == 1) { //��֤�ɹ��Ĳ���ִ�е���
		var instring = valid_obj(job, data, index);
		if (instring == "") {
			failNum++;
			data.TStatus = -1;
		} else {
			var importRet = tkMakeServerCall("web.DHCPE.ImportGInfo", "Main", $("#GID").val(), job,CTLocID);
			var ReturnStr = importRet.split("^");
			var Flag = ReturnStr[0];
			if (Flag != 0) {
				if (Flag == "-119") Flag = "���������ظ�";
				failNum++;
				data.TStatus = -2;
				data.TTipMsg = Flag;
			} else {
				if (ReturnStr[3] == 1) {
					successNum++;
					data.TStatus = 2;
				} else {
					failNum++;
					data.TStatus = -2;
					data.TTipMsg = tkMakeServerCall("web.DHCPE.ImportGInfo", "GetImportErr", $("#GID").val(), job, index + 1);
				}
			}
		}
	}
	if (needNum == (failNum + successNum)) {
		actionListObj.loadData(rowData);
		afterImport(failNum, needNum);
	} else {
		if ((failNum + successNum - 1) % interval_num == 0) {
			$("#LoadMsg").html("�������ݣ�<font color='red'> " + (failNum + successNum) + "</font>/" + needNum);
		}
		setTimeout(function() {
			import_rowData(job, rowData, index + 1, failNum, successNum, needNum);
		}, 0);
	}

}

/**
 * [��������¼�]
 * @param    {[int]}    failNum   [����ʧ�ܼ�¼��]
 * @param    {[int]}    successNum   [����ɹ���¼��]
 * @Author   wangguoying
 * @DateTime 2020-05-08
 */
function afterImport(failNum, successNum) {
	sortTStatus("asc"); //������ɺ����򣬽��������Ϣ��ʾ������
	$("#DisplayMsg").html("������ " + successNum + " ��¼��ʧ��<font color='red'> " + failNum + "</font> ��¼");
	$('#Loading').fadeOut('fast');
	$("#LoadMsg").html("�����С���");
}


function refresh_datagrid() {
	actionListObj.reload();
}

function delete_row(index, status) {
	if (index != "" && index > -1) {
		var tr = actionListObj.getRowDom(index);
		tr.tooltip("destroy").children("td[field]").each(function() {
			$(this).tooltip("destroy");
		});
		actionListObj.deleteRow(index);
		actionListObj.loadData(actionListObj.getRows());
		$("#DisplayMsg").html("ɾ�� 1 ��¼����ǰ�� " + actionListObj.getRows().length + " ��¼");
		$.messager.alert("��ʾ", "��ɾ��", "success");
		return;
	} else {
		var statusDesc = "";
		switch (status) {
			case 0:
				statusDesc = "δ��֤";
				break;
			case 1:
				statusDesc = "��֤�ɹ�";
				break;
			case 2:
				statusDesc = "����ɹ�";
				break;
			case -1:
				statusDesc = "��֤ʧ��";
				break;
			case -2:
				statusDesc = "����ʧ��";
				break;
		}
		if (statusDesc == "") { //ȫ������
			$.messager.confirm("��ʾ", "���ȫ����¼��", function(r) {
				if (r) {
					editRows = new Array();
					actionListObj.loadData({
						"total": 0,
						"rows": []
					});
					$("#DisplayMsg").html("������");
				}
			});

		} else {
			$.messager.confirm("��ʾ", "ɾ��״̬Ϊ��" + statusDesc + "����ȫ����¼��", function(r) {
				if (r) {
					var data = actionListObj.getRows();
					var oldLen = data.length;
					var newData = [];
					for (var i = 0; i < oldLen; i++) {
						if (data[i].TStatus != status) {
							newData.push(data[i]);
						}
					}
					var newLen = newData.length;
					actionListObj.loadData(newData);
					$("#DisplayMsg").html("ɾ�� " + (oldLen - newLen) + " ��¼����ǰ�� " + newLen + " ��¼");
				}
			});
		}

	}
}

function add_row() {
	actionListObj.appendRow({
		TStatus: 0
	});
	$("#DisplayMsg").html("���� 1 ��¼����ǰ�� " + actionListObj.getRows().length + " ��¼");
}


function KillImportGlobal(job) {
	var ReturnValue = tkMakeServerCall("web.DHCPE.ImportGInfo", "KillImportGlobal", job);

	return ReturnValue;
}



//ȥ���ַ������˵Ŀո�
function Trim(String) {
	if ("" == String) {
		return "";
	}
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

//ȥ���ַ����Ŀո�
function jsTrim(str) {
	var reg = /\s/;
	if (!reg.test(str)) {
		return str;
	}
	return str.replace(/\s+/g, "");
}

function StringIsNull(String) {
	if (String == null) return ""
	//return String
	return jsTrim(String)
}

//ȥ���ַ������˵Ŀո�
function ReplaceStr(s, Split, LinkStr) {
	if (s != "" && s != null && typeof(s) != "undefined") {
		s = s + "";
		var SArr = s.split(Split)
		s = SArr.join(LinkStr)
		return s
		var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
		return (m == null) ? "" : m[1];
	} else {
		return "";
	}

}

function GetBirthByIDCard(num) {
	if (num == "") return "";
	//alert(toString(num))
	var ShortNum = num.substr(0, num.length - 1)
	if (isNaN(ShortNum)) {
		//alert("����Ĳ�������?");
		return "";
	}
	var len = num.length;
	var re;
	if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{3})$/);
	else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
	else { //alert("���֤�����������λ������?");
		//websys_setfocus("IDCard");
		return "";
	}
	var a = (ShortNum + "1").match(re);
	if (a != null) {
		if (len == 15) {
			var D = new Date("19" + a[3] + "/" + a[4] + "/" + a[5]);
			var B = D.getYear() == a[3] && (D.getMonth() + 1) == a[4] && D.getDate() == a[5];
			var SexFlag = num.substr(14, 1);
		} else {
			var D = new Date(a[3] + "/" + a[4] + "/" + a[5]);
			var B = D.getFullYear() == a[3] && (D.getMonth() + 1) == a[4] && D.getDate() == a[5];
			var SexFlag = num.substr(16, 1);
		}


		if (!B) {
			//alert("��������֤�� "+ a[0] +" ��������ڲ���?");

			//websys_setfocus("IDCard"); //DGV2DGV2
			if (a[3].length == 2) a[3] = "19" + a[3];
			Str = a[3] + "-" + a[4] + "-" + a[5];
			return Str;
		}
		if (a[3].length == 2) a[3] = "19" + a[3];
		var Str = a[3] + "-" + a[4] + "-" + a[5];


		var SexNV = ""
		if (SexFlag % 2 == 1) {
			SexNV = "��";
		} else {
			SexNV = "Ů";
		}


		return Str + "^" + SexNV;

	}
	return "";
}

function IsDate(str) {
	var re = /^\d{4}-\d{1,2}-\d{1,2}$/;
	if (re.test(str)) {
		// ��ʼ���ڵ��߼��ж�??�Ƿ�Ϊ�Ϸ������� 
		var array = str.split('-');
		var date = new Date(array[0], parseInt(array[1], 10) - 1, array[2]);
		if (!((date.getFullYear() == parseInt(array[0], 10)) &&
				((date.getMonth() + 1) == parseInt(array[1], 10)) &&
				(date.getDate() == parseInt(array[2], 10)))) {
			// ������Ч������ 
			return false;
		}
		return true;
	}

	// ���ڸ�ʽ���� 
	return false;
}

function isCardID(sId) {
	var iSum = 0;
	var info = "";
	if (sId == "") return true;
	if (!/^\d{17}(\d|x)$/i.test(sId)) return "����������֤���Ȼ��ʽ����";
	sId = sId.replace(/x$/i, "a");
	if (aCity[parseInt(sId.substr(0, 2))] == null) return "������֤�����Ƿ�";
	sBirthday = sId.substr(6, 4) + "-" + Number(sId.substr(10, 2)) + "-" + Number(sId.substr(12, 2));
	var d = new Date(sBirthday.replace(/-/g, "/"));
	if (sBirthday != (d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate())) return "���֤�ϵĳ������ڷǷ�";
	for (var i = 17; i >= 0; i--) iSum += (Math.pow(2, i) % 11) * parseInt(sId.charAt(17 - i), 11);
	if (iSum % 11 != 1) return "����������֤�ŷǷ�";
	//aCity[parseInt(sId.substr(0,2))]+","+sBirthday+","+(sId.substr(16,1)%2?"��":"Ů");//�˴λ������жϳ���������֤�ŵ����Ա�
	return true;
}

//��֤�绰���ƶ��绰
function CheckTelOrMobile(telephone){
    if (isMoveTel(telephone)) return true;
    if (telephone.indexOf('-')>=0){
         return "�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!"; 
      
    }else{
        if(telephone.length!=11){
             return  "�绰����ӦΪ��11��λ,���ʵ!"
        }else{
            return "�����ڸúŶε��ֻ���,���ʵ!"
        }
    }
    return true;
}
/* 
��;����������Ƿ���ȷ�ĵ绰���ֻ��� 
���룺 �绰��
value���ַ��� 
���أ� ���ͨ����֤����true,���򷵻�false 
*/  
function isMoveTel(telephone){
    
    var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
    var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/; 
    var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
    if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){ 
        return false; 
    }else{ 
        return true; 
    } 

}

function InitCombobox()
{
	//����
	var GroupNameObj = $HUI.combogrid("#GroupName",{
		panelWidth:450,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//���   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
			param.Status="ARRIVED";
		},
		columns:[[
			{field:'TRowId',title:'����ID',width:80},
			{field:'TGDesc',title:'��������',width:140},
			{field:'TGStatus',title:'״̬',width:100},
			{field:'TAdmDate',title:'����',width:100}		
		]]
	});
}
function InitactionList()
{
	
	actionListObj =$HUI.datagrid("#actionList",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 50,
		pageList : [50,100,150],
		singleSelect: true,
		checkOnSelect: false, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: false,
		
		queryParams:{
			ClassName:"web.DHCPE.PreGADM",
			QueryName:"SearchOldGADMInfo",
			GroupDR:$("#GroupName").combogrid("getValue"),
			NewGID:$("#GID").val(),
			NewGDesc:$("#GDesc").val(),
			AllowCF:$("#AllowCF").val()

        },
        frozenColumns: [
        [{
            field: 'TOperate',
            title: '����',
            width: 60,
            formatter: function(value, row, index) {
                return "<span style='cursor:pointer;margin-left:8px;padding-top:4px;' class='icon-cancel' title='ɾ����¼' alt='ɾ����¼' onclick='delete_row(\""+index+"\",\"\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
            }
        }, {
            field: 'TStatus',
            title: '״̬',
            width: 70,
            sortable: 'true',
            align: "center",
            formatter: function(value, row, index) {
                var content = "";
                switch (row.TStatus) {
                    case "0":
                        content = "δ��֤";
                        break;
                    case "1":
                        content = "��֤ͨ��";
                        break;
                    case 2:
                        content = "����ɹ�";
                        break;
                    case "-1":
                        content = "��֤ʧ��";
                        break;
                    case -2:
                        content = "����ʧ��";
                        break;
                }
                return "<div style='color:#ffffff;'>" + content + "</div>";
            },
            styler: function(value, row, index) {
                var color = "#ffffff";
                switch (row.TStatus) {
                    case "0":
                        color = "#40A2DE";
                        break;
                    case "1":
                        color = "#40A2DE";
                        break;
                    case 2:
                        color= "rgb(101, 222, 101)";
                        break;
                    case "-1":
                        color = "red";
                        break;
                    case -2:
                        color = "red";
                        break;
                }
                return "background-color:" + color + ";";
            },
        }, {
            field: 'TTeam',
            width: 80,
            title: '��������',
            editor: 'text'
        }, {
            field: 'TRegNo',
            width: 100,
            title: '�ǼǺ�',
            editor: 'text'
        }, {
            field: 'TName',
            width: 100,
            title: '����',
            editor: 'text'
        }, {
            field: 'TIDCard',
            width: 180,
            title: '֤����',
            editor: 'text'
        }, {
            field: 'TTipMsg',
            title: '����ʾ��Ϣ',
            hidden: 'true'
        }]
    ],
    columns: [
        [{
            field: 'TSex',
            width: 40,
            align: "center",
            title: '�Ա�',
            editor: 'text'
        }, {
            field: 'TAge',
            width: 40,
            title: '����',
            editor: {
                type: 'numberbox',
                options: {
                    min: 1
                }
            }
        }, {
            field: 'TDob',
            width: 100,
            title: '��������',
            editor: 'text'
        }, {
            field: 'TMarital',
            width: 80,
            title: '����״��',
            editor: 'text'
        }, {
            field: 'TTel1',
            width: 100,
            title: '�ƶ��绰',
            editor: 'text'
        }, {
            field: 'TMobile',
            width: 100,
            title: '��ϵ�绰',
            editor: 'text'
        }, {
            field: 'TDepartment',
            width: 80,
            title: '����',
            editor: 'text'
        }, {
            field: 'TBeginDate',
            width: 80,
            title: '��ʼ����',
            editor: 'text'
        }, {
            field: 'TEndDate',
            width: 80,
            title: '��������',
            editor: 'text'
        }, {
            field: 'TAsCharged',
            width: 60,
            title: '��ͬ�շ�',
            editor: 'text'
        }, {
            field: 'TRecReport',
            width: 60,
            title: '���˱�����ȡ',
            editor: 'text'
        }, {
            field: 'TCashierType',
            width: 60,
            title: '���㷽ʽ',
            editor: 'text'
        }, {
            field: 'TGAdd',
            width: 60,
            title: '���Ѽ���',
            editor: 'text'
        }, {
            field: 'TAddLimit',
            width: 60,
            title: '����������',
            editor: 'text'
        }, {
            field: 'TAddAmt',
            width: 60,
            title: '������',
            editor: 'text'
        }, {
            field: 'TGMedical',
            width: 60,
            title: '����ҩ',
            editor: 'text'
        }, {
            field: 'TMedicalLimit',
            hidden: true,
            title: '��ҩ�������',
            editor: 'text'
        }, {
            field: 'TMedicalAmt',
            hidden: true,
            title: '��ҩ���',
            editor: 'text'
        }, {
            field: 'TCompany',
            width: 80,
            title: '������λ',
            editor: 'text'
        }, {
            field: 'TNation',
            width: 60,
            title: '����',
            editor: 'text'
        }, {
            field: 'TNewCard',
            width: 60,
            title: '�·���',
            editor: 'text'
        }, {
            field: 'TAddress',
            width: 120,
            title: '��ϵ��ַ',
            editor: 'text'
        }, {
            field: 'TPatType',
            width: 60,
            title: '��������',
            editor: 'text'
        }, {
            field: 'THealthArea',
            width: 100,
            title: '��������',
            editor: 'text'
        }, {
            field: 'TCardNo',
            width: 100,
            title: '���￨��',
            editor: 'text'
        }, {
            field: 'TVIPLevel',
            width: 60,
            title: 'VIP�ȼ�',
            editor: 'text'
        }, {
            field: 'TEmployeeNo',
            width: 80,
            title: '����',
            editor: 'text'
        }, {
            field: 'TFileNo',
            width: 80,
            title: '������',
            editor: 'text'
        }, {
            field: 'TPost',
            width: 80,
            title: 'ְ��',
            editor: 'text'
        }, {
            field: 'TProduct',
            width: 80,
            title: '����',
            editor: 'text'
        }, {
            field: 'TServLength',
            width: 80,
            title: '�Ӻ�����',
            editor: 'text'
        }]
    ],
    data: {
        "total": 0,
        "rows": []
    },
    fit: true,
    rownumbers: true,
    fitColumns: false,
    onSortColumn: function(sort, order) {
        sortTStatus(order);
    },
    rowTooltip: function(index, row) { //datagrid��չ����  ��������ʾ��Ϣ
        return row.TTipMsg;
    },
    rowStyler: function(index, row) {
        var rowStyle = "";
        switch (row.TStatus) {
            case 0: //δ��֤
                break;
            case 1: //��֤ͨ��
                break;
            case 2: //����ɹ�
                rowStyle = 'background-color:#65de65;';
                break;
            case -1: //��֤δͨ��
                rowStyle = 'background-color:rgb(251, 136, 226);';
                break;
            case -2: //����δͨ��
                break;
        }
        return rowStyle;
    },
    toolbar: [{
        iconCls: 'icon-add',
        text: '������',
        handler: function() {
            add_row();
        }
    }, {
        iconCls: 'icon-close',
        text: 'ɾ������֤ʧ�ܡ���¼',
        handler: function() {
            delete_row("", -1);
        }
    }, {
        iconCls: 'icon-close',
        text: 'ɾ��������ɹ�����¼',
        handler: function() {
            delete_row("", 2);
        }
    }, {
        iconCls: 'icon-reset',
        text: '�������',
        handler: function() {
            delete_row("", 9);
        }
    }, {
        iconCls: 'icon-reload',
        text: 'ˢ������',
        handler: function() {
            refresh_datagrid();
        }
    }, {
        iconCls: 'icon-export',
        text: '������������',
        handler: function() {
            export_errData();
        }
    }, {
        iconCls: 'icon-key-switch',
        text: '����֤�ɹ�',
        handler: function() {
            update_status(1);
        }
    }]
            
    })
}

function load_goldInfo()
{
	$("#actionList").datagrid('load',{
			ClassName:"web.DHCPE.PreGADM",
			QueryName:"SearchOldGADMInfo",
			GroupDR:$("#GroupName").combogrid("getValue"),
			NewGID:$("#GID").val(),
			NewGDesc:$("#GDesc").val(),
			AllowCF:$("#AllowCF").val()
	})
}