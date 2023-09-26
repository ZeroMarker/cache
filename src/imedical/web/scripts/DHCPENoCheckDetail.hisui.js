//名称	DHCPENoCheckDetail.hisui.js
//功能	体检已检未检项目查询
//创建	2019.06.11
//创建人  xy

$(function(){
			
	InitCombobox();
	
	InitNoCheckDetailDataGrid();  
     
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
})


//清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$(".hisui-combobox").combobox('setValue',"");
	$(".hisui-combogrid").combogrid('setValue',"");
}


//查询
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
		
			{field:'str',title:'结果预览',width:'70',align:'center',
			formatter:function(value,rowData,rowIndex){
				if(rowData.TPAADM!=""){
					return '<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" title="结果预览 "  border="0" onclick="ResultView('+rowData.TPAADM+')"></a>';
			
				}
				}},
			{field:'TRegNo',width:'110',title:'登记号'},
			{field:'TName',width:'100',title:'姓名'},
		]],
		columns:[[
		 	{field:'TPAADM',title:'PAADM',hidden: true},
			{field:'TSex',width:'60',title:'性别'},
			{field:'TBirth',width:'100',title:'出生日期'},
			{field:'TAge',width:'60',title:'年龄'},
			{field:'TTel',width:'120',title:'电话'},
			{field:'TGroupDesc',width:'200',title:'团体名称'},
			{field:'TVIPLevel',width:'80',title:'VIP等级'},
			{field:'TAuditStatus',width:'100',title:'提交状态'},
			{field:'TCheckStatus',width:'100',title:'检查状态'},
			{field:'TItemName',width:'500',title:'加项项目'},	
			
		]]
			
	})	
}

//结果预览 
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
	
	//性别
	var SexObj = $HUI.combobox("#Sex",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex',
		panelHeight:'130',
	});
	
	//VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
	
	//项目

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
			{field:'ArcimDesc',title:'医嘱名称',width:200},	
		]]
		});
		
	//站点
	var StationObj = $HUI.combobox("#StationDesc",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		})	
	
		/*
	//诊室
	var RoomPlaceObj = $HUI.combobox("#RoomPlace",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindRoomPlace&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'130',
		})
	*/	
	//医嘱状态
	var OrdStatusObj = $HUI.combobox("#OrdStatus",{
		url:$URL+"?ClassName=web.DHCPE.Report.GetCheckInfo&QueryName=ListOrdStatus&ResultSetType=array",
		valueField:'id',
		textField:'OrdStatusDesc',
		panelHeight:'130',
	});
		
	//医嘱类型
	var AddItemObj = $HUI.combobox("#AddItem",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'0',text:'预约'},
            {id:'1',text:'加项'},
           
        ]

	});	
			
	//提交状态
	var AuditStatusObj = $HUI.combobox("#AuditStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'1',text:'未提交'},
            {id:'2',text:'已提交'},
           
        ]

	});	
	
	//检查状态
	var CheckStatusObj = $HUI.combobox("#CheckStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'130',
		data:[
            {id:'0',text:'谢绝检查'},
            {id:'1',text:'未检'},
            {id:'2',text:'本科室部分已检'},
            {id:'3',text:'本科室全部已检'},
           
        ]

	});	
}