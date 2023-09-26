//����	DHCPEStationIncomeStatistic.hisui.js
//����	��������ͳ��
//����	2019.11.29
//������  yp

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
	$(".hisui-combobox").combobox('setValue',"");
	$(".hisui-combogrid").combogrid('setValue',"");
	
	InitCombobox();
	BFind_click();
}


//��ѯ
function BFind_click(){
	var BeginDate = "", EndDate = "", GroupDR = "", ShowFlag = "";
	var BeginDate = $("#BeginDate").datebox('getValue');
	/*if (BeginDate == "") {
		$.messager.alert("��ʾ","�����뿪ʼ���ڣ�");
		//$.messager.popover({msg:"�����뿪ʼ���ڣ�", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}*/
	
	var EndDate = $("#EndDate").datebox('getValue');
	/*if (EndDate == "") {
		$.messager.alert("��ʾ","������������ڣ�");
		//$.messager.popover({msg:"������������ڣ�", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}*/
	
	var GroupDR = $("#GroupName").combogrid("getValue");
	if (GroupDR == undefined || GroupDR == "undefined") { var GroupDR = ""; }
	
	var CurLoc = session["LOGON.CTLOCID"];
	
	var src = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&GroupDR=" + GroupDR
			+ "&CTLOCID=" + CurLoc
			;
	
	document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEStationIncomeStatistic.raq" + src;
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
			param.ShowPersonGroup="1";
		},
		columns:[[
			{field:'TRowId',title:'����ID',width:80},
			{field:'TGDesc',title:'��������',width:140},
			{field:'TGStatus',title:'״̬',width:100},
			{field:'TAdmDate',title:'����',width:100}		
		]]
	})
}