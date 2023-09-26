/**
 * FileName: dhcbill.ipbill.patientinfo.js
 * Anchor: ZhYW
 * Date: 2019-04-14
 * Description: 患者信息查询
 */

$(function () {
	initQueryMenu();
	initPatInfoList();
});

function initQueryMenu() {
	setValueById("name", ascTransChar(GV.Name));
	setValueById("IDNo", GV.IDNo);
	setValueById("birthDate", GV.BirthDate);
	setValueById("healthFundNo", GV.HealthFundNo);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadPatInfoList();
		}
	});
	
	$HUI.combobox("#sex", {
		panelHeight: "auto",
		url: $URL + "?ClassName=web.UDHCOPOtherLB&MethodName=ReadSex&JSFunName=GetSexToHUIJson",
		valueField: "id",
		textField: "text",
		blurValidValue: true,
		defaultFilter: 4,
		onLoadSuccess: function(data) {
			$(this).combobox("clear");
		}
	});
}

function initPatInfoList() {
	$HUI.datagrid("#patInfoList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: [[{title: '登记号', field: 'TPAPERNo', width: 100},
				   {title: '患者姓名', field: 'TPAPERName', width: 100},
				   {title: '性别', field: 'TSex', width: 60},
				   {title: '出生日期', field: 'TPAPERDob', width: 100},
				   {title: '身份证号', field: 'TPAPERID', width: 150},
				   {title: '住址', field: 'TAddress', width: 150},
				   {title: '病案号', field: 'TIPMedicare', width: 80},
				   {title: '工作单位', field: 'TCompany', width: 100},
				   {title: '联系电话', field: 'TTelephone', width: 100},
				   {title: '手机', field: 'TMobile', width: 100},
				   {title: '工作电话', field: 'TWorkTel', width: 100},
				   {title: '联系人', field: 'TForeignId', width: 80},
				   {title: '联系人电话', field: 'TTForeignTel', width: 100},
				   {title: '医保手册号', field: 'TInsuNo', width: 90}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.DHCIPBillPAPERInfo",
			QueryName: "CheckPatInfo",
			PAPERName: getValueById("name"),
			PAPERNo: GV.PatientNo,
			SexID: getValueById("sex"),
			PAPERID: getValueById("IDNo"),
			BirthDate: getValueById("birthDate"),
			InsuNo: getValueById("healthFundNo")
		},
		onDblClickRow: function (rowIndex, rowData) {
			websys_showModal("options").originWindow.switchPatient(rowData.TPAPERNo);
			websys_showModal("close");
		}
	});
}

function loadPatInfoList() {
	var queryParams = {
		ClassName: "web.DHCIPBillPAPERInfo",
		QueryName: "CheckPatInfo",
		PAPERName: getValueById("name"),
		PAPERNo: GV.PatientNo,
		SexID: getValueById("sex"),
		PAPERID: getValueById("IDNo"),
		BirthDate: getValueById("birthDate"),
		InsuNo: getValueById("healthFundNo")
	};
	loadDataGridStore("patInfoList", queryParams);
}