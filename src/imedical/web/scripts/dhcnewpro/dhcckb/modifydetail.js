///Creator:	xww
///Date:	2021-06-19
///Desc:	处方数量明细查询
var regNo = "";
var stDate = "";
var edDate = "";
var locName = "";
$(function(){
	
	initParams();
	
	initDataGrid();
	
})

function initParams(){
	stDate = getParam("stDate");   /// 开始日期
	edDate = getParam("edDate");   /// 结束日期
	locName = getParam("locName"); /// 科室名称
	locName = decodeURI(locName);
	type = getParam("type");   /// 类型
}


function initDataGrid(){

	var params = stDate + "^" + edDate  + "^" + locName + "^" + type;
	var columns= [[
		{field:'monId',title:'监测主表id',width:100,hidden:true},
		{field:'seqNo',title:'序号',width:40,hidden:false},
		{field:'patName',title:'患者姓名',width:70,hidden:false},
		{field:'PatSex',title:'性别',width:50,hidden:false},
		{field:'PatAge',title:'年龄',width:50,hidden:false},
		{field:'regNo',title:'登记号',width:100,hidden:false},
		{field:'Diagnosis',title:'诊断',width:120,hidden:false},
		{field:'PAAdmDate',title:'就诊日期',width:90,hidden:false},
		{field:'CMCreateDate',title:'审查日期',width:90,hidden:false},
		{field:'CMCreateTime',title:'审查时间',width:80,hidden:false},
		//{field:'locName',title:'查看',width:100,hidden:false,formatter:setCellEditSymbol},
	]];
	
	$HUI.datagrid('#datagrid',{
		url:'dhcapp.broker.csp?ClassName=web.DHCCKBRecipeAuditStat&MethodName=PrescModifyData',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  
		pageList:[30,60,90], 
		loadMsg: '正在加载信息...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:'处方修改患者信息', 
		iconCls:'icon-paper',
		headerCls:'panel-header-gray', //ed
		queryParams:{
			params:params,
		},
		onClickRow:function(rowIndex, rowData){
			showDrugDetail(rowData.monId)
		},
		onLoadSuccess:function(data){
			
		}
    })

}



function setCellEditSymbol(value, rowData, rowIndex){	
	return "<a href='#' onclick=\"showEditWin('"+rowData+"')\"><img src='../scripts/dhcadvEvt/images/adv_sel_8.png' border=0/></a>";
}

function showDrugDetail(monid){
	runClassMethod("web.DHCCKBRecipeAuditStat","PrescModifyDetail",{"monId":monid},function(jsonString){
		var Data=jsonString;
		showDrugDetailhtml(Data)
	},"json")
}

function showDrugDetailhtml(Data){
	var datalength = Data.length //处方修改次数
	var headhtml = "<tr>"
	var headhtml = headhtml + "<th style='background-color:#F0EDED;width:40%'>" + "药品名称" + "</th>"
	var headhtml = headhtml + "<th style='background-color:#F0EDED;width:15%'>" + "频次" + "</th>"
	var headhtml = headhtml + "<th style='background-color:#F0EDED;width:15%'>" + "给药途径" + "</th>"
	var headhtml = headhtml + "<th style='background-color:#F0EDED;width:15%'>" + "剂量" + "</th>"
	var headhtml = headhtml + "<th style='background-color:#F0EDED;width:15%'>" + "疗程" + "</th>"
	var headhtml = headhtml + "</tr>"
	var htmlStr = ""
	for(j = 0; j < datalength; j++){
		htmlStr = htmlStr+"第"+(j+1)+"次审核处方";
		htmlStr = htmlStr + "<table class='easyui-datagrid' style='width:100%'>";
		htmlStr = htmlStr + headhtml
		var subData = Data[j]
		for (i = 0; i < subData.length; i++){
			htmlStr=htmlStr+"<tr>"
			htmlStr=htmlStr+"<td style='background-color:#F0EDED;text-align:center;height:40px;'>"+subData[i].drugName+"</td>"
			htmlStr=htmlStr+"<td style='background-color:#F0EDED;text-align:center;height:40px;'>"+subData[i].drugFreq+"</td>"
			htmlStr=htmlStr+"<td style='background-color:#F0EDED;text-align:center;height:40px;'>"+subData[i].drugPreMet+"</td>"
			htmlStr=htmlStr+"<td style='background-color:#F0EDED;text-align:center;height:40px;'>"+subData[i].dose+"</td>"
			htmlStr=htmlStr+"<td style='background-color:#F0EDED;text-align:center;height:40px;'>"+subData[i].treatment+"</td>"
			htmlStr=htmlStr+"</tr>"
			
		}
		htmlStr=htmlStr+"</table>";
			
	}
	$("#datagriddetail").html(htmlStr)
}