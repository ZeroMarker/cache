/// Creator: zhanghailong
/// CreateDate: 2017-01-25

$(document).ready(function() {

	//��ʼ��ʱ��ؼ�
	//initDate();
	
	//��ʼ��combo
	initCombo();
	
	//��ʼ��easyui datagrid
	initTable();
	
	//��ʼ���ؼ��󶨵��¼�
	initMethod();
	
	//��ʼ��easyui datagrid
	initTableList();

});

//��ʼ��ʱ���
function initDate(){
	$('#StrDate').datebox("setValue",formatDate(0));
	$('#EndDate').datebox("setValue",formatDate(0));	
}

//��ʼ��datagrid
function initTable(){
	
	var columns = [[
	 {field: 'acceptLoc',align: 'center',title: '����',width: 200},
     {field: 'pepleNo',align: 'center',title: '��Ա����',width: 130},
     {field: 'pepeleName',align: 'center',title: '��Ա����',width: 200},
     {field: 'totalScore', align: 'center',title: '�ܵ÷�',width: 200},
     {field: 'general', align: 'center',title: '��������', width: 200},
     { field: 'average', align: 'center',title: '����',width: 200,formatter:Average },
     { field:'Check',title:'�鿴',align: 'center', width:200,formatter:CheckResult} 
     ]]
    
    $('#cspscorequeryTb').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISScoreQuery&MethodName=ListPeScore',
	    fit:true,
	    rownumbers:true,
	    columns:columns,
	    pageSize:20, // ÿҳ��ʾ�ļ�¼����
	    pageList:[20,40],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true
	})
}

//��ʼ��datagrid
function initTableList(){
	
	var columns = [[
     {field: 'UserName',align: 'center',title: '��Ա����',width: 200},
     {field: 'itmdrdesc',align: 'center',title: '��Ŀ����',width: 200},
     {field: 'LocDesc',align: 'center',title: 'ȥ�����',width: 200},
     {field: 'score', align: 'center',title: '�÷�',width: 200}
     ]]
    
    $('#cspscorelistTb').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISScoreQuery&MethodName=GetScores&UserDr='+UserDrid,
	    fit:true,
	    rownumbers:true,
	    columns:columns,
	    pageSize:20, // ÿҳ��ʾ�ļ�¼����
	    pageList:[20,40],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true
	})
}

///�������
function  Average(value,rowData,rowIndex){
	return (rowData.totalScore/rowData.general).toFixed(2);
}

///�鿴��ϸ
function  CheckResult(value,rowData,rowIndex){
    return "<a href='#' onclick='showHisResultWin("+rowIndex+");'>�鿴��ϸ</a>";  
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
 	 $('#searchBtn').bind('click',search) //����	
}


/*======================================================*/

//��ѯ
function search(){
	
	 var param=getParam()
	alert(param)
    $('#cspscorequeryTb').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISScoreQuery&MethodName=ListPeScore&Param='+param,
	    fit:true,
	    rownumbers:true,
	    //columns:columns,
	    pageSize:20, // ÿҳ��ʾ�ļ�¼����
	    pageList:[20,40],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true
	})
}

//Table�������
//return ����ʼʱ��^����ʱ��^�������^״̬
function getParam(){
	var stDate = $('#StrDate').datetimebox('getValue');
	var endDate=$('#EndDate').datetimebox('getValue');
	var applayLocDr= $('#ApplayLoc').combobox('getText');;
	var Score = $('#Score').combobox('getText');;
	return stDate+"^"+endDate+"^"+applayLocDr+"^"+Score
}