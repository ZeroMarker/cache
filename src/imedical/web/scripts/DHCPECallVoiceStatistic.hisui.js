//����	DHCPECallVoiceStatistic.hisui.js
//����	���к�ͳ��
//����	2019.09.09
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
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEStatisticCallVoice.raq");
})


//����
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	
	$("#ShowFlag").combobox('setValue',"User");
	BFind_click();
}


//��ѯ
function BFind_click(){
	var BeginDate = "", EndDate = "", ShowFlag = "", reportName = "";   
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	
	var ShowFlag = $("#ShowFlag").combogrid("getValue");
	if (ShowFlag == "User") reportName = "DHCPEStatisticCallVoice.raq";
	else if (ShowFlag == "Doc") reportName = "DHCPECallVoiceDocStatistic.raq";
	else { alert("��ѡ���ѯ���ͣ�"); return false;}
	
	var CurLoc = session["LOGON.CTLOCID"];
	var CurUser = session["LOGON.USERID"];
	
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&CurUser=" + CurUser
			+ "&CurLoc=" + CurLoc			
			;
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=" + reportName + lnk);
}

function InitCombobox(){
	
	// ��ѯ����
	$HUI.combobox("#ShowFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'User',text:$g('����Ա��ѯ'),selected:true},
			{id:'Doc',text:$g('��ҽ����ѯ')}
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
