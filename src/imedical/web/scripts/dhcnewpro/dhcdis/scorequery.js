/// Creator: zhanghailong
/// CreateDate: 2017-01-25

$(document).ready(function() {

	//初始化时间控件
	//initDate();
	
	//初始化combo
	initCombo();
	
	//初始化easyui datagrid
	initTable();
	
	//初始化控件绑定的事件
	initMethod();
	
	//初始化easyui datagrid
	initTableList();

});

//初始化时间框
function initDate(){
	$('#StrDate').datebox("setValue",formatDate(0));
	$('#EndDate').datebox("setValue",formatDate(0));	
}

//初始化datagrid
function initTable(){
	
	var columns = [[
	 {field: 'acceptLoc',align: 'center',title: '科室',width: 200},
     {field: 'pepleNo',align: 'center',title: '人员工号',width: 130},
     {field: 'pepeleName',align: 'center',title: '人员姓名',width: 200},
     {field: 'totalScore', align: 'center',title: '总得分',width: 200},
     {field: 'general', align: 'center',title: '总评次数', width: 200},
     { field: 'average', align: 'center',title: '均分',width: 200,formatter:Average },
     { field:'Check',title:'查看',align: 'center', width:200,formatter:CheckResult} 
     ]]
    
    $('#cspscorequeryTb').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISScoreQuery&MethodName=ListPeScore',
	    fit:true,
	    rownumbers:true,
	    columns:columns,
	    pageSize:20, // 每页显示的记录条数
	    pageList:[20,40],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true
	})
}

//初始化datagrid
function initTableList(){
	
	var columns = [[
     {field: 'UserName',align: 'center',title: '人员姓名',width: 200},
     {field: 'itmdrdesc',align: 'center',title: '项目名称',width: 200},
     {field: 'LocDesc',align: 'center',title: '去向科室',width: 200},
     {field: 'score', align: 'center',title: '得分',width: 200}
     ]]
    
    $('#cspscorelistTb').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISScoreQuery&MethodName=GetScores&UserDr='+UserDrid,
	    fit:true,
	    rownumbers:true,
	    columns:columns,
	    pageSize:20, // 每页显示的记录条数
	    pageList:[20,40],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true
	})
}

///求算均分
function  Average(value,rowData,rowIndex){
	return (rowData.totalScore/rowData.general).toFixed(2);
}

///查看明细
function  CheckResult(value,rowData,rowIndex){
    return "<a href='#' onclick='showHisResultWin("+rowIndex+");'>查看明细</a>";  
}

function showHisResultWin(rowIndex)
{
	var UserDrid=$("tr[datagrid-row-index="+rowIndex+"] "+"td[field=pepleNo]").text();
	
	window.open("dhcdis.scorelist.csp?UserDr="+UserDrid,'','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=850,height=450,left=250,top=130');
}

function initCombo(){
	$('#ApplayLoc').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISScoreQuery&MethodName=GetApplayLoc&HospID="+hosp,
		valueField:'id',    
	    textField:'text'
	});
	
	$('#Score').combobox({
		//url:LINK_CSP+"?ClassName=web.DHCDISScoreQuery&MethodName=GetListScore",
		panelHeight:'auto',
		valueField:'id',    
	    textField:'text' ,
	    data:[
	        {id:'1',text:'1'},
		    {id:'2',text:'2'},
		    {id:'3',text:'3'},
		    {id:'4',text:'4'},
		    {id:'5',text:'5'}
	    ]
	});
}

function initMethod(){
 	 $('#searchBtn').bind('click',search) //查找	
}


/*======================================================*/

//查询
function search(){
	
	 var param=getParam()
	alert(param)
    $('#cspscorequeryTb').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISScoreQuery&MethodName=ListPeScore&Param='+param,
	    fit:true,
	    rownumbers:true,
	    //columns:columns,
	    pageSize:20, // 每页显示的记录条数
	    pageList:[20,40],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true
	})
}

//Table请求参数
//return ：开始时间^结束时间^申请科室^状态
function getParam(){
	var stDate = $('#StrDate').datetimebox('getValue');
	var endDate=$('#EndDate').datetimebox('getValue');
	var applayLocDr= $('#ApplayLoc').combobox('getText');;
	var Score = $('#Score').combobox('getText');;
	return stDate+"^"+endDate+"^"+applayLocDr+"^"+Score
}