//����	DHCPEAsCharged.hisui.js
//����	��ͬ�շ�δ���Ѳ�ѯ�����ˣ�
//����	2021.01.19
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
		
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEAsCharged.raq");
})


//����
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
		BFind_click()
}


//��ѯ
function BFind_click(){
	
	var BeginDate = "", EndDate = "";
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');

	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&CTLOCID=" + session['LOGON.CTLOCID']
			;
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEAsCharged.raq" + lnk);
	//document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName=DHCPEAsCharged.raq"+lnk;

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
