//����	DHCPEAnnualReport.hisui.js
//����	����������ͳ�Ʊ���
//����	2019.09.23
//������  ln

$(function(){
		
     
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
})


//����
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$HUI.checkbox("#GroupFlag").setValue(false);
    //BFind_click();
	document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEAnnualReports1.raq";
}


//��ѯ
function BFind_click(){
	
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	/*if ((BeginDate=="")&&(EndDate=="")){
		$.messager.alert("��ʾ","���ڲ���Ϊ��","info");
		return false;
	}*/
	var CTLOCID=session['LOGON.CTLOCID'];
	var USERID=session['LOGON.USERID'];
	var iGroupFlag="N";
	var GroupFlag=$("#GroupFlag").checkbox('getValue');
	if (GroupFlag) {iGroupFlag="Y";} 
	
	if (iGroupFlag=="N"){		
		var ret=tkMakeServerCall("web.DHCPE.Statistic.AnnualReports","SetGlobalNum",BeginDate,EndDate,CTLOCID,USERID);
		var lnk="&BeginDate="+BeginDate+"&EndDate="+EndDate+"&USERID="+USERID;
		var reportName = "DHCPEAnnualReports.raq";	
	}else{
		var lnk="&BeginDate="+BeginDate+"&EndDate="+EndDate+"&CTLOCID="+CTLOCID+"&USERID="+USERID;
		var reportName = "DHCPEGroupAnnualReport.raq";	
	}
	document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;
}

