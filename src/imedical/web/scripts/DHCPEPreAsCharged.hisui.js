//����	DHCPEPreAsCharged.hisui.js
//����	���֧��ͳ��
//����	2021.07.27
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
    
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEPreAsCharged.raq");
})


//����
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
		BFind_click()
}


//��ѯ
function BFind_click(){
	
	var BeginDate = "", EndDate = "", GroupDR = ""
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');

	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&CTLOCID=" + session['LOGON.CTLOCID']
			;
			
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEPreAsCharged.raq" + lnk);
	//document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName=DHCPEPreAsCharged.raq"+lnk;

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