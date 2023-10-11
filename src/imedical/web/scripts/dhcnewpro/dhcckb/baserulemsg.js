
//===========================================================================================
// Author��      qunianpeng
// Date:		 2020-11-05
// Description:	 ���׹���ܾ������б�
//===========================================================================================

var resultArr = [{"value":"1","text":"��λ��ͬ"},{"value":"2","text":"��ֵ���ų�ͻ"},{"value":"3","text":"��ֵ��λΪ��"},{"value":"4","text":"�Ƕ�ͯ�������"}]
$(function(){ 

	initCombobox();
	initButton();
	initDataList();
		
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
		onSelect:function(ret){
			query();
	 	}
	})	 
	 		
}

///��ʼ����ť
function initButton()
{
	$("#find").bind("click",query);
	$("#reset").bind("click",reset);
	$("#drugName").bind("keypress",query);	

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
			{field:'drugId',title:'drugId',hidden:true},
			{field:'drugName',title:'ҩƷ',width:400,align:'left'},
			{field:'ruleId',title:'�������',width:100,align:'left'},
			{field:'result',title:'�ܾ�����ԭ��',width:300,align:'left'},
			{field:'dataId',title:'�ֵ�id',width:300,align:'left',hidden:true},
			{field:'dataName',title:'�ֵ�',width:300,align:'left'},
			{field:'soulce',title:'������Դ',width:200,align:'left',hidden:true}						
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
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){}, 
		onDblClickRow: function (rowIndex, rowData) {},
        onLoadSuccess:function(data){}			  
	}

	var uniturl = $URL+"?ClassName=web.DHCCKBPrescTest&MethodName=QueryErrBaseRuleMsg&params=";
	new ListComponent('errmsg', columns, uniturl, option).Init();
	
}

///��ѯ
function query()
{
	var params = $HUI.combobox("#result").getValue();
	var drugName = $("#drugName").val();
	params = params +"^"+ drugName;
	$('#errmsg').datagrid('load',{
		params:params
	}); 
	
}

///����
function reset()
{
	$HUI.combobox("#result").setValue("");
	$("#drugName").val("");
	//$HUI.checkbox('#prodrug').uncheck();
	query();
}