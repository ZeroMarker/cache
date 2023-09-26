/**
 * @模块:     煎药查询-煎药费查询
 * @编写日期: 2019-08-29
 * @编写人:   pushuangcai
 */
$(function () {
	InitDict();
	InitGridDecFee();
	SetDefVal();
});
/**
 * 初始化组件
 * @method InitDict
 */
function InitDict(){
	PHA.ComboBox("cmbDecLoc", {
		url: PHA_DEC_STORE.DecLoc().url,
	});
	PHA.ComboBox("cmbPhaLoc", {
		url: PHA_DEC_STORE.Pharmacy("").url
	});
	PHA.ComboBox("cmbDocLoc", {
		url: PHA_DEC_STORE.DocLoc().url
	});
	PHA.ComboBox("cmbCookFeeItem", {
		multiple: true,
		url: PHA_DEC_STORE.CookFeeItem().url
	});
}
/**
 * 设置默认值
 * @method SetDefVal
 */
function SetDefVal(){
	$.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, function(AppPropData){
			$("#cmbDecLoc").combobox("setValue", AppPropData.DefaultDecLoc);
			$("#dateStart").datebox("setValue", AppPropData.StatStartDate);
			$("#dateEnd").datebox("setValue", AppPropData.StatEndDate);
			$("#cmbPhaLoc").combobox("setValue", AppPropData.DefaultPhaLoc);
			$('#timeStart').timespinner('setValue',"00:00:00");
			$('#timeEnd').timespinner('setValue',"23:59:59");
			$('#cmbDocLoc').combobox("setValue","");
			$('#cmbCookFeeItem').combobox("clear");
			//$(":radio[name='statFlag'][value="+ "DQ" +"]").iCheck('check'); 
			$HUI.radio("input[value='DQ']").check();
		});
	$('#gridDecFee').datagrid('clear');	
}

/**
 * 初始化煎药费表格
 * @method InitGridDecFee
 */
function InitGridDecFee() {
	var columns = [[ 
		{field: 'deptLoc',	title: '开单科室',	align: 'left', width: 100},
		{field: 'item',		title: '项目',		align: 'left', width: 120},
		{field: 'outAmt',	title: '门急诊金额',align: 'right', width: 100},
		{field: 'inAmt', 	title: '住院金额', 	align: 'right', width: 100},
		{field: 'total', 	title: '合计金额', 	align: 'right', width: 100},
		{field: 'typeNum', 	title: 'typeNum', 	align: 'left', hidden: true}
	]];
	var dataGridOption = {
		fit: true,
		singleSelect: true,
		columns: columns,
		toolbar: '#toolBarDecFee',
		border: true,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.DecFee.Query",
			QueryName: "QueryDecFee",
		},
		rownumbers: true,
		rowStyler: function(rowIndex, rowData){
			if(rowData['item'] == "小计"){
				return 'color:red;';
			}
		},
		onLoadSuccess: function(data){
			var rows = data.rows;
			for(var i = 0; i < rows.length; i++){
				var row = rows[i];
				var rowNum = row['typeNum'];
				if(rowNum != ""){
					$('#gridDecFee').datagrid("mergeCells",{
						index: (i - rowNum + 1),
						field: 'deptLoc',
						rowspan: rowNum,
						colspan: 0
					});	
				}
			}
		}
	};
	PHA.Grid("gridDecFee", dataGridOption);
}
/**
 * 查询煎药费数据
 * @method queryPrtLabList
 */
function queryLocFeeList(){
	var inputStr = getParams();
	if(!inputStr) return;
	$('#gridDecFee').datagrid('query', {
		inputStr: inputStr
	});
}
/**
 * 获取界面元素值
 * @method getParams
 */
function getParams(){
	var stDate = $("#dateStart").datebox('getValue');
	if(stDate==""){
		PHA.Popover({showType: "show", msg: "请选择开始时间！", type: 'alert'});
		return null;
	}
	var enDate = $("#dateEnd").datebox('getValue');
	if(enDate==""){
		PHA.Popover({showType: "show", msg: "请选择截止时间！", type: 'alert'});
		return null;
	}
	var stTime = $('#timeStart').timespinner('getValue')||"";
	var enTime = $('#timeEnd').timespinner('getValue')||"";
	var locId = $('#cmbDecLoc').combobox("getValue")||"";
	if(locId==""){
		PHA.Popover({showType: "show", msg: "请选择煎药室！", type: 'alert'});
		return null;
	}
	var phaLocId = $('#cmbPhaLoc').combobox("getValue")||"";
	var docLocId = $('#cmbDocLoc').combobox("getText")||"";
	var statFlag = $("input[name='statFlag']:checked").val() || "";
	var feeItem = $('#cmbCookFeeItem').combobox("getText")||"";
	var params = stDate +"^"+ enDate +"^"+ stTime +"^"+ enTime +"^"+ locId;
		params += "^"+ phaLocId +"^"+ docLocId +"^"+ statFlag +"^"+ feeItem;
	return params;
}
