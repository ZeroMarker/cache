
/*
 * FileName:    dhcpeinpatient.reportprint.js
 * Author:      xueying
 * Date:        20220915
 * Description: 住院体检报告打印
 */
 
 $(function(){
	 
	 //下拉列表框
	 InitCombobox();
	
	//初始化列表
	InitIPatientReportGrid();
	
	$("#RegNo").keydown(function (e) {
		if (e.keyCode == 13) {
			BFind_click();
		}
	});

	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
   
})

function BPrintView(e){
	
	var LocID=session['LOGON.CTLOCID'];
	var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",LocID,"NewVerReport");
    
    var PAADM=$("#PAADM").val();
	if(PAADM==""){
		  $.messager.alert("提示","请选择待打印报告！","info");
		  return false;
	  }
 
	if(e.id=="BPrint"){
		var ReportStatus=$("#ReportStatus").val();
		
		if(ReportStatus.indexOf("未")>=0){
			
			$.messager.alert("提示","未初检，请核实报告状态","info");
			return false;
		}
	}
		
	if(NewVerReportFlag=="Lodop"){
		var Flag=tkMakeServerCall("web.DHCPE.PreIADM","IsHaveResultByPAADM",PAADM);
		if(Flag=="0"){
			$.messager.alert("提示","没有体检结果，不能预览","info");
			 return false; 
		}
		PEPrintReport(e.id,PAADM,""); //lodop+csp预览体检报告
		return false;
	}else if(NewVerReportFlag=="Word"){	
		var Flag=tkMakeServerCall("web.DHCPE.PreIADM","IsHaveResultByPAADM",PAADM);
		if(Flag=="0"){
			$.messager.alert("提示","没有体检结果，不能预览","info");
			 return false; 
		}
		websocoket_report(e.id,PAADM);
		return false;
	}
}

/* 
 * [websocket 客户端通信]
 * @param    {[Date]}    date [日期]
 * @return   {[String]}         [格式化的日期]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function websocoket_report(sourceID, jarPAADM) {	
	var opType = (sourceID == "BPrint" || sourceID == "NoCoverPrint") ? "2" : (sourceID == "BPrintView" ? "5" : (sourceID == "BUploadReport" ? "4" : "1"));
	var fileType = (sourceID == "BExportPDF") || (sourceID == "BUploadReport") ? "pdf" : (sourceID == "BExportHtml" ? "html" : "word");
	var execParam = {
		business: "REPORT", //报告固定为REPORT
		admId: jarPAADM,
		opType: opType,
		fileType: fileType,
		printType: "1" //1为个人报告
	};
	
	//打印预览——增加水印
	if(execParam.opType == "2") execParam.extStr="HS10322,"+session["LOGON.USERID"];
	if(execParam.opType == "5") execParam.extStr="WaterMark:PreView";
	
	var json = JSON.stringify(execParam);
	$PESocket.sendMsg(json, peSoceket_onMsg);
}

/*
 * [websocket 客户端通信回调函数]
 * @param    {[String]}    param [客户端接收到的 json串]
 * @return   {[Object]}    event [客户端返回的信息内容]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function peSoceket_onMsg(param, event) {
	var paramObj = JSON.parse(param);
	var FileName = paramObj.files;
	var retObj = JSON.parse(event.data);
	if (retObj.code == "0") {
		//当前操作为打印，需要更新报告状态
		if (paramObj.opType == "2") {
			var admIds = paramObj.admId;
			var userId = session["LOGON.USERID"];
			admIds.split("#").forEach(function(admId, index) {
				var xmlStr = "<Request><admId>" + admId + "</admId><status>P</status><userId>" + userId + "</userId></Request>";
				tkMakeServerCall("HS.BL.ExaminationReport", "UpdateReportStatus", xmlStr);
			});
		} else if (paramObj.opType == "4" && retObj.body != "") { //上传报告  更新报告上传状态
			var admIds = paramObj.admId;
			admIds.split("#").forEach(function(admId, index) {
				tkMakeServerCall("web.DHCPE.ReportExportPDF", "UpdateExportStatus", admId, "3", retObj.body);
			});
		}
	} else {
		$.messager.alert("提示", "<br><span style='color:red;font-weight:600;'>执行失败，详情请查询日志</span>", "info");
	}
}

//查询
function BFind_click() {
	
	var LocID=session['LOGON.CTLOCID'];
	var HospID=session['LOGON.HOSPID'];
	
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",LocID);
	var iRegNo=	$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,LocID);
			$("#RegNo").val(iRegNo);
	}

	 $("#IPatientReportGrid").datagrid('load',{
			ClassName:"web.DHCPE.OtherPatientToHP",
			QueryName:"FindReportList",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
		    AuditStartDate:$("#AuditStartDate").datebox('getValue'),
			AuditEndDate:$("#AuditEndDate").datebox('getValue'),
			PrintStartDate:$("#PrintStartDate").datebox('getValue'),
			PrintEndDate:$("#PrintEndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			Status:$("#Status").combobox('getValue'),
			hospid:session['LOGON.HOSPID'],
		    locid:session['LOGON.CTLOCID']
			
		})
		
}



function InitIPatientReportGrid(){
	
	
	$HUI.datagrid("#IPatientReportGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.OtherPatientToHP",
			QueryName:"FindReportList",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			AuditStartDate:$("#AuditStartDate").datebox('getValue'),
			AuditEndDate:$("#AuditEndDate").datebox('getValue'),
			PrintStartDate:$("#PrintStartDate").datebox('getValue'),
			PrintEndDate:$("#PrintEndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			hospid:session['LOGON.HOSPID'],
		    locid:session['LOGON.CTLOCID']
						
		},
		columns:[[       
		    {field:'TEpisodeID',title:'PAADM',hidden: true},
			{field:'TRegNo',width:120,title:'登记号'},
			{field:'TName',width:140,title:'姓名'},	
			{field:'TSex',width:60,title:'性别'},
			{field:'TAge',width:90,title:'年龄'},
			{field:'TIDCard',width:160,title:'证件号'},
			{field:'TIDCardDesc',width:160,title:'证件类型'},
			{field:'TInDate',width:120,title:'就诊日期'},
			{field:'THPDate',width:120,title:'体检日期'},
			{field:'TAuditDate',width:120,title:'审核日期'},
			{field:'TPrintDate',width:120,title:'打印日期'},
			{field:'TStatus',width:120,title:'状态'}
			
		]],
		onSelect: function (rowIndex, rowData) {
		
			$("#PAADM").val(rowData.TEpisodeID);
			$("#ReportStatus").val(rowData.TStatus);
			
		},
		onLoadSuccess: function(data) {
			
		},
			
	})
	
}


function InitCombobox()
{
}
