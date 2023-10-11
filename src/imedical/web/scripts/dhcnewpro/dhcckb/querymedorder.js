//querymedorder.js
//ҩ������ѯ

var library = "";

$(function(){	
	initDateBox();
	initDatagrid();
	initBtn();
})

///��ʼ���¼��ؼ�
function initDateBox(){
	$HUI.datebox("#stdate").setValue(formatDate(0));
	$HUI.datebox("#eddate").setValue(formatDate(0));
}

//��ʼ�����
function initDatagrid(){
	var stdate = $("#stdate").datebox("getValue");
	var eddate = $("#eddate").datebox("getValue");
	$("#datagrid").datagrid({
		nowrap:false,
		border:true,
		rownumbers:true,
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCCKBMedicationOrder&MethodName=listMedOrder',
		queryParams:{
			'params':stdate+"^"+eddate,
			},
		//fitColumns:true,
		singleSelect:true,
		pagination:true,
		pageSize:20,
		pageList:[20,40,100]	
	})
}

//��ʼ����ť
function initBtn(){
	$("#searchBTN").click(function(){
		search();	
	});
}

//����ѯ
function search(){
	var stdate = $("#stdate").datebox("getValue");
	var eddate = $("#eddate").datebox("getValue");
	var patname= $("#patname").val()
	var params = stdate+"^"+eddate+"^"+ patname
	$('#datagrid').datagrid('load',{
			'params':params,
	});
}
function setCellEditSymbol(value, rowData, rowIndex){	

	return "<a href='#' onclick=\"showEditWin('"+rowData.ID+"','"+rowData.Language+"')\"><img src='../scripts/dhcadvEvt/images/adv_sel_8.png' border=0/></a>";
	
	}

function showEditWin(ID,Language){
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'ҩ�����༭',
		collapsible:true,
		border:false,
		closed:"true",
		maximized:true,
		width:screen.availWidth-100,    ///2017-11-23  cy  �޸ĵ��������С 1250
		height:screen.availHeight-100
	});
	if (Language=="EN"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcckb.medicationorderEN.csp?medOrderID='+ID+'&hideFlag=1"></iframe>';
	}else{
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcckb.medicationordernew.csp?medOrderID='+ID+'&hideFlag=1"></iframe>';

	}
	$('#win').html(iframe);
	$('#win').window('open');

	}



