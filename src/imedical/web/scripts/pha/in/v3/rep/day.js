/**
 * 模块:     日月年报-日报
 * 编写日期: 2022-05-17
 * 编写人:   yangsj
 */
var cmbWidth = '160';
var REPTYPE = 'D'
var SELECTDAY   = ''
$(function () {
    InitDict();				//初始化字典
    InitGrid();				//初始化grid
    BindBtnEvent();
    SetDefault();			//设置默认值
	SetCellEdit();			//设置单元格编辑
	setTimeout(function () { DifPrompt(); }, 500);
});

function SetCellEdit(){
	$('#gridDay').datagrid('enableCellEditing').datagrid('gotoCell', {
		index: 0,
	});
}

function BindBtnEvent(){
	PHA_EVENT.Bind('#btnCreateDayRepByMon', 'click', function(){CreateDayRepByMon();});
	PHA_EVENT.Bind('#btnCreateDayRepByDay', 'click', function(){CreateDayRepByDay();});
	PHA.BindBtnEvent('#gridRepBar');
}

function InitDict(){
	$('.icon-help').popover({
		title: $g('提示'),
		width: '650',
		content: $g('[按选择月生成日报]：按照选择月份的所有日期依次生成日报。')
			+ '<br>'+ $g('[按选择日生成日报]：按照日历中选中的日期生成该日期的日报。')
			+ '<br>'+ $g(' 1.日报由系统任务自动生成，只生成昨日的日报。')
			+ '<br>'+ $g(' 2.首日日报必须由手动生成，如果科室从未日报则任务不会执行。')
			+ '<br>'+ $g(' 3.只有前日日报生成完成并且无差异时，任务才能自动生成昨日日报，否则需手动生成或者差异确认。')
	});

	$('.icon-reload').on('click', function () { QueryDays(); })
	
	
    /* 药房科室  */
    PHA_UX.ComboBox.Loc('locId', {
	    width: cmbWidth,
	    onSelect: function(e,val){
			QueryDays();
	    }
	});
	
	$('#yearMon').phamonthbox({
		width : cmbWidth,
		onSelect: function(val) {
			QueryDays(val);
		}
	});
}

function SetDefault(){
	//科室默认登陆科室
	$('#locId').combobox('setValue', session['LOGON.CTLOCID']);
	
	//初始化月份下拉框
	var myDate=new Date();
	var year = myDate.getFullYear();
	var mon = myDate.getMonth() + 1;
	var yearMon = year + '-' + mon;
	$('#yearMon').phamonthbox('setValue', yearMon);
	
	QueryDays();
}
function SetUpDiagDefault(){
}

function InitGrid(){
	InitGridDay();
	InitGridDayRep();
	REP_COM.INITGRID.InitComGrid();
}

function InitGridDay(){
   var columns = [
        [
        	// Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday
            { field: 'Monday', 		title: '一', align: 'center', width: 50,	styler:REP_COM.FORMATTER.DayStatusStyler,	formatter:REP_COM.FORMATTER.DayFormatter},  //styler:MStateStyler,
            { field: 'Tuesday', 	title: '二', align: 'center', width: 50,	styler:REP_COM.FORMATTER.DayStatusStyler,	formatter:REP_COM.FORMATTER.DayFormatter},
            { field: 'Wednesday', 	title: '三', align: 'center', width: 50,	styler:REP_COM.FORMATTER.DayStatusStyler,	formatter:REP_COM.FORMATTER.DayFormatter},
            { field: 'Thursday', 	title: '四', align: 'center', width: 50,	styler:REP_COM.FORMATTER.DayStatusStyler,	formatter:REP_COM.FORMATTER.DayFormatter},
            { field: 'Friday', 		title: '五', align: 'center', width: 50,	styler:REP_COM.FORMATTER.DayStatusStyler,	formatter:REP_COM.FORMATTER.DayFormatter},
            { field: 'Saturday', 	title: '六', align: 'center', width: 50,	styler:REP_COM.FORMATTER.DayStatusStyler,	formatter:REP_COM.FORMATTER.DayFormatter},
            { field: 'Sunday', 		title: '日', align: 'center', width: 50,	styler:REP_COM.FORMATTER.DayStatusStyler,	formatter:REP_COM.FORMATTER.DayFormatter},
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : 'PHA.IN.REP.Api',
            pMethodName: 'QueryDays',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        gridSave:false,
        columns: columns,
        exportXls: false,
        pagination: false,
        singleSelect:true,
        clickToEdit: true,
        onClickCell: function (index, field, value) {
	        if (value.indexOf('-') >= 0) value = value.split('-')[0]
	        SELECTDAY = value;
			if(value) QueryDayRep(SELECTDAY);
			else(REP_COM.OPERATE.ClearGrid('gridRep'))
		}
    };
    PHA.Grid('gridDay', dataGridOption);
}

function InitGridDayRep(){
   var columns = [
        [
        	// repId,date,useStatus,difStatus
        	{ field: 'repId', 		title: 'repId', 	align: 'center', width: 80 	,hidden:true},
        	{ field: 'repType', 	title: 'repType', 	align: 'center', width: 80 	,hidden:true},
        	{ field: 'date', 		title: '日报日期', 	align: 'center', width: 120 },
            { field: 'useStatus', 	title: '使用状态', 	align: 'center', width: 80 	,styler:REP_COM.FORMATTER.AllStateStyler,	formatter:REP_COM.FORMATTER.AllStateFormatter},
            { field: 'difStatus', 	title: '差异状态', 	align: 'center', width: 80 	,styler:REP_COM.FORMATTER.DifStateStyler,	formatter:REP_COM.FORMATTER.DifStateFormatter},
        ],
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : 'PHA.IN.REP.Api',
            pMethodName: 'QueryDayRep',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        gridSave:false,
        columns: columns,
        toolbar: '#gridRepBar',
        exportXls: false,
        pagination: false,
        onClickRow: function (rowIndex, rowData) {
	        if (rowData) {
                REP_COM.FUNCTION.QueryRepDetail();
                REP_COM.FUNCTION.QueryRepOperate();
            }
        },
        onDblClickRow: function (rowIndex, rowData) {
        }
    };
    PHA.Grid('gridRep', dataGridOption);
}

function onSelect(){
	QueryDays();
}

function QueryDays(yearMon, index, field){
	REP_COM.OPERATE.ClearGridAllDetail();
	
	SELECTDAY = '';
	if(!yearMon){
		var yearMon = $('#yearMon').phamonthbox('getValue') || '';
	}
	if(!yearMon) return;
	var locId = $('#locId').combobox('getValue')
	if(!locId) return;
	
    var pJson = {
	    	yearMon : yearMon,
	    	locId : locId
	    }
	$('#gridDay').datagrid('query', {
		pJson : JSON.stringify(pJson)
    });
    if(index && field){
	     /* 刷新之后需冲洗选中日期 */
		setTimeout(function(){ REP_COM.OPERATE.SelectCell('gridDay', index, field)}, 200)    
    }
}

function QueryDayRep(day){
	REP_COM.OPERATE.ClearGridAllDetail();
	if(!day) return;
	var yearMon = $('#yearMon').phamonthbox('getValue') || '';
	if(!yearMon) return;
	var date = yearMon + '-' +day;
	var locId = $('#locId').combobox('getValue')
	var pJson = {
	    	date  : date,
	    	locId : locId
	    }
	$('#gridRep').datagrid('query', {
        pJson : JSON.stringify(pJson)
    });
}

// 按日期生成日报
function CreateDayRepByDay(){
	var selectCell = $('#gridDay').datagrid('getSelectedCells');
	
	if ((selectCell.length == 0) || (!SELECTDAY)){
		PHA.Msg('alert','请选择一个日期！')
		return;
	}
	var yearMon = $('#yearMon').phamonthbox('getValue') || '';
	if(!yearMon) return;
	var date = yearMon + '-' + SELECTDAY;
	var locId = $('#locId').combobox('getValue'); 
	
    var field = selectCell[0].field
    var index = selectCell[0].index
	
	var	pJson = {
		locId	: locId,
		date 	: date,
		repType : REPTYPE,
		userId 	: session['LOGON.USERID']
	}
	PHA.Loading("Show");
	PHA.CM(
        {
            pClassName : 'PHA.IN.REP.Api',  
            pMethodName: 'CreateDayRepByDay',
            pJson	   : JSON.stringify(pJson),
        },
        function (retData) {
			if (PHA.Ret(retData)) {
				PHA.Loading("Hide");
		        QueryDays("", index, field);
		        QueryDayRep(SELECTDAY);
			}
        }
	)
	PHA.Loading("Hide");
}

// 按月份生成月报
function CreateDayRepByMon(){
	var yearMon = $('#yearMon').phamonthbox('getValue') || '';
	if(!yearMon) {
		PHA.Msg('alert','请选择一个月份！')
		return;
	}
	var locId = $('#locId').combobox('getValue'); 
	
	var	pJson = {
		locId	: locId,
		yearMon : yearMon,
		repType : REPTYPE,
		userId 	: session['LOGON.USERID']
	}
	PHA.Loading("Show");
	var retData = PHA.CM(
        {
            pClassName : 'PHA.IN.REP.Api',  
            pMethodName: 'CreateDayRepByMon',
            pJson	   : JSON.stringify(pJson),
        },
        false
    )
	if (PHA.Ret(retData)) {
	}
	QueryDays();
	PHA.Loading("Hide");
    
}

// 差异确认
function AuditDif(){
	var ret = REP_COM.FUNCTION.AuditDif();
	if (!ret) return;
	QueryDayRep(SELECTDAY);
	UpdateDay();
	REP_COM.FUNCTION.QueryRepOperate();
	/* 差异确认后自动生成本月剩余月报 */
	var yearMon = $('#yearMon').phamonthbox('getValue') || '';
	if(!yearMon) return;
	var date = yearMon + '-' + SELECTDAY;
	var retData = PHA.CM(
		{
			pClassName: 'PHA.IN.REP.Api',
			pMethodName: 'IsMonLastDate',
			pJson: JSON.stringify({ 'date': date }),
		}, false
	);
	if (!retData.isMonLastDate) {
		PHA.Confirm('提示', '是否生成本月剩余日报', function () {
			CreateDayRepByMon();
	    });
	}
}

// 作废
function CancelRep(){
	var ret = REP_COM.FUNCTION.Cancel();
	if (!ret) return;
	QueryDayRep(SELECTDAY);
	UpdateDay();
	REP_COM.FUNCTION.QueryRepOperate();
}

function UpdateDay(){
	var date = GetDate();
	if (!date) return;
	var locId = $('#locId').combobox('getValue')
	var	pJson = {
		locId	: locId,
		date 	: date
	}
	PHA.CM(
        {
            pClassName : 'PHA.IN.REP.Api',  
            pMethodName: 'GetStatusByDate',
            pJson	   : JSON.stringify(pJson),
        },
        function (retData) {
	        UpdateDayStatus(retData);
        }
    )    
}

function UpdateDayStatus(status){
	var selectCell = $('#gridDay').datagrid('getSelectedCells')
    if(selectCell.length == 0) return;
    var field = selectCell[0].field
    var index = selectCell[0].index
    var row = {}
    row[field] = SELECTDAY + '-' + status.data
    $('#gridDay').datagrid('updateRow', {
        index: index,
        row: row
    });	
    REP_COM.OPERATE.SelectCell('gridDay', index, field)
}

function GetDate(){
	var yearMon = $('#yearMon').phamonthbox('getValue') || '';
	if(!yearMon) return '';
	var date = yearMon + '-' + SELECTDAY;
	return date;
}

function Refresh(){
	REP_COM.FUNCTION.QueryRepDetail();
}

/// 检查是否有差异数据，跳转至差异界面
function DifPrompt() {
	var locId = $('#locId').combobox('getValue'); 
	var	pJson = {
		locId	: locId,
	}
	var retData = PHA.CM(
		{
			pClassName: 'PHA.IN.REP.Api',
			pMethodName: 'GetLastDifRep4Day',
			pJson: JSON.stringify(pJson),
		}, false
	);
	if (retData.lastDifDate != "") {
		var lastDifDate = retData.lastDifDate;
		PHA.Msg('info', lastDifDate + ' 日报差异未确认');
		var dateArr = lastDifDate.split('-');
		$('#yearMon').phamonthbox('setValue', dateArr[0] + '-' + dateArr[1]);  
		QueryDays();
	}

}