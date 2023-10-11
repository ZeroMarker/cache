/**
 * 模块:     煎药综合查询
 * 编写日期: 2019-07-17
 * 编写人:   GuoFa
 */
$(function () {
	InitDict(); //初始化下拉框
	InitGridQueryDetail(); //初始化表格
	InitSetDefVal(); //赋默认值
	queryDecInfo();
	$("#txt-prescno").on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			queryDecInfo();
		}
	});
	//处方号回车事件
	$("#txt-patno").on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			queryDecInfo();
		}
	});
	//登记号回车事件
	$('#txt-patno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txt-patno").val());
			if (patno != "") {
				$(this).val(PHA_COM.FullPatNo(patno));
				queryDecInfo();
			}
		}
	});
});
/**
 * 初始化组件
 * method InitDict
 */
function InitDict() {
	//煎药室
	PHA.ComboBox("cmbDecLoc", {
		width: 120,
		url: PHA_DEC_STORE.DecLoc().url,
		onSelect: function () {
			queryDecInfo();
		}
	});
	//当前流程
	PHA.ComboBox("cmbprocess", {
		width: 120,
		url: LINK_CSP + '?ClassName=PHA.DEC.Com.Store&MethodName=DecProDict&locId=' + gLocId,
		idField: 'RowId',
		textField: 'Description',
		method: 'get',
		onSelect: function () {
			queryDecInfo();
		}
	});
}
/**
 * 初始化明细表格
 * @method InitGridQueryDetail
 */
function InitGridQueryDetail() {
	var columns = [[{
				field: 'RowId',
				title: '煎药主表id',
				align: 'left',
				width: 100,
				hidden: true
			}, {
				field: 'patNo',
				title: '登记号',
				align: 'left',
				width: 100
			}, {
				field: 'patName',
				title: '姓名',
				align: 'left',
				width: 100
			}, {
				field: 'prescno',
				title: '处方号',
				align: 'left',
				width: 150,
				styler: function(value,row,index){
					return 'color:blue';
				}
			}, {
				field: 'ordLoc',
				title: '开单科室',
				align: 'left',
				width: 150
			}, {
				field: 'pdDesc',
				title: '当前流程',
				align: 'left',
				width: 70
			}, {
				field: 'pdType',
				title: '煎药类型',
				align: 'left',
				width: 70
			}, {
				field: 'compFlag',
				title: '完成标志',
				align: 'left',
				width: 70
			}, {
				field: 'pdDate',
				title: '生成日期',
				align: 'left',
				width: 100
			}, {
				field: 'pdTime',
				title: '生成时间',
				align: 'left',
				width: 80
			}, {
				field: 'soakInterval',
				title: '浸泡时长(分钟)',
				align: 'left',
				width: 120
			}, {
				field: 'soakEquiDesc',
				title: '浸泡设备',
				align: 'left',
				width: 80
			}, {
				field: 'firWaterQua',
				title: '首煎加水量(ml)',
				align: 'left',
				width: 120
			}, {
				field: 'firInterval',
				title: '首煎时长(分钟)',
				align: 'left',
				width: 120
			}, {
				field: 'firEquiDesc',
				title: '首煎设备',
				align: 'left',
				width: 80
			}, {
				field: 'secWaterQua',
				title: '二煎加水量(ml)',
				align: 'left',
				width: 120
			}, {
				field: 'secInterval',
				title: '二煎时长(分钟)',
				align: 'left',
				width: 120
			}, {
				field: 'secEquiDesc',
				title: '二煎设备',
				align: 'left',
				width: 80
			}, {
				field: 'labelNum',
				title: '标签数',
				align: 'left',
				width: 60
			}, {
				field: 'boxNum',
				title: '已装箱袋数',
				align: 'left',
				width: 120
			}
		]];
	var dataGridOption = {
		columns: columns,
		rownumbers: true,
		toolbar: '#toolBarDecComQuery',
		border: true ,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.Compre.Query",
			QueryName: "QueryDecoInfo"
		},
		onClickCell: function (rowIndex, field, value) {
			var RowId = $(this).datagrid("getRows")[rowIndex].RowId;
			if (field == "prescno") {
				PHADEC_UX.TimeLine(
					{
						modal: true,
						top: null,
						modalable: true
					},
					{ phpmId: RowId }
				);
			}	
		}
	};
	PHA.Grid("gridQueryDetail", dataGridOption);
}

/**
 * 获取界面元素值
 * method getParams
 */
function getParams() {
	var stDate = $("#startDate").datebox('getValue');
	var enDate = $("#endDate").datebox('getValue');
	var stTime = $('#startTime').timespinner('getValue') || "";
	var enTime = $('#endTime').timespinner('getValue') || "";
	var decLoc = $('#cmbDecLoc').combobox("getValue") || "";
	var type = $("input[name='busType']:checked").val() || "";
	var process = $('#cmbprocess').combobox("getValue") || "";
	var prescno = $.trim($("#txt-prescno").val());
	var patNo = $.trim($("#txt-patno").val());
	var succFlag = $('#chk-success').is(':checked');
	var succFlag = succFlag == true ? "Y" : "N";
	var params = stDate + "^" + enDate + "^" + stTime + "^" + enTime + "^" + decLoc + "^" + type + "^" + process + "^" + prescno + "^" + patNo + "^" + succFlag;
	return params;
}

/**
 * 查询table
 * method queryDecInfo
 */
function queryDecInfo() {
	var inputStr = getParams();
	$('#gridQueryDetail').datagrid('query', {
		inputStr: inputStr
	});
}
/**
 * 赋默认值
 * method InitSetDefVal
 */
function InitSetDefVal() {
	//公共配置
	$.cm({
		ClassName: "PHA.DEC.Com.Method",
		MethodName: "GetAppProp",
		UserId: gUserID,
		LocId: gLocId,
		SsaCode: "DEC.COMMON",
	}, function (jsonComData) {
		$("#startDate").datebox("setValue", jsonComData.StatStartDate);
		$("#endDate").datebox("setValue", jsonComData.StatEndDate);
		$('#startTime').timespinner('setValue', "00:00:00");
		$('#endTime').timespinner('setValue', "23:59:59");
		$("#cmbDecLoc").combobox("setValue", jsonComData.DefaultDecLoc);
	});
}
//清空
function ClearConditions() {
	InitSetDefVal();
	$("#cmbDecLoc").combobox('setValue', "");
	$("#cmbprocess").combobox('setValue', "");
	$("#txt-prescno").val("");
	$("#txt-patno").val("");
	$("#chk-success").checkbox("uncheck");	
	$("input[label='全部']").radio("check");
	$('#gridQueryDetail').datagrid('loadData', {
		total: 0,
		rows: []
	});
}

window.onload=function(){
	setTimeout("queryDecInfo()",200);
}
