/**
 * @模块:     查询统计-煎药工作量统计
 * @编写日期: 2019-08-29
 * @编写人:   hulihua
 */
$(function(){
	InitDict();
	InitSetDefVal();
	InitGridWorkLoad(); //初始化表格
})

/**
 * 初始化组件
 * @method InitDict
 */
function InitDict() {
	PHA.ComboBox("cmbDecLoc", {
		editable: false,
		url: PHA_DEC_STORE.DecLoc().url,
	});
	
	PHA.ComboBox("cmbProcess", {
		url: LINK_CSP + '?ClassName=PHA.DEC.Com.Store&MethodName=DecProDict&locId=' + gLocId,
	});
}

/**
 * 给控件赋初始值
 * @method InitSetDefVal
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
		$("#dateStart").datebox("setValue", jsonComData.StatStartDate);
		$("#dateEnd").datebox("setValue", jsonComData.StatEndDate);
		$('#timeStart').timespinner('setValue', "00:00:00");
		$('#timeEnd').timespinner('setValue', "23:59:59");
		$("#cmbDecLoc").combobox("setValue", jsonComData.DefaultDecLoc);
	});
}

/**
 * 初始化批量收方表格
 * @method InitGridWorkLoad
 */
function InitGridWorkLoad() {
	var columns = [
		[ {
				field: 'TUserCode',
				title: '工号',
				align: 'left',
				width: 120
			}, {
				field: 'TUserName',
				title: '姓名',
				align: 'left',
				width: 130
			}, {
				field: 'TPstDesc',
				title: '业务描述',
				align: 'left',
				width: 130
			}, {
				field: 'TPreForm',
				title: '处方剂型',
				align: 'left',
				width: 140
			}, {
				field: 'TOPPreNum',
				title: '门诊处方业务量',
				align: 'left',
				width: 130
			}, {
				field: 'TOPPreFacTor',
				title: ' 门诊付数业务量',
				align: 'left',
				width: 130
			}, {
				field: 'TOPPreCount',
				title: '门诊味数业务量',
				align: 'left',
				width: 130
			}, {
				field: 'TIPPreNum',
				title: '住院处方业务量',
				align: 'left',
				width: 130
			}, {
				field: 'TIPPreFacTor',
				title: '住院付数业务量',
				align: 'left',
				width: 130
			}, {
				field: 'TIPPreCount',
				title: '住院味数业务量',
				align: 'left',
				width: 130
			}, {
				field: 'TUserNum',
				title: 'TUserNum',
				align: 'center',
				width: 10,
				hidden: true  
			}, {
				field: 'TDictNum',
				title: 'TDictNum',
				align: 'center',
				width: 10,
				hidden: true  
			}
		]
	];
	var dataGridOption = {
		rownumbers: true,
		columns: columns,
		pageSize: 50,
		pageList: [50, 100, 200],
		pagination: true,
		toolbar: '#toolBarWorkLoad',
		border: true ,
		singleSelect: false,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.WorkLoad.Query",
			QueryName: "WorkLoad",
		},
		rowStyler: function(rowIndex, rowData){
			if(rowData['TPstDesc'] == "小计"){
				return 'background-color:#F4F6F5;';
			}
			else if(rowData['TUserCode'] == "总计"){
				return 'font-weight:bolder;background-color:#F4F6F5';
			}
		},
		onLoadSuccess: function(data){
			var rows = data.rows;
			var userEd = 1;
			var pstEd = 1;
			var formEd = 1;
			for(var i = (rows.length-1); i >=0 ; i--){
				var row = rows[i];
				if(rows[i-1]){
					if((rows[i-1]['TUserCode'] != row['TUserCode'])&&(row['TUserCode']!="")){
						$('#gridWorkLoad').datagrid("mergeCells",{
							index: i,
							field: 'TUserCode',
							rowspan: userEd
						});
						$('#gridWorkLoad').datagrid("mergeCells",{
							index: i,
							field: 'TUserName',
							rowspan: userEd
						});
						userEd = 1;
					}else{
						++userEd;	
					}
					if(rows[i-1]['TPstDesc'] != row['TPstDesc']){
						$('#gridWorkLoad').datagrid("mergeCells",{
							index: i,
							field: 'TPstDesc',
							rowspan: pstEd
						});
						pstEd = 1;
					}else{
						++pstEd;	
					}
					if(rows[i-1]['TPstDesc'] != row['TPstDesc']){
						$('#gridWorkLoad').datagrid("mergeCells",{
							index: i,
							field: 'TPstDesc',
							rowspan: formEd
						});
						formEd = 1;
					}else{
						++formEd;	
					}
				}
			}
		}
	};
	PHA.Grid("gridWorkLoad", dataGridOption);
}

/**
 * 清屏
 * @method Clear
 */
function Clear() {
	InitSetDefVal();
	$("#cmbProcess").combobox('setValue', "");
	$('#gridWorkLoad').datagrid('clear');
}

/**
 * 查询数据
 * @method Query
 */
function Query() {
	var params = GetParams();
	if (params == "") {
		return;
	}
	$('#gridWorkLoad').datagrid('query', {
		ParamStr: params
	});
}

/**
 * 获取界面元素值
 * @method GetParams
 */
function GetParams() {
	var stDate = $("#dateStart").datebox('getValue');
	var enDate = $("#dateEnd").datebox('getValue');
	var stTime = $('#timeStart').timespinner('getValue');
	var enTime = $('#timeEnd').timespinner('getValue');
	var declocid = $('#cmbDecLoc').combobox("getValue") || "";
	var decPstId = $('#cmbProcess').combobox("getValue") || "";
	var params = stDate + "^" + enDate + "^" + stTime + "^" + enTime + "^" + declocid + "^" +decPstId;
	return params;
}