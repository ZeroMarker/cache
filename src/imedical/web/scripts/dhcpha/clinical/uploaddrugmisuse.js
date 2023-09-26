/// Creator: bianshuai
/// CreateDate: 2014-10-29
//  Descript: ��ҩ�����ϱ�

var url="dhcpha.clinical.action.csp";
var statArray = [{ "val": "W", "text": "����" }, { "val": "A", "text": "����" }, { "val": "B", "text": "�˻�" }];
$(function(){

	$("#stdate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	
	//����
	$('#dept').combobox({
		onShowPanel:function(){
			$('#dept').combobox('reload',url+'?actiontype=SelAllLoc&loctype=E')
		}
	}); 

	//����
	$('#ward').combobox({
		onShowPanel:function(){
			$('#ward').combobox('reload',url+'?actiontype=SelAllLoc&loctype=W')
		}
	});
	
	//״̬
	$('#status').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:statArray 
	});
	$('#status').combobox('setValue',"W"); //����comboboxĬ��ֵ
	
	$('#Find').bind("click",Query); //�����ѯ
	
	InitPatList(); //��ʼ�������б�
})

//��ѯ
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue'); //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue'); //����ID
	var WardID=$('#ward').combobox('getValue'); //����ID
	if (LocID== undefined){LocID="";}
	if (WardID== undefined){WardID="";}
	var PatNo=$.trim($("#patno").val());
	var params=StDate+"^"+EndDate+"^"+WardID+"^"+LocID+"^"+PatNo+"^"+AppType;

	$('#maindg').datagrid({
		url:url+'?action=GetUntoEffectPatList',	
		queryParams:{
			params:params}
	});
}

//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
		{field:"AdrRepID",title:'AdrRepID',width:90},
		{field:'AdrRepNo',title:'������',width:160},
		{field:'PatNo',title:'�ǼǺ�',width:80},
		{field:'PatName',title:'����',width:80},
		{field:'Status',title:'״̬',width:80},
		{field:'AdmLoc',title:'����',width:120},
		{field:'AdmWard',title:'����',width:120},
		{field:'RepUser',title:'������',width:80},
		{field:'RepDate',title:'��������',width:100},
		{field:'RepTime',title:'����ʱ��',width:100},
		{field:'AuditUser',title:'�����',width:80},
		{field:'AuditDate',title:'�������',width:100},
		{field:'AuditTime',title:'�˻�ԭ��',width:120},
		{field:'IfUpLoad',title:'�Ƿ��ϱ�',width:120},
		{field:'UpLoad',title:'�ϱ�',width:120}
	]];
	
	//����datagrid
	$('#maindg').datagrid({
		title:'�����б�',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	
	initScroll("#maindg");//��ʼ����ʾ���������
}
