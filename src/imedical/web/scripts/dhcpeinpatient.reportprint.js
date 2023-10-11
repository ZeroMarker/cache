
/*
 * FileName:    dhcpeinpatient.reportprint.js
 * Author:      xueying
 * Date:        20220915
 * Description: סԺ��챨���ӡ
 */
 
 $(function(){
	 
	 //�����б��
	 InitCombobox();
	
	//��ʼ���б�
	InitIPatientReportGrid();
	
	$("#RegNo").keydown(function (e) {
		if (e.keyCode == 13) {
			BFind_click();
		}
	});

	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
   
})

function BPrintView(e){
	
	var LocID=session['LOGON.CTLOCID'];
	var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",LocID,"NewVerReport");
    
    var PAADM=$("#PAADM").val();
	if(PAADM==""){
		  $.messager.alert("��ʾ","��ѡ�����ӡ���棡","info");
		  return false;
	  }
 
	if(e.id=="BPrint"){
		var ReportStatus=$("#ReportStatus").val();
		
		if(ReportStatus.indexOf("δ")>=0){
			
			$.messager.alert("��ʾ","δ���죬���ʵ����״̬","info");
			return false;
		}
	}
		
	if(NewVerReportFlag=="Lodop"){
		var Flag=tkMakeServerCall("web.DHCPE.PreIADM","IsHaveResultByPAADM",PAADM);
		if(Flag=="0"){
			$.messager.alert("��ʾ","û�������������Ԥ��","info");
			 return false; 
		}
		PEPrintReport(e.id,PAADM,""); //lodop+cspԤ����챨��
		return false;
	}else if(NewVerReportFlag=="Word"){	
		var Flag=tkMakeServerCall("web.DHCPE.PreIADM","IsHaveResultByPAADM",PAADM);
		if(Flag=="0"){
			$.messager.alert("��ʾ","û�������������Ԥ��","info");
			 return false; 
		}
		websocoket_report(e.id,PAADM);
		return false;
	}
}

/* 
 * [websocket �ͻ���ͨ��]
 * @param    {[Date]}    date [����]
 * @return   {[String]}         [��ʽ��������]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function websocoket_report(sourceID, jarPAADM) {	
	var opType = (sourceID == "BPrint" || sourceID == "NoCoverPrint") ? "2" : (sourceID == "BPrintView" ? "5" : (sourceID == "BUploadReport" ? "4" : "1"));
	var fileType = (sourceID == "BExportPDF") || (sourceID == "BUploadReport") ? "pdf" : (sourceID == "BExportHtml" ? "html" : "word");
	var execParam = {
		business: "REPORT", //����̶�ΪREPORT
		admId: jarPAADM,
		opType: opType,
		fileType: fileType,
		printType: "1" //1Ϊ���˱���
	};
	
	//��ӡԤ����������ˮӡ
	if(execParam.opType == "2") execParam.extStr="HS10322,"+session["LOGON.USERID"];
	if(execParam.opType == "5") execParam.extStr="WaterMark:PreView";
	
	var json = JSON.stringify(execParam);
	$PESocket.sendMsg(json, peSoceket_onMsg);
}

/*
 * [websocket �ͻ���ͨ�Żص�����]
 * @param    {[String]}    param [�ͻ��˽��յ��� json��]
 * @return   {[Object]}    event [�ͻ��˷��ص���Ϣ����]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function peSoceket_onMsg(param, event) {
	var paramObj = JSON.parse(param);
	var FileName = paramObj.files;
	var retObj = JSON.parse(event.data);
	if (retObj.code == "0") {
		//��ǰ����Ϊ��ӡ����Ҫ���±���״̬
		if (paramObj.opType == "2") {
			var admIds = paramObj.admId;
			var userId = session["LOGON.USERID"];
			admIds.split("#").forEach(function(admId, index) {
				var xmlStr = "<Request><admId>" + admId + "</admId><status>P</status><userId>" + userId + "</userId></Request>";
				tkMakeServerCall("HS.BL.ExaminationReport", "UpdateReportStatus", xmlStr);
			});
		} else if (paramObj.opType == "4" && retObj.body != "") { //�ϴ�����  ���±����ϴ�״̬
			var admIds = paramObj.admId;
			admIds.split("#").forEach(function(admId, index) {
				tkMakeServerCall("web.DHCPE.ReportExportPDF", "UpdateExportStatus", admId, "3", retObj.body);
			});
		}
	} else {
		$.messager.alert("��ʾ", "<br><span style='color:red;font-weight:600;'>ִ��ʧ�ܣ��������ѯ��־</span>", "info");
	}
}

//��ѯ
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
			{field:'TRegNo',width:120,title:'�ǼǺ�'},
			{field:'TName',width:140,title:'����'},	
			{field:'TSex',width:60,title:'�Ա�'},
			{field:'TAge',width:90,title:'����'},
			{field:'TIDCard',width:160,title:'֤����'},
			{field:'TIDCardDesc',width:160,title:'֤������'},
			{field:'TInDate',width:120,title:'��������'},
			{field:'THPDate',width:120,title:'�������'},
			{field:'TAuditDate',width:120,title:'�������'},
			{field:'TPrintDate',width:120,title:'��ӡ����'},
			{field:'TStatus',width:120,title:'״̬'}
			
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
