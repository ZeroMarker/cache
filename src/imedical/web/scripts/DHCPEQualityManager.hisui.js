//����	DHCPEQualityManager.hisui.js
//����	�����ϱ�ͳ��
//����	2020.06.21
//������  ln

$(function(){
			
	InitCombobox();
	
     
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEQualityManager.raq");
})


//����
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$(".hisui-combobox").combobox('setValue',"");
	
	$("#ShowFlag").combobox('setValue',"Err");
	InitCombobox();
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEQualityManager.raq");
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEQualityManager.raq";
}


//��ѯ
function BFind_click(){
	var BeginDate = "", EndDate = "", VIPLevel="", ShowFlag = "", reportName = "";
	var BeginDate=$("#BeginDate").datebox('getValue');
    var EndDate = $("#EndDate").datebox('getValue');
		
	var VIPLevel=$("#VIPLevel").combobox('getValue');
	if (VIPLevel==undefined) {var VIPLevel="";}
	
	var ShowFlag = $("#ShowFlag").combogrid("getValue");
	if (ShowFlag == "Err") reportName = "DHCPEQualityManager.raq";
	else if (ShowFlag == "Create") reportName = "DHCPEQualityManager1.raq";
	else { $.messager.alert("��ʾ","��ѡ���ѯ���ͣ�","info");  return false;}
	
	var CurLoc = session["LOGON.CTLOCID"];
	
	var lnk = "&StartDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&VIPLevel=" + VIPLevel
			+ "&CurLoc=" + CurLoc
			;
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=" + reportName + lnk);
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;

}

function InitCombobox(){
	
	/*
	//VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
	*/
	
	//VIP�ȼ�-��Ժ�� 
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
	});

	
	// ��ѯ����
	$HUI.combobox("#ShowFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'Err',text:$g('������'),selected:true},
			{id:'Create',text:$g('�ϱ���')}
		]
	});
	
}
// ���iframe�� ��Ǭcsp ��������
function ShowRunQianUrl(iframeId, url) {
    var iframeObj = document.getElementById(iframeId)
    if (iframeObj) {
	    iframeObj.src=url;
	    //debugger;
	    $(iframeObj).hide();
	    if (iframeObj.attachEvent) {
		    iframeObj.attachEvent("onload", function(){
		        $(this).show();
		    });
	    } else {
		    iframeObj.onload = function(){
		        $(this).show();
		    };
	    }
    }
}