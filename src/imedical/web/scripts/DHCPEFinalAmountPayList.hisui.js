
//名称	DHCPEFinalAmountPayList.hisui.js
//功能	实际金额对应支付方式
//创建	2019.06.26
//创建人  xy

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

		    {field:'FAP_PayMode',width:'200',title:'支付方式'},
			{field:'FAP_Amount',width:'200',title:'金额',align:'right',},			
		]],
		
		
			
	})

}