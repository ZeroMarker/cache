/**
 * @模块:     草药处方煎药费查询
 * @编写日期: 2021-01-11
 * @编写人:   MaYuqiang
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var ComPropData		// 公共配置
var AppPropData		// 模块配置
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	PHA_COM.SetPanel('#pha_herb_v2_queryfeestat', $('#pha_herb_v2_queryfeestat').panel('options').title);
	InitDict();
	InitGridFee();
	InitSetDefVal();
	//登记号回车事件
	$('#conPatNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#conPatNo").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				queryLocFeeList();
			}	
		}
	});
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
        url: PHA_HERB_STORE.DocLoc().url,
        width: combWidth
	});
	// 煎药费
	PHA.ComboBox("conCookFeeItem", {
		multiple: false,
		url: PHA_HERB_STORE.CookFeeItem(gLocId).url
	});
	// 领药病区
    PHA.ComboBox('conWardLoc', {
        url: PHA_STORE.WardLoc().url,
        width: combWidth
	});
	// 处方费别
    PHA.ComboBox('conBillType', {
        width: combWidth,
        url: PHA_STORE.PACAdmReason(gHospId).url
    });
}

/**
 * 初始化煎药费表格
 * @method InitGridFee
 */
function InitGridFee() {
	var columns = [[ 
		{
			field: 'TDeptLoc',	
			title: '开单科室/病区',	
			align: 'left', 
			width: 300
		},
		{
			field: 'TFeeItem',		
			title: '项目',		
			align: 'left', 
			width: 200
		},
		{
			field: 'TOutAmt',	
			title: '门急诊金额',
			align: 'right', 
			width: 150
		},
		{
			field: 'TInAmt',
			title: '住院金额', 	
			align: 'right', 
			width: 150
		},
		{
			field: 'TTotalAmt', 	
			title: '合计金额', 	
			align: 'right', 
			width: 150
		},
		{
			field: 'TFeeNum', 	
			title: 'TFeeNum', 	
			align: 'left', 
			hidden: true
		}
	]];
	var dataGridOption = {
		fit: true,
		singleSelect: true,
		columns: columns,
		toolbar: '#toolBarFee',
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Query.FeeStat",
			QueryName: "QueryCookFee",
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
					$('#gridFee').datagrid("mergeCells",{
						index: (i - rowNum + 1),
						field: 'deptLoc',
						rowspan: rowNum,
						colspan: 0
					});	
				}
			}
		}
	};
	PHA.Grid("gridFee", dataGridOption);
}
/**
 * 查询煎药费数据
 * @method queryPrtLabList
 */
function queryLocFeeList(){
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridFee').datagrid('query', {
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
		admType: $('#conAdmType').combobox('getValue') || '',
		wardLocId: $('#conWardLoc').combobox('getValue') || '',
		prescNo: $('#conPrescNo').val(),
		docLocId: $('#conDocLoc').combobox('getValue') || '',
		feeItem: $('#conCookFeeItem').combobox('getValue') || '',
		billType: $('#conBillType').combobox('getValue') || '' ,
		patNo: $('#conPatNo').val()

    };
}

/*
 * 清屏
 * @method Clear
 */
function Clear() {
	InitSetDefVal();
	$('#conPhaLoc').combobox('select', gLocId);
    $('#conAdmType').combobox('clear');
	$('#conWardLoc').combobox('clear');
	$('#conPrescNo').val('');
	$('#conDocLoc').combobox('clear');
	$('#conCookFeeItem').combobox('clear');
	$('#conBillType').combobox('clear');
	$('#conPatNo').val('')
	$('#gridFee').datagrid('clear');
	
}
