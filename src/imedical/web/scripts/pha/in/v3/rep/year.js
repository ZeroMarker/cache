/**
 * 模块:     日月年报-年报
 * 编写日期: 2022-05-23
 * 编写人:   yangsj
 */

var REPTYPE = 'Y';

$(function () {
    InitDict();				//初始化字典
    InitGrid();				//初始化grid
    BindBtnEvent();
    SetDefault();			//设置默认值
});

function BindBtnEvent(){
	PHA_EVENT.Bind('#btnCreateYearRep', 'click', function(){CreateYearRep();});
	PHA.BindBtnEvent('#gridRepBar');
}

function InitDict(){
	$(".icon-help").popover({title:'提示',width:"400",content:"年报由月报产生,请保证月报数据正确再生成年报"});
	
	/* 药房科室  */
    PHA_UX.ComboBox.Loc('locId', {
	    width: 140,
	    onSelect: function(e,val){
			QueryYears();
	    }
	});
	
	/* 开始月 */
	$('#startYearMon').phamonthbox({
		width : 125
	});
	
	/* 结束月 */
	$('#endYearMon').phamonthbox({
		width : 125
	});
}

function SetDefault(){
	//科室默认登陆科室
	$('#locId').combobox('setValue', session['LOGON.CTLOCID']);
	
	//初始化年份份下拉框
	var myDate=new Date();
	var year = myDate.getFullYear();
	$('#year').val(year) ;
	QueryYears();
}

function InitGrid(){
	InitGridYear();
	InitGridYearRep();
	REP_COM.INITGRID.InitComGrid();
}

function InitGridYear(){
   var columns = [
        [
        	// mon,State,Wednesday,Thursday,Friday,Saturday,Sunday
            { field: 'year', 		title: '年份', align: 'center', width: 90,	},  
            { field: 'status', 		title: '状态', align: 'center', width: 100,	styler:REP_COM.FORMATTER.AllStateStyler,	formatter:REP_COM.FORMATTER.AllStateFormatter}
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : 'PHA.IN.REP.Api',
            pMethodName: 'QueryYears',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        idField: 'year',
        gridSave:false,
        columns: columns,
        toolbar: '#gridYearBar',
        exportXls: false,
        pagination: false,
        onClickRow: function (rowIndex, rowData) {
	        var year = rowData.year
	        var status = rowData.status
	        if(year){
				QueryYearRep();
				SetMon(year);
			}
		},
        onDblClickRow: function (rowIndex, rowData) {},
        onClickCell: function (index, field, value) {},
        onLoadSuccess: function (data){
	        var gridData = $('#gridYear').datagrid('getData');
	        if (gridData) {
		        var len = gridData.rows.length
		        if (len){
			        var year = $('#year').val() || '';
			        if (year) {
				        year = parseInt(year);
				        var yearRowId = year%10
				        $('#gridYear').datagrid('selectRow', yearRowId);
			        }
		        }
	        }
        }
    };
    PHA.Grid('gridYear', dataGridOption);
}

function InitGridYearRep(){
   var columns = [
        [
        	// repId,YearMon,UseState,DifState,FrDate,ToDate
        	{ field: 'repId', 			title: 'repId', 	align: 'center', width: 80 	,hidden:true},
        	{ field: 'repType', 		title: 'repType', 	align: 'center', width: 80 	,hidden:true},
        	{ field: 'year', 			title: '年报年份', 	align: 'center', width: 80 	},
            { field: 'useStatus', 		title: '使用状态', 	align: 'center', width: 80 	,styler:REP_COM.FORMATTER.AllStateStyler,	formatter:REP_COM.FORMATTER.AllStateFormatter},
            { field: 'difStatus', 		title: '差异状态', 	align: 'center', width: 70 	,styler:REP_COM.FORMATTER.DifStateStyler,	formatter:REP_COM.FORMATTER.DifStateFormatter},
            { field: 'startYearMon', 	title: '开始月', 	align: 'center', width: 100 },
            { field: 'endYearMon', 		title: '结束月', 	align: 'center', width: 100 },
        ],
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : 'PHA.IN.REP.Api',
            pMethodName: 'QueryYearRep',
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
		        var repId = rowData.repId
                REP_COM.FUNCTION.QueryRepDetail();
                REP_COM.FUNCTION.QueryRepOperate();
            }
        },
        onDblClickRow: function (rowIndex, rowData) {
        }
    };
    PHA.Grid('gridRep', dataGridOption);
}

function QueryYears(){
	var year = $('#year').val() || '';
	
	var dataJson = PHA.DomData('#gridYearBar', {
        doType: 'query',
        retType: 'Json'
    });
	var pJson = dataJson[0];
	
	$('#gridYear').datagrid('query', {
        pJson : JSON.stringify(pJson)
    });
}

function QueryYearRep(){
	REP_COM.OPERATE.ClearGridAllDetail();
	var year = GetYear()
    if (!year) {
		PHA.Msg("alert","请选择一个年份！")
		return;
	}
	var locId = $('#locId').combobox('getValue')
   	var pJson = {
	   	year  : year,
    	locId : locId
    }
	$('#gridRep').datagrid('query', {
        pJson : JSON.stringify(pJson)
    });
}

function GetYear(){
	var gridSelect = $('#gridYear').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.year;
    return "";
}

function CreateYearRep(){
	
	var year = GetYear()
    if (!year) {
		PHA.Msg("alert","请选择一个年份！")
		return;
	}
	var locId = $('#locId').combobox('getValue'); 
	if (!locId){
		PHA.Msg("alert", "请选择一个科室！")
		return;
	}
	var startYearMon = $('#startYearMon').phamonthbox('getValue') || '';
	var endYearMon = $('#endYearMon').phamonthbox('getValue') || '';
	
	if(!startYearMon||!endYearMon){
		PHA.Msg("alert", "开始或结束月份不能为空！")
		return;
	}
	var	pJson = {
		repType   : REPTYPE,
		locId	  : locId,
		year 	  : year,
		userId 	  : session['LOGON.USERID'],
		startYearMon  : startYearMon,
		endYearMon    : endYearMon
	}
	PHA.CM(
        {
            pClassName : 'PHA.IN.REP.Api',  
            pMethodName: 'CreateYearRep',
            pJson	   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
		        QueryYears();
			}
        }
    )
}

// 差异确认
function AuditDif(){
	var ret = REP_COM.FUNCTION.AuditDif();
	if (!ret) return;
	QueryYearRep();
	QueryYears();
	REP_COM.FUNCTION.QueryRepOperate();
}

function CancelRep(){
var ret = REP_COM.FUNCTION.Cancel();
	if (!ret) return;
	QueryYearRep();
	QueryYears();
	REP_COM.FUNCTION.QueryRepOperate();}

/// 上个年
function YearDown(){
	YearMove(-1)
}

/// 下个年
function YearUp(){
	YearMove(1)
}

function YearMove(num){
	var year = $('#year').val() || '';
	if(!year) {
		//初始化年份下拉框
		var myDate=new Date();
		var year = myDate.getFullYear();
		num = 0
	}
	year = parseInt(year)
	year = year + num
	$('#year').val(year);
	QueryYears();
}

function SetMon(year){
	var year = GetYear();
	var locId = $('#locId').combobox('getValue')
	var	pJson = {
		locId : locId,
		year  : year,
	}
	PHA.CM(
        {
            pClassName : 'PHA.IN.REP.Api',  
            pMethodName: 'GetYearMonAndStatus',
            pJson	   : JSON.stringify(pJson),
        },
        function (retData) {
	        if(retData.msg != ''){
	            $('#startYearMon').phamonthbox("clear")
	            $('#endYearMon').phamonthbox("clear")
	            $('#startYearMon').phamonthbox('disable')
				$('#endYearMon').phamonthbox('disable')
            }
            else{
	            $('#startYearMon').phamonthbox('enable')
	            $('#endYearMon').phamonthbox('enable')
	            if ((retData.startYearMon)&&(retData.startYearMon != "")) {
		            $('#startYearMon').phamonthbox('setValue',retData.startYearMon);
		            $('#startYearMon').phamonthbox('disable')
	            }
            }
        }
    )
}

function Refresh(){
	REP_COM.FUNCTION.QueryRepDetail();
}