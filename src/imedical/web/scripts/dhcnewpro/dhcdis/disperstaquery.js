///Description: ������Ա״̬��ѯ
///Creator:     zhaowuqiang
///Date:        2017/02/06
var Array = [{ "value": "0", "text": "æµ" },{ "value": "1", "text": "����" }];
$(document).ready(function(){
	initStatuslist();      // ��ʼ��������Ա״̬�б�
	initButton();		   // ��ʼ��ҳ��İ�ť
	initCombobox();		   // ��ʼ��ҳ���������
	querystatus();         // ��ʼ����ѯ
 });

///����datagrid
function initStatuslist()
{
	//  ����columns
	var columns=[[
		{field:'LocDesc',title:'����',width:260,align:'center'},
		{field:'StaNo',title:'��Ա����',width:260,align:'center'},
		{field:'StaName',title:'����',width:260,align:'center'},
		{field:'Enable',title:'�Ƿ����',width:260,align:'center'},
		{field:'Status',title:'״̬',width:290,align:'center'}
	]];
	// ��ʼ�� datagrid
	$('#statuslist').datagrid({
		title:'',
		fit:true,
		nowrap:false,
		rownumbers:true,
		columns:columns,
		pageSize:20,  		// ÿҳ��ʾ�ļ�¼����
		pageList:[20,40],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	
}

/// ��ʼ����ť
function initButton()
{
	// ��ѯ��ť
	$('a:contains("��ѯ")').bind("click",querystatus);
	
	//���combobox
	$('a:contains("���")').bind("click",clearcombobox);
	
	//�󶨻س��¼�
	$(document).keydown(function (e) { 
		if (e.which == 13) { 
		querystatus(); 
		} 
}); 
	
}


/// ��ʼ��combobox
function initCombobox()
{
	// ��Ա״̬
	var StatusCombobox = new ListCombobox("Status",'',Array,{panelHeight:"auto",editable:true});
	StatusCombobox.init();
	//$("#Status").combobox("setValue","0");   //����Ĭ��
	$("#Status").combobox({
		//value:"0",
		onSelect:function(){
			querystatus();}
		
		});
	// ״̬������ѡ�񴥷���ѯ�¼�
	/*  $("#Status").combobox({
		onSelect:function(){
			querystatus();}
		}); */
	
	// ����
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISPerStatus&MethodName=";	
	var url = uniturl+"SelAllLoc";
	new ListCombobox("Dept",url,'').init();
	// ����������ѡ�񴥷���ѯ�¼�
	$("#Dept").combobox({
		onSelect:function(){
			querystatus();}
		});
	//$("#Dept").combobox("setValue","0");    //����Ĭ��
	
}
/// ��ѯ
function querystatus()
{
	var dept=$("#Dept").combobox("getValue");
	var status=$("#Status").combobox("getValue");
	//alert(status)
	var params=dept+"^"+status;
	$('#statuslist').datagrid(
		{
			url:'dhcapp.broker.csp?ClassName=web.DHCDISPerStatus&MethodName=QueryPersonStatus',	
			queryParams:{
			StrParam:params}
			});
}
///���combobox
function clearcombobox()
{
	$("#Dept").combobox("setValue","");
	$("#Status").combobox("setValue","");
	querystatus();
}

/// JQuery ��ʼ��ҳ��
//$(function(){ initPageDefault(); })