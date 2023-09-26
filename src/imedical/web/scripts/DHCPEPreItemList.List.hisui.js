
//名称	DHCPEPreItemList.List.hisui.js
//功能	查看预约项目
//创建	2019.06.26
//创建人  xy

$(function(){
		
	InitPreItemListGrid();  
          
})

function InitPreItemListGrid(){
	$HUI.datagrid("#PreItemListGrid",{
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
			ClassName:"web.DHCPE.Query.PreItemList",
			QueryName:"QueryPreItemList",
			AdmId:ADMID,
			AdmType:"PERSON",
			
		},
		columns:[[

		     {field:'ItemDesc',width:350,title:'项目名称'},
			{field:'TAccountAmount',width:150,title:'应收金额',align:'right'},
			{field:'ItemSetDesc',width:200,title:'套餐'}, 
			{field:'TSpecName',width:100,title:'样本'},
			{field:'TAddUser',width:100,title:'操作员'},
			{field:'TPreOrAdd',width:100,title:'项目类别'},
			{field:'TRecLocDesc',width:100,title:'接收科室'}, 
		
		]],
		
		
			
	})

}