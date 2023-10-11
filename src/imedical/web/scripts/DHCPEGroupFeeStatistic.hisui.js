//����	DHCPEGroupFeeStatistic.hisui.js
//����	�������ͳ��
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

	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEGroupFeeStatistic.raq");
});

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
		
	var GADM=$("#GADM").combogrid("getValue");
	if (GADM == "undefined" || GADM == undefined) {var GADM="";}

	var lnk = "&BeginDate="+$("#BeginDate").datebox('getValue')
			+ "&EndDate="+$("#EndDate").datebox('getValue')
			+ "&GADM="+GADM
			+ "&CTLOCID="+session['LOGON.CTLOCID'];
	//alert(lnk)
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEGroupFeeStatistic.raq" + lnk);
	// document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName=DHCPEGroupFeeStatistic.raq"+lnk;
}

function InitCombobox(){
	
	//����
	var GroupNameObj = $HUI.combogrid("#GADM",{
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
	});
}