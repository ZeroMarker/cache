
//����	DHCPENotice.hisui.js
//����	��쵽�����Ѳ�ѯ
//����	2021.07.27
//������  sunxintao

$(function(){
			
	InitCombobox();
	
	InitCheckProgressGrid();  
     
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });  
})

//��ѯ
function BFind_click(){
	
	$("#NoticeGrid").datagrid('load',{
		ClassName:"web.DHCPE.Notice",
		QueryName:"Notice",
		NoticeType:getValueById("NoticeType"),
		Days:getValueById("Days"),
		Limits:getValueById("Limits")
	});
}




function InitCheckProgressGrid(){
	
		$HUI.datagrid("#NoticeGrid",{
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
		singleSelect: false,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Notice",
			QueryName:"Notice",

		},
		columns:[[
			
			{field:'TRegNo',width:250,title:'�ǼǺ�'},
			{field:'TName',width:250,title:'����'},
			{field:'PAPMISex',width:250,title:'�Ա�'},
			{field:'TAge',width:250,title:'����'},
			{field:'DateDesc',width:250,title:'��������'},
			{field:'GADMDRName',width:250,title:'����'}
		
		]]
			
	})	
}



function InitCombobox(){
	
	//��ѯ����
	var Typeobj = $HUI.combobox("#NoticeType",{
		valueField:'id',
		textField:'text',
		panelHeight:'130',
		data:[
            {id:'1',text:$g('����N��δ�ܼ�')},
            {id:'2',text:$g('�����ӡN��δ��ȡ')},
            {id:'3',text:$g('����N��δ�����ܼ���')}

        ]

	});
	
	//��ѯ��Χ
	var Limitsobj = $HUI.combobox("#NoticeLimits",{
		valueField:'id',
		textField:'text',
		panelHeight:'130',
		data:[
            {id:'0',text:$g('ȫ��')},
            {id:'1',text:$g('1����')}

        ]

	});
	
}