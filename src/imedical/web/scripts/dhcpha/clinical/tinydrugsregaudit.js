
var url="dhcpha.clinical.action.csp";
var tdrStatusArray = [{"value":"N","text":'�����'}, {"value":"Y","text":'�����'}];
$(function(){
	
	//��ʼ������Ĭ����Ϣ
	InitTinyDrugRegDefault();
	
	//��ʼ����ѯ��Ϣ�б�
	InitTinyDrugRegMainList();
	InitTinyDrugRegDetList();
	
	//��ʼ�����水ť�¼�
	InitTinyWidgetListener();
})

///��ʼ������Ĭ����Ϣ
function InitTinyDrugRegDefault(){
	
	/**
	 * ��������
	 */
	$("#tdrStartDate").datebox("setValue", formatDate(0));
	$("#tdrEndDate").datebox("setValue", formatDate(0));
	
	/**
	 * ����Ʊ�
	 */
	var tdrDeptCombobox = new ListCombobox("tdrDept",url+'?action=QueryConDept','');
	tdrDeptCombobox.init();
	
	$("#tdrDept").combobox("setValue",LgCtLocID);
	
	/**
	 * ������Ա
	 */
	var tdrUserCombobox = new ListCombobox("tdrUser",url+'?action=GetDeptUser&LgLocID='+LgCtLocID,'',{});
	tdrUserCombobox.init();
	
		
	/**
	 * ���״̬
	 */
	var tdrChkStatusCombobox = new ListCombobox("tdrChkStatus",'',tdrStatusArray,{panelHeight:"auto"});
	tdrChkStatusCombobox.init();
	
	$("#tdrChkStatus").combobox("setValue","N");
	
}

/// ����Ԫ�ؼ����¼�
function InitTinyWidgetListener(){

	$("a:contains('���')").bind("click",anditTinyDrugsRegDet);
	$("a:contains('��ѯ')").bind("click",queryTinyDrugsRegDet);
	$("#tdrInciDesc").bind("keydown",function(event){
        if(event.keyCode == "13"){
			if ($("#tdrInciDesc").val() == ""){return;}
			var mydiv = new UIDivWindow($("#tdrInciDesc"), $("#tdrInciDesc").val(), setCurrEditCellVal);
            mydiv.init();
        }
    });
}
/// ����ǰ�༭����ֵ
function setCurrEditCellVal(rowObj){
	
	if (rowObj == null){
		$("#tdrInciDesc").focus().select();  ///���ý��� ��ѡ������
		return;
	}
	///ҩƷ����	
	$("#tdrInciDesc").val(rowObj.InciDesc);
	///ҩƷ����ID	
	$("#tdrInci").val(rowObj.InciDr);
}
///ҩƷ��������Ϣ
function InitTinyDrugRegMainList(){
	/**
	 * ����columns
	 */
	var columns=[[
		{field:"tdrNo",title:'���㵥��',width:120},
		{field:"tdrCDate",title:'����',width:100},
		{field:"tdrCTime",title:'ʱ��',width:100},
		{field:'tdrDept',title:'�������',width:160},
		{field:'tdrUser',title:'������',width:100},
		{field:'tdrPurDesc',title:'����Ŀ��',width:100},
		{field:'tdrComFlag',title:'�Ƿ����',width:80,align:'center'},
		{field:'tdrChkFlag',title:'�Ƿ�˶�',width:80,align:'center'},
		{field:'tdrChkDate',title:'�˶�����',width:100},
		{field:'tdrChkTime',title:'�˶�ʱ��',width:100},
		{field:'tdrChkUsr',title:'�˶���',width:100},
		{field:'tdrID',title:'tdrID',width:80,hidden:true}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'���㵥��',
		singleSelect : true,
 		onClickRow:function(rowIndex, rowData){
	 		
	 		$('#tdrDetList').datagrid({
				url:url+'?action=QueryTdrNoDetList',
				queryParams:{
					tdrID : rowData.tdrID}
			});
        },
		onLoadSuccess:function(data){
			var rows = $("#tdrMainList").datagrid('getRows');
			if (rows.length != "0"){
				$('#tdrMainList').datagrid('selectRow',0);
				var rowData = $('#tdrMainList').datagrid('getSelected');
				$('#tdrDetList').datagrid({
					url:url+'?action=QueryTdrNoDetList',
					queryParams:{
						tdrID : rowData.tdrID}
				});
			}
		} 
	};
		
	var tdrMainListComponent = new ListComponent('tdrMainList', columns, '', option);
	tdrMainListComponent.Init();

	/**
	 * ��ʼ����ʾ���������
	 */
	//initScroll("#tdrMainList");	
}

///��ʼ�������ϸ
function InitTinyDrugRegDetList(){
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'tdrInciCode',title:'����',width:100},
		{field:'tdrInciDesc',title:'ҩƷ����',width:260},
		{field:'tdrSpec',title:'���',width:120},
		{field:'tdrManf',title:'����',width:200},
		{field:'tdrBatNo',title:'����',width:120},
		{field:'tdrExpDate',title:'Ч��',width:145},
		{field:'tdrQty',title:'��������',width:120},
		{field:'tdrMacSitNum',title:'ҩλ��',width:100},
		{field:'tdrUom',title:'��λ',width:120}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'������ϸ',
		//nowrap:false,
		singleSelect : true
	};
		
	var tdrDetListComponent = new ListComponent('tdrDetList', columns, '', option);
	tdrDetListComponent.Init();

	/**
	 * ��ʼ����ʾ���������
	 */
	//initScroll("#tdrDetList");
}

/// ��ѯҩƷ������ϸ
function queryTinyDrugsRegDet(){
	
	//1�����datagrid 
	$('#tdrMainList').datagrid('loadData', {total:0,rows:[]}); 
	$('#tdrDetList').datagrid('loadData', {total:0,rows:[]}); 

	//2����ѯ
	var tdrStartDate = $('#tdrStartDate').datebox('getValue');   //��ʼ����
	var tdrEndDate = $('#tdrEndDate').datebox('getValue'); 	     //��ֹ����
	var tdrDept = $('#tdrDept').combobox('getValue');         	 //�������
	var tdrUser = $('#tdrUser').combobox('getValue');  	 		 //������Ա
	var tdrChkStatus = $('#tdrChkStatus').combobox('getValue');  	 //���״̬
    var Incidr = $('#tdrInci').val();                                //ҩƷID
	var ListData = tdrStartDate + "^" + tdrEndDate + "^" + tdrDept + "^" + tdrUser +"^"+ tdrChkStatus+"^"+Incidr;

	$('#tdrMainList').datagrid({
		url:url+'?action=QueryTdrNo',
		queryParams:{
			param : ListData}
	});
}

/// ���ҩƷ������ϸ
function anditTinyDrugsRegDet(){
	
	var rowData = $("#tdrMainList").datagrid('getSelected'); //ѡ����
	//��������
	$.post(url+'?action=SetTindyChkFlag',{"tdrID":rowData.tdrID, "tdrUserID":LgUserID},function(jsonString){
		var jsonTdrObj = jQuery.parseJSON(jsonString);
		if (jsonTdrObj.ErrorCode == "0"){
			$.messager.alert("��ʾ:","<font style='font-size:20px;'>��˳ɹ���</font>");
			$('#tdrMainList').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ:","<font style='font-size:20px;'>��˴���,����ԭ��:</font><font style='font-size:20px;color:red;'>"+jsonTdrObj.ErrorMessage+"</font>");
			return;
		}
	});
}