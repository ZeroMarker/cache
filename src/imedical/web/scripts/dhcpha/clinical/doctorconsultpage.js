$(function(){
	
	$('#druggridss').datagrid({
		width:260,
		url:'',
		//data:{rows:json.product},
		title:'�û��б�',
		iconCls:'icon-search',
		striped:true, //����Ч��
		nowrap:false,//�Ƿ���һ����ʾ����
		//fitColumns:true, // ����Ӧ
		//loadMsg:'',
		//rownumbers:true, //��ʾ�к�
		singleSelect:true, //ֻ��ѡ��һ��
		toolbar:'#tb',
		columns:[[     			  
			{field:'incirowid',title:'Rowid',width:50},
			{field:'incidesc',title:'ҩƷ����',width:160},
			{field:'genericdesc',title:'ҩƷͨ����',width:120}
	
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