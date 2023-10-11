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
	var dataArr=[{id:'0',text:'ʵ���½�'}];
	if (SysRtn) dataArr=[{id:'0',text:'ʵ���½�'},{id:'1',text:'�����½�'}];
	var ReportType = $HUI.combobox("#ReportType",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:dataArr
	});
	setElement("ReportType","0");	//����Ĭ��ֵ
	
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
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���	    
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

//�۾ɼ��
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
		title: 'ִ���۾ɼ��',
		onOpen: function(){
			//
		}
	}).open();
	*/
}

//�±����
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
		title: 'ִ���۾ɼ��',
		onOpen: function(){
			if(SysRtn!=1) {
				$("#ReportType").next().hide();
				hiddenObj("cReportType",1);
			}
		}
	}).open();
	*/
}

//�±������
function BReportResult_Clicked()
{
	var url="dhceq.plat.checkresultfind.csp?";
	showWindow(url,"��������","","10row","icon-w-paper","modal","","","small"); 
}

//�ʲ��䶯������(�ʽ���Դ)-ҵ�����
function BCheckBussReport_Clicked()
{
	var url="dhceq.fam.smonthreportfunds.csp?ReportFileName=DHCEQSMonthReportFunds.raq";
	showWindow(url,"�±�-ҵ�����","","","icon-w-paper","modal","","","verylarge"); 
}

function BExeCheckDepre_Clicked()
{
	if (checkMustItemNull("")) return
	var	result=tkMakeServerCall("web.DHCEQ.Plat.BUSCheckResult","CheckEquipDepre",getElementValue("DepreMonthStr"))
	if (result==1)
	{
		alertShow("�������۾ɴ�����˶Դ�����־!")
		$("#tDHCEQDepreError").css({'display':'block','class':'hisui-datagrid'});
		$("#NoDataPic").css('display','none');
		initDepreErrorGrid();
	}
	else if (result==0)
	{
		alertShow("��������!")
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
		alertShow("ִ�гɹ�����˶Լ����!")
	}
	else
	{
		alertShow("ִ��ʧ��!������룺"+result)
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
			text:'����',
			handler: function(){
				ExportDepreError();
			}
		}],
		nowrap:false,		//�������ڻ���
	    columns:[[
			{field:'EquipID',title:'�豸ID'},
			{field:'SnapID',title:'����ID'},
			{field:'EQNo',title:'�豸���'},
			{field:'EQErrMsg',title:'�豸�۾ɴ�����Ϣ',width:250,wordBreak:"break-all"},
			{field:'DepreSetErrMsg',title:'�۾����ô�����Ϣ',width:250,wordBreak:"break-all"},
			{field:'FundsErrMsg',title:'�ʽ���Դ������Ϣ',width:250,wordBreak:"break-all"},
			{field:'OriginalFee',title:'ԭֵ'},
			{field:'DepreTotalFee',title:'�ۼ��۾�'},
			{field:'NetFee',title:'��ֵ'},
			{field:'NetRemainFee',title:'����ֵ'},
			{field:'DepreInfo',title:'�۾�������Ϣ',width:250,wordBreak:"break-all"},
			{field:'FundsInfo',title:'�ʽ���Դ��Ϣ',width:500,wordBreak:"break-all"}
		]]
	});
}

///ͬ������̨��/�����۾ɴ�����Ϣ
function ExportDepreError()
{
	$cm({
		ResultSetType:"ExcelPlugin",
		ExcelName:curHospitalName+"̨��/�����۾ɴ�������",
		ClassName:"web.DHCEQ.Plat.BUSCheckResult",
		QueryName:"CheckDepreList",
		rows:99999
	},false);
}
