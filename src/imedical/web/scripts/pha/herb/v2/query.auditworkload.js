/**
 * @模块:     草药房处方审核工作量查询
 * @编写日期: 2022-03-02
 * @编写人:   MaYuqiang
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var ComPropData		// 公共配置
var AppPropData		// 模块配置
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
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
}

/**
 * 初始化工作量表格
 * @method InitGridWorkLoad
 */
function InitGridWorkLoad() {
	var columns = [[ 
		{
			field: 'TUserId',	
			title: '审核药师Id',	
			align: 'right', 
			width: 100,
			hidden: true
		},{
			field: 'TUserName',	
			title: '审核药师',	
			align: 'right', 
			width: 150
		},{
			field: 'TAuditNum',	
			title: '审核数量',	
			align: 'right', 
			width: 150
		},
		{
			field: 'TPassNum',		
			title: '通过数量',		
			align: 'right', 
			width: 150
		},
		{
			field: 'TFailNum',	
			title: '不通过数量',
			align: 'right', 
			width: 150
		},
		{
			field: 'TAcceptNum',	
			title: '医生接受数量',
			align: 'right', 
			width: 150
		},
		{
			field: 'TAppealNum',
			title: '医生申诉成功数量', 	
			align: 'right', 
			width: 150
		}
	]];
	var dataGridOption = {
		fit: true,
		singleSelect: true,
		columns: columns,
		toolbar: '#toolBarAuditWorkLoad',
		border: true,
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Query.WorkLoad",
			QueryName: "QueryAuditWorkLoad",
		},
		rownumbers: true,
		rowStyler: function(rowIndex, rowData){
			if(rowData['TUserName'] == $g("合计")){
				return 'color:red;';
			}
			
		},
		onLoadSuccess: function(data){
			
		}
	};
	PHA.Grid("gridAuditWorkLoad", dataGridOption);
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
	$('#gridAuditWorkLoad').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});
}

/**
 * 查询条件的JSON
 * @method GetQueryParamsJson
 */
function GetQueryParamsJson() {
    return {
        startDate: $("#conStartDate").datebox('getValue'),
        endDate: $("#conEndDate").datebox('getValue'),
        startTime: $('#conStartTime').timespinner('getValue'),
        endTime: $('#conEndTime').timespinner('getValue'),
		phaLocId: $('#conPhaLoc').combobox('getValue') || '',
		docLocId: $('#conDocLoc').combobox('getValue') || '',
		admType: $('#conAdmType').combobox('getValue') || '',
    };
}

/*
 * 清屏
 * @method Clear
 */
function Clear() {
	$('#gridAuditWorkLoad').datagrid('clear');
	InitSetDefVal();
	$('#conPhaLoc').combobox('select', gLocId);
    $('#conAdmType').combobox('clear');
	$('#conDocLoc').combobox('clear');
}
