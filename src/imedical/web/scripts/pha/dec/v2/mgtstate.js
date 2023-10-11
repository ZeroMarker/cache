/**
 * 模块:     煎药状态管理
 * 编写日期: 2022-09-01
 * 编写人:   MaYuqiang
 */
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	InitDict(); //初始化下拉框
	InitGridQueryState(); //初始化表格
	InitSetDefVal(); //赋默认值
	queryStateInfo();
	$("#txt-prescno").on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			queryStateInfo();
		}
	});
	//处方号回车事件
	$("#txt-patno").on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			queryStateInfo();
		}
	});
	//登记号回车事件
	$('#txt-patno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txt-patno").val());
			if (patno != "") {
				$(this).val(PHA_COM.FullPatNo(patno));
				queryStateInfo();
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
			queryStateInfo();
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
			queryStateInfo();
		}
	});
}
/**
 * 初始化明细表格
 * @method InitGridQueryState
 */
function InitGridQueryState() {
	var columns = [[{
				field: 'PDPIItmId',
				title: '煎药子表id',
				align: 'left',
				width: 100,
				hidden: true
			}, {
				field: 'patNo',
				title: '登记号',
				align: 'left',
				width: 120
			}, {
				field: 'patName',
				title: '姓名',
				align: 'left',
				width: 120
			}, {
				field: 'prescNo',
				title: '处方号',
				align: 'left',
				width: 150,
				styler: function(value,row,index){
					return 'color:blue';
				}
			}, {
				field: 'curState',
				title: '当前流程',
				align: 'left',
				width: 100
			}, {
				field: 'decState',
				title: '执行流程',
				align: 'left',
				width: 100
			}, {
				field: 'stateUserName',
				title: '执行人员',
				align: 'left',
				width: 100
			}, {
				field: 'stateDateTime',
				title: '执行时间',
				align: 'left',
				width: 180
			}, {
				field: 'stateEquiDesc',
				title: '执行设备',
				align: 'left',
				width: 120
			}, {
				field: 'cancelUserName',
				title: '撤消人员',
				align: 'left',
				width: 100
			}, {
				field: 'cancelDateTime',
				title: '撤消时间',
				align: 'left',
				width: 180
			}
		]];
	var dataGridOption = {
		columns: columns,
		rownumbers: true,
		toolbar: '#toolBarDecState',
		border: true ,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.MGTState.Query",
			QueryName: "QueryStateInfo"
		},
		onLoadSuccess: function(data){
			var rows = data.rows;
			var patEd = 1;
			var prescEd = 1;
			for(var i = (rows.length-1); i >=0 ; i--){
				var row = rows[i];
				//debugger;
				if(rows[i-1]){
					if((rows[i-1]['patNo'] != row['patNo'])&&(row['patNo']!="")){
						$('#gridDecState').datagrid("mergeCells",{
							index: i,
							field: 'patNo',
							rowspan: patEd
						});
						$('#gridDecState').datagrid("mergeCells",{
							index: i,
							field: 'patName',
							rowspan: patEd
						});
						patEd = 1;
					}else{
						++patEd;	
					}
					if(rows[i-1]['prescNo'] != row['prescNo']){
						$('#gridDecState').datagrid("mergeCells",{
							index: i,
							field: 'prescNo',
							rowspan: prescEd
						});
						$('#gridDecState').datagrid("mergeCells",{
							index: i,
							field: 'curState',
							rowspan: prescEd
						});
						prescEd = 1;
					}else{
						++prescEd;	
					}
				}
				else {
					$('#gridDecState').datagrid("mergeCells",{
						index: i,
						field: 'patNo',
						rowspan: patEd
					});
					$('#gridDecState').datagrid("mergeCells",{
						index: i,
						field: 'patName',
						rowspan: patEd
					});	
					$('#gridDecState').datagrid("mergeCells",{
						index: i,
						field: 'prescNo',
						rowspan: prescEd
					});
					$('#gridDecState').datagrid("mergeCells",{
						index: i,
						field: 'curState',
						rowspan: prescEd
					});
				}
			}
			
		}
		
	};
	PHA.Grid("gridDecState", dataGridOption);
}

/**
 * 查询table
 * method queryStateInfo
 */
function queryStateInfo() {
	var startDate = $("#startDate").datebox('getValue');
	var endDate = $("#endDate").datebox('getValue');
	var startTime = $('#startTime').timespinner('getValue') || "";
	var endTime = $('#endTime').timespinner('getValue') || "";
	var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
	var decType = $("input[name='busType']:checked").val() || "";
	var curState = $('#cmbprocess').combobox("getValue") || "";
	var prescNo = $.trim($("#txt-prescno").val());
	var patNo = $.trim($("#txt-patno").val());
	var succFlag = $('#chk-success').is(':checked');
	var succFlag = succFlag == true ? "Y" : "N";
	
	var startDateTime = startDate+" "+startTime;
	var endDateTime = endDate +" "+endTime;
	var params = curState +"^"+ prescNo +"^"+ patNo +"^"+ decType +"^"+ succFlag;
	
	$('#gridDecState').datagrid('query', {
		startDateTime: startDateTime,
		endDateTime: endDateTime,
		decLocId: decLocId,
		params: params
	});
}

/**
 * 撤消执行
 * method cancelState
 */
function cancelState() {
	var selectRow = $('#gridDecState').datagrid("getSelected");
	if (selectRow == null){
		PHA.Popover({
			msg: "请先选择需要撤消的执行状态！",
			type: 'alert'
		});	
	}
	var pdpiItmId = selectRow.PDPIItmId;
	
	var ret = $.m({
		ClassName: "PHA.DEC.MGTState.Api",
		MethodName: "CancelExecute",
		pdpiId: pdpiItmId,
		cancelUser: gUserID,
		logonInfo: LogonInfo
	}, false);
	
	if (ret == 0){
		PHA.Popover({msg: "撤消成功!", type: 'success'});
		queryStateInfo();
	}
	else {
		$.messager.alert('提示',"煎药状态撤消失败！原因为："+ret,"info");
		return ;
	}
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
	$('#gridDecState').datagrid('loadData', {
		total: 0,
		rows: []
	});
}
