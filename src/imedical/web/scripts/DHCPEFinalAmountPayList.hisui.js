
//����	DHCPEFinalAmountPayList.hisui.js
//����	ʵ�ʽ���Ӧ֧����ʽ
//����	2019.06.26
//������  xy

$(function(){
		
	InitFinalAmountPayListGrid();  
          
})

function InitFinalAmountPayListGrid(){
	$HUI.datagrid("#FinalAmountPayListGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Report.PEPersonStatistic",
			QueryName:"FinalAmountPayList",
			ADMID:ADMID,
		},
		columns:[[

		    {field:'FAP_PayMode',width:'200',title:'֧����ʽ'},
			{field:'FAP_Amount',width:'200',title:'���',align:'right',},			
		]],
		
		
			
	})

}