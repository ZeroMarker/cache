//����	DHCPENoCheckDetail.hisui.js
//����	����Ѽ�δ����Ŀ��ѯ
//����	2019.06.11
//������  xy

$(function(){
			
	InitCombobox();
	
	InitNoCheckDetailDataGrid();  
     
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
}


//��ѯ
function BFind_click(){
	
	$("#NoCheckDetailGrid").datagrid('load',{
			ClassName:"web.DHCPE.Report.GetCheckInfo",
			QueryName:"CheckInfo",
			BeginDate:$("#BeginDate").datebox('getValue'),
		    EndDate:$("#EndDate").datebox('getValue'),
			StationID:$("#StationDesc").combobox('getValue'),
			
			ChcekStatus:$("#CheckStatus").combobox('getValue'),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			SexDR:$("#Sex").combobox('getValue'),
			AuditStatus:$("#AuditStatus").combobox('getValue'),
			AddItem:$("#AddItem").combobox('getValue'), 
			AdmStr:"",
			ArcimDR:$("#ArcimDesc").combogrid('getValue'),
			OrdStatusDR:$("#OrdStatus").combobox('getValue'),
		});	
}

function InitNoCheckDetailDataGrid(){

	$HUI.datagrid("#NoCheckDetailGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Report.GetCheckInfo",
			QueryName:"CheckInfo",

		},
		frozenColumns:[[
		
			{field:'str',title:'���Ԥ��',width:'70',align:'center',
			formatter:function(value,rowData,rowIndex){
				if(rowData.TPAADM!=""){
					return '<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" title="���Ԥ�� "  border="0" onclick="ResultView('+rowData.TPAADM+')"></a>';
			
				}
				}},
			{field:'TRegNo',width:'110',title:'�ǼǺ�'},
			{field:'TName',width:'100',title:'����'},
		]],
		columns:[[
		 	{field:'TPAADM',title:'PAADM',hidden: true},
			{field:'TSex',width:'60',title:'�Ա�'},
			{field:'TBirth',width:'100',title:'��������'},
			{field:'TAge',width:'60',title:'����'},
			{field:'TTel',width:'120',title:'�绰'},
			{field:'TGroupDesc',width:'200',title:'��������'},
			{field:'TVIPLevel',width:'80',title:'VIP�ȼ�'},
			{field:'TAuditStatus',width:'100',title:'�ύ״̬'},
			{field:'TCheckStatus',width:'100',title:'���״̬'},
			{field:'TItemName',width:'500',title:'������Ŀ'},	
			
		]]
			
	})	
}

//���Ԥ�� 
function ResultView(PAADM)
{
	var wwidth=1200;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var url="dhcpenewdiagnosis.diagnosis.hisui.csp?EpisodeID="+PAADM+"&MainDoctor="+""+"&OnlyRead="+"Y";
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(url,"_blank",nwin)
}

function InitCombobox(){
	
	//�Ա�
	var SexObj = $HUI.combobox("#Sex",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex',
		panelHeight:'130',
	});
	
	//VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
	
	//��Ŀ

		var ArcimDescObj = $HUI.combogrid("#ArcimDesc",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.Report.GetCheckInfo&QueryName=ListItem",
		mode:'remote',
		delay:200,
		idField:'ArcimDR',
		textField:'ArcimDesc',
		onBeforeLoad:function(param){
			
			var STId=$("#StationDesc").combobox('getValue');
			param.StationID = STId;
		},
		onShowPanel:function()
		{
			$('#ArcimDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
			 {field:'ArcimDR',title:'ID',width:80},
			{field:'ArcimDesc',title:'ҽ������',width:200},	
		]]
		});
		
	//վ��
	var StationObj = $HUI.combobox("#StationDesc",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		})	
	
		/*
	//����
	var RoomPlaceObj = $HUI.combobox("#RoomPlace",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindRoomPlace&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'130',
		})
	*/	
	//ҽ��״̬
	var OrdStatusObj = $HUI.combobox("#OrdStatus",{
		url:$URL+"?ClassName=web.DHCPE.Report.GetCheckInfo&QueryName=ListOrdStatus&ResultSetType=array",
		valueField:'id',
		textField:'OrdStatusDesc',
		panelHeight:'130',
	});
		
	//ҽ������
	var AddItemObj = $HUI.combobox("#AddItem",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'0',text:'ԤԼ'},
            {id:'1',text:'����'},
           
        ]

	});	
			
	//�ύ״̬
	var AuditStatusObj = $HUI.combobox("#AuditStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'1',text:'δ�ύ'},
            {id:'2',text:'���ύ'},
           
        ]

	});	
	
	//���״̬
	var CheckStatusObj = $HUI.combobox("#CheckStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'130',
		data:[
            {id:'0',text:'л�����'},
            {id:'1',text:'δ��'},
            {id:'2',text:'�����Ҳ����Ѽ�'},
            {id:'3',text:'������ȫ���Ѽ�'},
           
        ]

	});	
}