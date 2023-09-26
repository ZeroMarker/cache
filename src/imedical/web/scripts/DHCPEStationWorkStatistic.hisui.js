//����	DHCPEStationWorkStatistic.hisui.js
//����	���ҹ�����ͳ��
//����	2019.11.16
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
	$(".hisui-combobox").combobox('setValue',"");
	//$(".hisui-combogrid").combogrid('setValue',"");
	$("#GroupName").combogrid('setValue',"");
	$("#LocDesc").combogrid('setValue',"");
	$("#OEItemDesc").combogrid('setValue',"");
	
	$("#PayFlag").combobox('setValue',"");
	$("#ShowFlag").combobox('setValue',"Item");
	InitCombobox();
	BFind_click();
}


//��ѯ
function BFind_click(){
	var BeginDate = "", EndDate = "", GroupDR = "", LocDR="", VIPLevel="", OEItem="", PayFlag="", ShowFlag = "", reportName = "";
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	var GroupDR=$("#GroupName").combogrid("getValue");
	if (GroupDR == undefined || GroupDR == "undefined") { var GroupDR = ""; }
	
	var LocDR=$("#LocDesc").combogrid("getValue");
	if (LocDR == undefined || LocDR == "undefined") { var LocDR = ""; }
	
	var OEItem=$("#OEItemDesc").combogrid("getValue");
	if (OEItem == undefined || OEItem == "undefined") { var OEItem = ""; }
	
	var VIPLevel=$("#VIPLevel").combobox('getValue');
	if (VIPLevel==undefined) {var VIPLevel="";}
	var PayFlag = $("#PayFlag").combogrid("getValue");
	
	var ShowFlag = $("#ShowFlag").combogrid("getValue");
	if (ShowFlag == "Item") reportName = "DHCPEStationWorkStatistic.raq";
	else if (ShowFlag == "Coll") reportName = "DHCPEStationWorkCollStatistic.raq";
	else { alert("��ѡ���ѯ���ͣ�"); return false;}
	
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&GroupDR=" + GroupDR
			+ "&LocDR=" + LocDR
			+ "&OEItem=" + OEItem
			+ "&VIPLevel=" + VIPLevel
			+ "&PayFlag=" + PayFlag
			+ "&ShowFlag=" + ShowFlag
			;

	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName=" + reportName + lnk;
}

function InitCombobox(){
	
	//VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
	
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
	
	//����
	var LocDescObj = $HUI.combogrid("#LocDesc",{
		panelWidth:450,
		panelHeight:243,
		url:$URL+"?ClassName=web.DHCPE.Report.StationWorkStatistic&QueryName=SearchLoc",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//���   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'CTLOC_RowId',
		textField:'CTLOC_Desc',	
        onBeforeLoad:function(param){
			param.Desc = param.q;
		},		
		columns:[[
			{field:'CTLOC_Code',title:'����',width:100},
			{field:'CTLOC_Desc',title:'����',width:140},
			{field:'CTLOC_RowId',title:'ID',width:80}		
		]]
	})
	
	//�����Ŀ
	var OEItemDescObj = $HUI.combogrid("#OEItemDesc",{
		panelWidth:450,
		panelHeight:243,
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationOrder",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//���   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'id',
		textField:'desc',
        onBeforeLoad:function(param){
			param.Desc = param.q;
		},		
		columns:[[
			{field:'Code',title:'����',width:80},
			{field:'desc',title:'����',width:180},
			{field:'id',title:'ID',width:80} 			
		]]
	})
	
	// ���ѱ�־
	$HUI.combobox("#PayFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
		    {id:'',text:'����',selected:true},
			{id:'Y',text:'�Ѹ���'},
			{id:'N',text:'δ����'}
		]
	});
	
	// ��ѯ����
	$HUI.combobox("#ShowFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'Item',text:'��ҽ����ʾ',selected:true},
			{id:'Coll',text:'ֻ��ʾ����'}
		]
	});
	
}