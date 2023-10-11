/**
 * 模块:     日月年报-月报
 * 编写日期: 2022-05-19
 * 编写人:   yangsj
 */

var REPTYPE = 'M';
var SelectMon   = ""
$(function () {
    InitDict();				//初始化字典
    InitGrid();				//初始化grid
    BindBtnEvent();
    SetDefault();			//设置默认值
});

function BindBtnEvent(){
	PHA_EVENT.Bind('#btnCreateMonRep', 'click', function(){CreateMonRep();});
	PHA.BindBtnEvent('#gridRepBar');
}

function InitDict(){
	$(".icon-help").popover({title:'提示',width:"400",content:"月报由日报产生，请保证日报数据正确再生成月报。"});
	
	/* 药房科室  */
    PHA_UX.ComboBox.Loc('locId', {
	    width: 140,
	    onSelect: function(e,val){
			QueryMons();
	    }
	});
}

function SetDefault(){
	//科室默认登陆科室
	$('#locId').combobox('setValue', session['LOGON.CTLOCID']);
	
	//初始化年份份下拉框
	var myDate=new Date();
	var year = myDate.getFullYear();
	$('#year').val(year) ;
	QueryMons();
}

function InitGrid(){
	InitGridMon();
	InitGridMonRep();
	REP_COM.INITGRID.InitComGrid();
}

function InitGridMon(){
   var columns = [
        [
        	// mon,State,Wednesday,Thursday,Friday,Saturday,Sunday
            { field: 'mon', 		title: '月份', align: 'center', width: 90,	},  
            { field: 'status', 		title: '状态', align: 'center', width: 100,	styler:REP_COM.FORMATTER.AllStateStyler,	formatter:REP_COM.FORMATTER.AllStateFormatter}
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : 'PHA.IN.REP.Api',
            pMethodName: 'QueryMons',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        idField: 'mon',
        gridSave:false,
        columns: columns,
        toolbar: '#gridMonBar',
        exportXls: false,
        pagination: false,
        onClickRow: function (rowIndex, rowData) {
	        var mon = rowData.mon
	        var status = rowData.status
	        if(mon){
				QueryMonRep();
				SetDate(mon, status);
			}
			
		},
        onDblClickRow: function (rowIndex, rowData) {},
        onClickCell: function (index, field, value) {},
    };
    PHA.Grid('gridMon', dataGridOption);
}

function InitGridMonRep(){
   var columns = [
        [
        	// SMRID,YearMon,UseState,DifState,FrDate,ToDate
        	{ field: 'repId', 		title: 'repId', 	align: 'center', width: 80 	,hidden:true},
        	{ field: 'repType', 	title: 'repType', 	align: 'center', width: 80 	,hidden:true},
        	{ field: 'yearMon', 	title: '月报月份', 	align: 'center', width: 80 	},
            { field: 'useStatus', 	title: '使用状态', 	align: 'center', width: 80 	,styler:REP_COM.FORMATTER.AllStateStyler,	formatter:REP_COM.FORMATTER.AllStateFormatter},
            { field: 'difStatus', 	title: '差异状态', 	align: 'center', width: 70 	,styler:REP_COM.FORMATTER.DifStateStyler,	formatter:REP_COM.FORMATTER.DifStateFormatter},
            { field: 'startDate', 	title: '开始日', 	align: 'center', width: 100 },
            { field: 'endDate', 	title: '结束日', 	align: 'center', width: 100 },
        ],
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : 'PHA.IN.REP.Api',
            pMethodName: 'QueryMonRep',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        gridSave:false,
        columns: columns,
        fitColumns: true,
        toolbar: '#gridRepBar',
        exportXls: false,
        pagination: false,
        onClickRow: function (rowIndex, rowData) {
	        if (rowData) {
		        var SMRID = rowData.SMRID
                REP_COM.FUNCTION.QueryRepDetail();
                REP_COM.FUNCTION.QueryRepOperate();
            }
        },
        onDblClickRow: function (rowIndex, rowData) {
        },
    };
    PHA.Grid('gridRep', dataGridOption);
}

function onSelect(){
	QueryMons();
}

function QueryMons(){
	REP_COM.OPERATE.ClearGridAllDetail();
	var year = $('#year').val() || '';
	
	var dataJson = PHA.DomData('#gridMonBar', {
        doType: 'query',
        retType: 'Json'
    });
	var pJson = dataJson[0];
	
	$('#gridMon').datagrid('query', {
        pJson : JSON.stringify(pJson)
    });
}

function QueryMonRep(){
	REP_COM.OPERATE.ClearGridAllDetail();
	var mon = GetMon();
    if (!mon) {
		PHA.Msg("alert","请选择一个月份！")
		return;
	}
	var year = $('#year').val() || '';
	var locId = $('#locId').combobox('getValue')
   	var pJson = {
	   	year  : year,
    	mon   : mon,
    	locId : locId
    }
	$('#gridRep').datagrid('query', {
        pJson : JSON.stringify(pJson)
    });
}

function GetMon(){
	var gridSelect = $('#gridMon').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.mon;
    return "";
}

function CreateMonRep(){
	var year = $('#year').val();
	if (!year){
		PHA.Msg("alert","请选择一个年份！")
		return;
	}
	var gridSelect = $('#gridMon').datagrid('getSelected') || '';
    var mon = '';
    if (gridSelect) mon = gridSelect.mon;
    if (!mon){
		PHA.Msg("alert","请选择一个月份！")
		return;
	}
	var locId = $('#locId').combobox('getValue'); 
	if (!locId){
		PHA.Msg("alert", "请选择一个科室！")
		return;
	}
	var startDate = $('#startDate').datebox('getValue') || '';
	var endDate = $('#endDate').datebox('getValue') || '';
	if(!startDate||!endDate){
		PHA.Msg("alert","开始或结束日不能为空！")
		return;
	}
	var	pJson = {
		repType   : REPTYPE,
		locId	  : locId,
		year 	  : year,
		mon 	  : mon,
		userId 	  : session['LOGON.USERID'],
		startDate : startDate,
		endDate   : endDate
	}
	PHA.CM(
        {
            pClassName : 'PHA.IN.REP.Api',  
            pMethodName: 'CreateMonRep',
            pJson	   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
		        QueryMons();
			}
        }
    )
}

// 差异确认
function AuditDif(){
	var ret = REP_COM.FUNCTION.AuditDif();
	if (!ret) return;
	QueryMonRep();
    QueryMons();
    REP_COM.FUNCTION.QueryRepOperate();
}

function CancelRep(){
	var ret = REP_COM.FUNCTION.Cancel();
	if (!ret) return;
	QueryMonRep();
    QueryMons();
    REP_COM.FUNCTION.QueryRepOperate();
}

/// 上个月
function YearDown(){
	YearMove(-1)
}

/// 下个月
function YearUp(){
	YearMove(1)
}

function YearMove(num){
	var year = $('#year').val() || '';
	if(!year) {
		//初始化月份下拉框
		var myDate=new Date();
		var year = myDate.getFullYear();
		num = 0
	}
	year = parseInt(year)
	year = year + num
	$('#year').val(year);
	QueryMons();
}

function SetDate(mon,State){
	var year = $('#year').val() || '';
	var locId = $('#locId').combobox('getValue')
	var	pJson = {
		locId : locId,
		year  : year,
		mon   : mon
	}
	PHA.CM(
        {
            pClassName : 'PHA.IN.REP.Api',  
            pMethodName: 'GetMonDateAndStatus',
            pJson	   : JSON.stringify(pJson),
        },
        function (retData) {
	        if(retData.msg != ''){
	            $('#startDate').datebox("clear")
	            $('#endDate').datebox("clear")
	            $('#startDate').datebox('disable')
				$('#endDate').datebox('disable')
            }
            else{
	            $('#endDate').datebox('enable')
	            $('#startDate').datebox('setValue',retData.startDate);
	            $('#endDate').datebox('setValue',retData.endDate);
	            if(retData.lastRepId != "") $('#startDate').datebox('disable')
	            else $('#startDate').datebox('enable')
            }
        }
    )
}

function Refresh(){
	REP_COM.FUNCTION.QueryRepDetail();
}