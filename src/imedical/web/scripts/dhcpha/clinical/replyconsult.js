/// Creator:    bianshuai
/// CreateDate: 2015-01-29
/// Descript:   ��ѯ�ظ�����

var url="dhcpha.clinical.action.csp";
var consultID = "";
var rowIndex = "";	// qunianpeng 2016/10/31
$(function(){
	
	consultID = getParam("consultID");
	rowIndex = getParam("rowIndex");	// qunianpeng 2016/10/31
		
	InitConBakDetList(); //�ظ��б�
	QyConsultDetail();   //��ѯ�ظ���ϸ
	
	
	$('#consDetDesc').bind("focus",function(){
		if(this.value=="������������Ϣ..."){
			$('#consDetDesc').val("");
		}
	});
	
	$('#consDetDesc').bind("blur",function(){
		if(this.value==""){
			$('#consDetDesc').val("������������Ϣ...");
		}
	});
})

//��ʼ�������б�
function InitConBakDetList()
{
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'consItmID',title:'consItmID',width:100,hidden:true},
		{field:'consDDate',title:'�ظ�����',width:140},
		{field:'consDName',title:'�ظ���',width:70},
		{field:'consDDesc',title:'������',width:700,
			  	    formatter:setMonLevelShow},
		{field:'consDOkFlag',title:'�����',width:90,align:'center',formatter:SetCellUrl},
		{field:'LkBkDetial',title:'����',width:100,align:'center',formatter:SetCellOpUrl}
	]];

	/**
	 * ����datagrid
	 */
	var option = {
		title:'��ѯ���б�',
		nowrap:false,
		singleSelect:true
		};
	var conBakDetListComponent = new ListComponent('conBakDetList', columns, '', option);
	conBakDetListComponent.Init();
	
	initScroll("#conBakDetList");//��ʼ����ʾ���������
    $('#conBakDetList').datagrid('loadData', {total:0,rows:[]});
}

/// ��ѯ������ϸ
function QyConsultDetail(){

	$.post(url+'?action=QyConsultDetail',{"consultID":consultID},function(jsonString){

		var resobj = jQuery.parseJSON(jsonString);
				
		$("#consName").val(resobj.consName);    //����
		$("#consTele").val(resobj.consTele);    //��ϵ�绰
		$('#consIden').val(resobj.consIdenDesc);    //��ѯ���
		$('#consType').val(resobj.quesTypeDesc);    //��������
		$('#consDate').val(resobj.consDate);    //��ѯ����
		$('#consDesc').text(resobj.consDesc);   //��ѯ����
	});
	
	///��ѯ����ϸ
	$('#conBakDetList').datagrid({
		url:url + "?action=QueryConsultBakDet",	
		queryParams:{
			consultID:consultID}
	});
}

 /**
  * ������ѯ����
  */
function saveConsultDetail(){
	
	var consDetDesc = $('#consDetDesc').val();  ///��������
	if (consDetDesc == "������������Ϣ..."){
		showMsgAlert("","������Ϣ����Ϊ�գ�");
		return;
	}	
	if($('#consDetDesc').val().length>800){
		showMsgAlert("","������Ϣ���ܳ���800�֣�");
		return;
		}
	var lkConsultID = "";
	var conDataList = LgUserID +"^"+ consDetDesc +"^"+ lkConsultID;
	var rows = parent.$("#conDetList").datagrid('getSelections');  //nisijia 2016-09-30
	var rowvalue=rows[0].finiFlag;
	var newAnsCount=rows[0].ansCount;	// qunianpeng 2016/10/31
	if (rowvalue=="Y"){
		showMsgAlert("","����ɵļ�¼�������ٻظ���");
		clearConsultDetail();
		return;		
		}
	
	//��������
	$.post(url+'?action=saveConsultDDetail',{"consultID":consultID,"conDataList":conDataList},function(jsonString){
		
		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			$('#conBakDetList').datagrid('reload'); //���¼���
			clearConsultDetail();
			showMsgAlert("","����ɹ���");
			parent.$('#conDetList').datagrid('updateRow',{	//qunianpeng 2016/10/31 ��̬ˢ��һ��
				index: rowIndex,	 
				row: {
					ansCount:newAnsCount*1+1	//ת������
				}
			});

		//	parent.queryConsultDetail();  //nisijia 2016-09-29 //ע�� by qunianpeng 2016/10/31
		}else{
			$.messager.alert("��ʾ:","�ύʧ��,����ԭ��"+jsonConsObj.ErrorMessage);
		}
	});
}

/// �������
function clearConsultDetail(){
	$('#consDetDesc').val("������������Ϣ...");  ///��������
}

/// ��Ϣ��ʾ����
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("��ʾ:","<font >" + ErrMsg + "</font><font style='color:red;'>" + ErrDesc + "</font>");
}


function setMonLevelShow(value,rowData,rowIndex)
{
	var html="";
	if(value != ""){
		html='<p style="line-height:1.2;text-indet:2em;letter-spacimg:3.2;">'+value+'</p>';
	}
	return html;
}

//����
function SetCellUrl(value, rowData, rowIndex)
{
	var html = "";
	if (value == "Y"){
		html = "<span style='margin:0px 5px;font-weight:bold;color:red;'>����</span>";		
	}else{
		html = "<span style='margin:0px 5px;font-weight:bold;color:green;'>No</span>";
		}
    return html;
}

//����
function SetCellOpUrl(value, rowData, rowIndex)
{
	var html = "";
	if (rowData.consDOkFlag != "Y"){
		html = "<a href='#' onclick='adoptConsult("+"\""+rowData.consItmID+"\""+","+"\"Y\""+","+"\""+rowData.consDName+"\""+")' style='margin:0px 5px;text-decoration:none;'>����</a>";
	}else{
		html = "<a href='#' onclick='adoptConsult("+"\""+rowData.consItmID+"\""+","+"\"N\""+","+"\""+rowData.consDName+"\""+")' style='margin:0px 5px;text-decoration:none;'>ȡ������</a>";
		}
    return html;
}

/// ���ò��ɱ�׼���
function adoptConsult(consItmID, consOkFlag,consDName){
	//alert(consDName)
	//alert(LgUserName)
	//��������
	if(LgUserName!=consDName){
		showMsgAlert("","��Ȩ�޸ı��˵�����ȣ�");    //hezg 2018-7-13
		}
		else{
	$.post(url+'?action=saveAdoptConsult',{"consItmID":consItmID, "consOkFlag":consOkFlag},function(jsonString){

		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			if(consOkFlag=="Y"){
			showMsgAlert("","���۳ɹ���");
			$('#conBakDetList').datagrid('reload'); //���¼���
			}
			else{
			showMsgAlert("","ȡ�����ۣ�");
			$('#conBakDetList').datagrid('reload'); //���¼���	
				}
		}else{
			$.messager.alert("��ʾ:","����ʧ��,����ԭ��"+jsonConsObj.ErrorMessage);
		}
	});
		}
}