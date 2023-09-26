
///Creator:    bianshuai
///CreateDate: 2016-01-28
///Descript:   ҩѧ����ѯ
var flag=0;
var finiFlag="N"
var url="dhcpha.clinical.action.csp";
$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));     //Init��������
	
	$("a:contains('�½�')").bind("click",newCreateConsult);
	$("a:contains('��ѯ')").bind("click",queryConsultDetail);
	$("a:contains('ɾ��')").bind("click",delConsultDetail);
	
	/**
	 * ��ѯ���
	 */
	var consIdenCombobox = new ListCombobox("consIden",url+'?action=QueryConsIdenInfo','',{panelHeight:"auto"});
	consIdenCombobox.init();
	
	/**
	 * ��������
	 */
	var quesTypeCombobox = new ListCombobox("consType",url+'?action=QueryQuesType','',{panelHeight:"auto"});
	quesTypeCombobox.init();
	
	/**
	 * ��ѯ����
	 */
	 $('#consDept').combobox({
		//mode:'remote',		
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			$('#consDept').combobox('reload',url+'?action=SelAllLoc&hospId='+LgHospID)
			//$('#consDept').combobox('reload',url+'?action=SelAllLoc&HospID='+HospID)
		}
	}); 
	//var conDeptCombobox = new ListCombobox("consDept",url+'?action=QueryConDept','',{});
	//conDeptCombobox.init();
	
	InitConsultList();    //��ʼ����ѯ��Ϣ�б�
	
})

//��ʼ������Ĭ����Ϣ
function InitConsultDefault(){

	$("#consUserID").val(LgUserID);  //�û�ID
	$('#consCode').val(LgUserCode);  //�û�����
	$('#consName').val(LgUserName);  //�û�����
	$('#consDept').combobox('setValue',LgCtLocID);   
	$('#consDept').combobox('setText',LgCtLocDesc);  
	
	$("#consTele").val('');    //��ϵ�绰
	$('#consIden').combobox('setValue','');    //��ѯ���
	$('#consType').combobox('setValue','');    //��������
	$('#consDesc').val('');    //��ѯ����
	$("#consultID").val(''); //��ѯID
}

//��ʼ�������б�
function InitConsultList()
{

	/**
	 * ����columns
	 */
	var columns=[[
		{field:'consultID',title:'consultID',width:80,hidden:true},
		{field:'finiFlag',title:'��ɱ�־',width:50,align:'center',formatter:SetCellColor},
		{field:'consDate',title:'��ѯ����',width:100},
		{field:'consTime',title:'��ѯʱ��',width:90},
		{field:'quesType',title:'��������',width:120},
		{field:'consIden',title:'��ѯ���',width:100},
		{field:'consDept',title:'��ѯ����',width:160},
		{field:'consName',title:'��ѯ��',width:100},
		{field:'consTele',title:'��ϵ�绰',width:100},
		{field:'consDesc',title:'��������',width:500},
		{field:'consDet',title:'��ϸ',width:100,align:'center',formatter:SetCellUrl},
		{field:'LkRepDetial',title:'�鿴�ظ�',width:100,align:'center',formatter:SetCellDetUrl},
		{field:'LkDetial',title:'����',width:100,align:'center',formatter:SetCellOpUrl}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'��ѯ��ϸ',
		//nowrap:false,
		singleSelect : true,
		onLoadSuccess:function(data){
			///��ʾ��Ϣ
    		LoadCellTip("consDesc");
		},
		onDblClickRow:function(rowIndex, rowData){
			showModifyWin(rowData.consultID);
		} 
		};
		
	var conDetListComponent = new ListComponent('conDetList', columns, '', option);
	conDetListComponent.Init();

	initScroll("#conDetList");//��ʼ����ʾ���������

	queryConsultDetail();
}

 /**
  * �½���ѯ����
  */
function newCreateConsult(){
	finiFlag="N"
	newCreateConsultWin(); //�½���ѯ����
	InitConsultDefault();  //��ʼ������Ĭ����Ϣ
}

 /**
  * �½���ѯ����
  */
function newCreateConsultWin(){
	var option = {
			buttons:[{
				text:'����',
				iconCls:'icon-save',
				handler:function(){
					saveConsultDetail();
					}
			},{
				text:'�ر�',
				iconCls:'icon-cancel',
				handler:function(){
					$('#newConWin').dialog('close');
					}
			}]
		};
	if(flag==1){
		var newConDialogUX = new DialogUX('�޸�', 'newConWin', '730', '330', option); //lbb 2019-03-12
	}
	else{
	    var newConDialogUX = new DialogUX('�½�', 'newConWin', '730', '330', option); //nisijia 2016-09-30
	}
	newConDialogUX.Init();
	flag=0;
}

 /**
  * ������ѯ����
  */
function saveConsultDetail(){
	 if(finiFlag=="Y"){
		alert("����ȡ����ɺ��ٽ����޸�!!!");
		return;
	 }
	 
	var consName=$('#consName').val();    //����
	if (consName == ""){
		showMsgAlert("������ʾ:","��������Ϊ�գ�");
		return;
	}
		
	var consTele=$('#consTele').val();    //��ϵ�绰
	if (consTele == ""){
		showMsgAlert("������ʾ:","��ϵ�绰����Ϊ�գ�");
		return;
	}

	var consIden=$('#consIden').combobox('getValues');    //��ѯ���
	if (consIden == ""){
		showMsgAlert("������ʾ:","��ѯ��ݲ���Ϊ�գ�");
		return;
	}
	
	var consType=$('#consType').combobox('getValues');    //��������
	if (consType == ""){
		showMsgAlert("������ʾ:","�������Ͳ���Ϊ�գ�");
		return;
	}
	
	var consDept=$('#consDept').combobox('getValues');    //��ѯ����
	if (consDept == ""){
		showMsgAlert("������ʾ:","��ѯ���Ų���Ϊ�գ�");
		return;
	}

	var consDesc=$('#consDesc').val();       //��ѯ����
	if (consDesc == ""){
		showMsgAlert("������ʾ:","������������Ϊ�գ�");
		return;
	}
	if($('#consDesc').val().length>800){
		showMsgAlert("������ʾ:","�����������ܳ���800�֣�");
		return;
	}
	var consUserID = $("#consUserID").val();
	var consultID = $("#consultID").val();
	
	
	var conDataList = consUserID +"^"+ consTele +"^"+ consIden +"^"+ consType +"^"+ consDept +"^"+ consDesc;
		conDataList = conDataList +"^"+ LgUserID+"^"+ "MAN";

	//��������
	$.post(url+'?action=saveConsultDetail',{"consultID":consultID,"conDataList":conDataList},function(jsonString){
		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			$('#newConWin').dialog('close');     //�رմ���
			$('#conDetList').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ:","�ύʧ��,����ԭ��"+jsonConsObj.ErrorMessage);
		}
	});
}

 /**
  * ��ѯ��ѯ����
  */
function queryConsultDetail(){
	
	//1�����datagrid 
	$('#conDetList').datagrid('loadData', {total:0,rows:[]});
	
	//2����ѯ
	var startDate=$('#startDate').datebox('getValue');   //��ʼ����
	var endDate=$('#endDate').datebox('getValue');       //��ֹ����

	var consDesc=$('#inConsDesc').val();    //��ѯ����
	
	var params=startDate +"^"+ endDate +"^"+ LgUserID + "^" + consDesc +"^"+ ""  +"^"+ "" +"^"+ "MAN"+"^"+LgHospID;
	
	$('#conDetList').datagrid({
		url:url + "?action=QueryPhConsult",	
		queryParams:{
			params:params}
	});
}

//��������formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showModifyWin("+rowIndex+")'>�޸���ϸ</a>";
}

//��������formatter="SetCellUrl"
function SetCellColor(value, rowData, rowIndex)
{
	var html = "";
	if (value == "Y"){
		html = "<span style='margin:0px 5px;font-weight:bold;color:red;'>���</span>";		
	}else{
		html = "<span style='margin:0px 5px;font-weight:bold;color:green;'>No</span>";
		}
    return html;}


/// ɾ����ѯ��ϸ
function delConsultDetail(){
	showMsgAlert("����ԭ��:" , "ɾ��������ʱ�����ã�");
}


//�鿴�ظ��б�
//�鿴�ظ��б�
function SetCellDetUrl(value, rowData, rowIndex)
{
	var html = "";
	if (rowData.finiFlag == "Y"){
		html = "<a href='#' onclick='newCreateConsultDetWin("+rowData.consultID+")' style='margin:0px 5px;font-weight:bold;color:red;text-decoration:none;'>�鿴�ظ��б�</a>";
		
	}else{
		html = "<a href='#' onclick='newCreateConsultDetWin("+rowData.consultID+")'>�鿴�ظ��б�</a>";
		}
    return html;
}

//����
function SetCellOpUrl(value, rowData, rowIndex)
{
	var html = "";
	if (rowData.finiFlag != "Y"){
		html = "<a href='#' onclick='setConsultComplete("+"\""+rowData.consultID+"\""+","+"\"Y\""+")'>�������</a>";
	}else{
		html = "<a href='#' onclick='setConsultComplete("+"\""+rowData.consultID+"\""+","+"\"N\""+")'>ȡ�����</a>";
	}
    return html;
}


/// �������״̬
function setConsultComplete(consultID, consComFlag){

	//��������
	$.post(url+'?action=setConsultComplete',{"consultID":consultID, "consComFlag":consComFlag},function(jsonString){

		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			showMsgAlert("","���óɹ���");
			$('#conDetList').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ:","����ʧ��,����ԭ��"+jsonConsObj.ErrorMessage);
		}
	});
}

 /**
  * �½���ѯ����
  */
function newCreateConsultDetWin(consultID){
	
	var option = {
		minimizable : true,
		maximizable : true
		};
	var newConWindowUX = new WindowUX('�б�', 'newConDetWin', '930', '550', option);
	newConWindowUX.Init();

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.replyconsult.csp?consultID='+consultID+'"></iframe>';
	$('#newConDetWin').html(iframe);
	
	/*
	window.open ('dhcpha.clinical.replyconsult.csp?consultID='+consultID,'newwindow','height=930,width=620,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no') 
	*/
}

 /**
  * �޸Ĵ���
  */
function showModifyWin(index){

	/*
	if($('#newConWin').is(":visible")){ 
		//���崦�ڴ�״̬,�˳�
	}else{
		newCreateConsultWin(); //��������
	}
	*/
	flag=1;
	var rowData = $('#conDetList').datagrid('getData').rows[index];
	consultID = rowData.consultID;
	finiFlag=rowData.finiFlag   //lbb  2019/11/18  ȡ���״̬����ɺ����޸ı��棬ֻ�������
	newCreateConsultWin(); //��������
	
	$.post(url+'?action=QyConsultDetail',{"consultID":consultID},function(jsonString){

		var resobj = jQuery.parseJSON(jsonString);
		$("#consUserID").val(resobj.consUserID);    //�û�ID
		$("#consCode").val(resobj.consCode);    //����
		$("#consName").val(resobj.consName);    //����
		$("#consTele").val(resobj.consTele);    //��ϵ�绰
		$('#consIden').combobox('setValue',resobj.consIden);    //��ѯ���
		$('#consType').combobox('setValue',resobj.quesType);    //��������
		$('#consDept').combobox('setValue',resobj.consDept);    //��ѯ����
		$('#consDept').combobox('setText',resobj.consDeptDesc);    //��ѯ����
		$('#consDesc').val(resobj.consDesc);    //��ѯ����
		$("#consultID").val(consultID); //��ѯID
	});
	
}

/// ��Ϣ��ʾ����
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("��ʾ:","<font style=''>" + ErrMsg + "</font><font style='color:red;'>" + ErrDesc + "</font>");
}