/// Creator: guoguomin
/// CreateDate: 2017-02-7

$(document).ready(function() {

	//初始化时间控件
	//initDate();
	
	//初始化combo
	initCombo();
	
	//初始化easyui datagrid
	initTable();
	
	//初始化控件绑定的事件
	initMethod();

});

//初始化时间框
function initDate(){
	$('#StrDate').datebox("setValue",formatDate(0));
	$('#EndDate').datebox("setValue",formatDate(0));	
}

//初始化datagrid
function initTable(){
	
	var columns = [[
	 {field: 'LocName',align: 'center',title: '科室',width: 200},
     {field: 'UserDr',align: 'center',title: '人员工号',width: 130},
     {field: 'UserName',align: 'center',title: '人员姓名',width: 200},
     {field: 'ThisPeopleNum', align: 'center',title: '本院人次',width: 100},
     {field: 'OtherPeopleNum', align: 'center',title: '外院人次', width: 100},
     {field: 'ThisHosItemNum', align: 'center',title: '本院项目数',width: 100 },
     {field: 'OtherHosItemNum', align: 'center',title: '外院项目数',width: 100 },
     {field: 'PeopleNum', align: 'center',title: '人次合计', width: 100},
     {field: 'ItemNum', align: 'center',title: '项目合计', width: 100}]]
    $('#cspscorequeryTb').datagrid({
	    url:'dhcapp.broker.csp?ClassName=web.workquery&MethodName=ListPeScore',
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
///查看明细
function  CheckResult(value,rowData,rowIndex){
    return "<a href='#' mce_href='#' onclick='showHisResultWin("+rowIndex+");'>查看明细</a>";  
}

function showHisResultWin(rowIndex)
{
	var oeori=$("tr[datagrid-row-index="+rowIndex+"] "+"td[field=oeori]").text();
	window.open("dhclabviewoldresult.csp?PatientBanner=1&OrderID="+oeori+"&StartDate=",'','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=1250,height=670,left=80,top=10');
}

function initCombo(){
	$('#ApplayLoc').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISScoreQuery&MethodName=GetApplayLoc&HospID="+hosp,
		valueField:'id',    
	    textField:'text'
	});
	
	$('#DeliPeople').combobox({
		//url:LINK_CSP+"?ClassName=web.DHCDISScoreQuery&MethodName=GetListScore",
		panelHeight:'auto',
		valueField:'id',    
	    textField:'text' ,
	    data:[
	        {id:'1',text:'配送人员'},
		    {id:'2',text:'申请人员'},
		    {id:'3',text:'验证人员'},
		    {id:'4',text:'完成人员'}
	    ]
	});
}

function initMethod(){
 	
 	 $('#searchBtn').bind('click',search) //查找	
}


/*======================================================*/

//查询
function search(){
	var StrDate=$('#StrDate').datetimebox('getValue');
	var EndDate=$('#EndDate').datetimebox('getValue');
	var applayLocDr= $('#ApplayLoc').val();
	var Score = $('#Score').val();
	var aa=getParam()
	alert(aa)
}

//Table请求参数
//return ：开始时间^结束时间^申请科室^状态
function getParam(){
	var stDate = $('#StrDate').datetimebox('getValue');
	var endDate=$('#EndDate').datetimebox('getValue');
	var applayLocDr= $('#ApplayLoc').val();
	var Score = $('#Score').val();
	return stDate+"^"+endDate+"^"+applayLocDr+"^"+Score
}