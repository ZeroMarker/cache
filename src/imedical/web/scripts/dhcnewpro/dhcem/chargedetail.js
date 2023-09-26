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
			{field: 'admDeptDesc',title: '就诊科室'},
			{field: 'orcatDesc',title: '医嘱大类'},
			{field: 'arcimDesc',title: '医嘱名称'}, 
			{field: 'phOrdQtyUnit',title: '总量'},
			{field: 'price',title: '单价'},
			{field: 'totalAmount',title: '总价'},
			{field: 'ctcpDesc',title: '开医嘱人'},
			{field: 'reclocDesc',title: '接收科室'},
			{field: 'createDateTime',title: '开医嘱时间'},
			{field: 'sttDateTime',title: '要求执行时间'},
			{field: 'ordStatDesc',title: '医嘱状态'},
			{field: 'phcduDesc1',title: '疗程'},
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