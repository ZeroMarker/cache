/**
* FillName: insutarcontrastqry.js
* Description: ҽ��Ŀ¼���ղ�ѯ
* Creator JinShuai1010
* 2022-11-10/��˧/UI�޸�
* Date: 2022-09-26
*/
// ���峣��
var PUBLIC_CONSTANT = {
	SESSION: {
		HOSPID: session['LOGON.HOSPID'],  //Ժ��
	}
}
var PUB_CNT = {
	HITYPE: '',                               //ҽ������
	ChargesID: '',
	SSN: {
		USERID: session['LOGON.USERID'],	//����ԱID
	},
	SYSDTFRMT: function () {
		var _sysDateFormat = $.m({
			ClassName: "websys.Conversions",
			MethodName: "DateFormat"
		}, false);
		return _sysDateFormat;
	}
};
//��ں���

$(function () {
	GetjsonQueryUrl()
	setPageLayout();    //����ҳ�沼��
	init_Keyup();
	$("#btnDivQuery").click(InsuSearch);
	$("#clear").click(clear);
	//	$("#btnDivQuery").click(ChangesS);
});
//����ҳ�沼��
function setPageLayout() {
	//ҽ������
	initHiTypeCmb();
	initHisDivDetDgDg();
	initCenterDivDetDg();
}
//����
function clear() {
	setValueById('InsuPinYin', "");
	setValueById('InsuCode', "");
	setValueById('InsuName', "");
	setValueById('ChargesPinYin', "");
	setValueById('ChargesCode', "");
	setValueById('ChargesName', "");
	$('#hiType').combobox('reload');
	$("#HisDivDetDg").datagrid("loadData", { total: 0, rows: [] }); //20191028
	$("#CenterDivDetDg").datagrid("loadData", { total: 0, rows: [] }); //20191028
}
//�س�
function init_Keyup() {
	//ҽ��Ŀ¼����
	$('#InsuPinYin').keyup(function () {
		if (event.keyCode == 13) {
			InsuSearch();
		}
	});
	$('#InsuCode').keyup(function () {
		if (event.keyCode == 13) {
			InsuSearch();
		}
	});
	$('#InsuName').keyup(function () {
		if (event.keyCode == 13) {
			InsuSearch();
		}
	});
	$('#ChargesPinYin').keyup(function () {
		if (event.keyCode == 13) {
			InsuSearch();
		}
	});
	$('#ChargesCode').keyup(function () {
		if (event.keyCode == 13) {
			InsuSearch();
		}
	});
	$('#ChargesName').keyup(function () {
		if (event.keyCode == 13) {
			InsuSearch();
		}
	});
}
//��ʼ��ҽ������
function initHiTypeCmb() {
	$HUI.combobox('#hiType', {
		url: $URL,
		editable: false,
		valueField: 'cCode',
		textField: 'cDesc',
		panelHeight: 100,
		method: 'GET',
		onBeforeLoad: function (param) {
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName = 'QueryDic';
			param.ResultSetType = 'array';
			param.Type = 'DLLType';
			param.Code = '';
			param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		loadFilter: function (data) {
			for (var i in data) {
				if (data[i].cDesc == 'ȫ��') {
					data.splice(i, 1)
				}
			}
			return data
		},
		onLoadSuccess: function () {
			$('#hiType').combobox('select', '00A');
		},
		onSelect: function (rec) {
			PUB_CNT.HITYPE = rec.cCode;
		}

	});
}
//��ʼ���շ�����Ϣdg
var Hiscolumn = [[
	{ field: 'HISRowId', title: '�շ���id', width: 90, hidden: true },
	{ field: 'INTCTHisDesc', title: '�շ�������', width: 160 },
	{ field: 'INTCTHisCode', title: '�շ������', width: 90 },
	{ field: 'TARIPrice', title: '�շ���۸�', width: 80 },
	{ field: 'INSURowId', title: 'ҽ��Ŀ¼id', width: 90, hidden: true },
	{ field: 'INTCTInsuCode', title: 'ҽ��Ŀ¼����', width: 160 },
	{ field: 'INTCTInsuDesc', title: 'ҽ��Ŀ¼����', width: 160 },
	{ field: 'INTCTActiveDate', title: '��Ч����', width: 90 },
	{ field: 'INTCTExpiryDate', title: 'ʧЧ����', width: 90 }

]];
function initHisDivDetDgDg() {
	$HUI.datagrid('#HisDivDetDg', {
		autoSizeColumn: false,
		title: '�շ�����Ϣ',
		toolbar: [],
		headerCls: 'panel-header-gray',
		rownumbers: true,
		//border: false,
		fit: true,
		striped: true,
		//url:$URL,
		singleSelect: true,
		pageSize: 20,
		pageList: [10, 20, 30],
		pagination: true,
		columns: Hiscolumn

	});
}
//��ʼ��ҽ������Ϣdg
var initColumn = [[
	{ field: 'ARCIMDesc', title: 'ҽ��������', width: 150 },
	{ field: 'ARCIMCode', title: 'ҽ�������', width: 120 },
	{ field: 'ARCIMRowId', title: 'ҽ����Id', width: 120 },
	{ field: 'ARCIMEffDate', title: '��Ч����', width: 120 },
	{ field: 'ARCIMEffDateTo', title: 'ʧЧ����', width: 100 }

]];
function initCenterDivDetDg() {
	$HUI.datagrid('#CenterDivDetDg', {
		rownumbers: true,
		fit: true,
		striped: true,
		title: 'ҽ������Ϣ',
		toolbar: [],
		headerCls: 'panel-header-gray',
		singleSelect: true,
		pageSize: 20,
		pageList: [10, 20, 30],
		pagination: true,
		autoSizeColumn: false,
		columns: initColumn

	});
}
//��ѯ�շ�����Ϣ
function InsuSearch() {
	var InsuAlias = $('#InsuPinYin').val();
	var InsuCode = $('#InsuCode').val();
	var InsuDesc = $('#InsuName').val();
	var HisAlias = $('#ChargesPinYin').val();
	var HisCode = $('#ChargesCode').val();
	var HisDesc = $('#ChargesName').val();
	if (InsuAlias == "" && InsuCode == "" && InsuDesc == "" && HisAlias == "" && HisCode == "" && HisDesc == "") {
		$.messager.alert("��ʾ", "����������һ����ѯ����!", "info");
		return false;
	}
	$HUI.datagrid('#HisDivDetDg', {
		columns: Hiscolumn,
		url: $URL,
		iconCls: 'icon-save',
		border: true,                          //upt 2023/2/15 JinS1010 ��ʾ�߿�
		fit: true,
		striped: true,
		autoSizeColumn: false,
		rownumbers: true,
		pagination: true,
		singleSelect: true,
		pageSize: 20,
		pageList: [20, 40, 60],
		queryParams: {
			ClassName: 'web.INSUTarContrastQry',
			QueryName: 'GetTarConInfo',
			'Type': PUB_CNT.HITYPE,
			'InsuAlias': InsuAlias,
			'InsuCode': InsuCode,
			'InsuDesc': InsuDesc,
			'HisAlias': HisAlias,
			'HisCode': HisCode,
			'HisDesc': HisDesc,
			'HospId': PUBLIC_CONSTANT.SESSION.HOSPID
		},
		onSelect: function (rowIndex, rowData) {
			PUB_CNT.ID = rowData.HISRowId;
			InsuSelect();
		},
	});
}
//��ѯ��Ӧ��ҽ������Ϣ
function InsuSelect() {
	$HUI.datagrid('#CenterDivDetDg', {
		url: $URL,
		iconCls: 'icon-save',
		border: true,                        //upt 2023/2/15 JinS1010 ��ʾ�߿�
		fit: true,
		striped: true,
		autoSizeColumn: false,
		rownumbers: true,
		pagination: true,
		singleSelect: true,
		pageSize: 20,
		pageList: [20, 40, 60],
		queryParams: {
			ClassName: 'web.INSUTarContrastQry',
			QueryName: 'GetArcItmInfo',
			'TarRowid': PUB_CNT.ID,
			'HospId': PUBLIC_CONSTANT.SESSION.HOSPID
		}
	})
}
//����Ժ��
function selectHospCombHandle() {
	$('#hiType').combobox('reload');
}

