/// Creator: bianshuai
/// CreateDate: 2015-1-29
//  Descript: �໤��Ϣ��ѯ

var url="dhcpha.clinical.action.csp";

$(function(){
	$("#stdate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	
	//����
	$('#ward').combobox({
		onShowPanel:function(){
			$('#ward').combobox('reload',url+'?action=SelAllWard')
		}
	});
	
	//����
	$('#dept').combobox({
		onShowPanel:function(){
			$('#dept').combobox('reload',url+'?action=SelAllLoc&loctype=E')
		}
	});
	
	//�໤����
	$('#monLevel').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		onShowPanel:function(){
		//	$('#monLevel').combobox('reload',url+'?action=GetLevelComb')
			$('#monLevel').combobox('reload',url+'?action=SelMonLevel') //qunianpeng 2016-08-10
		}
	});
	
	//�ǼǺŻس��¼�
	$('#patno').bind('keypress',function(event){
	 if(event.keyCode == "13"){
		 var patno=$.trim($("#patno").val());
		 if (patno!=""){
			GetWholePatID(patno);
			Query();
		 }	
	 }
	});
	
	$('a:contains("��ѯ")').bind("click",Query); //��־
	 
	//��ʼ�������б�
	InitPatList();
})

//��ѯ
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var WardID=$('#ward').combobox('getValue');    //����ID
	var LocID=$('#dept').combobox('getValue');     //����ID
	var MonLevel=$('#monLevel').combobox('getValue');  //�໤����
	if (typeof LocID=="undefined"){LocID="";}
	if (typeof WardID=="undefined"){WardID="";}
	if (typeof MonLevel=="undefined"){MonLevel="";}
	var PatNo=$.trim($("#patno").val());
	var params=StDate+"^"+EndDate+"^"+WardID+"^"+LocID+"^"+MonLevel+"^"+PatNo;

	$('#maindg').datagrid({
		url:url+'?action=QueryPhaCare',	
		queryParams:{
			params:params}
	});
}

///��0���˵ǼǺ�
function GetWholePatID(RegNo)
{    
	if (RegNo=="") {
		return RegNo;
	}
	var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON","GetPatRegNoLen");
	var plen=RegNo.length;
	if (plen>patLen){
		$.messager.alert('������ʾ',"�ǼǺ��������");
		return;
	}
	for (i=1;i<=patLen-plen;i++){
		RegNo="0"+RegNo;  
	}
	$("#patno").val(RegNo);
}

//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
		{field:'MonDetail',title:'��ϸ��Ϣ',width:100,align:'center',formatter:setCellUrl},
		{field:'PatNo',title:'�ǼǺ�',width:120},
		{field:'PatName',title:'����',width:120},
		{field:'monCount',title:'�໤����',width:120,align:'center'},
		{field:'monWard',title:'����',width:280},
		{field:'monWardID',title:'monWardID',width:100,hidden:true},
		{field:'monLocID',title:'monLocID',width:100,hidden:true},
		{field:'monLocDesc',title:'����',width:240},
		{field:'monSubClassId',title:'monSubClassId',width:100,hidden:true},
		{field:'monSubClass',title:'ѧ�Ʒ���',width:240},
		{field:'monAdmID',title:'monAdmID',width:100,hidden:true}
	]];
	
	//����datagrid
	$('#maindg').datagrid({
		title:'�����б�',
		fit:true,
		nowrap:false,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	
	initScroll("#maindg");//��ʼ����ʾ���������
        $('#maindg').datagrid('loadData', {total:0,rows:[]});
}

///���ñ༭����
function setCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showEditWin("+rowData.monAdmID+","+rowData.monSubClassId+")'>��ϸ��Ϣ</a>";
}

function showEditWin(monAdmID,monSubClassId){

	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:"�໤��Ϣ��ѯ",
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600,
		onClose:function(){
			$('#win').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
		}
	});

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.pharcarequery.csp?monAdmID='+monAdmID+'&monSubClassId='+monSubClassId+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}