/// Creator: 	bianshuai
/// CreateDate: 2016-04-17
/// Descript:	�޸ķ�ҩ

var editRow="";  //��ǰ�༭�к�
var phac = "";   //��ҩ��ID
var url="dhcpha.clinical.action.csp";
var dspScArr = [{"value":"10","text":'����'}, {"value":"20","text":'ȫ��'}];
$(function(){

	phac=getParam("phac");
	
	//��ʼ������Ĭ����Ϣ
	InitDefault();
	
	//��ʼ����ѯ��Ϣ�б�
	InitMainList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
})

///��ʼ������Ĭ����Ϣ
function InitDefault(){
	
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){

	//$("a:contains('��ѯ')").bind("click",queryDispDetail);
}

///ҩƷ��������Ϣ
function InitMainList(){

	// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	//������Ϊ�ɱ༭
	var tdrRanEditor={
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:dspScArr,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#tdrMList").datagrid('getEditor',{index:editRow,field:'dspSCode'});
				$(ed.target).val(option.value);  //���÷�Χ����
				var ed=$("#tdrMList").datagrid('getEditor',{index:editRow,field:'dspSDesc'});
				$(ed.target).combobox('setValue', option.text);  //���÷�Χ����
			}
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:"phac",title:'phac',width:100},
		{field:"operRoomDesc",title:'�����',width:100},
		{field:"inci",title:'inci',width:100},
		{field:"inciDesc",title:'ҩƷ',width:260},
		{field:'dspBatNo',title:'����',width:120,editor:textEditor},
		{field:'dspQty',title:'����',width:100,editor:textEditor},
		{field:'dspUom',title:'��λ',width:100},
		{field:'dspSCode',title:'dspSCode',width:100,hidden:true,editor:textEditor},
		{field:'dspSDesc',title:'�޸ķ�Χ',width:100,editor:tdrRanEditor},
		{field:'dspEdit',title:'�༭',width:100,align:'center',formatter:SetCellOpUrl}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'�޸�����',
		singleSelect : true,
 		onClickRow:function(rowIndex, rowData){
 		},
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) { 
                $("#tdrMList").datagrid('endEdit', editRow); 
            } 
            $("#tdrMList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }
	};
		
	var tdrMainListComponent = new ListComponent('tdrMList', columns, '', option);
	tdrMainListComponent.Init();

	/**
	 * ��ʼ����ʾ���������
	 */
	//initScroll("#tdrMList");
	
	/// ����ҩƷ��ϸ
	 queryDispDetail();
}

/// ��ѯ��ҩ��ϸ
function queryDispDetail(){
	
	$('#tdrMList').datagrid({
		url:url+'?action=QueryDspDetList',
		queryParams:{
			phac : phac}
	});
}

/// �޸ķ�ҩ����
function modDispDetBat(rowIndex){
	
    if ((rowIndex != "")||(rowIndex == "0")) { 
        $("#tdrMList").datagrid('endEdit', rowIndex); 
    } 
    
    var rowData = $('#tdrMList').datagrid('getData').rows[rowIndex];
    var phac = rowData.phac;  		   ///��ҩ��ID
    var inci = rowData.inci;           ///�����ID
    var roomNum = rowData.roomNum;     ///�����
	var dspBatNo = rowData.dspBatNo;   ///����
	var dspQty = rowData.dspQty;       ///����
	var dspSCode = rowData.dspSCode;   ///��Χ
	var param = inci +"^"+ dspBatNo +"^"+ dspQty +"^"+ dspSCode +"^"+ roomNum;

	$.post(url+'?action=modDispDetBat',{"phac":phac, "param":param},function(jsonString){
		var jsonObj = jQuery.parseJSON(jsonString);
		if (jsonObj.ErrorCode == 0){
			$.messager.alert("��ʾ:","�޸ĳɹ���");
			queryDispDetail();
		}else{
			$.messager.alert("��ʾ:","�޸�ʧ��,����ԭ��" + jsonObj.ErrorMessage);
		}
	});
}

/// �༭
function SetCellOpUrl(value, rowData, rowIndex)
{
	var html = "<a href='#' onclick='modDispDetBat("+rowIndex+")'>�޸�����</a>";
    return html;
}
