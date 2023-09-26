$(function(){
	
	$('#druggridss').datagrid({
		width:260,
		url:'',
		//data:{rows:json.product},
		title:'用户列表',
		iconCls:'icon-search',
		striped:true, //斑马效果
		nowrap:false,//是否在一行显示数据
		//fitColumns:true, // 自适应
		//loadMsg:'',
		//rownumbers:true, //显示行号
		singleSelect:true, //只能选中一行
		toolbar:'#tb',
		columns:[[     			  
			{field:'incirowid',title:'Rowid',width:50},
			{field:'incidesc',title:'药品描述',width:160},
			{field:'genericdesc',title:'药品通用名',width:120}
	
		]],
		onDblClickRow:function() { 
    		var selected = $('#druggridss').datagrid('getSelected'); 
    		if (selected){ 
      			//alert(selected.incirowid); 

			} 
		} 
		//pagination: true
		
		//queryParams: {
			//action:'FindResults'
			//input:""
		//}

	});	

	
})