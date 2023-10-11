/**
 * @模块:     草药处方煎药条打印统计
 * @编写日期: 2022-10-28
 * @编写人:   MaYuqiang
 */
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var PHA_HERB_QUERY_DECLABEL = {
    Pid: tkMakeServerCall('PHA.COM.Base', 'NewPid')
};
PHAHERB_COM.KillTmpOnUnLoad('PHA.HERB.Query.DECLabel', PHA_HERB_QUERY_DECLABEL.Pid);
$(function () {
	InitDict();
	InitGridPrescList();
	$('#btnFind').on('click', QueryHandler);
	/*
	$('#btnPrintLabel').on('click', 
		PrintDECLabel("")
	);
	*/
	$('#btnPrintList').on('click', PrintHandler);
	//$('#btnClearScreen').on('click', Clear);
	
	$('#conPrescNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
	        QueryHandler();
	        PrintDECLabel($(this).val());
        }
    });
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	
});

function InitDict() {
    var combWidth = 160;
    $('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
    // 就诊类型
    PHA.ComboBox('conAdmType', {
        width: combWidth,
        data: [
            { RowId: 'O', Description: '门诊' },
            { RowId: 'I', Description: '住院' }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
	});
	$('#conAdmType').combobox('setValue', 'I');
	// 打印状态
    PHA.ComboBox('conPrintState', {
        width: combWidth,
        data: [
        	{ RowId: '0', Description: '全部' },
            { RowId: '1', Description: '已打印' },
            { RowId: '2', Description: '未打印' }
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
 * 初始化处方列表
 * @method InitGridPrescList
 */
function InitGridPrescList() {
	var columns = [
		[	{
				field: 'TPhaLocDesc',
				title: '执行科室',
				align: 'left',
				width: 130
			},{
				field: 'TWardDesc',
				title: '护理单元',
				align: 'left',
				width: 150
			},{
				field: 'TDocLocDesc',
				title: '开单科室',
				align: 'left',
				width: 150
			}, {
				field: 'TPatNo',
				title: '登记号',
				align: 'left',
				width: 100
			}, {
				field: 'TMRNo',
				title: '病案号',
				align: 'left',
				width: 100
			}, {
				field: 'TBedNo',
				title: '床号',
				align: 'left',
				width: 80
			}, {
				field: 'TPrescNo',
				title: '处方号',
				align: 'left',
				width: 130
			}, {
				field: 'TPatName',
				title: '姓名',
				align: 'left',
				width: 70
			}, {
				field: 'TDurDesc',
				title: '剂数',
				align: 'left',
				width: 70
			}, {
				field: 'TDaliyPackQty',
				title: '每份剂数',
				align: 'left',
				width: 70
			}, {
				field: 'TSinglePack',
				title: '另包药',
				align: 'left',
				width: 70
			}, {
				field: 'TInstruc',
				title: '用法',
				align: 'left',
				width: 70
			}, {
				field: 'TOrdDateTime',
				title: '开单日期',
				align: 'left',
				width: 160
			}, {
				field: 'TPrescProp',
				title: '处方属性',
				align: 'left',
				width: 80
			}, {
				field: 'TPrintSign',
				title: '打印状态',
				align: 'left',
				width: 80
			}, {
				field: 'TSign',
				title: '签名',
				align: 'left',
				width: 70
			}, {
				field: 'TPhbdId',
				title: 'TPhbdId',
				align: 'left',
				width: 80,				
				hidden: true
			}
		]
	];
	var dataGridOption = {
		 url: '',
        columns: columns,
        fitColumns: true,
        showFooter: true,
        toolbar: [],
        pageNumber: 1,
        pageSize: 100,
		loadFilter: PHAHERB_COM.LocalFilter,
		onLoadSuccess: function () {
            $(this).datagrid('loaded');
        }
	};
	PHA.Grid("gridPrescList", dataGridOption);
}


/**
 * 查询数据
 * @method QueryHandler
 */
function QueryHandler() {
    $('#gridPrescList').datagrid('loading');
    setTimeout(Query, 100);
}

function Query() {
    var pJson = GetQueryParamsJson();
    var ret = $.cm(
        {
            ClassName: 'PHA.HERB.Query.DECLabel',
            MethodName: 'Collect',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_HERB_QUERY_DECLABEL.Pid,
            dataType: 'text'
        },
        false
    );
    //var sort = $('#gridPrescList').datagrid('options').sortName;
    //var order = $('#gridInci').datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.HERB.Query.DECLabel',
            QueryName: 'QueryDECLabel',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_HERB_QUERY_DECLABEL.Pid,
            rows: 9999,
            page: 1
        },
        false
    );

    $('#gridPrescList').datagrid('loadData', rowsData);
    $('#conPrescNo').val('');	
}

/**
 * 查询条件的JSON
 * @method GetQueryParamsJson
 */
function GetQueryParamsJson() {
	var admType = $('#conAdmType').combobox('getValue') || '';
	if (admType == ""){
		$.messager.alert('提示',"就诊类型不能为空!","info");
        return;	
	}
    return {
        startDate: $("#conStartDate").datebox('getValue'),
        endDate: $("#conEndDate").datebox('getValue'),
        startTime: $('#conStartTime').timespinner('getValue'),
        endTime: $('#conEndTime').timespinner('getValue'),
		phaLocId: gLocId,
		admType: admType,
		prescNo: $('#conPrescNo').val(),
		printSate: $('#conPrintState').combobox('getValue') || '',
		docLocId: $('#conDocLoc').combobox('getValue') || '',
    };
}

/* 打印煎药小条 */
function PrintDECLabel(prescNo)
{
	if (prescNo == ""){
		var gridSelect = $("#gridPrescList").datagrid("getSelected");
		if (gridSelect !== null){
			var prescNo = gridSelect.TPrescNo ;
		}
	}
	if (prescNo == ""){
		$.messager.alert('提示',"请先选中需要打印的处方!","info");
		return;
	}	
	HERB_PRINTCOM.DECLabel(prescNo);
	return ;
}


// 导出煎药打印信息
function PrintHandler() 
{
	//PHA_COM.ExportGrid("gridPrescList");
	if ($('#gridPrescList').datagrid('getData').rows.length === 0) {
        PHA.Popover({
            msg: '没有数据',
            type: 'alert'
        });
        return;
    }
    var printTitle = "成都中医药大学附属医院·四川省中医院"; 
    var para = {
	    printTitle: printTitle + "煎药病人签收表",
        countDate: $('#conStartDate').datebox('getValue') + '至' + $('#conEndDate').datebox('getValue'),
        printUserName: session['LOGON.USERNAME']
    };

    var list = $('#gridPrescList').datagrid('getData').originalRows;

    PRINTCOM.XML({
        printBy: 'lodop',
        XMLTemplate: 'PHAHERB_DECLabelList',
        data: {
            Para: para,
            List: list
        },
        preview: false,
        listBorder: { style: 4, startX: 1, endX: 275 },
        page: { rows: 15, x: 245, y: 2, fontname: '黑体', fontbold: 'true', fontsize: '12', format: '页码：{1}/{2}' }
    });
    return ;
}

/*
 * 清屏
 * @method Clear
 */
function Clear() {
	$('#gridPrescList').datagrid('clear');
	$('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
	$('#conPrescNo').val("");
	return ;
}

//载入数据
/*
window.onload=function(){
	setTimeout("QueryHandler()",500);
}
*/

