//名称	  DHCPENetPreFind.hisui.js
//功能	  网上预约查询	
//创建	  2022.03.04
//创建人  xueying

$(function(){
	 
	InitCombobox();
	 
	InitNetPreFindGrid();
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
	});
        
	//清屏
	$("#BClear").click(function() {	
		BClear_click();		
	});
})

//查询
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

//清屏
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
		title:"预约明细",
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
			{field:'TName',width:'150',title:'姓名'},
			{field:'TSex',width:'80',title:'性别'},
			{field:'TAge',width:'80',title:'年龄'},
			{field:'TPACCardType',width:'150',title:'证件类型'},
			{field:'TIDCard',width:'200',title:'证件号'},
			{field:'TTel',width:'120',title:'电话'},
			{field:'TOrdEnt',width:'120',title:'套餐'},
			{field:'TDatetime',width:'150',title:'时间'}	
			
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
		    {field:'TDate',width:200,title:'日期'},
			{field:'TPreTime',width:200,title:'时间段'},
			{field:'TNetINum',width:150,title:'Net未处理',
				formatter:function(value,rowData,rowIndex){	
					if((value!="0")&&(rowData.TDate!="")){
						var Type="NetNum";
						return "<a href='#'  class='grid-td-text'  onclick=BNetPreDetail('" + rowIndex + "','" + Type + "')>"+value+"</a>";
			
					}else{return value}		
	
			}},
			{field:'TNetToHisNum',width:150,title:'His已处理',
				formatter:function(value,rowData,rowIndex){	
					if((value!="0")&&(rowData.TDate!="")){
						var Type="NetToHisNum";
						return "<a href='#'  class='grid-td-text'  onclick=BNetPreDetail('" + rowIndex + "','" + Type + "')>"+value+"</a>";
			
					}else{return value}		
	
			}},
			{field:'THisINum',width:150,title:'His个人',
				formatter:function(value,rowData,rowIndex){	
					if((value!="0")&&(rowData.TDate!="")){
						var Type="I";
						return "<a href='#'  class='grid-td-text'  onclick=BNetPreDetail('" + rowIndex + "','" + Type + "')>"+value+"</a>";
			
					}else{return value}
					
					
	
			}},
			{field:'THisGNum',width:150,title:'His团体',
			formatter:function(value,rowData,rowIndex){	
				if((value!="0")&&(rowData.TDate!="")){
					var Type="G";
					return "<a href='#'  class='grid-td-text'  onclick=BNetPreDetail('" + rowIndex + "','" + Type + "')>"+value+"</a>";
			
				}else{return value}	
			}},
			{field:'TVIPDesc',width:150,title:'VIP等级'},
			{field:'TTemplateNum',width:200,title:'限额'}
		]]
	});
		
}

function InitCombobox()
{
	// VIP等级		
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		});
		
	
}


