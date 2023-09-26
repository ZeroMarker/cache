///creator :QQA
///creatDate:2017-03-21

function init (){
	initTable();
	
	reloadTable();
}

function initTable (){
	$('#attachtable').dhccTable({
		    height:300,
	        url:'dhcapp.broker.csp?ClassName=web.DHCNurCom&MethodName=FindOrditemAttach&IsQuery=Y',
	        singleSelect:true,
	        columns:[
			{field: 'admDeptDesc',title: '�������'},
			{field: 'orcatDesc',title: 'ҽ������'},
			{field: 'arcimDesc',title: 'ҽ������'}, 
			{field: 'phOrdQtyUnit',title: '����'},
			{field: 'price',title: '����'},
			{field: 'totalAmount',title: '�ܼ�'},
			{field: 'ctcpDesc',title: '��ҽ����'},
			{field: 'reclocDesc',title: '���տ���'},
			{field: 'createDateTime',title: '��ҽ��ʱ��'},
			{field: 'sttDateTime',title: 'Ҫ��ִ��ʱ��'},
			{field: 'ordStatDesc',title: 'ҽ��״̬'},
			{field: 'phcduDesc1',title: '�Ƴ�'},
			{field: 'oeoriId',title: 'oeoriId'},
			{field: 'disposeStatCode',title: 'disposeStatCode'}
			]
	    });	
}


function reloadTable(){
	$('#attachtable').dhccQuery(
		{query:
			{regNo:$('#regNo').val(),
			 userId:LgUserID,
			 startDate:$('#startDate').val(),
			 endDate:$('#endDate').val(),
			 admType:"OE",
		  	 DetailFlag:"on",
		  	 ordId:$('#oreId').val(),
		  	 queryTypeCode: $("#queryTypeCode").val()
		  	}
		})
}

window.onload = init