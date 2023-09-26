/*
 * FileName: dhcbillmenu.invdepusergroup.js
 * User: TangTao
 * Date: 2014-04-10
 * Function: 押金收据与发票人员设置
 * Description:
 */

var lastIndex = "";
var EditIndex = -1;

$(function () {
	initGrid();
	if (BDPAutDisableFlag('BtnAdd')) {
		$('#BtnAdd').hide();
	}
	if (BDPAutDisableFlag('BtnDelete')) {
		$('#BtnDelete').hide();
	}
	
	var tableName = "Bill_Com_RcptGroupUser";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#hospital").combobox({
		panelHeight: 150,
		width: 300,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			//加载安全组
			var url = $URL + "?ClassName=DHCBILLConfig.DHCBILLOthConfig&QueryName=FindGroup&ResultSetType=array";
			$("#ComboGroup").combobox("clear").combobox("reload", url);
			
			//加载人员
			var url = $URL + "?ClassName=DHCBILLConfig.DHCBILLOthConfig&QueryName=FindGroupUser&ResultSetType=array";
			$("#ComboUser").combobox('clear').combobox("reload", url);
			
			var RcptType = getValueById("ComboBillType") || "A";
			var UserType = getValueById("ComboUserType");
			var ExpStr = RcptType + "^" + UserType;
			initLoadGrid(ExpStr);
		}
	});
	
	//人员类型
	$("#ComboUserType").combobox({
		valueField: 'id',
		textField: 'name',
		required: true,
		data: [{id:'1',name:'购入人员'}, {id:'2',name:'管理员'}, {id:'3',name:'收费员'}],
		onSelect: function(rec) {
			var ComboUserType = rec.id;
			var RcptType = 'A';
			var ExpStr = RcptType + '^' + ComboUserType;
			initLoadGrid(ExpStr);
			$('#ComboBillType, #ComboGroup, #ComboUser').combobox('clear');
			if((ComboUserType == 1) || (ComboUserType == 2)){
				$('#ComboBillType').combobox({disabled: true, required: false});
			}else {
				$('#ComboBillType').combobox({disabled: false, required: true});
			}
		}
	});
	
	//票据类型
	$("#ComboBillType").combobox({
		valueField: 'BillVal',    
        textField: 'BillDesc',
        required: true,
        url: $URL + "?ClassName=DHCBILLConfig.DHCBILLOthConfig&QueryName=FindBillType&ResultSetType=array",
		onSelect: function(rec) {
			var ComboUserType = getValueById("ComboUserType");   //人员类型
			var ExpStr = rec.BillVal + '^' + ComboUserType;
			initLoadGrid(ExpStr);
		}
	});
	
	//安全组
	$("#ComboGroup").combobox({
		valueField: 'TGrpRowid',    
        textField: 'TGrpFesc',
        required: true,
        defaultFilter: 4,
        onBeforeLoad:function(param) {
	        $.extend(param, {
		        	Grp: "",
	        		HospId: getValueById("hospital")
	        	});
			return true;
		},
		onSelect: function(rec) {
			var url = $URL + "?ClassName=DHCBILLConfig.DHCBILLOthConfig&QueryName=FindGroupUser&ResultSetType=array";
			$("#ComboUser").combobox('clear').combobox("reload", url);
		}
	});
	
	//人员
	$("#ComboUser").combobox({
		valueField: 'TUsrRowid',
        textField: 'TUsrName',
        required: true,
        defaultFilter: 4,
        onBeforeLoad: function(param) {
	        $.extend(param, {
			        Grp: getValueById("ComboGroup"),
			        Usr: "",
			        HospId: getValueById("hospital")
		        });
			return true;
		}
	});
});

function initGrid() {
	// 初始化Columns
	var CateColumns = [[{
				field: 'TRcptUsrName',
				title: '用户名称',
				width: 200,
				sortable: true,
				resizable: true
			}, {
				field: 'TRcptUsrGrp',
				title: '用户安全组',
				width: 200,
				sortable: true,
				resizable: true,
				hidden: true
			}, {
				field: 'TRcptUsrRowid',
				title: 'TRcptUsrRowid',
				width: 100,
				sortable: true,
				resizable: true,
				hidden: true
			}, {
				field: 'TRcptUsrGrpRowid',
				title: 'TRcptUsrGrpRowid',
				width: 100,
				sortable: true,
				resizable: true,
				hidden: true
			}, {
				field: 'TGrpUsrRowid',
				title: 'TGrpUsrRowid',
				width: 100,
				sortable: true,
				resizable: true,
				hidden: true
			}
		]];

	// 初始化DataGrid
	$('#tUserGroup').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		data: [],
		columns: CateColumns,
		toolbar: '#tToolBar',
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
}

function initLoadGrid(ExpStr) {
	var RcptTpye = "";
	var RcpeGrpRowid = "";
	if (ExpStr != "") {
		RcptTpye = ExpStr.split("^")[0];
		RcpeGrpRowid = ExpStr.split("^")[1];
	}
	var queryParams = {
		ClassName: "DHCBILLConfig.DHCBILLOthConfig",
		QueryName: "FindRcptGrpUser",
		RcptType: RcptTpye,
		RcptGrpType: RcpeGrpRowid,
		HospId: getValueById("hospital")
	};
	loadDataGridStore("tUserGroup", queryParams);
}

$('#BtnFind').bind('click', function () {
	var ComboUserType = $('#ComboUserType').combobox('getValue');
	var RcptType = "A";
	if (ComboUserType == 3) {
		RcptType = $('#ComboBillType').combobox('getValue')
	}
	var ExpStr = RcptType + "^" + ComboUserType;
	initLoadGrid(ExpStr);
});

$('#BtnAdd').bind('click', function () {
	var ComboUserType = $('#ComboUserType').combobox('getValue');
	var ComboGroup = $('#ComboGroup').combobox('getValue');
	var ComboUser = $('#ComboUser').combobox('getValue');
	var RcptType = "A";
	if (ComboUserType == 3) {
		RcptType = $('#ComboBillType').combobox('getValue');
	}
	var HospId = getValueById("hospital");
	var GrpStr = ComboUserType + "^" + ComboGroup + "^" + ComboUser + "^" + RcptType + "^" + HospId;
	$.cm({
		ClassName: "DHCBILLConfig.DHCBILLOthConfig",
		MethodName: "InsertGrpUser",
		GrpInfo: GrpStr,
		Guser: PUBLIC_CONSTANT.SESSION.USERID
	}, function(rtn) {
		if (rtn == "0") {
			$.messager.alert('提示', "保存成功", 'success');
		} else {
			$.messager.alert('提示', "保存失败，错误代码：" + rtn, 'error');
		}
		var ExpStr = RcptType + "^" + ComboUserType;
		initLoadGrid(ExpStr);
	});
});

$('#BtnDelete').bind('click', function () {
	var selected = $('#tUserGroup').datagrid('getSelected');
	if (selected) {
		$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
			if (r) {
				var GrpUsrRowid = selected.TGrpUsrRowid;
				var ComboUserType = $('#ComboUserType').combobox('getValue');
				var ComboGroup = selected.TRcptUsrGrpRowid;
				var ComboUser = selected.TRcptUsrRowid;
				var RcptType = "A";
				if (ComboUserType == 3) {
					RcptType = $('#ComboBillType').combobox('getValue');
				}
				var GrpStr = ComboUserType + "^" + ComboGroup + "^" + ComboUser + "^" + RcptType + "^" + GrpUsrRowid;
				$.cm({
					ClassName: "DHCBILLConfig.DHCBILLOthConfig",
					MethodName: "DeleteGrpUser",
					GrpInfo: GrpStr,
					Guser: PUBLIC_CONSTANT.SESSION.USERID
				}, function(rtn) {
					if (rtn == "0") {
						$.messager.alert('提示', "删除成功", 'success');
					} else {
						$.messager.alert('提示', "删除失败，错误代码：" + rtn, 'error');
					}
					var ExpStr = RcptType + "^" + ComboUserType;
					initLoadGrid(ExpStr);
				});
			}
		});
	} else {
		$.messager.alert('提示', "请选择要删除的记录", 'info');
	}
});