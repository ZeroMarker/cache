/**
 * 价格优惠优惠类型关联项目审核
 * FileName: dhcbillconfig/priceruleconitm.audit.js
 * tanfb 2023-01-09
 */

//全局变量
var GV =
{
	CLASSNAME: "BILL.CFG.COM.BL.PriceRuleConItmCtl",
	ExamineFlag: ""	//审核标志
};

$(function () {
	
	//初始化datagrid
	$HUI.datagrid("#dg",
		{
			fit: true,
			rownumbers: true,
			striped: false,
			fitColumns: true,
			singleSelect: false,
			autoRowHeight: false,
			toolbar: '#toolbar',
			checkbox: true,
			columns: [[
				{
					title: '',
					field: 'CheckOrd',
					checkbox: true,
					width: 20,
					showTip: true
				},
				{
					field: 'TarItemDesc',
					title: '项目名称',
					width: 150,
					tipPosition: "top",
					showTip: true
				},
				{
					field: 'AuditStatus',
					title: '审核标志',
					width: 50,
					formatter: function (value, row, index) {
						if (row.AuditStatus == "1") {
							return "审核通过";
						}
						else if ((row.AuditStatus == "2") && (row.AuditUser != "")) {
							return "审核拒绝";
						}
						else {
							return "未审核";
						}
					}
				},
				{
					field: 'AuditUser',
					title: '审核人',
					width: 50
				},
				{
					field: 'Memo',
					title: '审核备注',
					width: 150
				},
				{
					field: 'AuditDate',
					title: '审核时间',
					width: 100,
					formatter: function (value, row, index) {
						return row.AuditDate + " " + row.AuditTime;
					}
				},
				{
					field: 'TarItemId',
					title: '项目ID',
					width: 80
				},
				{
					field: 'RuleDesc',
					title: '优惠名称',
					width: 150
				},
				{
					field: 'ROWID',
					title: 'ROWID',
					width: 10,
					hidden: true
				}

			]],
			pageSize: 30,
			pagination: true,
			onLoadSuccess: function (data) {
				if (data != "" && data.total > 0) {
					return;
				}
			}
		});

	//初始化医院下拉框
	initHospitalCbx();

	//初始化优惠类型下拉框
	initRuleCbx();
	
	//初始化审核标志下拉框
	initAuditFlagCbx();

	//初始化备注对话框
	initInputDescDialog();
	
	//判断按钮是否按下
	initQueryMenu();	
});

//判断按钮是否按下
function initQueryMenu(){
	
	//登记号回车查询事件
	$("#dicKey").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			Querydic();
		}
	});
	
	// 查询
	$HUI.linkbutton("#btnQuery", {
		onClick: function () {
			Querydic();
		}
	});
	
	// 清屏
	$HUI.linkbutton("#btnClear", {
		onClick: function () {
			setValueById('dicKey', '');
			var defHospId = session['LOGON.HOSPID'];
			$("#hospital").combobox('select', defHospId);
			$("#ExamineFlag").combobox('select', '');
			$("#rule").combobox('select', '');
		}
	});
	
	// 审核通过
	$HUI.linkbutton("#btnPass", {
		onClick: function () {
			Examine("0");
		}
	});
	
	// 审核拒绝
	$HUI.linkbutton("#btnReject", {
		onClick: function () {
			Examine("1");
		}
	});
	
}

//初始化备注对话框
function initInputDescDialog() {
	$('#inputDescDialog').dialog(
		{
			autoOpen: false,
			title: '备注',
			iconCls: 'icon-w-edit',
			width: 426,
			height: 330,
			closed: true,
			cache: false,
			modal: true,
			resizable: true,
			buttons: [
				{
					text: '确定',
					iconCls: 'icon-w-save',
					handler: function () {
						var tVal = $('#inputDescDialog textarea').val();
						update(tVal);
						$('#inputDescDialog').dialog('close');
					}
				},
				{
					text: '取消',
					iconCls: 'icon-w-close',
					handler: function () {
						$('#inputDescDialog').dialog('close');
					}
				}
			]
		}
	);
}

//更新审核信息
function update(tVal) {
	var AllRowsData = $('#dg').datagrid('getChecked');
	var Examine = 0;
	var NotExamine = 0;
	for (i = 0; i < AllRowsData.length; i++) {
		if (AllRowsData[i]["AuditStatus"] != "1") {
			Examine = Examine + 1;
		}
		if (AllRowsData[i]["AuditUser"] == "" || AllRowsData[i]["AuditStatus"] != "2") {
			NotExamine = NotExamine + 1;
		}
	}
	var messagetex = "审核" + Examine;
	if (GV.ExamineFlag != "1") {
		var messagetex = "拒绝审核" + NotExamine;
	}
	$.messager.confirm("提示", "是否" + messagetex + "条数据？", function (r) {
		if (r) {
			for (i = 0; i < AllRowsData.length; i++) {
				if (GV.ExamineFlag == "1") {
					if (AllRowsData[i]["AuditStatus"] == "1") {
						continue;
					}
					var saveinfo = AllRowsData[i]["ROWID"] + "^" + GV.ExamineFlag + "^" + tVal;
					var savecode = tkMakeServerCall(GV.CLASSNAME, "SaveAudit", saveinfo, session['LOGON.USERID']);
					if (eval(savecode) < 0) {
						$.messager.alert('提示', '审核失败' + savecode, 'info');
						return;
					}
				}
				else {
					if (AllRowsData[i]["AuditStatus"] == "2" && AllRowsData[i]["AuditUser"] != "") {
						continue;
					}
					var saveinfo = AllRowsData[i]["ROWID"] + "^" + GV.ExamineFlag + "^" + tVal;
					var savecode = tkMakeServerCall(GV.CLASSNAME, "SaveAudit", saveinfo, session['LOGON.USERID']);
					if (eval(savecode) < 0) {
						$.messager.alert('提示', '拒绝审核失败' + savecode, 'info');
						return;
					}
				}
			}
			$("#dg").datagrid('reload');
			$("#dg").datagrid('unselectAll');
			$.messager.alert('提示', '操作成功!', 'info');
			Querydic();
		}
		else {
			return false;
		}
	}
	);
}

function Examine(Id) {
	var AllRowsData = $('#dg').datagrid('getChecked');
	var Examine = 0;
	var NotExamine = 0;
	for (i = 0; i < AllRowsData.length; i++) {
		if (AllRowsData[i]["AuditStatus"] != "1") {
			Examine = Examine + 1;
		}
		if (AllRowsData[i]["AuditUser"] == "" || AllRowsData[i]["AuditStatus"] != "2") {
			NotExamine = NotExamine + 1;
		}
	}
	if (Id == "0") {
		if (AllRowsData.length == 0) {
			$.messager.alert('提示', '请勾选要审核的数据!', 'info');
			return;
		}
		else if (Examine == 0) {
			$.messager.alert('提示', '选中的指标已审核,请重新选择!', 'info');
			return;
		}
		GV.ExamineFlag = "1";
		$('#inputDescDialog textarea').val();
		$('#inputDescDialog').dialog("open");
	}
	if (Id == "1") {
		if (AllRowsData.length == 0) {
			$.messager.alert('提示', '请勾选要拒绝审核的数据!', 'info');
			return;
		}
		else if (NotExamine == 0) {
			$.messager.alert('提示', '选中的指标已拒绝审核,请重新选择!', 'info');
			return;
		}
		GV.ExamineFlag = "2";
		$('#inputDescDialog textarea').val();
		$('#inputDescDialog').dialog("open");
	}
}

//初始化优惠类型下拉框
function initRuleCbx() {
	$HUI.combobox("#rule",
		{
			panelHeight: 150,
			url: $URL,
			editable: true,
			valueField: 'ROWID',
			textField: 'RuleDesc',
			defaultFilter: 4,
			onBeforeLoad: function (param) {
				param.ClassName = "BILL.CFG.COM.BL.PriceRuleCtl";
				param.QueryName = "QueryInfo";
				param.HospID = $('#hospital').combobox('getValue');
				param.KeyCode = "";
				param.ResultSetType = 'array';
			},
			onLoadSuccess: function (data) {
				if (data.length > 1) {
					$(this).combobox("setValue", "");
				}
			},
			onSelect: function (record) {
				Querydic();
			}
		}
	);
}

//初始化审核标志下拉框
function initAuditFlagCbx() {
	$HUI.combobox("#ExamineFlag",
		{
			panelHeight: 150,
			url: $URL,
			editable: true,
			valueField: 'DefaultValue',
			textField: 'DicDesc',
			defaultFilter: 4,
			onBeforeLoad: function (param) {
				param.ClassName = "BILL.CFG.COM.DictionaryCtl";
				param.QueryName = "QueryDicDataInfo";
				param.Type = "AuditFlag";
				param.KeyCode = "";
				param.ResultSetType = 'array';
			},
			onLoadSuccess: function (data) {
				if (data.length > 1) {
					$(this).combobox("setValue", "");
				}
			},
			onSelect: function (record) {
				Querydic();
			}
		}
	);
}


//初始化医院下拉框
function initHospitalCbx() {
	var tableName = "CF_BILL_COM.PriceRule";
	var defHospId = session['LOGON.HOSPID'];
	var SessionStr = session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.LOCID'] + "^" + defHospId; // 用户ID^安全组ID^科室ID^当前登录医院ID
	$("#hospital").combobox(
		{
			panelHeight: 150,
			url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName + '&SessionStr=' + SessionStr,
			method: 'GET',
			valueField: 'HOSPRowId',
			textField: 'HOSPDesc',
			editable: false,
			blurValidValue: true,
			onLoadSuccess: function (data) {
				$(this).combobox('select', defHospId);
			},
			onChange: function (newValue, oldValue) {
				Querydic();
			},
			onSelect: function (record) {
				$("#rule").combobox('reload');
			}
		}
	);
}

//加载审核界面表格
function Querydic() {
	$('#dg').datagrid('loadData',
		{
			total: 0,
			rows: []
		}
	);
	var QueryParam =
	{
		ClassName: GV.CLASSNAME,
		QueryName: 'QueryInfo',
		KeyCode: getValueById('dicKey'),
		rule: getValueById('rule'),
		type: 'Tar',
		ExamineFlag: $('#ExamineFlag').combobox('getValue')
	}
	loadDataGridStore('dg', QueryParam);
}
