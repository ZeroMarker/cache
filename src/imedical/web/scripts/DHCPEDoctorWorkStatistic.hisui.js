//����	DHCPEDoctorWorkStatistic.hisui.js
//����	ҽ��������ͳ��
//����	2019.10.30
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
	$("#DocNo").val("");
	$("#BeginDate,#EndDate").datebox('setValue')
	$(".hisui-combobox").combobox('setValue',"");
	//$(".hisui-combogrid").combogrid('setValue',"");
	$("#DocName").combogrid('setValue',"");
	$("#GroupName").combogrid('setValue',"");
	$("#StationName").combogrid('setValue',"");
	$("#OEItemDesc").combogrid('setValue',"");
	
	$("#ShowFlag").combobox('setValue',"Item");
	InitCombobox();
	BFind_click();
}


//��ѯ
function BFind_click(){
	var BeginDate="",EndDate="",DocNo="",DocDR="",GroupDR="",StationDR="",OEItem="",reportName = "";
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');

	var DocNo=$("#DocNo").val();
	var DocDR=$("#DocName").combogrid("getValue");
	if (DocDR == undefined || DocDR == "undefined") { var DocDR = ""; }
	
	var GroupDR=$("#GroupName").combogrid("getValue");
	if (GroupDR == undefined || GroupDR == "undefined") { var GroupDR = ""; }
	
	var StationDR=$("#StationName").combogrid("getValue");
	if (StationDR == undefined || StationDR == "undefined") { var StationDR = ""; }
	
	var OEItem=$("#OEItemDesc").combogrid("getValue");
	if (OEItem == undefined || OEItem == "undefined") { var OEItem = ""; }
	
	var VIPLevel=$("#VIPLevel").combobox('getValue');
	if (VIPLevel==undefined) {var VIPLevel="";}
	
	var ShowFlag = $("#ShowFlag").combogrid("getValue");
	if (ShowFlag == "Item") reportName = "DHCPEDoctorWorkStatistic.raq";
	else if (ShowFlag == "Person") reportName = "DHCPEDocPerWorkStatistic.raq";
	else { alert("��ѡ���ѯ���ͣ�"); return false;}
	
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&DocNo=" + DocNo
			+ "&DocDR=" + DocDR
			+ "&GroupDR=" + GroupDR
			+ "&StationDR=" + StationDR
			+ "&OEItem=" + OEItem
			+ "&VIPLevel=" + VIPLevel
			+ "&ShowFlag=" + ShowFlag
			;
	
	document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;
	
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
	
	//վ������
	var StationNameObj = $HUI.combogrid("#StationName",{
		panelWidth:440,
		panelHeight:245,
		url:$URL+"?ClassName=web.DHCPE.Station&QueryName=FromDescToStation",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//���   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'ST_RowId',
		textField:'ST_Desc',
        onBeforeLoad:function(param){
			param.StationDesc = param.q;
		},
         onChange:function(newValue, oldValue)
		{
			var ItemID = $("#OEItemDesc").combogrid("getValue");
			var Flag=tkMakeServerCall("web.DHCPE.HISUICommon","GetStationFlag",newValue,ItemID);
			if (Flag==0) {
			    $("#OEItemDesc").combogrid('setValue',"");
			}
			
		},			
		columns:[[
			{field:'ST_Desc',title:'վ������',width:80},
			{field:'ST_RowId',title:'վ��ID',width:140},
			{field:'ST_Code',title:'վ�����',width:100}		
		]]
	})
	
	//�����Ŀ
	var OEItemDescObj = $HUI.combogrid("#OEItemDesc",{
		panelWidth:450,
		panelHeight:245,
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
			var StationId=$("#StationName").combogrid("getValue");
			param.Station = StationId;
		},
        onShowPanel:function()
		{
			$('#OEItemDesc').combogrid('grid').datagrid('reload');
		},		
		columns:[[
			{field:'Code',title:'����',width:80},
			{field:'desc',title:'����',width:180},
			{field:'id',title:'ID',width:80}         		
		]]
	})
	
	//ҽ������
	var DocNameObj = $HUI.combogrid("#DocName",{
		panelWidth:400,
		panelHeight:240,
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindDocUser",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//���   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'UserID',
		textField:'UserName',	
        onBeforeLoad:function(param){
			param.Desc = param.q;
		},		
		columns:[[
			{field:'UserCode',title:'�û�ID',width:80},
			{field:'UserName',title:'����',width:160},
			{field:'UserID',title:'ID',width:80}		
		]]
	});
	
	// ��ѯ����
	$HUI.combobox("#ShowFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'Item',text:'��ҽ����ѯ',selected:true},
			{id:'Person',text:'���˲�ѯ'}
		]
	});
}