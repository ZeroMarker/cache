/// Creator: guoguomin
/// CreateDate: 2017-02-7

$(document).ready(function() {

	//��ʼ��ʱ��ؼ�
	//initDate();
	
	//��ʼ��combo
	initCombo();
	
	//��ʼ��easyui datagrid
	initTable();
	
	//��ʼ���ؼ��󶨵��¼�
	initMethod();

});

//��ʼ��ʱ���
function initDate(){
	$('#StrDate').datebox("setValue",formatDate(0));
	$('#EndDate').datebox("setValue",formatDate(0));	
}

//��ʼ��datagrid
function initTable(){
	
	var columns = [[
	 {field: 'LocName',align: 'center',title: '����',width: 200},
     {field: 'UserDr',align: 'center',title: '��Ա����',width: 130},
     {field: 'UserName',align: 'center',title: '��Ա����',width: 200},
     {field: 'ThisPeopleNum', align: 'center',title: '��Ժ�˴�',width: 100},
     {field: 'OtherPeopleNum', align: 'center',title: '��Ժ�˴�', width: 100},
     {field: 'ThisHosItemNum', align: 'center',title: '��Ժ��Ŀ��',width: 100 },
     {field: 'OtherHosItemNum', align: 'center',title: '��Ժ��Ŀ��',width: 100 },
     {field: 'PeopleNum', align: 'center',title: '�˴κϼ�', width: 100},
     {field: 'ItemNum', align: 'center',title: '��Ŀ�ϼ�', width: 100}]]
    $('#cspscorequeryTb').datagrid({
	    url:'dhcapp.broker.csp?ClassName=web.workquery&MethodName=ListPeScore',
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
///�鿴��ϸ
function  CheckResult(value,rowData,rowIndex){
    return "<a href='#' mce_href='#' onclick='showHisResultWin("+rowIndex+");'>�鿴��ϸ</a>";  
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
	        {id:'1',text:'������Ա'},
		    {id:'2',text:'������Ա'},
		    {id:'3',text:'��֤��Ա'},
		    {id:'4',text:'�����Ա'}
	    ]
	});
}

function initMethod(){
 	
 	 $('#searchBtn').bind('click',search) //����	
}


/*======================================================*/

//��ѯ
function search(){
	var StrDate=$('#StrDate').datetimebox('getValue');
	var EndDate=$('#EndDate').datetimebox('getValue');
	var applayLocDr= $('#ApplayLoc').val();
	var Score = $('#Score').val();
	var aa=getParam()
	alert(aa)
}

//Table�������
//return ����ʼʱ��^����ʱ��^�������^״̬
function getParam(){
	var stDate = $('#StrDate').datetimebox('getValue');
	var endDate=$('#EndDate').datetimebox('getValue');
	var applayLocDr= $('#ApplayLoc').val();
	var Score = $('#Score').val();
	return stDate+"^"+endDate+"^"+applayLocDr+"^"+Score
}