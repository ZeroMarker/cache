
//����	DHCPEPreItemList.List.hisui.js
//����	�鿴ԤԼ��Ŀ
//����	2019.06.26
//������  xy

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

		     {field:'ItemDesc',width:350,title:'��Ŀ����'},
			{field:'TAccountAmount',width:150,title:'Ӧ�ս��',align:'right'},
			{field:'ItemSetDesc',width:200,title:'�ײ�'}, 
			{field:'TSpecName',width:100,title:'����'},
			{field:'TAddUser',width:100,title:'����Ա'},
			{field:'TPreOrAdd',width:100,title:'��Ŀ���'},
			{field:'TRecLocDesc',width:100,title:'���տ���'}, 
		
		]],
		
		
			
	})

}