/**
 * @模块:     草药房工作量查询
 * @编写日期: 2021-08-09
 * @编写人:   MaYuqiang
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var ComPropData		// 公共配置
var AppPropData		// 模块配置
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	PHA_COM.SetPanel('#pha_herb_v2_queryworkload', $('#pha_herb_v2_queryworkload').panel('options').title);
	InitDict();
	InitGridWorkLoad();
	InitSetDefVal();
});

/**
 * 给控件赋初始值
 * @method InitSetDefVal
 */
 function InitSetDefVal() {
	//界面配置
	// 公共设置
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
		}, false)

    $("#conStartDate").datebox("setValue", ComPropData.QueryStartDate);
    $("#conEndDate").datebox("setValue", ComPropData.QueryEndDate);
	$('#conStartTime').timespinner('setValue', ComPropData.QueryStartTime);
	$('#conEndTime').timespinner('setValue', ComPropData.QueryEndTime);
	
}

/**
 * 初始化组件
 * @method InitDict
 */
function InitDict(){
	var combWidth = 160;
	$('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
    $('#conStartTime').timespinner('setValue', '00:00:00');
    $('#conEndTime').timespinner('setValue', '23:59:59');
    // 发药科室
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('').url,
		panelHeight: 'auto',
		width: combWidth,
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', gLocId);
        }
    });
    // 就诊类型
    PHA.ComboBox('conAdmType', {
        width: combWidth,
        data: [
            { RowId: 'O,E', Description: $g('门急诊') },
            { RowId: 'I', Description: $g('住院') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
	});
	// 开单科室
    PHA.ComboBox('conDocLoc', {
        url: PHA_STORE.DocLoc().url,
        width: combWidth
	});
	// 业务类型
    PHA.ComboBox('conBusType', {
        width: combWidth,
        data: [
            { RowId: 'DISP', Description: $g('发药') },
            { RowId: 'RETURN', Description: $g('退药') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
	});
	// 药师类型
    PHA.ComboBox('conUserType', {
        width: combWidth,
        data: [
            { RowId: 'Disp', Description: $g('配药药师') },
            { RowId: 'Check', Description: $g('核对药师') },
            { RowId: 'FY', Description: $g('发药药师') }
        ],
        panelHeight: 'auto',
		onLoadSuccess: function(){
			$('#conUserType').combobox('select', 'Disp');
		},
        onSelect: function () {
			//queryWorkLoad();
		}
	});
}

/**
 * 初始化工作量表格
 * @method InitGridWorkLoad
 */
function InitGridWorkLoad() {
	var columns = [[ 
		{
			field: 'TUserId',	
			title: '药师Id',	
			align: 'left', 
			width: 100,
			hidden: true
		},{
			field: 'TUserName',	
			title: '药师姓名',	
			align: 'left', 
			width: 150
		},{
			field: 'TUserCode',	
			title: '药师工号',	
			align: 'left', 
			width: 150
		},
		{
			field: 'TPrescQty',	
			title: '处方数',
			align: 'right', 
			width: 150
		},
		{
			field: 'TPrescAmt',	
			title: '金额',
			align: 'right', 
			width: 150
		},
		{
			field: 'TPrescFactor',
			title: '付数', 	
			align: 'right', 
			width: 150
		},
		{
			field: 'TPrescDrugKind', 	
			title: '味数', 	
			align: 'right', 
			hidden: false ,
			width: 150
		}
	]];
	var dataGridOption = {
		fit: true,
		singleSelect: true,
		columns: columns,
		toolbar: '#toolBarWorkLoad',
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Query.WorkLoad",
			QueryName: "QueryWorkLoad",
		},
		rownumbers: true,
		rowStyler: function(rowIndex, rowData){
			if(rowData['TUserName'] == $g("小计")){
				return 'color:blue;';
			}
			if(rowData['TUserName'] == $g("合计")){
				return 'color:red;';
			}
			if(rowData['TUserName'] == $g("总计")){
				return 'color:red;';
			}
		},
		onLoadSuccess: function(data){
			var rows = data.rows;
			for(var i = 0; i < rows.length; i++){
				var row = rows[i];
				var rowNum = row['typeNum'];
				if(rowNum != ""){
					$('#gridWorkLoad').datagrid("mergeCells",{
						index: (i - rowNum + 1),
						field: 'deptLoc',
						rowspan: rowNum,
						colspan: 0
					});	
				}
			}
		}
	};
	PHA.Grid("gridWorkLoad", dataGridOption);
}
/**
 * 查询草药房工作量
 * @method queryPrtLabList
 */
function queryWorkLoad(){
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridWorkLoad').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});
}

/**
 * 查询条件的JSON
 * @method GetQueryParamsJson
 */
function GetQueryParamsJson() {
	var userType = $('#conUserType').combobox('getValue') || '';
	if (userType == ''){
		$.messager.alert('提示',"药师类型不能为空！","info");
		return;
	}
    return {
        startDate: $("#conStartDate").datebox('getValue'),
        endDate: $("#conEndDate").datebox('getValue'),
        startTime: $('#conStartTime').timespinner('getValue'),
        endTime: $('#conEndTime').timespinner('getValue'),
		phaLocId: $('#conPhaLoc').combobox('getValue') || '',
		docLocId: $('#conDocLoc').combobox('getValue') || '',
		admType: $('#conAdmType').combobox('getValue') || '',
		busType: $('#conBusType').combobox('getValue') || '',
		userType: userType
    };
}

/*
 * 清屏
 * @method Clear
 */
function Clear() {
	$('#gridWorkLoad').datagrid('clear');
	$('#conPhaLoc').combobox('select', gLocId);
    $('#conAdmType').combobox('clear');
	$('#conDocLoc').combobox('clear');
	$('#conBusType').combobox('clear');
	InitSetDefVal();
	$('#conUserType').combobox('select', 'Disp');
}
