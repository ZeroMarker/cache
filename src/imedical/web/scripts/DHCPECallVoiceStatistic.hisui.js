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
	
	var CTLOCID = session["LOGON.CTLOCID"];
	var GROUPID = session["LOGON.GROUPID"];
	var USERID = session["LOGON.USERID"];
	
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&USERID=" + USERID
			+ "&CTLOCID=" + CTLOCID			
			;
	document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;

}

function InitCombobox(){
	
	// ��ѯ����
	$HUI.combobox("#ShowFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'User',text:'����Ա��ѯ',selected:true},
			{id:'Doc',text:'��ҽ����ѯ'}
		]
	});
}

