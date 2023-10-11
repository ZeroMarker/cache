///Creator:	xww
///Date:	2021-06-19
///Desc:	����������ϸ��ѯ
var regNo = "";
var stDate = "";
var edDate = "";
var locName = "";
$(function(){
	
	initParams();
	
	initDataGrid();
	
})

function initParams(){
	stDate = getParam("stDate");   /// ��ʼ����
	edDate = getParam("edDate");   /// ��������
	locName = getParam("locName"); /// ��������
	locName = decodeURI(locName);
	type = getParam("type");   /// ����
}


function initDataGrid(){

	var params = stDate + "^" + edDate  + "^" + locName + "^" + type;
	var columns= [[
		{field:'monId',title:'�������id',width:100,hidden:true},
		{field:'seqNo',title:'���',width:40,hidden:false},
		{field:'patName',title:'��������',width:70,hidden:false},
		{field:'PatSex',title:'�Ա�',width:50,hidden:false},
		{field:'PatAge',title:'����',width:50,hidden:false},
		{field:'regNo',title:'�ǼǺ�',width:100,hidden:false},
		{field:'Diagnosis',title:'���',width:120,hidden:false},
		{field:'PAAdmDate',title:'��������',width:90,hidden:false},
		{field:'CMCreateDate',title:'�������',width:90,hidden:false},
		{field:'CMCreateTime',title:'���ʱ��',width:80,hidden:false},
		//{field:'locName',title:'�鿴',width:100,hidden:false,formatter:setCellEditSymbol},
	]];
	
	$HUI.datagrid('#datagrid',{
		url:'dhcapp.broker.csp?ClassName=web.DHCCKBRecipeAuditStat&MethodName=PrescModifyData',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  
		pageList:[30,60,90], 
		loadMsg: '���ڼ�����Ϣ...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:'�����޸Ļ�����Ϣ', 
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
	var datalength = Data.length //�����޸Ĵ���
	var headhtml = "<tr>"
	var headhtml = headhtml + "<th style='background-color:#F0EDED;width:40%'>" + "ҩƷ����" + "</th>"
	var headhtml = headhtml + "<th style='background-color:#F0EDED;width:15%'>" + "Ƶ��" + "</th>"
	var headhtml = headhtml + "<th style='background-color:#F0EDED;width:15%'>" + "��ҩ;��" + "</th>"
	var headhtml = headhtml + "<th style='background-color:#F0EDED;width:15%'>" + "����" + "</th>"
	var headhtml = headhtml + "<th style='background-color:#F0EDED;width:15%'>" + "�Ƴ�" + "</th>"
	var headhtml = headhtml + "</tr>"
	var htmlStr = ""
	for(j = 0; j < datalength; j++){
		htmlStr = htmlStr+"��"+(j+1)+"����˴���";
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