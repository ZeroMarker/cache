var Columns=getCurColumnsInfo('PLAT.G.CheckResult.Find','','','')

$(document).ready(function () {
    initDocument();
});
function initDocument()
{
	initUserInfo();
	initMessage();
	initEvent();
	//initReportType();
	initDataGrid();	
}

function initEvent()
{
	jQuery("#BCheckDepre").on("click", BCheckDepre_Clicked);
	jQuery("#BCheckReport").on("click", BCheckReport_Clicked);
	jQuery("#BReportResult").on("click", BReportResult_Clicked);
	jQuery("#BCheckBussReport").on("click", BCheckBussReport_Clicked);
	jQuery("#BExeCheckDepre").on("click", BExeCheckDepre_Clicked);
	jQuery("#BCloseDepre").on("click", BCloseDepre_Clicked);
	jQuery("#BExeCheckReport").on("click", BExeCheckReport_Clicked);
	jQuery("#BCloseReport").on("click", BCloseReport_Clicked);
}

function initReportType()
{
	SysRtn=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","901003");
	var dataArr=[{id:'0',text:'实物月结'}];
	if (SysRtn) dataArr=[{id:'0',text:'实物月结'},{id:'1',text:'财务月结'}];
	var ReportType = $HUI.combobox("#ReportType",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:dataArr
	});
	setElement("ReportType","0");	//设置默认值
	
}

function initDataGrid()
{
	var BuyReqGrid=$HUI.datagrid("#tDHCEQCheckResultFind",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Plat.BUSCheckResult",
	        	QueryName:"CheckResult",
		},
		toolbar:[],
	    border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列	    
        //onClickRow:onClickRow,
	    columns:Columns,
		pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12],
		onLoadSuccess:function(){
			//creatToolbar();
		}
	});
}

//折旧检测
function BCheckDepre_Clicked()
{
	setRequiredElements("DepreMonthStr");
	setRequiredElements("ReportMonthStr^ReportType",false);
	BExeCheckDepre_Clicked();
	/*
	$HUI.dialog('#DepreWin', {
		width: 400,
		height: 150,
		modal:true,
		title: '执行折旧检测',
		onOpen: function(){
			//
		}
	}).open();
	*/
}

//月报检测
function BCheckReport_Clicked()
{
	setRequiredElements("ReportMonthStr^ReportType");
	setRequiredElements("DepreMonthStr",false);
	BExeCheckReport_Clicked();
	/*
	$HUI.dialog('#ReportWin', {
		width: 400,
		height: 200,
		modal:true,
		title: '执行折旧检测',
		onOpen: function(){
			if(SysRtn!=1) {
				$("#ReportType").next().hide();
				hiddenObj("cReportType",1);
			}
		}
	}).open();
	*/
}

//月报检测结果
function BReportResult_Clicked()
{
	var url="dhceq.plat.checkresultfind.csp?";
	showWindow(url,"报表检测结果","","10row","icon-w-paper","modal","","","small"); 
}

//资产变动及结存表(资金来源)-业务对照
function BCheckBussReport_Clicked()
{
	var url="dhceq.fam.smonthreportfunds.csp?ReportFileName=DHCEQSMonthReportFunds.raq";
	showWindow(url,"月报-业务对照","","","icon-w-paper","modal","","","verylarge"); 
}

function BExeCheckDepre_Clicked()
{
	if (checkMustItemNull("")) return
	var	result=tkMakeServerCall("web.DHCEQ.Plat.BUSCheckResult","CheckEquipDepre",getElementValue("DepreMonthStr"))
	if (result==1)
	{
		alertShow("有数据折旧错误，请核对错误日志!")
		$("#tDHCEQDepreError").css({'display':'block','class':'hisui-datagrid'});
		$("#NoDataPic").css('display','none');
		initDepreErrorGrid();
	}
	else if (result==0)
	{
		alertShow("数据无误!")
	}
	else
	{
		alertShow(result)
	}
}

function BExeCheckReport_Clicked()
{
	if (checkMustItemNull("")) return
	var	result=tkMakeServerCall("web.DHCEQ.Plat.BUSCheckResult","CheckMonthReport",getElementValue("ReportMonthStr"),getElementValue("ReportType"))
	if (result==0)
	{
		alertShow("执行成功，请核对检测结果!")
	}
	else
	{
		alertShow("执行失败!错误代码："+result)
	}
}

function BCloseDepre_Clicked()
{
	$HUI.dialog("#DepreWin").close();
}

function BCloseReport_Clicked()
{
	$HUI.dialog("#ReportWin").close();
}

function initDepreErrorGrid()
{
	var DepreErrorObj=$HUI.datagrid("#tDHCEQDepreError",{
		url:$URL,
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,
		pagination:true,
		pageSize:15,
		pageList:[15,30,50],
		queryParams:{
			ClassName:"web.DHCEQ.Plat.BUSCheckResult",
			QueryName:"CheckDepreList"
		},
		toolbar:[{
			iconCls: 'icon-export-paper',
			text:'导出',
			handler: function(){
				ExportDepreError();
			}
		}],
		nowrap:false,		//开启行内换行
	    columns:[[
			{field:'EquipID',title:'设备ID'},
			{field:'SnapID',title:'快照ID'},
			{field:'EQNo',title:'设备编号'},
			{field:'EQErrMsg',title:'设备折旧错误信息',width:250,wordBreak:"break-all"},
			{field:'DepreSetErrMsg',title:'折旧设置错误信息',width:250,wordBreak:"break-all"},
			{field:'FundsErrMsg',title:'资金来源错误信息',width:250,wordBreak:"break-all"},
			{field:'OriginalFee',title:'原值'},
			{field:'DepreTotalFee',title:'累计折旧'},
			{field:'NetFee',title:'净值'},
			{field:'NetRemainFee',title:'净残值'},
			{field:'DepreInfo',title:'折旧设置信息',width:250,wordBreak:"break-all"},
			{field:'FundsInfo',title:'资金来源信息',width:500,wordBreak:"break-all"}
		]]
	});
}

///同步导出台账/快照折旧错误信息
function ExportDepreError()
{
	$cm({
		ResultSetType:"ExcelPlugin",
		ExcelName:curHospitalName+"台账/快照折旧错误数据",
		ClassName:"web.DHCEQ.Plat.BUSCheckResult",
		QueryName:"CheckDepreList",
		rows:99999
	},false);
}
