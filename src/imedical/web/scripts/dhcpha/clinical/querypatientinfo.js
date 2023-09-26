///Creator:sufan
///date:2016/10/25
//ҳ���ʼ������
function initPageDefault()
{
	initPatientlist();   // ��ʼ�������б�
	initCombobox();		 // ��ʼ��ҳ���������
	initButton();		 // ��ʼ����ť
}
function initPatientlist()
{
	///  ����columns
	var columns=[[
		{field:'PatientID',title:'����ID',width:80,align:'center',hidden:'true'},
		{field:'PatNo',title:'�ǼǺ�',width:80,align:'center'},
		{field:'PatName',title:'����',width:80,align:'center'},
		{field:'SexDesc',title:'�Ա�',width:60,align:'center'},
		{field:'PatAge',title:'����',width:60,align:'center'},
		{field:"AdmDate",title:'��������',width:100,align:'center'},
		{field:'CtlocDesc',title:'�������',width:150,align:'center'},
		{field:'WardDesc',title:'���ﲡ��',width:150,align:'center'},
		{field:"MainDiag",title:'���',width:200,align:'center'},
		{field:'AdmDocName',title:'ҽ��',width:100,align:'center'},
		{field:'PhaomResult',title:'�ص㻼�߱�־',width:120,align:'center'},
		{field:'Statues',title:'ҩ��״̬',width:100,align:'center'}
	]];
	/// ��ʼ�� datagrid
	$('#patientlist').datagrid({
		title:'',
		fit:true,
		nowrap:false,
		rownumbers:true,
		columns:columns,
		pageSize:20,  // ÿҳ��ʾ�ļ�¼����
		pageList:[20,40],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
}

/// ҳ��Combobox��ʼ����
function initCombobox()
{
	
	//����
	var uniturl = LINK_CSP+"?ClassName=web.DHCCM.QueryPatient&MethodName=";	
	var url = uniturl+"SelAllWard";
	new ListCombobox("wing",url,'').init();
	$("#wing").combobox("setValue");
	
	//�ٴ�·�� 
	var uniturl = LINK_CSP+"?ClassName=web.DHCSTPHCMCOMMON&MethodName=";	
	var url = uniturl+"ClinPathWayDic";
	new ListCombobox("pathway",url,'').init();
	$("#pathway").combobox("setValue");
}
function initButton()
{
	//��ѯ��ť
	$('a:contains("��ѯ")').bind("click",querypatientinfo);
	
	//�ǼǺ�
	$("#patno").bind('keypress',function(event){       
        if(event.keyCode == "13"){
	        GetRegno();
            querypatientinfo();
          }
         });
}
function querypatientinfo()
{
	var Patno=$("#patno").val();
	var Pathway=$("#pathway").combobox("getText");
	var MedicalNum=$("#idnum").val();
	var Ward=$("#wing").combobox("getValue");
	var params=Patno+"^"+Pathway+"^"+MedicalNum+"^"+Ward;
	$('#patientlist').datagrid(
		{
			url:'dhcapp.broker.csp?ClassName=web.DHCCM.QueryPatient&MethodName=GetPatientinfoByWard',	
			queryParams:{
			params:params}
			});
}

function resetasklist()
{
	$("#patno").val("");
	$("#pathway").combobox("setValue","");
	$("#idnum").val("");
	$("#wing").combobox("setValue","");
	querypatientinfo();
	//$('#patientlist').datagrid('loaddata',{total:0,rows:[]});
}
function GetRegno()
{
	var Patno=$("#patno").val();
	var Patnolen=Patno.length;
	var zerolen=10-Patnolen;
	for (var i=1;i<=zerolen;i++)
	{
		var Patno=0+Patno;
	}
	var Patno=$("#patno").val(Patno);
}

$(function(){ initPageDefault(); })