
/**
 *	����ҩƷ����һ�ྫ��ҩƷ���յǼ�
 */
var url="dhcpha.clinical.action.csp";
$(function(){
	
	//��ʼ������Ĭ����Ϣ
	InitUIDefault();
	
	//��ʼ����ѯ��Ϣ�б�
	InitDetList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
})

///��ʼ������Ĭ����Ϣ
function InitUIDefault(){

	/**
	 * ��ʼ����ֹ����
	 */
	$("#startDate").datebox("setValue", formatDate(0));
	$("#endDate").datebox("setValue", formatDate(0));

	/**
	 * �����Ʊ�
	 */
	var srInDeptCombobox = new ListCombobox("srInDept",url+'?action=QueryConDept','');
	srInDeptCombobox.init();
	//$("#srInDept").combobox("setValue",LgCtLocID);
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){

	$("a:contains('��ѯ')").bind("click",findPoiExaReg);
	$("a:contains('����')").bind("click",expPoiExaReg);
	$("a:contains('��ӡ')").bind("click",prtPoiExaReg);
	$("#srInciDesc").bind("keydown",function(event){
        if(event.keyCode == "13"){
			if ($("#srInciDesc").val() == ""){return;}
			var mydiv = new UIDivWindow($("#srInciDesc"), $("#srInciDesc").val(), setCurrEditCellVal);
            mydiv.init();
        }
    });
}

/// ����ǰ�༭����ֵ
function setCurrEditCellVal(rowObj){
	
	if (rowObj == null){
		$("#srInciDesc").focus().select();  ///���ý��� ��ѡ������
		return;
	}
	///ҩƷ����	
	$("#srInciDesc").val(rowObj.InciDesc);
	///ҩƷ����ID	
	$("#srInci").val(rowObj.InciDr);
}

///��ʼ�������б�
function InitDetList(){

	/**
	 * ����columns
	 */
	var columns=[[
		{field:'srIngrDate',title:'����',width:100},
		{field:'srInciDesc',title:'ҩƷ����',width:220},
		{field:'srForm',title:'����',width:80},
		{field:'srSpec',title:'���',width:80},
		{field:'srCertNo',title:'ƾ֤��',width:100},
		{field:'srVendor',title:'������λ/���ò���',width:320},
		{field:'srUomDesc',title:'��λ',width:80},
		{field:'srInQty',title:'��������',width:80},
		{field:'srOutQty',title:'��������',width:80},
		{field:'srResQty',title:'��������(������λ)',width:120},
		{field:'srBatNo',title:'����',width:100},
		{field:'srExpDate',title:'��Ч��',width:100},
		{field:'srManf',title:'������ҵ',width:120},
		{field:'srSendFlag',title:'��ҩ��',width:100},
		{field:'srExaUsr',title:'������',width:100},
		{field:'srIngUsr',title:'������',width:100}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'��ϸ',
		//nowrap:false,
		singleSelect : true
	};
		
	var srDetListComponent = new ListComponent('srDetList', columns, '', option);
	srDetListComponent.Init();

	initScroll("#srDetList");//��ʼ����ʾ���������
}

///  �������յ���
function findPoiExaReg(){
	
	//1�����datagrid 
	$('#srDetList').datagrid('loadData', {total:0,rows:[]}); 

	//2����ѯ
	var srStartDate = $('#startDate').datebox('getValue');   //��ʼ����
	var srEndDate = $('#endDate').datebox('getValue'); 	     //��ֹ����
	var srInDept = $('#srInDept').combobox('getValue');      //������
	if (srInDept == ""){
		$.messager.alert("��ʾ:","��ѯʧ�ܣ�ԭ��"+"����ѡ����ⲿ�ţ�");
	}
	var srInci = $('#srInci').val();  	 					 //ҩƷID

	var ListData = srStartDate + "^" + srEndDate + "^" + srInDept + "^" + srInci;

	$('#srDetList').datagrid({
		url:url+'?action=jsonpoidruginoutloc',
		queryParams:{
			param : ListData}
	});
}
function expPoiExaReg(){

gridSaveAsExcel(datagrid);
}

/*
/// �������յ���
function expPoiExaReg(){

	//2����ѯ
	var srStartDate = $('#startDate').datebox('getValue');   //��ʼ����
	var srEndDate = $('#endDate').datebox('getValue'); 	     //��ֹ����
	var srInDept = $('#srInDept').combobox('getValue');      //������
	if (srInDept == ""){
	
		$.messager.alert("��ʾ:","����ʧ�ܣ�ԭ��"+"����ѡ����ⲿ�ţ�");
	}
	var srInci = $('#srInci').val();  	 					 //ҩƷID

    fileName="DHCST_INGd_YKExport.raq&StartDate="+srStartDate+"&EndDate="+srEndDate+"&LocID="+srInDept+"&Inci="+srInci;
	DHCCPM_RQPrint(fileName);
	
}
*/
/// ��ӡ���յ���
function prtPoiExaReg(){
	$(".my_show").jqprint(findPoiExaReg()); 
	
    //fileName="DHCST_INGd_YKExport.raq&StartDate="+srStartDate+"&EndDate="+srEndDate+"&LocID="+srInDept+"&Inci="+srInci;
	//DHCCPM_RQPrint(fileName);

}