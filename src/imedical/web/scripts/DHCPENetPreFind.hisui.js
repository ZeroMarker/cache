//����	  DHCPENetPreFind.hisui.js
//����	  ����ԤԼ��ѯ	
//����	  2022.03.04
//������  xueying

$(function(){
	 
	InitCombobox();
	 
	InitNetPreFindGrid();
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
	});
        
	//����
	$("#BClear").click(function() {	
		BClear_click();		
	});
})

//��ѯ
function BFind_click(){
	$("#NetPreFindGrid").datagrid('load',{
		ClassName:"web.DHCPE.NetPre.PreFind",
		QueryName:"SerchPreInfo",
		StartDate:$("#StartDate").datebox('getValue'),
		EndDate:$("#EndDate").datebox('getValue'),
		VIPLevel:$("#VIPLevel").combobox('getValue'),
		LocID:session['LOGON.CTLOCID'],
		UserID:session['LOGON.USERID'],
		CSPName:"dhcpnetprefind.hisui.csp"
	});
}

//����
function BClear_click(){
	
	$("#StartDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$("#VIPLevel").combobox('setValue',"");
	BFind_click();
	
}

function BNetPreDetail(rowIndex,Type){
	
    var row = $('#NetPreFindGrid').datagrid('getRows');
    var DateInfo=row[rowIndex].TDate;
    var TimeInfo=row[rowIndex].TPreTime;
	var VIPID=row[rowIndex].TVIPID;
	
    $("#NetPreDetailWin").show();
	
	$HUI.window("#NetPreDetailWin",{
		title:"ԤԼ��ϸ",
		iconCls:'icon-w-list',
		minimizable:false,
		maximizable:false,
		collapsible:false,
		modal:true,
		width:1150,
		height:390
	});
	
	var NetPreDetailGridObj = $HUI.datagrid("#NetPreDetailGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		pageSize: 20,
		pageList : [20,100,200],
		queryParams:{
			ClassName:"web.DHCPE.NetPre.PreFind",
			QueryName:"SerchPreDetail",
			DateInfo:DateInfo,
			DetailType:Type,
			TimeInfo:TimeInfo,
			VIPDesc:VIPID
			
		},
		
		columns:[[
			{field:'TName',width:'150',title:'����'},
			{field:'TSex',width:'80',title:'�Ա�'},
			{field:'TAge',width:'80',title:'����'},
			{field:'TPACCardType',width:'150',title:'֤������'},
			{field:'TIDCard',width:'200',title:'֤����'},
			{field:'TTel',width:'120',title:'�绰'},
			{field:'TOrdEnt',width:'120',title:'�ײ�'},
			{field:'TDatetime',width:'150',title:'ʱ��'}	
			
		]]				
		
		})
	
	
}

function InitNetPreFindGrid(){
	
	$HUI.datagrid("#NetPreFindGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		
		queryParams:{
			ClassName:"web.DHCPE.NetPre.PreFind",
			QueryName:"SerchPreInfo",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			LocID:session['LOGON.CTLOCID'],
			UserID:session['LOGON.USERID'],
			CSPName:"dhcpnetprefind.hisui.csp"
		},
	
		columns:[[
		
			{field:'TVIPID',title:'TVIPID',hidden:true},
		    {field:'TDate',width:200,title:'����'},
			{field:'TPreTime',width:200,title:'ʱ���'},
			{field:'TNetINum',width:150,title:'Netδ����',
				formatter:function(value,rowData,rowIndex){	
					if((value!="0")&&(rowData.TDate!="")){
						var Type="NetNum";
						return "<a href='#'  class='grid-td-text'  onclick=BNetPreDetail('" + rowIndex + "','" + Type + "')>"+value+"</a>";
			
					}else{return value}		
	
			}},
			{field:'TNetToHisNum',width:150,title:'His�Ѵ���',
				formatter:function(value,rowData,rowIndex){	
					if((value!="0")&&(rowData.TDate!="")){
						var Type="NetToHisNum";
						return "<a href='#'  class='grid-td-text'  onclick=BNetPreDetail('" + rowIndex + "','" + Type + "')>"+value+"</a>";
			
					}else{return value}		
	
			}},
			{field:'THisINum',width:150,title:'His����',
				formatter:function(value,rowData,rowIndex){	
					if((value!="0")&&(rowData.TDate!="")){
						var Type="I";
						return "<a href='#'  class='grid-td-text'  onclick=BNetPreDetail('" + rowIndex + "','" + Type + "')>"+value+"</a>";
			
					}else{return value}
					
					
	
			}},
			{field:'THisGNum',width:150,title:'His����',
			formatter:function(value,rowData,rowIndex){	
				if((value!="0")&&(rowData.TDate!="")){
					var Type="G";
					return "<a href='#'  class='grid-td-text'  onclick=BNetPreDetail('" + rowIndex + "','" + Type + "')>"+value+"</a>";
			
				}else{return value}	
			}},
			{field:'TVIPDesc',width:150,title:'VIP�ȼ�'},
			{field:'TTemplateNum',width:200,title:'�޶�'}
		]]
	});
		
}

function InitCombobox()
{
	// VIP�ȼ�		
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		});
		
	
}


