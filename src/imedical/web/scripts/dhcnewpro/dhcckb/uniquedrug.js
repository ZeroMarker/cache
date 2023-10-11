
//===========================================================================================
// Author��      qunianpeng
// Date:		 2021-02-20
// Description:	 ҩƷȥ��
//===========================================================================================

var resultArr = [{"value":"general","text":"������ͨ����ƥ��"},{"value":"generalForm","text":"������ͨ����+��Ч��λƥ��"}] 
$(function(){ 
		initDataList();
	initCombobox();
	initButton();

		
})

///��ʼ��combobox
function initCombobox()
{
	//var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
	$HUI.combobox("#result",{
		//url:uniturl,
		valueField:'value',
		textField:'text',
		panelHeight:"160",
		mode:'remote',
		data:resultArr,
		onSelect:function(){
			query();
	 	},
	 	onLoadSuccess:function () {
		 	var data =  $('#result').combobox('getData');//��ȡ��������������
            if (data.length > 0) {
             	$('#result').combobox('select',data[1].value);	//��������ݵĻ�Ĭ��ѡ�е�һ������
            }
        }	 
	})	 

}

///��ʼ����ť
function initButton()
{
	$("#find").bind("click",query);
	$("#reset").bind("click",reset);
}

///ҩƷ�б�
function initDataList(){
	
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}

	// ����columns
	var columns=[[   	 
			{field:'id',title:'drugId',hidden:true},
			{field:'code',title:'ҩƷ����',width:200,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }},
			{field:'desc',title:'��������',width:300,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }},
			{field:'linkDrug',title:'����ҩƷ',width:300,align:'left',hidden:true},	
			{field:'form',title:'����',width:100,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }},
			{field:'generalName',title:'������ͨ����',width:150,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }},
			{field:'spec',title:'���',width:100,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }},
			{field:'eqUnit',title:'��Ч��λ',width:150,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }},
			{field:'ruleFlag',title:'��ʵ',width:100,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }},	
			{field:'hospList',title:'ҽԺ',width:100,align:'left'},			
			{field:'parref',title:'�ֵ�',width:100,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }}
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		remoteSort:false,
		//sortName:"desc",
		sortOrder : 'desc',
		pageSize:100,
		pageList:[100,200,300],		
 		onClickRow:function(rowIndex,rowData){}, 
		onDblClickRow: function (rowIndex, rowData) {},
        onLoadSuccess:function(data){}			  
	}

	var uniturl = $URL+"?ClassName=web.DHCCKBUniqueDrug&MethodName=QueryUniqueAllDrug&type=generalForm";
	//var uniturl = $URL+"?ClassName=web.DHCCKBUniqueDrug&MethodName=UniqueAllDrug&type=generalForm"; 
	new ListComponent('druglist', columns, uniturl, option).Init();
	
}

///��ѯ
function query()
{
	var queryType = $HUI.combobox("#result").getValue();
	$('#druglist').datagrid('load',{
		type:queryType
	}); 
	
}

///����
function reset()
{
	$HUI.combobox("#result").setValue("") ;
	//$HUI.checkbox('#prodrug').uncheck();
	query();
}