//����	DHCPEFeeStatistic.hisui.js
//����	������ͳ��
//����	2020.02.24
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
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEFeeStatistic.raq");
});

//����
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$(".hisui-combobox").combobox('setValue',"");
	$("#GroupName").combogrid('setValue',"");
	
	$("#ShowFlag").combobox('setValue',"Item");
	InitCombobox();
	BFind_click();
}

//��ѯ
function BFind_click(){
	var BeginDate = "", EndDate = "", GroupDR = "", ShowFlag = "", reportName = "";
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate = $("#EndDate").datebox('getValue');

	var GroupDR=$("#GroupName").combogrid("getValue");
	if (GroupDR == "undefined" || GroupDR == undefined) {var GroupDR="";}
	
	var ShowFlag = $("#ShowFlag").combogrid("getValue");
	if (ShowFlag == "Item") reportName = "DHCPEFeeStatistic.raq";
	else if (ShowFlag == "User") reportName = "DHCPEFeeStatistic1.raq";
	else { alert("��ѡ���ѯ���ͣ�"); return false;}
	
	var CurLoc = session["LOGON.CTLOCID"];	
	
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&GroupDR=" + GroupDR
			+ "&ShowFlag=" + ShowFlag
			+ "&CurLoc=" + CurLoc
			;
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=" + reportName + lnk);
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;
}
function InitCombobox(){
	
	//����
	var GroupNameObj = $HUI.combogrid("#GroupName",{
		panelWidth:450,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//���   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},
		columns:[[
			{field:'TRowId',title:'����ID',width:80},
			{field:'TGDesc',title:'��������',width:140},
			{field:'TGStatus',title:'״̬',width:100},
			{field:'TAdmDate',title:'����',width:100}		
		]]
	})
	
	// ��ѯ����
	$HUI.combobox("#ShowFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'Item',text:$g('��ҽ����ѯ'),selected:true},
			{id:'User',text:$g('����Ա��ѯ')}
		]
	});
}