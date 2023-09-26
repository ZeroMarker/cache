/**
 * 评估统计 dhchm.evaluationstatistic.js
 * @Author   wangguoying
 * @DateTime 2019-06-03
 */

var CategoryLeveObj = $HUI.combobox("#CategoryLeve",{
		url:$URL+"?ClassName=web.DHCHM.EvaluationStatistic&QueryName=FindTblTree&CodeType=1004&ResultSetType=array",
		valueField:'id',
		textField:'text',
		onSelect:function(record){
			initHumClass(record.id);
		}
	});
var HumClassObj ;
function initHumClass(type){
	HumClassObj = $HUI.combobox("#HumClass",{
		url:$URL+"?ClassName=web.DHCHM.HMCodeConfig&QueryName=FindHumClass&ResultSetType=array&CodeType="+type,
		valueField:'ID',
		textField:'HCDesc',
		onSelect:function(record){
		}
	});

}
var StatisticDataGrid=$HUI.datagrid("#StatisticList",{
		url:$URL,
		title:"",
		border : false,
		bodyCls:'panel-body-gray',
		singleSelect:true,
		queryParams:{
			ClassName:"web.DHCHM.EvaluationStatistic",
			QueryName:"FindBaseInfoByType",
		},
		onSelect:function(rowIndex,rowData){
			
		},
		onDblClickRow:function(index,row){
																	
		},	
		columns:[[
			{field:'OQEId',hidden:true,sortable:'true'},
			{field:'vBIPAPMINo',width:100,title:'登记号'},
			{field:'vName',width:100,title:'姓名'},
			{field:'SexDesc',width:80,title:'性别'},
			{field:'Date',width:100,title:'日期'},
			{field:'EducationDesc',hidden:true,title:'学历'},
			{field:'MaritalDesc',hidden:true,title:'婚姻'}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:20,
		fit:true,
		rownumbers:true
	});

function find_click(){
	var HumClass=$("#HumClass").combobox("getValue");
	var BeginDate=$("#BeginDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	if(HumClass==""){
		//$.messager.alert("提示","人员类型不能为空","info");
		//return false;
	}
	
	StatisticDataGrid.load({ClassName:"web.DHCHM.EvaluationStatistic",QueryName:"FindBaseInfoByType",VStartDate:BeginDate,VEndDate:EndDate,HCId:HumClass});
}

function init(){
	//setLayoutSize();
}
function setLayoutSize(){
	var dHeight=$(document).height();
	$("#TabDiv").height(dHeight-160);
	$("#StatisticList").datagrid("resize");
	$("#StatisticList").datagrid('getPanel').css("border-radius",0)// 去掉表格圆角样式
}
$(init);