//����	DHCPECompainStatistic.hisui.js
//����	���Ͷ�����ͳ��
//����	2023.02.15
//������  ln

$(function(){
			
	InitCombobox();
	
     
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
     
    $("#Type").combobox('setValue','C'); 

    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEComplainStatistic.raq");
})


//����
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$(".hisui-combobox").combobox('setValue',"");
	
	InitCombobox();
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEComplainStatistic.raq");
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEComplainStatistic.raq";
}


//��ѯ
function BFind_click(){
	var BeginDate = "", EndDate = "", Type="";
	var BeginDate=$("#BeginDate").datebox('getValue');
    var EndDate = $("#EndDate").datebox('getValue');
		
	var Type=$("#Type").combobox('getValue');
	if (Type==undefined) {var Type="";}
		
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&Type=" + Type
			+ "&CurLoc=" + session['LOGON.CTLOCID']
			;
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEComplainStatistic.raq" + lnk);
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEComplainStatistic.raq" + lnk;

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
function InitCombobox(){
	
    //����	
	var TypeObj = $HUI.combobox("#Type",{
        valueField:'id',
        textField:'text',
        panelHeight:'70',
        data:[
           {id:'C',text:$g('Ͷ��')}  
        ]

    });
	
	
	
}