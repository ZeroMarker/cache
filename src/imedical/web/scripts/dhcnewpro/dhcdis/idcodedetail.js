$(document).ready(function(){
	
	//��ʼ�� table
	initTable();
	
	})

function initTable()
{
	//����columns
	var columns=[[
	    //{field:'RCPointer',title:'disreqID',width:80,hidden:false},
		//{field:"ck",checkbox:true,width:20},
		{field:'DisRCCode',title:'��֤��',width:200,align:'center'},
		{field:'DisRCCreateDate',title:'��������',width:200,align:'center'},
		{field:'DisRCCreateTime',title:'����ʱ��',width:200,align:'center'},
		{field:'DisRCCreateUser',title:'������',width:200,align:'center'},
		{field:'DisRCActiveFlag',title:'�Ƿ����',width:200,align:'center'}
	]];
	//var param = disreqID
	
	//��֤����ϸ
	$('#codedetail').datagrid({
		//url:LINK_CSP+'?ClassName=web.DHCDISEscortArrage&MethodName=codequery&param='+param,
	    columns:columns,
	    fit:true,
	    title:'',
	    fitColumns:true,
	    rownumbers:true,
	    pageSize:20, // ÿҳ��ʾ�ļ�¼����
	    pageList:[20,40],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    nowrap:false//�����Զ�����
		//onClickRow:function(Index, row){
		//	disreqID=row.DisREQ;
		//	ClickRowDetail(disreqID);//��ʾ���뵥��ϸ�б�
		//}
	});
	search();
}

function search(){
	var Params=disreqID+"^"+TypeID; //��ȡ����
	$('#codedetail').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISGoodsRequest&MethodName=QueryCodeDetail',	
			queryParams:{
			StrParam:Params}	
	});
	
}