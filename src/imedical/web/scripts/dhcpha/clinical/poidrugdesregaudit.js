
/// �龫ҩƷ���ٵǼ����
var url="dhcpha.clinical.action.csp";
var ddrStatusArray = [{"value":"N","text":'�����'}, {"value":"Y","text":'�����'}];
$(function(){
	
	//��ʼ������Ĭ����Ϣ
	InitDefault();
	
	//��ʼ����ѯ��Ϣ�б�
	InitMainList();
	InitDetList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
})

///��ʼ������Ĭ����Ϣ
function InitDefault(){
	
	/**
	 * ��������
	 */
	$("#ddrStartDate").datebox("setValue", formatDate(0));
	$("#ddrEndDate").datebox("setValue", formatDate(0));
	
	/**
	 * ���ٿƱ�
	 */
	var ddrDeptCombobox = new ListCombobox("ddrDept",url+'?action=QueryConDept','');
	ddrDeptCombobox.init();
	
	//$("#ddrDept").combobox("setValue",LgCtLocID);
	
	/**
	 * ������Ա
	 */
	var ddrUserCombobox = new ListCombobox("ddrUser",url+'?action=SelUserByGrp&grpId=1','',{panelHeight:"auto"});
	ddrUserCombobox.init();
	
		
	/**
	 * ���״̬
	 */
	var ddrChkStatusCombobox = new ListCombobox("ddrChkStatus",'',ddrStatusArray,{panelHeight:"auto"});
	ddrChkStatusCombobox.init();
	
	$("#ddrChkStatus").combobox("setValue","N");
	
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){

	$("a:contains('���')").bind("click",audit);
	$("a:contains('��ѯ')").bind("click",query);
}

///ҩƷ��������Ϣ
function InitMainList(){
	/**
	 * ����columns
	 */
	var columns=[[
		{field:"ddrNo",title:'���ٵ���',width:120},
		{field:"ddrCDate",title:'����',width:100},
		{field:"ddrCTime",title:'ʱ��',width:100},
		{field:'ddrDept',title:'���ٿ���',width:160},
		{field:'ddrUser',title:'������',width:100},
		{field:'ddrDesWayDesc',title:'���ٷ�ʽ',width:100},
		{field:'ddrComFlag',title:'�Ƿ����',width:80,align:'center'},
		{field:'ddrChkFlag',title:'�Ƿ�˶�',width:80,align:'center'},
		{field:'ddrChkDate',title:'�˶�����',width:100},
		{field:'ddrChkTime',title:'�˶�ʱ��',width:100},
		{field:'ddrChkUsr',title:'�˶���',width:100},
		{field:'ddrID',title:'ddrID',width:80,hidden:true}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'���ٵ���',
		singleSelect : true,
 		onClickRow:function(rowIndex, rowData){
	 		
	 		$('#ddrDetList').datagrid({
				url:url+'?action=QueryDesRegNoDetList',
				queryParams:{
					ddrID : rowData.ddrID}
			});
        },
		onLoadSuccess:function(data){
			var rows = $("#ddrMainList").datagrid('getRows');
			if (rows.length != "0"){
				$('#ddrMainList').datagrid('selectRow',0);
				var rowData = $('#ddrMainList').datagrid('getSelected');
				$('#ddrDetList').datagrid({
					url:url+'?action=QueryDesRegNoDetList',
					queryParams:{
						ddrID : rowData.ddrID}
				});
			}
		} 
	};
		
	var ddrMainListComponent = new ListComponent('ddrMainList', columns, '', option);
	ddrMainListComponent.Init();

	/**
	 * ��ʼ����ʾ���������
	 */
	//initScroll("#ddrMainList");	
}

///��ʼ�������ϸ
function InitDetList(){
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ddrInciCode',title:'����',width:100},
		{field:'ddrInciDesc',title:'ҩƷ����',width:260},
		{field:'ddrSpec',title:'���',width:120},
		{field:'ddrManf',title:'����',width:200},
		{field:'ddrBatNo',title:'����',width:120},
		{field:'ddrExpDate',title:'Ч��',width:145},
		{field:'ddrQty',title:'��������',width:120},
		{field:'ddrUom',title:'��λ',width:120}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'������ϸ',
		//nowrap:false,
		singleSelect : true
	};
		
	var ddrDetListComponent = new ListComponent('ddrDetList', columns, '', option);
	ddrDetListComponent.Init();

	/**
	 * ��ʼ����ʾ���������
	 */
	//initScroll("#ddrDetList");
}

/// ��ѯҩƷ������ϸ
function query(){
	
	//1�����datagrid 
	$('#ddrMainList').datagrid('loadData', {total:0,rows:[]}); 
	$('#ddrDetList').datagrid('loadData', {total:0,rows:[]}); 

	//2����ѯ
	var ddrStartDate = $('#ddrStartDate').datebox('getValue');   //��ʼ����
	var ddrEndDate = $('#ddrEndDate').datebox('getValue'); 	     //��ֹ����
	var ddrDept = $('#ddrDept').combobox('getValue');         	 //���ٿ���
	var ddrUser = $('#ddrUser').combobox('getValue');  	 		 //������Ա
	var ddrChkStatus = $('#ddrChkStatus').combobox('getValue');  	 //���״̬

	var ListData = ddrStartDate + "^" + ddrEndDate + "^" + ddrDept + "^" + ddrUser +"^"+ ddrChkStatus;

	$('#ddrMainList').datagrid({
		url:url+'?action=QueryDesRegNoList',
		queryParams:{
			param : ListData}
	});
}

/// ���ҩƷ������ϸ
function audit(){
	
	var rowData = $("#ddrMainList").datagrid('getSelected'); //ѡ����
	//��������
	$.post(url+'?action=SetDesRegChkFlag',{"ddrID":rowData.ddrID, "ddrUserID":LgUserID},function(jsonString){
		var jsonddrObj = jQuery.parseJSON(jsonString);
		if (jsonddrObj.ErrorCode == "0"){
			$.messager.alert("��ʾ:","<font style='font-size:20px;'>��˳ɹ���</font>");
			$('#ddrMainList').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ:","<font style='font-size:20px;'>��˴���,����ԭ��:</font><font style='font-size:20px;color:red;'>"+jsonddrObj.ErrorMessage+"</font>");
			return;
		}
	});
}