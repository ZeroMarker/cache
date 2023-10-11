/*
 * FileName: dhcpe/ct/viplevel.js
 * Author: xy
 * Date: 2021-08-08
 * Description: VIP�ȼ�ά��
 */

var tableName = "DHC_PE_LocVIPLevel";

var SessionStr = session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.HOSPID']

$(function () {

	//��ȡ���������б�
	GetLocComp(SessionStr)

	InitCombobox();

	//��ʼ�� VIP�ȼ�Grid
	InitVIPGrid();

	//��ʼ�� VIP�ȼ�����Grid
	InitLocVIPGrid();

	//���������б�change
	$("#LocList").combobox({
		onSelect: function () {
			var LocID = session['LOGON.CTLOCID']
			var LocListID = $("#LocList").combobox('getValue');
			if (LocListID != "") { var LocID = LocListID; }

			$("#LocVIPGrid").datagrid('load', {
				ClassName: "web.DHCPE.CT.VIPLevel",
				QueryName: "FindLocVIPInfo",
				VIPLevelID: $("#ID").val(),
				NoActiveFlag: $("#NoActive").checkbox('getValue') ? "Y" : "N",
				LocID: LocID
			})


			/*****************���񼶱����¼���(combobox)*****************/
			var HMServiceurl = $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindHMService&ResultSetType=array&LocID=" + LocID;
			$('#HMService').combobox('reload', HMServiceurl);
			/*****************���񼶱����¼���(combobox)*****************/
		}

	});



	//��ѯ
	$('#BFind').click(function () {
		BFind_click();
	});

	//����
	$('#BClear').click(function () {
		BClear_click();
	});

	//����
	$('#BAdd').click(function () {
		BAdd_click();
	});

	//�޸�
	$('#BUpdate').click(function () {
		BUpdate_click();
	});


	//����(����VIP�ȼ�ά��)
	$('#BLClear').click(function () {
		BLClear_click();
	});

	//����(����VIP�ȼ�ά��)
	$('#BLAdd').click(function () {
		BLAdd_click();
	});

	//�޸�(����VIP�ȼ�ά��)
	$('#BLUpdate').click(function () {
		BLUpdate_click();
	});
	/*
	$('#NoActive').checkbox({
		onCheckChange:function(e,vaule){
			$("#LocVIPGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.VIPLevel",
			QueryName:"FindLocVIPInfo",
			VIPLevelID:$("#ID").val(),
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
			LocID:$("#LocList").combobox('getValue')
			})			
		}			
	});   
	 */

	//��ѯ(����VIP�ȼ�ά��)
	$('#BLFind').click(function () {
		BLFind_click();
	});

})



/*******************************VIP�ȼ� start*************************************/
//��ѯ
function BFind_click() {
	$("#VIPGrid").datagrid('load', {
		ClassName: "web.DHCPE.CT.VIPLevel",
		QueryName: "FindVIPLevel",
		Code: $("#Code").val(),
		Desc: $("#Desc").val(),
		NoActive: $("#VIPNoActive").checkbox('getValue') ? "Y" : "N"

	});
}

//����
function BClear_click() {
	$("#ID,#Code,#Desc").val("");
	$("#VIPNoActive").checkbox('setValue', true);
	BFind_click();
	BLFind_click();

}

//����
function BAdd_click() {

	BSave_click("0");
}

//�޸�
function BUpdate_click() {
	BSave_click("1");
}

function BSave_click(Type) {

	if (Type == "1") {
		var ID = $("#ID").val();
		if (ID == "") {
			$.messager.alert("��ʾ", "��ѡ����޸ĵļ�¼", "info");
			return false;
		}
	}
	if (Type == "0") {
		if ($("#ID").val() != "") {
			$.messager.alert("��ʾ", "�������ݲ���ѡ�м�¼,�����������������", "info");
			return false;
		}
		var ID = "";
	}

	var Code = $("#Code").val();
	if ("" == Code) {
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
		});
		$.messager.alert("��ʾ", "���벻��Ϊ��", "info");
		return false;
	}

	var Desc = $("#Desc").val();
	if ("" == Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
		});
		$.messager.alert("��ʾ", "��������Ϊ��", "info");
		return false;
	}

	var iVIPNoActive = "N";
	var VIPNoActive = $("#VIPNoActive").checkbox('getValue');
	if (VIPNoActive) iVIPNoActive = "Y"

	var UserID = session['LOGON.USERID'];

	var InfoStr = Code + "^" + Desc + "^" + iVIPNoActive + "^" + UserID;

	//alert("InfoStr:"+InfoStr)

	var ret = tkMakeServerCall("web.DHCPE.CT.VIPLevel", "UpdateVIPLevel", ID, InfoStr);
	var Arr = ret.split("^");
	if (Arr[0]!="-1") {
		$.messager.popover({ msg:Arr[1], type: 'success', timeout: 1000 });
		BClear_click();
	} else {
		$.messager.alert("��ʾ", Arr[1], "error");
	}


}

function InitVIPGrid() {
	$HUI.datagrid("#VIPGrid", {
		url: $URL,
		fit: true,
		border: false,
		striped: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams: {
			ClassName: "web.DHCPE.CT.VIPLevel",
			QueryName: "FindVIPLevel",
			NoActive: $("#VIPNoActive").checkbox('getValue') ? "Y" : "N"

		},
		frozenColumns: [[
			{ field: 'TCode', title: '����', width: 60 },
			{ field: 'TDesc', title: '����', width: 120 },

		]],
		columns: [[
			{ field: 'id', title: 'id', hidden: true },
			{ field: 'TNoActive', title: '����', align: 'center', width: 60 },
			{ field: 'TUpdateDate', title: '��������', width: 120 },
			{ field: 'TUpdateTime', title: '����ʱ��', width: 120 },
			{ field: 'TUserName', title: '������', width: 120 }

		]],
		onSelect: function (rowIndex, rowData) {

			$("#ID").val(rowData.id);
			$("#Desc").val(rowData.TDesc);
			$("#Code").val(rowData.TCode);
			$('#LocVIPGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			BLClear_click();

		}
	});
}

/*******************************VIP�ȼ� end*************************************/


/*******************************����VIP�ȼ����� start*************************************/

//��ѯ(����VIP�ȼ�ά��)
function BLFind_click() {

	$("#LocVIPGrid").datagrid('load', {
		ClassName: "web.DHCPE.CT.VIPLevel",
		QueryName: "FindLocVIPInfo",
		VIPLevelID: $("#ID").val(),
		NoActiveFlag: $("#NoActive").checkbox('getValue') ? "Y" : "N",
		LocID: $("#LocList").combobox('getValue')
	})
}


//����
function BLClear_click() {

	$("#LVID,#HPCode,#Template,#ZYDInfo,#ZYDTemplate").val("");
	$("#Secret,#Default").checkbox('setValue', false);
	$("#NoActive").checkbox('setValue', true);
	$("#PatFeeType,#HMService,#CutInLine,#GeneralType").combobox('setValue', "");
	$("#OrdSetsDesc").combogrid('setValue', "");
	$("#GeneralType").combobox('setValue', "JKTJ");
	$("#GIFlag").combobox("setValue", "");
	BLFind_click();

}

//����
function BLAdd_click() {

	BLSave_click("0");
}

//�޸�
function BLUpdate_click() {
	BLSave_click("1");
}


function BLSave_click(Type) {

	var VIPLevelDR = $("#ID").val();
	if (VIPLevelDR == "") {
		$.messager.alert("��ʾ", "��ѡ��VIP�ȼ���¼", "info");
		return false;
	}

	if (Type == "1") {
		var ID = $("#LVID").val();
		if (ID == "") {
			$.messager.alert("��ʾ", "��ѡ����޸ĵļ�¼", "info");
			return false;
		}
	}
	if (Type == "0") {
		if ($("#LVID").val() != "") {
			$.messager.alert("��ʾ", "�������ݲ���ѡ�м�¼,�����������������", "info");
			return false;
		}
		var ID = "";
	}


	var LocID = $("#LocList").combobox('getValue');

	var iHPCode = $("#HPCode").val();
	if ("" == iHPCode) {
		$("#HPCode").focus();
		var valbox = $HUI.validatebox("#HPCode", {
			required: true,
		});
		$.messager.alert("��ʾ", "���ű��벻��Ϊ��", "info");
		return false;
	}

	var iZYDTemplate = ""
	//var iZYDTemplate=$("#ZYDTemplate").val();

	var iZYDInfo = $("#ZYDInfo").val();

	var iTemplate = $("#Template").val();

	var iPatFeeType = $("#PatFeeType").combobox('getValue');

	var iGeneralType = $("#GeneralType").combobox('getValue');

	var iHMService = $("#HMService").combobox('getValue');

	var reg = /^[0-9]+.?[0-9]*$/;
	if ((!(reg.test(iHMService))) && (iHMService != "")) { var iHMService = $("#HMServiceDR").val(); }

	var iCutInLine = $("#CutInLine").combobox('getValue');

	var iOrdSetsDesc = $("#OrdSetsDesc").combogrid('getValue');
	if (($("#OrdSetsDesc").combogrid('getValue') == undefined) || ($("#OrdSetsDesc").combogrid('getValue') == "")) { var iOrdSetsDesc = ""; }

	var iNoActive = "N";
	var NoActive = $("#NoActive").checkbox('getValue');
	if (NoActive) iNoActive = "Y"

	var iSecret = "N";
	var Secret = $("#Secret").checkbox('getValue');
	if (Secret) iSecret = "Y"

	var iDefault = "N";
	var Default = $("#Default").checkbox('getValue');
	if (Default) iDefault = "Y"

	var giFlag = $("#GIFlag").combobox("getValue");

	var UserID = session['LOGON.USERID'];

	var InfoStr = iHPCode + "^" + iZYDTemplate + "^" + iZYDInfo + "^" + iTemplate + "^" + iPatFeeType + "^" + iGeneralType + "^" + iHMService + "^" + iCutInLine + "^" + iOrdSetsDesc + "^" + iNoActive + "^" + iSecret + "^" + iDefault + "^" + LocID + "^" + UserID + "^" + tableName + "^" + VIPLevelDR + "^" + giFlag;

	//alert("InfoStr:"+InfoStr)

	var ret = tkMakeServerCall("web.DHCPE.CT.VIPLevel", "UpdateLocVIPLevel", ID, InfoStr);
	var Arr = ret.split("^");
	if (Arr[0] == "-1") {
		$.messager.alert("��ʾ", Arr[1], "error");
	} else {
		$.messager.alert("��ʾ", Arr[1], "success");
		BLFind_click();
	}

}


function InitLocVIPGrid() {
	$HUI.datagrid("#LocVIPGrid", {
		url: $URL,
		fit: true,
		border: false,
		striped: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams: {
			ClassName: "web.DHCPE.CT.VIPLevel",
			QueryName: "FindLocVIPInfo",
			LocID: session['LOGON.CTLOCID'],
			NoActiveFlag: $("#NoActive").checkbox('getValue') ? "Y" : "N",
			VIPLevelID: $("#ID").val()
		},

		frozenColumns: [[
			{ field: 'HPCode', title: '���ű���', width: 90 },
			{ field: 'Template', title: '����ģ��', width: 120 },
			{ field: 'Default', title: 'Ĭ��', width: 50 },
			{ field: 'NoActive', title: '����', width: 50 }
		]],
		columns: [[

			{ field: 'ID', title: 'ID', hidden: true },
			{ field: 'Secret', title: '����', width: 50 },
			{ field: 'FeeTypeDR', title: 'FeeTypeDR', hidden: true },
			{ field: 'FeeType', title: '�������', width: 150 },
			{ field: 'OrdSetsDR', title: 'OrdSetsDR', hidden: true },
			{ field: 'OrdSets', title: 'Ĭ���ײ�', width: 150 },
			{ field: 'ZYDInfo', title: '���ﵥ��ʾ', width: 150 },
			{
				field: 'ZYDTemplate', title: '���ﵥģ��', width: 150, formatter: function (value, row, ind) {
					var text = "<span color='red'>Ĭ��</span>";
					if (value.indexOf("$") >= 0) {
						var headT = "", bodyT = "", footT = "";
						var templateA = value.split("$");
						for (var i = 0; i < templateA.length; i++) {
							var temp = templateA[i];
							if (i == 0) {  // Head
								switch (temp) {
									case "H-Simple": headT = "��"; break;
									case "H-General": headT = "����"; break;
									case "H-Fully": headT = "ȫ��"; break;
									case "H-Custom": headT = "�Զ���"; break;
									default: "";
								}
							} else if (i == 1) {  // Body
								switch (temp) {
									case "B-Formatter1": bodyT = "��Ŀ��ʽ1"; break;
									case "B-Formatter2": bodyT = "��Ŀ��ʽ2"; break;
									case "B-Formatter3": bodyT = "��Ŀ��ʽ3"; break;
									case "B-Formatter4": bodyT = "��Ŀ��ʽ4"; break;
									case "B-Custom": bodyT = "�Զ���"; break;
									default: "";
								}
							} else if (i == 2) {  // Foot
								switch (temp) {
									case "F-NoFooter": footT = "��ҳ��"; break;
									case "F-Pagination": footT = "��ҳ��"; break;
									case "F-Tips": footT = "����ʾ"; break;
									case "F-PageAndTips": footT = "ҳ��+��ʾ"; break;
									case "F-Receive": footT = "��ȡ��Ϣ"; break;
									case "B-Custom": footT = "�Զ���"; break;
									default: "";
								}
							}
						}
						text = headT + "," + bodyT + "," + footT;
					}
					return "<a href='javascript:void(0);' class='grid-td-text' onclick='BShowDJDTemplate(\"" + row.ID + "\", \"" + value + "\")'>" + text + "</a>";
				}
			},
			{ field: 'HMServiceDR', title: 'HMServiceDR', hidden: true },
			{ field: 'HMService', title: '�ʾ���', width: 150 },
			{ field: 'CutInLine', title: '�Ƿ���', width: 90 },
			{ field: 'TGIFlagDR', title: 'TGIFlagDR', hidden: true },
			{ field: 'TGIFlag', title: '�޶�����', width: 90 },
			{
				field: 'GeneralType', title: '�ܼ�����', width: 150,
				formatter: function (value, rowData, rowIndex) {
					if (value == "JKTJ") return "�������";
					else if (value == "RZTJ") return "��ְ���";
					else if (value == "GWY") return "����Ա";
					else if (value == "ZYJK") return "ְҵ����";
					else if (value == "JKZ") return "����֤";
					else if (value == "OTHER") return "����";
					else return "�������";
				}
			},
			{ field: 'UpdateDate', title: '��������', width: 150 },
			{ field: 'UpdateTime', title: '����ʱ��', width: 150 },
			{ field: 'UserName', title: '������', width: 120 }
		]],
		onSelect: function (rowIndex, rowData) {

			$("#LVID").val(rowData.ID);
			$("#HPCode").val(rowData.HPCode);
			$("#Template").val(rowData.Template);
			$("#ZYDInfo").val(rowData.ZYDInfo);
			$("#ZYDTemplate").val(rowData.ZYDTemplate);
			if (rowData.Secret == "N") {
				$("#Secret").checkbox('setValue', false);
			} if (rowData.Secret == "Y") {
				$("#Secret").checkbox('setValue', true);
			};

			if (rowData.Default == "N") {
				$("#Default").checkbox('setValue', false);
			} if (rowData.Default == "Y") {
				$("#Default").checkbox('setValue', true);
			};

			$("#PatFeeType").combobox('setValue', rowData.FeeTypeDR);
			$("#OrdSetsDesc").combogrid('setValue', rowData.OrdSetsDR);
			$("#HMService").combobox('setValue', rowData.HMService);
			$("#HMServiceDR").val(rowData.HMServiceDR)
			$("#CutInLine").combobox('setValue', rowData.CutInLine);
			$("#GeneralType").combobox('setValue', rowData.GeneralType);
			$("#GIFlag").combobox("setValue", rowData.TGIFlagDR);
			if (rowData.NoActive == "N") {
				$("#NoActive").checkbox('setValue', false);
			} if (rowData.NoActive == "Y") {
				$("#NoActive").checkbox('setValue', true);
			};


		}
	});
}

/*******************************����VIP�ȼ����� end*************************************/
function InitCombobox() {
	var LocID = session['LOGON.CTLOCID']
	var LocListID = $("#LocList").combobox('getValue');
	if (LocListID != "") { var LocID = LocListID; }

	//������
	var VIPObj = $HUI.combobox("#PatFeeType", {
		url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeType&ResultSetType=array",
		valueField: 'id',
		textField: 'desc',
		panelHeight: '70',
	});

	//�ʾ�ȼ�
	var HMSObj = $HUI.combobox("#HMService", {
		url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindHMService&ResultSetType=array&LocID=" + LocID,
		valueField: 'id',
		textField: 'desc',
		panelHeight: '105',
	});


	//Ĭ���ײ�
	var OrdSeObj = $HUI.combogrid("#OrdSetsDesc", {
		panelWidth: 500,
		url: $URL + "?ClassName=web.DHCPE.HandlerOrdSetsEx&QueryName=queryOrdSet",
		mode: 'remote',
		delay: 200,
		idField: 'OrderSetId',
		textField: 'OrderSetDesc',
		onBeforeLoad: function (param) {
			param.Set = param.q;
			param.Type = "ItemSet";
			param.LocID = session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];
			param.UserID = session['LOGON.USERID'];

		},
		columns: [[
			{ field: 'OrderSetId', title: 'ID', width: 80 },
			{ field: 'OrderSetDesc', title: '����', width: 200 },
			{ field: 'IsBreakable', title: '�Ƿ���', width: 80 },
			{ field: 'OrderSetPrice', title: '�۸�', width: 100 },

		]]
	});

	// �ܼ�����
	$HUI.combobox("#GeneralType", {
		valueField: 'id',
		textField: 'text',
		panelHeight: "auto",
		//editable:false,
		data: [
			{ id: 'JKTJ', text: '�������', selected: 'true' },
			{ id: 'RZTJ', text: '��ְ���' },
			{ id: 'GWY', text: '����Ա' },
			{ id: 'ZYJK', text: 'ְҵ����' },
			{ id: 'JKZ', text: '����֤' },
			{ id: 'OTHER', text: '����' }
		]
	});

	//�Ƿ���
	$HUI.combobox("#CutInLine", {
		valueField: 'id',
		textField: 'text',
		panelHeight: "auto",
		data: [
			{ id: 'Y', text: '��' },
			{ id: 'N', text: '��' }
		]
	});

}

// Ԥ��ϵͳָ����
function BShowDJDTemplate(id, tempName) {
	var SelRowData = $("#VIPGrid").datagrid("getSelected");
	if (!SelRowData) {
		$.messager.alert("��ʾ", "δ��ȡ��VIP�ȼ���", "info");
		return false;
	}
	var VIPDesc = SelRowData.TDesc + "-";

	var lnk = "dhcpe.ct.djdtemplate.csp" + "?ID=" + id + "&TemplateName=" + tempName + "&LocID=" + session['LOGON.CTLOCID'];
	websys_showModal({
		title: VIPDesc + '���쵥��ʽԤ��',
		url: websys_writeMWToken(lnk),
		width: '1150',
		height: '650',
		iconCls: 'icon-w-paper',
		onClose: function() {
			BLFind_click();
		}
	});
}
