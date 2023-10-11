/**
* FillName: dhcinsu/divmonstmtimportresult.js
* Description: 对账清算上传导入第三方明细弹出界面
* Creator WangXQ
* Date: 2022-06-17
*/
//var Rq = INSUGetRequest();
//var Pid=Rq["Pid"];

//入口函数
$(function(){

	setPageLayout();    //设置页面布局
	setElementEvent();  //设置页面元素事件	
});

function setPageLayout() {
	InitImportYDg();
	InitImportNDg();
}
function setElementEvent(){
	QryImportY();
	QryImportN();
	$("#btnSearch").click(SearchImportData);		//查询
	$("#btnExportN").click(ExportImportDataN);		//导出失败数据
	$("#btnExportY").click(ExportImportDataY);		//导出成功数据
	$("#psnName").keydown(function(e) { 	//姓名回车事件
	  if (e.keyCode==13)
	  {
		SearchImportData();
	  }
	});
	$("#seltId").keydown(function(e) { 		//结算ID回车事件
	  if (e.keyCode==13)
	  {
		SearchImportData();
	  }
	}); 
	$("#mdtrtId").keydown(function(e) { 	//就诊ID回车事件
	  if (e.keyCode==13)
	  {
		SearchImportData();
	  }
	}); 
	$("#certNo").keydown(function(e) { 		//证件号码回车事件
	  if (e.keyCode==13)
	  {
		SearchImportData();
	  }
	});   			
	
}

//查询按钮
function SearchImportData(){
	
	QryImportY();
	QryImportN();

}
//查询导入成功数据
function QryImportY()
{
	var Rq = INSUGetRequest();
	var Pid=Rq["Pid"];

	 var queryParams = {

	    ClassName : 'INSU.MI.DAO.HisDivInfo',
	    QueryName : 'QueryImportInfo',
	    ImportFlag:"Y",
	    PsnName:$('#psnName').val(),
	 	SeltId:$('#seltId').val(),
	 	MdtrtId:$('#mdtrtId').val(),
	 	CertNo:$('#certNo').val(),
	 	Pid:Pid
	}	
    loadDataGridStore('importy',queryParams);
	}
	
//查询导入失败数据
function QryImportN()
{
	var Rq = INSUGetRequest();
	var Pid=Rq["Pid"];
	
	 var queryParams = {

	    ClassName : 'INSU.MI.DAO.HisDivInfo',
	    QueryName : 'QueryImportInfo',
	    ImportFlag:"N",
	    PsnName:$('#psnName').val(),
	 	SeltId:$('#seltId').val(),
	 	MdtrtId:$('#mdtrtId').val(),
	 	CertNo:$('#certNo').val(),
	 	Pid:Pid	    
	}	
    loadDataGridStore('importn',queryParams);
	}

//导出失败数据
function ExportImportDataN()
{
   try
   {
  	var Rq = INSUGetRequest();
	var Pid=Rq["Pid"];
$.messager.progress({
         title: "提示",
		 msg: '正在导出导入失败数据',
		 text: '导出中....'
		   });
$cm({
	ResultSetType:"ExcelPlugin",  
	ExcelName:"导入失败数据",		  
	PageName:"QueryImportData",      
	ClassName:"INSU.MI.DAO.HisDivInfo",
	QueryName:"QueryImportData",
    ImportFlag:"N",
	PsnName:$('#psnName').val(),
	SeltId:$('#seltId').val(),
	MdtrtId:$('#mdtrtId').val(),
	CertNo:$('#certNo').val(),
	Pid:Pid
},function(){
	  setTimeout('$.messager.progress("close");', 3 * 1000);	
});

   } catch(e) {
	   $.messager.alert("警告",e.message);
	   $.messager.progress('close');
   };
  
   
   }
//导出成功数据
function ExportImportDataY()
{
   try
   {
  	var Rq = INSUGetRequest();
	var Pid=Rq["Pid"];
$.messager.progress({
         title: "提示",
		 msg: '正在导出导入成功数据',
		 text: '导出中....'
		   });
$cm({
	ResultSetType:"ExcelPlugin",  
	ExcelName:"导入成功数据",		  
	PageName:"QueryImportData",      
	ClassName:"INSU.MI.DAO.HisDivInfo",
	QueryName:"QueryImportData",
    ImportFlag:"Y",
	PsnName:$('#psnName').val(),
	SeltId:$('#seltId').val(),
	MdtrtId:$('#mdtrtId').val(),
	CertNo:$('#certNo').val(),
	Pid:Pid
},function(){
	  setTimeout('$.messager.progress("close");', 3 * 1000);	
});

   } catch(e) {
	   $.messager.alert("警告",e.message);
	   $.messager.progress('close');
   };
   }
   
   
	
//初始化导入成功数据列表
function InitImportYDg() {
	$('#importy').datagrid({
		onLoadSuccess: function () {
	           $(".datagrid-header-rownumber,.datagrid-cell-rownumber").width("50");
	        },
				fit:true,
				border:false,
				striped:true,
				checkOnSelect:true,
				singleSelect: true,
				rownumbers: true,
				pageList: [13,30,50],
				pageSize: 13,
				pagination: true,
			    columns: [[
			   {
				title: '结算ID',
				field: 'seltId',
			},
			{
				title: '就诊ID',
				field: 'mdtrtId',
			},
			{
				title: '原报文ID',
				field: 'msgId',
			},
			{
				title: '人员编码',
				field: 'psnNo',
			},
			{
				title: '人员姓名',
				field: 'psnName',
			},
			{
				title: '证件号码',
				field: 'certNo',
			},
			{
				title: '开始时间',
				field: 'StDate',
			},
			{
				title: '结束时间',
				field: 'EnDate',
			},
			{
				title: '结算时间',
				field: 'tmpsfrq',
			},
			{
				title: '就诊类型',
				field: 'admType',
			},
			{
				title: '总费用',
				field: 'totAmout',
			},
			{
				title: '基金支出',
				field: 'hisJjzfe',
			},
			{
				title: '个人支付',
				field: 'OwnPay',
			},
			{
				title: '个账支付',
				field: 'hisZhzfe',
			},
			{
				title: '现金支付',
				field: 'hisGrzfe',
			},
			{
				title: '险种',
				field: 'xzlb',
			},
			{
				title: '退费结算标识',
				field: 'RefdSetlFlag',
			},
			{
				title: '清算经办机构',
				field: 'ClrOptins',
			},
			{
				title: '人员类别',
				field: 'patType',
			},
			{
				title: '参保机构医保区划',
				field: 'insuOptins',
			},
			{
				title: '就诊日期',
				field: 'VisitDate',
			},
			{
				title: '出院日期(非住院为空)',
				field: 'LeaveDate',
			},
			{
				title: '入院诊断',
				field: 'preDiagnosis',
			},
			{
				title: '出院诊断/主要诊断',
				field: 'mainDiagnosis',
			},
			{
				title: '基本医疗统筹基金支出',
				field: 'hisHifpPay',
			},
			{
				title: '大额医疗补助基金支出',
				field: 'hisHifobPay',
			},
			{
				title: '公务员医疗补助基金支出',
				field: 'hisCvlservPay',
			},
			{
				title: '医疗救助基金支出',
				field: 'hisMafPay',
			},
			{
				title: '伤残人员医疗保障基金支出',
				field: 'hisHifdmPay',
			},
			{
				title: '补充医疗保险基金支出',
				field: 'hisHifesPay',
			},
			{
				title: '大病补充医疗保险基金支出',
				field: 'hisHifmiPay',
			},
			{
				title: '其他基金支出',
				field: 'hisOthPay',
			},
			{
				title: '全自费金额',
				field: 'hisOwnpayAmt',
			},
			{
				title: '超限价自费费用',
				field: 'hisOverlmtSelfPay',
			},
			{
				title: '先行自付金额',
				field: 'hisPreselfpayAmt',
			},
			{
				title: '符合范围金额',
				field: 'hisInscpScpAmt',
			},
			{
				title: '基本医疗统筹比例自付',
				field: 'hisPoolPropSelfPay',
			},
			{
				title: '人员证件类型',
				field: 'psnCertType',
			},
			{
				title: '是否正常记录',
				field: 'YoNNormalRecord',
			}
			    
			    ]]
			    			    
			    });
}
//初始化导入失败数据列表
function InitImportNDg() {
	$('#importn').datagrid({
		onLoadSuccess: function () {
	           $(".datagrid-header-rownumber,.datagrid-cell-rownumber").width("50");
	        },
				fit:true,
				border:false,
				striped:true,
				checkOnSelect:true,
				singleSelect: true,
				rownumbers: true,
				pageList: [13,30,50],				
				pageSize: 13,
				pagination: true,
			    columns: [[
			    {
				title: '失败信息',
				field: 'FailInfo',
			},
			    {
				title: '结算ID',
				field: 'seltId',
			},
			{
				title: '就诊ID',
				field: 'mdtrtId',
			},
			{
				title: '原报文ID',
				field: 'msgId',
			},
			{
				title: '人员编码',
				field: 'psnNo',
			},
			{
				title: '人员姓名',
				field: 'psnName',
			},
			{
				title: '证件号码',
				field: 'certNo',
			},
			{
				title: '开始时间',
				field: 'StDate',
			},
			{
				title: '结束时间',
				field: 'EnDate',
			},
			{
				title: '结算时间',
				field: 'tmpsfrq',
			},
			{
				title: '就诊类型',
				field: 'admType',
			},
			{
				title: '总费用',
				field: 'totAmout',
			},
			{
				title: '基金支出',
				field: 'hisJjzfe',
			},
			{
				title: '个人支付',
				field: 'OwnPay',
			},
			{
				title: '个账支付',
				field: 'hisZhzfe',
			},
			{
				title: '现金支付',
				field: 'hisGrzfe',
			},
			{
				title: '险种',
				field: 'xzlb',
			},
			{
				title: '退费结算标识',
				field: 'RefdSetlFlag',
			},
			{
				title: '清算经办机构',
				field: 'ClrOptins',
			},
			{
				title: '人员类别',
				field: 'patType',
			},
			{
				title: '参保机构医保区划',
				field: 'insuOptins',
			},
			{
				title: '就诊日期',
				field: 'VisitDate',
			},
			{
				title: '出院日期(非住院为空)',
				field: 'LeaveDate',
			},
			{
				title: '入院诊断',
				field: 'preDiagnosis',
			},
			{
				title: '出院诊断/主要诊断',
				field: 'mainDiagnosis',
			},
			{
				title: '基本医疗统筹基金支出',
				field: 'hisHifpPay',
			},
			{
				title: '大额医疗补助基金支出',
				field: 'hisHifobPay',
			},
			{
				title: '公务员医疗补助基金支出',
				field: 'hisCvlservPay',
			},
			{
				title: '医疗救助基金支出',
				field: 'hisMafPay',
			},
			{
				title: '伤残人员医疗保障基金支出',
				field: 'hisHifdmPay',
			},
			{
				title: '补充医疗保险基金支出',
				field: 'hisHifesPay',
			},
			{
				title: '大病补充医疗保险基金支出',
				field: 'hisHifmiPay',
			},
			{
				title: '其他基金支出',
				field: 'hisOthPay',
			},
			{
				title: '全自费金额',
				field: 'hisOwnpayAmt',
			},
			{
				title: '超限价自费费用',
				field: 'hisOverlmtSelfPay',
			},
			{
				title: '先行自付金额',
				field: 'hisPreselfpayAmt',
			},
			{
				title: '符合范围金额',
				field: 'hisInscpScpAmt',
			},
			{
				title: '基本医疗统筹比例自付',
				field: 'hisPoolPropSelfPay',
			},
			{
				title: '人员证件类型',
				field: 'psnCertType',
			},
			{
				title: '是否正常记录',
				field: 'YoNNormalRecord',
			}
			    
			    ]]
			    			    
			    });
}
