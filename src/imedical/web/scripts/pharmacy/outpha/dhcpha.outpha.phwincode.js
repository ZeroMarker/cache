/**
 * 模块:    门诊药房
 * 子模块:  药房窗口定义
 * 编写日期:2017-11-20
 * 编写人:  yunhaibao
 */
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var ComLocRowId=""
var HospId=session['LOGON.HOSPID'];
$(function () {
	InitHospCombo();
	InitDict();
	InitGrid();
	$("#btnClear").on('click', ClearHandler);
	$("#btnAdd").on('click', AddHandler);
	$("#btnUpdate").on('click', UpdateHandler);
	$("#btnSearch").on('click', SearchHandler);
});

var CtLocEditor = {
	type: 'combobox',
	options: {
		panelHeight: "300",
		valueField: "RowId",
		textField: "Desc",
		mode: "remote",
		url:'DHCST.COMMONPHA.ACTION.csp'+'?action=GetCtLocDs&HospId='+HospId,
		onHidePanel: function () {
			var locId=$(this).combobox("getValue");
			var winSelect = $("#grid-phwin").datagrid('getSelected');
			if (winSelect == null) {
				$.messager.alert("提示", "请先选择药房窗口!", "info")
				return;
			}
			var phwId = winSelect.TPhwid;
			var saveRet = tkMakeServerCall("PHA.OP.CfDispWin.OperTab", "InsertPhwLoc", phwId, locId);
			var retCode = saveRet.split("^")[0];
			var retMessage = saveRet.split("^")[1];
			if (retCode != 0) {
				$.messager.alert('提示', retMessage, "warning");
				return;
			} else {
				$.messager.alert('提示', "指定科室增加成功!", "info");
				$('#grid-locwin').datagrid('reload');
			}
		}
	}
}

/// 初始化字典
function InitDict() {
	var options = {
		width: 'auto',
		panelWidth: 'auto',
		url: commonOutPhaUrl + '?action=GetUserAllLocDs&gUserId=' + session['LOGON.USERID']+'&HospId='+HospId,
		onSelect: function (rowData) {
			var locId=rowData.RowId;
			if(locId!=ComLocRowId){
				ComLocRowId=locId
				GetPhper(ComLocRowId);
			}
			
		}
	}
	$('#cmbPhLoc').dhcphaEasyUICombo(options);
	var options = {
		width: 'auto',
		panelWidth: 'auto',
		url: commonOutPhaUrl + '?action=GetWinType'
		
	}
	$('#cmbPhWinType').dhcphaEasyUICombo(options);
			
	
}

/// 初始化表格
function InitGrid() {
	///窗口定义
	var gridColumns = [[{
				field: 'TLocDesc',
				title: '药房名称',
				width: 200
			}, {
				field: 'TWinType',
				title: '窗口类型',
				width: 150
			}, {
				field: 'TWinDesc',
				title: '窗口名称',
				width: 200
			}, {
				field: 'TPyPerDesc',
				title: '预配人员',
				width: 100
			}, {
				field: 'TFyPerDesc',
				title: '预发人员',
				width: 100
			}, {
				field: 'TPyPer',
				title: 'TPyPer',
				width: 200,
				hidden: true
			}, {
				field: 'TFyPer',
				title: 'TFyPer',
				width: 200,
				hidden: true
			}, {
				field: 'TSureFlag',
				title: '默认',
				width: 150,
				width: 75,
				align: 'center',
				formatter: function (value, row, index) {
					if (value == "是") {
						return '<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>';
					}
				}
			}, {
				field: 'TNoUseFlag',
				title: '无效',
				width: 150,
				width: 75,
				align: 'center',
				formatter: function (value, row, index) {
					if (value == "是") {
						return '<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>';
					}
				}
			}, {
				field: 'TPhlid',
				title: 'TPhlid',
				width: 150,
				hidden: true
			}, {
				field: 'TPhwid',
				title: 'TPhwid',
				width: 150,
				hidden: true
			}, {
				field: 'TLocId',
				title: 'TLocId',
				width: 150,
				hidden: true
			}, {
				field: 'TWinTypeId',
				title: 'TWinTypeId',
				width: 150,
				hidden: true
			}

		]];

	var options = {
		ClassName: 'PHA.OP.CfDispWin.Query',
		QueryName: 'FindPhWin',
		fitColumns: false,
		columns: gridColumns,
		rownumbers: true,
		singleSelect: true,
		striped: true,
		title: "药房窗口",
	        queryParams:{
		        StrParams: "|@|"+HospId
		    },
		onSelect: function (rowIndex, rowData) {
			var locId=rowData.TLocId;
			if(ComLocRowId!=locId){
				ComLocRowId=locId;
				GetPhper(ComLocRowId);
			}
			$("#cmbPhLoc").combobox('setValue', rowData.TLocId);
			$("#cmbPhLoc").combobox('setText', rowData.TLocDesc);
			$("#cmbPhWinType").combobox('setValue', rowData.TWinTypeId);
			$("#txtPhWinDesc").val(rowData.TWinDesc);
			$("#chkDefault").prop("checked", rowData.TSureFlag == '是' ? true : false);
			$("#chkNoUse").prop("checked", rowData.TNoUseFlag == '是' ? true : false);
			
			$("#cmbPhPyPer").combobox('setValue', rowData.TPyPer);
			$("#cmbPhPyPer").combobox('setText', rowData.TPyPerDesc);
			$("#cmbPhFyPer").combobox('setValue', rowData.TFyPer);
			$("#cmbPhFyPer").combobox('setText', rowData.TFyPerDesc);
			
			$('#grid-locwin').datagrid({
				queryParams: {
					StrParams: rowData.TPhwid
				}
			});
			
			
		},
		onLoadSuccess: function () {
			$('#grid-locwin').datagrid('loadData', {
				total: 0,
				rows: []
			});
			$('#grid-locwin').datagrid('options').queryParams.params = "";
		}
	}
	$('#grid-phwin').dhcstgrideu(options);
	// 科室指定窗口
	var gridColumns = [[{
				field: 'THandler',
				title: "<a href='#' onclick='AddWinLoc()'><i class='fa fa-plus' aria-hidden='true' style='color:#17A05D;font-size:18px'></i></a>",
				width: 50,
				align: 'center',
				formatter: function (value, row, index) {
					return "<a href='#' onclick='DeleteWinLoc(" + index + ")'><i class='fa fa-minus' aria-hidden='true' style='color:#DE5145;font-size:18px'></i></a>";
				}
			}, {
				field: 'Tloc',
				title: '科室',
				editor: CtLocEditor,
				width: 200
			}, {
				field: 'Trowid',
				title: 'Trowid',
				width: 200,
				hidden: true
			}, {
				field: 'TLocId',
				title: 'TLocId',
				width: 200,
				hidden: true
			}
		]];

	var options = {
		ClassName: 'PHA.OP.CfDispWin.Query',
		QueryName: 'GetLocWin',
		fitColumns: true,
		columns: gridColumns,
		singleSelect: true,
		striped: true,
		title: "指定科室",
		pagination: false
	}
	$('#grid-locwin').dhcstgrideu(options);
}

function ClearHandler() {
	$("#cmbPhLoc").combobox('setValue', "");
	$("#cmbPhWinType").combobox('setValue', "");
	$("#txtPhWinDesc").val("");
	$("#chkDefault").prop("checked", false);
	$("#chkNoUse").prop("checked", false);
	$("#cmbPhPyPer").combobox('setValue', "");
	$("#cmbPhFyPer").combobox('setValue', "");
	$('#grid-phwin').datagrid({
		queryParams: {
			StrParams:"|@|"+HospId
		}
	});
	ComLocRowId="";
}

/// 获取参数
function QueryParams(getType) {
	var params = "";
	var locId = $("#cmbPhLoc").combobox('getValue');
	if ((getType != "") && (locId == "")) {
		$.messager.alert('提示', "药房名称不能为空!", "warning");
		return "";
	}
	var winTypeId = $("#cmbPhWinType").combobox('getValue');
	if ((getType != "") && (winTypeId == "")) {
		$.messager.alert('提示', "窗口类型不能为空!", "warning");
		return "";
	}
	var winDesc = $("#txtPhWinDesc").val();
	if ((getType != "") && (winDesc == "")) {
		$.messager.alert('提示', "窗口名称不能为空!", "warning");
		return "";
	}
	var defaultFlag = $("#chkDefault").prop("checked") == true ? '1' : '0';
	var nouseFlag = $("#chkNoUse").prop("checked") == true ? '1' : '0';
	var PhPyPer = $("#cmbPhPyPer").combobox('getValue');
	var PhFyPer = $("#cmbPhFyPer").combobox('getValue');
	params = locId + "^" + winTypeId + "^" + winDesc + "^" + defaultFlag + "^" + nouseFlag+ "^" +PhPyPer + "^" +PhFyPer;
	return params;
}

function AddHandler() {
	var params = QueryParams(1);
	if (params == "") {
		return;
	}
	var paramsArr = params.split("^");
	var PhPerStr=paramsArr[5]+ "^" + paramsArr[6];
	var saveRet = tkMakeServerCall("PHA.OP.CfDispWin.OperTab", "Insert", paramsArr[0], paramsArr[2], paramsArr[3], paramsArr[4], paramsArr[1], session['LOGON.USERID'],PhPerStr);
	var retCode = saveRet.split("^")[0];
	var retMessage = saveRet.split("^")[1];
	if (retCode != 0) {
		$.messager.alert('提示', retMessage, "warning");
		return;
	} else {
		$.messager.alert('提示', "增加成功!", "info");
		$("#grid-phwin").datagrid("reload");
	}
}

function UpdateHandler() {
	var seletcted = $("#grid-phwin").datagrid("getSelected");
	if (seletcted == null) {
		$.messager.alert('提示', "请先选中需修改的行!", "warning");
		return;
	}
	var params = QueryParams(1);
	if (params == "") {
		return;
	}
	var ctLocId = seletcted.TLocId;
	var phLocId = seletcted.TPhlid;
	var rowId = seletcted.TPhwid;
	var paramsArr = params.split("^");
	if (ctLocId != paramsArr[0]) {
		$.messager.alert('提示', "不允许修改药房!", "warning");
		return;
	}
	var PhPerStr=paramsArr[5]+ "^" + paramsArr[6];
	var saveRet = tkMakeServerCall("PHA.OP.CfDispWin.OperTab", "Update", rowId, paramsArr[2], paramsArr[3], paramsArr[4], paramsArr[1], session['LOGON.USERID'],PhPerStr);
	var retCode = saveRet.split("^")[0];
	var retMessage = saveRet.split("^")[1];
	if (retCode != 0) {
		$.messager.alert('提示', retMessage, "warning");
		return;
	} else {
		$.messager.alert('提示', "修改成功!", "info");
		$("#grid-phwin").datagrid("reload");
	}
}

function SearchHandler() {
	var params = QueryParams("");
	$('#grid-phwin').datagrid({
		queryParams: {
			StrParams: params+"|@|"+HospId
		}
	});
}

function AddWinLoc() {
	var row = $('#grid-locwin').datagrid('getData').rows[0];
	if (row) {
		if (row.Trowid == "") {
			return;
		}
	}
	$("#grid-locwin").datagrid('insertRow', {
		index: 0,
		row: {
			Tloc: '',
			Trowid: '',
			TLocId: ''
		}
	});
	$("#grid-locwin").datagrid('beginEdit', 0);
}

function DeleteWinLoc(rowIndex) {
	$.messager.confirm('提示', '您确认删除吗？', function (r) {
		if (r) {
			var locWinData = $("#grid-locwin").datagrid('getData').rows[rowIndex];
			var locWinId = locWinData.Trowid;
			if(locWinId==""){
				$("#grid-locwin").datagrid("deleteRow",rowIndex);
				return;
			}
			var delRet = tkMakeServerCall("PHA.OP.CfDispWin.OperTab", "DeletePhwLoc", locWinId);
			var retCode = delRet.split("^")[0];
			var retMessage = delRet.split("^")[1];
			if (retCode != 0) {
				$.messager.alert('提示', retMessage, "warning");
				return;
			} else {
				$.messager.alert('提示', "删除指定科室成功!", "info");
				$("#grid-locwin").datagrid('reload');
			}
		}
	});
}

function GetPhper(LocRowId)
{
	
	var options = {
		width: 'auto',
		panelWidth: 'auto',
		url: commonOutPhaUrl + '?action=GetPhPerList&perFlag=1&locId='+LocRowId
	}
	$('#cmbPhFyPer').dhcphaEasyUICombo(options);
	var options = {
		width: 'auto',
		panelWidth: 'auto',
		url: commonOutPhaUrl + '?action=GetPhPerList&perFlag=2&locId='+LocRowId
	}
	$('#cmbPhPyPer').dhcphaEasyUICombo(options);
}
function InitHospCombo(){
	var genHospObj =DHCSTEASYUI.GenHospComp({tableName:'PHA-OP-DispWindow'}); //加载医院
	if (typeof genHospObj === 'object') {
		//增加选择事件
		$('#_HospList').combogrid("options").onSelect=function(index,record){
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;
				ClearHandler();
				$('#cmbPhLoc').combobox('loadData', {})
				$('#cmbPhLoc').combobox('options').url=commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+session['LOGON.USERID']+'&HospId='+HospId;
				$('#cmbPhLoc').combobox('reload');			
				CtLocEditor.options.url='DHCST.COMMONPHA.ACTION.csp'+'?action=GetCtLocDs&HospId='+HospId;
				var gridColumns=[[
			        {field:'THandler',title:"<a href='#' onclick='AddWinLoc()'><i class='fa fa-plus' aria-hidden='true' style='color:#17A05D;font-size:18px'></i></a>",width:50,align:'center',
			        	formatter:function(value,row,index){
				        		return "<a href='#' onclick='DeleteWinLoc("+index+")'><i class='fa fa-minus' aria-hidden='true' style='color:#DE5145;font-size:18px'></i></a>";
				        }
			        },
					{field:'Tloc',title:'科室',editor:CtLocEditor,width:200},
					{field:'Trowid',title:'Trowid',width:200,hidden:true},
					{field:'TLocId',title:'TLocId',width:200,hidden:true}
				]];	
				$('#grid-locwin').datagrid('options').columns=gridColumns;
				$('#grid-locwin').datagrid('options').queryParams.params = "";
		    	$('#grid-locwin').datagrid('loadData',{total:0,rows:[]}); 		
			}
		};
	}
}