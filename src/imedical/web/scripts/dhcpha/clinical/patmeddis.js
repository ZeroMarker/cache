/// Creator: bianshuai
/// CreateDate: 2015-03-20
//  Descript: �����Ķ�

var url="dhcpha.clinical.action.csp";

$(function(){

	$("#stdate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	
	$('a:contains("��ѯ")').bind("click",Query);   //��ѯ
	$('a:contains("�½�")').bind("click",NewWin);  //�½�
	$('a:contains("����")').bind("click",downLoad);  //����
	$('a:contains("���")').bind("click",view);  //���
	$('a:contains("�޸�")').bind("click",mod);  //�޸�
	$('a:contains("ɾ��")').bind("click",del);  //ɾ��
	
	InitPatList(); //��ʼ�������б�
})

//��ѯ
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	var status=$('#status').combobox('getValue');  //״̬
	if (typeof LocID=="undefined"){LocID="";}
	var PatNo=$.trim($("#patno").val());
	var UserID=session['LOGON.USERID'];       //�û�
	var LocId=session['LOGON.CTLOCID'];       //����
	var GroupId=session['LOGON.GROUPID'];     //��ȫ��
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+GroupId+"^"+LocId+"^"+UserID+"^"+status;

	$('#maindg').datagrid({
		url:url+'?action=GetAdrReport',	
		queryParams:{
			params:params}
	});
}

//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
		{field:"documentID",title:'documentID',width:90},
		{field:'date',title:'����',width:100},
		{field:'title',title:'��Ŀ',width:160},
		{field:'user',title:'������',width:100},
		{field:'content',title:'��Ҫ����',width:260},
		{field:'liters',title:'�ο�����',width:320},
		{field:'partuser',title:'�μ���Ա',width:320},
		{field:'address',title:'�ص�',width:160}
	]];
	
	//����datagrid
	$('#maindg').datagrid({
		title:'��������',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	
	initScroll("#maindg");//��ʼ����ʾ���������
        $('#maindg').datagrid('loadData', {total:0,rows:[]});
}

/*******************����**********************/
function downLoad()
{
}

/*******************���**********************/
function view()
{
}

/*******************ɾ��**********************/
function del()
{
}

/*******************�޸�**********************/
function mod()
{
}


/*******************�½�����**********************/
function NewWin()
{	
	clearDialog();
	$('#newwin').css("display","block");
	$('#newwin').dialog({
		title:"�½����������ۡ�",
		collapsible:false,
		border:false,
		closed:"true",
		width:800,
		height:420,
		buttons:[{
				text:'����',
				iconCls:'icon-save',
				handler:function(){
					closeNewWin(); ///�ر��½�����
					}
			},{
				text:'�˳�',
				iconCls:'icon-cancel',
				handler:function(){
					closeNewWin();  ///�ر��½�����
					}
			}]
	});
	///��ʾ�Ի���	
	$('#newwin').dialog('open');
}

/*******************�ر��½�����**********************/
function closeNewWin()
{
	$('#newwin').dialog('close');
	$("#newwin").css("display","none");
}

/// Creator: qunianpeng
/// CreateDate: 2016-08-01
//  Descript: ����½�����
function clearDialog(){	
	$("#date").datebox("setValue","");  // ����
	$("#address").val("");			 // �ص�
	$("#user").val("");				// ������
	$("#file").val("");	             // ����ļ�	
	$("#title").val("");			//��Ŀ
	$("#content").val("");			//��Ҫ����
	$("#liters").val("");				//�ο�����
	$("#partuser").val("");			//�μ���Ա
 
}