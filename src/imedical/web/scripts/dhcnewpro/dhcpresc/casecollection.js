//===========================================================================================
// ���ߣ�      shy
// ��д����:   2022-3-29
// ����:	   �����ղط���
//===========================================================================================
var AuditId="" ;   //�ղ�������ID
var collectId = "";
/// ҳ���ʼ������
function initPageDefault(){
	InitGetData();            /// ��ʼ�������Ϣ 
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	InitCombobox();           /// ��ʼ��Combobox
	InitMethod();         	  /// ��ʼ������

}
// �ղط���
function Update()
{
	
	//����׼��
	var Theme=$("#theme").combobox('getValue') //����
	var Level=$("#level").combobox('getValue') //����
	var ShreGrp=$("#shregrp").combobox('getValue');  //������
	var ShareUit=$("#shareuit").combobox('getValue'); //����λ
	var StartDate=$("#startDate").datebox('getValue');  //��ʼ����
	var EndDate=$("#endDate").datebox('getValue');    //��������
	var Params=Theme+"^"+Level+"^"+ShreGrp+"^"+ShareUit+"^"+StartDate+"^"+EndDate+"^"+LgUserID+"^"+LgHospID
	//������������
	if(Theme=="")
	{
		$.messager.alert("��ʾ","��ѡ�����⣡","warning")
		return ;	
	}
	if(Level=="")
	{
		$.messager.alert("��ʾ","��ѡ�񼶱�","warning")
		return ;	
	}
	if(ShreGrp=="")
	{
		$.messager.alert("��ʾ","��ѡ������飡","warning")
		return ;	
	}
	if(ShareUit=="")
	{
		$.messager.alert("��ʾ","��ѡ�����λ��","warning")
		return ;	
	}
	if(StartDate=="")
	{
		$.messager.alert("��ʾ","��ѡ��ʼ���ڣ�","warning")
		return ;	
	}
	if(EndDate=="")
	{
		$.messager.alert("��ʾ","��ѡ��������ڣ�","warning")
		return ;	
	}
	//�ж������Ƿ���ڣ�����������򱣴����������
	//���永���ղ��ĸ���
	var Result=""
	runClassMethod("web.DHCPrescCaseCollection","InsertCase",{"Params":Params,"AuditId":AuditId},function(getString){
		if (getString == 0){
			Result = "�����ɹ���";
		}else
		{
			Result = "����ʧ�ܣ�";	
		}
	},'text',false);
	$("#visgrid").datagrid('reload');
	$.messager.popover({msg: Result,type:'success',timeout: 1000});
	
	
	//�ر��ղط�����
	//websys_showModal("close")
}
// �ղ� lidong
function Collect()
{
	
	//����׼��
	var ShreGrp=$("#shregrp").combobox('getValue');  //������
	var ShareUit=$("#shareuit").combobox('getValue'); //����λ
	var StartDate=$("#startDate").datebox('getValue');  //��ʼ����
	var EndDate=$("#endDate").datebox('getValue');    //��������
	var Theme=$HUI.combobox("#theme").getValue() //����
	var Level=$("#level").combobox('getValue') //����
	var Params=Theme+"^"+Level+"^"+LgUserID+"^"+LgHospID;		//������������
	if(Theme=="")
	{
		$.messager.alert("��ʾ","��ѡ�����⣡","warning")
		return ;	
	}
	if(Level=="")
	{
		$.messager.alert("��ʾ","��ѡ�񼶱�","warning")
		return ;	
	}
	/* if((ShreGrp!=="")||(ShareUit!=="")||(StartDate!=="")||(EndDate!==""))
	{
		$.messager.alert("��ʾ","������д������Ϣ��������������ť","info")
			
	} */
	
	//�ж������Ƿ���ڣ�����������򱣴����������
	//���永���ղ��ĸ���
	var Result=""
	runClassMethod("web.DHCPrescCaseCollection","CollectSave",{"Params":Params,"AuditId":AuditId},function(getString){
		if (getString > 0){
			collectId = getString;
			Result = "�����ɹ���";
			if((ShreGrp!=="")||(ShareUit!=="")||(StartDate!=="")||(EndDate!==""))
			{
				$.messager.alert("��ʾ","�ղسɹ����������ղؼ�¼","info")
			
			} 
		}else
		{
			Result = "����ʧ�ܣ�";	
		}
	},'text',false);
	$("#visgrid").datagrid('reload');
	$.messager.popover({msg: Result,type:'success',timeout: 1000});
	
	
	//�ر��ղط�����
	//websys_showModal("close")
}
// ����
function Share()
{
	//����׼��
	var Theme=$("#theme").combobox('getValue') //����
	var Level=$("#level").combobox('getValue') //����
	var ShreGrp=$("#shregrp").combobox('getValue');  //������
	var ShareUit=$("#shareuit").combobox('getValue'); //����λ
	var StartDate=$("#startDate").datebox('getValue');  //��ʼ����
	var EndDate=$("#endDate").datebox('getValue');    //��������
	var Params=ShreGrp+"^"+ShareUit+"^"+StartDate+"^"+EndDate+"^"+LgUserID+"^"+collectId
	//������������
	if(ShreGrp=="")
	{
		$.messager.alert("��ʾ","��ѡ������飡","warning")
		return ;	
	}
	if(ShareUit=="")
	{
		$.messager.alert("��ʾ","��ѡ�����λ��","warning")
		return ;	
	}
	if(StartDate=="")
	{
		$.messager.alert("��ʾ","��ѡ��ʼ���ڣ�","warning")
		return ;	
	}
	if(EndDate=="")
	{
		$.messager.alert("��ʾ","��ѡ��������ڣ�","warning")
		return ;	
	}
	//�ж������Ƿ���ڣ�����������򱣴����������
	//���永���ղ��ĸ���
	var Result=""
	runClassMethod("web.DHCPrescCaseCollection","ShareSave",{"Params":Params,"AuditId":AuditId},function(getString){
		if (getString == 0){
			Result = "�����ɹ���";
		}else if(getString == -7){
			Result = "�����ղأ��ٷ���";
		}else{
			Result = "����ʧ�ܣ�";	
		}
	},'text',false);
	$("#visgrid").datagrid('reload');
	$.messager.popover({msg: Result,type:'success',timeout: 2000});
	
	
	//�ر��ղط�����
	//websys_showModal("close")
}
// ��ʼ�������Ϣ 
function InitGetData()
{
	AuditId=getParam("AuditId");		//������ID
}
// ��ʼ������
function InitMethod()
{
		
}
// ��ʼ��Combobox
function InitCombobox()
{      
	/* // �����ղ�����
	$HUI.combobox("#themes",{
		url: $URL+"?ClassName=web.DHCPrescCaseCollection&MethodName=GetThemeData",
		valueField: "id", 
		textField: "text",
		editable:true,
		mode:'remote',
		onSelect:function(ret){
			
		}
	})	
	
	// �����ղؼ���
	$HUI.combobox("#levels",{
		url: $URL+"?ClassName=web.DHCPrescCaseCollection&MethodName=GetLevelData",
		valueField: "id", 
		textField: "text",
		editable:true,
		mode:'remote',
		onSelect:function(ret){
			
		}
	})	
	// �������������
	$('#shregrps').combobox( {
		data:[{"id":"D","text":"ȫԺ"},{"id":"L","text":"����"},{"id":"G","text":"��ȫ��"},{"id":"U","text":"��Ա"},{"id":"P","text":"ְ��"}],
	    valueField: 'id',
	    textField: 'text',
	    onSelect: function (option) {
	    $("#shareuits").combobox( { 
				url:'dhcapp.broker.csp?ClassName=web.DHCPrescCaseCollection&MethodName=GetScopeValueDate&type='+option.id
		})
	    }
	   
	})
// ��ʼ�������������λ
$('#shareuits').combobox( {
    valueField: 'id',//���ֶ�ID
    textField: 'text',//���ֶ�Name
    onSelect: function (option) {
    }
   
}) */



// �����ղط�������
	$HUI.combobox("#theme",{
		url: $URL+"?ClassName=web.DHCPRESCCommonUtil&MethodName=QueryDicItemCombox&code=COLLECT&hospId="+LgHospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote',
		onSelect:function(ret){
			
		}
	})	
	
	// �����ղط�����
	$HUI.combobox("#level",{
		url: $URL+"?ClassName=web.DHCPRESCCommonUtil&MethodName=QueryDicItemCombox&code=COLLECTLEV&hospId="+LgHospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote',
		onSelect:function(ret){
			
		}
	})	
	// �����ղط��������
	$('#shregrp').combobox( {
		data:[{"id":"D","text":"ȫԺ"},{"id":"L","text":"����"},{"id":"G","text":"��ȫ��"},{"id":"U","text":"��Ա"},{"id":"P","text":"ְ��"}],
	    valueField: 'id',
	    textField: 'text',
	    mode:'remote',
	    onSelect: function (option) {
	    $("#shareuit").combobox( { 
				url:$URL+'?ClassName=web.DHCPrescCaseCollection&MethodName=GetScopeValueDate&type='+option.id
		})
	    }
	   
	})
// ��ʼ�������ղط������λ
$('#shareuit').combobox( {
    valueField: 'id',//���ֶ�ID
    textField: 'text',//���ֶ�Name
    mode:'remote',
    onSelect: function (option) {
    }
   
})
}





/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPageDataGrid(){
	///  ����columns
	var columns=[[
		{field:'AttributeTValue',title:'����',width:120,align:'center'},
		{field:'AttributeLValue',title:'����',width:100,align:'center'},
		{field:'Type',title:'������',width:100,align:'center'},
		{field:'Pointer',title:'����λ',width:200,align:'center'},
		{field:'StartDate',title:'��ʼ����',width:120,align:'center'},
		{field:'EndDate',title:'��������',width:120,align:'center'},
	]]
	
	/* var option={	
		columns:columns,
		bordr:false,	
		fitColumns:false,
		singleSelect:true,		
		striped: true, 
		pagination:true,
		rownumbers:true,
		loadMsg: '���ڼ�����Ϣ...',
		pageSize:50,
		pageList:[50,100,150],		
 		onClickRow:function(rowIndex,rowData){}, 
		onDblClickRow: function (rowIndex, rowData) {},
        onLoadSuccess:function(data){
	     }
	}  */
	var option = {
		//showHeader:false,
		fitColumn:true,
		toolbar:[],
		rownumbers:false,
		singleSelect:true,
		pagination:true,
		fit:true,
	    onLoadSuccess:function (data) { //���ݼ�������¼�
	    	
        }
	};       
	
	var uniturl = $URL+"?ClassName=web.DHCPrescCaseCollection&MethodName=QueryCollectShare&AuditId="+ AuditId+"&LgUserID="+LgUserID;
	new ListComponent('visgrid', columns, uniturl, option).Init();
	///  ����datagrid
	/* var option = {
		//showHeader:false,
		fitColumn:true,
		rownumbers:false,
		singleSelect:true,
		pagination:true,
		fit:true,
	    onLoadSuccess:function (data) { //���ݼ�������¼�
	    	
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCPrescCaseCollection&MethodName=QueryCollectShare&AuditId="+ AuditId+"&LgUserID="+LgUserID;
	new ListComponent('visgrid', columns, uniturl, option).Init(); */
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
